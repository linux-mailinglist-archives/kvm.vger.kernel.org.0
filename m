Return-Path: <kvm+bounces-31428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F449C3B56
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:50:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4508CB23DCB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30927156886;
	Mon, 11 Nov 2024 09:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQTf89N4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3462137747;
	Mon, 11 Nov 2024 09:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318583; cv=none; b=NAwMd5Btls2movv+VFVwt82wu4jdvzjcaVkyVkeadV1FN7pflfwNmfiIlwR4PaymOMZOifp0R+RGMSEmGMl4Fx1kKzQyT3ya4+yEYBqUNrbVGUv7ee012fd3nTs5p8Mo7qwHVM9h+4LUoZAPu6yP43+jCquBCkhOGh+l62nu7EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318583; c=relaxed/simple;
	bh=bFuwQvVDaRobEbDMsM+r1TnG8PeZqFEjybiX/ieA7ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZmTsV91kOGIl2sRifVN42OK8t1QlebtS8304mSzaz9LRcfvwnL+9sShbuh7/QJcE2zuioOVFp6teDKsXz9I4zfVqi6b/nd2qUw+Mjk/dQOk95D9B0YDar5B8/wK2DxcMoBRF+FuJqRruo03Nf+U2aNRUb+KpswiKsK71/ZgOaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQTf89N4; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731318582; x=1762854582;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bFuwQvVDaRobEbDMsM+r1TnG8PeZqFEjybiX/ieA7ao=;
  b=aQTf89N4gTXd85/mrdeShLOH4NaC7G3zO9JoQa5EpRiS4397W4z+WDmZ
   68J5Uaor9sptt5D0lSX1Fvwtb0jokmN8X3WRcNpnxtnUty6FAcVU/rIFA
   BK0t/o7e9VKvpBPY7fepsmZ9Udlvh8d2WOUHp3981hWnLi1wyqVWAQzEa
   S5nrG81l98jbSVyxQfrK86JEngzDMmVKJcrASWHRm3s7RbaOY+JaN24op
   oz2sLsqRvaCHsw47vACcQtTUNCXr1KsUEzYb12rxo2FtCOrTC2zXfN0+n
   v/CQwdtyuMElVDPjeRJRuM4o0dHqu8XwcZ/4oYn04o/zmcTOge576vjIj
   Q==;
X-CSE-ConnectionGUID: ARP5W4r8QBmcGDU76jkWGA==
X-CSE-MsgGUID: 8zUyzvHdQMum0eGRtn15zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11252"; a="34906426"
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="34906426"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:49:42 -0800
X-CSE-ConnectionGUID: 4ak59gGPRAKHqTAWJvIpyg==
X-CSE-MsgGUID: VY60hJLdT1SP3bAb22nJkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117768257"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.68])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 01:49:37 -0800
Date: Mon, 11 Nov 2024 11:49:32 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Message-ID: <ZzHTLO-TM_5_Q7U3@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>

On Thu, Oct 31, 2024 at 09:21:29PM +0200, Adrian Hunter wrote:
> On 30/10/24 21:00, Rick Edgecombe wrote:
> > Here is v2 of TDX VM/vCPU creation series. As discussed earlier, non-nits 
> > from v1[0] have been applied and it’s ready to hand off to Paolo. A few 
> > items remain that may be worth further discussion:
> >  - Disable CET/PT in tdx_get_supported_xfam(), as these features haven’t 
> >    been been tested.
> 
> It seems for Intel PT we have no support for restoring host
> state.  IA32_RTIT_* MSR preservation is Init(XFAM(8)) which means
> the TDX Module sets the MSR to its RESET value after TD Enty/Exit.
> So it seems to me XFAM(8) does need to be disabled until that is
> supported.

So for now, we should remove the PT bit from tdx_get_supported_xfam(),
but can still keep it in tdx_restore_host_xsave_state()?

Then for save/restore, maybe we can just use the pt_guest_enter() and
pt_guest_exit() also for TDX. Some additional checks are needed for
the pt_mode though as the TDX module always clears the state if PT is
enabled. And the PT_MODE_SYSTEM will be missing TDX enter/exit data
but might be otherwise usable.

Regards,

Tony

