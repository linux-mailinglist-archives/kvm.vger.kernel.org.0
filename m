Return-Path: <kvm+bounces-30224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 994569B8340
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:21:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D1322810B5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AF91CB502;
	Thu, 31 Oct 2024 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UwNTzx/O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19E347C7;
	Thu, 31 Oct 2024 19:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730402502; cv=none; b=L2bJ/3En7xyqlkijFnHLxpwk3X3W5H3vdkhl6+WppvakC3hezUoL49VHubu8R8KbrhsqEkpbPoq9w3sNAGa9tDGLPfzAhlVupxRk15q5n6ermikiDTedhdPAae05mVNRErkGQu7bqNedaKBYKYxXJUMqZtVfANQ9cyXcO6UkZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730402502; c=relaxed/simple;
	bh=JwqlDQ+7L58U5/0cq+CtWtI4arvDFq1yUmmHNP3l1h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2GkmrHf7A7kym5z2EejUlxO0IBHaISyIKSRq0zqj3DPpUV64XPxNuDxyPVk7nKbVomJAZwVWsKPmp0YQ09SKNStlIpCxw/0iMmF+7OCUWXOU7L8FAqQcc+NG9NzIA4yFT92gt/RlyftNzYsMJRYYCJLNVaDj+GBA6B93jsZxZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UwNTzx/O; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730402500; x=1761938500;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JwqlDQ+7L58U5/0cq+CtWtI4arvDFq1yUmmHNP3l1h8=;
  b=UwNTzx/OLXjml2EFolCceKjOM+mIac0pJpK6aoVZ+8JyuJM+Rel91+DJ
   AwJSX1zrHtihOL+R/m5+jxEhOLGCoezOcYofCoUfRjPBovMYsz/wTePN3
   /UqdMecyEC+3efaL2zsjzb6GOre3CkbjKA37Qpr+XOuQTJHlBZfT6CFsl
   G+Q5bsM/ubxW3zjevjxvCVwrxIEEU1uhKnBIM2wvb8vbQDaWK3j6QrOjx
   v5xTXBf8Z9YpsRvlXgJhxmarXXyRDpYLBe2qA4+5Rfe9t8ydEYVrEo8yh
   s+vXC/JvtWMMXxKlGwq8qNZPt1A3M1kU4icFx3IDSACCDRHxjTWdp/sLv
   Q==;
X-CSE-ConnectionGUID: oolvr/WgTp21ONnjIOSR0g==
X-CSE-MsgGUID: DUpChuD2TIm8mp5CQnKmeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="47639317"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="47639317"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 12:21:40 -0700
X-CSE-ConnectionGUID: jkF4PW2gSZGOODde+mekIA==
X-CSE-MsgGUID: QSV555ArS8SmfpM3S+iOOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="83069517"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 12:21:35 -0700
Message-ID: <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>
Date: Thu, 31 Oct 2024 21:21:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 reinette.chatre@intel.com
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/10/24 21:00, Rick Edgecombe wrote:
> Here is v2 of TDX VM/vCPU creation series. As discussed earlier, non-nits 
> from v1[0] have been applied and it’s ready to hand off to Paolo. A few 
> items remain that may be worth further discussion:
>  - Disable CET/PT in tdx_get_supported_xfam(), as these features haven’t 
>    been been tested.

It seems for Intel PT we have no support for restoring host
state.  IA32_RTIT_* MSR preservation is Init(XFAM(8)) which means
the TDX Module sets the MSR to its RESET value after TD Enty/Exit.
So it seems to me XFAM(8) does need to be disabled until that is
supported.


