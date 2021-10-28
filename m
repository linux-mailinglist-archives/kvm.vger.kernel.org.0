Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B7243F1D7
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 23:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhJ1VhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 17:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhJ1VhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 17:37:11 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB57C061745
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 14:34:43 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z10-20020ac83e0a000000b002a732692afaso5411972qtf.2
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 14:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=OQDQ2f8asb/XV/7FhL+X/OcXI4SOd7uK2NuQ9jXG82g=;
        b=V15hpHIJKFlrONA4ck3gnpQxOMBmxXpg8zWdnO3bKmdnKpgyrKIHj1W414KzxnSJPO
         0lm+gU7kc+/Di9iP1OoXUonyfWvhs5GwiJGUtRn93f6xrDmVs8lcP5qvjcUk3V4F/z6j
         fqQNwFDljf0DCDeSXgXMrv2jWuATPlzNDOGL25BBCHbaeXuoqzbiqWPBGREC7HDOcnC5
         seRzrXPCxC2nTg7t6nxjGZFIPIrzA/qp8MEckWw1qdVRR4L1SGj+cTgRfATNN3SlEBd5
         ckK+PwMG+K55cFtpIJctHVt+M7ZoM8viL/34Iz6ILxmZo4DQQ4qooLpiv2O8f8c1c2Ke
         Kr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=OQDQ2f8asb/XV/7FhL+X/OcXI4SOd7uK2NuQ9jXG82g=;
        b=wWw4q0+4ZYYJdkdUDn9S5I5R74qYge/8OR2WXvU27LYhJ7TfLlfwAaO9EZuEcQp+6x
         1qMqxvWh5kYgSKIBhXZrdXjklrBlNJVuAa34eQ++hBa7VMKj1JldeQ6PCO2Hs75SPvxQ
         meMVKTry81/c1SY7nCO6lz7jLDMCcQyR3zWyJA011KhiWLRHEBuMpGVZlBTYxcNRxMJr
         krqpLYpVEVi8sMM17QDVhUBshOLkijmQsh7TfVIdUXjTVd66SCYLps6xjsxDA4nyCkA0
         QdxBHroRaakZ0WX+7hUEFALnonXB64a1vBk1+Rb8qudRcDZE7+EDHGKMwGpmcH2yif7R
         T7xg==
X-Gm-Message-State: AOAM531yh5LC4sK1mclHQLvB79MBLThqL0QzmrA7k/7g6P7YWTEj8baL
        lJKRNeEO2r4DbXc0ibmiJGdYXb+4Uqg=
X-Google-Smtp-Source: ABdhPJx/zJIBQjlkciiZyjU08oE/ufcsTYPRGQljhVBj9crj3Qsd0W2Wk/AaJbFCQkKyQ6KV6eihUIdUUec=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:cbc8:1a0d:eab9:2274])
 (user=seanjc job=sendgmr) by 2002:a05:622a:1441:: with SMTP id
 v1mr7554345qtx.45.1635456882657; Thu, 28 Oct 2021 14:34:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 28 Oct 2021 14:34:08 -0700
Message-Id: <20211028213408.2883933-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH] KVM: x86: Shove vp_bitmap handling down into sparse_set_to_vcpu_mask()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ajay Garg <ajaygargnsit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the vp_bitmap "allocation" that's need to handle mismatched vp_index
values down into sparse_set_to_vcpu_mask() and drop __always_inline from
said helper.  The vp_bitmap mess is a detail that's specific to the sparse
translation and does not need to be exposed to the caller.

The underlying motivation is to fudge around a compilation warning/error
when CONFIG_KASAN_STACK=y, which is selected (and can't be unselected) by
CONFIG_KASAN=y when compiling with gcc (clang/LLVM is a stack hog in some
cases so it's opt-in for clang).  KASAN_STACK adds a redzone around every
stack variable, which pushes the Hyper-V functions over the default limit
of 1024.  With CONFIG_KVM_WERROR=y, this breaks the build.  Shuffling which
function is charged with vp_bitmap gets all functions below the default
limit.

Regarding the __always_inline, prior to commit f21dd494506a ("KVM: x86:
hyperv: optimize sparse VP set processing") the helper, then named
hv_vcpu_in_sparse_set(), was a tiny bit of code that effectively boiled
down to a handful of bit ops.  The __always_inline was understandable, if
not justifiable.  Since the aforementioned change, sparse_set_to_vcpu_mask()
is a chunky 350-450+ bytes of code without KASAN=y, and balloons to 1100+
with KASAN=y.  In other words, it has no business being forcefully inlined.

Reported-by: Ajay Garg <ajaygargnsit@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Vitaly (and anyone with extensive KVM + Hyper-V knowledge), it would be
really helpful to get better coverage in kvm-unit-tests.  There's a smoke
test for this in selftests, but it's not really all that interesting.  It
took me over an hour and a half just to get a Linux guest to hit the
relevant flows.  Most of that was due to QEMU 5.1 bugs (doesn't advertise
HYPERCALL MSR by default) and Linux guest stupidity (silently disables
itself if said MSR isn't available), but it was really annoying to have to
go digging through QEMU to figure out how to even enable features that are
extensive/critical enough to warrant their own tests.

/wave to the clang folks for the pattern patch on the changelog ;-)

 arch/x86/kvm/hyperv.c | 55 ++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f15c0165c05..80018cfab5c7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1710,31 +1710,36 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		return kvm_hv_get_msr(vcpu, msr, pdata, host);
 }
 
-static __always_inline unsigned long *sparse_set_to_vcpu_mask(
-	struct kvm *kvm, u64 *sparse_banks, u64 valid_bank_mask,
-	u64 *vp_bitmap, unsigned long *vcpu_bitmap)
+static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
+				    u64 valid_bank_mask, unsigned long *vcpu_mask)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
+	bool has_mismatch = atomic_read(&hv->num_mismatched_vp_indexes);
+	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *vcpu;
 	int i, bank, sbank = 0;
+	u64 *bitmap;
 
-	memset(vp_bitmap, 0,
-	       KVM_HV_MAX_SPARSE_VCPU_SET_BITS * sizeof(*vp_bitmap));
+	BUILD_BUG_ON(sizeof(vp_bitmap) >
+		     sizeof(*vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS));
+
+	/* If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly. */
+	if (likely(!has_mismatch))
+		bitmap = (u64 *)vcpu_mask;
+
+	memset(bitmap, 0, sizeof(vp_bitmap));
 	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
 			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
-		vp_bitmap[bank] = sparse_banks[sbank++];
+		bitmap[bank] = sparse_banks[sbank++];
 
-	if (likely(!atomic_read(&hv->num_mismatched_vp_indexes))) {
-		/* for all vcpus vp_index == vcpu_idx */
-		return (unsigned long *)vp_bitmap;
-	}
+	if (likely(!has_mismatch))
+		return;
 
-	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+	bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (test_bit(kvm_hv_get_vpindex(vcpu), (unsigned long *)vp_bitmap))
-			__set_bit(i, vcpu_bitmap);
+			__set_bit(i, vcpu_mask);
 	}
-	return vcpu_bitmap;
 }
 
 struct kvm_hv_hcall {
@@ -1756,9 +1761,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
-	unsigned long *vcpu_mask;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[64];
 	int sparse_banks_len;
@@ -1842,11 +1845,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	if (all_cpus) {
 		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
 	} else {
-		vcpu_mask = sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-						    vp_bitmap, vcpu_bitmap);
+		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
-		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-					    vcpu_mask);
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
 	}
 
 ret_success:
@@ -1879,9 +1880,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
-	unsigned long *vcpu_mask;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[64];
 	int sparse_banks_len;
@@ -1937,11 +1936,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
-	vcpu_mask = all_cpus ? NULL :
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-					vp_bitmap, vcpu_bitmap);
+	if (all_cpus) {
+		kvm_send_ipi_to_many(kvm, vector, NULL);
+	} else {
+		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
-	kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
+		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
+	}
 
 ret_success:
 	return HV_STATUS_SUCCESS;
-- 
2.33.0.1079.g6e70778dc9-goog

