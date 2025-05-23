Return-Path: <kvm+bounces-47493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF23AC1965
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D2D03A108E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D640D2D29A1;
	Fri, 23 May 2025 01:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X6KY7wC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD762C3755
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962085; cv=none; b=nDS9u2gUr5184W7tb3iehaozEzitwzHqDJGzzp2FmTbJTHqWQrpLh7Q3BNrV2fh9tumRJf2qV2/mj1ONWKilwkNPq05RU+GymF/FvQbD1P3UHaf1Ui9JEU7Chi/fsgVBJMygfWxUETYRj1WSwikgANeHHoc61ev94LovxK0n+rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962085; c=relaxed/simple;
	bh=Z00yQ0PQn26W+YkvG1/+a4jEvueuLPaetcdy4ijqCYQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AGHz/nf24wcNrn+ByvGoXt3zdChHKWhiVpbCrL0Zu6CuzhHOKFbnzx/QZhoIyVMYj4npPJmtej60Gu4VWW0HIiIk7B8VTYl6865m8MVVYwvQ5oA5wza2BAogm7+IfLGjPUCi7R58xQMBAxrmSOCpaHbeeD9/lJ0gQQ5aYbP1Fo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X6KY7wC7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so9579917a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962082; x=1748566882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zrysmAdotRY3tUKAweOx9pfjToN/g2hJE4Ng9AMbRtg=;
        b=X6KY7wC71sGhF8qc6wRH17VGL2H9By+lUhIcmm0m9l7lQGGNr4I0uNkITR9Qon+W4M
         YbyoT44AWd3MSRgOV5BFyFVGgbiyXRAMuPPo2H46bCx48LcRABH6mY7L9YRMB/X0mmBM
         JDjqh/KrS4zAtKFaqNVpaA26EGRrEVncoNjOUu2V+Oxt/rVT/+uJuYMgRjgz4VDcQMJ4
         UPbC7yIdmqqWowzEtjLLF9OXuITYt0wXoNXxK5oqB4Ao2HorGNAIpU1BL5JDVh84f7Un
         jdh6l8xUvDjeysYRJDKupzTMc/oKp5rhkJKCoNJ8Tu4tapmkyTBJutq/ioE7Pk1BTZLw
         vHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962082; x=1748566882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zrysmAdotRY3tUKAweOx9pfjToN/g2hJE4Ng9AMbRtg=;
        b=pahhllepUOvgcBcdOGz2mYPiCS9H1e0NonCLO/BGZuaztNQZeECJKaN+kzq2fP3UbO
         GIH1HWdtHaQHmeanlmvyGFi/fYhp1e5MWPXAVSa1JHyLrbvBD6SwIYV46a4mAHzE+T5t
         a0uc247mK+R2dfwDgItOPRYHG3t9aOKJJZXVTwdVSvVTz7U4Ciz0HVK6qN7dOj3Q+SbL
         eOp4cY6AmjAU8rk3TFg8XEKQqda9JrWvtFfgluMFnSgHxqmmNA7Z1GFkJtqbR/NyFNMY
         aPZYn8Ugo9eAVHktK7VP7AH8AmLVY1ZA+vOWPq2/qJjbm8goCk3DjoCOstWTtIxojMag
         yx5A==
X-Gm-Message-State: AOJu0YxjzBF/JWsejq4RAAUikM7Qj7CC1JKoAOXT3bDZx/RdR+Lq+5bj
	dG1LmDGMcRZEYAM0Hng1G41z8HYhqkAMh/agfhevXWLaf+jdfeimj1ySnmuiQkDHiTJlgOwTO5U
	8Is4SEg==
X-Google-Smtp-Source: AGHT+IFYYw2vNKO7X1E4jTH8MJBys/Xi26XTWV4xJAxpgqO4gyT9OdqFXK5/A1nwW8HDjPEMRjulaYFMODU=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:aac:e580])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:394d:b0:2ee:d024:e4fc
 with SMTP id 98e67ed59e1d1-30e7d5bb433mr48333499a91.33.1747962082505; Thu, 22
 May 2025 18:01:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:48 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-44-seanjc@google.com>
Subject: [PATCH v2 43/59] KVM: SVM: Don't check for assigned device(s) when
 activating AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog


