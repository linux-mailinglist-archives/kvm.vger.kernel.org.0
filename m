Return-Path: <kvm+bounces-70709-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHsTIa3bimkOOgAAu9opvQ
	(envelope-from <kvm+bounces-70709-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:18:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F40BC117CC9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65A58302A04C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52B5330B10;
	Tue, 10 Feb 2026 07:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8ln3JB0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA879CD
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707696; cv=none; b=lGLkyzomgfRbGdhOM86d26jRX3f61GSScxbD1b7q1AbkCdXTT9WM2lp5yb3qkkpe6onzakn+3s/x1NlfpAlmoFj2t0p9sr8H2hMuxI4rVM3iMsLH6g/wzt/ivjHtXtQ8yLEGMZ2gb2j3KOU1ZQqKGi1pHBZOl5avu7eNs5jTO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707696; c=relaxed/simple;
	bh=skPpdXck19RJFs/p+cWcI0O12SRZOQZ8nvGFWWjcjpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Izr/MnoQwIGcGEsBpdlr5si5QBHXxKd+MYpP2n6G8jf73A4dU2Q89QnNoqX0VvIf5yMQvHlMJsydcf6C8OtdVrfeJGUsVDku4Y23BVyJaWaWluOt/wNUZu+mnk6r2dmdKLSCWC6GAF9bKWJYqm7IsV2v5kezknrawCs0C/eFHF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8ln3JB0; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770707695; x=1802243695;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=skPpdXck19RJFs/p+cWcI0O12SRZOQZ8nvGFWWjcjpY=;
  b=U8ln3JB0WLVj93DKxSvhnTAPMyZPzdyuN/jTblpjByd7IXVd17NTOYaq
   LIN/x1VAuAzTviTahcgpatl6Ppxmb/nYpGkrwDPSGxlZr/qGBlV8ESRSP
   HBZcy5NNqNnmNUKSdyYNXgumEkvEDR1CBLDQFcTZIMtOMN25LPz+Csbzy
   So6x9P0BWYn1gkVD9CJ1YvAoctvhH3Qp7nLo9vQdLYUkQTtCU7h48/jpw
   aIkN2C1P9Qw4APd6InMKY4xlB5s/mi9gNLWVezoHE6AsExceKWngmW1cL
   UXRcYJ/KedHYym/kx+IkqgkUvNPue2NII9Ce/L7P2/lyvkSaAXsXVReWc
   A==;
X-CSE-ConnectionGUID: ro7+4cqSRn2tX3G8e3FivQ==
X-CSE-MsgGUID: uol4i5phRGOBBs34kI0TnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="75454268"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="75454268"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:14:54 -0800
X-CSE-ConnectionGUID: o6f/FJTATqGCLj0+sVZ/VQ==
X-CSE-MsgGUID: l6hIKXY0QM+gnm62VSkaHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216361627"
Received: from qianm-mobl2.ccr.corp.intel.com (HELO [10.238.1.184]) ([10.238.1.184])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:14:53 -0800
Message-ID: <4b0ca0ab-bf5c-427d-bfe9-18aee47572ff@linux.intel.com>
Date: Tue, 10 Feb 2026 15:14:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 09/11] target/i386: Refactor LBR format handling
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-10-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260128231003.268981-10-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,linux.intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70709-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: F40BC117CC9
X-Rspamd-Action: no action


On 1/29/2026 7:09 AM, Zide Chen wrote:
> Detach x86_cpu_pmu_realize() from x86_cpu_realizefn() to keep the latter
> focused and easier to follow.  Introduce a dedicated helper,
> x86_cpu_apply_lbr_pebs_fmt(), in preparation for adding PEBS format
> support without duplicating code.
>
> Convert PERF_CAP_LBR_FMT into separate mask and shift macros to allow
> x86_cpu_apply_lbr_pebs_fmt() to be shared with PEBS format handling.
>
> No functional change intended

Seems a period is missed for above line.

Others look good to me.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V2:
> - New patch.
>
>  target/i386/cpu.c | 94 +++++++++++++++++++++++++++++++----------------
>  target/i386/cpu.h |  3 +-
>  2 files changed, 65 insertions(+), 32 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 09180c718d58..54f04adb0b48 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9781,6 +9781,66 @@ static bool x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu,
>  }
>  #endif
>  
> +static bool x86_cpu_apply_lbr_pebs_fmt(X86CPU *cpu, uint64_t host_perf_cap,
> +                                  uint64_t user_req, bool is_lbr_fmt,
> +                                  Error **errp)
> +{
> +    CPUX86State *env = &cpu->env;
> +    uint64_t mask;
> +    unsigned shift;
> +    unsigned user_fmt;
> +    const char *name;
> +
> +    if (is_lbr_fmt) {
> +        mask = PERF_CAP_LBR_FMT_MASK;
> +        shift = PERF_CAP_LBR_FMT_SHIFT;
> +        name = "lbr";
> +    } else {
> +        return false;
> +    }
> +
> +    if (user_req != -1) {
> +        env->features[FEAT_PERF_CAPABILITIES] &= ~(mask << shift);
> +        env->features[FEAT_PERF_CAPABILITIES] |= (user_req << shift);
> +    }
> +
> +    user_fmt = (env->features[FEAT_PERF_CAPABILITIES] >> shift) & mask;
> +
> +    if (user_fmt) {
> +        unsigned host_fmt = (host_perf_cap >> shift) & mask;
> +
> +        if (!cpu->enable_pmu) {
> +            error_setg(errp, "vPMU: %s is unsupported without pmu=on", name);
> +            return false;
> +        }
> +        if (user_fmt != host_fmt) {
> +            error_setg(errp, "vPMU: the %s-fmt value (0x%x) does not match "
> +                        "the host value (0x%x).",
> +                        name, user_fmt, host_fmt);
> +            return false;
> +        }
> +    }
> +
> +    return true;
> +}
> +
> +static int x86_cpu_pmu_realize(X86CPU *cpu, Error **errp)
> +{
> +    uint64_t host_perf_cap =
> +        x86_cpu_get_supported_feature_word(NULL, FEAT_PERF_CAPABILITIES);
> +
> +    /*
> +     * Override env->features[FEAT_PERF_CAPABILITIES].LBR_FMT
> +     * with user-provided setting.
> +     */
> +    if (!x86_cpu_apply_lbr_pebs_fmt(cpu, host_perf_cap,
> +                                    cpu->lbr_fmt, true, errp)) {
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
>  static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>  {
>      CPUState *cs = CPU(dev);
> @@ -9788,7 +9848,6 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>      X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
>      CPUX86State *env = &cpu->env;
>      Error *local_err = NULL;
> -    unsigned guest_fmt;
>  
>      if (!kvm_enabled())
>          cpu->enable_pmu = false;
> @@ -9824,35 +9883,8 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>          goto out;
>      }
>  
> -    /*
> -     * Override env->features[FEAT_PERF_CAPABILITIES].LBR_FMT
> -     * with user-provided setting.
> -     */
> -    if (cpu->lbr_fmt != -1) {
> -        env->features[FEAT_PERF_CAPABILITIES] &= ~PERF_CAP_LBR_FMT;
> -        env->features[FEAT_PERF_CAPABILITIES] |= cpu->lbr_fmt;
> -    }
> -
> -    /*
> -     * vPMU LBR is supported when 1) KVM is enabled 2) Option pmu=on and
> -     * 3)vPMU LBR format matches that of host setting.
> -     */
> -    guest_fmt = env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_LBR_FMT;
> -    if (guest_fmt) {
> -        uint64_t host_perf_cap =
> -            x86_cpu_get_supported_feature_word(NULL, FEAT_PERF_CAPABILITIES);
> -        unsigned host_lbr_fmt = host_perf_cap & PERF_CAP_LBR_FMT;
> -
> -        if (!cpu->enable_pmu) {
> -            error_setg(errp, "vPMU: LBR is unsupported without pmu=on");
> -            return;
> -        }
> -        if (guest_fmt != host_lbr_fmt) {
> -            error_setg(errp, "vPMU: the lbr-fmt value (0x%x) does not match "
> -                        "the host value (0x%x).",
> -                        guest_fmt, host_lbr_fmt);
> -            return;
> -        }
> +    if (x86_cpu_pmu_realize(cpu, errp)) {
> +        return;
>      }
>  
>      if (x86_cpu_filter_features(cpu, cpu->check_cpuid || cpu->enforce_cpuid)) {
> @@ -10445,7 +10477,7 @@ static const Property x86_cpu_properties[] = {
>  #endif
>      DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
>      DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
> -    DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT),
> +    DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT_MASK),
>  
>      DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
>                         HYPERV_SPINLOCK_NEVER_NOTIFY),
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 3e2222e105bc..aa3c24e0ba13 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -420,7 +420,8 @@ typedef enum X86Seg {
>  #define ARCH_CAP_TSX_CTRL_MSR		(1<<7)
>  
>  #define MSR_IA32_PERF_CAPABILITIES      0x345
> -#define PERF_CAP_LBR_FMT                0x3f
> +#define PERF_CAP_LBR_FMT_MASK           0x3f
> +#define PERF_CAP_LBR_FMT_SHIFT          0x0
>  #define PERF_CAP_FULL_WRITE             (1U << 13)
>  #define PERF_CAP_PEBS_BASELINE          (1U << 14)
>  

