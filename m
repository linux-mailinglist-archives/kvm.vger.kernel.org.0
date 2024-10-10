Return-Path: <kvm+bounces-28510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DAB69990AB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EE6F1C222C5
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FE91FF7B8;
	Thu, 10 Oct 2024 18:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fhtsmxz8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA51FCC7E
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584765; cv=none; b=neE5DEPgBSITz5axddyrkILSft92xqd33FH6TUq4L3BN2W1SF+riUMWp1p6FexJCTUzG+mmW8xAIir0bFaW98VGZZ112PJJ01O688FejAQ2jXZp9Puy99ZTkUK31q4oVDSBxUMJG/tFjajs9Nh9q1pg/y6nsz7Q4UCWTHjhqhcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584765; c=relaxed/simple;
	bh=mQXhN5iZpOZWnnd2N5GwBNgcRKXl5xUfnEr6O0WaUwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Awc9JpQ+mB4bJZMVmHiDzpzgIX2xif9cNae9aIahfWONMG+u8GrQxfuvCqcRdbc1e8TNYuu5NwabudPNzTUUu7fAKiUIA5vlU8JB2O/rBwrTfrLYlqXKKR2qgwGMnOSyst3ZoIljYczhWIefQzKSMnvDF9k9XRRpJHcb2cABpac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fhtsmxz8; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3204db795so21454177b3.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584761; x=1729189561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DlXoUFYFzJpPJut8ySNZ/avzuJs4Hk+oSmN6VTWgSk=;
        b=fhtsmxz8vpfa2op10hhZgWbQg3a/Ux0j9mEjjKDNpT+6H68jzG7G30Lrt0DgwS2OqA
         VAQch49mqfwm5cA16yd/W6I1emiwxouDMXVSvKt1yo8/wuYywAj8WmU3ri9BLGwOXV2O
         ev+52ekxcamGE3PinuEE6axN2+AjKb8EBbMunUi5MpzIPNmR7Cd+feQewcjH6urh4T2Y
         L7YmQKAT/bzQUgg9L16aEUHrMjmkiyjytv61vSD0Smo/6KXR/dS0NqmYK+EDeZ81iIUB
         BpN0M+BzPxJAzpf2q5xvJT+CdoJM7Ovvc/CKmFvaOg7Bed7+EqAlOAxWv/v1tDiHH+OX
         ghxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584761; x=1729189561;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+DlXoUFYFzJpPJut8ySNZ/avzuJs4Hk+oSmN6VTWgSk=;
        b=I7+gK0vQD9cDMAdNuKYFZ8YEwkMzFOKlQMrz2lYoYF57k1QjqFn4/GHe77gy3W7ty7
         dHVD5qrXGPFuEumNuS2p8MitJXtlrkcTeWuOF7OYT7QMemvDm2hVhv7XTZGRK2nas6Hb
         65c7D4p5Hd1evDFkTAChwInF/DEoNol7rJJjIx0uu76E/fY69NagFmWcfYT3a7CUAx1o
         dcunO4+gXZmOYH8YVOvmaCCwSCjY0iFBWsIsBJv8Unq8mr9N6QSUNMNp6+NkjzXWMbLb
         7g69KHm3WcTy1y8pM0aI3uWKbrP1nNuZKe55hantjATS/PhDmeE3vjVKTwGYdEryT5R3
         Thqg==
X-Gm-Message-State: AOJu0YyxcII75ZbODfLRY/7cE55iO1l3j9AThabK8nKYuhQsAakNKLpE
	q0N74dBEW34xxcke+P9HybRQz8hRAE/X/HB4HZKyQm29JqHdcpMw3SPvf8nWEUYomFsCurNf6FH
	D+w==
X-Google-Smtp-Source: AGHT+IHYBe/gylmYYB76Y4JbCGQqBxyU7NvKFk8CzbtQRqqOSH0kk5njqmBLFW7wxt+Okx9MKc9CHg/F7Og=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4349:b0:6e2:1713:bdb5 with SMTP id
 00721157ae682-6e32217cfd3mr118607b3.5.1728584760829; Thu, 10 Oct 2024
 11:26:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:35 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-34-seanjc@google.com>
Subject: [PATCH v13 33/85] KVM: Pass in write/dirty to kvm_vcpu_map(), not kvm_vcpu_unmap()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Now that all kvm_vcpu_{,un}map() users pass "true" for @dirty, have them
pass "true" as a @writable param to kvm_vcpu_map(), and thus create a
read-only mapping when possible.

Note, creating read-only mappings can be theoretically slower, as they
don't play nice with fast GUP due to the need to break CoW before mapping
the underlying PFN.  But practically speaking, creating a mapping isn't
a super hot path, and getting a writable mapping for reading is weird and
confusing.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  4 ++--
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
 include/linux/kvm_host.h  | 20 ++++++++++++++++++--
 virt/kvm/kvm_main.c       | 12 +++++++-----
 6 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d5314cb7dff4..9f9478bdecfc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -922,7 +922,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_svm_vmexit(svm);
=20
 out:
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	return ret;
 }
@@ -1126,7 +1126,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
=20
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	nested_svm_transition_tlb_flush(vcpu);
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0b851ef937f2..4557ff3804ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3468,7 +3468,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
=20
 	sev_es_sync_to_ghcb(svm);
=20
-	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map, true);
+	kvm_vcpu_unmap(&svm->vcpu, &svm->sev_es.ghcb_map);
 	svm->sev_es.ghcb =3D NULL;
 }
=20
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..c1e29307826b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2299,7 +2299,7 @@ static int vmload_vmsave_interception(struct kvm_vcpu=
 *vcpu, bool vmload)
 		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
 	}
=20
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	return ret;
 }
@@ -4714,7 +4714,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union=
 kvm_smram *smram)
 	svm_copy_vmrun_state(map_save.hva + 0x400,
 			     &svm->vmcb01.ptr->save);
=20
-	kvm_vcpu_unmap(vcpu, &map_save, true);
+	kvm_vcpu_unmap(vcpu, &map_save);
 	return 0;
 }
=20
@@ -4774,9 +4774,9 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const=
 union kvm_smram *smram)
 	svm->nested.nested_run_pending =3D 1;
=20
 unmap_save:
-	kvm_vcpu_unmap(vcpu, &map_save, true);
+	kvm_vcpu_unmap(vcpu, &map_save);
 unmap_map:
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map);
 	return ret;
 }
=20
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ff83b56fe2fa..259fe445e695 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -231,7 +231,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu=
 *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map);
 	vmx->nested.hv_evmcs =3D NULL;
 	vmx->nested.hv_evmcs_vmptr =3D EVMPTR_INVALID;
=20
@@ -318,9 +318,9 @@ static void nested_put_vmcs12_pages(struct kvm_vcpu *vc=
pu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
=20
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map);
 	vmx->nested.pi_desc =3D NULL;
 }
=20
@@ -624,7 +624,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct=
 kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 =3D vmx->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map msr_bitmap_map;
+	struct kvm_host_map map;
=20
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -647,10 +647,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(stru=
ct kvm_vcpu *vcpu,
 			return true;
 	}
=20
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &msr_bitmap_map))
+	if (kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &map))
 		return false;
=20
-	msr_bitmap_l1 =3D (unsigned long *)msr_bitmap_map.hva;
+	msr_bitmap_l1 =3D (unsigned long *)map.hva;
=20
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -714,7 +714,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct=
 kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
=20
-	kvm_vcpu_unmap(vcpu, &msr_bitmap_map, false);
+	kvm_vcpu_unmap(vcpu, &map);
=20
 	vmx->nested.force_msr_bitmap_recalc =3D false;
=20
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8739b905d85b..9263375d0362 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -285,6 +285,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool writable;
 };
=20
 /*
@@ -1312,8 +1313,23 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn=
_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *ma=
p);
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool =
dirty);
+
+int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *=
map,
+		   bool writable);
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map);
+
+static inline int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       struct kvm_host_map *map)
+{
+	return __kvm_vcpu_map(vcpu, gpa, map, true);
+}
+
+static inline int kvm_vcpu_map_readonly(struct kvm_vcpu *vcpu, gpa_t gpa,
+					struct kvm_host_map *map)
+{
+	return __kvm_vcpu_map(vcpu, gpa, map, false);
+}
+
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, b=
ool *writable);
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,=
 int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 40a59526d466..080740f65061 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3116,7 +3116,8 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
=20
-int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *ma=
p)
+int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *=
map,
+		   bool writable)
 {
 	struct kvm_follow_pfn kfp =3D {
 		.slot =3D gfn_to_memslot(vcpu->kvm, gfn),
@@ -3130,6 +3131,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, st=
ruct kvm_host_map *map)
 	map->page =3D NULL;
 	map->hva =3D NULL;
 	map->gfn =3D gfn;
+	map->writable =3D writable;
=20
 	map->pfn =3D kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(map->pfn))
@@ -3146,9 +3148,9 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, st=
ruct kvm_host_map *map)
=20
 	return map->hva ? 0 : -EFAULT;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_map);
+EXPORT_SYMBOL_GPL(__kvm_vcpu_map);
=20
-void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool =
dirty)
+void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
 {
 	if (!map->hva)
 		return;
@@ -3160,11 +3162,11 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct k=
vm_host_map *map, bool dirty)
 		memunmap(map->hva);
 #endif
=20
-	if (dirty)
+	if (map->writable)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
=20
 	if (map->pinned_page) {
-		if (dirty)
+		if (map->writable)
 			kvm_set_page_dirty(map->pinned_page);
 		kvm_set_page_accessed(map->pinned_page);
 		unpin_user_page(map->pinned_page);
--=20
2.47.0.rc1.288.g06298d1525-goog


