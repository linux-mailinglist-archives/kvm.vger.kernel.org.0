Return-Path: <kvm+bounces-66960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B093ECEF739
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 23:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DF823013388
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 22:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F54F26C3AE;
	Fri,  2 Jan 2026 22:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rw7cCibD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE3E221540
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767394757; cv=none; b=pIs/RumZ6Qut5LEJEm2MsjugL65QYAeqJp5DU7peWU3IvCNZxac1QvdpkGmUPL4E7Igd7qW8c+j0AiiAsPLw5JPlhJtgrAKY29CDE58BHXP0jo3VBbhTu93VEpsbduKzrBA9I2GCPqm8x9LjcqgK0H+vOXh3T+LHwN8q1Lk+WfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767394757; c=relaxed/simple;
	bh=D20EtKNYAY+TWKUOPiodzmWKx69NyYfF3aLv9FA9bKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FZSndx1H5OgF6F8Dua1Q/hn/BwoISn0dKr9Cr4UwsWLQLOAt9E+cPQiwwkTvKm5RDDKaxMcOVudxSXQ60kV9P99u6ufH6nri2CBfs8j9tnqlhNHMYYdfawT5QyPTMvPJ+YLCkj+DTqwm4oGZFUYkt/f66z6E8qABPgbhizXdOIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rw7cCibD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767394756; x=1798930756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D20EtKNYAY+TWKUOPiodzmWKx69NyYfF3aLv9FA9bKk=;
  b=Rw7cCibDRW4zjNxkh2BL6Vvtv/AUy6omyZMhtPvChbs3XV2lI6GtCiB1
   Rc6q+qm+Ovtc0B32SocF/d0QvQNUxWqsvtf4CYlsXX0GhjIXRMEmL7ZG8
   B1xZbLmTB3LZC+PnQjPxRHltyg0KJgAHYRr+xp/x6+NaCI4zCqfud4e9A
   4L6kWAhZxJUGQpNIKCGWIVdjiea9aqVWdoxiyMnr69L6gQi2abhxkHwHA
   jR5xhnM7zYA/2DkXn+e/uMF8zXJ8gygzS3w8OtnZbBo/dfcUeMK7TwrfT
   adlmKvAH3/Jd49eTCdY6+Q32iVvns6a29olHpeAjF6u1hB+UlITuNU0I8
   A==;
X-CSE-ConnectionGUID: fNejScGIQzO9H2opTqQ7FA==
X-CSE-MsgGUID: loolYVJgTBOCWT4j2oTA7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="68862154"
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="68862154"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 14:59:15 -0800
X-CSE-ConnectionGUID: vRiXAqa6SEOb//OBkJgM0g==
X-CSE-MsgGUID: bicxgchGTNWycW3NUEgpSA==
X-ExtLoop1: 1
Received: from soc-cp83kr3.clients.intel.com (HELO [10.241.240.111]) ([10.241.240.111])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 14:59:14 -0800
Message-ID: <b6c531d4-328d-48a7-856b-051c918c24ae@intel.com>
Date: Fri, 2 Jan 2026 14:59:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] target/i386/kvm: query kvm.enable_pmu parameter
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-5-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20251230074354.88958-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/29/2025 11:42 PM, Dongli Zhang wrote:
> When PMU is enabled in QEMU, there is a chance that PMU virtualization is
> completely disabled by the KVM module parameter kvm.enable_pmu=N.
> 
> The kvm.enable_pmu parameter is introduced since Linux v5.17.
> Its permission is 0444. It does not change until a reload of the KVM
> module.
> 
> Read the kvm.enable_pmu value from the module sysfs to give a chance to
> provide more information about vPMU enablement.> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
> Changed since v2:
>   - Rework the code flow following Zhao's suggestion.
>   - Return error when:
>     (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu)
> Changed since v3:
>   - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
>     suggestion.
>   - Rework the commit messages.
>   - Bring back global static variable 'kvm_pmu_disabled' from v2.
> Changed since v4:
>   - Add Reviewed-by from Zhao.
> Changed since v5:
>   - Rebase on top of most recent QEMU.
> Changed since v6:
>   - Add Reviewed-by from Dapeng Mi.
> 
>  target/i386/kvm/kvm.c | 61 +++++++++++++++++++++++++++++++------------
>  1 file changed, 44 insertions(+), 17 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 3b803c662d..338b9558e4 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -187,6 +187,10 @@ static int has_triple_fault_event;
>  static bool has_msr_mcg_ext_ctl;
>  
>  static int pmu_cap;
> +/*
> + * Read from /sys/module/kvm/parameters/enable_pmu.
> + */
> +static bool kvm_pmu_disabled;
>  
>  static struct kvm_cpuid2 *cpuid_cache;
>  static struct kvm_cpuid2 *hv_cpuid_cache;
> @@ -2068,23 +2072,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      if (first) {
>          first = false;
>  
> -        /*
> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
> -         * disable PMUs; however, QEMU has been providing PMU property per
> -         * CPU since v1.6. In order to accommodate both, have to configure
> -         * the VM-level capability here.
> -         *
> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
> -         * behavior on Intel platform because current "pmu" property works
> -         * as expected.
> -         */
> -        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> -                                    KVM_PMU_CAP_DISABLE);
> -            if (ret < 0) {
> -                error_setg_errno(errp, -ret,
> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
> -                return ret;
> +        if (X86_CPU(cpu)->enable_pmu) {
> +            if (kvm_pmu_disabled) {
> +                warn_report("Failed to enable PMU since "
> +                            "KVM's enable_pmu parameter is disabled");

I'm wondering about the intended value of this patch?

If enable_pmu is true in QEMU but the corresponding KVM parameter is
false, then KVM_GET_SUPPORTED_CPUID or KVM_GET_MSRS should be able to
tell that the PMU feature is not supported by host.

The logic implemented in this patch seems somewhat redundant.

Additionally, in this scenario — where the user intends to enable a
feature but the host cannot support it — normally no warning is emitted
by QEMU.

> +            }
> +        } else {
> +            /*
> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
> +             * disable PMUs; however, QEMU has been providing PMU property per
> +             * CPU since v1.6. In order to accommodate both, have to configure
> +             * the VM-level capability here.
> +             *
> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
> +             * behavior on Intel platform because current "pmu" property works
> +             * as expected.
> +             */
> +            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                        KVM_PMU_CAP_DISABLE);
> +                if (ret < 0) {
> +                    error_setg_errno(errp, -ret,
> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
> +                    return ret;
> +                }
>              }
>          }
>      }
> @@ -3302,6 +3313,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      int ret;
>      struct utsname utsname;
>      Error *local_err = NULL;
> +    g_autofree char *kvm_enable_pmu;
>  
>      /*
>       * Initialize confidential guest (SEV/TDX) context, if required
> @@ -3437,6 +3449,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>      pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>  
> +    /*
> +     * The enable_pmu parameter is introduced since Linux v5.17,
> +     * give a chance to provide more information about vPMU
> +     * enablement.
> +     *
> +     * The kvm.enable_pmu's permission is 0444. It does not change
> +     * until a reload of the KVM module.
> +     */
> +    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
> +                            &kvm_enable_pmu, NULL, NULL)) {
> +        if (*kvm_enable_pmu == 'N') {
> +            kvm_pmu_disabled = true;

It’s generally better not to rely on KVM’s internal implementation
unless really necessary.

For example, in the new mediated vPMU framework, even if the KVM module
parameter enable_pmu is set, the per-guest kvm->arch.enable_pmu could
still be cleared.

In such a case, the logic here might not be correct.

> +        }
> +    }
> +
>      return 0;
>  }
>  


