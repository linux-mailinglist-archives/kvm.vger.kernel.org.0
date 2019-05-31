Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1C13089A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfEaGhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:37:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42328 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfEaGhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:37:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id e6so2211094pgd.9;
        Thu, 30 May 2019 23:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bwO8b2099JZadUfRmVcnPa+T8ct2M/drZDJt4vgMUM=;
        b=MQtNKVIIhCsNGCjqQIzlTDvmsNLTK/9jgZ5KiwyzKQ+CswF4q2/19IJevG+dFFgI4U
         rwmuQ2vFWN3d79sUmzNKytZ6vgJJ/wJBpdVA7tT/cqspw9jz8wq4RKfKgaG6rmiIE4wt
         fk0F/nVh9ZGmuaiHINzi7Xks7WbMHEY+XYZjfYC18Tzg8wmgC+Mda7gCOUq/tEJmVKdr
         8HrC8CqJE+xPWyccUlhHvbzW/53V+A0FDubXqb4zDN3B2XGY/b+aS6CUn+AczmruYY9c
         0BgLONg4xBKfAONN1req3WoaVkrsZNbBce4ocypolZGrciJEvlEbtget9OG0gds79Fw1
         Z6Lg==
X-Gm-Message-State: APjAAAUVc2ZvOnt/glQz2gIEPSayX1U6Zu+wON9IUQzofLEUBOzNkFUY
        KnN3ePZ5xqjhKvqGVfFctEY=
X-Google-Smtp-Source: APXvYqy40gpqhsyMdmpCYqEmAgDL9zi8xcQuj4XMXWCp0oVtt6RuVLS2aWlcI95Dz4ODQdS2nlSAPQ==
X-Received: by 2002:a62:1a0f:: with SMTP id a15mr8084310pfa.111.1559284627207;
        Thu, 30 May 2019 23:37:07 -0700 (PDT)
Received: from htb-2n-eng-dhcp405.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id g17sm9256429pfk.55.2019.05.30.23.37.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 23:37:06 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [RFC PATCH v2 06/12] KVM: x86: Provide paravirtualized flush_tlb_multi()
Date:   Thu, 30 May 2019 23:36:39 -0700
Message-Id: <20190531063645.4697-7-namit@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531063645.4697-1-namit@vmware.com>
References: <20190531063645.4697-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support the new interface of flush_tlb_multi, which also flushes the
local CPU's TLB, instead of flush_tlb_others that does not. This
interface is more performant since it parallelize remote and local TLB
flushes.

The actual implementation of flush_tlb_multi() is almost identical to
that of flush_tlb_others().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arch/x86/kernel/kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index c1c2b88ea3f1..86b8267166e6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -593,7 +593,7 @@ static void __init kvm_apf_trap_init(void)
 
 static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
 
-static void kvm_flush_tlb_others(const struct cpumask *cpumask,
+static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
 {
 	u8 state;
@@ -607,6 +607,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	 * queue flush_on_enter for pre-empted vCPUs
 	 */
 	for_each_cpu(cpu, flushmask) {
+		/*
+		 * The local vCPU is never preempted, so we do not explicitly
+		 * skip check for local vCPU - it will never be cleared from
+		 * flushmask.
+		 */
 		src = &per_cpu(steal_time, cpu);
 		state = READ_ONCE(src->preempted);
 		if ((state & KVM_VCPU_PREEMPTED)) {
@@ -616,7 +621,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 		}
 	}
 
-	native_flush_tlb_others(flushmask, info);
+	native_flush_tlb_multi(flushmask, info);
 }
 
 static void __init kvm_guest_init(void)
@@ -641,9 +646,8 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
-		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
+		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
-		static_key_disable(&flush_tlb_multi_enabled.key);
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-- 
2.20.1

