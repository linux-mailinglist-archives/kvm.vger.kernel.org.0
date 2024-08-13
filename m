Return-Path: <kvm+bounces-24006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1E395081E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90A541C220D7
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7671A01D9;
	Tue, 13 Aug 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFuLmPln"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4433119FA8E;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560479; cv=none; b=lOCXAikRMLSm5c8jnF/hHjZ//fi7kGlwpDyFgSh6FYWWpWiY+Wdv4mXo02WspfbK6NsIlSxQmh9/b3nhWIhyfY6sNi5vkM1216ADX4iXUlDrpLBl/vRFfBHdBpPTxkMOTXUtFWep37H3z8VeFbm7NyPj/i8BrWzPkA9y/3jf1iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560479; c=relaxed/simple;
	bh=hMvaTIIDsws2gWarUwjsfFWKccw4pmnymZDpQdb9O2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GZKzvVyOyL34T2iqFvNZIpH8upT4T9L8DqY5akacYB/7V1zsAZD+doWx9YHZFp7QTKxLUbwD9J1kfMFMfBpigtgENgX8mEXbaJl9I9suHPQTPJpvSVnoJTaOkt+dqtcyTwVXu+3vBt9WmcFsKv0mK6lpMrLdGYCMSGF+li0kYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFuLmPln; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16697C4AF18;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560479;
	bh=hMvaTIIDsws2gWarUwjsfFWKccw4pmnymZDpQdb9O2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFuLmPlnki+A6KNzfNt3bJRtM120mELggB2D0lAavBB1tIQZ9nbigi0OMG9ZvuVVs
	 auGmEKfO96zwikNqfO+KJS+y2kMWy02XGPY1IVCzoPg3fcitJ9OAeCNMMv/HLhz4Wh
	 tn/Ipgh60DbUmVqYfWkwuhHnZnvhSXFFTmSWJUQDnHaxjuJmlxxMDdM5UqmsYmhT3O
	 HMKJ9hoUAAiQm5OHI4x9OocSegOO+m3ffw3mS+i0mLqg52efWMTNc+Sa2NkVqSYbnJ
	 LD2G6d3D9+BprlnC/zUGLeTDvZdGu7BnUC/YaKVMxu0ax8jqS2Eu2Y5B4d6fRxbOUQ
	 pGOoC478eM8Qw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoW-003O27-VD;
	Tue, 13 Aug 2024 15:47:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 04/10] KVM: arm64: Add save/restore for TCR2_EL2
Date: Tue, 13 Aug 2024 15:47:32 +0100
Message-Id: <20240813144738.2048302-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Like its EL1 equivalent, TCR2_EL2 gets context-switched.
This is made conditional on FEAT_TCRX being adversised.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 6db5b4d0f3a4..7099775cd505 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,6 +51,9 @@ static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
 		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
+		if (ctxt_has_tcrx(ctxt))
+			ctxt_sys_reg(ctxt, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -108,6 +111,9 @@ static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
+	if (ctxt_has_tcrx(ctxt))
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL2), SYS_TCR2);
+
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
-- 
2.39.2


