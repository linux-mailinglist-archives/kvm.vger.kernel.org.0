Return-Path: <kvm+bounces-23950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E1494FFF5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B41DB21614
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F6513BC3D;
	Tue, 13 Aug 2024 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bmNFWbY4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE0F78C6C;
	Tue, 13 Aug 2024 08:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723538238; cv=none; b=ms7gdw1AtyVEanK+9lqQrD9QPFle7MdTznR8OzvclCQ8bTPTmc/wgdXAPX/k8c5GghFj0gJwETsG+T+W5YIlUEcqP0SgBBImDKv02yX6SyIOb2WTvh29yWX1ElnUk+b5gW5bxoGnsLP82Jh01gpVVCxYI//FV+h/ORBDGvueAmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723538238; c=relaxed/simple;
	bh=fcLXIpcSe4/fgGljFfkeFeXuiNBhULn1uL7282+/yXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lm8QJ7XaZodQWWNGkmkFVN9QzKc63qBTxyoy+226XFa1LPV66s4juVqSnEnDwsJ/vMIFFJgBdSVqju2xiHepnoDCHLEA2KWw3rh07eVRXhfLA0o2vBVLhN4ruml1pjbxLWMGz3E4JhQBpROtimAWhEJVlxsfXZ218ig0dR/OdIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bmNFWbY4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723538236; x=1755074236;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fcLXIpcSe4/fgGljFfkeFeXuiNBhULn1uL7282+/yXc=;
  b=bmNFWbY46zWTUaKFZX5zkNOaX3yRTu9mT/75UgNgPegC+TCIWujdRsT7
   PU2ekliV6FsTaTpOgEHB2Vhl/ra/87ShQ+wX7b4a5AUQl0ff/hM1WHl59
   fosVPttWvsGF+qZQsB9uItgJM6lsUI47xyYYGdnhKBPn2j0iAT+oNNFmd
   mohBTeqDQOodVWuwmyyyWqDIebv25WpkENHpu1O8H2Xy8GiFEMYyT8FAF
   ahzs+EEakrR0VyYi2Rsewgzu/k3xUgIi3vd2/RQd7ne4gJbQ3fpTEUwFl
   5Z6IA+5FoVd52caGbb/53kS1ERKQCoaDx96E2C/NMUbhSRPuRqcxmAaTJ
   A==;
X-CSE-ConnectionGUID: ES35x9/jSPyGPMFsBDyxfg==
X-CSE-MsgGUID: IkfQVaVNQP2+Q5Pq1mRcbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21245439"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21245439"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 01:37:15 -0700
X-CSE-ConnectionGUID: YSCFcy/uSAecIWVepqOzVQ==
X-CSE-MsgGUID: P+1z8rfLS1iqT3SyHba7pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58668512"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 01:37:12 -0700
Message-ID: <528c5307-4006-4122-b333-331084d7b55b@linux.intel.com>
Date: Tue, 13 Aug 2024 16:37:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/25] KVM: TDX: Don't offline the last cpu of one package
 when there's TDX guest
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-17-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240812224820.34826-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Destroying TDX guest requires there's at least one cpu online for each
> package, because reclaiming the TDX KeyID of the guest (as part of the
> teardown process) requires to call some SEAMCALL (on any cpu) on all
> packages.
>
> Do not offline the last cpu of one package when there's any TDX guest
> running, otherwise KVM may not be able to teardown TDX guest resulting
> in leaking of TDX KeyID and other resources like TDX guest control
> structure pages.
>
> Add a tdx_arch_offline_cpu() and call it in kvm_offline_cpu() to provide
> a placeholder for TDX specific check.  The default __weak version simply
> returns 0 (allow to offline) so other ARCHs are not impacted.  Implement
> the x86 version, which calls a new 'kvm_x86_ops::offline_cpu()' callback.
> Implement the TDX version 'offline_cpu()' to prevent the cpu from going
> offline if it is the last cpu on the package.

This part is stale.
Now, it's using TDX's own hotplug state callbacks instead of hooking
into KVM's.

>
[...]
> +
>   static void __do_tdx_cleanup(void)
>   {
>   	/*
> @@ -946,7 +982,7 @@ static int __init __do_tdx_bringup(void)
>   	 */
>   	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
>   					 "kvm/cpu/tdx:online",
> -					 tdx_online_cpu, NULL);
> +					 tdx_online_cpu, tdx_offline_cpu);
>   	if (r < 0)
>   		return r;
>   


