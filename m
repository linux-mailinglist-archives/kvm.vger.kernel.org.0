Return-Path: <kvm+bounces-72980-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GL50ClRJqmlkOgEAu9opvQ
	(envelope-from <kvm+bounces-72980-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:26:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8432521B127
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 04:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32058302837C
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 03:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67B336BCE9;
	Fri,  6 Mar 2026 03:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YBOeJVhM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B610E33DECD
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 03:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772767556; cv=none; b=MlxABYo+6DkzdW8HHwGKV9afQ3JsIiyCiXmh234B4Gpv1gNannsKxQ2FrEOs9h62YSA2bcJ+Lv1cs64GYiZ2ab2E9BHsidM7C8oXduKDhk+MoII0OZDrVs2KpRQsG0GKRBuCn5FBLySKnZQ6KKY/S04p6jGHLCGVdQz0qauTqUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772767556; c=relaxed/simple;
	bh=Yc6hFHwiTmrxSF+/qL9x+vyoSiqgmClUy+bV4BuDjAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5bCREmSIFqvjJ44kMxety7hwA6P6a9fwun4I5+3b3flQgsGjs3QdPCBhebwvPjt8qtqSa3C/xgQx0Q3OsI+JWmXsyHr1tijQ5fhD2u7Qyoi7GmJrb0/1V7+rWgFhp1uyLkGc2GryG0F7qI9jib3TOBnOEkF1jf09sybJrrYYow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YBOeJVhM; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772767554; x=1804303554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yc6hFHwiTmrxSF+/qL9x+vyoSiqgmClUy+bV4BuDjAM=;
  b=YBOeJVhMBZVyesltzui039gsSCynJE1hojmjE2vIk/pQUpJpav8gnFgM
   Hu9a7kYQTTC5Fx6ZicB8x1qKE2tS9tRxDeLWNrmVGt6rbG1qwsIfwBQg+
   8qRTzQQsfstzbMO+Rk33qCmXY17iX5o9xgfBLdFzn3X9IDcy+R9jt8Kol
   /GJYwdnWd6AYaf7xqy5vq0dmksLGmdtW/Sv2TGbiwYPgLXtx4IOO867Wk
   UH0W0eurAZV1sTiU8JHyRmSposvbTe8sL4sfiNuw0PyDJvdE1/GGCWRje
   ZDx8ernzwfOeTbcuqrnCB6h2izI33cZGxACTXUBUBGBEzx6eVGkYFcqud
   w==;
X-CSE-ConnectionGUID: k0LmTxTnQNycsoWvSAbc9A==
X-CSE-MsgGUID: h9FEQxxTRCaDL1EOcMyyIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="74060581"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="74060581"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:25:54 -0800
X-CSE-ConnectionGUID: meFLeV7VTEq4D2v560TKhQ==
X-CSE-MsgGUID: TBINicLMQL6nvWWjrW4UEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="216053631"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.241.147]) ([10.124.241.147])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 19:25:51 -0800
Message-ID: <f1fb6e47-b115-45a0-b212-0542b00c33ec@linux.intel.com>
Date: Fri, 6 Mar 2026 11:25:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 08/13] target/i386: Make some PEBS features
 user-visible
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
 <20260304180713.360471-9-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260304180713.360471-9-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8432521B127
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72980-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.intel.com:mid,intel.com:dkim,intel.com:email]
X-Rspamd-Action: no action

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

On 3/5/2026 2:07 AM, Zide Chen wrote:
> Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
> the corresponding bits user-visible CPU feature knobs, allowing them to
> be explicitly enabled or disabled via -cpu +/-<feature>.
>
> Once named, these bits become part of the guest CPU configuration
> contract.  If a VM is configured with such a feature enabled, migration
> to a destination that does not support the feature may fail, as the
> destination cannot honor the guest-visible CPU model.
>
> The PEBS_FMT bits are not exposed, as target/i386 currently does not
> support multi-bit CPU properties.
>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V2:
> - Add the missing comma after "pebs-arch-reg".
> - Simplify the PEBS_FMT description in the commit message.
> ---
>  target/i386/cpu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index a69c3108f64b..89691fba45e1 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1618,10 +1618,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .type = MSR_FEATURE_WORD,
>          .feat_names = {
>              NULL, NULL, NULL, NULL,
> +            NULL, NULL, "pebs-trap", "pebs-arch-reg",
>              NULL, NULL, NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> -            NULL, "full-width-write", NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> +            NULL, "full-width-write", "pebs-baseline", NULL,
> +            NULL, "pebs-timing-info", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,

