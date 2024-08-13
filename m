Return-Path: <kvm+bounces-23981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9096F9502B4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38D601F230C1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5041819B3C6;
	Tue, 13 Aug 2024 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bexLQW99"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A2F19AA40;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545851; cv=none; b=aVBFM+iUTAdm91xzJJ3fCsyrO9G8udxE/DnsLyOmo6Dmt9dh/c9J89DqwuTWIJh5JiPZ6ftviVzqoZVNMyjVVWc2Uwf2s3g7YKdjtsB52jbbq5Mg5CMPTg48vZxixJsIpY9H55tC+QlPbNcYdDHRAAZUjCqItfnU43FLz5YCC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545851; c=relaxed/simple;
	bh=4HwTm/sykbQDERcywrayLevJsGBUpXDaZP64IyuOh0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t1P8Ywa7L6aC0yDSYPgcymuwx025Sd2DEZMif4Dc6ZpbQjYf6yXirJq8qm9Ofcn8goB4OySYjYUlKkFhu/dyqt6lw+J+SIHqk6M2Q7/xRQvF9H6dgqPEkVgX46/Ay0g2PmpnNK/nykEBW4bH9sFADIfGoCQPJCHMN5KHrGgrjuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bexLQW99; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117E9C4AF1B;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545851;
	bh=4HwTm/sykbQDERcywrayLevJsGBUpXDaZP64IyuOh0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bexLQW99LYdXFHqeHe8Xke5P3TncehoVUdHjMott4SX2a77ePCxuOfkAm7UMk3J5T
	 4dMqlS0cFiAMLTxZmUO+jhHeSDyfMh75gzIDnpTBmbUs7H+9AwVLyxmoHuvnbgUY0O
	 Rd/2JacH9fbFD1+M8cl2ExEyTxj+c1ePdo9YT+HlXSYNQ05AmixxR2dQw8B3eqsVUF
	 fpfXD6NVc3UEKQT6SP0gV2LcybGRqP6/cnfovk/3IQO6SNQ1c5b5vC2TkvQ0knwty4
	 CbtqcJWNp3omX2vg0CMCphCNVZJ0EcAI+qtw2wxJeBIurKZqJXvq3yQNGd/l/qZ5Ny
	 BaIwPzqovkofg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0b-003JD1-AB;
	Tue, 13 Aug 2024 11:44:09 +0100
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
Subject: [PATCH v3 7/8] KVM: arm64: Enable FP8 support when available and configured
Date: Tue, 13 Aug 2024 11:43:59 +0100
Message-Id: <20240813104400.1956132-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
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


