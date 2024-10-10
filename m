Return-Path: <kvm+bounces-28555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B89D99913A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A1571F23AA6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D329219CA9;
	Thu, 10 Oct 2024 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rVwSkyMU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DEA2194AC
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584860; cv=none; b=aDpfFcdFzLKZX9WLpWCOhh4gtmZBC4oGpzzdX8mDiwVZY0Tv8Ba658mmTIhxzi8jsAECRTLh7JEu15oZBlWwkY/6UQp8Jv/B8X8lZpSJzRsZLx2O6MlJJO5agCHfSMqj/vqs6+lPWR1Sa/dAiq0gryzJjbsDMhnFXJghQvcckqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584860; c=relaxed/simple;
	bh=WU2bYG9iOpd2mUwv0Kp3QHVdfdxFDeft8vY+L5Knm2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uGqJmrcRUknU1k66/+3iopImUChGAK5vtYCYl1aFqkr4z6SwRy1QwIIaliUwn0h851YSAHPHQR6/2gf0Qigi0m9TipuBCkgPiqmO0VltnfAsfYTRvT5ch0vQQKuDMFVtj66SBorVi/BE49YeZRHSvWL6cQiN4xBYDPlFw/ChIOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rVwSkyMU; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1173934a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584858; x=1729189658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=43Dd+lWRPu/QQcFLGDLhCyyiH7uAqu5vbmltTcj5okg=;
        b=rVwSkyMURh+jnY5mhdfmEcQccS8IDp53PkuungLNC+QuxTGyFwJnXYuV4KpMgc91FZ
         bFvRWLz6gCAuL8I4pFdUmjoij8nlXt+RkgsWY/Ra7wXd/1Wau2HIby3umw7iSRAB2EmN
         ut+5qUUcerlx01e/0fA02Swap/VPizSrvEggtnZUOJ3WrTusH7oqshsyTmbh3f+dI20n
         uyRVKZBCTZawUdXzMhX2Ok6XvgFbIG0mVs+37d+uWqG7tQt6n6PSxhsbtHnD6bpftV5j
         rLI2JXT2gaMRXtSRAfpKWNB6WrSgK1uzbqCfQX+rH4CoQXpbwXxDDS5Cl51S6vCpTwBp
         n5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584858; x=1729189658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=43Dd+lWRPu/QQcFLGDLhCyyiH7uAqu5vbmltTcj5okg=;
        b=KRsuCY6+WPf9teXzhhMIrZewJNzrF5GohJhaYof56tCnyw26hizGQqVc7/JixJAz6c
         vX6NGbZZiVPiewSv/eV8yGjD2aMBNoy0Ls9vqGKlop4//4Jsa9nWA4X0PHJ785FZ7xC6
         d4sDknm+YdzoFjikamabvfpqSyVRn4OwEy28Pa77w3leGx2wwoltpF1funrW8VN6D3FB
         9n3TiygneX7nrRM2/TbqtQDzaXHGbGmHtN65nrT0snbt5Ul/QttU4i7/qin9c2V+RwQ0
         KABjVMbT5W3TUB0DFP6C2aCbONXcfUC13pkWuDzgi5oDIJ5MuJzPZr9cYt3BYL8WH3se
         i42g==
X-Gm-Message-State: AOJu0YyMKuuIpu/Z/RLMN6HGwK1mZarqbtYciKVM5p3nxeAPgATK3icy
	AW+4ICesU/bhJo/ORcrvPsEodHkVDioZKbv/Wazj9V4BO63NmvCsoOIXDZQtIejfOTazA0jDZ/H
	ZlA==
X-Google-Smtp-Source: AGHT+IGjs5y0lK7jvR8/zbNWJNDHfDWRUWSPa98vwOnU2bZ6sNQJgoH/6j7HDiYxyC+lHu033MhghQMujcY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:b208:0:b0:7e6:c3f2:24c2 with SMTP id
 41be03b00d2f7-7ea535dce6cmr30a12.6.1728584857741; Thu, 10 Oct 2024 11:27:37
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:20 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-79-seanjc@google.com>
Subject: [PATCH v13 78/85] KVM: PPC: Explicitly require struct page memory for
 Ultravisor sharing
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

Explicitly require "struct page" memory when sharing memory between
guest and host via an Ultravisor.  Given the number of pfn_to_page()
calls in the code, it's safe to assume that KVM already requires that the
pfn returned by gfn_to_pfn() is backed by struct page, i.e. this is
likely a bug fix, not a reduction in KVM capabilities.

Switching to gfn_to_page() will eventually allow removing gfn_to_pfn()
and kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 92f33115144b..3a6592a31a10 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -879,9 +879,8 @@ static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
 {
 
 	int ret = H_PARAMETER;
-	struct page *uvmem_page;
+	struct page *page, *uvmem_page;
 	struct kvmppc_uvmem_page_pvt *pvt;
-	unsigned long pfn;
 	unsigned long gfn = gpa >> page_shift;
 	int srcu_idx;
 	unsigned long uvmem_pfn;
@@ -901,8 +900,8 @@ static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
 
 retry:
 	mutex_unlock(&kvm->arch.uvmem_lock);
-	pfn = gfn_to_pfn(kvm, gfn);
-	if (is_error_noslot_pfn(pfn))
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
 		goto out;
 
 	mutex_lock(&kvm->arch.uvmem_lock);
@@ -911,16 +910,16 @@ static unsigned long kvmppc_share_page(struct kvm *kvm, unsigned long gpa,
 		pvt = uvmem_page->zone_device_data;
 		pvt->skip_page_out = true;
 		pvt->remove_gfn = false; /* it continues to be a valid GFN */
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_unused(page);
 		goto retry;
 	}
 
-	if (!uv_page_in(kvm->arch.lpid, pfn << page_shift, gpa, 0,
+	if (!uv_page_in(kvm->arch.lpid, page_to_pfn(page) << page_shift, gpa, 0,
 				page_shift)) {
 		kvmppc_gfn_shared(gfn, kvm);
 		ret = H_SUCCESS;
 	}
-	kvm_release_pfn_clean(pfn);
+	kvm_release_page_clean(page);
 	mutex_unlock(&kvm->arch.uvmem_lock);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
@@ -1083,21 +1082,21 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gpa,
 
 int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
 {
-	unsigned long pfn;
+	struct page *page;
 	int ret = U_SUCCESS;
 
-	pfn = gfn_to_pfn(kvm, gfn);
-	if (is_error_noslot_pfn(pfn))
+	page = gfn_to_page(kvm, gfn);
+	if (!page)
 		return -EFAULT;
 
 	mutex_lock(&kvm->arch.uvmem_lock);
 	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL))
 		goto out;
 
-	ret = uv_page_in(kvm->arch.lpid, pfn << PAGE_SHIFT, gfn << PAGE_SHIFT,
-			 0, PAGE_SHIFT);
+	ret = uv_page_in(kvm->arch.lpid, page_to_pfn(page) << PAGE_SHIFT,
+			 gfn << PAGE_SHIFT, 0, PAGE_SHIFT);
 out:
-	kvm_release_pfn_clean(pfn);
+	kvm_release_page_clean(page);
 	mutex_unlock(&kvm->arch.uvmem_lock);
 	return (ret == U_SUCCESS) ? RESUME_GUEST : -EFAULT;
 }
-- 
2.47.0.rc1.288.g06298d1525-goog


