Return-Path: <kvm+bounces-57456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC15B55A15
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65630AE04F5
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B32B2D6E71;
	Fri, 12 Sep 2025 23:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r1d5NAvx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5272D5436
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719430; cv=none; b=BsVHxckJof73hOsbMz4XCm5ZQbEp8tlcG5ZWDO9zx1SxGq6cMHaHMLI8ljsc8znWwxgo/MDT2jD3VFrV7Futq+3BtXlUaCc8BD+TRh9ZOWKYgdHWriwpYVnfwpVo8IvOd4RBzUdnR776MOs+GzLRjjDMAeO4Q+Qptl0qsgGRk34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719430; c=relaxed/simple;
	bh=985mQqULIGpufOuzaAVFSt7yUo06RAYS1zBwm4OIB80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YhTQE8739bGXGAv4+3VayKFR5qGhmrld6WWmw//6q2QunNBqLjj8F/eivpsZkIxMeuy+++Mg7ocyVLnswtIpgF6M2bCPkX5K3I6ahh5BM2jc3kxvXhz1dbzq5P3LMl/NT3VBk974oiikT+ERF20BdMEsceIns93xCxme2Pe705M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r1d5NAvx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77260b29516so4707455b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719428; x=1758324228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EGYFfxiDLtJ7q4NwudFUxWdrWn2kGXus37phRe1p0h4=;
        b=r1d5NAvxKqmBTnUfjQtH4DnKocTiyZYfNhlMmERlKmyi7MzgvpOE3ygb2Gsjl+CDAq
         opPYhZ2F+JI0q02wjm5B0NdjewenzS4BQGP2IThFGQDdD4g6hHSf32F6s6gd5tGyDAh8
         qN/zJyQnzy3eBjtS+fZCw44iRxH7ML1eC0eZtu5nn/ZyBxcnrfwWsDFkP47pED7EHHfZ
         p6q/ygdfS4yevQvfLKqcO7nUIXp3Qps3iVlHL16A/uWM6ATStKJk8xXLwJx3ry+mUViX
         V2nyu9Fr+fvTRVHxbVrqOTbxcbwXxxjKZN1Se28yFgvnfbye6bYnnfQlQe+06qwq3IJP
         nDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719428; x=1758324228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGYFfxiDLtJ7q4NwudFUxWdrWn2kGXus37phRe1p0h4=;
        b=heUlzr83uGXf6u3tj4sOsurk5/FuDCyLeagHrxSMbSP9+AasIKnBqwXxrAIriWYmE5
         pRIvJBrnqspqhWAwmMbUdul7pGQJZpmX6vUGmwsWecPH4PL9lOfREqgU8L0PcTVEtvqA
         S8mMDgyoImFSAdQYno+3zdmLNUQXATp51hTUJeJXLwajSF7B2H++OogGFZIKMrxbDsTQ
         WpDrE+yq3MjXA64Bqhljnv86jDXXe7W0QdXZxj0mUs8V0FeormrTn6cTrPVsDCZvfyaP
         71Ez/EF4KqQ5Snq3xAK1XZpT5pLFSynJhCyQIUPwpWWOy2fJcM4p+Ym/pkquJcHpG32J
         RcOQ==
X-Gm-Message-State: AOJu0YzKYkGwzROqHszxDAY2m2yVpcz/llGBSZp850CiaqB5cen3M1IP
	TvjYX2KZzYSfE4FJke0cEOkMD4/0rhmgcejsicfik0mAROjsJT6HBbUyKTIQElynIwdazEleTYu
	9DZ65Bg==
X-Google-Smtp-Source: AGHT+IF3EsKj/KEE1isiWP6uA4W6JiQbK2d3C0u8tqB9rJOm/OOK+jqg062W5TZ7UziXwYy9ajwdI76c0fw=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:32b:5ea2:778])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9186:b0:243:15b9:765b
 with SMTP id adf61e73a8af0-2602cd11f0fmr5877361637.53.1757719428215; Fri, 12
 Sep 2025 16:23:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:51 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-14-seanjc@google.com>
Subject: [PATCH v15 13/41] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Enable guest shadow stack pointer(SSP) access interface with new uAPIs.
CET guest SSP is HW register which has corresponding VMCS field to save
and restore guest values when VM-{Exit,Entry} happens. KVM handles SSP
as a fake/synthetic MSR for userspace access.

Use a translation helper to set up mapping for SSP synthetic index and
KVM-internal MSR index so that userspace doesn't need to take care of
KVM's management for synthetic MSRs and avoid conflicts.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  |  8 ++++++++
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              | 23 +++++++++++++++++++++--
 arch/x86/kvm/x86.h              | 10 ++++++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd02675a24d..6ae24c5ca559 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2911,6 +2911,14 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 x86 MSR registers have the following id bit patterns::
   0x2030 0002 <msr number:32>
 
+Following are the KVM-defined registers for x86:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x2030 0003 0000 0000 SSP       Shadow Stack Pointer
+======================= ========= =============================================
+
 4.69 KVM_GET_ONE_REG
 --------------------
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 508b713ca52e..8cc79eca34b2 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -437,6 +437,9 @@ struct kvm_xcrs {
 #define KVM_X86_REG_KVM(index)					\
 	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
 
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c9908bc8b32..460ceae11495 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6017,7 +6017,15 @@ struct kvm_x86_reg_id {
 
 static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
 {
-	return -EINVAL;
+	switch (reg->index) {
+	case KVM_REG_GUEST_SSP:
+		reg->type = KVM_X86_REG_TYPE_MSR;
+		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
 }
 
 static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
@@ -6097,11 +6105,22 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
 static int kvm_get_reg_list(struct kvm_vcpu *vcpu,
 			    struct kvm_reg_list __user *user_list)
 {
-	u64 nr_regs = 0;
+	u64 nr_regs = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ? 1 : 0;
+	u64 user_nr_regs;
+
+	if (get_user(user_nr_regs, &user_list->n))
+		return -EFAULT;
 
 	if (put_user(nr_regs, &user_list->n))
 		return -EFAULT;
 
+	if (user_nr_regs < nr_regs)
+		return -E2BIG;
+
+	if (nr_regs &&
+	    put_user(KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), &user_list->reg[0]))
+		return -EFAULT;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 786e36fcd0fb..a7c9c72fca93 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -101,6 +101,16 @@ do {											\
 #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX	USHRT_MAX
 #define KVM_SVM_DEFAULT_PLE_WINDOW	3000
 
+/*
+ * KVM's internal, non-ABI indices for synthetic MSRs. The values themselves
+ * are arbitrary and have no meaning, the only requirement is that they don't
+ * conflict with "real" MSRs that KVM supports. Use values at the upper end
+ * of KVM's reserved paravirtual MSR range to minimize churn, i.e. these values
+ * will be usable until KVM exhausts its supply of paravirtual MSR indices.
+ */
+
+#define MSR_KVM_INTERNAL_GUEST_SSP	0x4b564dff
+
 static inline unsigned int __grow_ple_window(unsigned int val,
 		unsigned int base, unsigned int modifier, unsigned int max)
 {
-- 
2.51.0.384.g4c02a37b29-goog


