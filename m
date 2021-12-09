Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E49A46EAD0
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbhLIPN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239393AbhLIPNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:13:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDA2C0617A1;
        Thu,  9 Dec 2021 07:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=P7jWpzgbT12FCdsjDooidRhIFWcGCOa4zDJtICW8Wok=; b=Qz7lWoMiMKIGzzayfMQiY+lt2z
        09F6tq/3vPTlyyXeNyNdGf+E7qN3d5XFJRACSfoFc14wD8LpyuvDSdc1p6EmYPlRpVzSMZLwxu1Iu
        DRbe0m3efrcRHfRJuy+kOwKLx6tB6VelijuZgYBq7mCJB004gDXUgJb5/8mJkejY8zNOXBphAUvvE
        MT5I4sJmdJaleM5VzQ2RMYi8B467gVFf69PBlTWjoP71DsxBBrQrU+b2plcnqMfIidT/EO5e+OWn4
        QLccjpt8vv/cQ8786Qn9JpPJYRmJ13o9hJPvDTSi6jDnsJy25omSFok0ShJxaGtd00/D0af8Mx3jR
        52LG9JPg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-009Rs8-NW; Thu, 09 Dec 2021 15:09:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-0000yF-V8; Thu, 09 Dec 2021 15:09:45 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH 08/11] x86/tsc: Avoid synchronizing TSCs with multiple CPUs in parallel
Date:   Thu,  9 Dec 2021 15:09:35 +0000
Message-Id: <20211209150938.3518-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209150938.3518-1-dwmw2@infradead.org>
References: <20211209150938.3518-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The TSC sync algorithm is only designed to do a 1:1 sync between the
source and target CPUs.

In order to enable parallel CPU bringup, serialize it by using an
atomic_t containing the number of the target CPU whose turn it is.

In future we should look at inventing a 1:many TSC synchronization
algorithm, perhaps falling back to 1:1 if a warp is observed but
doing them all in parallel for the common case where no adjustment
is needed. Or just avoiding the sync completely for cases like kexec
where we trust that they were in sync already.

This is perfectly sufficient for the short term though, until we get
those further optimisations.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/tsc_sync.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 50a4515fe0ad..4ee247d89a49 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -202,6 +202,7 @@ bool tsc_store_and_check_tsc_adjust(bool bootcpu)
  * Entry/exit counters that make sure that both CPUs
  * run the measurement code at once:
  */
+static atomic_t tsc_sync_cpu = ATOMIC_INIT(-1);
 static atomic_t start_count;
 static atomic_t stop_count;
 static atomic_t skip_test;
@@ -326,6 +327,8 @@ void check_tsc_sync_source(int cpu)
 		atomic_set(&test_runs, 1);
 	else
 		atomic_set(&test_runs, 3);
+
+	atomic_set(&tsc_sync_cpu, cpu);
 retry:
 	/*
 	 * Wait for the target to start or to skip the test:
@@ -407,6 +410,10 @@ void check_tsc_sync_target(void)
 	if (unsynchronized_tsc())
 		return;
 
+	/* Wait for this CPU's turn */
+	while (atomic_read(&tsc_sync_cpu) != cpu)
+		cpu_relax();
+
 	/*
 	 * Store, verify and sanitize the TSC adjust register. If
 	 * successful skip the test.
-- 
2.31.1

