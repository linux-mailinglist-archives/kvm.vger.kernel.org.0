Return-Path: <kvm+bounces-28488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E6F99902D
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6ACE71C247F1
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1C51EB9F9;
	Thu, 10 Oct 2024 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="msluruMB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA5D1EABA1
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584718; cv=none; b=FSYb+HQ6/yKt4pMU6Rgs2yMZjpECHEC7iHO33UdxY7+YIy5nyq7cNROpz3g7R2WBf/b3uG8N9TNic3L349cvCWT6ovGEN4OIGBxnSvPBcM4BnKncrVKn+P8Vt5k53MR/XJRFpz+ggx7e9fENney6+DTcrJ97Nv9CIU/3kzfTEfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584718; c=relaxed/simple;
	bh=bXBvqUXIo6rFfz7xJp3m3CL9RbZG3WivseimjKRiNcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fk0SCoUi1jnvEh9LNTGHD2Zvy2/juqq0o5piLwDCKmmwOPcivMAJYf7X3q3MbhLzPAkIOs8EKhs9bZnBPwmTcuhBxg48kjduSasoLGNwEVdcx/+KZGDJtc4vYNO3ziXs3AA/mCNVFaPQRCVzbG3uhRWSrguH2VRNhVUJcy7cy3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=msluruMB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20b921fa133so13291585ad.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584715; x=1729189515; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDoARMTIexYqUKDMQLAC2OQWFTeknat7PpvqQx990/M=;
        b=msluruMB47yV+eMqqJKQqQc3MtTMadYZ8sWgl6QRmMr09qa3+feEPjjvGyBY+uif8W
         qpS0VwqWhyL0czQJzqH+B9niYon2tyJam8T8Wx431OsNSh0byA40a4gCFG9E/iQ4vl7a
         6UoZSJP5zfbt83Sm9xMLY1LQdgh7R2IqI7So3Y4ciWiXWgSST91zKUp2NWSuxui2Udu2
         XYV5f67I+k1MuchiObUt1AkpUZwZ9d/5lXZxbM2nMVGYJ3xTOCQSP/NlphrkSb4KDTES
         lsmR21Ah+UemyDSlKJ7g2DcTy675DQzG6u8F3vgdUqFS9ZvBqFBbQWAyPrrqdAw2BlVR
         7WoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584715; x=1729189515;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WDoARMTIexYqUKDMQLAC2OQWFTeknat7PpvqQx990/M=;
        b=pFNgBz2vhBff625W+m3AevMdoJ4T3G14v6VcVNA5m+Zb82Fn8aOj9eSkhrB4SGUssQ
         DlwLB/V/s0cZKPMChvf2Jn3i0HYsAM4eCKMtrVxi4HFmAAhpW4SL7PHXTUCa/Om4OZAl
         CW1Un7mcYQyXB9ZR3Q1dBbYpY2NqTfGkhCSAvIwPdwwyrJdg1KXT/rRRsQS8XOqp0Rcl
         pg7gkixixjjtRbcqErbYB/9SqI+3foyaSn4lHDloyE98KyNQHne6HY7bZybT93uN2JOo
         1UlDQ0sZVaQyp/iqYCuT2qIcIcZp+lcNgzeZk1WbxB/o9kp7G3NOBG54tZ+ji5kTDJJy
         wTgQ==
X-Gm-Message-State: AOJu0YxCPkt/lLiGdX0U5vncykVWny4XNjZfDoCYPLdery+9NtqzDHIh
	A5AwnVA976vtOZXzYnc7fEKXsPh4y6DE35XvuEFv+LGqPkSOWl/Qdfc+Y5ZJ4U0X1B6zI+oUCOt
	rDA==
X-Google-Smtp-Source: AGHT+IFdLsiMiQR9ssEjYgvfJ+TOiOlvv8h202qp7bAbI4MCMFrC9IRsz+IufRcGyfoerq3Ms7MkoMKw8Uo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:f143:b0:20c:5beb:9c6a with SMTP id
 d9443c01a7336-20c80510505mr43225ad.4.1728584715291; Thu, 10 Oct 2024 11:25:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:13 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-12-seanjc@google.com>
Subject: [PATCH v13 11/85] KVM: Rename gfn_to_page_many_atomic() to kvm_prefetch_pages()
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

Rename gfn_to_page_many_atomic() to kvm_prefetch_pages() to try and
communicate its true purpose, as the "atomic" aspect is essentially a
side effect of the fact that x86 uses the API while holding mmu_lock.
E.g. even if mmu_lock weren't held, KVM wouldn't want to fault-in pages,
as the goal is to opportunistically grab surrounding pages that have
already been accessed and/or dirtied by the host, and to do so quickly.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 include/linux/kvm_host.h       | 4 ++--
 virt/kvm/kvm_main.c            | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04228a7da69a..5fe45ab0e818 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2958,7 +2958,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *=
vcpu,
 	if (!slot)
 		return -1;
=20
-	ret =3D gfn_to_page_many_atomic(slot, gfn, pages, end - start);
+	ret =3D kvm_prefetch_pages(slot, gfn, pages, end - start);
 	if (ret <=3D 0)
 		return -1;
=20
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 36b2607280f0..143b7e9f26dc 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -549,7 +549,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_=
mmu_page *sp,
 	if (!slot)
 		return false;
=20
-	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) !=3D 1)
+	if (kvm_prefetch_pages(slot, gfn, &page, 1) !=3D 1)
 		return false;
=20
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab4485b2bddc..56e7cde8c8b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1207,8 +1207,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
=20
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages);
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages);
=20
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2032292df0b0..957b4a6c9254 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3053,8 +3053,8 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, =
gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
=20
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages)
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages)
 {
 	unsigned long addr;
 	gfn_t entry =3D 0;
@@ -3068,7 +3068,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *s=
lot, gfn_t gfn,
=20
 	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
 }
-EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
+EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
=20
 /*
  * Do not use this helper unless you are absolutely certain the gfn _must_=
 be
--=20
2.47.0.rc1.288.g06298d1525-goog


