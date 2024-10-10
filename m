Return-Path: <kvm+bounces-28486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D81999020
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D7691C23EB2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFED11E9075;
	Thu, 10 Oct 2024 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YFnRBGee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B31E1E7C30
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584714; cv=none; b=HCyqXeujAcmAgyOt1ogJC8LgoyWfKFFxe3/B6lRMSme0653g1rJpIWeEKdT1zdiERZbudyboR8rgF/Wpv2YDEd2Tcn12eEBqH4msB7tHh7T1N6yj2g38LA9nngYutoig8theDIrb307rCm7aGcC2V2F0Mcnan9F55UJyRB9FIQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584714; c=relaxed/simple;
	bh=sB5G3PQtHd5Wp6fJfSwA75+Ou8nv+Xyz2zynkW7I+sM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jH76Q2fjg6OdH1x+Yt45xym5m+84Vmt4FaCSKyIIDROAvjpwYdF3NTh3daxkDCQvjUsLPubuRTesgNbrnd6EmBLCWjgojqDGgKRQBiObyNcv+1D4uDIzMWrv0Q7TaGgQlzzYWbwDLUNaT7B9LXwVpNj8fyRAVNi/7cbryidl5B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YFnRBGee; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2baf2ff64so22478437b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584711; x=1729189511; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ix/Xs4/Qn/2DvOT3Bh000Q598gzWwOGIiO61AJ4Bto=;
        b=YFnRBGeeymk+2pmMBdw0wl0Yy+Pdr75lMEEb46Qj2R/ZMELxdBUC0VhXMaFoLMRZyw
         lM5BZATdJOfXIHC7Ufn9e5g1CVYCsM89XBgpEbeWnjle3YVc0JrKT5IY3d3WFOKNc03i
         tQo8sG3IUbpyxFHlOMrb7ZHLDldQnJqNa2RjhIHLewNO7ZU5NmsXMw8G548D7wuNl5BX
         KAXxb5IgcpvzTluv7+tQS9iUf8SuC1dnEWalfACIcBmgOeNyW3QjD8rsI9do0p1/7fwV
         MXEidCQsM6goBjTy2GmzJ7UCSunVjhh4Ev1K313o4BihBPVtWlNKHeeWHalpT8ZOONki
         6nMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584711; x=1729189511;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ix/Xs4/Qn/2DvOT3Bh000Q598gzWwOGIiO61AJ4Bto=;
        b=mZRZUewcBqft2qdbgI0nUIEuN/TXUGCdtHOj3LQp5OPIM2inVtzGWOFhbs81KGqLMB
         vQHPrYSPzfKKYk9QD+LNKXusYww2l29NsRSJKC9KVIob7cwKoY0UuBLLzHYwLDnGU69n
         YU5RNyz9WqtlPJhLTOKM5z0GkogCmv0uTb6HJLhNeQFXdeA/aoB3ob0qB+TKcsth1Cd3
         EMqkCEtKa61TWKF45smAl/JYclpAVyKVicy3WhW3nrPV4CZyJbAM0XGXBNGmXAK2PnaK
         s0zbjzmLU1vrsafu1fgL/Eq2AG/LB9HkAQFYeSBgzqbiIwl1FukmUxASHUfmdaq3//Qw
         aAHw==
X-Gm-Message-State: AOJu0YxT9f/iSLaexNy8QHWjf+mG1OqxMvMIlPHbJtxD/duahUkWHcqu
	6sVJRrwji+il1aQ+diy77LXMSitaGuctEozFHAgEMsew3Tg5KxGcXgzSNCpqlrb35Y1sTc17g5R
	Dmw==
X-Google-Smtp-Source: AGHT+IGD2TfP2dloLIlDYfRlI1lvmWPD7YUtu8EYW3dxRXY7JxJbZQIAJnuRF8jcBfCYGhk25T1qJs7AAuY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5b41:b0:6db:c6ac:62a0 with SMTP id
 00721157ae682-6e322305467mr243067b3.5.1728584711093; Thu, 10 Oct 2024
 11:25:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:11 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-10-seanjc@google.com>
Subject: [PATCH v13 09/85] KVM: x86/mmu: Mark page/folio accessed only when
 zapping leaf SPTEs
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

Now that KVM doesn't clobber Accessed bits of shadow-present SPTEs,
e.g. when prefetching, mark folios as accessed only when zapping leaf
SPTEs, which is a rough heuristic for "only in response to an mmu_notifier
invalidation".  Page aging and LRUs are tolerant of false negatives, i.e.
KVM doesn't need to be precise for correctness, and re-marking folios as
accessed when zapping entire roots or when zapping collapsible SPTEs is
expensive and adds very little value.

E.g. when a VM is dying, all of its memory is being freed; marking folios
accessed at that time provides no known value.  Similarly, because KVM
marks folios as accessed when creating SPTEs, marking all folios as
accessed when userspace happens to delete a memslot doesn't add value.
The folio was marked access when the old SPTE was created, and will be
marked accessed yet again if a vCPU accesses the pfn again after reloading
a new root.  Zapping collapsible SPTEs is a similar story; marking folios
accessed just because userspace disable dirty logging is a side effect of
KVM behavior, not a deliberate goal.

As an intermediate step, a.k.a. bisection point, towards *never* marking
folios accessed when dropping SPTEs, mark folios accessed when the primary
MMU might be invalidating mappings, as such zappings are not KVM initiated,
i.e. might actually be related to page aging and LRU activity.

Note, x86 is the only KVM architecture that "double dips"; every other
arch marks pfns as accessed only when mapping into the guest, not when
mapping into the guest _and_ when removing from the guest.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 76 +++++++++++++++---------------
 arch/x86/kvm/mmu/mmu.c             |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c         |  7 ++-
 3 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/lo=
cking.rst
index 20a9a37d1cdd..3d8bf40ca448 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -147,49 +147,51 @@ Then, we can ensure the dirty bitmaps is correctly se=
t for a gfn.
=20
 2) Dirty bit tracking
=20
-In the origin code, the spte can be fast updated (non-atomically) if the
+In the original code, the spte can be fast updated (non-atomically) if the
 spte is read-only and the Accessed bit has already been set since the
 Accessed bit and Dirty bit can not be lost.
=20
 But it is not true after fast page fault since the spte can be marked
 writable between reading spte and updating spte. Like below case:
=20
-+------------------------------------------------------------------------+
-| At the beginning::                                                     |
-|                                                                        |
-|	spte.W =3D 0                                                       |
-|	spte.Accessed =3D 1                                                |
-+------------------------------------+-----------------------------------+
-| CPU 0:                             | CPU 1:                            |
-+------------------------------------+-----------------------------------+
-| In mmu_spte_clear_track_bits()::   |                                   |
-|                                    |                                   |
-|  old_spte =3D *spte;                 |                                  =
 |
-|                                    |                                   |
-|                                    |                                   |
-|  /* 'if' condition is satisfied. */|                                   |
-|  if (old_spte.Accessed =3D=3D 1 &&     |                                =
   |
-|       old_spte.W =3D=3D 0)             |                                =
   |
-|     spte =3D 0ull;                   |                                  =
 |
-+------------------------------------+-----------------------------------+
-|                                    | on fast page fault path::         |
-|                                    |                                   |
-|                                    |    spte.W =3D 1                    =
 |
-|                                    |                                   |
-|                                    | memory write on the spte::        |
-|                                    |                                   |
-|                                    |    spte.Dirty =3D 1                =
 |
-+------------------------------------+-----------------------------------+
-|  ::                                |                                   |
-|                                    |                                   |
-|   else                             |                                   |
-|     old_spte =3D xchg(spte, 0ull)    |                                  =
 |
-|   if (old_spte.Accessed =3D=3D 1)      |                                =
   |
-|     kvm_set_pfn_accessed(spte.pfn);|                                   |
-|   if (old_spte.Dirty =3D=3D 1)         |                                =
   |
-|     kvm_set_pfn_dirty(spte.pfn);   |                                   |
-|     OOPS!!!                        |                                   |
-+------------------------------------+-----------------------------------+
++-------------------------------------------------------------------------=
+
+| At the beginning::                                                      =
|
+|                                                                         =
|
+|	spte.W =3D 0                                                            =
  |
+|	spte.Accessed =3D 1                                                     =
  |
++-------------------------------------+-----------------------------------=
+
+| CPU 0:                              | CPU 1:                            =
|
++-------------------------------------+-----------------------------------=
+
+| In mmu_spte_update()::              |                                   =
|
+|                                     |                                   =
|
+|  old_spte =3D *spte;                  |                                 =
  |
+|                                     |                                   =
|
+|                                     |                                   =
|
+|  /* 'if' condition is satisfied. */ |                                   =
|
+|  if (old_spte.Accessed =3D=3D 1 &&      |                               =
    |
+|       old_spte.W =3D=3D 0)              |                               =
    |
+|     spte =3D new_spte;                |                                 =
  |
++-------------------------------------+-----------------------------------=
+
+|                                     | on fast page fault path::         =
|
+|                                     |                                   =
|
+|                                     |    spte.W =3D 1                   =
  |
+|                                     |                                   =
|
+|                                     | memory write on the spte::        =
|
+|                                     |                                   =
|
+|                                     |    spte.Dirty =3D 1               =
  |
++-------------------------------------+-----------------------------------=
+
+|  ::                                 |                                   =
|
+|                                     |                                   =
|
+|   else                              |                                   =
|
+|     old_spte =3D xchg(spte, new_spte);|                                 =
  |
+|   if (old_spte.Accessed &&          |                                   =
|
+|       !new_spte.Accessed)           |                                   =
|
+|     flush =3D true;                   |                                 =
  |
+|   if (old_spte.Dirty &&             |                                   =
|
+|       !new_spte.Dirty)              |                                   =
|
+|     flush =3D true;                   |                                 =
  |
+|     OOPS!!!                         |                                   =
|
++-------------------------------------+-----------------------------------=
+
=20
 The Dirty bit is lost in this case.
=20
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ae823ebd12b..04228a7da69a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -542,10 +542,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	 * to guarantee consistency between TLB and page tables.
 	 */
=20
-	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
+	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte))
 		flush =3D true;
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-	}
=20
 	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
 		flush =3D true;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 517b384473c1..8aa0d7a7602b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -520,10 +520,6 @@ static void handle_changed_spte(struct kvm *kvm, int a=
s_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-
-	if (was_leaf && is_accessed_spte(old_spte) &&
-	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
=20
 static inline int __must_check __tdp_mmu_set_spte_atomic(struct tdp_iter *=
iter,
@@ -865,6 +861,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct k=
vm_mmu_page *root,
=20
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
=20
+		if (is_accessed_spte(iter.old_spte))
+			kvm_set_pfn_accessed(spte_to_pfn(iter.old_spte));
+
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
 		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
--=20
2.47.0.rc1.288.g06298d1525-goog


