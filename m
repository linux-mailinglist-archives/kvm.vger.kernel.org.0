Return-Path: <kvm+bounces-49148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C28AD62FD
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 441F07AB2F0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3B225A64C;
	Wed, 11 Jun 2025 22:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XRPZRfrA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AC12566D9
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682021; cv=none; b=oMV1E5xrJF5iKiYbZeVWR+EzNnZFi0KT3EUbdDZfvD6igtxAXSt1VAKGzrXIHQbmHZWiD7Ah5zD21pzkoYXDcoh91+E/AtZKxJHNxxarshl+nGpVJ6xJA2jSGjZQN7gpauHjgIe3+NkCMrvbAdlaowHpeuEs9c6OzbAfNh6xH/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682021; c=relaxed/simple;
	bh=3RinVstCvuPOndpP2qbzIU1WkDpDfa7DXhIJNaW07EI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iQtpFUYpaC3eOUhrsbDmbGWtNtgu9s8EOfDOaE4YkJmH9C7CuoJ7uauiHIefYCy6OrRkTk8IZX6t1MiFQK05M5gw2+ZRocRXluYpCNAYXvOFlWmHIzHkoYgoRUMGwZIuOJyirgQNn981abqYOFP4FOHWtnQ9mIBVgtyRsb7eXvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XRPZRfrA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25163so282472a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682019; x=1750286819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J8/39YMW2TnSu0vcgq5sLc/aWRKEr8Y6tOCzdbkWep0=;
        b=XRPZRfrAMeLjtk8c99XvSfscEUWXqAK1T0+URQXkLXtLs51+74j4/xt1I/DpW75W9+
         vzJiuHncIkdZaB+tnpm4NuDZbDY0AWIk1ZJNk+au+bIdd5uOabmDk7vucsDjAu3mG4vT
         RlVu40PpaeP+b+cxTWCtg6+zv6nmWgBG9cvOyUbbd2nEuAm+iP8hEO5JeVhGSd/bRnss
         JmStWyBQdjoO7+Ip4jpPEPgcJerqPQxnIUF64bCfhzyIfj0ZTa2QPn9qg0XyUwKE6Z8s
         ngjsgjg3PTUzt3GXmo4TBoEp6ZE2W41Jq8bnEAVfWRHXD+zJVK/X7FQl9jGCw4DSzUmr
         FaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682019; x=1750286819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J8/39YMW2TnSu0vcgq5sLc/aWRKEr8Y6tOCzdbkWep0=;
        b=U9i5KDG6kf2Tj/wvCvmH70fjetkZiN9IhpD0gs3a3H5bwQvVBg0jQalgyuFF1BOW+w
         vo0FLpWh2Jg1jmrQ3solR+qDJNC5qFwEuxmWEDxMw75dQMa+F8AnghZCmKbLQh3m9SOH
         tZxtT8lW5Od0ZW2rcFjBrj9PC1QkLukCpCvscLNxfC3naM2B29o/Y67dHB8iK14AgL5X
         JL6rrIrt67oCXYR977NUoYMATmkLz8Wr7BnYDpT/JB0bOLJ2rL3YEJ1BJYiDlNEXUUtp
         Ag0Lvn6hrT6AP6y814h1SManxdOiIwMHJODeQKg384OPSL6DOjTPP4lrHljRzFOaJ0QA
         osYA==
X-Forwarded-Encrypted: i=1; AJvYcCUfHa4ZlM+05BiRKFD4ECtGQ/fFHYIzFXgncLWfhy7EbdzJoH106+FBKWwQ+867S4+EEa4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8UxstFP7gAHnlRIevqAVYfrBT9tB3khXfhG3eRm9vWEx6wn+Y
	hh0Wvhy4SicQfmfKYRi8AvQhF9L2tmXXlRykzIfljVOMvphzxlxdij4QT+9iis7tD9aCUWdcaaz
	lWSPzBQ==
X-Google-Smtp-Source: AGHT+IE4n+pz35x0pb/YvabbWEbD1z+qTn+f+8VFoLc/qnaff30Vgk2g7VglikeaFDWzSwKhNVkNo49sz8M=
X-Received: from pjbpa3.prod.google.com ([2002:a17:90b:2643:b0:311:46e:8c26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3902:b0:311:abba:53c9
 with SMTP id 98e67ed59e1d1-313bfba1132mr1720309a91.7.1749682019303; Wed, 11
 Jun 2025 15:46:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:05 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-4-seanjc@google.com>
Subject: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
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

WARN if unmapping a vLPI in kvm_vgic_v4_unset_forwarding() fails, as
failure means an IRTE has likely been left in a bad state, i.e. IRQs
won't go where they should.  WARNing in arch code will eventually allow
dropping all the plumbing a similar WARN in kvm_irq_routing_update(),
and thus avoid having to plumb back a return code just to WARN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..86e54cefc237 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -546,6 +546,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
 		ret = its_unmap_vlpi(host_irq);
+		WARN_ON_ONCE(ret);
 	}
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


