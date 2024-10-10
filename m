Return-Path: <kvm+bounces-28559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F04999149
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3B591C2087C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202D821BB14;
	Thu, 10 Oct 2024 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AchV74I+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B7121B45E
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584869; cv=none; b=DCbsClYM1JyLOqJV5x4b2AZt+jvU0pthB5ulnQWx7ZF1H7A3TZ6A1avlAoqHVLHdQLVXGCcQ8GCF0M/6PI8kteuBEDvhxscH4rZiH0OkfoMOeK1n9VRATIKpW0gAkfv6/4m5X6o2Anf3Dn79HKT4WasQ8g6FCZfzsAzJ+jDpjl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584869; c=relaxed/simple;
	bh=PnrPzaCfKEgiP1btOoqWv8SGAKP2OnxCXZvE+imIcuc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vt9kouPJy7S6NYYDPehzF7xGccgoPmEyu75gaL2LXgF71vj0PjpMxJQnWe/mUh43Ht6h0Q3yci4OGIFBXhFbEPkQbiu92UvVTUNR7+ehfVX7tl57sm2IbEg3Zk4SOEqtGbQ4FocWl8f9RCHRnKIvU8JGCn/C7Z4uaKM8c7b+nps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AchV74I+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2e5e376fcso26578367b3.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584866; x=1729189666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0R/snR1lBsefu+Gd9v26W9gBjpskR/lINZXMlcZUSs=;
        b=AchV74I+JHnLrzKw1CnNCcRL41wNv//gHQc4NBTbfpjxRDy9PpJE1B/SqMD9myx1R0
         mVHR+P8bSOu3/Oz7lQ1hgUtN9RY36X8gOczJcSEzTD6A4XAuLIdAiocO1EWVeSzm/4NK
         iNG3yhnElAt6f+kb1qQgRYpbE90dKeTPD0ImYwKFpZwH+xttYCi4J3DbFBX+y8+g6m/J
         qSa67DktV6zF5OIY/4SFr42+hJi/UbFrb3E+c81xKI47QPmXP/2WartrnYvjKaDYHUd5
         jRzI+lw3Ax3tYbLNUtXYTLdiL9GbDm/+hYmfVoG+Cx077QveQVOlUtcb0lxUp1GhD1cL
         Ji/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584866; x=1729189666;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l0R/snR1lBsefu+Gd9v26W9gBjpskR/lINZXMlcZUSs=;
        b=JJ5p1UulIfed2shpz4nn2MkeW4V1HNYH3yWqRQmJvCdLPhmXQEZRZfTi/t0IdMA+bI
         af7pUNTn/itUNHSWO7CRaEoFDgrxPs9KAI5hcZubq31g9N6DcmkTP/r3yMj/qwfI/TxM
         jcFVDwLl01foyI+4+2jBaV4+yc2SuMi5A46htZ/2j7k5Vw1s47x+PWiEYzM3JkG9MK4j
         xr6sl5s4tQxZwkpr8TiQDHkLPQGpx5baSGTOCsRDELF0Pgt06DavTLGjzo9YKDE2gBFN
         f6/YaUncCEdoXnpRPC9N1YdtS3xWdVOnn3E3gWGFYJxSWbdipDg/UNvdRRKiKkNRJ+nT
         T03g==
X-Gm-Message-State: AOJu0Yyfmhp+cTKfvihA9UAD6xDEwoRQLl0kpW/yZldelaShM1NcMLQ9
	7DxjXeLRviMEfC6J5/uIOkyJv69eH2gBFQ7wTkebYMW0hMglLewahreyAU2e5YmUmxmPxgQJd78
	5tQ==
X-Google-Smtp-Source: AGHT+IE49fRlqLzz+ddXUJ4fW719WQNIEaF+exc+KxAZEodOOT6YKCh59uZdX+xzyPwnVHJ15Mb6QwFZ+jU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:470f:b0:6e3:39e5:f0e8 with SMTP id
 00721157ae682-6e339e5f461mr119227b3.6.1728584866570; Thu, 10 Oct 2024
 11:27:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:24 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-83-seanjc@google.com>
Subject: [PATCH v13 82/85] KVM: x86/mmu: Don't mark "struct page" accessed
 when zapping SPTEs
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

Don't mark pages/folios as accessed in the primary MMU when zapping SPTEs,
as doing so relies on kvm_pfn_to_refcounted_page(), and generally speaking
is unnecessary and wasteful.  KVM participates in page aging via
mmu_notifiers, so there's no need to push "accessed" updates to the
primary MMU.

And if KVM zaps a SPTe in response to an mmu_notifier, marking it accessed
_after_ the primary MMU has decided to zap the page is likely to go
unnoticed, i.e. odds are good that, if the page is being zapped for
reclaim, the page will be swapped out regardless of whether or not KVM
marks the page accessed.

Dropping x86's use of kvm_set_pfn_accessed() also paves the way for
removing kvm_pfn_to_refcounted_page() and all its users.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 17 -----------------
 arch/x86/kvm/mmu/tdp_mmu.c |  3 ---
 2 files changed, 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5acdaf3b1007..55eeca931e23 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -559,10 +559,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  */
 static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 {
-	kvm_pfn_t pfn;
 	u64 old_spte =3D *sptep;
 	int level =3D sptep_to_sp(sptep)->role.level;
-	struct page *page;
=20
 	if (!is_shadow_present_pte(old_spte) ||
 	    !spte_has_volatile_bits(old_spte))
@@ -574,21 +572,6 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, =
u64 *sptep)
 		return old_spte;
=20
 	kvm_update_page_stats(kvm, level, -1);
-
-	pfn =3D spte_to_pfn(old_spte);
-
-	/*
-	 * KVM doesn't hold a reference to any pages mapped into the guest, and
-	 * instead uses the mmu_notifier to ensure that KVM unmaps any pages
-	 * before they are reclaimed.  Sanity check that, if the pfn is backed
-	 * by a refcounted page, the refcount is elevated.
-	 */
-	page =3D kvm_pfn_to_refcounted_page(pfn);
-	WARN_ON_ONCE(page && !page_count(page));
-
-	if (is_accessed_spte(old_spte))
-		kvm_set_pfn_accessed(pfn);
-
 	return old_spte;
 }
=20
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8aa0d7a7602b..91caa73a905b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -861,9 +861,6 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct k=
vm_mmu_page *root,
=20
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
=20
-		if (is_accessed_spte(iter.old_spte))
-			kvm_set_pfn_accessed(spte_to_pfn(iter.old_spte));
-
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
 		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
--=20
2.47.0.rc1.288.g06298d1525-goog


