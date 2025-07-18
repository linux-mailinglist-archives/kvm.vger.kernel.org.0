Return-Path: <kvm+bounces-52884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF791B0A1A5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2425958798B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5AF2C1597;
	Fri, 18 Jul 2025 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJUB4OwL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481BE2BF012;
	Fri, 18 Jul 2025 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837137; cv=none; b=XTBtMBHYl4cwQwDRwK/bpJSSnxzheWiCTxHVqny5vIMZr6rZWILDehqEjuT8ocu9eHlfGDd7c+5ONppFHBXt6GvHruvE5HO18ce8MfgVccYnoYF0c2MDooDJIGCSIB3SP29S6M5WmDGuyk6RAMc6LW8zKPSeoyTxHSCApxsDPz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837137; c=relaxed/simple;
	bh=7Ipn0X7vVw04ZDLhQLIqE9uJ4GWphQGneKdbxPUSTh8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ktOxi1/e1ekTXxXq7F1FAgWO9IJSyEeR9wIeiD1LOhAKBeg/8Khd30gQrVEZGA5kdmY5JDG3aIhgw4MWz+4VTMkEAWMurn09VHN4dTgwgsW3blSn/6z1voUFwx3kuxBMl5UEPxv3Na2+QbeqsOsYQhRYVEuYCT+JzPjUGKuuEX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJUB4OwL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B86C4CEF8;
	Fri, 18 Jul 2025 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752837136;
	bh=7Ipn0X7vVw04ZDLhQLIqE9uJ4GWphQGneKdbxPUSTh8=;
	h=From:To:Cc:Subject:Date:From;
	b=HJUB4OwLxY/Pj1xU7RZuTtL+UEJ3qC13FcTRSoPsgA1sR6QmuufR0Ty40PqHpz/9c
	 LwpDUBDlwyvBmXntDmn+ZxdXZnt5j5LUXV14k9EKkYZahi5Y5wiUPy8JioJkKpeCyB
	 9Et9h9s/WsRdIFSqd1HSYsV0GCUPZi8F5Mfd+3NB5R3MZLgKzyFG2GPB0EOiJuwXU9
	 kPax9y7+Ckc757MlqEiUqtoLaSSZD39v6r6Tg05Wjz9llTCkyrghNk/mWwXghfSCKt
	 NAlQVftxIj54vkD0YUEM1rxuscIm+hHC0+mxS95rSMTQWhUeSSYAE3BQ7FbOhOZVL8
	 8kqYDibD2NLjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ucj0g-00Gt2B-By;
	Fri, 18 Jul 2025 12:12:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 0/4] KVM: arm64: Userspace GICv3 sysreg access fixes and testing
Date: Fri, 18 Jul 2025 12:11:50 +0100
Message-Id: <20250718111154.104029-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As a follow-up to my earlier series at [1], here's a small set of
fixes to address an annoying bug that made ICH_HCR_EL2 unreachable
from userspace -- not something you'd expect.

So the first patch fixes the ordering the the sysreg table, which had
ICH_HCR_EL2 at the wrong spot. The next two ensure that we now check
for the table to be sorted (just like all the other tables). Finally,
the last patch augments the vgic_init selftest to actually check that
we can access these registers

[1] https://lore.kernel.org/r/20250714122634.3334816-1-maz@kernel.org

Marc Zyngier (4):
  KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
  KVM: arm64: Clarify the check for reset callback in
    check_sysreg_table()
  KVM: arm64: Enforce the sorting of the GICv3 system register table
  KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg userspace access
    test

 arch/arm64/kvm/sys_regs.c                     |  20 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c              |   8 +-
 arch/arm64/kvm/vgic/vgic.h                    |   1 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 219 +++++++++++++++++-
 4 files changed, 237 insertions(+), 11 deletions(-)

-- 
2.39.2


