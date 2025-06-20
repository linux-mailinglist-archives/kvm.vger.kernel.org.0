Return-Path: <kvm+bounces-50053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F27AE1933
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6154E7A63F4
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 10:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4572E1F09BF;
	Fri, 20 Jun 2025 10:45:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D809265CDF
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 10:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750416301; cv=none; b=jS1h8fKQywAaD4XhYG9m1EvlcwRioJiDm018J3Jilo9Czs1gfs1g9JyoLLCHSUvFcF+9B1G8CqYTKb+vvw2xcgDUU7F1+kK5jaTELRJMXddeRneKlS9K6XWzlVEzb9pC4JJq0r7fSrKrSRTuYiu2+/0qPC9XvffniGH/jlzPWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750416301; c=relaxed/simple;
	bh=LqmboNW/v2AzG/6r2y+pR2hwLNoIYYKvvog7utCxnP4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zf7lUMbhsvUt7VJsOWKoFf2KAaGdHxlff8WK5pXbWfNB32f7h+j725/22h2Yfi0gfWJKZIDPcOjgNV3gyJXWOvCwdh1YhfjJFApWtcwzXK3oN7gWsPd8e/rb9I0jtbz2aIETEl0kc56N8WeQ7fSCOkLuAk4TV6CloF1GIAydmHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01FE4176A;
	Fri, 20 Jun 2025 03:44:40 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.32.101.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D7503F58B;
	Fri, 20 Jun 2025 03:44:58 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool 0/3] arm64: Nested virtualization support
Date: Fri, 20 Jun 2025 11:44:51 +0100
Message-Id: <20250620104454.1384132-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks to the imperturbable efforts from Marc, arm64 support for nested
virtualization has now reached the mainline kernel, which means the
respective kvmtool support should now be ready as well.

Patch 1 updates the kernel headers, to get the new EL2 capability, and
the VGIC device control to setup the maintenance IRQ.
Patch 2 introduces the new "--nested" command line option, to let the
VCPUs start in EL2. To allow KVM guests running in such a guest, we also
need VGIC support, which patch 3 allows by setting the maintenance IRQ.

Tested on the FVP (with some good deal of patience), and some commercial
(non-fruity) hardware, down to a guest's guest's guest.

Cheers,
Andre

P.S.: Marc: I saw the other patches in your kernel.org repo, do we need any
of them - HYP timer IRQ, E2H0, counter offset? I guess E2H0 for fruity
hardware, what about the others?

Andre Przywara (3):
  Sync kernel UAPI headers with v6.16-rc1
  arm64: Initial nested virt support
  arm64: nested: add support for setting maintenance IRQ

 arm64/arm-cpu.c                     |  3 +-
 arm64/fdt.c                         |  5 +-
 arm64/gic.c                         | 21 +++++++-
 arm64/include/asm/kvm.h             | 23 +++++++--
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h |  5 +-
 arm64/kvm-cpu.c                     | 12 ++++-
 include/linux/kvm.h                 |  5 ++
 include/linux/virtio_net.h          | 13 +++++
 include/linux/virtio_pci.h          |  1 +
 riscv/include/asm/kvm.h             |  2 +
 x86/include/asm/kvm.h               | 75 +++++++++++++++++++++++++++++
 12 files changed, 157 insertions(+), 10 deletions(-)

-- 
2.25.1


