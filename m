Return-Path: <kvm+bounces-25596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF052966D51
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E199B1C21D88
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821B2481B4;
	Sat, 31 Aug 2024 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x6Ud8f+Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF0641A94
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063366; cv=none; b=MdeGDsbBhYb+9rFpiGq2/kiJ0gUomLbcRsA78rgHBLlaMm9SvIcZV8vTK4bjDWh/unI0Hq1Ycs5yVeOPIxR1aysm4enfOuLihpfS7EQ1nM8Wr1V6Ib0dol4wC7axyzQmY/uPgQ/mj4RAJMkdIeH2ymkbn4Q/ODs2fC1L3bWtz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063366; c=relaxed/simple;
	bh=0ugKPXm7f0Z9tkNBlydIBvCQhLXirirTmaxUHzxFYGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPBPP2moioMe+mm1OdXIidjR1g0gw+lyxwHrAfOlBVzfM3IzLQ+rtt9zd6uSpqjld+2/9HxmUQyhtoXLdVSyTGaN4XDubfg1RxJ7LGobwi0z5g50dzoOls+mvgMBwkyNnScVCqnLn+XrShTI8BBqBcSX85qjE0CRHoqwE9fLU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x6Ud8f+Y; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7143ae1b4fbso1962077b3a.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063365; x=1725668165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pFaEKpwsoQLgtn+xPOU/nmb2rgY2BlrNEgxoYJSjng0=;
        b=x6Ud8f+YfiNAppvZWkbOoTh7yNRBp/eZpMnrRSdIR8mbBUeHPL2tUDE41RtBZRqTKk
         2m4wZj4k0gWHDEMvAE+rD2Rx9ihFFJTKoO8hEsteWIAfQxbwquLVysdznBoBIPKl9XIq
         7AD9/vT/9fTg3Xp8nrZiAF5gn9l0djEkeAK9zf7xodZd8QZkgvFqhzqyFf+DnG4Q5Jn7
         Y8c4j1tx0T96EHILB77ySJgUKmMX2BMjWp0cKLpM7DyAF4+WWZM5cp4JSjNSp7nqf7Ph
         f9vIieuWR7y/+fP3h185SmIir8jt4SmGf52ctXsCU2ywgmxW0/8+ALa+BsIskzn3jBtH
         A+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063365; x=1725668165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFaEKpwsoQLgtn+xPOU/nmb2rgY2BlrNEgxoYJSjng0=;
        b=dbKdLwNzS0KxuNdM5QzEjGWXOWOiL2ikyd+zeJK+xuxlx/sOLLamjowbIj4rTzDuqX
         f6lOtjCXvesJMSmIIrapngrIgslDUyAasYcIoYaWD3l01FDM+OgWNIOBmrWOb6LX5681
         WNRZsZBbbGgjkl8cbgFubKUjgKjNiBnQMRHeGoyAp/1LbUKPzJbX0wdWqpL3LaCCiWXI
         nytqilMONXhtaGM3ZmGoTyxdpigAn1E8SxTKeFmahdTA8h/cpUyA9vnND5C/528HPqIM
         54fgQMEtsMX1I8Rl85OD9xY4r2J8omVbLPuWmFc+vmS+wAhlfLPddNbC9YBtDnGIuCnr
         AMLQ==
X-Gm-Message-State: AOJu0Yw2Sj7pGkT3NXUGrJL/2E7cgA7+FV15rlDBQjLq3th0wd5MtTkA
	hXMjUaeYyBMHE4uilkcmkjC2CoNkN1Lb8vqsrbtXUnamNJr+IJcnYDErnRpaDstH5ivPzSvOLp6
	Nfw==
X-Google-Smtp-Source: AGHT+IHeayohZ8P9bTfkvLJWiAXof8KEhjPXfE8aDRqDE3XirEUvuRZ9MRzo1AWngrkQZ4frV2qYEdsDGQ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:870f:b0:714:37ca:ed6e with SMTP id
 d2e1a72fcca58-715e104ad90mr24129b3a.3.1725063364507; Fri, 30 Aug 2024
 17:16:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:27 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-13-seanjc@google.com>
Subject: [PATCH v2 12/22] KVM: x86/mmu: Don't try to unprotect an INVALID_GPA
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

If getting the gpa for a gva fails, e.g. because the gva isn't mapped in
the guest page tables, don't try to unprotect the invalid gfn.  This is
mostly a performance fix (avoids unnecessarily taking mmu_lock), as
for_each_gfn_valid_sp_with_gptes() won't explode on garbage input, it's
simply pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd62bd1e7657..ee288f8370de 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2729,8 +2729,11 @@ bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
 	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct)
+	if (!vcpu->arch.mmu->root_role.direct) {
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
+		if (gpa == INVALID_GPA)
+			return false;
+	}
 
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 	if (r) {
@@ -2749,6 +2752,8 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
+	if (gpa == INVALID_GPA)
+		return 0;
 
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 
-- 
2.46.0.469.g59c65b2a67-goog


