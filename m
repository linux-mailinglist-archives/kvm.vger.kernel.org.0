Return-Path: <kvm+bounces-24634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F3C9587B7
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1EF81F22B9F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71981917F5;
	Tue, 20 Aug 2024 13:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvkc17j8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CB2190667;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159889; cv=none; b=HdX/EeFOZcV1NWIycdg1Is0ios/TJ9tCON5qBDE8EQDGdFh5ULFbROaW6F7n4O3amWCK8U2t1mC73MGKQAO2sJY0XwB4U+npaYCON6boPCLRwhKhDGZy5rSQcvB8DV8a7Uv6vBThEhH8EoapnTmrNRPXRzgClTQrzyDTaq5/DQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159889; c=relaxed/simple;
	bh=4HwTm/sykbQDERcywrayLevJsGBUpXDaZP64IyuOh0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JVWpjgrIYnRU+vFTkHkzXE4kMdkmjNBe3Xct2rYiUILltVlA4z1vmhnsS+quYv+vEaEc7mDRPiK+irmOss/bvHY6NG67x2dg2d9lcoZBnEWoZQYEbICH3Io18AOGqj70+cNSYZR3CeGn7y3smU0KKJfH+3oVOVZLX4e9NGZDoxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvkc17j8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5E5C4AF15;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159889;
	bh=4HwTm/sykbQDERcywrayLevJsGBUpXDaZP64IyuOh0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvkc17j8pl+DVKtIgXfnWRICW/rl5T1oS7MvQqwy7FJjSE0NMop8y6QK0ZOf/K51L
	 XHPIrSBEv0Mm9/SfgXWngLWWastDaSmui6uoTvY0OtZW1KQz6uparUvxscygvT+mtb
	 N5eFgY/OF4fM8SY8O+OkraSuAL9njzldpoki+DVJpyU9zuyZ1ElfC/YL7FrspSgmoU
	 YTsZrVF4n/oRvQVr1fraqRaN/AcodWNl2jlu+RgTXm3kdJeYtij+zAvrXtqCzeAT/Z
	 AvlDF+ZyvSYpMXn6flyZMRyKUhVazZHaLC+XtQjgk1a+o6RYYv4OP36UkhP3V51dBY
	 nthzdx1ktdMPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgOkR-005HMQ-D3;
	Tue, 20 Aug 2024 14:18:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 7/8] KVM: arm64: Enable FP8 support when available and configured
Date: Tue, 20 Aug 2024 14:18:01 +0100
Message-Id: <20240820131802.3547589-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
References: <20240820131802.3547589-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If userspace has enabled FP8 support (by setting ID_AA64PFR2_EL1.FPMR
to 1), let's enable the feature by setting HCRX_EL2.EnFPM for the vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4c2f7c0af537..51627add0a72 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4579,6 +4579,9 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+
+		if (kvm_has_fpmr(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
 	}
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
-- 
2.39.2


