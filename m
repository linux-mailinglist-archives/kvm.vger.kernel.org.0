Return-Path: <kvm+bounces-54963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B697B2BCA2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEE7A6809D5
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A913176EE;
	Tue, 19 Aug 2025 09:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eh0xO4Gt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F91F37D3
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594541; cv=none; b=lYCA3DgPh8aBohUxRFzJ/1Ue5vXjloYE4XeOOkdz3sd8G4fIp0DrkRlOwCPuTmu6RFcCnbjDHHznI+fTVSZUfXA/GJYmMRhM6wCfyOCO4ndgeVJ+x7wBm6yeZm7VhCqH22XKt4Aod4nwHyLeDwwBBPYx4L2Q42WZdpdoKtpsLVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594541; c=relaxed/simple;
	bh=iliNESQOeDobGewdbbUbXsvs6Y5CEaxm25avhAkMT18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=meLWqZOMtznOxCeFerIQsX16XKxsyA49oHPQ7Rg9l/0ixqDCrLlWKqvn7YP9VS15GM8kqq95DOOsimEjkipJC8PmQJu0UYT4EL2ietVqOICa1QqNvn7CRlUOeOc1TrXyl5vfK2r/K85PajNVDiibhTYcoP7e6M5+4a2QQzj96BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eh0xO4Gt; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso31430985e9.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755594538; x=1756199338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RbYlBne+CRt0rANt7gz2XsCKAdtbMUR7nWNO2HYDU48=;
        b=eh0xO4GtyM5YGXjPr5twFepjqa1qk8oalobxydLGISrWYb/dxjpQl7V4K5QOR5GAyp
         VGNJ5gmm/pq8CB3uydQCTbf9r/Uar/4yZh+PuYH5xgIUb96ThRQXLBYfxawDuoIW6nMR
         oMWLJKWL99jMj/V04nZ3JmJaTq9cgGVZqXUiYSGojRU1d3KA3Kc2KjMTxzFb+aHt5MFV
         ukBqfFUMXVTKoDHoA0kgDcTBVvqvQLPm0/W1TNGULKH4I0y1knkSdFcmjX6wqdP896L6
         SLHJAbHDNAqAKBi9a6ltI2bGv3GQkgGG1O+jqY0dXTuu6XAL0s8hjz5wWy37SylgrgO+
         p54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755594538; x=1756199338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RbYlBne+CRt0rANt7gz2XsCKAdtbMUR7nWNO2HYDU48=;
        b=PoUy/TL+uZZCKK75u3szj6xmzI4+roj87lZDYa37j808fZqNWM6whaz3y5hUwWMCjb
         BkjdGKJGI84Vu5h/Y8Zn97Ih/fq6HThpmgRymjwjXD40x/zFWe25y+h2ySxX6Clgfz7B
         kUbQmwXqV24/FeVC8b9dS26I0vmwGngu8gdIjMXnr8n7ubb7BzLaiybptuystNjKm/GB
         hqskqihoejiYb3nQY8SNwWbolZIis3a0yev5vFDrMhFEJ1jYqlelyIRf4eRvf1yMqmuk
         ximA/PggEkJx+l+dnJ5RkCVFJvz8A09B2WUfp0WQzo7E9TcmGsLWK8NeOKB31l6U5fjj
         kPAw==
X-Forwarded-Encrypted: i=1; AJvYcCXDrx+HUKEQ4Ofyv7g0DY1H0IZPTZSwtjwgQYQSs6DP5C7Pwx/1aoEJ1vtf75ufL72WFo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy08Wn1gAwTZNiykxsHphYuXZsKz10FrY5yF4f5ra1Uoiuyu2mf
	6UQkfnGdSgtmA6x2j40u8SX+Ys4rwTtKuw8+iCHYcBkj/hfTGopsdobAjNhS551MKIFVGgDzMI/
	hHw==
X-Google-Smtp-Source: AGHT+IFTda9OEOY5S6WXkDS//BLctKGWXODfwGT2L71EAeMG+xw30IhSWH1WfqqbuVudUz36x/Bwh88Big==
X-Received: from wmte11.prod.google.com ([2002:a05:600c:8b2b:b0:459:dac7:4ea6])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4750:b0:459:df48:3b19
 with SMTP id 5b1f17b1804b1-45b43e07202mr14121285e9.18.1755594538057; Tue, 19
 Aug 2025 02:08:58 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:08:50 +0000
In-Reply-To: <20250819090853.3988626-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819090853.3988626-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250819090853.3988626-2-keirf@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: vgic-init: Remove vgic_ready() macro
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
2.51.0.rc1.193.gad69d77794-goog


