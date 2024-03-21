Return-Path: <kvm+bounces-12421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E370E885E50
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99EF9282099
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515BE13B2A5;
	Thu, 21 Mar 2024 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BEe7/88K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E401713A86C;
	Thu, 21 Mar 2024 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711039081; cv=none; b=nTKJJDW6+B/lmEtO/hsUc0oMKFpZ5l68KwMIkEzji+7pCWn4Gq+7jgn5YjDZ8V20hC/S04PZSOhwU8kvmj3/NOCwm0DyxOeH1izIzpRvPIqNH/d7UZ37WpmpxsSR7CSHHRC3OSDAV2aHn2cH3uMMOdqL+HVuyMAxsN+tk8kBNgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711039081; c=relaxed/simple;
	bh=YCj2qQftSd7l+gxFrpcsdW9Lj3sXlflLeQPUXhtO+ik=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XPytBQtOvyDoMkwHzlJniU5xBSRmpJa5lTkJ2OthpybSAdTCBzVoBE7r3DTT4vo+H+uPu5NfgWz2niMllam33HOIZ/dlhNglgNyHRQ7k2TkWL6rCVHhnQCwDF0YGq0iQnxRR0aTZ96a34My1fKgPLxZmI37cKzhr2P1jO5DFupk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BEe7/88K; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711039079; x=1742575079;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YCj2qQftSd7l+gxFrpcsdW9Lj3sXlflLeQPUXhtO+ik=;
  b=BEe7/88KCUmfMjO0o87DY83gd8oSo9xJopg2dCm/Yny6G+kr2vXVM3L5
   GNqZAW0SIn5q2RlVXLrnT96MnKe75GeUTbvDRn0TJhoZUHx5+wVYSPkWy
   cgZUBbQ0QQysRfwRpm5rY4WXOnauBE2lJ9/SZF6+gfVjrk990JjjXcLrk
   RDT4+zyudV7uaJO3gSqTjP/nD5bAUEmbJ2raCeyWqk/v3bn+McURU8zXT
   pIIuN/tzz8huW9BtTj/hhpc46D9YLucHQDq/1HtZh5Mt1SqOnVWcKJyh2
   jeD+CgWf/WBAnfIiBB0HZT73Evw3mMFWTF+TuBmeL5zxJJT+1YhxaEhQ+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="31477555"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="31477555"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="19280008"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
Date: Thu, 21 Mar 2024 09:37:40 -0700
Message-Id: <cover.1711035400.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

(I am helping Isaku for a bit by submitting the next versions of this
 series.)

Changes from v3:
- v3: https://lore.kernel.org/all/cover.1702974319.git.isaku.yamahata@intel.com/
- Reworked all changelogs.
- Regarding code changes: patches #1 and #2 are unchanged, patch #3 was
  reworked according to Sean's guidance, and patch #4 (the test)
  needed changes after rebase to kvm-x86/next and the implementation
  (patch #3) changes.
- Added Reviewed-by tags to patches #1, #2, and #4, but removed
  Maxim's Reviewed-by tag from patch #3 because it changed so much.
- Added a "Suggested-by" to patch #4 to reflect that it represents
  Sean's guidance.
- Reworked cover to match customs (in subject line) and reflect feedback
  to patches: capability renamed to KVM_CAP_X86_APIC_BUS_FREQUENCY, clarify
  distinction between "core crystal clock" and "bus clock", and update
  pro/con list.
- Please refer to individual patches for detailed changes.

Changes from v2:
- v2: https://lore.kernel.org/lkml/cover.1699936040.git.isaku.yamahata@intel.com/
- Removed APIC_BUS_FREQUENCY and apic_bus_frequency of struct kvm-arch.
- Update the commit messages.
- Added reviewed-by (Maxim Levitsky)
- Use 1.5GHz instead of 1GHz as frequency for the test case.

Changes from v1:
- v1: https://lore.kernel.org/all/cover.1699383993.git.isaku.yamahata@intel.com/
- Added a test case
- Fix a build error for i386 platform
- Add check if vcpu isn't created.
- Add check if lapic chip is in-kernel emulation.
- Updated api.rst

Summary
-------
Add KVM_CAP_X86_APIC_BUS_FREQUENCY capability to configure the APIC
bus clock frequency for APIC timer emulation.
Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_FREQUENCY) to set the
frequency in nanoseconds. When using this capability, the user space
VMM should configure CPUID leaf 0x15 to advertise the frequency.

Description
-----------
Vishal reported [1] that the TDX guest kernel expects a 25MHz APIC bus
frequency but ends up getting interrupts at a significantly higher rate.

The TDX architecture hard-codes the core crystal clock frequency to
25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
does not allow the VMM to override the value.

In addition, per Intel SDM:
    "The APIC timer frequency will be the processor’s bus clock or core
     crystal clock frequency (when TSC/core crystal clock ratio is
     enumerated in CPUID leaf 0x15) divided by the value specified in
     the divide configuration register."

The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
APIC bus frequency of 1GHz.

The KVM doesn't enumerate CPUID leaf 0x15 to the guest unless the user
space VMM sets it using KVM_SET_CPUID. If the CPUID leaf 0x15 is
enumerated, the guest kernel uses it as the APIC bus frequency. If not,
the guest kernel measures the frequency based on other known timers like
the ACPI timer or the legacy PIT. As reported in [1] the TDX guest kernel
expects a 25MHz timer frequency but gets timer interrupt more frequently
due to the 1GHz frequency used by KVM.

To ensure that the guest doesn't have a conflicting view of the APIC bus
frequency, allow the userspace to tell KVM to use the same frequency that
TDX mandates instead of the default 1Ghz.

There are several options to address this:
1. Make the KVM able to configure APIC bus frequency (this series).
   Pro: It resembles the existing hardware.  The recent Intel CPUs
        adopts 25MHz.
   Con: Require the VMM to emulate the APIC timer at 25MHz.
2. Make the TDX architecture enumerate CPUID leaf 0x15 to configurable
   frequency or not enumerate it.
   Pro: Any APIC bus frequency is allowed.
   Con: Deviates from TDX architecture.
3. Make the TDX guest kernel use 1GHz when it's running on KVM.
   Con: The kernel ignores CPUID leaf 0x15.
4. Change CPUID leaf 0x15 under TDX to report the crystal clock frequency
   as 1 GHz.
   Pro: This has been the virtual APIC frequency for KVM guests for 13
        years.
   Pro: This requires changing only one hard-coded constant in TDX.
   Con: It doesn't work with other VMMs as TDX isn't specific to KVM.
   Con: Core crystal clock frequency is also used to calculate TSC frequency.
   Con: If it is configured to value different from hardware, it will
        break the correctness of INTEL-PT Mini Time Count (MTC) packets
        in TDs.

[1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/

Isaku Yamahata (4):
  KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
  KVM: x86: Make nsec per APIC bus cycle a VM variable
  KVM: x86: Add a capability to configure bus frequency for APIC timer
  KVM: selftests: Add test for configure of x86 APIC bus frequency

 Documentation/virt/kvm/api.rst                |  17 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/hyperv.c                         |   3 +-
 arch/x86/kvm/lapic.c                          |   6 +-
 arch/x86/kvm/lapic.h                          |   3 +-
 arch/x86/kvm/x86.c                            |  28 +++
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   7 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 166 ++++++++++++++++++
 10 files changed, 228 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c


base-commit: 964d0c614c7f71917305a5afdca9178fe8231434
-- 
2.34.1


