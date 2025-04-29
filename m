Return-Path: <kvm+bounces-44745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAF4AA0A4E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 052CC169829
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DAF2D1935;
	Tue, 29 Apr 2025 11:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5IDkc9Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCA12C1E23;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745926883; cv=none; b=PkUzO/nmLdjZNp2TfBQEnsiIA3MaiSQZTZxyK/etJzGjybgdD3l9QbY51vWTDSKaRxpmi4NiYISKDWYWO8R4fIXeL3m4YdLgtVW12EDSMuKP5QPofpo3nQKR2z6arhrURngCcPxl9xfLNx2CsUOZ6szLjlquyV1smPb0qFBexN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745926883; c=relaxed/simple;
	bh=z7vRY6j0385eKhIiCYAI50mg523Vhh6+q1JFXwnzUdE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iWChlH5YaHwSv0usGsvJspBmMrmI4rYd97Cc3RSex5XRNtqQotjPZiw7gkPMFW7KEznux10fWCbqEEgh97cdE9RV3Rx3fXejUWF8zjR6gb1RgV/oq6OoHGunaimOpEOEooa4fx359w676gbKi++i+DDKhCd18sn5ds3Q07Ljh/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5IDkc9Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB46C4CEEB;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745926883;
	bh=z7vRY6j0385eKhIiCYAI50mg523Vhh6+q1JFXwnzUdE=;
	h=From:To:Cc:Subject:Date:From;
	b=Z5IDkc9QmnF156EVu9ZzmDZrwjdxZ90IGgHdzed+020IwE8u5OLLG3TW2V7tb/xnP
	 gaFfLfUq66jpo4tw4iXaSyhSluCA6IkVb4v5wfP06p/YqpnzTxnQTQr2vHwbAaT1cl
	 x3PsCXgMcBmtpwxKIkA7fsIWFYcS2gTuXX2hqJVcsm/prfh5HCCEQt7f5xk+eKiU3F
	 S0HgXNdI751oc1+EyQvlO0p5pwEY8IbgIZfdvLSFOyAzlILoRKL5GGiY6OTcv3ufyd
	 sTicQ27SPT+YjWApIXQ4T9inmqW+8dB6HVGklIbyvxMoyNyJ2OaA58bi955nNo/ooD
	 oaU901VICr6OA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u9jKz-009t0f-6k;
	Tue, 29 Apr 2025 12:41:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 0/2] KVM: arm64: Make AArch64 support sticky
Date: Tue, 29 Apr 2025 12:41:15 +0100
Message-Id: <20250429114117.3618800-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It's been recently reported[1] that our sorry excuse for a test suite
is writing a bunch of zeroes to ID_AA64PFR0_EL1.EL{0,1,2,3},
effectively removing the advertised support for AArch64 to the guest.

This leads to an interesting interaction with the NV code which reacts
in a slightly overzealous way and inject an UNDEF at the earliest
opportunity.

This small series fixes KVM by bluntly refusing to disable AArch64,
and the test to stop being so lame. I'm also fixing the NV code
separately, since it isn't upstream.

[1] https://lore.kernel.org/r/4e63a13f-c5dc-4f97-879a-26b5548da07f@os.amperecomputing.com

Marc Zyngier (2):
  KVM: arm64: Prevent userspace from disabling AArch64 support at any
    virtualisable EL
  KVM: arm64: selftest: Don't try to disable AArch64 support

 arch/arm64/kvm/sys_regs.c                       | 6 ++++++
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.39.2


