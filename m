Return-Path: <kvm+bounces-45628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADAFAACB54
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0CD417779E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D2A2868BE;
	Tue,  6 May 2025 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIZ+RaXn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598F286880;
	Tue,  6 May 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549851; cv=none; b=pafoCxr5dk/NccUsxFUaTp2IQCjyjw23vz92u5aNSLo4hO//ii6dkYX4hJ4MEaYWz2yzBAzCA49HXvUANdPWnoXbLJUnosm7Y1YVbj6gJecx9NNzAd95JhOFvO8Hqlex+HQ0jAvmYOOF9hQEiKQQVE2QgBG2W09vfHYlNh6BqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549851; c=relaxed/simple;
	bh=Uxgz86q4vttcqou3lbEa8mbH5Xk35X47+RPO2LMlXkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n7Lp9ioq6BZCOHxyhINX+/ebR6BYucrl/XexcHBex7xQr1DygqrCprL/4uzVSWeTFUk0mk16DhelK6SEGReE42Rf8eZFInkDFPYbYu8im2Kn92w3PzL8PWMr65XE0Rf6rnE141q1h5qNC9Lr10hcMNadRKGy2VK4le1S6uRcSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIZ+RaXn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B49C4CEF6;
	Tue,  6 May 2025 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549851;
	bh=Uxgz86q4vttcqou3lbEa8mbH5Xk35X47+RPO2LMlXkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIZ+RaXnP4PF0CA6k34lsw8KbJlvuVCrD4cMCVUsUnYoKNL4G30axhDvaml9B37NZ
	 LbE6jgqohLjDouNpM1RkpfoIsLd0v1I5a8+jy5/2gjN4B2e3tE09Zzj58qUuSwk5ON
	 BFlhfGoCJ7DIVix6KOdOZB7LpzXmtnL8UI8pRWN2tFNhkksnOTRwaiV1h18LcsynQO
	 kUqndh1pMOPrq3QNNVne0WOcWU4Oy2EPcCCQa7IUaufX/rLurf3GEHfLp6K5x+FHBL
	 S6iyL9b5hEsfqJWnew4rTty8aIcXQGkDS71JZ2cKZBDK25cIHSJGPl7H5gXMzCqObJ
	 t04GdbWUf4Bdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOr-00CJkN-MJ;
	Tue, 06 May 2025 17:44:09 +0100
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
Subject: [PATCH v4 16/43] KVM: arm64: Tighten handling of unknown FGT groups
Date: Tue,  6 May 2025 17:43:21 +0100
Message-Id: <20250506164348.346001-17-maz@kernel.org>
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

triage_sysreg_trap() assumes that it knows all the possible values
for FGT groups, which won't be the case as we start adding more
FGT registers (unless we add everything in one go, which is obviously
undesirable).

At the same time, it doesn't offer much in terms of debugging info
when things go wrong.

Turn the "__NR_FGT_GROUP_IDS__" case into a default, covering any
unhandled value, and give the kernel hacker a bit of a clue about
what's wrong (system register and full trap descriptor).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index efe1eb3f1bd07..1bcbddc88a9b7 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2352,9 +2352,10 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		}
 		break;
 
-	case __NR_FGT_GROUP_IDS__:
+	default:
 		/* Something is really wrong, bail out */
-		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
+		WARN_ONCE(1, "Bad FGT group (encoding %08x, config %016llx)\n",
+			  sysreg, tc.val);
 		goto local;
 	}
 
-- 
2.39.2


