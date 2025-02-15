Return-Path: <kvm+bounces-38298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE3CA36FD0
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:38:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B81A17031E
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD67B1EDA13;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB1ock6H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089913959D;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641103; cv=none; b=X3WoZhlwppuMVqyYL1UvbCcErYDllH0HL5c2wDHEL7mYSWRtpNL5qW0x5kbO+dR/upSeGUG9wkDe+u2dQBYM8MUEw55EnvAL64SFBMqRnMQq9nBOAsMQCxrmCrEzrQoLjZhtMKz0zmS0FLcavBH2U8JQ5MigTHCUDiwEYVm+VB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641103; c=relaxed/simple;
	bh=rjDmx4d677pB7gUG89fk/kXGjM99BsbpDijy6LWcIC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ove9l6FAPkfkH+We4f2/KjxOUKTBF7tFaGI0poa7OIOs1KONL2KB1qZEchifAWfSzGlAxq3iuxCkJmYZJLtlSScVqyiEWoKM/b4Ys/TNbiyl8oPY+eWzbcPy0JL7DjLbAEIG/cIOlCrf2rgTSP8FFXMACwILmuK7lcAACqrKmc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB1ock6H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79089C4CEE4;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641102;
	bh=rjDmx4d677pB7gUG89fk/kXGjM99BsbpDijy6LWcIC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MB1ock6H2jEKead6FUX2Mb1dzKdGqK7bAfbdZJ+WFrUGzY+8OoBzgJj3vA6g75CVS
	 k6OizBAa2gioNtaV2qRR9flv665jd7w1VHU6nhRQZAz4DMcRajotydJK4ITlakyLzX
	 8ek4W+HtNTiJkYXju+Kmfc0vuAad/7pKxEgUe2TMFqsZLEDSzbLSiNAB4NG0Cc+ZD5
	 h0PV6SmVj8/ZZ/DGROqtRjhEf2tTEbv12uReVulQpKBbun0MyVDz50X0IOX+vejWqM
	 cQi1cGsHGxlFlSUsxXUn23CZvHkMvLTGyvSFsYtYOmuF86Lso0Cu3Ez+XUh/IYdetK
	 aBXez24A/HCQw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7Q-004Pqp-Md;
	Sat, 15 Feb 2025 17:38:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 02/14] KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
Date: Sat, 15 Feb 2025 17:38:04 +0000
Message-Id: <20250215173816.3767330-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since our take on FEAT_NV is to only support FEAT_NV2, we should
never expose ID_AA64MMFR2_EL1.NV to a guest nor userspace.

Make sure we mask this field for good.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd02..9f10dbd26e348 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1627,6 +1627,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		break;
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+		val &= ~ID_AA64MMFR2_EL1_NV;
 		break;
 	case SYS_ID_AA64MMFR3_EL1:
 		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
-- 
2.39.2


