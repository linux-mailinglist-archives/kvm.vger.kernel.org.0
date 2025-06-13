Return-Path: <kvm+bounces-49447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21123AD9207
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D26441E5C64
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12F220F060;
	Fri, 13 Jun 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YQZ6wGNI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B4020F06A
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829966; cv=none; b=qjnzbdn0fnK3pGTlqeouEtpBV7PiQPeEFEnRiN8KxEtlGzTk/w4Wn04VbgL0hk6UTko8TANefL22ffpfWndYNCBmcq0eX0Z2yM63klfrx2FqIyeaZMyMaegle4wbezuUJYAVS4l4BU5dRx5XWU7yYr/G1qI8gAZIN5F0cAMu6RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829966; c=relaxed/simple;
	bh=Ci1/ilbhd8VIC+oxHWhP8i2cQbOsisZvulH3qn/eMlw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=juQ4Uu1th76exhKiOWQAMwPCk8bUtZIEnGdDFgQW0HN6n+/5zKgJzNvaEmO1JUIO/a2y63LInXseLH5JjKI9u2IB4JkW9gSZgOrViVkMH6fWKTav6A0wS/d5n5NZMs3Ifwbs5jk6PP97Issy3C8ZRPjnJYnyZEm//2psFH9G2CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YQZ6wGNI; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-875bd5522e9so234036539f.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829964; x=1750434764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oeEVYUZ5YyS7Po4kQ9W2WYTxXWOxgfNLZlSZcUsGw0o=;
        b=YQZ6wGNIXeW2/Nlanw70aG8mRTW090hfY1ouit3nTVAJfMt3n3N3bySphy1+uE2Qfw
         86hnPRpSjvrrHUk/sLdFPipYminFedCVqDS/7rhcFIGJKvng1NFK+b8AO4smE7N08Qje
         I2VL0hiwYTYYkxnyZT8h+fF7jcbOyk46XWyXH6CcVsPsOlOkVmSZz0nlHvczuokZ9L1s
         1baCS4tTqWteNwzKYQHfYyDiy9aqNFv3MegoeuWuKoopLgLzq8NNSKM+C7ez+5SUVvtG
         zYA0RgBFxSdB/C7kJ1mt2s3rms1CAlZVxbGCt493FKmpvH+ffmhFFokZmiLpMYFDFQUq
         Sw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829964; x=1750434764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeEVYUZ5YyS7Po4kQ9W2WYTxXWOxgfNLZlSZcUsGw0o=;
        b=SpcvYjU2NbtQR67VelwRIcktKTNSYHKnNiQ3urDRIQKHsG/JFCwyVKibV8slpCZU80
         A9l17lyjSytzx2ENwsMAhR2R9mrZy8yZkErmHHS8Yrwm8/j8R5cYtRuVtnLCLTGzkTaI
         cJ6HijvKOtiGqF8sJDX4/njbvLgCbpRDSZ9IlBLyjN/e1My8kltMaEvXXsBlxIcXaqle
         f/K9JWLzUDgIYWayP7geUXB8jcn5BY+kYDkMcP2H9lunX92eJR/gXITr9hVdgRtjPAQ2
         mo3w9tnJXcx7JobArrcQ4Yn11i4eP/mYaYlW+MwqMQ0xYPqnY6a1ZDJoobBFR/vCnlHN
         d4lQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgeySIIuvG50TAs6Mwzh+u5wtxWphtFT2c0CL8sb6Kxw66z53Lg1hWfVFoUTS9ypDDrhw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPl+oBgbxwL83uZaJkx94WHexGNJYXmesxsuDDN75JQ56xsdKJ
	2WGtWesSMPC0i+/vfNRSw7wZbX3xr2LNPrxTm5LeGTTBm3fFdku0uHg1AUK64t08FIqsN4tcrYR
	2eaqh8Vm/9A==
X-Google-Smtp-Source: AGHT+IFunbFJhKmi5ZFShXe5exfB3EJuEIksn0wi7XdmxJ1Imwtlw1UTfq/1Z4OxBS2uV1KpJFLBY6hAS3Gk
X-Received: from iobel14.prod.google.com ([2002:a05:6602:3e8e:b0:86c:fede:130b])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:7504:b0:873:f22:92fb
 with SMTP id ca18e2360f4ac-875d3bf0780mr439553039f.1.1749829963955; Fri, 13
 Jun 2025 08:52:43 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:35 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-2-rananta@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Disambiguate support for vSGIs v. vLPIs
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
if either vSGIs or vLPIs are supported. Pick it apart into a few
predicates and replace some open-coded checks for vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         |  4 ++--
 arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index eb1205654ac8..5e0e4559004b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -395,7 +395,7 @@ int vgic_init(struct kvm *kvm)
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
 	 * enable it if we present a virtual ITS to the guest.
 	 */
-	if (vgic_supports_direct_msis(kvm)) {
+	if (vgic_supports_direct_irqs(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
@@ -443,7 +443,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_supports_direct_msis(kvm))
+	if (vgic_supports_direct_irqs(kvm))
 		vgic_v4_teardown(kvm);
 
 	xa_destroy(&dist->lpi_xa);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..1a9c5b4418b2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -50,8 +50,12 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
-	return (kvm_vgic_global_state.has_gicv4_1 ||
-		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
+	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+}
+
+bool vgic_supports_direct_sgis(struct kvm *kvm)
+{
+	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
 }
 
 /*
@@ -86,7 +90,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case GICD_TYPER2:
-		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
+		if (vgic_supports_direct_sgis(vcpu->kvm))
 			value = GICD_TYPER2_nASSGIcap;
 		break;
 	case GICD_IIDR:
@@ -119,7 +123,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
+		if (!vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
@@ -133,7 +137,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		if (is_hwsgi != dist->nassgireq)
 			vgic_v4_configure_vsgis(vcpu->kvm);
 
-		if (kvm_vgic_global_state.has_gicv4_1 &&
+		if (vgic_supports_direct_sgis(vcpu->kvm) &&
 		    was_enabled != dist->enabled)
 			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
 		else if (!was_enabled && dist->enabled)
@@ -178,7 +182,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 		}
 	case GICD_CTLR:
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1)
+		if (vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..e7e284d47a77 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -356,7 +356,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
+	if (!vgic_supports_direct_irqs(vcpu->kvm) || !vpe->resident)
 		return 0;
 
 	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
@@ -367,7 +367,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 	int err;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
+	if (!vgic_supports_direct_irqs(vcpu->kvm) || vpe->resident)
 		return 0;
 
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8f8096d48925..f5148b38120a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -951,7 +951,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * can be directly injected (GICv4).
 	 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
-	    !vgic_supports_direct_msis(vcpu->kvm))
+	    !vgic_supports_direct_irqs(vcpu->kvm))
 		return;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
@@ -965,7 +965,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
 
-	if (vgic_supports_direct_msis(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm))
 		vgic_v4_commit(vcpu);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4349084cb9a6..ebf9ed6adeac 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,13 @@ int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
 
 bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
-- 
2.50.0.rc2.692.g299adb8693-goog


