Return-Path: <kvm+bounces-32830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 827319E09BB
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:22:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 509FE162F26
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EA81DD0F9;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fud1a6Xa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A5C1DAC8E;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160139; cv=none; b=aAlYgJ7wC1gRR+HBEvOo5+F5uJZnV4d2s6lgbTW5azx0382CM6PZ5w3JdfcMXc6yd/eYaoiDD5R5+QLO0K6y5r4Y0+Z016Y0K/e1OTRjkZzOaikDmmbH4c3TEn9kYV+e9r8SM0tYjmszV4pMd2o1BBBezFYY1MNrpseBTUa/Swg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160139; c=relaxed/simple;
	bh=/6ehcPZl2b9FxW/6Rj24yU7DtKsnX/BkIYVDARjLPoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VjC45Luu26RpMl2llNGqVG1rUPxUDHtAjH4BOBj/zT3qCmb8tU4xDmXEoemkJxqOOEE+j5lMIresMxyonHX0Nr50WsPdFpjA78WFDAq9iuffwq861KN3F7wL7sI0Tw07vU3MATlTqmEP8E/EEQ5AiPKEoIhBfIO8x/cHFirg15g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fud1a6Xa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6BBC4CEE0;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160138;
	bh=/6ehcPZl2b9FxW/6Rj24yU7DtKsnX/BkIYVDARjLPoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fud1a6XahjKVbzv4IRn7pjn63JctMk52BEySVB1cxZgVntjdth78Iw/Al9jVAEzXu
	 YcMz1hSS4iQ4x2AmPlv2yaE8BDZK/TfcXebynLw0TDevjzCRwYACMnT5DHg08SneAF
	 SMMTkW3CTkpKwKyBYOYsmENY1caJy5BS+ckmdZnlcQIDePJe4b70oy8crbBoW9yCdu
	 ZgGFVGNUSzQYFgWyoFuGi6rPG+aAfzEhDZN88bGiuYYDf/TZXHqz+UG9DzJYxw0CUF
	 zsO/cOp9AvDxoeD9kBKzR3Vxrf3iBZ4rnfGaA60HkWK/GaYW50xrlYdFOhngOI5Hx5
	 B8Y8J5QDDuDxA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7k-00HQcf-VF;
	Mon, 02 Dec 2024 17:22:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 06/11] KVM: arm64: nv: Acceletate EL0 counter accesses from hypervisor context
Date: Mon,  2 Dec 2024 17:21:29 +0000
Message-Id: <20241202172134.384923-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similarly to handling the physical timer accesses early when FEAT_ECV
causes a trap, we try to handle the physical counter without returning
to the general sysreg handling.

More surprisingly, we introduce something similar for the virtual
counter. Although this isn't necessary yet, it will prove useful on
systems that have a broken CNTVOFF_EL2 implementation. Yes, they exist.

Special care is taken to offset reads of the counter with the host's
CNTPOFF_EL2, as we perform this with TGE clear.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 +++++
 arch/arm64/kvm/hyp/vhe/switch.c         | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 34f53707892df..30e572de28749 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -501,6 +501,11 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
+{
+	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
+}
+
 static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *ctxt;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b014b0b10bf5d..49815a8a4c9bc 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -296,6 +296,13 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
 			val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
 		}
 		break;
+	case SYS_CNTPCT_EL0:
+	case SYS_CNTPCTSS_EL0:
+		/* If !ELIsInHost(EL0), the guest's CNTPOFF_EL2 applies */
+		val = compute_counter_value(!(vcpu_el2_e2h_is_set(vcpu) &&
+					      vcpu_el2_tge_is_set(vcpu)) ?
+					    vcpu_ptimer(vcpu) : vcpu_hptimer(vcpu));
+		break;
 	case SYS_CNTV_CTL_EL02:
 		val = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
 		break;
@@ -314,6 +321,12 @@ static bool kvm_hyp_handle_timer(struct kvm_vcpu *vcpu, u64 *exit_code)
 		else
 			val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
 		break;
+	case SYS_CNTVCT_EL0:
+	case SYS_CNTVCTSS_EL0:
+		/* If !ELIsInHost(EL2), the guest's CNTVOFF_EL2 applies */
+		val = compute_counter_value(!vcpu_el2_e2h_is_set(vcpu) ?
+					    vcpu_vtimer(vcpu) : vcpu_hvtimer(vcpu));
+		break;
 	default:
 		return false;
 	}
-- 
2.39.2


