Return-Path: <kvm+bounces-4779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B154381836E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4141CB24726
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8EB812B70;
	Tue, 19 Dec 2023 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsL+4TqP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF21170E;
	Tue, 19 Dec 2023 08:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702974917; x=1734510917;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yHtPjmqpz3Mz0YbnN6unWIOBLlJv/uXvh0ERtks9GyY=;
  b=dsL+4TqP/sSxpNfHr0NP99GOUPGGiGQSpl571Tl5TnVujNLKtKSMW9Jl
   KRKqAFvDxDEARGUuJWDoO6TYnKzRcA7p8zV3Lw/N3QiRDn1jlIr5dtdPJ
   fqwqxS2xTMZ+9FXWqubQCEIigsxxvbr+eAgnwRzMRFUpOOUefOh8YmaW+
   2CgR6UyqfxSdK31u3ncd3rP2e5OZMBVpITlj19I4Uhx2fS7mrVc42eu+T
   IdbvM8f6uTIj/boj4UW8LujjMzITV+5fv4OXulbtguoeBjfmWzfDDNzgW
   ai1fr05844tBjD+D1Bwqr7OhoAz5ReToeCigwy8kPz2TZVfmf3963GN1m
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="395355748"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="395355748"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="725658887"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="725658887"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:53 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH v3 0/4] KVM: X86: Make bus clock frequency for vapic timer configurable
Date: Tue, 19 Dec 2023 00:34:37 -0800
Message-Id: <cover.1702974319.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes from v2:
- Removed APIC_BUS_FREQUENCY and apic_bus_frequency of struct kvm-arch.
- Update the commit messages.
- Added reviewed-by (Maxim Levitsky)
- Use 1.5GHz instead of 1GHz as frequency for the test case.

Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
frequency.  When using this capability, the user space VMM should configure
CPUID[0x15] to advertise the frequency.

The TDX architecture hard-codes the APIC bus frequency to 25MHz in the
CPUID leaf 0x15.  The TDX mandates it to be exposed and doesn't allow the
VMM to override its value.  The KVM APIC timer emulation hard-codes the
frequency to 1GHz.  The KVM doesn't unconditionally enumerate it to the
guest unless the user space VMM sets the CPUID leaf 0x15 by KVM_SET_CPUID.

If the CPUID leaf 0x15 is enumerated, the guest kernel uses it as the APIC bus
frequency.  If not, the guest kernel measures the frequency based on other known
timers like the ACPI timer or the legacy PIT.  The TDX guest kernel gets timer
interrupt more times by 1GHz / 25MHz. [1] T o ensure that the guest doesn't have
a conflicting view of the APIC bus frequency, allow the userspace to tell KVM to
use the same frequency that TDX mandates instead of the default 1Ghz.

There are several options to address this.
1. Make the KVM able to configure APIC bus frequency (This patch).
   Pro: It resembles the existing hardware.  The recent Intel CPUs
        adapts 25MHz.
   Con: Require the VMM to emulate the APIC timer at 25MHz.
2. Make the TDX architecture enumerate CPUID 0x15 to configurable
   frequency or not enumerate it.
   Pro: Any APIC bus frequency is allowed.
   Con: Deviation from the real hardware.
3. Make the TDX guest kernel use 1GHz when it's running on KVM.
   Con: The kernel ignores CPUID leaf 0x15.
4. Change CPUID.15H under TDX to report the crystal clock frequency as
   1 GHz.
   Pro: This has been the virtual APIC frequency for KVM guests for 13
        years.
   Pro: This requires changing only one hard-coded constant in TDX.
   Con: It doesn't work with other VMMs as TDX isn't specific to KVM.

[1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/

Changes from v1:
  https://lore.kernel.org/all/cover.1699383993.git.isaku.yamahata@intel.com/
- Added a test case
- Fix a build error for i386 platform
- Add check if vcpu isn't created.
- Add check if lapic chip is in-kernel emulation.
- Updated api.rst

Isaku Yamahata (4):
  KVM: x86/hyperv: Calculate APIC bus frequency for hyper-v
  KVM: x86: Make the APIC bus cycles per nsec VM variable
  KVM: X86: Add a capability to configure bus frequency for APIC timer
  KVM: selftests: Add test case for x86 apic_bus_clock_frequency

 Documentation/virt/kvm/api.rst                |  14 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/hyperv.c                         |   3 +-
 arch/x86/kvm/lapic.c                          |   6 +-
 arch/x86/kvm/lapic.h                          |   3 +-
 arch/x86/kvm/x86.c                            |  34 +++++
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   7 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 135 ++++++++++++++++++
 10 files changed, 200 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c


base-commit: ceb6a6f023fd3e8b07761ed900352ef574010bcb
-- 
2.25.1


