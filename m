Return-Path: <kvm+bounces-42295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEBAA775A9
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 09:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ECE87A367D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6871E9B21;
	Tue,  1 Apr 2025 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8qHtNBy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298E22D05E;
	Tue,  1 Apr 2025 07:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743493985; cv=none; b=s2cwuoC1DQdr0fDqLdwPhcph8j2huTX4C5FOWBRilnSKXURNMsng9uaIukZvWdcAyzKgoeK20MnCO6UB5PvJbRwQuYDn5FQ++jN5WPs0OelYaPl0lKPaLJ9eigIQYLRpY6rPzziL3fgy0IKfLGdl3zu+REkBJic1Spuvle9jhkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743493985; c=relaxed/simple;
	bh=85J+UQqrPmkLGjgTDn4/gMvG0FvRmMphb7RZrr3I10Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgD6lMShP06lDpiasqqI1bW24Ev94JGYn/Dolq37LeZoGTrSPcTEE0+paZuNCxdVgiNQrXXtRd4E2T9a4vPXIwakGX0LhFmps/hELa6ZJXJLhqE6OUPSNyD15cO8IJu3xYMuD3yIlMK59H/g6aJya0sPouOHnBqGMWDHxvYVWZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8qHtNBy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8963EC4CEE4;
	Tue,  1 Apr 2025 07:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743493984;
	bh=85J+UQqrPmkLGjgTDn4/gMvG0FvRmMphb7RZrr3I10Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z8qHtNByIm8E5p7AbYs018QH17/ls1OzKBt8dHzcgbJ67+A1/wTK+6rA4JlB/4Ps/
	 WHwSgnuRMBluhXVJsMV2uImUjVoCl7ZOUajOXz8Hy2N7kW37JJREgvN1MLwtK8P16B
	 30z2+YLa787+Wp3jqgsF4EZ1g26n27iQ91Ma0VqyTWbEZNW+g4X5Pr7B5VytBQpKSn
	 gU5tO4JDdcbGvmbLt948CbvNiXSCFGtMI8xYuqH8g75jwnqDwYAt1tbX3G/fZ2xGxQ
	 vbNOC92UT5Zbj1+851IKPt/uEZp+yF68D+7pSayPTk33ws4MtrWg9ytAxtDP4ARZWZ
	 93xpSccuufhrg==
Date: Tue, 1 Apr 2025 09:52:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, linux-edac@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
	bpf@vger.kernel.org, llvm@lists.linux.dev, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
	peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, alexey.amakhalov@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
	pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
	luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
	haiyangz@microsoft.com, decui@microsoft.com,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v1 01/15] x86/msr: Replace __wrmsr() with
 native_wrmsrl()
Message-ID: <Z-ubVFyoOzwKhI53@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-2-xin@zytor.com>
 <Z-pruogreCuU66wm@gmail.com>
 <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com>


* H. Peter Anvin <hpa@zytor.com> wrote:

> On March 31, 2025 3:17:30 AM PDT, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >* Xin Li (Intel) <xin@zytor.com> wrote:
> >
> >> -	__wrmsr      (MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3, val >> 32);
> >> +	native_wrmsrl(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);
> >
> >This is an improvement.
> >
> >> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
> >> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)plr->closid << 32 | rmid_p);
> >
> >> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
> >> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)closid_p << 32 | rmid_p);
> >
> >This is not an improvement.
> >
> >Please provide a native_wrmsrl() API variant where natural [rmid_p, closid_p]
> >high/lo parameters can be used, without the shift-uglification...
> >
> >Thanks,
> >
> >	Ingo
> 
> Directing this question primarily to Ingo, who is more than anyone 
> else the namespace consistency guardian:
> 
> On the subject of msr function naming ... *msrl() has always been 
> misleading. The -l suffix usually means 32 bits; sometimes it means 
> the C type "long" (which in the kernel is used instead of 
> size_t/uintptr_t, which might end up being "fun" when 128-bit 
> architectures appear some time this century), but for a fixed 64-but 
> type we normally use -q.

Yeah, agreed - that's been bothering me for a while too. :-)

> Should we rename the *msrl() functions to *msrq() as part of this 
> overhaul?

Yeah, that's a good idea, and because talk is cheap I just implemented 
this in the tip:WIP.x86/msr branch with a couple of other cleanups in 
this area (see the shortlog & diffstat below), but the churn is high:

  144 files changed, 1034 insertions(+), 1034 deletions(-)

So this can only be done if regenerated and sent to Linus right before 
an -rc1 I think:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip WIP.x86/msr

Thanks,

	Ingo

=======================>
Ingo Molnar (18):
      x86/msr: Standardize on u64 in <asm/msr.h>
      x86/msr: Standardize on u64 in <asm/msr-index.h>
      x86/msr: Use u64 in rdmsrl_amd_safe() and wrmsrl_amd_safe()
      x86/msr: Use u64 in rdmsrl_safe() and paravirt_read_pmc()
      x86/msr: Rename 'rdmsrl()' to 'rdmsrq()'
      x86/msr: Rename 'wrmsrl()' to 'wrmsrq()'
      x86/msr: Rename 'rdmsrl_safe()' to 'rdmsrq_safe()'
      x86/msr: Rename 'wrmsrl_safe()' to 'wrmsrq_safe()'
      x86/msr: Rename 'rdmsrl_safe_on_cpu()' to 'rdmsrq_safe_on_cpu()'
      x86/msr: Rename 'wrmsrl_safe_on_cpu()' to 'wrmsrq_safe_on_cpu()'
      x86/msr: Rename 'rdmsrl_on_cpu()' to 'rdmsrq_on_cpu()'
      x86/msr: Rename 'wrmsrl_on_cpu()' to 'wrmsrq_on_cpu()'
      x86/msr: Rename 'mce_rdmsrl()' to 'mce_rdmsrq()'
      x86/msr: Rename 'mce_wrmsrl()' to 'mce_wrmsrq()'
      x86/msr: Rename 'rdmsrl_amd_safe()' to 'rdmsrq_amd_safe()'
      x86/msr: Rename 'wrmsrl_amd_safe()' to 'wrmsrq_amd_safe()'
      x86/msr: Rename 'native_wrmsrl()' to 'native_wrmsrq()'
      x86/msr: Rename 'wrmsrl_cstar()' to 'wrmsrq_cstar()'

 arch/x86/coco/sev/core.c                           |   2 +-
 arch/x86/events/amd/brs.c                          |   8 +-
 arch/x86/events/amd/core.c                         |  12 +--
 arch/x86/events/amd/ibs.c                          |  26 ++---
 arch/x86/events/amd/lbr.c                          |  20 ++--
 arch/x86/events/amd/power.c                        |  10 +-
 arch/x86/events/amd/uncore.c                       |  12 +--
 arch/x86/events/core.c                             |  42 ++++----
 arch/x86/events/intel/core.c                       |  66 ++++++-------
 arch/x86/events/intel/cstate.c                     |   2 +-
 arch/x86/events/intel/ds.c                         |  10 +-
 arch/x86/events/intel/knc.c                        |  16 +--
 arch/x86/events/intel/lbr.c                        |  44 ++++-----
 arch/x86/events/intel/p4.c                         |  24 ++---
 arch/x86/events/intel/p6.c                         |  12 +--
 arch/x86/events/intel/pt.c                         |  32 +++---
 arch/x86/events/intel/uncore.c                     |   2 +-
 arch/x86/events/intel/uncore_discovery.c           |  10 +-
 arch/x86/events/intel/uncore_nhmex.c               |  70 ++++++-------
 arch/x86/events/intel/uncore_snb.c                 |  42 ++++----
 arch/x86/events/intel/uncore_snbep.c               |  50 +++++-----
 arch/x86/events/msr.c                              |   2 +-
 arch/x86/events/perf_event.h                       |  26 ++---
 arch/x86/events/probe.c                            |   2 +-
 arch/x86/events/rapl.c                             |   8 +-
 arch/x86/events/zhaoxin/core.c                     |  16 +--
 arch/x86/hyperv/hv_apic.c                          |   4 +-
 arch/x86/hyperv/hv_init.c                          |  66 ++++++-------
 arch/x86/hyperv/hv_spinlock.c                      |   6 +-
 arch/x86/hyperv/ivm.c                              |   2 +-
 arch/x86/include/asm/apic.h                        |   8 +-
 arch/x86/include/asm/debugreg.h                    |   4 +-
 arch/x86/include/asm/fsgsbase.h                    |   4 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/microcode.h                   |   2 +-
 arch/x86/include/asm/msr-index.h                   |  12 +--
 arch/x86/include/asm/msr.h                         |  50 +++++-----
 arch/x86/include/asm/paravirt.h                    |   8 +-
 arch/x86/include/asm/spec-ctrl.h                   |   2 +-
 arch/x86/kernel/acpi/cppc.c                        |   8 +-
 arch/x86/kernel/amd_nb.c                           |   2 +-
 arch/x86/kernel/apic/apic.c                        |  16 +--
 arch/x86/kernel/apic/apic_numachip.c               |   6 +-
 arch/x86/kernel/cet.c                              |   2 +-
 arch/x86/kernel/cpu/amd.c                          |  28 +++---
 arch/x86/kernel/cpu/aperfmperf.c                   |  28 +++---
 arch/x86/kernel/cpu/bugs.c                         |  24 ++---
 arch/x86/kernel/cpu/bus_lock.c                     |  18 ++--
 arch/x86/kernel/cpu/common.c                       |  68 ++++++-------
 arch/x86/kernel/cpu/feat_ctl.c                     |   4 +-
 arch/x86/kernel/cpu/hygon.c                        |   6 +-
 arch/x86/kernel/cpu/intel.c                        |  10 +-
 arch/x86/kernel/cpu/intel_epb.c                    |  12 +--
 arch/x86/kernel/cpu/mce/amd.c                      |  22 ++---
 arch/x86/kernel/cpu/mce/core.c                     |  58 +++++------
 arch/x86/kernel/cpu/mce/inject.c                   |  32 +++---
 arch/x86/kernel/cpu/mce/intel.c                    |  32 +++---
 arch/x86/kernel/cpu/mce/internal.h                 |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  12 +--
 arch/x86/kernel/cpu/resctrl/core.c                 |  10 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   2 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c          |   2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   6 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   2 +-
 arch/x86/kernel/cpu/topology.c                     |   2 +-
 arch/x86/kernel/cpu/topology_amd.c                 |   4 +-
 arch/x86/kernel/cpu/tsx.c                          |  20 ++--
 arch/x86/kernel/cpu/umwait.c                       |   2 +-
 arch/x86/kernel/fpu/core.c                         |   2 +-
 arch/x86/kernel/fpu/xstate.c                       |  10 +-
 arch/x86/kernel/fpu/xstate.h                       |   2 +-
 arch/x86/kernel/fred.c                             |  20 ++--
 arch/x86/kernel/hpet.c                             |   2 +-
 arch/x86/kernel/kvm.c                              |  28 +++---
 arch/x86/kernel/kvmclock.c                         |   4 +-
 arch/x86/kernel/mmconf-fam10h_64.c                 |   8 +-
 arch/x86/kernel/process.c                          |  16 +--
 arch/x86/kernel/process_64.c                       |  20 ++--
 arch/x86/kernel/reboot_fixups_32.c                 |   2 +-
 arch/x86/kernel/shstk.c                            |  18 ++--
 arch/x86/kernel/traps.c                            |  10 +-
 arch/x86/kernel/tsc.c                              |   2 +-
 arch/x86/kernel/tsc_sync.c                         |  14 +--
 arch/x86/kvm/svm/avic.c                            |   2 +-
 arch/x86/kvm/svm/sev.c                             |   2 +-
 arch/x86/kvm/svm/svm.c                             |  16 +--
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
 arch/x86/kvm/vmx/sgx.c                             |   8 +-
 arch/x86/kvm/vmx/vmx.c                             |  66 ++++++-------
 arch/x86/kvm/x86.c                                 |  38 ++++----
 arch/x86/lib/insn-eval.c                           |   6 +-
 arch/x86/lib/msr-smp.c                             |  16 +--
 arch/x86/lib/msr.c                                 |   4 +-
 arch/x86/mm/pat/memtype.c                          |   4 +-
 arch/x86/mm/tlb.c                                  |   2 +-
 arch/x86/pci/amd_bus.c                             |  10 +-
 arch/x86/platform/olpc/olpc-xo1-rtc.c              |   6 +-
 arch/x86/platform/olpc/olpc-xo1-sci.c              |   2 +-
 arch/x86/power/cpu.c                               |  26 ++---
 arch/x86/realmode/init.c                           |   2 +-
 arch/x86/virt/svm/sev.c                            |  20 ++--
 arch/x86/xen/suspend.c                             |   6 +-
 drivers/acpi/acpi_extlog.c                         |   2 +-
 drivers/acpi/acpi_lpit.c                           |   2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   8 +-
 drivers/cpufreq/amd-pstate-ut.c                    |   6 +-
 drivers/cpufreq/amd-pstate.c                       |  22 ++---
 drivers/cpufreq/amd_freq_sensitivity.c             |   2 +-
 drivers/cpufreq/e_powersaver.c                     |   6 +-
 drivers/cpufreq/intel_pstate.c                     | 108 ++++++++++-----------
 drivers/cpufreq/longhaul.c                         |  24 ++---
 drivers/cpufreq/powernow-k7.c                      |  14 +--
 drivers/crypto/ccp/sev-dev.c                       |   2 +-
 drivers/edac/amd64_edac.c                          |   6 +-
 drivers/gpu/drm/i915/selftests/librapl.c           |   4 +-
 drivers/hwmon/fam15h_power.c                       |   6 +-
 drivers/idle/intel_idle.c                          |  34 +++----
 drivers/mtd/nand/raw/cs553x_nand.c                 |   6 +-
 drivers/platform/x86/intel/ifs/core.c              |   4 +-
 drivers/platform/x86/intel/ifs/load.c              |  20 ++--
 drivers/platform/x86/intel/ifs/runtest.c           |  16 +--
 drivers/platform/x86/intel/pmc/cnp.c               |   6 +-
 drivers/platform/x86/intel/pmc/core.c              |   8 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |  18 ++--
 .../x86/intel/speed_select_if/isst_if_mbox_msr.c   |  14 +--
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   2 +-
 drivers/platform/x86/intel/tpmi_power_domains.c    |   4 +-
 drivers/platform/x86/intel/turbo_max_3.c           |   4 +-
 .../x86/intel/uncore-frequency/uncore-frequency.c  |  10 +-
 drivers/platform/x86/intel_ips.c                   |  36 +++----
 drivers/powercap/intel_rapl_msr.c                  |   6 +-
 .../int340x_thermal/processor_thermal_device.c     |   2 +-
 drivers/thermal/intel/intel_hfi.c                  |  14 +--
 drivers/thermal/intel/intel_powerclamp.c           |   4 +-
 drivers/thermal/intel/intel_tcc_cooling.c          |   4 +-
 drivers/thermal/intel/therm_throt.c                |  10 +-
 drivers/video/fbdev/geode/gxfb_core.c              |   2 +-
 drivers/video/fbdev/geode/lxfb_ops.c               |  22 ++---
 drivers/video/fbdev/geode/suspend_gx.c             |  10 +-
 drivers/video/fbdev/geode/video_gx.c               |  16 +--
 include/hyperv/hvgdk_mini.h                        |   2 +-
 144 files changed, 1034 insertions(+), 1034 deletions(-)

