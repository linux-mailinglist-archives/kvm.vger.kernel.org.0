Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC9A3B23C3
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFWXI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFWXIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:25 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FE2C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:05 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 14-20020a37060e0000b02903aad32851d2so4356081qkg.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9ugzlw7yCqvttuGsYPFF9841OjnqtnS5Arl+jCDe6NI=;
        b=WLvvhmvbbq/Pomzk4a+6iHO6aZLiPMI63QIAbzByGdXZG7scEr1xttoW3fJ2B1jhhs
         p8LEAUJfwBzh9ifDiOogyAkKsxnbJr8ZzxXbv4fpkw8k1pON8H9cKHTMdaiZz/9SitHL
         NaB4cnHmu33ynS6YLB291L5PBlNFVc3x/9nCzr8Dj5E7uKGgmtaThvHeMXb9f4Bw+BR/
         dtE4Z5zQnYFEsv3KFunnK3l4hD9JgJPOBXdaeCxZckC1BRHxtbOmkv06BXtrx6D4ksI6
         DDwhcfeZFCF6HiMV3wKge2EgS38nshhI0XbV+np3uLuUZH/JbZjTX9DbYGiQ3/Gv1ROQ
         49ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9ugzlw7yCqvttuGsYPFF9841OjnqtnS5Arl+jCDe6NI=;
        b=q4bSonbQ/vYBaSY0+vJr5uso9xKqnlf8DnNgXiV0CLAIlD46mX3dd97U5ItV/T2UuH
         fxZMoRfL4qBpQteGOk3g5jPhq1lRBaV/UTCbJBzPDRGnRLCuSTgpvTe/vwMOa5rLmdPS
         KsP0Rb/LwZOJmOb+OGZYAG73hK6DU9x91uAuYOYqB073TyeohFc0XpLymUwschzAe/lz
         d/csn+9RK8JavSY9/zeOAKZP9zW34O0tUKUgeM7wWQS6viZDUGTRbsVpe9ZMttxmVvKu
         C/QaHpECUwWWsmkw7YXPA4MgPt9mXF/ihbnLA3hn70AF/c25YfFj9TdCregXTd/ECapj
         6gbA==
X-Gm-Message-State: AOAM530wEDvYF4C2EbQTmCUXPrRt6WnmR6IKKHtHHQYuz7v80DV9mMp5
        dEelFnmiXBDKAjFZeUxvNTJqkJE7C0M=
X-Google-Smtp-Source: ABdhPJxha8/+D066BvQrLuLO91KgGwWa5GXjlpzOHG7V2UU9DZqKCk6jwt6lncZgWeX4l/F0kNPwVj0CYN8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:ad4:5f0e:: with SMTP id fo14mr2278544qvb.16.1624489564995;
 Wed, 23 Jun 2021 16:06:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:48 -0700
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Message-Id: <20210623230552.4027702-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210623230552.4027702-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 3/7] KVM: x86: Truncate reported guest MAXPHYADDR to C-bit if
 SEV is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enumerate "C-bit - 1" as the MAXPHYADDR for KVM_GET_SUPPORTED_CPUID if
NPT is enabled, SEV is supported in hardware, and the C-bit overlaps
the legal guest physical address space reported by hardware.  I.e.
advertise the C-bit and any PA bits above the C-bit as reserved.
Reuse svm_adjust_mmio_mask()'s C-bit retrieval logic, but
opportunistically switch to the "safe" RDMSR, e.g. the MSR may not be
emulated if KVM is running nested.

AMD's APM is a bit ambiguous as to the behavior of the C-bit for non-SEV
guests running on SEV-capable hardware.  In "15.34.6 Page Table Support",
under "15.34 Secure Encrypted Virtualization", the APM does state that
the guest MAXPHYADDR is not reduced unless the C-bit is stolen from the
legal physical address space:

  Note that because guest physical addresses are always translated
  through the nested page tables, the size of the guest physical address
  space is not impacted by any physical address space reduction indicated
  in CPUID 8000_001F[EBX]. If the C-bit is a physical address bit however,
  the guest physical address space is effectively reduced by 1 bit.

What it doesn't clarify is whether or not that behavior applies to
non-SEV guests, i.e. whether the C-bit is reserved or a legal GPA bit.

Regardless of what the intended behavior is (more on this later), KVM is
broken because it treats the C-bit as ignored for non-SEV.  At first
blush, it would appear the KVM treats the C-bit as a legal GPA bit for
non-SEV guests, but the C-bit is stripped for host _and_ guest PTEs
tables, as PT64_BASE_ADDR_MASK is defined to incorporate the adjusted
physical_mask (CONFIG_DYNAMIC_PHYSICAL_MASK is forced for SME, and the
C-bit is explicitly cleared).

  #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
  #define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
  #else

As a result, KVM reports the full guest MAXPHYADDR even though it
(silently) drops the C-bit.

If the APM's intent is that the C-bit is a GPA bit for non-SEV guests,
then the correct fix would be to split PT64_BASE_ADDR_MASK into host
and guest masks, with the guest mask being dynamic since SEV guests
would still need to drop the C-bit.

But, on AMD EPYC 7B12, a.k.a. Rome, the C-bit is reserved for non-SEV
guests.  E.g. the demand_paging_test selftest hits an unexpected #PF when
running NPT due to using the highest possible GPAs.  A dump of the #PF
and guest page tables (via #PF interception) shows the CPU generates a
reserved #PF, and clearing the C-bit in the test passes.  The same dump
also captures KVM's clearing of the C-bit in its final GPA calulcation.

  SVM: KVM: CPU #PF @ rip = 0x409ca4, cr2 = 0xc0000000, pfec = 0xb
  KVM: guest PTE = 0x181023 @ GPA = 0x180000, level = 4
  KVM: guest PTE = 0x186023 @ GPA = 0x181000, level = 3
  KVM: guest PTE = 0x187023 @ GPA = 0x186000, level = 2
  KVM: guest PTE = 0xffffbffff003 @ GPA = 0x187000, level = 1
  SVM: KVM: GPA = 0x7fffbffff000

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 11 +++++++++++
 arch/x86/kvm/svm/svm.c | 37 +++++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.c     |  3 +++
 arch/x86/kvm/x86.h     |  1 +
 4 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 28878671d648..e05a9eb0dd03 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -955,6 +955,17 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		else if (!g_phys_as)
 			g_phys_as = phys_as;
 
+		/*
+		 * The exception to the exception is if hardware supports SEV,
+		 * in which case the C-bit is reserved for non-SEV guests and
+		 * isn't a GPA bit for SEV guests.
+		 *
+		 * Note, KVM always reports '0' for the number of reduced PA
+		 * bits (see 0x8000001F).
+		 */
+		if (tdp_enabled && sev_c_bit)
+			g_phys_as = min(g_phys_as, (unsigned int)sev_c_bit);
+
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12c06ea28f5c..2549e80abf05 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -860,6 +860,26 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
+static __init u8 svm_get_c_bit(bool sev_only)
+{
+	unsigned int eax, ebx, ecx, edx;
+	u64 msr;
+
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return 0;
+
+	if (rdmsrl_safe(MSR_K8_SYSCFG, &msr) ||
+	    !(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+		return 0;
+
+	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
+
+	if (sev_only && !(eax & feature_bit(SEV)))
+		return 0;
+
+	return ebx & 0x3f;
+}
+
 /*
  * The default MMIO mask is a single bit (excluding the present bit),
  * which could conflict with the memory encryption bit. Check for
@@ -869,18 +889,13 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 static __init void svm_adjust_mmio_mask(void)
 {
 	unsigned int enc_bit, mask_bit;
-	u64 msr, mask;
-
-	/* If there is no memory encryption support, use existing mask */
-	if (cpuid_eax(0x80000000) < 0x8000001f)
-		return;
+	u64 mask;
 
 	/* If memory encryption is not enabled, use existing mask */
-	rdmsrl(MSR_K8_SYSCFG, msr);
-	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+	enc_bit = svm_get_c_bit(false);
+	if (!enc_bit)
 		return;
 
-	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
 	mask_bit = boot_cpu_data.x86_phys_bits;
 
 	/* Increment the mask bit if it is the same as the encryption bit */
@@ -1013,6 +1028,12 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+	/*
+	 * The SEV C-bit location is needed to correctly enumeration guest
+	 * MAXPHYADDR even if SEV is not fully supported.
+	 */
+	sev_c_bit = svm_get_c_bit(true);
+
 	/* Note, SEV setup consumes npt_enabled. */
 	sev_hardware_setup();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76dae88cf524..4479e67e5727 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -223,6 +223,9 @@ EXPORT_SYMBOL_GPL(host_xss);
 u64 __read_mostly supported_xss;
 EXPORT_SYMBOL_GPL(supported_xss);
 
+u8 __read_mostly sev_c_bit;
+EXPORT_SYMBOL_GPL(sev_c_bit);
+
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("pf_fixed", pf_fixed),
 	VCPU_STAT("pf_guest", pf_guest),
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 521f74e5bbf2..a80cc63039c3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -338,6 +338,7 @@ extern u64 host_xcr0;
 extern u64 supported_xcr0;
 extern u64 host_xss;
 extern u64 supported_xss;
+extern u8  sev_c_bit;
 
 static inline bool kvm_mpx_supported(void)
 {
-- 
2.32.0.288.g62a8d224e6-goog

