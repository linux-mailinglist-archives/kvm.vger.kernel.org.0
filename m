Return-Path: <kvm+bounces-34919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02416A077E9
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35F2916522A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9787A222572;
	Thu,  9 Jan 2025 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHs1/KEK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6B221DAB
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429916; cv=none; b=b4SVhut74IZjqMVVxMbSVVmAiWEPGfun7HBJggqrcf7nm/XFf8vJjx6iJnGViugNGgL/5B9z32/8VUM//l6id6M+jdiq6p6Z/oouId1PIR8D+Wfgjyw2tGp/Aa2q735clWaZnLOHuEOl466CV73AwGWmA7B1d0FjyYfJ9/+rd2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429916; c=relaxed/simple;
	bh=iNT9KPtrkMdcv/JnCsg0+6j7kTEB+dZG7xYjFTS5aX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riCaE2fBmhZs8y/KENnqhmrHAVK+tV7PzyFOYRpkZLl4jvZ0MlrzjPWOx4bpbxCiB0dFgT1Tut99GkvDPBPZKB5NoZm2okZ/6MPhcbrT/yMSkIUtlGd0eIOmjhjVfksdfopKtX+AD00jVknjQxUZ5et7IN3jKwLUyXEpHyEuFMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHs1/KEK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736429913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4qkNvDxtryDJuaOhZabXXDqOZ28SJd16eOJBotltio=;
	b=NHs1/KEKNATP/8dD/qoXG7gyKO4Ce4uoKyekzHtmBKXl6vSyapSAIrcj5g3hyDBo3UoaTa
	58LhJFMtIbstWoyRLW5cu2m4KKDSgj4qpgt6wiCiBV9vY286JotGCGuPRgQL3Ck09igZGa
	/bLoVjKSIJwzqNFMQf65yL14DEaIDSw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-0oofM-aOPQSOjlmqGHSEEQ-1; Thu, 09 Jan 2025 08:38:32 -0500
X-MC-Unique: 0oofM-aOPQSOjlmqGHSEEQ-1
X-Mimecast-MFC-AGG-ID: 0oofM-aOPQSOjlmqGHSEEQ
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa689b88293so95486766b.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 05:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429911; x=1737034711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4qkNvDxtryDJuaOhZabXXDqOZ28SJd16eOJBotltio=;
        b=GDf8Be4z4mB/VNXzbYP6Yi+GX5bW5k3xiqq9hYouLfyJFZiqbdXWXSuuhe2gDw8GVh
         ZntmMCiKNMhK07XmQrgZAaDZebuiQ+fJATNI2pSTMadEvtzpu3y3k3k2U0R5ImKmt+qE
         6Yhx5NfZp8eXMybY3pXMIMPHtHosYbPaqNFKR2av7I+ffRKdkhOj64Is2I1lCU3ZFv7O
         cnhC83G8BHDbkEeLskFhdvWzpz9isOIbGkQOOg5hsFHdXejuopGPJeOFoSye03Q5SDTK
         EQZ5p05iFx9Xv57EAfFTyDoHhtkLxTwHPH+fdLFXbNxELiARfRSzKEEzx7kAvuD8u1AY
         9I2w==
X-Forwarded-Encrypted: i=1; AJvYcCWuhwaURHsIX+KTf9KjkJWUTgIwGhfwRh6YgNgUrrXdaHSRr24syL8UzMZXYu29TWrqVro=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRUnrWNCOHKxU1H55UZ2SehlkCdN42dVnSomKPdO30K3DpnJSz
	365G/2u8vvViCZpPyJeg+F+jRm7gL3fDlyvP5LadPfrWKaxd3noG/GHHI85/uxg4MKWp1/O8EQh
	VSmB+522/YQE8022JaPslg5NXP2kmVMC+AJkfQptKa3rWNhWi0A==
X-Gm-Gg: ASbGncsdCY3WgKKE/I3aGfn/5OLTW9OMwy/nxsOeXsGTKoj9CaO/0WIDl/hI1bMzp8/
	A63YKc8MVg/TamO3djnr/PdwTpCW1lFR4uLInHEUKIyyyGKdDdXe79vSa+/NOhPTdVpjBYdk8Z/
	fkM1VTqk79S6/TmA/YKYblGaRA1jJIxo2n+6C5saYpubfmA2wpz4imxNu71LdzRIIe+iwZ5BQIG
	s88KkXIXAqxuzA6e2o5tOPPUAvvm0UY+YzxAUR7/XdhIJtp9PcWlg9ezyGf
X-Received: by 2002:a17:907:97c6:b0:aaf:208:fd3f with SMTP id a640c23a62f3a-ab2ab558911mr610031766b.13.1736429911049;
        Thu, 09 Jan 2025 05:38:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcNnAC+O5NQsf3e6ZbNH5VgDVjtZpeWPQB3s6uy9MQKvp52Beiu2u+bl2BWL3zXg+RcIfN2Q==
X-Received: by 2002:a17:907:97c6:b0:aaf:208:fd3f with SMTP id a640c23a62f3a-ab2ab558911mr610029466b.13.1736429910681;
        Thu, 09 Jan 2025 05:38:30 -0800 (PST)
Received: from [192.168.10.47] ([151.62.105.73])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90d6838sm74386766b.55.2025.01.09.05.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 05:38:29 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oliver.upton@linux.dev,
	Will Deacon <will@kernel.org>,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	seanjc@google.com,
	linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>
Subject: [PATCH 4/5] KVM: e500: map readonly host pages for read
Date: Thu,  9 Jan 2025 14:38:16 +0100
Message-ID: <20250109133817.314401-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109133817.314401-1-pbonzini@redhat.com>
References: <20250109133817.314401-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new __kvm_faultin_pfn() function is upset by the fact that e500 KVM
ignores host page permissions - __kvm_faultin requires a "writable"
outgoing argument, but e500 KVM is nonchalantly passing NULL.

If the host page permissions do not include writability, the shadow
TLB entry is forcibly mapped read-only.

Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index e332a10fff00..7752b7f24c51 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -379,6 +379,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			unsigned long slot_start, slot_end;
 
 			pfnmap = 1;
+			writable = vma->vm_flags & VM_WRITE;
 
 			start = vma->vm_pgoff;
 			end = start +
@@ -454,7 +455,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
+		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &page);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -499,7 +500,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, true);
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg, writable);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 	writable = tlbe_is_writable(stlbe);
-- 
2.47.1


