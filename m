Return-Path: <kvm+bounces-8229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8BD84CD24
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DB6F28B234
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 14:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4E27E77B;
	Wed,  7 Feb 2024 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euyP0kTX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E917CF03;
	Wed,  7 Feb 2024 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317184; cv=none; b=c/yT2hi4nwYiB3flqL1NJMU+oCOQJwVOb0PyPvFzjJhS7/Z1d72dv4XzAlYYwEs0JOsXLIXeD+B+G4kI12t0DP6QYZNqNRaJOQQHTDMRSNK+vHh+vEvxQZBDuafFTKm/NnuwF1DWY6IsT5HLdxyOAKti1HBrB8g42uqhoUAWLqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317184; c=relaxed/simple;
	bh=ogco/FzOtjq0n+3+m8vpWui5nen+L0YKTOH8EtL1JDU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DFGUSrzEyOQI6v6e+mqf8svwJXMCR4+SG4lGHNXkjEKJ+pcNzyhKZfhwWblhV/yhkU+7yQRYNn7Au8y+krG0OWbM+/DTUx+OLIlikjwE2b3JGOU220HxwvSpTA5Z3xc6UlpBt0A8VWq91f1xoVlYtIGN91wWPlo5DPXeb6xiZAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euyP0kTX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C269C433F1;
	Wed,  7 Feb 2024 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707317184;
	bh=ogco/FzOtjq0n+3+m8vpWui5nen+L0YKTOH8EtL1JDU=;
	h=From:To:Cc:Subject:Date:From;
	b=euyP0kTXIBKkYWf2OTzQF996LfIjvTuX3S6STo5ziv2iqFcu1LAahrWhG+WkTO0PO
	 Q+KuN5Faveg+cefJ50SG+55aG1fyNrlX0ItttCbnF/OXq4g601tlpckoHqENogfHlN
	 yOBAuHI3QaWdbw0S0yivIiPjfWQfIdnmuI7M6AoZaO+Thw7act01/cuHkbq1Pmvjxr
	 grwMnGN/ebcsXDHAN8WmZbhfUGRaj+n8j5tFwilENMtyusJJDmCXgiqX99NMihJ2/Z
	 OXHKyzyT4p7yAj8MIQKEgCBRDiliJzSuotGvig7x8vjbNEdfsdgmmOPFyYYtin4jW/
	 v82pGVSzMSaKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rXjBt-0019dG-GH;
	Wed, 07 Feb 2024 14:46:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sebastian Ene <sebastianene@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM/arm64 fixes for 6.8, take #1
Date: Wed,  7 Feb 2024 14:46:11 +0000
Message-Id: <20240207144611.1128848-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, masahiroy@kernel.org, oliver.upton@linux.dev, sebastianene@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Paolo,

Things have been pretty quiet on the fixes front, and I'm tired of
waiting for people to find bugs. So here's what i have so far, which
is pretty little: Sebastian found yet another instance of locking
order issue with pKVM, and Masahiro has offered a cleanup of the
Kconfig file. None of them is majorly critical at this stage, but
better fix them now.

Please pull,

	M.

Masahiro Yamada (1):
  KVM: arm64: Do not source virt/lib/Kconfig twice

Sebastian Ene (1):
  KVM: arm64: Fix circular locking dependency

 arch/arm64/kvm/Kconfig |  1 -
 arch/arm64/kvm/pkvm.c  | 27 +++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

-- 
2.39.2

The following changes since commit 6613476e225e090cc9aad49be7fa504e290dd33d:

  Linux 6.8-rc1 (2024-01-21 14:11:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.8-1

for you to fetch changes up to 42dfa94d802a48c871e2017cbf86153270c86632:

  KVM: arm64: Do not source virt/lib/Kconfig twice (2024-02-04 13:08:28 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.8, take #1

- Don't source the VFIO Kconfig twice

- Fix protected-mode locking order between kvm and vcpus

----------------------------------------------------------------
Masahiro Yamada (1):
      KVM: arm64: Do not source virt/lib/Kconfig twice

Sebastian Ene (1):
      KVM: arm64: Fix circular locking dependency

 arch/arm64/kvm/Kconfig |  1 -
 arch/arm64/kvm/pkvm.c  | 27 +++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

