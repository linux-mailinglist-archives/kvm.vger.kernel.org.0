Return-Path: <kvm+bounces-52619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2FDAB07445
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 210721AA6916
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FC62F431C;
	Wed, 16 Jul 2025 11:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KGPB21K/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A5C2F3634
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664067; cv=none; b=Dpxr2FCxoD8VxT3BlvwUNJuJMAEFLE/KeW02xWbFzN8XxEj5xkQXzH0SCj7e5/2Cd5PqtszsrjELZm+LVJ/jMGyrUM/0xTvQAOu7T676w9OWgATQfSYN+FTLoLdodHLMOOKMERFNa6DNGupzB+JYZ7QmuOHDdk3vNL63+P5bJME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664067; c=relaxed/simple;
	bh=7MCXu2XIExm1XsO3hQiAoT4CvnT5CB3Dy282TZ97t3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BhrOWP7bQp8XtZqnAHSe3F813xeQ62FR/89/8AvY8Lzirx5Qnpj/HfdEjh/gQQzu7+F/ad3F992PvnWnsUlQ2WjjauCKjXhP7NvJpRptvkrS5/574kRRP9KJf2BaxeJ7nSriGXodfjHIWCeDQhhTqLOAMWpoT/x4j/NNRDGZ+fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KGPB21K/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso24954955e9.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752664064; x=1753268864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lw9Wdz3TAUoCooOMv3X14CEUxWY0AuV/hf0NzcKNFE8=;
        b=KGPB21K/wFDrm3ArnevTOzbNa0dlmdb8VQFUxn1geeeW9/fwrbhbxjMWWystOnUPOA
         RShHNYAmZ2Xe8ypB8PPRaeBMe+eSHG1yUgf76MQDC8cOrnwLwNK/rF2ZiQna9lk3HLyS
         1CR993ZYB+wyZulszyisgY2S6esPjON/a1LiAPqP2KJv0N/d7nP0C8bT4IZfAlF4H48Q
         WiGvY1bZ3p82EeMnxgGfo13kifv+HuQB/NMkLwtOUEx2QYqJhMAm4NZ1x2/9EhilkCB0
         OGeM/TbPxdAKq6mCaJNAApv461aRMttAIJ+/hJQ9oPn/Gk5f3ohaQsBQv9HUAmqpb9+O
         LUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752664064; x=1753268864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lw9Wdz3TAUoCooOMv3X14CEUxWY0AuV/hf0NzcKNFE8=;
        b=YevR0NlDqXhOwSBtSkvSwWGZ2ehqV/Zrdxb+ps+sIfnGgzip4FP+tIOLxIFFgryfXD
         N+Wc1OCMnxydzpKe3nheoEAFms/ss09XMmCekR8Llq7p4tmgb0kS5jXSuDwmVt1v8GkF
         vE5xqZU9RaVxzGiSk2MU4sXEPiOpPDBNurqbmz9bfAB+hOaXs+vqeR1Z2vu/zZhifjhn
         YE5G50yJk7cFkidMLykAsX/rcXJtoKLLZ71pSoncXbcCrmSnEZ6KkvfrSvEeb/n2Hd6V
         Fg63fgmUkdnIIFvK9Lpd6gd+q7KggOgqODQKZLTyr6HbPQU6SR7ZKGCQvEM60oFVxiHK
         QVGA==
X-Forwarded-Encrypted: i=1; AJvYcCW1RRNoUKB9nuv0gKAPFtZN/IOPtNPHl3EJUyM0ZOtKjxi7sxzfXiiLH1afvBOT9yWWkc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh6At+s6F/IfnvnqjJHaKF+XxDhurs7tB+keuFBM1P3DxNqXRp
	P1OCh0h/LHobZLLN5ucg2+5sZMV0vvJAcfBS2JtH2MXgSknhpbU9e+WSoG3EXk+NfOD+1+wkk8o
	GHA==
X-Google-Smtp-Source: AGHT+IHuNxCrx7B1F7XbHUaYm3AAwwPyLKTJsfFZ+D2KSuL1269JyI8e442f/hH+yv6mKmRQSSBPsJCPSA==
X-Received: from wmbek10.prod.google.com ([2002:a05:600c:3eca:b0:451:4d6b:5b7e])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3481:b0:43c:fcbc:9680
 with SMTP id 5b1f17b1804b1-4562e3c4b8bmr18712195e9.25.1752664064367; Wed, 16
 Jul 2025 04:07:44 -0700 (PDT)
Date: Wed, 16 Jul 2025 11:07:34 +0000
In-Reply-To: <20250716110737.2513665-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716110737.2513665-1-keirf@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250716110737.2513665-2-keirf@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: vgic-init: Remove vgic_ready() macro
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

It is now used only within kvm_vgic_map_resources(). vgic_dist::ready
is already written directly by this function, so it is clearer to
bypass the macro for reads as well.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 5 ++---
 include/kvm/arm_vgic.h          | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index eb1205654ac8..502b65049703 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -559,7 +559,6 @@ int vgic_lazy_init(struct kvm *kvm)
  * Also map the virtual CPU interface into the VM.
  * v2 calls vgic_init() if not already done.
  * v3 and derivatives return an error if the VGIC is not initialized.
- * vgic_ready() returns true if this function has succeeded.
  */
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
@@ -568,12 +567,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	gpa_t dist_base;
 	int ret = 0;
 
-	if (likely(vgic_ready(kvm)))
+	if (likely(dist->ready))
 		return 0;
 
 	mutex_lock(&kvm->slots_lock);
 	mutex_lock(&kvm->arch.config_lock);
-	if (vgic_ready(kvm))
+	if (dist->ready)
 		goto out;
 
 	if (!irqchip_in_kernel(kvm))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..233eaa6d1267 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -399,7 +399,6 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_ready(k)		((k)->arch.vgic.ready)
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
-- 
2.50.0.727.gbf7dc18ff4-goog


