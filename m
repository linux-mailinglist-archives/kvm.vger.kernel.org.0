Return-Path: <kvm+bounces-50737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E3BAE8B15
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 19:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57F3A4A60C8
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834A42EF66E;
	Wed, 25 Jun 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/WuwFND"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464C02EE60D;
	Wed, 25 Jun 2025 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750870631; cv=none; b=CiqGD4+bbpg3yfKS+yxENPtn34OxhBH2THRaeXM792bPYTXOl/igGhWbUCUo1Ll8gFrRG/YhvtP65zxUohwrQGceVqVZrSAaJMlrpVIvNRdxgGl4Bo68CEcQULFrni9Ip3haaROtUVLjkhv+OxXIubO2rq8Qq6asD3VTr43tvQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750870631; c=relaxed/simple;
	bh=vtF75GbZIym3tzqvrk642qAA3zl3CSOPhwdZSIM5njw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vi1wtrQiy5OfL6RhgdNpupIe/EOSoC3aQY97o8BJUGu0XmnKXNUnN3ZUA8oguFCDKhjgdJO3mMwD5UUEIK4dxIYGtbRr2EXxyE/ms6lDeYaEaTAPKLnvN1AmqZ8klsp3r1e4YJlDtK1Viedgpo8ZNUH+2XhvncIm5hC7dI5wqm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/WuwFND; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750870630; x=1782406630;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vtF75GbZIym3tzqvrk642qAA3zl3CSOPhwdZSIM5njw=;
  b=V/WuwFNDYvZKNrUVFVz1i6bDNkGpLWYaWElNee9zeUb7ATgg9pA8YJvd
   tx4QKZ7bUgZRD6LQoqf0VVLYF6MtYoghP1W1QXxfLQayACOIXQuNE4rTT
   whekVjmL6iDsPds6IaIiunvYR86CMFBWns02y6+sspT5Km51EvwINiDGf
   kb2WTDTK/W7iWi/d4Cf+ZHCeKKo4wW+LrBlmOO/feQdwiNMtxPxNsKRHi
   QvTujt51pvrALXXV+ofy/yYsTlYyNrWRUvOgEG4Z+WEAwoM6PUHn5yi7E
   SJ/SGoz3K8GPdnFV41M90+BXR3YKJxr6S0oUexnDAKnsr4WRS1zl5oRIO
   Q==;
X-CSE-ConnectionGUID: Sv5rVXY+RwmZktGkS0MXsw==
X-CSE-MsgGUID: J/Zv3nv8RBq0jx7ssaBuAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="55775588"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="55775588"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:57:09 -0700
X-CSE-ConnectionGUID: +xHjEmsYS2yLU1TNcdgGzw==
X-CSE-MsgGUID: SrWISwehRIGlH1i8YeM6wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="156537623"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.244]) ([10.125.108.244])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:57:08 -0700
Message-ID: <2c8075f0-2817-4895-a509-bcf1a0771bff@intel.com>
Date: Wed, 25 Jun 2025 09:57:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, pbonzini@redhat.com, seanjc@google.com,
 Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 Vishal Annapurve <vannapurve@google.com>, rick.p.edgecombe@intel.com
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-3-adrian.hunter@intel.com>
 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
 <8f05cd1c-74cf-4370-a39c-8e06cdf2c921@intel.com>
 <6de76911-5007-4170-bf74-e1d045c68465@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <6de76911-5007-4170-bf74-e1d045c68465@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 09:42, Adrian Hunter wrote:
> On 25/06/2025 19:31, Dave Hansen wrote:
>> On 6/25/25 09:25, Adrian Hunter wrote:
>>>> IIUC, even if movdir64b stores contents on hwpoisoned pages, it's not
>>>> going to cause any trouble.
>>> No.  PageHWPoison(page) means the page should not be touched.  It must
>>> be freed back to the allocator where it will never be allocated again.
>>
>> What's the end-user-visible effect if the page is touched in this
>> specific function in this specific way (with movdir64b)?
>>
>> In other words, what does this patch do for end users?
> 
> We have another patch that clarifies that.  It turns out we need
> to clear pages (MOVDIR64B) only if the platform has the so-called
> partial-write errata X86_BUG_TDX_PW_MCE.
> 
> It was decided to deal with that issue separately, but maybe it
> needs to bundled in the same patch set, now that the discussion
> has moved in that direction?

It sure sounds like it to me.

