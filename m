Return-Path: <kvm+bounces-23145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D331946492
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3742B1C20C51
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650ED12A16C;
	Fri,  2 Aug 2024 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uecvvOGg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A73A1311B4
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631522; cv=none; b=kE1YdxRo0bPcNVnvRakWt0v4u36fMaZ0ars/xuPlwj/MquVhDWn+QbvYDFMJ38pKeBNz4r08SI/K7K/l9s/3/2CWV2qce98c2Tnyt1XXrMXQiX7nKjSfiIUPCfNUnZFEbP0EqFO4EZrdJN1GtF/jMcP3baper7amxl+RSzp3Ens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631522; c=relaxed/simple;
	bh=XiBb3/2+Y11JQa3ISIlTyC0BrcKFHgasOhtRB+Hckb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WLBLnuliJZQzRHh0dLFgk3ojqOw6/LU2MP9IvxoCREKIHJtLLAR0vLfD+gfa8IANPAE6KZ10c2PhRVk6ewPVH6QlzDt/zIH+d8NvxP+10fL1Td0FjIDwCxvd+hd30ptp9v8Fso4w33x9HVV0adkgD/74nHivo9lpgA8hnwJyyrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uecvvOGg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso13637049276.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631520; x=1723236320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YAVVvosBGaQooisla/uYDPtaWdSHgHnkf46AZuaMyGQ=;
        b=uecvvOGgVyYCt+c/MkRI5y4Vk0wETSAq/8N+Gma+yXBslla+RIfzm7exAG/w4s6bA6
         HGawnO3mM86LTmDFHieQX10Jlz7RHKhrxYtiYXuS/SZlRVmXYKhjN35PEIPYZyC2QQZi
         tbKRr3dEUJFB60pAAHFid/tVwORz7k+4FfxOLPgD3KdjsvjKz3Kl431b5TUIGNsc8QHC
         kPDxv0FjCtjwZ9SpiJEMcfw5lO/PAKgz/SVXXyXJZGbi/KvKZ5Hw+JGicKyo37Ym4Oe9
         3qyfLeQwhpjqGDHyO+0aWRita+Xr4O7IZv9yRcSaWwCiVA4mnupuNv6BbSwToAx1V4ax
         R/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631520; x=1723236320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YAVVvosBGaQooisla/uYDPtaWdSHgHnkf46AZuaMyGQ=;
        b=fOOHAKtUSAr3ZaXruqZxx7jCVPEHU9MFtFVHvFGZEKCJ6xtbKRN7XTApqkXDffessK
         vHElMn4wPvQZDDB+Bi9OV/TOxldDfAsUw5kiK2Bf0ozUbQtbVuuoF9x1B8Dh3f2HUmQi
         E3eRcdsE6qc5p7hP/cFxUXJgnZCs7XXpI/rPu2VTAYsf5Yx7aWFuDiLjDibYuxk3mP+y
         pwAkmBQBhsKMiZSB8X0/TrG9LTz+XgwRSuh59/twuk5smOElPVjtn1Gc65tKVq+pIbvw
         uBLlLgFDXQ1+Ok8hTro8u+1OIB2/tZuI3uu5nBCyGDZ7HIf+lGuv8e8+Bi2pwci52x7Z
         7YOQ==
X-Gm-Message-State: AOJu0Yyn2secpJ8I++FbpzqBi415nGZ7iuNUJIdryMq08HQzeEiqvApj
	WrDSzJLl1m/Qh4OdPUnTb72GlaCsAxRSlSNh46hQr2X/nd+LQMGRxhTyXWeFPQWy5mSw2pKWopf
	+aA==
X-Google-Smtp-Source: AGHT+IFPDPOfed4bfrEZNnwZ17lL7+A2nCaNcU3DAzSYWZX3ae0+7bgADBtnO+nLvjjjI443/H/XthQlK0Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c3:b0:e0b:4559:e6e8 with SMTP id
 3f1490d57ef6-e0bde3f022dmr7643276.7.1722631519965; Fri, 02 Aug 2024 13:45:19
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:45:11 -0700
In-Reply-To: <20240802204511.352017-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802204511.352017-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802204511.352017-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: SVM: Track the per-CPU host save area as a VMCB pointer
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The host save area is a VMCB, track it as such to help readers follow
along, but mostly to cleanup/simplify the retrieval of the SEV-ES host
save area.

Note, the compile-time assertion that

  offsetof(struct vmcb, save) == EXPECTED_VMCB_CONTROL_AREA_SIZE

ensures that the SEV-ES save area is indeed at offset 0x400 (whoever added
the expected/architectural VMCB offsets apparently likes decimal).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 15 ++++++++-------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c44261fda70..43156ac93fb3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -573,7 +573,7 @@ static void __svm_write_tsc_multiplier(u64 multiplier)
 
 static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm_cpu_data *sd)
 {
-	return page_address(sd->save_area) + 0x400;
+	return &sd->save_area->host_sev_es_save;
 }
 
 static inline void kvm_cpu_svm_disable(void)
@@ -696,7 +696,7 @@ static void svm_cpu_uninit(int cpu)
 		return;
 
 	kfree(sd->sev_vmcbs);
-	__free_page(sd->save_area);
+	__free_page(__sme_pa_to_page(sd->save_area_pa));
 	sd->save_area_pa = 0;
 	sd->save_area = NULL;
 }
@@ -704,23 +704,24 @@ static void svm_cpu_uninit(int cpu)
 static int svm_cpu_init(int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
+	struct page *save_area_page;
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = snp_safe_alloc_page_node(cpu_to_node(cpu), GFP_KERNEL);
-	if (!sd->save_area)
+	save_area_page = snp_safe_alloc_page_node(cpu_to_node(cpu), GFP_KERNEL);
+	if (!save_area_page)
 		return ret;
 
 	ret = sev_cpu_init(sd);
 	if (ret)
 		goto free_save_area;
 
-	sd->save_area_pa = __sme_page_pa(sd->save_area);
+	sd->save_area = page_address(save_area_page);
+	sd->save_area_pa = __sme_page_pa(save_area_page);
 	return 0;
 
 free_save_area:
-	__free_page(sd->save_area);
-	sd->save_area = NULL;
+	__free_page(save_area_page);
 	return ret;
 
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2b095acdb97f..43fa6a16eb19 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -335,7 +335,7 @@ struct svm_cpu_data {
 	u32 next_asid;
 	u32 min_asid;
 
-	struct page *save_area;
+	struct vmcb *save_area;
 	unsigned long save_area_pa;
 
 	struct vmcb *current_vmcb;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


