Return-Path: <kvm+bounces-50472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD454AE60C2
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE6A540720B
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7586E27C84E;
	Tue, 24 Jun 2025 09:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdRkeQP3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE4A27BF93
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756990; cv=none; b=FtMov8Q+UJye5aYVnOlPI+NxqHtiS4TXl3TQYcd3yNxHbxaz6C3dk0tYzSsAoZxBccRxH5edvNHO2nuOdnZzt7EEWy+4hk+sEH3B2YjJ0dCJXXPmUqBFspo7UAzi/gu0AJ+hUA1CyjVmcu2hCY0yN3dyJ+0I/3MvX7NDrlz5bsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756990; c=relaxed/simple;
	bh=l3m7FhiLM/McN3mI9q18qHpMk9udwtRdVtDv+3q2NY0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CPD05El86QU6EuWcOXiBsfiK92mklffH2j6D5Ai62Ybf224aa8rdcseQByIW+UHecnI0DM2Hk2pQsuqMzT+Y7BfpmJN2pN4Y/WrAvb64N8kNzVu+QedpVS7ikxc+fxlss5BWW2M+0goPQhaDlDqiJtRCEFT5P/QtW9FrvAL+B/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdRkeQP3; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45311704d1fso32528345e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 02:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750756987; x=1751361787; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gnkSB92ftCEMF+gRpwfaLkPqS/gljqC5XzxNgYk33lQ=;
        b=fdRkeQP3MC2sRJwPJoqFXGTHwdXoRgSfaarKB+4yeYuvwstP4LQO5F3zUKnP5h3kRw
         6FknpGo/yKB6mY49HV1Bsmx+Tgi9I2PlRdtpkAk34yXP9ZQGzZzXYBkOynILajQNAqix
         FF2yyxFHboR8awt9XSrgEMNr0MJJ0aSmerszkyYTiRGN+16Q7UMsT0ESmUzhkNTwTGCL
         WykDpqkuCms0blam/zIT3uoiNbxHW18QFGi59yBzw924FWV98fsdsXWRhGjt66Kjkujh
         evtc73I9RqVmOOZMvlvi1Fee2Dlpv61shxL1ZDmFkM3/jBEVdK80P8Uuj0dxZbc2yg3k
         INqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750756987; x=1751361787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gnkSB92ftCEMF+gRpwfaLkPqS/gljqC5XzxNgYk33lQ=;
        b=elN0meI9iaBUg3pgonlpgrtEpa+lhZk7b/UK1EePa/yc6EaE5bjGx9o9fs9FuIFL5A
         i9ajy0pAteqsqn+sF88SSEczoBnlU9TxxvSVzSkqe+cUSP1JmwdHizGT1ZpINuXZ1vQ/
         B76JwYqQVc0q3OMpn4BSNfWLXwYSkPWTTb//oT4KXDBPzOaZXPhC4xX5i2QdHjm5A5qf
         VhpqvmEx843B9Qqidq586CWeX9xlVPVNEl7q1BKZXg/JVb9USVLHLvql7KU5SBeqENDv
         xoPAXH919MVGZAhEJUWnh/KsNCf8t6bH9rDk/mxYZQVnJPdFCTDNZwXDD/JvRS7oceyK
         dFrA==
X-Forwarded-Encrypted: i=1; AJvYcCXXu1/etvb9x6lmwBeBKahPU7TbJ8qZiQJLtPDdh5dqdQB7LYD/pY70ktToYhXJTsmk3ew=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTOseqeCX3Ra8fO5UNTqAWFuw2U2dxZBEYQDI7MPAekuJgZh5S
	o4mK4zOAlvGCRyabFPhZ850BXYQVAB8tCC/y8NS+t5smYohClNbMdyYyM8unXGiAeZrZm8U4Bm3
	Png==
X-Google-Smtp-Source: AGHT+IENBGL6rEhAk+NNskr4lOMge+pijt5IJ1Z408FeHTt6NB0j+98GwBkWX+DuFsdVnafeh8q4qfdzww==
X-Received: from wmbel22.prod.google.com ([2002:a05:600c:3e16:b0:450:dcfd:1870])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c99:b0:440:54ef:dfdc
 with SMTP id 5b1f17b1804b1-453659c9c2amr140402165e9.8.1750756987581; Tue, 24
 Jun 2025 02:23:07 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:22:53 +0000
In-Reply-To: <20250624092256.1105524-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250624092256.1105524-1-keirf@google.com>
X-Mailer: git-send-email 2.50.0.rc2.761.g2dc52ea45b-goog
Message-ID: <20250624092256.1105524-2-keirf@google.com>
Subject: [PATCH 1/3] KVM: arm64: vgic-init: Remove vgic_ready() macro
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Keir Fraser <keirf@google.com>
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
2.50.0.rc2.761.g2dc52ea45b-goog


