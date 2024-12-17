Return-Path: <kvm+bounces-33949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DA89F4D90
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C16216B578
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7B11F7070;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTyNMKwq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B000C1F5437;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445407; cv=none; b=Ql0cg6wWcdJmo7il3fWzhyk3D1nhncZVjPx+IgYFLFxAsY+n2QZrWItqVATSMzPVc6u6yFav5oSVgBvMeASje6j8rPoLaaeZ8SHsR7nLSiv9bQ33v69OqPiIE9NeKpYJYSuIg9Lcg3vD0g0IUl6iFe/QhV4JaUNn7AA5IUvZUbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445407; c=relaxed/simple;
	bh=pdUNx1WcP9RZOx0BJJpcgIOG/jIzcvGHKlE8NGg16b4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p/CfV5eqw/QkzRGwWAsd0qV97rtW20KN5KXqUukCCzAkRMoQEbfoRtENe1tuKd2MpeV+JrWr5JQ1b52GGccUzd+xUN0/iA+gEFhr4wfzmPrkaUmNLTexitqpA41gv2PlpjiZQlMTvGYJh/bM9IJvknaWkhQvTeRo+hgncdg7rwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTyNMKwq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DEFC4CEDF;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445407;
	bh=pdUNx1WcP9RZOx0BJJpcgIOG/jIzcvGHKlE8NGg16b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTyNMKwqoDSUGlXbFwtlDNiOjsx6vcHXEeWk1nuOFz2FzqdLFTUBSLotNEwrNL0Lv
	 z57MThzdsMnHppigUxDOe3tkGRPVFTwswtxjA5rjCHsiYFHM+qlv2H1lC02IKYfuNh
	 cw2EKsgtcN/tPA2rtzrMgLYPudwXCoTmhOY4J5BQ74zCvNjmSQ7hs3UHUnuJAPlEIP
	 JbAiw2frIyaoiMr1kltHNIlDDnyBPJOZf7UEwTG3IX/wJiiUI6X+QKaUlNa/YAQn/A
	 GHuA3LQ2cuQR2VA4NA030/G8Khca7EiZwNwq2BvY3AindO8Djbx9onaoqtszsAnVZE
	 XltAQ309VGUAA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTt-004aJx-ML;
	Tue, 17 Dec 2024 14:23:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 06/12] KVM: arm64: nv: Accelerate EL0 counter accesses from hypervisor context
Date: Tue, 17 Dec 2024 14:23:14 +0000
Message-Id: <20241217142321.763801-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similarly to handling the physical timer accesses early when FEAT_ECV
causes a trap, we try to handle the physical counter without returning
to the general sysreg handling.

More surprisingly, we introduce something similar for the virtual
counter. Although this isn't necessary yet, it will prove useful on
systems that have a broken CNTVOFF_EL2 implementation. Yes, they exist.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 51119d58ecff8..ef344bcff09a1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -324,6 +324,10 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
 			val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
 		}
 		break;
+	case SYS_CNTPCT_EL0:
+	case SYS_CNTPCTSS_EL0:
+		val = compute_counter_value(vcpu_hptimer(vcpu));
+		break;
 	case SYS_CNTV_CTL_EL02:
 		val = compute_emulated_cntx_ctl_el0(vcpu, CNTV_CTL_EL0);
 		break;
@@ -342,6 +346,10 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
 		else
 			val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
 		break;
+	case SYS_CNTVCT_EL0:
+	case SYS_CNTVCTSS_EL0:
+		val = compute_counter_value(vcpu_hvtimer(vcpu));
+		break;
 	default:
 		return false;
 	}
-- 
2.39.2


