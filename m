Return-Path: <kvm+bounces-18137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E628CE6E1
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0507B1F223F7
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABF712C7FD;
	Fri, 24 May 2024 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BA6ph51F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E91F12C47A;
	Fri, 24 May 2024 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560413; cv=none; b=mn4P6pz49tncuvBm4iNnjQ3/+hPqaCxsED4H+kyQXnyly3yyuUcfxauHGyKdmDRWzbWe67w63q56GCGtYYzaOvRFfUV04JROVkuwcBHGpKgkw1BFGArDFZMgQQG2aWljCmXIHU9RgvwGwUlTkrvfRCtWZXmPtr+MeK8JCsqWV2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560413; c=relaxed/simple;
	bh=iIdRYg57SpeBw9lBpc2D4+wuU3F3SdjQYymK7xok+G0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cyjwY0C6gRtVJ+T9npos2F3z2YpJ3lSzRbeKtgU3QGM7tLzTmegI9I7z9QfPMnnWySc6FPvElju61Dt50IiQB41xpu2Nn3a2XPWR/qQNX5KbedrPNJiBlNkWU2oWRnlSMGqJflypj4pxDTqKCQEN+VADdQEjuWxo/FyuI9vwVJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BA6ph51F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074B3C32782;
	Fri, 24 May 2024 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716560413;
	bh=iIdRYg57SpeBw9lBpc2D4+wuU3F3SdjQYymK7xok+G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BA6ph51Fp/v6UuF+peq85zhAGG5SWQWnU4+1HfNiovp29zouMfIUR1PgzCiVvQSnS
	 78lrwP6TXP/4epSVxDfc3lMWO2dmvmYOVkIMSqEGKckOojDPGzFzrfuN55wqqybkT/
	 cDfXv1/x6t2l7CQruK043drSBUQnHnH6yx7bh/nBiV+wlNZVH5wQiJQ598V4KLDj+l
	 t/vPmcx4WjK2KESEMkRwpw5i8eg3lI+UeBVL6+gvTmRFFD2oVV5kjhn+JURyyhBjFg
	 6OmMkZ7BIS5jHjihscPkTh/v9cIDRBq+V2YXlSRm+XBapkrS6bLtyC6rsr/MBM73/s
	 rsyaKAtnN3ymg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sAVmF-00FRdK-2z;
	Fri, 24 May 2024 15:20:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Fri, 24 May 2024 15:19:55 +0100
Message-Id: <20240524141956.1450304-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240524141956.1450304-1-maz@kernel.org>
References: <20240524141956.1450304-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, nsg@linux.ibm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It appears that we don't allowed a vcpu to be restored in AArch32
System mode, as we *never* included it in the list of valid modes.

Just add it to the list of allowed modes.

Fixes: 0d854a60b1d7 ("arm64: KVM: enable initialization of a 32bit vcpu")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/guest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d9617b11f7a8..11098eb7eb44 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -251,6 +251,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;
-- 
2.39.2


