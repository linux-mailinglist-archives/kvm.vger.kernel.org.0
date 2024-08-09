Return-Path: <kvm+bounces-23765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C2594D6E8
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:08:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CAE0B22CFE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C538D19AD73;
	Fri,  9 Aug 2024 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hgK0uaBd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9024319A292
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230234; cv=none; b=PRTURnHI46VIQeVSuDOmpzT2OErpYUZDatxWuq7mlPuC0UK7fo81HJoqJIbWo6kQLMP1w7WAQyTk2I4hzWUJ97gA1Dr5hsipXYnjcZAnNMUbRrqsK2WWxsJx1ET6eTiy35E+PQ3nKRafK1qJHIKgIrg770rUPmxJJvuiNUEQcAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230234; c=relaxed/simple;
	bh=bRCd13k6i1A0U1LnG9khVbeFxffh10XZUO3UGsbmPjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dSFkCvREagetQBalKLVk1XJOFyyrdFWP7lubCvByrpasMjmHuSdIzMr9cZbuVBngbFZaZUNI2IQr9wdG1LtlCSsjcEAX8GDZQExm+i2uwMna7DDL/Jc7z6K8pILRvNbxGPygBKchlLgWIh7wIeLnBCVfTn3xP0FwM7UkYBW1piM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hgK0uaBd; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fca868b53cso22258475ad.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230233; x=1723835033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i6No2hwzIu6e4YAJZs7ugQt7CXH2dDKyvdiMgrvYWso=;
        b=hgK0uaBd1RE+lf3DyVFJOV9l/j2RQdxqNqi358JHDxqzPCD3Tx+ZS5r/leMQduUrQm
         DnmQXl/xK4eJJD6gkoPt38xa2dt45RY50vSlpNA3F6oO4EwCCNl/GaoroNSm0kSpGLp+
         emlosudG2AzCn+Xh4gK/2eYKfFGUPafJQ7MWtDD4yowBQaEI/7hwX3sdjgiNYLf3fqa+
         t4VDfJtK3YvqRrNTjWtDc69t8FaOuK9TO56L7MuozAtt3qyWb8VTcV9/sP3CKx1CeCIT
         nVhRmuXfUZWcq/wCpvT6Fy7E/qAiy1VKKfCH9L7MwzpyJlo6YDMP0OQOEMp/Pux1gLOG
         h1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230233; x=1723835033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6No2hwzIu6e4YAJZs7ugQt7CXH2dDKyvdiMgrvYWso=;
        b=Qq1TPHwwQQ2moCPYDgmkVeG4hffzx2PYlR227oTz2yz+3SqAnFnvU9OqpQD2ar08lV
         pUsqfV473OTJOr9QUpqpVv1xBO7AEGvgVoRzTJdg4pK6EJICX0ejuHiquw8wmA1PzJ6c
         +XCxegsBhhNg3A89xEaBO0xflCK2RLTShCLseMAJBpZLoFuK6RvSkL524ccafVAuGrUz
         DUuRCjmyLlE2BdP9J6a1rKOj5j6TMJquI15EDYllWFScyt/556RuSPHl33x9wT/tO4gY
         MVyERxCHUkEQ9YF4k2M7sFOq8PIokyznw1mJ5JEx4kni17hQ2zH6w7MIsbiDM3K9FUU9
         lFMw==
X-Gm-Message-State: AOJu0YzpjAoXCLNw4lFXT+CCWxE5vXs4CU3ASzDzdjEPdSr38ORdHcLS
	2L7tTLA5EZQ91YkligDsBMSyGGJvac4kfwo6RKcXEgZASrYF1oKKuAzsFw95HEEkUnIpt/kkzgS
	IlQ==
X-Google-Smtp-Source: AGHT+IEiNLsgXHr0s14hEc+y88fytjsQ/uGLHuXkzmmisdcEk/UgFC8sD2BUQDaPdf5KBMzcHwv9BLUzTIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa8e:b0:1f6:2964:17b8 with SMTP id
 d9443c01a7336-200ae584d14mr701055ad.10.1723230232634; Fri, 09 Aug 2024
 12:03:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:11 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-15-seanjc@google.com>
Subject: [PATCH 14/22] KVM: x86/mmu: Always walk guest PTEs with WRITE access
 when unprotecting
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

When getting a gpa from a gva to unprotect the associated gfn when an
event is awating reinjection, walk the guest PTEs for WRITE as there's no
point in unprotecting the gfn if the guest is unable to write the page,
i.e. if write-protection can't trigger emulation.

Note, the entire flow should be guarded on the access being a write, and
even better should be conditioned on actually triggering a write-protect
fault.  This will be addressed in a future commit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5d1f6232f8c..f64ad36ca9e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2761,7 +2761,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	if (vcpu->arch.mmu->root_role.direct)
 		return 0;
 
-	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
+	gpa = kvm_mmu_gva_to_gpa_write(vcpu, gva, NULL);
 	if (gpa == INVALID_GPA)
 		return 0;
 
-- 
2.46.0.76.ge559c4bf1a-goog


