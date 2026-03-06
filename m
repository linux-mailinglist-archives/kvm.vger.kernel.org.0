Return-Path: <kvm+bounces-72978-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wByyNF9HqmnxOQEAu9opvQ
	(envelope-from <kvm+bounces-72978-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:17:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 722A721AFAC
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 85787303A08B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 03:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A0834A788;
	Fri,  6 Mar 2026 03:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IwYHJx4X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA3D229B32
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 03:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772767032; cv=none; b=PP0aHVAuwUh7sdEF0GDkoiznh8gi6jmTN+AlVISY2TsTCGNyRKRzo5BpYxswSF44lS0nyXBupNLXgfRhs1R6QrzNWu87Jdh30Lz3gt/2i4lT8TY0uz8jWRvJvj2JblP61HYp6KOmKEOY6m+7Vf/joGahNWQUGgCVIswsWO44QRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772767032; c=relaxed/simple;
	bh=PtFCYUhxjLP3lWKnlSJfivIA+ShJwsAIokwzmLGIR/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Thxa728Wlpw1nUzHrrqWbP3dsgWWmNm3v9I/RHvpr9u2Gmf4yteH5gaYOd38oNs6OdeE//lBP2/2w2W9424+3oU4x/0faPVGGYaj7W2RuPWX0eVAL4fT0PRYKFLfbZ0i/21trUsi1A6iW/TtryR+mmlIcIIPNfmrTnmZl4txSps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IwYHJx4X; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772767031; x=1804303031;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PtFCYUhxjLP3lWKnlSJfivIA+ShJwsAIokwzmLGIR/E=;
  b=IwYHJx4XHitUKat1/mYY3ss+BtW73Vbz/e0ZUlsOZcheXXUDJmH3RQEm
   U63WTtxB3BfUcFAzavhQ2SH3HZ1/sBC+ixec+QX9yL8zNpig5CV3lfcBw
   HPRlGZ6BRfM3WAV6pdUjxnsp0sd0/KEnrlcVeI+2lzZXpcZjoRMI77s8M
   ydBr60qby2ITGNcD+uBjFo5AuY5IlgGUgwNesEMAzDpHhwWqsYPIya6Zq
   DIE2jy0/WcEKBJOR51kyV18d13P6TFlWfC3DnVoZdbkeqoibqPodzCtMQ
   YKZhQ6OCjRm3sfmjr40U6cgohSArwDL78jA6Cdg+8V2NyXS/n5ZfnQ3Kt
   A==;
X-CSE-ConnectionGUID: PEMT107jRp+3ENdeikLTNg==
X-CSE-MsgGUID: dikh7MWOR/qlrQL1ntRJ+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77741898"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="77741898"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:17:10 -0800
X-CSE-ConnectionGUID: D/nNeNVWT3iKaYkAgKizwA==
X-CSE-MsgGUID: Nh57sl0TSoCm3v9lHDzL4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="214835091"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:17:07 -0800
Message-ID: <b6fce45c-0c81-4ac5-b469-f7b8ca50d7ff@linux.intel.com>
Date: Fri, 6 Mar 2026 11:17:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 07/13] target/i386: Add get/set/migrate support for
 legacy PEBS MSRs
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-8-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-8-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 722A721AFAC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72978-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email]
X-Rspamd-Action: no action

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

On 3/5/2026 2:07 AM, Zide Chen wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>
> The legacy DS-based PEBS relies on IA32_DS_AREA and IA32_PEBS_ENABLE
> to take snapshots of a subset of the machine registers into the Intel
> Debug-Store.
>
> Adaptive PEBS introduces MSR_PEBS_DATA_CFG to be able to capture only
> the data of interest, which is enumerated via bit 14 (PEBS_BASELINE)
> of IA32_PERF_CAPABILITIES.
>
> QEMU must save, restore and migrate these MSRs when legacy PEBS is
> enabled.  Though the availability of these MSRs may not be the same,
> it's still valid to put them in the same vmstate subsection for
> implementation simplicity.
>
> Originally-by: Luwei Kang <luwei.kang@intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Co-developed-by: Zide Chen <zide.chen@intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V3:
> - Add the missing Originally-by tag to credit Luwei.
> - Fix the vmstate name of msr_ds_pebs.
> - Fix the criteria for determining availability of IA32_PEBS_ENABLE
>   and MSR_PEBS_DATA_CFG.
> - Change title to cover all aspects of what this patch does.
> - Re-work the commit messages.
> ---
>  target/i386/cpu.h     | 10 ++++++++++
>  target/i386/kvm/kvm.c | 29 +++++++++++++++++++++++++++++
>  target/i386/machine.c | 27 ++++++++++++++++++++++++++-
>  3 files changed, 65 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 7c241a20420c..3a10f3242329 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -422,6 +422,7 @@ typedef enum X86Seg {
>  #define MSR_IA32_PERF_CAPABILITIES      0x345
>  #define PERF_CAP_LBR_FMT                0x3f
>  #define PERF_CAP_FULL_WRITE             (1U << 13)
> +#define PERF_CAP_PEBS_BASELINE          (1U << 14)
>  
>  #define MSR_IA32_TSX_CTRL		0x122
>  #define MSR_IA32_TSCDEADLINE            0x6e0
> @@ -479,6 +480,7 @@ typedef enum X86Seg {
>  /* Indicates good rep/movs microcode on some processors: */
>  #define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)
>  #define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
> +#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL  (1ULL << 12)
>  #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
>  #define MSR_IA32_MISC_ENABLE_DEFAULT    (MSR_IA32_MISC_ENABLE_FASTSTRING     | \
>                                           MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
> @@ -514,6 +516,11 @@ typedef enum X86Seg {
>  #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS       0xc0000300
>  #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL          0xc0000301
>  
> +/* Legacy DS based PEBS MSRs */
> +#define MSR_IA32_PEBS_ENABLE            0x3f1
> +#define MSR_PEBS_DATA_CFG               0x3f2
> +#define MSR_IA32_DS_AREA                0x600
> +
>  #define MSR_K7_EVNTSEL0                 0xc0010000
>  #define MSR_K7_PERFCTR0                 0xc0010004
>  #define MSR_F15H_PERF_CTL0              0xc0010200
> @@ -2099,6 +2106,9 @@ typedef struct CPUArchState {
>      uint64_t msr_fixed_ctr_ctrl;
>      uint64_t msr_global_ctrl;
>      uint64_t msr_global_status;
> +    uint64_t msr_ds_area;
> +    uint64_t msr_pebs_data_cfg;
> +    uint64_t msr_pebs_enable;
>      uint64_t msr_fixed_counters[MAX_FIXED_COUNTERS];
>      uint64_t msr_gp_counters[MAX_GP_COUNTERS];
>      uint64_t msr_gp_evtsel[MAX_GP_COUNTERS];
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4ba54151320f..8c4564bcbb9e 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4280,6 +4280,16 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>              }
>  
> +            if (env->features[FEAT_1_EDX] & CPUID_DTS) {
> +                kvm_msr_entry_add(cpu, MSR_IA32_DS_AREA, env->msr_ds_area);
> +            }
> +            if (!(env->msr_ia32_misc_enable & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL)) {
> +                kvm_msr_entry_add(cpu, MSR_IA32_PEBS_ENABLE, env->msr_pebs_enable);
> +            }
> +            if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_PEBS_BASELINE) {
> +                kvm_msr_entry_add(cpu, MSR_PEBS_DATA_CFG, env->msr_pebs_data_cfg);
> +            }
> +
>              /* Set the counter values.  */
>              for (i = 0; i < num_pmu_fixed_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
> @@ -4900,6 +4910,16 @@ static int kvm_get_msrs(X86CPU *cpu)
>              kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
>              kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
>          }
> +
> +        if (env->features[FEAT_1_EDX] & CPUID_DTS) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_DS_AREA, 0);
> +        }
> +        if (!(env->msr_ia32_misc_enable & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL)) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_PEBS_ENABLE, 0);
> +        }
> +        if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_PEBS_BASELINE) {
> +            kvm_msr_entry_add(cpu, MSR_PEBS_DATA_CFG, 0);
> +        }
>      }
>  
>      if (env->mcg_cap) {
> @@ -5241,6 +5261,15 @@ static int kvm_get_msrs(X86CPU *cpu)
>                  env->msr_gp_evtsel[index] = msrs[i].data;
>              }
>              break;
> +        case MSR_IA32_DS_AREA:
> +            env->msr_ds_area = msrs[i].data;
> +            break;
> +        case MSR_PEBS_DATA_CFG:
> +            env->msr_pebs_data_cfg = msrs[i].data;
> +            break;
> +        case MSR_IA32_PEBS_ENABLE:
> +            env->msr_pebs_enable = msrs[i].data;
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 7d08a05835fc..5cff5d5a9db5 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -659,6 +659,27 @@ static const VMStateDescription vmstate_msr_ia32_feature_control = {
>      }
>  };
>  
> +static bool ds_pebs_enabled(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return (env->msr_ds_area || env->msr_pebs_enable ||
> +            env->msr_pebs_data_cfg);
> +}
> +
> +static const VMStateDescription vmstate_msr_ds_pebs = {
> +    .name = "cpu/msr_architectural_pmu/msr_ds_pebs",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = ds_pebs_enabled,
> +    .fields = (const VMStateField[]){
> +        VMSTATE_UINT64(env.msr_ds_area, X86CPU),
> +        VMSTATE_UINT64(env.msr_pebs_data_cfg, X86CPU),
> +        VMSTATE_UINT64(env.msr_pebs_enable, X86CPU),
> +        VMSTATE_END_OF_LIST()}
> +};
> +
>  static bool pmu_enable_needed(void *opaque)
>  {
>      X86CPU *cpu = opaque;
> @@ -697,7 +718,11 @@ static const VMStateDescription vmstate_msr_architectural_pmu = {
>          VMSTATE_UINT64_ARRAY(env.msr_gp_counters, X86CPU, MAX_GP_COUNTERS),
>          VMSTATE_UINT64_ARRAY(env.msr_gp_evtsel, X86CPU, MAX_GP_COUNTERS),
>          VMSTATE_END_OF_LIST()
> -    }
> +    },
> +    .subsections = (const VMStateDescription * const []) {
> +        &vmstate_msr_ds_pebs,
> +        NULL,
> +    },
>  };
>  
>  static bool mpx_needed(void *opaque)

