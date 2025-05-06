Return-Path: <kvm+bounces-45651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 437B2AACB6A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3C983BA5F0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFC9288CB9;
	Tue,  6 May 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbfMthXX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A98288C33;
	Tue,  6 May 2025 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549857; cv=none; b=AL7o5j8/zEdS9jbhPvZyvmran2KV/s35QaGHSIxmEcOGDubS9fvWlrJeHTFnm/pYzHZFgoTpci3fLwvHKmL+PT6XkGUYOM+Al9L23QpYq8IYkPW9Cai0QkCen+Jj/nIAnQ7IhUzNn+bPdaGl3rhkSDCVIleNWs4eCeZzPeWKHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549857; c=relaxed/simple;
	bh=U0IcVwx7DI2PFPXqgbaLx9sOFJAOnAR9kyfbtx5vOZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lwHOMAclA2c3QUPSW+EqrQOnRNc8l4mUnGxlHYp//l7E/NY70xaCa4S/7dN3vzAwmyXsRvVjHmBo8QCu3bJNaYaTGiuVnGwskXq0XLnsTWhyRiSWkOxwhkBQkoAi0+4LkWXR6YAKkUhFkb86vN7KkDrm9cuoHYrUaoEkOMZR4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbfMthXX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F198C4CEF0;
	Tue,  6 May 2025 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549857;
	bh=U0IcVwx7DI2PFPXqgbaLx9sOFJAOnAR9kyfbtx5vOZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbfMthXXrG2B98prBj1qwxcDUIP11stPeQB7X6HuPgAslYvm48/NlFGsAa9/K/hNs
	 U79g3YLLMvLvoZj7VJ5NzeRV9o4Oi81FBExmYMX6QWBTv5UxMqUh/3k0Ow91kWu5JK
	 W9x6ncFVb7e6SEq1zAsjjWCPvZEIODEH0QC2S08gqR26/pIbdVWAwiueJJJPRo9Tng
	 GcMPqU664o3zRfwlq0mnLDj/bUHl9xMACX8mC56r0AndPtnQ7bVubUmth3R06FCA7E
	 EWA+vulDqpSeTL2I27z9sahijwW93HxkR8MqA+Q11sv6bPBZPQN8sJZz9QrD7LpcUt
	 qzhLruD87orWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOx-00CJkN-F7;
	Tue, 06 May 2025 17:44:15 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 40/43] KVM: arm64: Add context-switch for FEAT_FGT2 registers
Date: Tue,  6 May 2025 17:43:45 +0100
Message-Id: <20250506164348.346001-41-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
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


