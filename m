Return-Path: <kvm+bounces-46541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53E8AB75C6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 21:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB1A21782ED
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 19:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453C8296700;
	Wed, 14 May 2025 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dikJrf5+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0CC2951BE
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250533; cv=none; b=utfja5lqhVNONWzjPPgUCTqSmzqcXFLoA7H06hUZlBfRu9CHy/Y3YYSmG514CrLJzD5PW/C9qvHqEy02a0rUCzjMux49A2k3nG1ao9EQQPoIVhjsXpCxe4OdS6p7Tq+BKtFqZZAS9pss9w/EOemg89E2xGww040DUPI5miclF8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250533; c=relaxed/simple;
	bh=YOzE7iJKn1cKrVnHeYmsANZJwRedYEE2+tWwGO6R4Sg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uyYBE+jQ6F/+R/VeF0eqnVAuYlFMHfmaQlOUREVbVDTwmqHKspXhnXfm6Fl/aJ3EA5m1gbdzaXpvU9sv/VA/vScCBxU/UEiqKrPN85TuGUNNfjqLquu+9mQyxcDrVs3DeYjJbwyTPZrEaNO7H24DH8zIN6nQ1KK0FRReWF4J4c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dikJrf5+; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-85b3a6c37e2so17012739f.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 12:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747250530; x=1747855330; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3CSQ6PBMOqGVYj+xqhMBfKnGOIDEpoWfmf6grdNY9M=;
        b=dikJrf5+joAOhXTosvS3NsOY/z+tSo4by/LgKMISPQSvAo/98Nx319OVZk9YWOXqy7
         wSqYeMbL9ytLGGTmyII2Dqqkuf4UQMt81cL3JO+yVo01vKEnVends0qUNGGNGtqgIwwO
         0bFEuOrPTdful96Gu/WK2Mw+TZwUyo61WvWztJKWM1O2GkgUPtbVNUMSvW3Ki5BProV+
         XpNb3K3PEAa0HHzQAymIKnmGTuaJkfClcl+dIO7LdndigYoH4p+fAp8Tf44GLRkFNGyJ
         PK1Uq60hfI8uHPjfBZj+FP8CgbIuApC8lDNYPOA6THNw6Cb60XGqpAjeEtgBa0bgu87q
         J+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250530; x=1747855330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3CSQ6PBMOqGVYj+xqhMBfKnGOIDEpoWfmf6grdNY9M=;
        b=cV3wPrA3xhaBUucXsYOIx6yvaCJ9z2xf3elWSgYhiXWRuwAzp31APaux+wlayFDibH
         aiNUuyufuh+DCqDeCRvBPd2NBFWhrjZjGk1FCNt6n1wJqdg2TvO949kVH/u31OkIV5CQ
         7/NOwf9HAAQhh0hEhhooXPt4BlOeLwy/B/Pl9WN7pKw5kQNuzXk6XAbimxXZJpoU+8qk
         8FFZkIH2Qrymb/E2TX5tGtJsurU/U19gOa2fSfWBdisGFgkY4K5E+YZi32GOW3DOWOez
         y5Wqja/Z3gbloMYtm2i/VLzmW2jD2uD+aG/6JxQSZ/+nalk+FJfv4zwV6EV/6MVaRIge
         KqCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUI6SSmsX3UhyeK1tMTjmfPhEO9zgLLzMZuwMUGjFbBSgb//4pGTXds79qW4ldPcARWDWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi3Ii6KCtOvBouUEqWGGfRQN4SbLxbZBjvjvUgq9YtL32WngK2
	gPHjtGIjQFw3TgR+IWLEdJHekjLyWbO/vJXw4MoeNEFTZmTvGVk7Haad/g+bAD948gfMM0rEMDk
	HenYZTA==
X-Google-Smtp-Source: AGHT+IGg18AnCuBF63uwtJjiLbr7/IX5pN6tnMFQzW8sojexBjp+3ynRNR8yhYl88WVyZs8zmM6M9UEXqLY6
X-Received: from ilbby14.prod.google.com ([2002:a05:6e02:260e:b0:3d8:1a1e:8c05])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:36c8:b0:85b:3791:b2ed
 with SMTP id ca18e2360f4ac-86a08ded21cmr611062639f.8.1747250528149; Wed, 14
 May 2025 12:22:08 -0700 (PDT)
Date: Wed, 14 May 2025 19:21:59 +0000
In-Reply-To: <20250514192159.1751538-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250514192159.1751538-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250514192159.1751538-4-rananta@google.com>
Subject: [PATCH 3/3] KVM: selftests: Extend vgic_init to test GICv4 config attr
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend the arm64 vgic_init test to check KVM_DEV_ARM_VGIC_CONFIG_GICV4
attribute. This includes testing the interface with various
configurations when KVM has vGICv4 enabled (kvm-arm.vgic_v4_enable=1
cmdline) and disabled.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index b3b5fb0ff0a9..adcfaf461b2b 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -675,6 +675,63 @@ static void test_v3_its_region(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_vgicv4_config(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	uint8_t gicv4_config;
+	struct vm_gic v;
+	int ret;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	if (__kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+					KVM_DEV_ARM_VGIC_CONFIG_GICV4))
+		return;
+
+	kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+
+	if (gicv4_config == KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE) {
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == ENXIO,
+			"vGICv4 allowed to be disabled even though it's unavailable");
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == ENXIO,
+			"vGICv4 allowed to be enabled even though it's unavailable");
+	} else { /* kvm-arm.vgic_v4_enable=1 */
+		TEST_ASSERT(gicv4_config == KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE,
+				"Expected vGICv4 to be enabled by default");
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE;
+		kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE;
+		kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE + 1;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == EINVAL,
+			"vGICv4 allowed to be configured with unknown value");
+
+		kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+					KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == EBUSY,
+			"Changing vGICv4 config allowed after vGIC initialization");
+	}
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -730,6 +787,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
 		test_v3_its_region();
+		test_v3_vgicv4_config();
 	}
 }
 
-- 
2.49.0.1101.gccaa498523-goog


