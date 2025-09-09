Return-Path: <kvm+bounces-57090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAC0B4A930
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2952362B5C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D150314A7E;
	Tue,  9 Sep 2025 10:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UX+tK9Tz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAF313E1F
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757412018; cv=none; b=poBjefwwKh8BoQ7Y5NkvkRRSIL764zhhHo0wCBfirqS9CL09MIBKQQaLsVcufJCXTdJz96n1rm/VdWWMnYL2yVZMWLPLb3UbLHHRPsD0CdhoS5a1RVtFeTH9xat7D319QcTki7KQJvInCDN0hpI8lKLN8heW6A7rf5KZTIebKWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757412018; c=relaxed/simple;
	bh=QbVUoQSdw11J0elYFMP4o+j77757DkndTpi+NATPMR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Swj1Hr0yqm1oyuDxS57Kbj2h+hAOCoFDkQatk14gIL5JC5khtDWs1Kd26MUpWc7YWXpGTEW8zZNxP5WwZYWbgViJXFPuX5r7l6YekGL8s4LH/LeZ6C1UXzowFXsoZlNNcjYbDnMRGBJQybaFOn7bEOtRgEertHNAm5nBSXfxYbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UX+tK9Tz; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3e2055ce8b7so1991035f8f.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 03:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757412015; x=1758016815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9hVlCzjahaiEGhplG9Zdx1nbP2OLi1/QyI4a7DScZAA=;
        b=UX+tK9TzGw8FZBSTCTsjzT5gFk9EGdS+GsRxGiSCjffOmBfklC4REFC3kZo0dYLOi7
         IO5QhBGXsMEcmJsS9HpQy0avRgruZgpu0JvKamqGPgJrRR7ICFTxMWvcAoUb0hZ2b1bh
         nHlh447W1y9a1B0T4KltSJFk1zuvM+tceFsPgniDcLyBcJoGJuMp7w+nb5BEfiL6qms9
         7UYrxcz+219uVttEpcQ6PZoaXhC5E2NWOH2qbRp0cr2OvwOEd1DfrNYSRGLjZYwD+DKG
         PRtRjoFr+V8CWciYoGaY3FK76wEoq1oG01csOEz3QI8pc8My9EDUJHZPYs5311wX/X0s
         c0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412015; x=1758016815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hVlCzjahaiEGhplG9Zdx1nbP2OLi1/QyI4a7DScZAA=;
        b=d3G8RmOaZUDEG4ySQl1KV7jB7C7hIGO+jKdk1sXs0/k0E4apUTXISrLkEwWG7aguI2
         fXORZT07eNOBxrS+RYdcq6i2NsmAiGKDCY+GicbOdcXVF/tbpzEHgBNPdn8tZH5koCwW
         dLsr9Mss+yYzpdIE8oFm6M0wurTpuhfuV8nA2wTybO1VKOZtDAf6vuNrUhmFCr7bG65Z
         ZqoUPKVYmfs1SacSkNSv8QsPcr9Qa2b88+mKcaGul/7nxYyXnpjnQmvyNZGbRcmf07SN
         IkTOxjIsVs76KwWfw4YSEb0L6iGFidBn9S854ljqSi3BQ+cxIeS7uEelDaIB1VaIakvx
         t54w==
X-Forwarded-Encrypted: i=1; AJvYcCXlIQlK8F2LC/+2Nqlt+imXLeYnnLbWh7NFOoecJ0mKLFx3uyGxE6fZuc3xdaOIfTPm32w=@vger.kernel.org
X-Gm-Message-State: AOJu0YytDLxwIs0GBw1RmRRVwN7NNctMgsRcf3lUV51oDQZ3XMCArwls
	QXHDKOlhQH0N/WaHSB6/5Tl2IjA4711UXQGJ+b5eSD3mVZGKqO2yIzPp8z3w15F/dGQOJellVay
	M+g==
X-Google-Smtp-Source: AGHT+IGeA46JHPn4PsdMlz1aRauFfewChlBh5UIalpMRgks3j6VnU3FPD/svB6rNtJIzDBHZErkOZlargQ==
X-Received: from wrtr3.prod.google.com ([2002:a5d:4e43:0:b0:3d4:dcf3:824d])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:25fc:b0:3e7:42ba:7e66
 with SMTP id ffacd0b85a97d-3e742ba8bfcmr6891763f8f.3.1757412014690; Tue, 09
 Sep 2025 03:00:14 -0700 (PDT)
Date: Tue,  9 Sep 2025 10:00:04 +0000
In-Reply-To: <20250909100007.3136249-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909100007.3136249-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909100007.3136249-2-keirf@google.com>
Subject: [PATCH v4 1/4] KVM: arm64: vgic-init: Remove vgic_ready() macro
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
index 1e680ad6e863..3f207b5f80a5 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -554,7 +554,6 @@ int vgic_lazy_init(struct kvm *kvm)
  * Also map the virtual CPU interface into the VM.
  * v2 calls vgic_init() if not already done.
  * v3 and derivatives return an error if the VGIC is not initialized.
- * vgic_ready() returns true if this function has succeeded.
  */
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
@@ -563,12 +562,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
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
index 404883c7af6e..e7ffaf4bf2e7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -406,7 +406,6 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_ready(k)		((k)->arch.vgic.ready)
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
-- 
2.51.0.384.g4c02a37b29-goog


