Return-Path: <kvm+bounces-9294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 870CB85D54A
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 11:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2603FB2206E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 10:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DAFF3D96B;
	Wed, 21 Feb 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpsFCK1y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C883A24B57;
	Wed, 21 Feb 2024 10:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708510641; cv=none; b=kn0wXtFVnfmrOc96RMxdVREnKv/f8tQVD15RLVXnLqjVHguJVkAt9KH6HZe7yV7QFYEMZABtJfIG/5hRs5leX7qGHlrYbYDdwLybJEtMhKHlEVL+2wtccjChNMIr7UJptavk+eDjHz73QfbGS/uQVSlkmaekQrTcSG7NAunqxZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708510641; c=relaxed/simple;
	bh=rDihJ2qZsh4aBhB/KRNnvpywWBWh8t5oztOINSRoa38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I2DU8ZPdw8CtV95jkwvQb6gOsicS84wc6x+RGG6AhIDmS0pqN36CURUEqvm4dEUKYgujWmYi/3+pWGYVXtkmTYI9lrSpFla1MjwtSU+EFkCIeffLlfHZ43XKcbx3DbjEAlxZgZzuhOF6iyMVIY8xfdrttRqpFEaklE4aMA3XsPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GpsFCK1y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A16C433F1;
	Wed, 21 Feb 2024 10:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708510641;
	bh=rDihJ2qZsh4aBhB/KRNnvpywWBWh8t5oztOINSRoa38=;
	h=From:To:Cc:Subject:Date:From;
	b=GpsFCK1yYRU3q/SBnYoNLYgIczXs5unldlH1uRU7bLeidcWgiB2uuMkxRDPu7bNjd
	 BEQvzR0SteLSMgXv587r0fWqLm5kbqC38ZCgJRXTWaF4J6IUHx/dSV93fV3mXXSVCX
	 BZ5M2m+bHRVoyIbChNfLzz7TsaRD/wvsJxttQB9pFDy0H3sEd6QHU4m0G/R//we22v
	 rCcTR5ylb5t/SUJXBs28vePTTkSZ9LHBzPgsApef8ZN21/oaOQYBmBYWI0blvnSrwW
	 Lx81uXZavK8C6mn/zCWV6dQKYIzvy2yWyGBT59pE3byXlsczAR/6Ib0eyPxW825lR3
	 Z8EDQ5sJqkLMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rcjfD-005CWP-44;
	Wed, 21 Feb 2024 10:17:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.8, take #3
Date: Wed, 21 Feb 2024 10:17:11 +0000
Message-Id: <20240221101711.2105066-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hey Paolo,

Another week, another couple of fixes. This time, two fixes for the
ITS emulation that could result in non-existent LPIs being used, with
unpredictable consequences. Thanks to Oliver for spotting those as he
was reworking the ITS translation cache.

Please pull,

	M.

The following changes since commit c60d847be7b8e69e419e02a2b3d19c2842a3c35d:

  KVM: arm64: Fix double-free following kvm_pgtable_stage2_free_unlinked() (2024-02-13 19:22:03 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.8-3

for you to fetch changes up to 85a71ee9a0700f6c18862ef3b0011ed9dad99aca:

  KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler (2024-02-21 10:06:41 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.8, take #3

- Check for the validity of interrupts handled by a MOVALL
  command

- Check for the validity of interrupts while reading the
  pending state on enabling LPIs.

----------------------------------------------------------------
Oliver Upton (2):
      KVM: arm64: vgic-its: Test for valid IRQ in its_sync_lpi_pending_table()
      KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler

 arch/arm64/kvm/vgic/vgic-its.c | 5 +++++
 1 file changed, 5 insertions(+)

