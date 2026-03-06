Return-Path: <kvm+bounces-72987-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMKfLldnqmlOQwEAu9opvQ
	(envelope-from <kvm+bounces-72987-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:34:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACA521BBF0
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B36E13031F2F
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 05:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A413624B8;
	Fri,  6 Mar 2026 05:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a6gMibAP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2399426F29C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 05:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772775247; cv=none; b=j7ATlpXmEMlz9H5Ytz6Hfw/sL0IiFRCD9RwHEADfOomZmWnoWLbtLz9Cc/t3QXWPJkXRcPrIPPBxSexVAEIhJGzHlFfDtr8BcF7PrN72g5xZ5yoZzE6ti1G+k4DzsEpaYgUfqkAgCgjLLB1S14IL0zl1Q4EGyxX1Jlvc6CB2Lio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772775247; c=relaxed/simple;
	bh=eddxyeWVkUyW0AcN7Wf7qdFoHBwu0Mn0ZNswE1Ip1Kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvemqJSaytnGMTsPFI/fE1NDjj5eltCw+8BSHAbxtq7C6MD6OLTJyvyTtJLUBg1tvkmZPVoxsPbqhxOcjsM6z6OUCNn/+G8hevI1ymAYn6jvB+K55pvbBoExTplclPJm1D5vnRzHVMJmPe8A0OEWoN72soe3QelaX+MuzqMQpaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a6gMibAP; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772775247; x=1804311247;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eddxyeWVkUyW0AcN7Wf7qdFoHBwu0Mn0ZNswE1Ip1Kc=;
  b=a6gMibAP6ToAgkQOVJjYea+FHdcJ9Dz7eKS3tmew+HHDdGRS7nGfNVvk
   dYEpgGQt3AS6wAjRHS6EWMnpOP7A3/g3R7gsHYtbfZhpoWchrz+WL79o2
   zmMhdUlAneFcRzTgpBksi3jIEsAzmkocwmkjxGUNQWjUtl+tmdskGDLO4
   mzCY0Cnb39m91JCEGnVtU0iFyx+BoLys8ns11T0MdxbjkpCBaNWp2IcCg
   9q0U8kzDXgPRxx9srwUatazcHdNlNYMonmy7kEzd2STEx0k8sYnovxk0f
   NmqHDc/iQ9saAHaMVhxNXxNhAVESeZczTDNsAp9dVbYDUu9a7rLWRRX6X
   g==;
X-CSE-ConnectionGUID: uCnmjb52SLy+qgvKF3ka7A==
X-CSE-MsgGUID: /zCnWu80RG6RCYRZ10czgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="91269236"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="91269236"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:34:06 -0800
X-CSE-ConnectionGUID: tCSWuHajQISJOM7eQNBNqA==
X-CSE-MsgGUID: YcADNc1KT9GnB0ZdlfW55w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="215630782"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:34:03 -0800
Message-ID: <9d74db3d-49d0-493f-9c68-da5d97f9c45e@linux.intel.com>
Date: Fri, 6 Mar 2026 13:34:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 12/13] target/i386: Clean up Intel Debug Store feature
 dependencies
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-13-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-13-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5ACA521BBF0
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
	TAGGED_FROM(0.00)[bounces-72987-lists,kvm=lfdr.de];
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

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

On 3/5/2026 2:07 AM, Zide Chen wrote:
> - 64-bit DS Area (CPUID.01H:ECX[2]) depends on DS (CPUID.01H:EDX[21]).
> - When PMU is disabled, Debug Store must not be exposed to the guest,
>   which implicitly disables legacy DS-based PEBS.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V3:
> - Update title to be more accurate.
> - Make DTES64 depend on DS.
> - Mark MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL in previous patch.
> - Clean up the commit message.
>
> V2: New patch.
> ---
>  target/i386/cpu.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2e1dea65d708..3ff9f76cf7da 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1899,6 +1899,10 @@ static FeatureDep feature_dependencies[] = {
>          .from = { FEAT_1_ECX,             CPUID_EXT_PDCM },
>          .to = { FEAT_PERF_CAPABILITIES,       ~0ull },
>      },
> +    {
> +        .from = { FEAT_1_EDX,               CPUID_DTS},
> +        .to = { FEAT_1_ECX,                 CPUID_EXT_DTES64},
> +    },
>      {
>          .from = { FEAT_1_ECX,               CPUID_EXT_VMX },
>          .to = { FEAT_VMX_PROCBASED_CTLS,    ~0ull },
> @@ -9471,6 +9475,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>              env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
>          }
>  
> +        env->features[FEAT_1_EDX] &= ~CPUID_DTS;
>          env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
>      }
>  

