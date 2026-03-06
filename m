Return-Path: <kvm+bounces-72988-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGsBCQhoqmlOQwEAu9opvQ
	(envelope-from <kvm+bounces-72988-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:37:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9458021BC13
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F88A3033390
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 05:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704DC36C0BC;
	Fri,  6 Mar 2026 05:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AHcXyvAD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67377345734
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 05:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772775427; cv=none; b=D6O9PiLkHJMfvGdZq4Fds6anjTIsW4xsle9LBvoIe8fC0XxZbi2BxLdV6xR3woGVIvVyo6YMT+CqFeKZSpONKZqsE+A3ZiT9VeKyaxi9qN72TyCULqsTGmOGQOBVKXlmlx9U9fCXGWYs8kfTZ7Bxi+ndlaEdYRRz7fWTRhPfPJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772775427; c=relaxed/simple;
	bh=3j82WyUflnJOrnQUQDQg1X89lw9l2xXyQpwpjg187zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YrMHuuDO0I3ivjjTRXnaskMqZ3RA3zOmwyxlrxEVWSjTnbc6++5ZhKtgXvfoqw4uowVyUP7cUHE4wOmgNNayCLYKS/DxAFd2X0c3sQUOIhaikrsv1OYaU4rwM+3iZzXkwU03rCOqkscmuxabdErtxjv7G2bUbJWuOR8W9xucZhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AHcXyvAD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772775426; x=1804311426;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3j82WyUflnJOrnQUQDQg1X89lw9l2xXyQpwpjg187zw=;
  b=AHcXyvADm1Hrp6sGz8BI7M73f8MbgklHyYdRW3Q4XE0oeu+hb2uV5nZo
   aPcXm3HWz0rcLzqhv8dJo2jSWaV3ygAZI2J6XeA8q4QRF0nZGve78vS4k
   YpMrM4july3bfgboH+bTsKwcEYo78IEr0P8HeYKiSbtPTY3RiI/B4NhQ4
   gOEG1Nb7sfDsJmOG4N5dHh75VV0R0Zm89uBIBDn7cbbeZlW4U3A+mVlzh
   rTS1jtqSyzNPNRBn1EfllsNdl9yWEcTBYNcecrtdTyFS4dzIIS5m3K6J6
   4+Wn1GT9jmWXps647b4hpryP87jXT3KFfG0njBsRloUoDPUsxs+myKzcG
   g==;
X-CSE-ConnectionGUID: mZ3Gf4pcQG+MlgEYptLxTg==
X-CSE-MsgGUID: F118LzvwSMOWwARbt6c5jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85227886"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="85227886"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:37:06 -0800
X-CSE-ConnectionGUID: KtR5zKE6SBKiVqe/2gBfSw==
X-CSE-MsgGUID: 535IJ0eVTqO6PIZxF55elA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="216074971"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:37:03 -0800
Message-ID: <7a09bdbc-750b-4248-80a5-a03341cf5fcc@linux.intel.com>
Date: Fri, 6 Mar 2026 13:37:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 13/13] target/i386: Add Topdown metrics feature support
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-14-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-14-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9458021BC13
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72988-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,linux.intel.com:mid]
X-Rspamd-Action: no action

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

On 3/5/2026 2:07 AM, Zide Chen wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>
> IA32_PERF_CAPABILITIES.PERF_METRICS_AVAILABLE (bit 15) indicates that
> the CPU provides built-in support for TMA L1 metrics through
> the PERF_METRICS MSR.  Expose it as a user-visible CPU feature
> ("perf-metrics"), allowing it to be explicitly enabled or disabled and
> used with migratable guests.
>
> Plumb IA32_PERF_METRICS through the KVM MSR get/put paths to be able
> to save and restore this MSR.
>
> Migrate IA32_PERF_METRICS MSR using a new subsection of
> vmstate_msr_architectural_pmu.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Co-developed-by: Zide Chen <zide.chen@intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V3: New patch
> ---
>  target/i386/cpu.c     |  2 +-
>  target/i386/cpu.h     |  3 +++
>  target/i386/kvm/kvm.c | 10 ++++++++++
>  target/i386/machine.c | 19 +++++++++++++++++++
>  4 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 3ff9f76cf7da..88cfd3529851 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1620,7 +1620,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, "pebs-trap", "pebs-arch-reg",
>              NULL, NULL, NULL, NULL,
> -            NULL, "full-width-write", "pebs-baseline", NULL,
> +            NULL, "full-width-write", "pebs-baseline", "perf-metrics",
>              NULL, "pebs-timing-info", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 6a9820c4041a..5d0ed692ae06 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -428,6 +428,7 @@ typedef enum X86Seg {
>                                           PERF_CAP_PEBS_FMT_SHIFT)
>  #define PERF_CAP_FULL_WRITE             (1U << 13)
>  #define PERF_CAP_PEBS_BASELINE          (1U << 14)
> +#define PERF_CAP_TOPDOWN                (1U << 15)
>  
>  #define MSR_IA32_TSX_CTRL		0x122
>  #define MSR_IA32_TSCDEADLINE            0x6e0
> @@ -514,6 +515,7 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_FIXED_CTR0        0x309
>  #define MSR_CORE_PERF_FIXED_CTR1        0x30a
>  #define MSR_CORE_PERF_FIXED_CTR2        0x30b
> +#define MSR_PERF_METRICS                0x329
>  #define MSR_CORE_PERF_FIXED_CTR_CTRL    0x38d
>  #define MSR_CORE_PERF_GLOBAL_STATUS     0x38e
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
> @@ -2111,6 +2113,7 @@ typedef struct CPUArchState {
>      uint64_t msr_fixed_ctr_ctrl;
>      uint64_t msr_global_ctrl;
>      uint64_t msr_global_status;
> +    uint64_t msr_perf_metrics;
>      uint64_t msr_ds_area;
>      uint64_t msr_pebs_data_cfg;
>      uint64_t msr_pebs_enable;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8c4564bcbb9e..3f533cd65708 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4295,6 +4295,10 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>                                    env->msr_fixed_counters[i]);
>              }
> +            /* SDM: Write IA32_PERF_METRICS after fixed counter 3. */
> +            if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_TOPDOWN) {
> +                    kvm_msr_entry_add(cpu, MSR_PERF_METRICS, env->msr_perf_metrics);
> +            }
>              for (i = 0; i < num_pmu_gp_counters; i++) {
>                  kvm_msr_entry_add(cpu, perf_cntr_base + i,
>                                    env->msr_gp_counters[i]);
> @@ -4868,6 +4872,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
>          }
> +        if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_TOPDOWN) {
> +            kvm_msr_entry_add(cpu, MSR_PERF_METRICS, 0);
> +        }
>          for (i = 0; i < num_pmu_fixed_counters; i++) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>          }
> @@ -5234,6 +5241,9 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
>              env->msr_global_status = msrs[i].data;
>              break;
> +        case MSR_PERF_METRICS:
> +            env->msr_perf_metrics = msrs[i].data;
> +            break;
>          case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:
>              env->msr_fixed_counters[index - MSR_CORE_PERF_FIXED_CTR0] = msrs[i].data;
>              break;
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 5cff5d5a9db5..6b7141cfead7 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -680,6 +680,24 @@ static const VMStateDescription vmstate_msr_ds_pebs = {
>          VMSTATE_END_OF_LIST()}
>  };
>  
> +static bool perf_metrics_enabled(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return !!env->msr_perf_metrics;
> +}
> +
> +static const VMStateDescription vmstate_msr_perf_metrics = {
> +    .name = "cpu/msr_architectural_pmu/msr_perf_metrics",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = perf_metrics_enabled,
> +    .fields = (const VMStateField[]){
> +        VMSTATE_UINT64(env.msr_perf_metrics, X86CPU),
> +        VMSTATE_END_OF_LIST()}
> +};
> +
>  static bool pmu_enable_needed(void *opaque)
>  {
>      X86CPU *cpu = opaque;
> @@ -721,6 +739,7 @@ static const VMStateDescription vmstate_msr_architectural_pmu = {
>      },
>      .subsections = (const VMStateDescription * const []) {
>          &vmstate_msr_ds_pebs,
> +        &vmstate_msr_perf_metrics,
>          NULL,
>      },
>  };

