Return-Path: <kvm+bounces-44451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F027A9DAB6
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B2569A3C75
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A79F2561B6;
	Sat, 26 Apr 2025 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8g65JXN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327C1255223;
	Sat, 26 Apr 2025 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670543; cv=none; b=cFax0n1iKLFC07PgzpAJKybVDw4vzh9KaBX+S2hNTlk8Iw+IUuZsDegXjhtLmya2C3SSr3uWARHB8WM3kmEOxjDQhZt8RaClZuieUc/u/dOu2tJcJ8VbRmiab0QwyYicOauQm5RCO5UL1o3EwJNl9Q+0tR7nfrIbk+IVHErdjPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670543; c=relaxed/simple;
	bh=GiGc1R1Pi1q8F7lTqhQerLhx4turyXGHxprlQAfaI0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A0gaB/Bd/iIT/4g0Uw6Bu2e2mGIrdOEw6C0GpnTlov/9rKbYnBbPos8wKbqcerxe7Bc4dtTEOp0QC4uq+r1hH/8iTaM+eCzp159ZWhFZDy07HkwFG/NTYMVv5721GOG1u5dwcAtn7601WibpsEVGxISw5P3HfmzuQAWDBUrCYLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8g65JXN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2749C4CEEB;
	Sat, 26 Apr 2025 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670542;
	bh=GiGc1R1Pi1q8F7lTqhQerLhx4turyXGHxprlQAfaI0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8g65JXNF9BgHfxSJIW3oelUbZh0FRuOuKnx4xNmhVJSedV625rh79UWR2PgaGHwX
	 eNPt3jTYqbOs5nCURrM8Z+ZJYX3KJoVfoKCfI0UT0MgYQnHiyj9hWlxpX2LYZQGHu6
	 +PXroWRg30J1ftCp9JjDkotSf3gdHysICUWcAJjEqG1UBvdQ2iu7bFPM32tp1Ryy0B
	 a6vZQCY9rdq9IdnQeJUNI9tUszdcqyGbMQnvZRN+g3P3RAdAGHsZvDmpmOQ2olAYmk
	 +GC38BIJThwCWJLihHWUv6Yjl9cA3Ugn2rHzlnzAdb19MUsdyIcEs0QRWRpYeX2Eww
	 sl0LgiV8uzCog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeS-0092VH-Nd;
	Sat, 26 Apr 2025 13:29:00 +0100
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
Subject: [PATCH v3 38/42] KVM: arm64: Add trap routing for FEAT_FGT2 registers
Date: Sat, 26 Apr 2025 13:28:32 +0100
Message-Id: <20250426122836.3341523-39-maz@kernel.org>
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

Similarly to the FEAT_FGT registers, pick the correct FEAT_FGT2
register when a sysreg trap indicates they could be responsible
for the exception.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3312aefa095e0..e2a843675da96 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2485,6 +2485,18 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		}
 		break;
 
+	case HFGRTR2_GROUP:
+		fgtreg = is_read ? HFGRTR2_EL2 : HFGWTR2_EL2;
+		break;
+
+	case HDFGRTR2_GROUP:
+		fgtreg = is_read ? HDFGRTR2_EL2 : HDFGWTR2_EL2;
+		break;
+
+	case HFGITR2_GROUP:
+		fgtreg = HFGITR2_EL2;
+		break;
+
 	default:
 		/* Something is really wrong, bail out */
 		WARN_ONCE(1, "Bad FGT group (encoding %08x, config %016llx)\n",
-- 
2.39.2


