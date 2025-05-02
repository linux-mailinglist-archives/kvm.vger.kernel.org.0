Return-Path: <kvm+bounces-45231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A791EAA7312
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1FF51C02FF9
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B46255236;
	Fri,  2 May 2025 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PUfTHgWM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61F1252905;
	Fri,  2 May 2025 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191606; cv=none; b=Pj8IBZ2ACDsCyH256PsyfsEm22wb/6kKnEDLyZK1iroRNu9B00FPwTS0ZqtvR+IHfiDwyXSX/7T340iNMJ7kpZ+wL1caLe3ATZefoNzoD/wYPrzed64j7yBSkZcunFxMbIiaintv7uKmcF+zPyutqmONhaiSmAciy+t1btcsgxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191606; c=relaxed/simple;
	bh=8rjzfX3W2W2Ua3bnqMyXei5mk/ntSXdZx8V9rkAjM0A=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YXP6+qcX6mFz3b1EMJv4q2HdX0WzcXZTovEFDhoCxDelcAPGqaf/GFwSOi2VIePBcVTnTn2myUTTl8MF5DYmb+s1kE8suMI9mQtN7pGGtl5ZgorZVcYi9WEUF/cHIIGORagOjqm9Fd1eHTj2BlVItPzIcDY7CMs94hg+Kek57Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PUfTHgWM; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191604; x=1777727604;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=8rjzfX3W2W2Ua3bnqMyXei5mk/ntSXdZx8V9rkAjM0A=;
  b=PUfTHgWMvFJxTxND5TgwBvNsgJId94eVBVfY440xMak13A4AWz2tAXMD
   Tao5LLz6glxthe48jZDAji454nEQ7pCS0yaWIRtt58SJAPgIb8CALdIzn
   XjXoRZMkps0dcuyhpJu5ErZ/E3FMm724c1VeqkvyhLDVla9PiJNPNQ+hb
   UI2miYeVyfl8xb9sD5fQDWVHBUH7OlS2t6VwkIU4+iQP76IHZjN0OWL7D
   k2GhxH/HW2A29ksO0xD7OsaxXM/E0fegq45MRQzdcYeFZs+un+N0qk1rp
   Yr6I/ELrKocmRKRB/psq9q++qBO2KKjoqZHjZWXykBb5aSUxgu2PFj0aa
   w==;
X-CSE-ConnectionGUID: 3nKXHhdgS9Wu9QsbB212VA==
X-CSE-MsgGUID: 8DsjZxQjR+S24+L33e3JJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="59233288"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="59233288"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:13:23 -0700
X-CSE-ConnectionGUID: uqJeJQZ9QjyJ9pDg+lbEpA==
X-CSE-MsgGUID: eaKgRDz1TzO6Du8usPzXEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="135599266"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.135])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:13:07 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 2 May 2025 16:13:03 +0300 (EEST)
To: "Xin Li (Intel)" <xin@zytor.com>, mingo@redhat.com
cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
    linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
    virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
    linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
    linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
    Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, acme@kernel.org, jgross@suse.com, 
    andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org, 
    mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
    irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com, 
    wei.liu@kernel.org, ajay.kaher@broadcom.com, 
    bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com, 
    pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com, 
    luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com, 
    haiyangz@microsoft.com, decui@microsoft.com, dapeng1.mi@linux.intel.com
Subject: Re: [PATCH v4A 01/15] x86/msr: Add missing includes of <asm/msr.h>
In-Reply-To: <20250501054241.1245648-1-xin@zytor.com>
Message-ID: <a34d7955-aa31-7bef-52cf-65dc4bb7a5c1@linux.intel.com>
References: <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com> <20250501054241.1245648-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-2124274657-1746191047=:958"
Content-ID: <69d4ead6-fa09-8594-add2-0d027d3e7e6c@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2124274657-1746191047=:958
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <914dd26d-9889-125a-917d-3b9acfbc7938@linux.intel.com>

On Wed, 30 Apr 2025, Xin Li (Intel) wrote:

> For some reason, there are some TSC-related functions in the MSR
> header even though there is a tsc.h header.
>=20
> To facilitate the relocation of rdtsc{,_ordered}() from <asm/msr.h>
> to <asm/tsc.h> and to eventually eliminate the inclusion of
> <asm/msr.h> in <asm/tsc.h>, add <asm/msr.h> to the source files that
> reference definitions from <asm/msr.h>.
>=20
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> ---
>=20
> Change in v4A:
> *) Use "git grep -l -e $PATTERN | grep -v -f <(git grep -l -e 'asm/msr\.h=
')"
>    to ensure ALL required *direct* inclusion of <asm/msr.h> (Ilpo J=E4rvi=
nen).
>=20
> Change in v4:
> *) Add missing includes in a different patch (Ilpo J=E4rvinen).
> *) Add all necessary direct inclusions for msr.h (Ilpo J=E4rvinen).
>=20
> Change in v3:
> * Add a problem statement to the changelog (Dave Hansen).
> ---
>  arch/x86/coco/sev/core.c                                    | 1 +
>  arch/x86/events/amd/core.c                                  | 1 +
>  arch/x86/events/amd/ibs.c                                   | 1 +
>  arch/x86/events/amd/iommu.c                                 | 2 ++
>  arch/x86/events/amd/lbr.c                                   | 1 +
>  arch/x86/events/amd/power.c                                 | 1 +
>  arch/x86/events/core.c                                      | 1 +
>  arch/x86/events/intel/bts.c                                 | 1 +
>  arch/x86/events/intel/core.c                                | 1 +
>  arch/x86/events/intel/cstate.c                              | 1 +
>  arch/x86/events/intel/ds.c                                  | 1 +
>  arch/x86/events/intel/knc.c                                 | 1 +
>  arch/x86/events/intel/p4.c                                  | 1 +
>  arch/x86/events/intel/p6.c                                  | 1 +
>  arch/x86/events/intel/pt.c                                  | 1 +
>  arch/x86/events/intel/uncore.c                              | 1 +
>  arch/x86/events/intel/uncore_discovery.c                    | 1 +
>  arch/x86/events/intel/uncore_nhmex.c                        | 1 +
>  arch/x86/events/intel/uncore_snb.c                          | 1 +
>  arch/x86/events/intel/uncore_snbep.c                        | 1 +
>  arch/x86/events/msr.c                                       | 2 ++
>  arch/x86/events/perf_event.h                                | 1 +
>  arch/x86/events/probe.c                                     | 2 ++
>  arch/x86/events/rapl.c                                      | 1 +
>  arch/x86/events/utils.c                                     | 1 +
>  arch/x86/events/zhaoxin/core.c                              | 1 +
>  arch/x86/hyperv/hv_apic.c                                   | 1 +
>  arch/x86/hyperv/hv_init.c                                   | 1 +
>  arch/x86/hyperv/hv_spinlock.c                               | 1 +
>  arch/x86/hyperv/hv_vtl.c                                    | 1 +
>  arch/x86/hyperv/ivm.c                                       | 1 +
>  arch/x86/include/asm/fred.h                                 | 1 +
>  arch/x86/include/asm/kvm_host.h                             | 1 +
>  arch/x86/include/asm/microcode.h                            | 2 ++
>  arch/x86/include/asm/mshyperv.h                             | 1 +
>  arch/x86/include/asm/msr.h                                  | 1 +
>  arch/x86/include/asm/resctrl.h                              | 2 ++
>  arch/x86/include/asm/suspend_32.h                           | 1 +
>  arch/x86/include/asm/suspend_64.h                           | 1 +
>  arch/x86/include/asm/switch_to.h                            | 2 ++
>  arch/x86/kernel/acpi/sleep.c                                | 1 +
>  arch/x86/kernel/amd_nb.c                                    | 1 +
>  arch/x86/kernel/apic/apic.c                                 | 1 +
>  arch/x86/kernel/apic/apic_numachip.c                        | 1 +
>  arch/x86/kernel/cet.c                                       | 1 +
>  arch/x86/kernel/cpu/amd.c                                   | 1 +
>  arch/x86/kernel/cpu/aperfmperf.c                            | 1 +
>  arch/x86/kernel/cpu/bus_lock.c                              | 1 +
>  arch/x86/kernel/cpu/feat_ctl.c                              | 1 +
>  arch/x86/kernel/cpu/hygon.c                                 | 1 +
>  arch/x86/kernel/cpu/mce/inject.c                            | 1 +
>  arch/x86/kernel/cpu/microcode/core.c                        | 1 +
>  arch/x86/kernel/cpu/mshyperv.c                              | 1 +
>  arch/x86/kernel/cpu/resctrl/core.c                          | 1 +
>  arch/x86/kernel/cpu/resctrl/monitor.c                       | 1 +
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c                   | 1 +
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c                      | 1 +
>  arch/x86/kernel/cpu/sgx/main.c                              | 1 +
>  arch/x86/kernel/cpu/topology.c                              | 1 +
>  arch/x86/kernel/cpu/topology_amd.c                          | 1 +
>  arch/x86/kernel/cpu/tsx.c                                   | 1 +
>  arch/x86/kernel/cpu/zhaoxin.c                               | 1 +
>  arch/x86/kernel/fpu/core.c                                  | 1 +
>  arch/x86/kernel/fpu/xstate.c                                | 1 +
>  arch/x86/kernel/fpu/xstate.h                                | 1 +
>  arch/x86/kernel/fred.c                                      | 1 +
>  arch/x86/kernel/hpet.c                                      | 1 +
>  arch/x86/kernel/kvm.c                                       | 1 +
>  arch/x86/kernel/paravirt.c                                  | 1 +
>  arch/x86/kernel/process.c                                   | 1 +
>  arch/x86/kernel/process_64.c                                | 1 +
>  arch/x86/kernel/trace_clock.c                               | 2 +-
>  arch/x86/kernel/traps.c                                     | 1 +
>  arch/x86/kernel/tsc.c                                       | 1 +
>  arch/x86/kernel/tsc_sync.c                                  | 1 +
>  arch/x86/kvm/svm/avic.c                                     | 1 +
>  arch/x86/kvm/svm/sev.c                                      | 1 +
>  arch/x86/kvm/svm/svm.c                                      | 1 +
>  arch/x86/kvm/vmx/nested.c                                   | 1 +
>  arch/x86/kvm/vmx/pmu_intel.c                                | 1 +
>  arch/x86/kvm/vmx/sgx.c                                      | 1 +
>  arch/x86/kvm/vmx/vmx.c                                      | 1 +
>  arch/x86/lib/insn-eval.c                                    | 1 +
>  arch/x86/lib/kaslr.c                                        | 2 +-
>  arch/x86/mm/mem_encrypt_identity.c                          | 1 +
>  arch/x86/mm/tlb.c                                           | 1 +
>  arch/x86/pci/amd_bus.c                                      | 1 +
>  arch/x86/pci/mmconfig-shared.c                              | 3 ++-
>  arch/x86/power/cpu.c                                        | 1 +
>  arch/x86/realmode/init.c                                    | 1 +
>  arch/x86/virt/svm/sev.c                                     | 1 +
>  arch/x86/xen/enlighten_pv.c                                 | 1 +
>  arch/x86/xen/pmu.c                                          | 1 +
>  arch/x86/xen/suspend.c                                      | 1 +
>  drivers/accel/habanalabs/common/habanalabs_ioctl.c          | 2 --
>  drivers/acpi/acpi_extlog.c                                  | 1 +
>  drivers/acpi/processor_perflib.c                            | 1 +
>  drivers/acpi/processor_throttling.c                         | 6 +++++-
>  drivers/char/agp/nvidia-agp.c                               | 1 +
>  drivers/cpufreq/amd-pstate-ut.c                             | 2 ++
>  drivers/cpufreq/elanfreq.c                                  | 1 -
>  drivers/cpufreq/sc520_freq.c                                | 1 -
>  drivers/crypto/ccp/sev-dev.c                                | 1 +
>  drivers/edac/amd64_edac.c                                   | 1 +
>  drivers/edac/ie31200_edac.c                                 | 1 +
>  drivers/edac/mce_amd.c                                      | 1 +
>  drivers/hwmon/hwmon-vid.c                                   | 4 ++++
>  drivers/idle/intel_idle.c                                   | 1 +
>  drivers/misc/cs5535-mfgpt.c                                 | 1 +
>  drivers/net/vmxnet3/vmxnet3_drv.c                           | 4 ++++
>  drivers/platform/x86/intel/ifs/core.c                       | 1 +
>  drivers/platform/x86/intel/ifs/load.c                       | 1 +
>  drivers/platform/x86/intel/ifs/runtest.c                    | 1 +
>  drivers/platform/x86/intel/pmc/cnp.c                        | 1 +
>  drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
>  .../platform/x86/intel/speed_select_if/isst_if_mbox_msr.c   | 1 +
>  drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c | 1 +
>  drivers/platform/x86/intel/turbo_max_3.c                    | 1 +
>  .../platform/x86/intel/uncore-frequency/uncore-frequency.c  | 1 +
>  drivers/powercap/intel_rapl_common.c                        | 1 +
>  drivers/powercap/intel_rapl_msr.c                           | 1 +
>  .../intel/int340x_thermal/processor_thermal_device.c        | 1 +
>  drivers/thermal/intel/intel_tcc_cooling.c                   | 1 +
>  drivers/thermal/intel/x86_pkg_temp_thermal.c                | 1 +
>  drivers/video/fbdev/geode/display_gx.c                      | 1 +
>  drivers/video/fbdev/geode/gxfb_core.c                       | 1 +
>  drivers/video/fbdev/geode/lxfb_ops.c                        | 1 +
>  127 files changed, 142 insertions(+), 8 deletions(-)
>=20

> diff --git a/arch/x86/kernel/trace_clock.c b/arch/x86/kernel/trace_clock.=
c
> index b8e7abe00b06..708d61743d15 100644
> --- a/arch/x86/kernel/trace_clock.c
> +++ b/arch/x86/kernel/trace_clock.c
> @@ -4,7 +4,7 @@
>   */
>  #include <asm/trace_clock.h>
>  #include <asm/barrier.h>
> -#include <asm/msr.h>
> +#include <asm/tsc.h>

Does this change belong to this patch?

It might even cause a build failure until the second patch which moves=20
the tsc related things to the other file (unless there's indirect include=
=20
path to asm/msr.h).

> diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
> index a58f451a7dd3..b5893928d55c 100644
> --- a/arch/x86/lib/kaslr.c
> +++ b/arch/x86/lib/kaslr.c
> @@ -8,7 +8,7 @@
>   */
>  #include <asm/asm.h>
>  #include <asm/kaslr.h>
> -#include <asm/msr.h>
> +#include <asm/tsc.h>

Same thing here.

>  #include <asm/archrandom.h>
>  #include <asm/e820/api.h>
>  #include <asm/shared/io.h>

> diff --git a/drivers/accel/habanalabs/common/habanalabs_ioctl.c b/drivers=
/accel/habanalabs/common/habanalabs_ioctl.c
> index 8729a0c57d78..dc80ca921d90 100644
> --- a/drivers/accel/habanalabs/common/habanalabs_ioctl.c
> +++ b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
> @@ -17,8 +17,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/vmalloc.h>
> =20
> -#include <asm/msr.h>
> -

I suggested making a separate patch out of these removals. Currently you=20
do them without any clear warning in the changelog which only talks about=
=20
adding asm/msr.h.

> diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor=
_throttling.c
> index 00d045e5f524..ecd7fe256153 100644
> --- a/drivers/acpi/processor_throttling.c
> +++ b/drivers/acpi/processor_throttling.c
> @@ -18,9 +18,13 @@
>  #include <linux/sched.h>
>  #include <linux/cpufreq.h>
>  #include <linux/acpi.h>
> +#include <linux/uaccess.h>
>  #include <acpi/processor.h>
>  #include <asm/io.h>
> -#include <linux/uaccess.h>
> +#include <asm/asm.h>

???

> +#ifdef CONFIG_X86
> +#include <asm/msr.h>
> +#endif


I really appreciate you took the effort to do this change the correct
way! :-)

--
 i.
--8323328-2124274657-1746191047=:958--

