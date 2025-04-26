Return-Path: <kvm+bounces-44450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6010CA9DAB3
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C74791B613C6
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E194F2561A7;
	Sat, 26 Apr 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBAsu569"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C262550DD;
	Sat, 26 Apr 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670543; cv=none; b=i9MjjA7WapwoPpjVf1X79dGxJxNDNqVtKGSxB4/r5EsdPPnKzAxU4/XPRmYjsoCKiDWw2EBAce/WrfTJBqwmrQNeowBMXCNatiJWxRXlHmfa6GU5Px7PqhcjjuHrW+AS2mTB1/GA7oHTiAL5ZFooPOLCA+lsmT2MhNJGTQveHdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670543; c=relaxed/simple;
	bh=U0IcVwx7DI2PFPXqgbaLx9sOFJAOnAR9kyfbtx5vOZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FqBhW4xdtA+1oyggkCzizCiTSNMuay+I/Cr7zFig8B2aPZ6HUU/pn7v778GCMTdksHmmlQoj8JEca/VIXg6cIeVLhL+KogofZ7o6kWODOrnioq+d/SyMJadNZBqrs9l1NyIYjgWtp9ZrfNS/l808oijU/6c5hhN/t4hqAmlrD6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBAsu569; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E565BC4CEED;
	Sat, 26 Apr 2025 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670543;
	bh=U0IcVwx7DI2PFPXqgbaLx9sOFJAOnAR9kyfbtx5vOZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBAsu569u8GkwsBFemGInbv3/S5nyd69v6PXGeVeVkak0TBu0A5e7pSxEH89TK2Qd
	 M5OCO1OEftruULGVy7VTh2mGfwt53/9Lf4djvbnqV0061WLNKne57g78z7u3W44HEb
	 q3ROoNmXw8OW6zUt5iTOq7js5cZCwL1sEWYTRoaAw/JfKk+btUk3AjDxCiiKNjoJ7E
	 3vaVTkgWIVxfVbq5Bw6o7CZ1C2v4IVyNGCwg75pLHAwfVU4TYp5LUVxg+wifxWDl+w
	 yd5yVkKiOm6Yda+TZxxplQIPnmfWsW84dozZ8sOscf1x0zuL3Q56orsgmKAIi/lgsu
	 P8AMNrZ70bBzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeT-0092VH-1M;
	Sat, 26 Apr 2025 13:29:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 39/42] KVM: arm64: Add context-switch for FEAT_FGT2 registers
Date: Sat, 26 Apr 2025 13:28:33 +0100
Message-Id: <20250426122836.3341523-40-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like the rest of the FGT registers, perform a switch of the
FGT2 equivalent. This avoids the host configuration leaking into
the guest...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 44 +++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0d61ec3e907d4..f131bca36bd3d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -87,6 +87,21 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		case HAFGRTR_EL2:					\
 			m = &hafgrtr_masks;				\
 			break;						\
+		case HFGRTR2_EL2:					\
+			m = &hfgrtr2_masks;				\
+			break;						\
+		case HFGWTR2_EL2:					\
+			m = &hfgwtr2_masks;				\
+			break;						\
+		case HFGITR2_EL2:					\
+			m = &hfgitr2_masks;				\
+			break;						\
+		case HDFGRTR2_EL2:					\
+			m = &hdfgrtr2_masks;				\
+			break;						\
+		case HDFGWTR2_EL2:					\
+			m = &hdfgwtr2_masks;				\
+			break;						\
 		default:						\
 			BUILD_BUG_ON(1);				\
 		}							\
@@ -120,6 +135,17 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		case HAFGRTR_EL2:					\
 			id = HAFGRTR_GROUP;				\
 			break;						\
+		case HFGRTR2_EL2:					\
+		case HFGWTR2_EL2:					\
+			id = HFGRTR2_GROUP;				\
+			break;						\
+		case HFGITR2_EL2:					\
+			id = HFGITR2_GROUP;				\
+			break;						\
+		case HDFGRTR2_EL2:					\
+		case HDFGWTR2_EL2:					\
+			id = HDFGRTR2_GROUP;				\
+			break;						\
 		default:						\
 			BUILD_BUG_ON(1);				\
 		}							\
@@ -182,6 +208,15 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 	if (cpu_has_amu())
 		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
+
+	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
+	    return;
+
+	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HFGWTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HFGITR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR2_EL2);
 }
 
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
@@ -205,6 +240,15 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 	if (cpu_has_amu())
 		__deactivate_fgt(hctxt, vcpu, HAFGRTR_EL2);
+
+	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
+	    return;
+
+	__deactivate_fgt(hctxt, vcpu, HFGRTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, HFGWTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, HFGITR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, HDFGRTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
 
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
-- 
2.39.2


