Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9957B3ED3
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 18:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732592AbfIPQXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 12:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbfIPQXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 12:23:06 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B77888BE70
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 16:23:05 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id h6so122059wrh.6
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 09:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DnhcrFhYT0NJ78dPeEqKXN/V1tHyuglzQzoOeMUR4QY=;
        b=TfexS36Y/FkJYPWbRsXxs6vn5x6y3qXz0CzeZLFZhoo9o/ZrthlyH8XFDe80bazCae
         qrv0lCxAC8BhRYpVzWZxyuJ1ivArqAxL1iZAQcymyOi9ALKrfqtL5tHSh5fuOphhckB8
         sqcthbL/DmaTzpFqvtWXT0MZxPjE36g+rQodbTAmP1bUo/OrO37Gw9kv36leiBOhqzMV
         e3L0Rm0D6HLFN6JpFvNVFZ5f11g9ODUZBs+jj2FHJTpG158R4raa6AoNoFQW7fGOfRL5
         +9CODt+U1MclHmq7sANPQ7R4SdEXW/cs7FRsZunopUKpFiDtlS4wkVaeUKqHglw98ESH
         goTg==
X-Gm-Message-State: APjAAAU3njjRKBG9XKHFcCTwAokPC6AM5QwyvIoekqvCczCngTCXrPya
        BcLiFMKbrYf2geRRWAWxUFD7G/htrgl/7HC9GGO6o3QFht5g1kdbrXyxkXO7prYT15OBx+t0H/p
        fKmZv1oV9oATZ
X-Received: by 2002:a1c:2144:: with SMTP id h65mr32645wmh.114.1568650984107;
        Mon, 16 Sep 2019 09:23:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwqBQYTcgo16PkRqlPSOV/k7mPpgorRRib7zPPDxcWoF61Nz7u2WkI+Bq4Zjx3zql/YwldjxQ==
X-Received: by 2002:a1c:2144:: with SMTP id h65mr32612wmh.114.1568650983843;
        Mon, 16 Sep 2019 09:23:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q10sm78370575wrd.39.2019.09.16.09.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 09:23:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH 1/3] cpu/SMT: create and export cpu_smt_possible()
Date:   Mon, 16 Sep 2019 18:22:56 +0200
Message-Id: <20190916162258.6528-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916162258.6528-1-vkuznets@redhat.com>
References: <20190916162258.6528-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM needs to know if SMT is theoretically possible, this means it is
supported and not forcefully disabled ('nosmt=force'). Create and
export cpu_smt_possible() answering this question.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/linux/cpu.h |  2 ++
 kernel/cpu.c        | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index fcb1386bb0d4..6d48fc456d58 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -201,12 +201,14 @@ enum cpuhp_smt_control {
 extern enum cpuhp_smt_control cpu_smt_control;
 extern void cpu_smt_disable(bool force);
 extern void cpu_smt_check_topology(void);
+extern bool cpu_smt_possible(void);
 extern int cpuhp_smt_enable(void);
 extern int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval);
 #else
 # define cpu_smt_control		(CPU_SMT_NOT_IMPLEMENTED)
 static inline void cpu_smt_disable(bool force) { }
 static inline void cpu_smt_check_topology(void) { }
+static inline bool cpu_smt_possible(void) { return false; }
 static inline int cpuhp_smt_enable(void) { return 0; }
 static inline int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval) { return 0; }
 #endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e84c0873559e..2f8c2631e641 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -389,8 +389,7 @@ enum cpuhp_smt_control cpu_smt_control __read_mostly = CPU_SMT_ENABLED;
 
 void __init cpu_smt_disable(bool force)
 {
-	if (cpu_smt_control == CPU_SMT_FORCE_DISABLED ||
-		cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
+	if (!cpu_smt_possible())
 		return;
 
 	if (force) {
@@ -435,6 +434,14 @@ static inline bool cpu_smt_allowed(unsigned int cpu)
 	 */
 	return !per_cpu(cpuhp_state, cpu).booted_once;
 }
+
+/* Returns true if SMT is not supported of forcefully (irreversibly) disabled */
+bool cpu_smt_possible(void)
+{
+	return cpu_smt_control != CPU_SMT_FORCE_DISABLED &&
+		cpu_smt_control != CPU_SMT_NOT_SUPPORTED;
+}
+EXPORT_SYMBOL_GPL(cpu_smt_possible);
 #else
 static inline bool cpu_smt_allowed(unsigned int cpu) { return true; }
 #endif
-- 
2.20.1

