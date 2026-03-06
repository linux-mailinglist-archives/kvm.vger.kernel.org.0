Return-Path: <kvm+bounces-72985-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCV6KuJkqmnnQgEAu9opvQ
	(envelope-from <kvm+bounces-72985-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:23:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 286FA21BB03
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 481CC30364C8
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 05:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC1936D512;
	Fri,  6 Mar 2026 05:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OAbyJk7p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8322ED84A
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 05:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772774618; cv=none; b=emdYMSNE8UlAFlu33ZBwQtfx+0S0XM6Uhxn63XkjJsDC7AK1Dhu2muA3i3k+o2LZEaMuOwhZvSXdA0TiFYSRGsxNSIFHNKkCOs8S/c5trIru37F81F4CsWYpELKs+iiBRFhe0vdYJyuhk53zYW1MxP+mBDhKc9y1b+sNpo8yFBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772774618; c=relaxed/simple;
	bh=0ax+oQaiJNLdZbHr5DGxG6SrjHrdNmxRhayTtiFKdUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p5fdMJbE+5kIFkgjBRPdrMtStDJC2SSavQGujKYCyfuxDh+n0VcsJj8SvK0rCFxALejqCjs9pcKzs9mAizyIgHnOwmuzQvG1cZ3h43R39O7Qb4oxmM2ll51W5t7jL9wZKRMMnuDOFyDQJPlxqZsiPMxkAfOz3reJLzmtI6iWV28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OAbyJk7p; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772774617; x=1804310617;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0ax+oQaiJNLdZbHr5DGxG6SrjHrdNmxRhayTtiFKdUc=;
  b=OAbyJk7pX4aWbZQZE8oDrqhK6Rk5s21KcQpM8d233paIXTy6fvVYjmgH
   phRkLIOqD5DcHLJEBw90oKo+wXs7e0/7NDCkBvqu7zFUjY5TGBAF6yn1a
   vTTOaMlM+vOPqKWYj60Y1uJ4kAhLRb9RXp6QKgmdy8JV09BMQ5W46bFxe
   ISWnMjZABnVpg2jlmZ8cRZIvAqjFvtC50vgXG+QtdbT/pwckkMHbuAo6Q
   GRuaHSPCBB+7p0Bf5B+uu3uz93R0v4Fl+2qBeGnnvOULVfvuzDD1dXMo6
   aZ3idfIgpypsIV3xAC+2MnL2IxFgDa9guCI4NxXa8hPWeCRxEahuj/lBa
   A==;
X-CSE-ConnectionGUID: MgpN50uDShKGOdKAppmzww==
X-CSE-MsgGUID: 8tWEdXWfRveCqTchf+kMYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85227016"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="85227016"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:23:36 -0800
X-CSE-ConnectionGUID: wN8otppCTQqGbCxZ6jpQYw==
X-CSE-MsgGUID: 5X38X1puTrub+C0yV+nrcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="215629134"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:23:33 -0800
Message-ID: <143fcad8-1637-45e9-94e5-5ca3cca499bb@linux.intel.com>
Date: Fri, 6 Mar 2026 13:23:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 11/13] target/i386: Add pebs-fmt CPU option
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-12-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-12-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 286FA21BB03
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
	TAGGED_FROM(0.00)[bounces-72985-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,linux.intel.com:mid]
X-Rspamd-Action: no action


On 3/5/2026 2:07 AM, Zide Chen wrote:
> Similar to lbr-fmt, target/i386 does not support multi-bit CPU
> properties, so the PEBS record format cannot be exposed as a
> user-visible CPU feature.
>
> Add a pebs-fmt option to allow users to specify the PEBS format via the
> command line.  Since the PEBS state is part of the vmstate, this option
> is considered migratable.
>
> We do not support PEBS record format 0.  Although it is a valid format
> on some very old CPUs, it is unlikely to be used in practice.  This
> allows pebs-fmt=0 to be used to explicitly disable PEBS in the case of
> migratable=off.
>
> If PEBS is not enabled, mark it as unavailable in IA32_MISC_ENABLE and
> clear the PEBS-related bits in IA32_PERF_CAPABILITIES.
>
> If migratable=on on PEBS capable host and pmu is enabled:
> - PEBS is disabled if pebs-fmt is not specified or pebs-fmt=0.
> - PEBS is enabled if pebs-fmt is set to the same value as the host.
>
> When migratable=off, the behavior is similar, except that omitting
> the pebs-fmt option does not disable PEBS.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V3:
> - If DS is not available, make this option invalid.
> - If pebs_fmt is 0, mark PEBS unavailable.
> - Move MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL code from [patch v2 11/11] to
>   this patch for tighter logic.
> - Add option usage to commit message.
>
> V2: New patch.
> ---
>  target/i386/cpu.c         | 23 ++++++++++++++++++++++-
>  target/i386/cpu.h         |  7 +++++++
>  target/i386/kvm/kvm-cpu.c |  1 +
>  3 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index d5e00b41fb04..2e1dea65d708 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9170,6 +9170,13 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
>          env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
>      }
>  
> +    if (!(env->features[FEAT_1_EDX] & CPUID_DTS) ||
> +	!(env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_PEBS_FORMAT)) {
> +        /* Mark PEBS unavailable and clear all PEBS related bits. */
> +        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
> +        env->features[FEAT_PERF_CAPABILITIES] &= ~0x34fc0ull;

Better use a combined macro bitmap to clear the PEBS bits instead of a
magic number. It's hard to read and check.


> +    }
> +
>      memset(env->dr, 0, sizeof(env->dr));
>      env->dr[6] = DR6_FIXED_1;
>      env->dr[7] = DR7_FIXED_1;
> @@ -9784,10 +9791,17 @@ static bool x86_cpu_apply_lbr_pebs_fmt(X86CPU *cpu, uint64_t host_perf_cap,
>          shift = PERF_CAP_LBR_FMT_SHIFT;
>          name = "lbr";
>      } else {
> -        return false;
> +        mask = PERF_CAP_PEBS_FMT_MASK;
> +        shift = PERF_CAP_PEBS_FMT_SHIFT;
> +        name = "pebs";
>      }
>  
>      if (user_req != -1) {
> +        if (!is_lbr_fmt && !(env->features[FEAT_1_EDX] & CPUID_DTS)) {
> +            error_setg(errp, "vPMU: %s is unsupported without Debug Store", name);

Better change the name to preciser "ds pebs" since arch-PEBS doesn't depend
on DS. Thanks.


> +            return false;
> +        }
> +
>          env->features[FEAT_PERF_CAPABILITIES] &= ~(mask << shift);
>          env->features[FEAT_PERF_CAPABILITIES] |= (user_req << shift);
>      }
> @@ -9825,6 +9839,11 @@ static int x86_cpu_pmu_realize(X86CPU *cpu, Error **errp)
>          return -EINVAL;
>      }
>  
> +    if (!x86_cpu_apply_lbr_pebs_fmt(cpu, host_perf_cap,
> +                                    cpu->pebs_fmt, false, errp)) {
> +        return -EINVAL;
> +    }
> +
>      return 0;
>  }
>  
> @@ -10291,6 +10310,7 @@ static void x86_cpu_initfn(Object *obj)
>  
>      object_property_add_alias(obj, "hv-apicv", obj, "hv-avic");
>      object_property_add_alias(obj, "lbr_fmt", obj, "lbr-fmt");
> +    object_property_add_alias(obj, "pebs_fmt", obj, "pebs-fmt");
>  
>      if (xcc->model) {
>          x86_cpu_load_model(cpu, xcc->model);
> @@ -10462,6 +10482,7 @@ static const Property x86_cpu_properties[] = {
>      DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
>      DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
>      DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT_MASK),
> +    DEFINE_PROP_UINT64_CHECKMASK("pebs-fmt", X86CPU, pebs_fmt, PERF_CAP_PEBS_FMT_MASK),
>  
>      DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
>                         HYPERV_SPINLOCK_NEVER_NOTIFY),
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index a064bf8ab17e..6a9820c4041a 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -422,6 +422,10 @@ typedef enum X86Seg {
>  #define MSR_IA32_PERF_CAPABILITIES      0x345
>  #define PERF_CAP_LBR_FMT_MASK           0x3f
>  #define PERF_CAP_LBR_FMT_SHIFT          0x0
> +#define PERF_CAP_PEBS_FMT_MASK          0xf
> +#define PERF_CAP_PEBS_FMT_SHIFT         0x8
> +#define PERF_CAP_PEBS_FORMAT            (PERF_CAP_PEBS_FMT_MASK << \
> +                                         PERF_CAP_PEBS_FMT_SHIFT)
>  #define PERF_CAP_FULL_WRITE             (1U << 13)
>  #define PERF_CAP_PEBS_BASELINE          (1U << 14)
>  
> @@ -2410,6 +2414,9 @@ struct ArchCPU {
>       */
>      uint64_t lbr_fmt;
>  
> +    /* PEBS_FMT bits in IA32_PERF_CAPABILITIES MSR. */
> +    uint64_t pebs_fmt;
> +
>      /* LMCE support can be enabled/disabled via cpu option 'lmce=on/off'. It is
>       * disabled by default to avoid breaking migration between QEMU with
>       * different LMCE configurations.
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 1d0047d037c7..60bf3899852a 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -231,6 +231,7 @@ static void kvm_cpu_instance_init(CPUState *cs)
>      }
>  
>      cpu->lbr_fmt = -1;
> +    cpu->pebs_fmt = -1;
>  
>      kvm_cpu_xsave_init();
>  }

