Return-Path: <kvm+bounces-32439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CB29D86B5
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33EC2286537
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378891ACDED;
	Mon, 25 Nov 2024 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1lkg7IT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CB61AC44D;
	Mon, 25 Nov 2024 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732542213; cv=none; b=PFYsaESoFx3HSPwe+dbzJ34fKL93/ImLFAW66XQ8LS0RKBPlzwB0yXm3p/dpx7tjAmocAG4LmExGkoHp3xecPi4BMWFVeDmV1IO49ZrJv0GlZ8yJbXQORnKIiFOvXF40ynPGN1eDnqJ+zG6OmsQuBDpi04T1/2f1138gmKIKoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732542213; c=relaxed/simple;
	bh=Q/jcwJelIrMfdXmXtGKSecp7uffVmmF+ktyVhbp+pTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uchsi1Z03Fd0giLHW+GOxaSTBfUbU4MJsiUierNAkzsjmg2u/C7Go4ik16f49po/wrdGYa5cHNSHQMIedi6VxnpOcINv2GPnGoOFA/U2qBlIjlV4PaDhZZOJQqmHtfnwoAlIp+HPc3CvR/YV1vYmzdNKQ7FIHeV4LB5ts+1wYR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1lkg7IT; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732542212; x=1764078212;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q/jcwJelIrMfdXmXtGKSecp7uffVmmF+ktyVhbp+pTo=;
  b=L1lkg7ITg/G1/hkK4tJ52EFae5L4PRIuoLWwBndN8mlmRnOAxAHnBwxx
   yJDYBzi9D2Nhvj5o+TyD/cB8i9qPiQVDlcY3OynyV0WZfOfL8HmOB5RAb
   QErv2pyzjBkASbIL5JwSRRqlOcojTfIIhspF1BxFZ0y/lALrlzabQw6qo
   RsJxA7jijIq6GrUTi8rPZKCpAC/RMuERYHD4g93i9qgwOczEtw8dEG4sG
   /j9hzwDne1SnwRovzdnGxIQU9bJFlxRw89I0IU6F0A00GAUPkxl2/WYtc
   M7Zi8CD2SyW9Q4qlOyuFXFPwGjt1t5BjoOH1s/WgK4rdBYa7qGfkQ4QpB
   g==;
X-CSE-ConnectionGUID: TjvEO7wNT3iZroPzPfsI8g==
X-CSE-MsgGUID: hU5zQsvbRpynvjrnrYugFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32797796"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="32797796"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:43:31 -0800
X-CSE-ConnectionGUID: 7De0ob9FRku2WWnyyuU9TQ==
X-CSE-MsgGUID: VNguQgXyR/6oOOwYBaZJPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="91611695"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:43:26 -0800
Message-ID: <edcc2f0d-8e02-4ec9-8ca3-c2452fcdf8ff@intel.com>
Date: Mon, 25 Nov 2024 15:43:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
 <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "Yang, Weijiang"
 <weijiang.yang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "Huang, Kai" <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-2-adrian.hunter@intel.com>
 <83defc08-c05f-438d-9c64-a46f4112333c@intel.com>
 <018aad4190bc7e8142606dce2d3ff9fad9cf9b4c.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <018aad4190bc7e8142606dce2d3ff9fad9cf9b4c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/11/24 19:29, Edgecombe, Rick P wrote:
> On Fri, 2024-11-22 at 08:26 -0800, Dave Hansen wrote:
>> On 11/21/24 12:14, Adrian Hunter wrote:
>>> +u64 tdh_vp_enter(u64 tdvpr, struct tdx_module_args *args)
>>> +{
>>> +   args->rcx = tdvpr;
>>> +
>>> +   return __seamcall_saved_ret(TDH_VP_ENTER, args);
>>> +}
>>> +EXPORT_SYMBOL_GPL(tdh_vp_enter);
>>
>> I made a similar comment on another series, but it stands here too: the
>> typing of this wrappers really needs a closer look. Passing u64's around
>> everywhere means zero type safety.
>>
>> Type safety is the reason that we have types like pte_t and pgprot_t in
>> mm code even though they're really just longs (most of the time).
>>
>> I'd suggest keeping the tdx_td_page type as long as possible, probably
>> until (for example) the ->rcx assignment, like this:
>>
>>       args->rcx = td_page.pa;
> 
> Any thoughts on the approach here to the type questions?
> 
> https://lore.kernel.org/kvm/20241115202028.1585487-1-rick.p.edgecombe@intel.com/

For tdh_vp_enter() we will just use the same approach for
tdvpr, whatever that ends up being.


