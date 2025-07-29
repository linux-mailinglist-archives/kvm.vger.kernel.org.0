Return-Path: <kvm+bounces-53692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7785B15590
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE9F13ABA77
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857032C15A9;
	Tue, 29 Jul 2025 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqXjOkMD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22772C08BD
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829755; cv=none; b=AvnxKCEPGGgvKAIsP27PIO/HMMPPtHQ4QACMjazhuMOQYs48aQpYsAhWRx5D9Nu08xkJd+dqmvOMveR0mcUkjafQmOKdVK3utOuioFEUYZZpPF8yHk8JyXQ65P2y7r2HEVwPlmpwD1QX3Z5EpJXx7Ts7OiDPAaBUsXIivpJfq3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829755; c=relaxed/simple;
	bh=WeFKr3XwYMubF6PEa5sSz6hYZVpnww/5jO5Tu3utXR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5hJPW/mnHjlItqwUl9fD/tAts0zbf+/MASVkJ7Rotfug2ZTjC8bVHbIf9GaqQwNf91Og+itCLCYS2u24vlx5Uj9UwSwcevAe+esq6tLBiQrdesfvShHAu2lRUK8hNTxhaPB5i2dn4F1zakmzEeiKM6qgYgDcSxPqXf8mm28UpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqXjOkMD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-240012b74dfso25206445ad.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829752; x=1754434552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jTad4J8Qg1Nlv10PcvZ871whY+Aaj9TjlMyj9Irid8k=;
        b=eqXjOkMD6OcOb7fjk2bmw39/IdqpnQTPM0dzUFyowV+BDPUvKkqL5F5eAMAzOcaJIY
         LzTlWtL7zkoLujCvOt1zm+qY4hO9qkmg14JXpEzrOAFXuIVrGWEK9VHBUGJAVwY2/c2N
         iaHN1F8FelY7UAk5ku4mXUG6jV0JuDRN8uPXTbdMxXTZgvv9hF744pGjoJcQrBYCEC+W
         FxUNl6OJ0ocYjSPJ0skQQKKflTTeKnnNfyiAMH5e/TwCjNYeHPoCEM2OofaKRNGtQQwQ
         5Gyc59sYgE+AGtjesEaX/oYUhqFhJRxvQSEyXtZp4SavVRZ2jVWpS+bF7X1QQD092Xd7
         n15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829752; x=1754434552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jTad4J8Qg1Nlv10PcvZ871whY+Aaj9TjlMyj9Irid8k=;
        b=ek5Jj/uJ65nqunWUMD8659RkR7b06NPIRr6EywDJ6HQ1d6pxElQjr7qyFZVb5dI3cW
         Fi/1Oo3OtavHvW6QVAjBrxNpmu/islsqH/VtCNvo36dqPGuqPC1umod0L4gBoWiPyrKI
         t60GtHPCClyCdrJD90Mv7A7PO+MkdaXtwn8mDz9WFqaupvEpMuDug0clEdzCKz6e8GYX
         kUMPYc35s7y3wmxCXYWxsgKrR30/7l4VzpwxsH6R60xGgMsEWx9RDSbdSG0cdKqdDiZc
         Vd65fVOaDuRjnTXouw0BEWxetWls68HIugaATw04sHX2SqwaO3LYBQjZ0U4JermcEhhU
         fMAQ==
X-Gm-Message-State: AOJu0YzzM7ocgIl4SLCZ6ywtQxarIGUq13SlGO/QxTsF+i5OHShO1NcZ
	+VwBPTDC4Nyv3lYr/jNeRuFjcOujgLhwB4qcMUYlCqZVRysVCSmIJaISlB2hYWrk8kmeplqQpqi
	KnGm8Ig==
X-Google-Smtp-Source: AGHT+IE+WmeXckPv5tF/SBSQrHY4ZKYybHI52HgzkPQNumcR9r+UIJ3cQitNOL7pJonSsZZzG7kXKsvAgds=
X-Received: from plblc3.prod.google.com ([2002:a17:902:fa83:b0:240:3906:c827])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d547:b0:234:8e78:ce8a
 with SMTP id d9443c01a7336-24096bfd5e2mr13095805ad.48.1753829752170; Tue, 29
 Jul 2025 15:55:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:43 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-13-seanjc@google.com>
Subject: [PATCH v17 12/24] KVM: x86/mmu: Rename .private_max_mapping_level()
 to .gmem_max_mapping_level()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
in anticipation of extending guest_memfd support to non-private memory.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/mmu/mmu.c             | 2 +-
 arch/x86/kvm/svm/sev.c             | 2 +-
 arch/x86/kvm/svm/svm.c             | 2 +-
 arch/x86/kvm/svm/svm.h             | 4 ++--
 arch/x86/kvm/vmx/main.c            | 6 +++---
 arch/x86/kvm/vmx/tdx.c             | 2 +-
 arch/x86/kvm/vmx/x86_ops.h         | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 18a5c3119e1a..62c3e4de3303 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -145,7 +145,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
-KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
+KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50366a1ca192..c0a739bf3829 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdc2824755ee..b735611e8fcd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4532,7 +4532,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7744c210f947..be1c80d79331 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..8a66e2e985a4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5180,7 +5180,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
-	.private_max_mapping_level = sev_private_max_mapping_level,
+	.gmem_max_mapping_level = sev_gmem_max_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..d84a83ae18a1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
@@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..dd7687ef7e2d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -831,10 +831,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	if (is_td(kvm))
-		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+		return tdx_gmem_max_mapping_level(kvm, pfn);
 
 	return 0;
 }
@@ -1005,7 +1005,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
+	.gmem_max_mapping_level = vt_op_tdx_only(gmem_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..b444714e8e8a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3318,7 +3318,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return PG_LEVEL_4K;
 }
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2b3424f638db..6037d1708485 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.50.1.552.g942d659e1b-goog


