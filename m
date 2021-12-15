Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46527475B32
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243683AbhLOO5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243647AbhLOO5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 09:57:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7B4C061756;
        Wed, 15 Dec 2021 06:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dJyy0YIZO4tRfWrXqs9ij9LAoxRemS/hxa82XKa0frY=; b=MizMnXSX4dJ7XEVv7ruOg7nDoe
        medssANIG7jEcaYogcNbLBvQTBvgOeEDoPIRkjB6DIZTVh+WVvFCEwKIwbuUX/pkBRppVFl88vu/n
        NkCmgXd4PLSyKS8Hfm+o7aC6A37YFD+NlqLxt8PFXGjrcw75s967L7DKG7hvCYDuhFdX+igkHNM+g
        r/oD68vOo+jrs+Rb+bercpu9009GCSM30D1I/WLqyrZ2PFD3kkAHmpO3MIP968n4nUBn/rH89u4LN
        5R3Qp6jAMjM3Brcply178985qfj+b8RGfYRb2zcZygRS9mAvMAgoMYywm1aznz8wb333C38zm3rxS
        NSqdU9yg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhr-001WOy-OX; Wed, 15 Dec 2021 14:56:35 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhr-0001O8-E3; Wed, 15 Dec 2021 14:56:35 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH v3 8/9] x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
Date:   Wed, 15 Dec 2021 14:56:32 +0000
Message-Id: <20211215145633.5238-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215145633.5238-1-dwmw2@infradead.org>
References: <20211215145633.5238-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There's no need to repeatedly save the BSP's MTRRs for each AP we bring
up at boot time. And there's no need to use smp_call_function_single()
even for the one time we *do* want to do it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/cpu/mtrr/mtrr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 2746cac9d8a9..2884017586f1 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -814,11 +814,20 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
+	static bool mtrr_saved;
 	int first_cpu;
 
 	if (!mtrr_enabled())
 		return;
 
+	if (system_state < SYSTEM_RUNNING) {
+		if (!mtrr_saved) {
+			mtrr_save_fixed_ranges(NULL);
+			mtrr_saved = true;
+		}
+		return;
+	}
+
 	first_cpu = cpumask_first(cpu_online_mask);
 	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
 }
-- 
2.31.1

