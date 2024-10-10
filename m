Return-Path: <kvm+bounces-28560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEB799915F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A27D6B2A7FA
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6368921C179;
	Thu, 10 Oct 2024 18:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LR0bZlhg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0B421BAF5
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584870; cv=none; b=tVOwn3t0EE4Writ3zngKJvRzfZhT8SnZ181E4G04OxYTQnUg2yGIhPqlY7TtlC7ofm/X2rvlgiVIyVafQLK8HC0ewImPxbZijl9xRzGz9zlfpJz3PSR3kETCKc2yYuL3xdQ//SavOAfjB7OJ3HXjypXWchpPz40PgAspXWJMYzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584870; c=relaxed/simple;
	bh=4ce0ST1uTErGaf3Fu8uQPVTe9dXk8k7UaRtdo8iN0BA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qt5chIigUlgJ3widx395+swIXD/+80KFdBGvORaw21sM3aN+FtMgVY/Ai5EecBxbz4LZaH4VzX2ci3OYDXPOBjWMGM27ghYIkE7muwziNtgptSwbo7tjuTPs7/7V4Efa6Wh7EcRoUWPEFvyC2FcIfvl4w6V73qogKplxqVKLJV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LR0bZlhg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20b8bf5d09aso15617865ad.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584868; x=1729189668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYRk8t9w2U8aQ/ID4AWjouVrA1tdB4hWvcNmB/sB3HQ=;
        b=LR0bZlhgBqqlK/AxVHUnYDgdPVeVfg62ritjsHW4icLlp2VXJMdBEQpqQ2DjaOB4Vo
         BMk5u0CdNiJU47xxEKEBNDUg1VIzyKQFA0lEenO//nWQFutF6qqNsjqYWpd0KkluabCG
         scoWgGmVwMXCV2bJcO3DxVbQdljLpb0S7K+9zHipw5iopVLZ5O/Et9tquTm7UfUH/R3W
         Tzhi8J9rL8rJ6Zw+R2IdaOJPRXvC3k33WFcoS6zAsYYyRLTyXGYrquN21MhPyyOeIlNt
         k76iPpUznp7HqqlLd6wYwP+ZU1DkIHHgVTgrkh+gxlQpcl0jRX8rnB7ytNb8WRs+Wq5s
         9Kuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584868; x=1729189668;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qYRk8t9w2U8aQ/ID4AWjouVrA1tdB4hWvcNmB/sB3HQ=;
        b=pune3INggeQbIE3EMr6KqHZCNT21ic07/FmQViULbirWVvpb+wYxbMl77VTRCKHGoQ
         q/c9LvztEuzUhAgEHXUGealq7YLCEHdA45rvgWBQcDJKq2nzaR/QnvwIQ9+eGDa7+4fZ
         WK9stN2T4kiVwPwjhEIlTjLuQMgWyxQ8DxyLYh4l9a0bFaVHczXDkk2zmiis0aTV9ICi
         pCxo2hr7tTj7fYs+dRdcqluaRFoWkNE9GPfO5koqZ010cxzcDJO3/ZlTnPYV/2vAtEJX
         qxPndBy+jp9i1TaraItNeC9bhBWZuVp2oEP1tLFgVaHL8o1POfRmtYauMsjedt6fjvF6
         ePWw==
X-Gm-Message-State: AOJu0Yws9yI5FmADvSJqgNgMitJvzy6DsbtTNLSeyMQTdnM+BVjr61OE
	X94Yo3cK+4ul9hiTiaoxfc5hnmEa47s24tID0dzn/J9cM6mEYZHS3VnSO+By2P7tWhCxlXsZRf0
	svw==
X-Google-Smtp-Source: AGHT+IHfwq/leOSDpGNmElHsEevN2NLhktzxL5WWYsNV7s51yqV4fIBatX1NQsHzbv29AfLNcoyCuLVeClM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e745:b0:20c:857b:5dcb with SMTP id
 d9443c01a7336-20c857b62ffmr639275ad.4.1728584868183; Thu, 10 Oct 2024
 11:27:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:25 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-84-seanjc@google.com>
Subject: [PATCH v13 83/85] KVM: arm64: Don't mark "struct page" accessed when
 making SPTE young
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

Don't mark pages/folios as accessed in the primary MMU when making a SPTE
young in KVM's secondary MMU, as doing so relies on
kvm_pfn_to_refcounted_page(), and generally speaking is unnecessary and
wasteful.  KVM participates in page aging via mmu_notifiers, so there's no
need to push "accessed" updates to the primary MMU.

Dropping use of kvm_set_pfn_accessed() also paves the way for removing
kvm_pfn_to_refcounted_page() and all its users.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +---
 arch/arm64/kvm/hyp/pgtable.c         | 7 ++-----
 arch/arm64/kvm/mmu.c                 | 6 +-----
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/=
kvm_pgtable.h
index 03f4c3d7839c..aab04097b505 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -674,10 +674,8 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *p=
gt, u64 addr, u64 size);
  *
  * If there is a valid, leaf page-table entry used to translate @addr, the=
n
  * set the access flag in that entry.
- *
- * Return: The old page-table entry prior to setting the flag, 0 on failur=
e.
  */
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
=20
 /**
  * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the a=
ccess
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11bcebac908..40bd55966540 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1245,19 +1245,16 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable=
 *pgt, u64 addr, u64 size)
 					NULL, NULL, 0);
 }
=20
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
-	kvm_pte_t pte =3D 0;
 	int ret;
=20
 	ret =3D stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF=
, 0,
-				       &pte, NULL,
+				       NULL, NULL,
 				       KVM_PGTABLE_WALK_HANDLE_FAULT |
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
 		dsb(ishst);
-
-	return pte;
 }
=20
 struct stage2_age_data {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4054356c9712..e2ae9005e333 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1706,18 +1706,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_i=
pa)
 {
-	kvm_pte_t pte;
 	struct kvm_s2_mmu *mmu;
=20
 	trace_kvm_access_fault(fault_ipa);
=20
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu =3D vcpu->arch.hw_mmu;
-	pte =3D kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
 	read_unlock(&vcpu->kvm->mmu_lock);
-
-	if (kvm_pte_valid(pte))
-		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
 }
=20
 /**
--=20
2.47.0.rc1.288.g06298d1525-goog


