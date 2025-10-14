Return-Path: <kvm+bounces-60016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D072BD9575
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 14:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D160544DC8
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 12:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8094631354C;
	Tue, 14 Oct 2025 12:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtw6eAlK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D842E2EF2;
	Tue, 14 Oct 2025 12:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760444992; cv=none; b=R3F8zUoOpWHpISCbMnRqjEtZkKoDxCbm3uSyvhJezjjCGHOQbmrp1eUdJxisuLL0G4kd+TS/IZ1aFdJ9vSCSZJvMoM8kKSQF6L2khgaLLE+sOmP6rbQ02GBDB9uUZD9oHLNl3UE5nKheh0nLSvRstR6HhWd8QATKD9YC/dM4MMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760444992; c=relaxed/simple;
	bh=xmh4KsnNeZHjO8jbGVSUeCrebEvYn671IaiHQKtmJ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JFYXC1VzIb5ym6SjDrp39KW5PDof/xz7MIZbVXC5eL/j6aq0JwwAu/27eqXmP+imB+JJkEmRaFLupuUvGMAwyLTq6bV5QN67jr5k3VUZAFEGKLN/M29wXKvZIJKtbPT+9v++NhqTC3rfMx/JR2YEBnwmctNTqXUT6Uz2RjtBx0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtw6eAlK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DF6C4CEE7;
	Tue, 14 Oct 2025 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760444992;
	bh=xmh4KsnNeZHjO8jbGVSUeCrebEvYn671IaiHQKtmJ6k=;
	h=From:To:Cc:Subject:Date:From;
	b=gtw6eAlKqZpUgQCZr6MBd6O5SQ4QuD5+eHAuXwQ//c/0lAr2cfGRt3Q77Qvqezaf1
	 GSYaXTMvWghTjvBZI2Y5hOR0JMn+M8vHiD+V6lKQxEjOl6V+LiLqU1o1QLyyta5yfo
	 cO5hUy98WvQgQ6J3F43lTRprz/bJozu3HDIGyJZpY4CWlonscXazEL8MBFK3ycvB14
	 u82So6pD1mnoPqiQXmLGmTuzitSEKSQDDmRST4kCLQ3bf2P+4m4/AR1+yf78Eo+FmZ
	 Ld6ZPltfVZgZ6Nldk7hfWHIpf9JIsQ33T6vT56vaADdzP5lSJkV4lBE3BYZQ4T1gm/
	 Y9/9AZO+gFTtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8eA1-0000000Dr1F-1wD9;
	Tue, 14 Oct 2025 12:29:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jan Kotas <jank@cadence.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.18, take #1
Date: Tue, 14 Oct 2025 13:28:57 +0100
Message-ID: <20251014122857.1250976-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, jank@cadence.com, joey.gouly@arm.com, mark.rutland@arm.com, mukesh.ojha@oss.qualcomm.com, naresh.kamboju@linaro.org, oliver.upton@linux.dev, osama.abdelkader@gmail.com, sascha.bischoff@arm.com, seanjc@google.com, sebott@redhat.com, yuzenghui@huawei.com, zenghui.yu@linux.dev, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

As 6.18-rc1 is out, here's a collection of fixes that have accumulated
over the past 3 weeks, addressing a pretty wide ranging set of issues.
Nothing really jumps out, for once, and it's the usual mix of UAPI
tidy-up, architecture fixups, and other random cleanups. Maybe a few
more selftest updates than we usually do, but I'm sure this isn't
going to last!

I'm already looking at some more fixes, so will probably be back next
week with more presents...

You will notice that, just like I did with the main pull request, I'm
adding message-ids to the tag instead of putting them into the
individual patches. It looks rubbish, but I don't have a good
alternative, and I'm not prepared to remove provenance information
from the stuff I ferry upstream.

I'd welcome any guidance that would make things suck less for people
reporting bugs and backporting stuff, despite the "Link: is bad"
nonsense. Preferably something that we can adopt across architectures
supporting KVM.

In the meantime, please pull.

	M.

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.18-1

for you to fetch changes up to ca88ecdce5f51874a7c151809bd2c936ee0d3805:

  arm64: Revamp HCR_EL2.E2H RES1 detection (2025-10-14 08:18:40 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.18, take #1

Improvements and bug fixes:

- Fix the handling of ZCR_EL2 in NV VMs
  (20250926194108.84093-1-oliver.upton@linux.dev)

- Pick the correct translation regime when doing a PTW on
  the back of a SEA (20250926224246.731748-1-oliver.upton@linux.dev)

- Prevent userspace from injecting an event into a vcpu that isn't
  initialised yet (20250930085237.108326-1-oliver.upton@linux.dev)

- Move timer save/restore to the sysreg handling code, fixing EL2 timer
  access in the process (20250929160458.3351788-1-maz@kernel.org)

- Add FGT-based trapping of MDSCR_EL1 to reduce the overhead of debug
  (20250924235150.617451-1-oliver.upton@linux.dev)

- Fix trapping configuration when the host isn't GICv3
  (20251007160704.1673584-1-sascha.bischoff@arm.com)

- Improve the detection of HCR_EL2.E2H being RES1
  (20251009121239.29370-1-maz@kernel.org)

- Drop a spurious 'break' statement in the S1 PTW
  (20250930135621.162050-1-osama.abdelkader@gmail.com)

- Don't try to access SPE when owned by EL3
  (20251010174707.1684200-1-mukesh.ojha@oss.qualcomm.com)

Documentation updates:

- Document the failure modes of event injection
  (20250930233620.124607-1-oliver.upton@linux.dev)

- Document that a GICv3 guest can be created on a GICv5 host
  with FEAT_GCIE_LEGACY (20251007154848.1640444-1-sascha.bischoff@arm.com)

Selftest improvements:

- Add a sesttest for the effective value of HCR_EL2.AMO
  (20250926224454.734066-1-oliver.upton@linux.dev)

- Address build warning in the timer selftest when building
  with clang (20250926155838.2612205-1-seanjc@google.com)

- Teach irq_fd selftests about non-x86 architectures
  (20250930193301.119859-1-oliver.upton@linux.dev)

- Add missing sysregs to the set_id_regs selftest
  (20251012154352.61133-1-zenghui.yu@linux.dev)

- Fix vcpu allocation in the vgic_lpi_stress selftest
  (20251008154520.54801-1-zenghui.yu@linux.dev)

- Correctly enable interrupts in the vgic_lpi_stress selftest
  (20251007195254.260539-1-oliver.upton@linux.dev)

----------------------------------------------------------------
Marc Zyngier (15):
      KVM: arm64: nv: Don't advance PC when pending an SVE exception
      KVM: arm64: Hide CNTHV_*_EL2 from userspace for nVHE guests
      KVM: arm64: Introduce timer_context_to_vcpu() helper
      KVM: arm64: Replace timer context vcpu pointer with timer_id
      KVM: arm64: Make timer_set_offset() generally accessible
      KVM: arm64: Add timer UAPI workaround to sysreg infrastructure
      KVM: arm64: Move CNT*_CTL_EL0 userspace accessors to generic infrastructure
      KVM: arm64: Move CNT*_CVAL_EL0 userspace accessors to generic infrastructure
      KVM: arm64: Move CNT*CT_EL0 userspace accessors to generic infrastructure
      KVM: arm64: Fix WFxT handling of nested virt
      KVM: arm64: Kill leftovers of ad-hoc timer userspace access
      KVM: arm64: selftests: Make dependencies on VHE-specific registers explicit
      KVM: arm64: selftests: Add an E2H=0-specific configuration to get_reg_list
      KVM: arm64: selftests: Fix misleading comment about virtual timer encoding
      arm64: Revamp HCR_EL2.E2H RES1 detection

Mukesh Ojha (1):
      KVM: arm64: Guard PMSCR_EL1 initialization with SPE presence check

Oliver Upton (9):
      KVM: arm64: nv: Don't treat ZCR_EL2 as a 'mapped' register
      KVM: arm64: Use the in-context stage-1 in __kvm_find_s1_desc_level()
      KVM: arm64: selftests: Test effective value of HCR_EL2.AMO
      KVM: arm64: Prevent access to vCPU events before init
      KVM: arm64: Document vCPU event ioctls as requiring init'ed vCPU
      KVM: selftests: Fix irqfd_test for non-x86 architectures
      KVM: arm64: selftests: Actually enable IRQs in vgic_lpi_stress
      KVM: arm64: Compute per-vCPU FGTs at vcpu_load()
      KVM: arm64: nv: Use FGT write trap of MDSCR_EL1 when available

Osama Abdelkader (1):
      KVM: arm64: Remove unreachable break after return

Sascha Bischoff (2):
      KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests
      Documentation: KVM: Update GICv3 docs for GICv5 hosts

Sean Christopherson (1):
      KVM: arm64: selftests: Track width of timer counter as "int", not "uint64_t"

Zenghui Yu (2):
      KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in guest
      KVM: arm64: selftests: Allocate vcpus with correct size

 Documentation/virt/kvm/api.rst                     |   5 +
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |   3 +-
 arch/arm64/include/asm/el2_setup.h                 |  38 +++++-
 arch/arm64/include/asm/kvm_host.h                  |  50 +++++++
 arch/arm64/kvm/arch_timer.c                        | 105 ++-------------
 arch/arm64/kvm/arm.c                               |   7 +
 arch/arm64/kvm/at.c                                |   7 +-
 arch/arm64/kvm/config.c                            |  90 +++++++++++++
 arch/arm64/kvm/debug.c                             |  15 ++-
 arch/arm64/kvm/guest.c                             |  70 ----------
 arch/arm64/kvm/handle_exit.c                       |   7 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 148 +++------------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   1 +
 arch/arm64/kvm/nested.c                            |   9 +-
 arch/arm64/kvm/sys_regs.c                          | 131 ++++++++++++++----
 arch/arm64/kvm/sys_regs.h                          |   6 +
 arch/arm64/kvm/vgic/vgic-v3.c                      |   5 +-
 include/kvm/arm_arch_timer.h                       |  24 ++--
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |   2 +-
 .../testing/selftests/kvm/arm64/external_aborts.c  |  43 ++++++
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |  99 +++++++++++++-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |   3 +
 .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   3 +-
 .../selftests/kvm/include/arm64/processor.h        |  12 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   2 +
 tools/testing/selftests/kvm/irqfd_test.c           |  14 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +
 tools/testing/selftests/kvm/lib/s390/processor.c   |   5 +
 tools/testing/selftests/kvm/lib/x86/processor.c    |   5 +
 30 files changed, 565 insertions(+), 354 deletions(-)

