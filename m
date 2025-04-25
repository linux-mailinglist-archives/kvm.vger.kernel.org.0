Return-Path: <kvm+bounces-44278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3B7A9C288
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77EEA189DE94
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C9F2356BA;
	Fri, 25 Apr 2025 08:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQR6xNWh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D594D21D59B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 08:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745571465; cv=none; b=ibTNU72FH0XJH5TmS62aa9ImyBrRjzuuPsEVVXUi4xf9Cgjg8dRKTfYTpD56ghgpIb8zMmiY7+YXRMJX8e7642mwViObsh//1zTUaa6EWwkJIzeHYOz2pRXX5vNV/hxFMnZ+4UFrYcXV/cPMhwFZVOhKYMJHXy8vXSciAdzgtuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745571465; c=relaxed/simple;
	bh=mcEr0zmSiDOPEt70TYU6E6B7dOkZJjNKNUv16j9oVcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkrSm0SmBACMK5F63/LRIfILrrr7rGquZpQ6edYHED0F4DseAtiV6K2PRAdpD2BzWz/6ry6Cg8KPFba486YI5Seb15R+qS4dIlWM525Vqbbqezs27HIqis9o3bQACW+JT1a4KjpXSk/XaouTHqSHhKeaPGcm2QoK/suDzqaoWHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nQR6xNWh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745571464; x=1777107464;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mcEr0zmSiDOPEt70TYU6E6B7dOkZJjNKNUv16j9oVcE=;
  b=nQR6xNWhSynKbf/DxoyOgKqK45/hX5103mNJ7yb4mX716Ccwx5hNkNph
   ENt4Zwi32advuRPDD85qwlJC/t/J3BuHKQdLhOjLMalFQMeBMJBplfDUt
   bR0gkQ0cC+Ak/RNRVElAZUYlSAHwFlwPRziQyQIjKBlLhVaIPcPRyAE5+
   NAh/TUn3Wp5eg8a8KGHpU78Ra3OFNgyO90TESD7Hvvc5VPZTufHEmJ2AO
   cmBn8lW4w97PPDdDtWusl87kgNfJvcrHnLy90dluUjLTsvcszg6vWG0Ze
   f6NnOIXbt9EzCOkD6QivAWTGJiYh/T2nMrfo9mOD4+BDpvwvEacoFXECJ
   g==;
X-CSE-ConnectionGUID: 0e0zPWzQQ76Gu0XkGdja6w==
X-CSE-MsgGUID: qV+csF3ERpaa3tJ79GroaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="58598695"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="58598695"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 01:57:43 -0700
X-CSE-ConnectionGUID: GO8FEL63QBeQRXrZ2LqRRQ==
X-CSE-MsgGUID: gdGUVTFQQaa54FHx4mG1AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="132847488"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 25 Apr 2025 01:57:33 -0700
Date: Fri, 25 Apr 2025 17:18:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
	kraxel@redhat.com, berrange@redhat.com
Subject: Re: [PATCH v4 09/11] target/i386/kvm: reset AMD PMU registers during
 VM reset
Message-ID: <aAtTZLZR7IRhdOUC@intel.com>
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-10-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416215306.32426-10-dongli.zhang@oracle.com>

On Wed, Apr 16, 2025 at 02:52:34PM -0700, Dongli Zhang wrote:
> Date: Wed, 16 Apr 2025 14:52:34 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v4 09/11] target/i386/kvm: reset AMD PMU registers during
>  VM reset
> X-Mailer: git-send-email 2.43.5
> 
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
> 
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
> 
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> 4. After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
> Changed since v2:
>   - Remove 'static' from host_cpuid_vendorX.
>   - Change has_pmu_version to pmu_version.
>   - Use object_property_get_int() to get CPU family.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Send error log when host and guest are from different vendors.
>   - Move "if (!cpu->enable_pmu)" to begin of function. Add comments to
>     reminder developers.
>   - Add support to Zhaoxin. Change is_same_vendor() to
>     is_host_compat_vendor().
>   - Didn't add Reviewed-by from Sandipan because the change isn't minor.
> Changed since v3:
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Check AMD directly makes the "compat" rule clear.
>   - Add comment to MAX_GP_COUNTERS.
>   - Skip PMU info initialization if !kvm_pmu_disabled.
> 
>  target/i386/cpu.h     |  12 +++
>  target/i386/kvm/kvm.c | 175 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 183 insertions(+), 4 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


