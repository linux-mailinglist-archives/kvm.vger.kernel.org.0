Return-Path: <kvm+bounces-69800-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCuEARhJgGnC5gIAu9opvQ
	(envelope-from <kvm+bounces-69800-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 07:50:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E52BC8F44
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 07:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CB1D630058FA
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 06:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6B530C37B;
	Mon,  2 Feb 2026 06:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KSZQurlV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E9B26ADC;
	Mon,  2 Feb 2026 06:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770014991; cv=none; b=NIeMSr3WlVOH3fJp1yK7ne8nXfBsyoV9x46pz7SV4mY6NKn70tGHKdf58MoM6XAI9xutXZ6EzkG3lGGVYhagtlZbamTPbmwDhdOaCMtNEFy0g+q14Ab7zRtXxTwoeMScLKdtOTndAgBYGgvTo15z472vuwazsasj5mFnCo2iwWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770014991; c=relaxed/simple;
	bh=p6wHUv3nGRgjxVKeJCG4f/1CwrUZUt88QzBgtgugBAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiyrbwYepr/XBdngVlwft6Y5sCX1mdVKnrh2MIe7lldpH3LtetDh7xuaBrylETUxaWW4KXYH30/zDKuaggR/esYne9rDdcBzuBWqBIb/uoKZMGe1zh1s79rdI48kc3iRFC4odd5RwJtWoVbzttRPuSm4w3y1qc0lHch+1Y0cQtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KSZQurlV; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770014988; x=1801550988;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p6wHUv3nGRgjxVKeJCG4f/1CwrUZUt88QzBgtgugBAY=;
  b=KSZQurlVBn/nmp01OKCEXEtvNAxaFfJ8cj6X4s6bcqUMci6vZUnu5O4a
   +QbJUTsvFYCI0CvQq2ifKjNov8s4470+3XjH0XOFZz4Q0mPfyhyJ1JHnV
   OQI0F6WA+gi7DBHSXIFGt60DQKWy3VGwWEgZ0+1jcyrhchOu4S9OaoaiI
   rPzOuzamtcsLyGsJKAhERUhYwyioSGwapjZKUp7qoHVW9hc4GZrzni+Sk
   R8O81fIpEJlmgWoS2Idaf9Ju1MfWBEAX/3lzJ0Ze5r6HQBmihLXqQ2BKo
   e0latkKnX9HEM79plI7+klGla9JddsdlRQzpu/IyieBQ1KPSLRfL3FQdU
   A==;
X-CSE-ConnectionGUID: +tRDIU/zRmG+Rzr+ruYpxQ==
X-CSE-MsgGUID: Qd/3iS1xRAyGfzjxlpHg1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="71332098"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="71332098"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 22:49:48 -0800
X-CSE-ConnectionGUID: REd2b/jSRJKiBRQDU8Pg1w==
X-CSE-MsgGUID: Xv7GgVZ0TTaoscg4z1UF8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="213537167"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa003.jf.intel.com with ESMTP; 01 Feb 2026 22:49:42 -0800
Date: Mon, 2 Feb 2026 14:31:18 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 16/26] x86/virt/seamldr: Shut down the current TDX
 module
Message-ID: <aYBEtqEeUBThuaJr@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-17-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-17-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69800-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: 9E52BC8F44
X-Rspamd-Action: no action

> +static int get_tdx_sys_info_handoff(struct tdx_sys_info_handoff *sysinfo_handoff)
> +{
> +	int ret = 0;
> +	u64 val;
> +
> +	if (tdx_supports_runtime_update(&tdx_sysinfo) &&
> +	    !(ret = read_sys_metadata_field(0x8900000100000000, &val)))
> +		sysinfo_handoff->module_hv = val;
> +
> +	return ret;
> +}
> +
>  static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>  {
>  	int ret = 0;
> @@ -115,6 +127,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>  	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>  	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
>  	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
> +	ret = ret ?: get_tdx_sys_info_handoff(&sysinfo->handoff);

Do all fields in sysinfo_handoff optional or just module_hv, if the
former, is it better:

	if (tdx_supports_runtime_update(&tdx_sysinfo)
		ret = ret ?: get_tdx_sys_info_handoff(&sysinfo->handoff);

>  
>  	return ret;
>  }
> -- 
> 2.47.3
> 

