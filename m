Return-Path: <kvm+bounces-23682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4155E94CBE4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 10:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56CC4281B00
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 08:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9311818CBE6;
	Fri,  9 Aug 2024 08:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OeVRqCC1"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A70E18EA2
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723191151; cv=none; b=BQewXwNcYfRrPyTr5zt09xcYNND+lLI+94nIEDCO4wb/Sy7kJtsFYae8UbmZO9/bytB/n2klEYEVMiEp6kse7cN2YqnC4aKJ1PE7shPqzVueO1JLKKj65xddoXFiEtSqo0xV6H+c4bQ6ouTt3K7qYHkBiKkuKdfjda25kT11zh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723191151; c=relaxed/simple;
	bh=kHDhDSR2+w+Ph+NdsUodVPwydVWb2V+/ba4K3JJ4EvM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tyrfOGeN7CBw0ho9YWQW8o4lkhnFEDC58NBPrv8FVrZF5qpwgUindxINrH7mr45oTRRjHAUHWv183pU4pGZFRcvYNE9P7JeYzf+mnpUobYUlGpmdx84MvpPjKkVI2JN3rXFjzEFwXfr1guU2dxYd7elxRuQwKl+BjJqA2SjP8mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OeVRqCC1; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 9 Aug 2024 01:12:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723191146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ZHuIVP7wwieh91FvNO32MlwMqME40e728uT/JCQsoZ8=;
	b=OeVRqCC1RsSwvbLdaEG7URAMTfh5Eum+qKE4wrIElDzzFHGHjeZVNhU8LfsYEsQcQdeMvD
	jSIlNjv154Swu/c7f9AoAm3t/9qOg0t6CdU0PK1T13NSySCLD5gnajIhzFDUgvwp2yKuO9
	pEP0IWiyo2Po/D10G6h869HaEs/u3hw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Alexander Potapenko <glider@google.com>,
	Mark Brown <broonie@kernel.org>, Fuad Tabba <tabba@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Takahiro Itazuri <itazur@amazon.com>,
	Sebastian Ott <sebott@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] KVM/arm64 fixes for 6.11, round #1
Message-ID: <ZrXPY7yIG0eu8mQU@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Decent bit of fixes this time around. The most noteworthy among these
is probably Marc's vgic fix that closes a race which can precipitate a
UAF, as seen w/ syskaller.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.11-1

for you to fetch changes up to 9eb18136af9fe4dd688724070f2bfba271bd1542:

  KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface (2024-08-08 16:58:22 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.11, round #1

 - Use kvfree() for the kvmalloc'd nested MMUs array

 - Set of fixes to address warnings in W=1 builds

 - Make KVM depend on assembler support for ARMv8.4

 - Fix for vgic-debug interface for VMs without LPIs

 - Actually check ID_AA64MMFR3_EL1.S1PIE in get-reg-list selftest

 - Minor code / comment cleanups for configuring PAuth traps

 - Take kvm->arch.config_lock to prevent destruction / initialization
   race for a vCPU's CPUIF which may lead to a UAF

----------------------------------------------------------------
Danilo Krummrich (1):
      KVM: arm64: free kvm->arch.nested_mmus with kvfree()

Fuad Tabba (1):
      KVM: arm64: Tidying up PAuth code in KVM

Marc Zyngier (2):
      KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
      KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface

Mark Brown (1):
      KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-list

Sebastian Ott (3):
      KVM: arm64: fix override-init warnings in W=1 builds
      KVM: arm64: fix kdoc warnings in W=1 builds
      KVM: arm64: vgic: fix unexpected unlock sparse warnings

Takahiro Itazuri (1):
      docs: KVM: Fix register ID of SPSR_FIQ

Zenghui Yu (1):
      KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI

 Documentation/virt/kvm/api.rst                     |  2 +-
 arch/arm64/include/asm/kvm_ptrauth.h               |  2 +-
 arch/arm64/kvm/Kconfig                             |  1 +
 arch/arm64/kvm/Makefile                            |  3 +++
 arch/arm64/kvm/arm.c                               | 15 +++++----------
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  1 -
 arch/arm64/kvm/hyp/nvhe/Makefile                   |  2 ++
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  5 ++---
 arch/arm64/kvm/hyp/vhe/Makefile                    |  2 ++
 arch/arm64/kvm/nested.c                            |  2 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |  5 +++--
 arch/arm64/kvm/vgic/vgic-init.c                    |  3 +--
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |  7 ++++---
 arch/arm64/kvm/vgic/vgic-its.c                     | 18 +++++++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c                      |  2 +-
 arch/arm64/kvm/vgic/vgic.c                         |  2 +-
 arch/arm64/kvm/vgic/vgic.h                         |  2 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  4 ++--
 18 files changed, 42 insertions(+), 36 deletions(-)

