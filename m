Return-Path: <kvm+bounces-49190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA1FAD6355
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98C7B7A758D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14572EA474;
	Wed, 11 Jun 2025 22:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jv2mxpLJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1320E277C95
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682095; cv=none; b=qOWZFi1M3FvhTzf4YTA8UI9KxAXuhW2S7ymsEolpHhTpadWkB/2jv7od5j1lBpWV8foD4B+EYog8BALZy02XPNFecMqSheevl8TBbn1ChjUrq6uriYYatAjWRw737eq/ilWIWLy8WRXj0qZNu3vQmyAsP0WVleJx1yq2r6PR/Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682095; c=relaxed/simple;
	bh=5uhQSLawC2qU5tV2gH8Qd+5+MUnVHTVb+tyLOzTBT7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aB3xUnr5DtkOiXioRQHctxpRI+WeUbd2IBYU1qMzmIBWKXWlUhdOHgNXK8usnGnzTbC4C2MzUcgi5bC4pTFKcPyQ3br98+sGRa9YBW5talbiowYPJtjZEuA8BxxCRzoMIZHgj2ALBcQRRY1rpTp135lIHyCmokxCCzx+JHfpZp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jv2mxpLJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311b6d25278so341950a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682093; x=1750286893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xaTt4Giap+1J1lFwTOaDaJBf68Rv5IWBO561HkZo+gI=;
        b=Jv2mxpLJPxEcfB2K31MlC6K6CNw/yQqTHfNxZlQtDtR1OtR+BE2dW8/0P97EWLD4BN
         qQKf4AYnxwwrzgx1IyaoNOmiu3sXy2dHfQbW0ZfICT7R8O1IAlkJKTN1D3oFFO23EO0g
         BHrF7eLRmW8+6F+nsClWUQChBJEUYs2ODfUv34v2lKCrL1nsJtd0oUf+Cu9egF84MATI
         HeNAvaGaSwcJJPEAPkn6tlzfzHRY3gxaWqG4Q04xjwPPeWSJ5Y2N5rn89OXRWMSBPHRy
         dWvT2dfgr7Diul+N7EdGBBr1dDkbvfzovOpi487zhLeHFX6MVXwf8G4xaNv4Vcv6XJJz
         tK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682093; x=1750286893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xaTt4Giap+1J1lFwTOaDaJBf68Rv5IWBO561HkZo+gI=;
        b=K3U1HiTRTqTFt42xtnJqYc4nKLmH9lZ3BzjKU0dfinFLrvMH3nlzRu+DFXXFPhlufs
         bj28vS33coX7tzQP1V0qDtY5pFwE724M6LDN5bTUkeNWMk8r8Y22i+iMYLU84aMSVz4v
         Gst1lwbERQGZCm4AfRkdWQhr6IST4GwpOOrwPFJbg89r/72LgmCucWJrnbXAY2WktgnQ
         DGsA1GTWDT24tIGPvYPfrN1/Jl/0QMSz5kmqHgSEbMeIwjiV+H55hTWteXLq9bHTrR5p
         b5EPPJLG6DVbFdvNAs53d0HpEZz1eX/WTt4CggzbQfwmQSjyGB3nNtCBKIWcc2cl18wh
         u3TA==
X-Forwarded-Encrypted: i=1; AJvYcCWcrEFS3YuNNH4zKOPau38UVAn/ViR5OUro3aYh/di7+xNmVL9Xnlzjch2e0ftCs/aje1I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6vaBXXxX1eq6tZ2t6bXfkWmZDavVuff6VRAWw7xQ75iE4VLLp
	MJr00/ILZhEHuyeitj8JKn2pSQjKIx0b5kDfqI6ZA7AlJ1VJRgryXEmDge7l6a5dAkNIaBOTqhx
	9hd/W1A==
X-Google-Smtp-Source: AGHT+IGf03w35WpWXu537xHWr4U/N7R14xnxNpvZmT8HfbsZ9X3mUH7UkRwX/TiEroCP15FbAA6qEaYzrj4=
X-Received: from pjtd16.prod.google.com ([2002:a17:90b:50:b0:312:dbc:f731])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5408:b0:311:9c9a:58ca
 with SMTP id 98e67ed59e1d1-313c0688525mr1173665a91.8.1749682093424; Wed, 11
 Jun 2025 15:48:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:48 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-47-seanjc@google.com>
Subject: [PATCH v3 45/62] KVM: SVM: Don't check for assigned device(s) when
 activating AVIC
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't short-circuit IRTE updating when (de)activating AVIC based on the
VM having assigned devices, as nothing prevents AVIC (de)activation from
racing with device (de)assignment.  And from a performance perspective,
bailing early when there is no assigned device doesn't add much, as
ir_list_lock will never be contended if there's no assigned device.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dadd982b03c0..ab7fb8950cc0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -732,9 +732,6 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
-- 
2.50.0.rc1.591.g9c95f17f64-goog


