Return-Path: <kvm+bounces-32827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD139E0C73
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0162B605A4
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775621DBB13;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYDSI5e3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE2D1D9A41;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160138; cv=none; b=SiogUVAtT1EL7Zc4FfbUA19cukZ8+ByF4KElH4SypnqS022y4No+D8gRGlPOUbFJuhwRm0NxirpLumvN2/2Wb+XVrWyykO1Obwf7naDDWHW7XKdo1tlBasxYOjH+GTDoTwXzo/+fS8gZtj3cfAC61gAzIcyZ7xd5mZ7fAK5AJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160138; c=relaxed/simple;
	bh=UpzE0ZmBH3j6iH9EdlvMQO+Y3xZZ7zh9pVe57GIdbkY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u9XrapwGEAeS+NKBlCBupubdDiyKfv7/0zsJgL7tiwqo18eAshcIUT5XO2Ymavzu831XLjUcxv7pKUhS8t40mGQlIyL89V6pOmEfZnDgvGE3si7JqvfBmeZmtuyfzH0A6VrpKMLtH6bVfgh0imPfs/LwPbRntschlt7V3zT0kCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pYDSI5e3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD101C4CED1;
	Mon,  2 Dec 2024 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160137;
	bh=UpzE0ZmBH3j6iH9EdlvMQO+Y3xZZ7zh9pVe57GIdbkY=;
	h=From:To:Cc:Subject:Date:From;
	b=pYDSI5e3AmxzREPbNfe/OtP9tFYgHbjYic41biAC5nbB5i/Zd5IQOfR/3Hlw3WzlC
	 3T3va3TYFnjO88NLAHp/32MA2708EYAGN1Q4emlZiJZ29ch6i1yAkLpTw45rJVRzvr
	 /Vjx1xCWDzI9FGAJW07fm+4rTnFzQ6PaRBC3ULHzg4dFVGlF2n8CjWikCSkdDvv/K7
	 06N22GExQSq0AIrQnSbpHi2ncbFHAWWP9t617Y3w5zzEMCPA4aAF0VUvYM57X4aNjf
	 UJID57/cPI4Rkc8OQd/k+J10jk47xuaH/ZQnxuk0f4LH0F1YBrXRRWXVOqNEbWQDDv
	 bPnFe5nRIVB6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7j-00HQcf-LD;
	Mon, 02 Dec 2024 17:22:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 00/11] KVM: arm64: Add NV timer support
Date: Mon,  2 Dec 2024 17:21:23 +0000
Message-Id: <20241202172134.384923-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's another batch of NV-related patches, this time bringing in most
of the timer support for EL2 as well as nested guests.

The code is pretty convoluted for a bunch of reasons:

- FEAT_NV2 breaks the timer semantics by redirecting HW controls to
  memory, meaning that a guest could setup a timer and never see it
  firing until the next exit

- We go try hard to reflect the timer state in memory, but that's not
  great.

- With FEAT_ECV, we can finally correctly emulate the virtual timer,
  but this emulation is pretty costly

- As a way to make things suck less, we handle timer reads as early as
  possible, and only defer writes to the normal trap handling

- Finally, some implementations are badly broken, and require some
  hand-holding, irrespective of NV support. So we try and reuse the NV
  infrastructure to make them usable. This could be further optimised,
  but I'm running out of patience for this sort of HW.

What this is not implementing is support for CNTPOFF_EL2. It appears
that the architecture doesn't let you correctly emulate it, so I guess
this will be trap/emulate for the foreseeable future.

This series is on top of v6.13-rc1, and has been tested on my usual M2
setup, but also on a Snapdragon X1 Elite devkit. I would like to thank
Qualcomm for the free hardware with no strings (nor support) attached!

If you are feeling brave, you can run the whole thing from [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next

Marc Zyngier (11):
  KVM: arm64: nv: Add handling of EL2-specific timer registers
  KVM: arm64: nv: Sync nested timer state with FEAT_NV2
  KVM: arm64: nv: Publish emulated timer interrupt state in the
    in-memory state
  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV in
    use
  KVM: arm64: nv: Acceletate EL0 counter accesses from hypervisor
    context
  KVM: arm64: Handle counter access early in non-HYP context
  KVM: arm64: nv: Add trap routing for
    CNTHCTL_EL2.EL1{NVPCT,NVVCT,TVT,TVCT}
  KVM: arm64: nv: Propagate CNTHCTL_EL2.EL1NV{P,V}CT bits
  KVM: arm64: nv: Sanitise CNTHCTL_EL2
  KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity

 arch/arm64/include/asm/cputype.h        |   2 +
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/sysreg.h         |   4 +
 arch/arm64/kernel/cpu_errata.c          |   8 ++
 arch/arm64/kernel/image-vars.h          |   3 +
 arch/arm64/kvm/arch_timer.c             | 177 +++++++++++++++++++++---
 arch/arm64/kvm/arm.c                    |   3 +
 arch/arm64/kvm/emulate-nested.c         |  58 +++++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  39 ++++--
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  16 ++-
 arch/arm64/kvm/hyp/vhe/switch.c         |  84 +++++++++++
 arch/arm64/kvm/nested.c                 |  15 ++
 arch/arm64/kvm/sys_regs.c               | 146 ++++++++++++++++++-
 arch/arm64/tools/cpucaps                |   1 +
 include/clocksource/arm_arch_timer.h    |   6 +
 include/kvm/arm_arch_timer.h            |  23 +++
 16 files changed, 546 insertions(+), 41 deletions(-)

-- 
2.39.2


