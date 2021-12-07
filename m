Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3D046C73D
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242147AbhLGWNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 17:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242149AbhLGWNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 17:13:18 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EE0C061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 14:09:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf15-20020a17090ac7cf00b001a9a31687d0so409252pjb.1
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 14:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iQDtWCeRApkNxvgSf3YZuTCTKLwT5JTxHh4XbwJlOF8=;
        b=j5Tjlp1+fQIwr+HynktQ1gsZzx01M2pRoJMnKTxaPKyV38VfTFFhU42vy8OmXqvrUx
         Jef/37Wn0sxInn7kSQcJ24PpXFYpE/gOhZwS1Tgv36QCfIxxRQnWRnwlSGNzARQTCfZz
         JZH7xKUPTaTb+VLakJXelWmUm6FttSZg3oWDyZcHFOhQyOkved5x5Y3s0CHf7fff7Rer
         27vNKFRvWGRelWbdoSFHAbgpRcYA8wEZAN/MPfawqs+sHRWIQKInDQsQ+xWIm845F1NV
         bvLATookEaVS1TQpF7iqMH0A5BNZYqX2/+qeSV9BCBBexz40/er+oPmNTM2hekKs3r1E
         EzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iQDtWCeRApkNxvgSf3YZuTCTKLwT5JTxHh4XbwJlOF8=;
        b=CIVRQETkIJl4NLmL6Z32uNy/L9wHWLI6E57Tk1nTK9UmA7MoUb+fHswtnDCKqsycoI
         bTT8pdqFBc2DO2u5Iy1fj0SkhvYlT0TPpKIPYsTEbww/8BiXcZEl2a3a2UTzDce79kEi
         iFthWiQPF5XZF4/F3Qwo/kOcKLnHDEEG9Wr5KmekfoakeYiWLhWQEhbbQRGEHXT35q4H
         YN+y9YWFl7LfKdfOq7/7oGyDG11wiiaPNILaKbCgtVDBoIOuFR3YDIZG7r03bBX/v1Uf
         8oxvm25m8DUYwA2e5VLg1JjB5dmEPGkxCTqWNqefzDLOQ4IubMDt+vThol5gI3dcB4bR
         Epog==
X-Gm-Message-State: AOAM532eZCDz+q8f7DMepb/r0XUGAcWeXYfXCucNkrpmyv8Gg7DumjsI
        ZBR3K734AyHsTc88CYdAfGSR/tsVTFY=
X-Google-Smtp-Source: ABdhPJxwIWI6EO7Di+1vHiHCvjTsyUvE6JHMu1iC+F7VJ2ivqyHTsKcZcjJPDnxA8I95E2jOYruKTPLkgoM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7c02:b0:143:9d6a:8e42 with SMTP id
 x2-20020a1709027c0200b001439d6a8e42mr54202143pll.80.1638914986582; Tue, 07
 Dec 2021 14:09:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 22:09:24 +0000
In-Reply-To: <20211207220926.718794-1-seanjc@google.com>
Message-Id: <20211207220926.718794-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211207220926.718794-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 6/8] KVM: x86: Shove vp_bitmap handling down into sparse_set_to_vcpu_mask()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the vp_bitmap "allocation" that's needed to handle mismatched vp_index
values down into sparse_set_to_vcpu_mask() and drop __always_inline from
said helper.  The need for an intermediate vp_bitmap is a detail that's
specific to the sparse translation with mismatched VP<=>vCPU indexes and
does not need to be exposed to the caller.

Regarding the __always_inline, prior to commit f21dd494506a ("KVM: x86:
hyperv: optimize sparse VP set processing") the helper, then named
hv_vcpu_in_sparse_set(), was a tiny bit of code that effectively boiled
down to a handful of bit ops.  The __always_inline was understandable, if
not justifiable.  Since the aforementioned change, sparse_set_to_vcpu_mask()
is a chunky 350-450+ bytes of code without KASAN=y, and balloons to 1100+
with KASAN=y.  In other words, it has no business being forcefully inlined.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 65 +++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a470cde7a7a7..f33a5e890048 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1710,32 +1710,47 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
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
 	int bank, sbank = 0;
 	unsigned long i;
+	u64 *bitmap;
 
-	memset(vp_bitmap, 0,
-	       KVM_HV_MAX_SPARSE_VCPU_SET_BITS * sizeof(*vp_bitmap));
+	BUILD_BUG_ON(sizeof(vp_bitmap) >
+		     sizeof(*vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS));
+
+	/*
+	 * If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly, else
+	 * fill a temporary buffer and manually test each vCPU's VP index.
+	 */
+	if (likely(!has_mismatch))
+		bitmap = (u64 *)vcpu_mask;
+	else
+		bitmap = vp_bitmap;
+
+	/*
+	 * Each set of 64 VPs is packed into sparse_banks, with valid_bank_mask
+	 * having a '1' for each bank that exists in sparse_banks.  Sets must
+	 * be in ascending order, i.e. bank0..bankN.
+	 */
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
@@ -1772,9 +1787,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
-	unsigned long *vcpu_mask;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	bool all_cpus;
@@ -1867,11 +1880,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
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
@@ -1904,9 +1915,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
-	unsigned long *vcpu_mask;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
@@ -1962,11 +1971,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
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
2.34.1.400.ga245620fadb-goog

