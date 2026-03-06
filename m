Return-Path: <kvm+bounces-72976-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LWgNtNDqmlxOQEAu9opvQ
	(envelope-from <kvm+bounces-72976-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:02:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 337E521AD38
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1700830265A2
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 03:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580AD2F9DA1;
	Fri,  6 Mar 2026 03:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FwWi/VyG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A112D8364
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 03:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772766154; cv=none; b=mSI6JsWYIHiiJWFs1UMCVjdFzUeEfU2R9UlnJNn5JWWMzxDXmrW5iLiJY9d5cyxsciQoBcfb2mxrTwanU7saXdFotpc2FrwocA5FQwpEMXLNOuWXspH+L18NGpbSQRgVxToWZoiJCVUc6fIiGuyJwLhFRWTXkykH/127z47y+so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772766154; c=relaxed/simple;
	bh=DhvNDxxeIWLb9YuNZGM3wTYZ+ckehia3cilXA5xumY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5X+WaHnSy4CXdlCPjmDl/nbSmZTrY8z9d0G9/13ihktTgIsZ8EfHNnjHMHrBjp06maguwCwJqrFvXhwiU45Xqed2cPjjULBB2si8yEmX77FOJedi/xeGTqpxlvhPQsT7Ikgh/yxCCaBHu5fDkz/sk0JJLHINfqcfKhTvDADrkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FwWi/VyG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772766153; x=1804302153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DhvNDxxeIWLb9YuNZGM3wTYZ+ckehia3cilXA5xumY0=;
  b=FwWi/VyG+mIQKxgnljrFHq1l+q2k15TC/TZvtbVeoKzuyWQ9qz+j8PnZ
   ryZXRMSSVdNAWni2fIwrrzcpJJ4zamD89XIu4n9XrEiqaZj2/7R6x1U79
   8dyfItPE+09XEvnq4BbHx0eapyeo1rTZPgc3TS408OHoyH9X4fsZNHJlY
   diBc9EJk97KdG6y6Fq3s36vKSdL/FRyFt+3HCEv9vPcMGNpVjBMIaG4cx
   3MzTYOiRvwBN+WzZVD+dV1U8rVN019nIYzef2Ng0rcbCbBZhJVHFTEWLn
   /UZFbxJDDvhPLCdTk2y4Q/ttpQy1ycx8S9r9m5MBKgu7LZWK6bfMX76a8
   Q==;
X-CSE-ConnectionGUID: HyaBg9dXSgSI9+OPkfUK+A==
X-CSE-MsgGUID: FOwHDxBrRi6PQoTB+YlX4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84954572"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="84954572"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:02:33 -0800
X-CSE-ConnectionGUID: hV1FhsldRRyy4/47AI7qSA==
X-CSE-MsgGUID: 753ji1UKSjqS6iqFsXsGgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="219015950"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:02:29 -0800
Message-ID: <0fe9efc7-c3b3-4e11-b99e-17c80fe72892@linux.intel.com>
Date: Fri, 6 Mar 2026 11:02:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 04/13] target/i386: Adjust maximum number of PMU
 counters
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-5-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-5-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 337E521AD38
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72976-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.intel.com:mid]
X-Rspamd-Action: no action


On 3/5/2026 2:07 AM, Zide Chen wrote:
> Changing either MAX_GP_COUNTERS or MAX_FIXED_COUNTERS affects the
> VMState layout and therefore requires bumping the migration version
> IDs.  Adjust both limits together to avoid repeated VMState version
> bumps in follow-up patches.
>
> To support full-width writes, QEMU needs to handle the alias MSRs
> starting at 0x4c1.  With the current limits, the alias range can
> extend into MSR_MCG_EXT_CTL (0x4d0).  Reducing MAX_GP_COUNTERS from 18
> to 15 avoids the overlap while still leaving room for future expansion
> beyond current hardware (which supports at most 10 GP counters).
>
> Increase MAX_FIXED_COUNTERS to 7 to support additional fixed counters
> (e.g. Topdown metric events).
>
> With these changes, bump version_id to prevent migration to older
> QEMU, and bump minimum_version_id to prevent migration from older
> QEMU, which could otherwise result in VMState overflows.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
>  target/i386/cpu.h     | 8 ++------
>  target/i386/machine.c | 4 ++--
>  2 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 6d3e70395dbd..23d4ee13abfa 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1749,12 +1749,8 @@ typedef struct {
>  #define CPU_NB_REGS CPU_NB_REGS32
>  #endif
>  
> -#define MAX_FIXED_COUNTERS 3
> -/*
> - * This formula is based on Intel's MSR. The current size also meets AMD's
> - * needs.
> - */
> -#define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
> +#define MAX_FIXED_COUNTERS 7
> +#define MAX_GP_COUNTERS    15

I suppose it's good enough to reduce MAX_GP_COUNTERS to 10. I don't think
there would be 10+ GP counters for Intel platforms in near future. But need
AMD guys to confirm if it's enough for AMD platforms.

Of course, shrinking MAX_GP_COUNTERS to 15 is fine for me as well.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


>  
>  #define NB_OPMASK_REGS 8
>  
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 1125c8a64ec5..7d08a05835fc 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -685,8 +685,8 @@ static bool pmu_enable_needed(void *opaque)
>  
>  static const VMStateDescription vmstate_msr_architectural_pmu = {
>      .name = "cpu/msr_architectural_pmu",
> -    .version_id = 1,
> -    .minimum_version_id = 1,
> +    .version_id = 2,
> +    .minimum_version_id = 2,
>      .needed = pmu_enable_needed,
>      .fields = (const VMStateField[]) {
>          VMSTATE_UINT64(env.msr_fixed_ctr_ctrl, X86CPU),

