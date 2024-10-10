Return-Path: <kvm+bounces-28489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2266499903B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F4691F21A6F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FDF1EBA08;
	Thu, 10 Oct 2024 18:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eihI10jr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2F1E909B
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584721; cv=none; b=UDU428xbvkGEH1tVq6LrmCWPuBNQVZxCA6vgfCgHDZlHyZ/mQAH5c3lemI/yjR7mfyyehekyzv3NBeSLQ8An3qs9Ty8Oca5g4A0PGlaWu2RhVlbRnPz2TwTHlIuuuWnU471K6952NCz3IppGmam+qm7GIj6mtlMepwvoJ3At5rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584721; c=relaxed/simple;
	bh=NgBQk0YRvUNmc13dbVZlntKigL70MLaajTeU3NGo9fA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RE/TO0Qh1KOren6uFokyP9Zyx1hCuGPJdLuhHw0ckqiaZBNGdTc2IXycR+bsws8ZiMCerWF3Bn9MEmVZexcIKrdJPirw7WYA6X1f2yM2i4EbJ/BQv5bVpsDoxIOLMuMoFDz00XSJx0kVKvTgf82Y2dy6AFQdVjBPdRwhrG9HW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eihI10jr; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71df5102bc0so1345460b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584717; x=1729189517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMk6Ksq+DkJF8Cmr0W3poBl1lc0GSthNwEC5P5onZMQ=;
        b=eihI10jru2n8ukWDIrc4V1BUWuR7kg0e1MklavXglc6950CPFgvqStVWPROKStYTp3
         hNXNXKKlqyzDuLLGxwwWxlgdHdmPGCfXDNUg1NmPaTS44X9jIVXe/ExDP544smBEGPaF
         hk8AtmMAPGvv8BKjmHvXS6tiKMnZmeVClyLoX/BaV/Blwx/GCI6B2Yu3V02I2crBiNsk
         1u0NCDnwPePOmtM2eaOQH2672Om7WlhN2DEagdo+me81XgGdIVBDEjPXYHoKNWdjMqCl
         Z1oc4pvNwUbuOmrWza21vh57XnX3eqw7MGRoIVnvl5bwzDuQdR41ncqUkNktv/loOESb
         L5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584717; x=1729189517;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IMk6Ksq+DkJF8Cmr0W3poBl1lc0GSthNwEC5P5onZMQ=;
        b=wy5ot9UQkzbYwr3OsGKhqeNzm90mUY+NxhpfDwjOElmRoT6nnQcxHGxARRVtbb6hAh
         nsb0/mbFQN7yWwFT88QQTYh95CKUpaxsUqFfdBF4FAfqEhB6IAKiFD0b1CQ6kibDGnHW
         hGiQcsKELrOGbY8ggz+8Vme5Lu+vkTR32rqTZfvLpeVsOh0aczCtq4WQMAURnL+vSiQR
         U4QtC+7TMIKp5+asx9eFQESGZbIRYQ5XIhMsbSecJYllbv8zPQCBPIoUo4jxBIoB1cd+
         8qJpIi0QFXataqAD9ee+pA5+HiYb3tWP+3X/v2UppYKJSs2BfdWNVbMxLPBS1zCO/Rdz
         uzpQ==
X-Gm-Message-State: AOJu0YyfNG5PpJb20mgyMV4OR9h4iw5vBqArmw4SK+6Hmhq8Hu6RoDR1
	xYkSw9EY9VKcPRwhvvK//i/jKYW44Yj3a4aFtIo7j16BdqIwxdj8Ds0Pzq8slX29liXwb5AwpZc
	mjg==
X-Google-Smtp-Source: AGHT+IEgBAPk5NggidzeRIz4/KASJ69N4B17cGxFjG2BQTaLRrpMtimTBEcirbwLQ+H7ew0HtHwcTgFgXoI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8a:b0:71d:fc7c:4a34 with SMTP id
 d2e1a72fcca58-71e1dbff219mr24371b3a.6.1728584717336; Thu, 10 Oct 2024
 11:25:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:14 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-13-seanjc@google.com>
Subject: [PATCH v13 12/85] KVM: Drop @atomic param from gfn=>pfn and hva=>pfn APIs
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

Drop @atomic from the myriad "to_pfn" APIs now that all callers pass
"false", and remove a comment blurb about KVM running only the "GUP fast"
part in atomic context.

No functional change intended.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst     |  4 +--
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 12 ++++----
 include/linux/kvm_host.h               |  4 +--
 virt/kvm/kvm_main.c                    | 39 ++++++--------------------
 virt/kvm/kvm_mm.h                      |  4 +--
 virt/kvm/pfncache.c                    |  2 +-
 9 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/lo=
cking.rst
index 3d8bf40ca448..f463ac42ac7a 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -135,8 +135,8 @@ We dirty-log for gfn1, that means gfn2 is lost in dirty=
-bitmap.
 For direct sp, we can easily avoid it since the spte of direct sp is fixed
 to gfn.  For indirect sp, we disabled fast page fault for simplicity.
=20
-A solution for indirect sp could be to pin the gfn, for example via
-kvm_vcpu_gfn_to_pfn_atomic, before the cmpxchg.  After the pinning:
+A solution for indirect sp could be to pin the gfn before the cmpxchg.  Af=
ter
+the pinning:
=20
 - We have held the refcount of pfn; that means the pfn can not be freed an=
d
   be reused for another gfn.
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a509b63bd4dd..a6e62cc9015c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1569,7 +1569,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
=20
-	pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+	pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 				   write_fault, &writable, NULL);
 	if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_=
64_mmu_hv.c
index 1b51b1c4713b..8cd02ca4b1b8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -613,7 +613,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok =3D true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+		pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book=
3s_64_mmu_radix.c
index 408d98f8a514..26a969e935e3 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -852,7 +852,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcp=
u,
 		unsigned long pfn;
=20
 		/* Call KVM generic code to do the slow-path check */
-		pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
+		pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5fe45ab0e818..0e235f276ee5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4380,9 +4380,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 		return kvm_faultin_pfn_private(vcpu, fault);
=20
 	async =3D false;
-	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, false=
,
-					  &async, fault->write,
-					  &fault->map_writable, &fault->hva);
+	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, &asyn=
c,
+					  fault->write, &fault->map_writable,
+					  &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
=20
@@ -4402,9 +4402,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
-					  NULL, fault->write,
-					  &fault->map_writable, &fault->hva);
+	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, NULL,
+					  fault->write, &fault->map_writable,
+					  &fault->hva);
 	return RET_PF_CONTINUE;
 }
=20
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 56e7cde8c8b8..2faafc7a56ae 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1232,9 +1232,8 @@ kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn=
);
-kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gf=
n_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t g=
fn,
-			       bool atomic, bool interruptible, bool *async,
+			       bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva);
=20
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
@@ -1315,7 +1314,6 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
=20
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn=
_t gfn);
-kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *ma=
p);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool =
dirty);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 957b4a6c9254..0bc077213d3e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2756,8 +2756,7 @@ static inline int check_user_page_hwpoison(unsigned l=
ong addr)
=20
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
- * true indicates success, otherwise false is returned.  It's also the
- * only part that runs if we can in atomic context.
+ * true indicates success, otherwise false is returned.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
@@ -2922,7 +2921,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal sig=
nals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
@@ -2934,22 +2932,16 @@ static int hva_to_pfn_remapped(struct vm_area_struc=
t *vma,
  * 2): @write_fault =3D false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
+		     bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	int npages, r;
=20
-	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
-
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
=20
-	if (atomic)
-		return KVM_PFN_ERR_FAULT;
-
 	npages =3D hva_to_pfn_slow(addr, async, write_fault, interruptible,
 				 writable, &pfn);
 	if (npages =3D=3D 1)
@@ -2986,7 +2978,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic,=
 bool interruptible,
 }
=20
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t g=
fn,
-			       bool atomic, bool interruptible, bool *async,
+			       bool interruptible, bool *async,
 			       bool write_fault, bool *writable, hva_t *hva)
 {
 	unsigned long addr =3D __gfn_to_hva_many(slot, gfn, NULL, write_fault);
@@ -3008,39 +3000,24 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_mem=
ory_slot *slot, gfn_t gfn,
 		writable =3D NULL;
 	}
=20
-	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
-			  writable);
+	return hva_to_pfn(addr, interruptible, async, write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
=20
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
+				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
=20
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn=
)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
=20
-kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gf=
n_t gfn)
-{
-	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
-
-kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn)=
;
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
-
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..a3fa86f60d6c 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -20,8 +20,8 @@
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
=20
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-		     bool *async, bool write_fault, bool *writable);
+kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
+		     bool write_fault, bool *writable);
=20
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..58c706a610e5 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -198,7 +198,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 		}
=20
 		/* We always request a writeable mapping */
-		new_pfn =3D hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
+		new_pfn =3D hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			goto out_error;
=20
--=20
2.47.0.rc1.288.g06298d1525-goog


