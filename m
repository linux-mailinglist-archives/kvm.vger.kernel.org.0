Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F7161E6E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgBRBMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 20:12:35 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35282 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgBRBMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:12:35 -0500
Received: by mail-pf1-f195.google.com with SMTP id y73so9783977pfg.2;
        Mon, 17 Feb 2020 17:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SzGI6xs2fHTPFP1btrspKrYRFCHYr+qic+EgFU1IfK0=;
        b=ENkDYBLud7go9wvHtB/pF+TIBZ+b1aERO8eipPTrMhsl91IEvDMliQkwOQTGtcH9C4
         Hq597ccPiy6VFwLo1iveUmaoCVhKHt7efRwYXEyp/E1OUiVfoJ3gXVwdV/BEje7qjX6I
         +UW48QJUl6d0Cp+oKzdYa3JPqQKchWknyCSoRk/Sl/YuVNfcjN+73gwsZaCSVRtebpWl
         7UBOaQjLS/i1/E5vdDIxHY4NXIclr5Si9s/+UHQozfpKKVNhZKoDDcQKltZ0cIr03Nxf
         UIc+n8rvgJ7SoxZT3YhlZ03QHTQeNb9Yy2LloRQ3JUCCwp/ZoAc7dCRcrmgNEM+tumKX
         iu+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SzGI6xs2fHTPFP1btrspKrYRFCHYr+qic+EgFU1IfK0=;
        b=dzPq2q/ACMtS/XzqT2Le8KBVjUCvWTmCcH1xqOb6wIQqyS/4iEjX3iaQqiXdV/Sn4+
         lPUunQUmzVmm+1O4mNBdIeDqXAuMFMUxPCWK+RP01OofT8q86+0Du1NzffGaFuBEKjTU
         5JSEKmpRUsxI88ctMvobigCbcGuvZ4y3yAjiC5XOM+/+THK0k5cIGWUNgHudYpjcJOQj
         mIMPo98aGZ+o3mOSAi19RKPrnZO44tkOkjcqaEo11oaDws+jS2fBVytlNyyG3Jr63mne
         RBh1o8k5KBRU6ryhb18ZM2bZdjVa4siKYeSYUOf7TXhcPEXD5pOzJJY39wNBqgaoN97p
         sX6A==
X-Gm-Message-State: APjAAAXXgveONYZjR82z9p1XpnUmF0xrSKsLKKgwgb5rwzdjECWfaNMQ
        Kfpks499xa6EqA4cjJiJdMIVwya7EvjAag==
X-Google-Smtp-Source: APXvYqwbA2WBnXkqnVFAOGAIfekLcWZR9ie/X7qJ37c2i6oBa5pOq5qarBPZ1rQx5VrPFTL0EPz+pA==
X-Received: by 2002:a62:830c:: with SMTP id h12mr19877979pfe.162.1581988354348;
        Mon, 17 Feb 2020 17:12:34 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.205])
        by smtp.googlemail.com with ESMTPSA id x23sm2074774pge.89.2020.02.17.17.12.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Feb 2020 17:12:33 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
Date:   Tue, 18 Feb 2020 09:08:24 +0800
Message-Id: <1581988104-16628-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Nick Desaulniers Reported:

  When building with:
  $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
  The following warning is observed:
  arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
  function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
  vector)
              ^
  Debugging with:
  https://github.com/ClangBuiltLinux/frame-larger-than
  via:
  $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
    kvm_send_ipi_mask_allbutself
  points to the stack allocated `struct cpumask newmask` in
  `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
  potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
  the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
  8192, making a single instance of a `struct cpumask` 1024 B.

This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for 
both pv tlb and pv ipis..

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * remove '!alloc' check
 * use new pv check helpers

 arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 76ea8c4..377b224 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
 		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
+
 #ifdef CONFIG_SMP
 
 static bool pv_ipi_supported(void)
@@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
 static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	unsigned int this_cpu = smp_processor_id();
-	struct cpumask new_mask;
+	struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 	const struct cpumask *local_mask;
 
-	cpumask_copy(&new_mask, mask);
-	cpumask_clear_cpu(this_cpu, &new_mask);
-	local_mask = &new_mask;
+	cpumask_copy(new_mask, mask);
+	cpumask_clear_cpu(this_cpu, new_mask);
+	local_mask = new_mask;
 	__send_ipi_mask(local_mask, vector);
 }
 
@@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
 	update_intr_gate(X86_TRAP_PF, async_page_fault);
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
 
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
@@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	u8 state;
 	int cpu;
 	struct kvm_steal_time *src;
-	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
+	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 
 	cpumask_copy(flushmask, cpumask);
 	/*
@@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
 	if (pv_tlb_flush_supported()) {
 		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
+		pr_info("KVM setup pv remote TLB flush\n");
 	}
 
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
@@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);
 
-static __init int kvm_setup_pv_tlb_flush(void)
+static __init int kvm_alloc_cpumask(void)
 {
 	int cpu;
+	bool alloc = false;
 
 	if (!kvm_para_available() || nopv)
 		return 0;
 
-	if (pv_tlb_flush_supported()) {
+	if (pv_tlb_flush_supported())
+		alloc = true;
+
+#if defined(CONFIG_SMP)
+	if (pv_ipi_supported())
+		alloc = true;
+#endif
+
+	if (alloc)
 		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
+			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
 				GFP_KERNEL, cpu_to_node(cpu));
 		}
-		pr_info("KVM setup pv remote TLB flush\n");
-	}
 
 	return 0;
 }
-arch_initcall(kvm_setup_pv_tlb_flush);
+arch_initcall(kvm_alloc_cpumask);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
-- 
2.7.4

