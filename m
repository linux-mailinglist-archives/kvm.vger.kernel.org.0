Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D26140FD59
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbhIQP5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbhIQP5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 11:57:35 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C893C061574
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 08:56:13 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k23so7285215pji.0
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 08:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=oPN96D/w80bcliO5oaGyR+sP0QfueKQfKsX6sGaFsbg=;
        b=gbRsuhxbYFFiYRjEqchkxzlzPSCsPAgd65mJn8l+pI5ztBnGIOcxYpw4NdU+EPOqkW
         Zc9jBGJ9bXNuWhy0B54SNHlnK4z5nIdelrPBA12BxjKrKGus8pgPW+6jP2kLz9ETYCGp
         STxsCu4Wt9oKtJ2NYlPNzdRvVHTRh3/1uCVixb5gq8tAr/WdmwXW7pBXU+j2idGkUWek
         yW64UUQ9r5lKNDFVz3a5Vzd7Qp/sU61vw5PWdGdVTKd2tB1MclWnngImFMIozK0m+Nwt
         HQxJ4e58Whtb85xFYk0fEf/ajkwzsWNAGT+B1PCsj2mHBeLI9LK4KrkUV8MdZ6BzupFa
         fsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oPN96D/w80bcliO5oaGyR+sP0QfueKQfKsX6sGaFsbg=;
        b=k+0lpKaUC/PUOojkL/SgQ4kXKQkcjhok0T9qJjxkw/Ze7fWOrboy0J0YA3XbgDq6Co
         SnBdVJ9W4d6Z8jtJ27PW/bhDze/yD6/AnEOom5YPZoLtaJUL3+fpM5UfHhCwpKH5OISr
         JcAiWqRnzeoUQ28LNVwEI/m9fhvU/xCwJrvuvr3VRrqIkCG9El5TB/TPZnBlul9fuygY
         rCTw8E03FdRMAXj1l5t4ycBB7AiNiyzbSHmNDPRuOyfE6YOvaIyUrWNprouAqzyqKQ7a
         /uFFT3xbDh3UlVbI7lQv2afMr7kVc2+y93UqgzL4iCc5HXc5oKtqQ1U7XRmVxmZw7Ssk
         CiWw==
X-Gm-Message-State: AOAM531I3qyysgvI5BVPI9R19RiKa8v2/XTzy8MMMVh2E+kFa/GhBA3q
        3NdXYnUKEAM+6irtZwAOTTbKiG84zGc=
X-Google-Smtp-Source: ABdhPJxuVUCEaf5hmFZpcSXCcoRXAVxo4yYGCMQRgDjKes134kjYpf7tXdaMXvFPSC0sYkPjAAHfsQ==
X-Received: by 2002:a17:90b:4012:: with SMTP id ie18mr13468510pjb.105.1631894172542;
        Fri, 17 Sep 2021 08:56:12 -0700 (PDT)
Received: from localhost.localdomain ([122.161.247.80])
        by smtp.gmail.com with ESMTPSA id y8sm7016537pfe.162.2021.09.17.08.56.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 08:56:12 -0700 (PDT)
From:   Ajay Garg <ajaygargnsit@gmail.com>
To:     kvm@vger.kernel.org
Cc:     ajay <ajaygargnsit@gmail.com>
Subject: [PATCH] KVM: x86: (64-bit x86_64 machine) : fix -frame-larger-than warnings/errors.
Date:   Fri, 17 Sep 2021 21:25:59 +0530
Message-Id: <1631894159-10146-1-git-send-email-ajaygargnsit@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ajay <ajaygargnsit@gmail.com>

Issue :
=======

In "kvm_hv_flush_tlb" and "kvm_hv_send_ipi" methods, defining
"u64 sparse_banks[64]" inside the methods (on the stack), causes the
stack-segment-memory-allocation to go beyond 1024 bytes, thus raising the
warning/error which breaks the build.

Fix :
=====

Instead of defining "u64 sparse_banks [64]" inside the methods, we instead
define this array in the (only) client method "kvm_hv_hypercall", and then
pass the array (and its size) as additional arguments to the two methods.

Doing this, we do not exceed the 1024 bytes stack-segment-memory-allocation,
on any stack-segment of any method.

Signed-off-by: ajay <ajaygargnsit@gmail.com>
---
 arch/x86/kvm/hyperv.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 232a86a6faaf..5340be93daa4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1750,7 +1750,8 @@ struct kvm_hv_hcall {
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 };
 
-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc,
+                            bool ex, u64 *sparse_banks, u32 num_sparse_banks)
 {
 	int i;
 	gpa_t gpa;
@@ -1762,10 +1763,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 	unsigned long *vcpu_mask;
 	u64 valid_bank_mask;
-	u64 sparse_banks[64];
 	int sparse_banks_len;
 	bool all_cpus;
 
+        memset(sparse_banks, 0, sizeof(u64) * num_sparse_banks);
+
 	if (!ex) {
 		if (hc->fast) {
 			flush.address_space = hc->ingpa;
@@ -1875,7 +1877,8 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	}
 }
 
-static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
+static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc,
+                           bool ex, u64 *sparse_banks, u32 num_sparse_banks)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
@@ -1884,11 +1887,12 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 	unsigned long *vcpu_mask;
 	unsigned long valid_bank_mask;
-	u64 sparse_banks[64];
 	int sparse_banks_len;
 	u32 vector;
 	bool all_cpus;
 
+        memset(sparse_banks, 0, sizeof(u64) * num_sparse_banks);
+
 	if (!ex) {
 		if (!hc->fast) {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
@@ -2162,6 +2166,10 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	struct kvm_hv_hcall hc;
 	u64 ret = HV_STATUS_SUCCESS;
 
+#define NUM_SPARSE_BANKS        64
+
+	u64 sparse_banks[NUM_SPARSE_BANKS];
+
 	/*
 	 * hypercall generates UD from non zero cpl and real mode
 	 * per HYPER-V spec
@@ -2248,42 +2256,48 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, false,
+                                       sparse_banks, NUM_SPARSE_BANKS);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, false);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, false,
+                                       sparse_banks, NUM_SPARSE_BANKS);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 		if (unlikely(!hc.rep_cnt || hc.rep_idx)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, true,
+                                       sparse_banks, NUM_SPARSE_BANKS);
 		break;
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
 		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_flush_tlb(vcpu, &hc, true);
+		ret = kvm_hv_flush_tlb(vcpu, &hc, true,
+                                       sparse_banks, NUM_SPARSE_BANKS);
 		break;
 	case HVCALL_SEND_IPI:
 		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_send_ipi(vcpu, &hc, false);
+		ret = kvm_hv_send_ipi(vcpu, &hc, false,
+                                      sparse_banks, NUM_SPARSE_BANKS);
 		break;
 	case HVCALL_SEND_IPI_EX:
 		if (unlikely(hc.fast || hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
-		ret = kvm_hv_send_ipi(vcpu, &hc, true);
+		ret = kvm_hv_send_ipi(vcpu, &hc, true,
+                                      sparse_banks, NUM_SPARSE_BANKS);
 		break;
 	case HVCALL_POST_DEBUG_DATA:
 	case HVCALL_RETRIEVE_DEBUG_DATA:
-- 
2.30.2

