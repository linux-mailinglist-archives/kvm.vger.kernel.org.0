Return-Path: <kvm+bounces-63203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B715C5CE51
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 12:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 726694E329F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 11:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5472D313E04;
	Fri, 14 Nov 2025 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2rRQ37z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905B281356;
	Fri, 14 Nov 2025 11:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763120083; cv=none; b=q/LqyBF3stDnF2O/mIcpglnb6cHXWfogary65cjbWH2PiYhxXAtg3MQLXRM1pXDMmuH3JLvQmbJ+C+w0LCbJLjqMIDXqkOx8MdetA0VCSopTmpCSYNpu1QpBSMXAJ0lM3w6UNqu00UZRMw6S2yHkLyC/mjZ8EnSRE3y+/fe8ekY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763120083; c=relaxed/simple;
	bh=KV4hhmCrF50yCsv4HaclQvyKMdrM81Xxcq4YVAQQSdM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/5/9SrhSXB3LXCXpythr6lR5Q8/kK+IDU8Xnt1BaF5w4K1gvbqukqCsZ54nbGgXmKO3cjHZr5wXUfY6q0vSuk89bdxwt+q9We5VfBcS70O8MocfzCd3SxxKudRVPaCxhnygDGLFjmiI5MYPzPNB3eFbTVP/JAX8V9GY15qCxPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2rRQ37z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF769C19421;
	Fri, 14 Nov 2025 11:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763120083;
	bh=KV4hhmCrF50yCsv4HaclQvyKMdrM81Xxcq4YVAQQSdM=;
	h=From:To:Cc:Subject:Date:From;
	b=L2rRQ37z0sVAN0FA5ANL2E37QwZJvRNyI7QuUHhc6R5hz7YYRZyW2i43z80bvLIai
	 lemBuJC5vC6ZWyC7DMhcJREmerTrvldjmsTWXQKjiT1kEIJCj7MB1wwVAOlc9VqNHB
	 sawVRJauQ+m9txr8vDvkkT5mJNA2nak1hPwmDFUSIsOdWgnrCMsQubgSHO3rBdy1II
	 pT4JfFlMz1sNI99vz5LD8SV8J8INeZwGv9Ph2Tq/aYvP/gzMTRlBkZWNhddh1/RkI9
	 FmzuvdszNNBLiEo/kwgm884A0Zxla311ddGhbwKNFuhXrSjSyZFCDREGDnvBo4feeX
	 zTdaWfno+fEbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vJs4e-00000005Brg-38Js;
	Fri, 14 Nov 2025 11:34:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fix for 6.18, take #3
Date: Fri, 14 Nov 2025 11:34:15 +0000
Message-ID: <20251114113415.3217950-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, broonie@kernel.org, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

I'm back with my weekly routine of collecting patches, plugging
another couple of regressions (the FGT one is particularly annoying).
I hope this is the last one for this cycle, but my gut feeling is that
we're not quite finished with it yet...

Please pull,

	M.

The following changes since commit 4af235bf645516481a82227d82d1352b9788903a:

  MAINTAINERS: Switch myself to using kernel.org address (2025-11-08 11:21:20 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.18-3

for you to fetch changes up to 85592114ffda568b507bc2b04f5e9afbe7c13b62:

  KVM: arm64: VHE: Compute fgt traps before activating them (2025-11-12 10:52:58 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.18, take #3

- Only adjust the ID registers when no irqchip has been created once
  per VM run, instead of doing it once per vcpu, as this otherwise
  triggers a pretty bad conbsistency check failure in the sysreg code.

- Make sure the per-vcpu Fine Grain Traps are computed before we load
  the system registers on the HW, as we otherwise start running without
  anything set until the first preemption of the vcpu.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: VHE: Compute fgt traps before activating them

Marc Zyngier (1):
      KVM: arm64: Finalize ID registers only once per VM

 arch/arm64/kvm/arm.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

