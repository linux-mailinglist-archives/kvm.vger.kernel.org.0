Return-Path: <kvm+bounces-28478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A93A4998FE3
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F0B31F262C0
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952411CF2A6;
	Thu, 10 Oct 2024 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c6ulq1H/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A0D1CEAA2
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584693; cv=none; b=M4aKr7vw9QNFBSuEr1iH92djg5JxyDxaJlLtqzWzm3PJ87Og6FXJKomTqrVm332WU0CTsiiwQocNijAl/Ti/GI1GwUN720bZgZC157RdYSNgNoyMoUPWCNr+4VdZPM43qLIuTysJHVSrq7mio9XJ9tLnJzq12ji9Pwmq/dFTcps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584693; c=relaxed/simple;
	bh=VeqAt9xsRyQYjwTyqnYEHFfSJqQO2zWoId1ssBiaEMk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JnCCt7zIB1e1jz15QP05RZX0DAewyf5YMAw4+VkeEXkNKaSPZ4zNXirKsd0mFIM8tWcnktAcztFuQMBpAZCoASG4TgB4AdRUsxcfHaynwNTkUaOY0S+E9xCSABZiAMJv+zONcNDa+zRUEBh3nX4VHjGRtG64Dncjv94tEJ9VX2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c6ulq1H/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2ebab7abfso157717a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584691; x=1729189491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Om/x5O1cFoCu45xFQlZl7muX4OGvvwFhFfu/OqGssvQ=;
        b=c6ulq1H/+SVkO3snwnEpIDv6c51AZwFPT1LwqFNCVv4NoGTlUIwMtlx2CGv4OolC4z
         5koadCL6jvV5FKPkcR7h2EcqLSGLIrxPFSpXWBBtr1Q7Qs67rbWfXAkZuygIXztR30jX
         vinelIxIHIA9mCJvKaK123LtWbg1NOboLMeiKUh0EpYwOSI95YlMnIXDtfqepFmlcWAS
         CnV3G1l9SuTBGmxsijDu+22rWmksmHX3fhLSJfqBck7S6jAczfD9MKD7ErhknpjpLCXD
         TxRiyYgzfFwgfGEmjn40VJXaAyNZX1rswlRL/erQ/34CTu9kx47GkXzSb8i1IPcncetk
         Akrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584691; x=1729189491;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Om/x5O1cFoCu45xFQlZl7muX4OGvvwFhFfu/OqGssvQ=;
        b=V4gsUK4qh/w3gz46/+2C7oCCXAAz7B1GCcwhJW7zGkIJtmxogdda4h6YPLt5kO0One
         TRqikKAysSaAw1J4RMMHStuTqjwiExkctwIyuZuEA4W+/3XOkoKtUzj0VUVH+nhDFQvn
         x1tMbcfybAQYY8r/kSgu54UPPOrWezI+iwVKS50yIGurmFEs3JEyP3rMsmOf4An0EwRQ
         DIMyJp64sRTk75UP3xaLn5k66If4zrM4RxsrpN8FWhRzf1G7DiSkY98odqietB02g176
         C8x8ZWWx8M3lnN4QizFgvITseWbKJj0R3ivmtFJY1o3uva0f8N6Gs4xK4yppowmP7s81
         0rnQ==
X-Gm-Message-State: AOJu0YxLj+8/bMuf7VfrI1JUnCLOdGth6tNvTTcBXLunciDeXTmDblDj
	90XlQS9G8+eiRc+yIMj/YHuyA2dmPYfHxp4MewINkIgdkpxvjWz2Vu16iXZVJZxWcuZtpW2f6ep
	v6g==
X-Google-Smtp-Source: AGHT+IG89v4lIFRhnNqxe9hFvIIxqDvldHGwH//6ib2L4odxYyk8SJA2JGOjXIHuxBeh8ylp7HgA6abaBbM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:eac4:b0:2e2:8f4d:457 with SMTP id
 98e67ed59e1d1-2e2c80b5015mr7266a91.2.1728584689990; Thu, 10 Oct 2024 11:24:49
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:03 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-2-seanjc@google.com>
Subject: [PATCH v13 01/85] KVM: Drop KVM_ERR_PTR_BAD_PAGE and instead return
 NULL to indicate an error
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

Remove KVM_ERR_PTR_BAD_PAGE and instead return NULL, as "bad page" is just
a leftover bit of weirdness from days of old when KVM stuffed a "bad" page
into the guest instead of actually handling missing pages.  See commit
cea7bb21280e ("KVM: MMU: Make gfn_to_page() always safe").

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c          |  2 +-
 arch/powerpc/kvm/book3s_xive_native.c |  2 +-
 arch/s390/kvm/vsie.c                  |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              |  7 -------
 virt/kvm/kvm_main.c                   | 15 ++++++---------
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 7b8ae509328f..d7721297b9b6 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -645,7 +645,7 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, st=
ruct kvmppc_pte *pte)
 	int i;
=20
 	hpage =3D gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (is_error_page(hpage))
+	if (!hpage)
 		return;
=20
 	hpage_offset =3D pte->raddr & ~PAGE_MASK;
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3=
s_xive_native.c
index 6e2ebbd8aaac..d9bf1bc3ff61 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -654,7 +654,7 @@ static int kvmppc_xive_native_set_queue_config(struct k=
vmppc_xive *xive,
 	}
=20
 	page =3D gfn_to_page(kvm, gfn);
-	if (is_error_page(page)) {
+	if (!page) {
 		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_err("Couldn't get queue page %llx!\n", kvm_eq.qaddr);
 		return -EINVAL;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 89cafea4c41f..763a070f5955 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -661,7 +661,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, h=
pa_t *hpa)
 	struct page *page;
=20
 	page =3D gfn_to_page(kvm, gpa_to_gfn(gpa));
-	if (is_error_page(page))
+	if (!page)
 		return -EINVAL;
 	*hpa =3D (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
 	return 0;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..20526e4d6c62 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2664,7 +2664,7 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 	}
=20
 	page =3D gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (is_error_page(page)) {
+	if (!page) {
 		ret =3D -EFAULT;
 		goto out;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db567d26f7b9..ee186a1fbaad 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -153,13 +153,6 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
 	return gpa =3D=3D INVALID_GPA;
 }
=20
-#define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
-
-static inline bool is_error_page(struct page *page)
-{
-	return IS_ERR(page);
-}
-
 #define KVM_REQUEST_MASK           GENMASK(7,0)
 #define KVM_REQUEST_NO_WAKEUP      BIT(8)
 #define KVM_REQUEST_WAIT           BIT(9)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..4b659a649dfa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3078,19 +3078,14 @@ EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	struct page *page;
 	kvm_pfn_t pfn;
=20
 	pfn =3D gfn_to_pfn(kvm, gfn);
=20
 	if (is_error_noslot_pfn(pfn))
-		return KVM_ERR_PTR_BAD_PAGE;
+		return NULL;
=20
-	page =3D kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return KVM_ERR_PTR_BAD_PAGE;
-
-	return page;
+	return kvm_pfn_to_refcounted_page(pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
=20
@@ -3184,7 +3179,8 @@ static void kvm_set_page_accessed(struct page *page)
=20
 void kvm_release_page_clean(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	if (WARN_ON(!page))
+		return;
=20
 	kvm_set_page_accessed(page);
 	put_page(page);
@@ -3208,7 +3204,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
=20
 void kvm_release_page_dirty(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	if (WARN_ON(!page))
+		return;
=20
 	kvm_set_page_dirty(page);
 	kvm_release_page_clean(page);
--=20
2.47.0.rc1.288.g06298d1525-goog


