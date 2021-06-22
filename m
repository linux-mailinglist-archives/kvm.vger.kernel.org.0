Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899FE3B0F24
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhFVVDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFVVDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:35 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BA9C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:18 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id u11-20020a05622a010bb029024ec154fa8bso485822qtw.20
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3P8WFMk29fXQiBoRqtWNr/iSF/dXwga8+A/3IePGOxA=;
        b=OX3ruCf78UnEldp7t76FZHDd+qZdy5Cko3Q6aKUZoBg9X1BeibQXj7nTpSCNlJOxq3
         pP6kNtwEIVgdVE07vWx9E0Pof91tlylMsLyJctwDc/KOtGAjJKoLZnWl3bxNYQZ6BIVd
         i/OxLGnM3uT7xZI3wZ2HDLiXkLm4hAW0pV/QiDSRA8ZeOYKyuwpHKMJ6wS5HE5UwkEXE
         qRq7vpLHKQIkoblrHJ59n8rjcB9QvGvD28MXTPi37UteXdVAanWDuSTS2n2I/JKyJEmn
         oIQnK7+SxiXkZ49/lrZHdf2mqV3tXf4slLu9fU64z10ZRh/wRRyAp4Uprq1C8ugBpk4P
         q2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3P8WFMk29fXQiBoRqtWNr/iSF/dXwga8+A/3IePGOxA=;
        b=OYCQ/q3WkHhUBqUvdrGgUu0als+5dGNzqd5BkskdwebPbZpg5d/VBw/AZQbFYQ/6Z2
         9qJsVd3YbR9/kK5D3JBFTvsrVKlRrAm+j8tnBWxO8BxFLtsGy98vESbgTJIEcaLTgWq/
         eqPTO0VnZctrtV8uV/FtyMBj1msF0QoqcEIzeiIXP/3mcLM8UnWIuvm+9WeyYzPyOaDT
         hZ0Hz+AS5TLdjOUsAEy7ViTUPjcx1qo29Aq9esA/6QkcOpkKAMUrGTlzpo7LepcxNnQu
         zxoRJS81/CknPF8yYgPxrVeHlaO15znU8zZ9uvWvmj85CY8ClYi8ZnSqES5ToyptQczg
         Jprw==
X-Gm-Message-State: AOAM532uJRq0ylNIlOEzyk7xbuNwjYtULYKtCPKGHBxPVNdJozpHVANb
        LS6wLKTqIkIPFtODJZq5Pb9EfdvvROI=
X-Google-Smtp-Source: ABdhPJwQXA3eXgNi6syIuW4k1Gl0POPdEboiHOlT/9vywS8670SZmaCI5d0EnMw2cOi3an6RDrNkKsm8kdE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a5b:649:: with SMTP id o9mr4356032ybq.399.1624395677591;
 Tue, 22 Jun 2021 14:01:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:47 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 12/12] nSVM: Add test for NPT reserved bit and
 #NPF error code behavior
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test to verify that KVM generates the correct #NPF and PFEC when
host and guest EFER.NX and CR4.SMEP values diverge, and that KVM
correctly detects reserved bits in the first place.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm.c       |   5 +-
 x86/svm_tests.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 0959189..f185ca0 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -13,6 +13,7 @@
 #include "alloc_page.h"
 #include "isr.h"
 #include "apic.h"
+#include "vmalloc.h"
 
 /* for the nested page table*/
 u64 *pte[2048];
@@ -397,12 +398,14 @@ test_wanted(const char *name, char *filters[], int filter_count)
 
 int main(int ac, char **av)
 {
+	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
+	pteval_t opt_mask = 0;
 	int i = 0;
 
 	ac--;
 	av++;
 
-	setup_vm();
+	__setup_vm(&opt_mask);
 
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
 		printf("SVM not availble\n");
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index fdef620..1aaf983 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2499,6 +2499,148 @@ static void svm_guest_state_test(void)
 	test_vmrun_canonicalization();
 }
 
+static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
+				     ulong cr4, u64 guest_efer, ulong guest_cr4)
+{
+	u64 pxe_orig = *pxe;
+	int exit_reason;
+	u64 pfec;
+
+	wrmsr(MSR_EFER, efer);
+	write_cr4(cr4);
+
+	vmcb->save.efer = guest_efer;
+	vmcb->save.cr4  = guest_cr4;
+
+	*pxe |= rsvd_bits;
+
+	exit_reason = svm_vmrun();
+
+	report(exit_reason == SVM_EXIT_NPF,
+	       "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits, exit_reason);
+
+	if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
+		/*
+		 * The guest's page tables will blow up on a bad PDPE/PML4E,
+		 * before starting the final walk of the guest page.
+		 */
+		pfec = 0x20000000full;
+	} else {
+		/* RSVD #NPF on final walk of guest page. */
+		pfec = 0x10000000dULL;
+
+		/* PFEC.FETCH=1 if NX=1 *or* SMEP=1. */
+		if ((cr4 & X86_CR4_SMEP) || (efer & EFER_NX))
+			pfec |= 0x10;
+
+	}
+
+	report(vmcb->control.exit_info_1 == pfec,
+	       "Wanted PFEC = 0x%lx, got PFEC = %lx, PxE = 0x%lx.  "
+	       "host.NX = %u, host.SMEP = %u, guest.NX = %u, guest.SMEP = %u",
+	       pfec, vmcb->control.exit_info_1, *pxe,
+	       !!(efer & EFER_NX), !!(cr4 & X86_CR4_SMEP),
+	       !!(guest_efer & EFER_NX), !!(guest_cr4 & X86_CR4_SMEP));
+
+	*pxe = pxe_orig;
+}
+
+static void _svm_npt_rsvd_bits_test(u64 *pxe, u64 pxe_rsvd_bits,  u64 efer,
+				    ulong cr4, u64 guest_efer, ulong guest_cr4)
+{
+	u64 rsvd_bits;
+	int i;
+
+	/*
+	 * Test all combinations of guest/host EFER.NX and CR4.SMEP.  If host
+	 * EFER.NX=0, use NX as the reserved bit, otherwise use the passed in
+	 * @pxe_rsvd_bits.
+	 */
+	for (i = 0; i < 16; i++) {
+		if (i & 1) {
+			rsvd_bits = pxe_rsvd_bits;
+			efer |= EFER_NX;
+		} else {
+			rsvd_bits = PT64_NX_MASK;
+			efer &= ~EFER_NX;
+		}
+		if (i & 2)
+			cr4 |= X86_CR4_SMEP;
+		else
+			cr4 &= ~X86_CR4_SMEP;
+		if (i & 4)
+			guest_efer |= EFER_NX;
+		else
+			guest_efer &= ~EFER_NX;
+		if (i & 8)
+			guest_cr4 |= X86_CR4_SMEP;
+		else
+			guest_cr4 &= ~X86_CR4_SMEP;
+
+		__svm_npt_rsvd_bits_test(pxe, rsvd_bits, efer, cr4,
+					 guest_efer, guest_cr4);
+	}
+}
+
+static u64 get_random_bits(u64 hi, u64 low)
+{
+	u64 rsvd_bits;
+
+	do {
+		rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
+	} while (!rsvd_bits);
+
+	return rsvd_bits;
+}
+
+
+static void svm_npt_rsvd_bits_test(void)
+{
+	u64   saved_efer, host_efer, sg_efer, guest_efer;
+	ulong saved_cr4,  host_cr4,  sg_cr4,  guest_cr4;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	saved_efer = host_efer  = rdmsr(MSR_EFER);
+	saved_cr4  = host_cr4   = read_cr4();
+	sg_efer    = guest_efer = vmcb->save.efer;
+	sg_cr4     = guest_cr4  = vmcb->save.cr4;
+
+	test_set_guest(basic_guest_main);
+
+	/*
+	 * 4k PTEs don't have reserved bits if MAXPHYADDR >= 52, just skip the
+	 * sub-test.  The NX test is still valid, but the extra bit of coverage
+	 * isn't worth the extra complexity.
+	 */
+	if (cpuid_maxphyaddr() >= 52)
+		goto skip_pte_test;
+
+	_svm_npt_rsvd_bits_test(npt_get_pte((u64)basic_guest_main),
+				get_random_bits(51, cpuid_maxphyaddr()),
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+skip_pte_test:
+	_svm_npt_rsvd_bits_test(npt_get_pde((u64)basic_guest_main),
+				get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+	_svm_npt_rsvd_bits_test(npt_get_pdpe(),
+				PT_PAGE_SIZE_MASK |
+					(this_cpu_has(X86_FEATURE_GBPAGES) ? get_random_bits(29, 13) : 0),
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+	_svm_npt_rsvd_bits_test(npt_get_pml4e(), BIT_ULL(8),
+				host_efer, host_cr4, guest_efer, guest_cr4);
+
+	wrmsr(MSR_EFER, saved_efer);
+	write_cr4(saved_cr4);
+	vmcb->save.efer = sg_efer;
+	vmcb->save.cr4  = sg_cr4;
+}
 
 static bool volatile svm_errata_reproduced = false;
 static unsigned long volatile physical = 0;
@@ -2741,6 +2883,7 @@ struct svm_test svm_tests[] = {
       host_rflags_finished, host_rflags_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
+    TEST(svm_npt_rsvd_bits_test),
     TEST(svm_vmrun_errata_test),
     TEST(svm_vmload_vmsave),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
-- 
2.32.0.288.g62a8d224e6-goog

