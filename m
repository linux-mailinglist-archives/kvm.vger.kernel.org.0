Return-Path: <kvm+bounces-63339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EA4C6318A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F45C3A9EB5
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613443271EE;
	Mon, 17 Nov 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQUxZ5N1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EBE324B28;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370941; cv=none; b=jZEThXE4AuKHYAocWUYeTVsmeyuULUsFfi8Gp9oFEo9XPi0vESHT7pFqgA2LRtNgrxSNkmoitEJ/RbM5iTcNsnJWHR3AQgp/tY+qWnfy8GdSt+lwwjXVXEM1XQwNGjyunS/6J4G+PlRwVLCA0GkYAl2ud0w6k6uJOM2VqCCiFSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370941; c=relaxed/simple;
	bh=mH/Jp7MHuDkzj0cxiq1eLsInTqMdrk+HHd3BkgjUU08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sTa/b8xqq1icKD3YNY4j7LIfLMhJth6OxGeaklhBWU9P8pPIrlFf/B1Nzd8IvqmOgtLYfmny1XNni647HQIGkHtYKwaek1TXQiR9OGvLDKns3g3/k7kmcgpjUV90+ChsHic1URIHZTzMQDpU0bRW2aSzk3ckLzs0prWHOidgwbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQUxZ5N1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CEEC4AF1D;
	Mon, 17 Nov 2025 09:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763370940;
	bh=mH/Jp7MHuDkzj0cxiq1eLsInTqMdrk+HHd3BkgjUU08=;
	h=From:To:Cc:Subject:Date:From;
	b=pQUxZ5N11uoXXupgGNvToPT7NVMZWZSD3hMglZkeH0cLnf8c1S/j1Hj5QRimtiUMk
	 niDaJzdb6wQhbstLpyocrd8RCkLWKBgAk0IseaIn1MhO3vAJ9IyDzdUnupeHtMihz4
	 ltTJ5bfnSwReL24GBCgqUD9fGYKYdukvW7kGX37RTMvpjWrW+2SXTJICcDlDdUyUaR
	 FJ75yTqWmh3WfqpCIPwbKe2QXTJvy8s+piZHJ0oWB3RUDf6JeHIDYbdKWoGeJvCCwk
	 oBqtUhYB1az0D3FQo6fY5I7DorgStpac2/q0LUdNJ7Nf7vrdwwBOwsqJBx60dfqVk1
	 CBuKkiahc7/jA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vKvKk-00000005lB2-1nkE;
	Mon, 17 Nov 2025 09:15:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 0/5] KVM: arm64: Add LR overflow infrastructure (the dregs, the bad and the ugly)
Date: Mon, 17 Nov 2025 09:15:22 +0000
Message-ID: <20251117091527.1119213-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is a follow-up to the original series [1] (and fixes [2][3])
with a bunch of bug-fixes and improvements. At least one patch has
already been posted, but I thought I might repost it as part of a
series, since I accumulated more stuff:

- The first patch addresses Mark's observation that the no-vgic-v3
  test has been broken once more. At some point, we'll have to retire
  that functionality, because even if we keep fixing the SR handling,
  nobody tests the actual interrupt state exposure to userspace, which
  I'm pretty sure has badly been broken for at least 5 years.

- The second one addresses a report from Fuad that on QEMU,
  ICH_HCR_EL2.TDIR traps ICC_DIR_EL1 on top of ICV_DIR_EL1, leading to
  the host exploding on deactivating an interrupt. This behaviour is
  allowed by the spec, so make sure we clear all trap bits

- Running vgic_irq in an L1 guest (the test being an L2) results in a
  MI storm on the host, as the state synchronisation is done at the
  wrong place, much like it was on the non-NV path before it was
  reworked. Apply the same methods to the NV code, and enjoy much
  better MI emulation, now tested all the way into an L3.

- Nuke a small leftover from previous rework.

- Force a read-back of ICH_MISR_EL2 when disabling the vgic, so that
  the trap prevents too many spurious MIs in an L1 guest, as the write
  to ICH_HCR_EL2 does exactly nothing on its own when running under
  FEAT_NV2.

Oliver: this is starting to be a large series of fixes on top of the
existing series, plus the two patches you have already added. I'd be
happy to respin a full v4 with the fixes squashed into their original
patches. On the other hand, if you want to see the history in its full
glory, that also works for me.

[1] https://msgid.link/20251109171619.1507205-1-maz@kernel.org
[2] https://msgid.link/20251113172524.2795158-1-maz@kernel.org
[3] https://lore.kernel.org/kvmarm/86frahu21h.wl-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: GICv3: Don't advertise ICH_HCR_EL2.En==1 when no vgic is
    configured
  KVM: arm64: GICv3: Completely disable trapping on vcpu exit
  KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI
    emulation
  KVM: arm64: GICv3: Remove vgic_hcr workaround handling leftovers
  KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En

 arch/arm64/include/asm/kvm_hyp.h     |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 11 +++-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 78 ++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-v3.c        |  3 ++
 arch/arm64/kvm/vgic/vgic.c           |  6 ++-
 arch/arm64/kvm/vgic/vgic.h           |  1 +
 6 files changed, 62 insertions(+), 38 deletions(-)

-- 
2.47.3


