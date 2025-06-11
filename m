Return-Path: <kvm+bounces-48954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DBDCAD4853
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5457217ADE3
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895DC170A26;
	Wed, 11 Jun 2025 02:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HWy06SWF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41136FBF;
	Wed, 11 Jun 2025 02:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607503; cv=none; b=qlt/iZItzTFH+uRJKl4SIe2v1j5DRi9JQrv0ZvQhpP3ERfJ/hIxnvennKh+Uc6nPiHoleK5UcWXIo3sYO2N9x2+vGOlXSdVAGo4/XPUCBW6tiSutvdxkZk1+jqMKk/OnZ26YNvrzTjFBiuUMPUzQyUuzVUdCvUK/ipdEkQYAyoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607503; c=relaxed/simple;
	bh=QkjN0yrqWqSyvn3N877w5lr2kBMnRiRybGvkYTQ55fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iHpSoqd3QDPOprUaVUxiMUKEmz7GSyqEO4SlmcrIzZvJ4KE6j+hZXeUlRtB+QqGOcf1pkjKwQcrIgPzny0ym5bFDG0Lm5kflNE+fFgoozqcmOD6jxOOPng8VJLdwIAKyXc/WYyoeahMmP9kTUa1pI46R4z5WJ+I0awnLQvF7KpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HWy06SWF; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749607502; x=1781143502;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QkjN0yrqWqSyvn3N877w5lr2kBMnRiRybGvkYTQ55fk=;
  b=HWy06SWF14+4zsksv2ZU8JXMqgDPZC4GibK6qd3qqZ0ynxGGieE7/mGj
   1WNUpZ/LCX0qRanz/cuTb9y+0lvHPWeabiJsDJy8vYwFoMnKulYK0BqIo
   k32LIQaThCSU1xRY79DWe/uE4l8FI1gVeKwlG5KjNf8vajqlqFlDYobqM
   pvJXkroSqnNU12SebVdtrQSkRenSQud7aqrBmbsiIOtf2dr5HUl70+Bmp
   6ORpW8rgDj9Av9uzi+08/0YVHAH5MluAwiI+mOogprzfXNPw2soTy8W/3
   lnYJxAVt/VABkC+GJO28yFU3LeJYs/YSCJqf+vmuMj2uaax5uscqW63nv
   Q==;
X-CSE-ConnectionGUID: oHN/GLZ5R8alWrnJ37AQjQ==
X-CSE-MsgGUID: 3xySpXq3TzSorHfCl3JA3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51616444"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51616444"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:05:01 -0700
X-CSE-ConnectionGUID: YQndixjfTtyajYVuEuJH6w==
X-CSE-MsgGUID: 4Xj4m9ZcSA+igvZcXs8l4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="150861724"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:04:58 -0700
Message-ID: <e2e7f3d0-1077-44c6-8a1d-add4e1640d32@linux.intel.com>
Date: Wed, 11 Jun 2025 10:04:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
 <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
 <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 12:54 AM, Edgecombe, Rick P wrote:
> On Tue, 2025-06-10 at 09:50 -0700, Rick Edgecombe wrote:
>> Why do we need an opt-in interface instead of a way to expose which exit's are
>> supported by KVM? I would think the need for a TDVMCALL opt-in interface would
>> only come up if there was a bad guest that was making TDVMCALLs that it did not
>> see in GetTdVmCallInfo.

The opt-in interface can eliminate some requirements for userspace.
E.g, for GetQuote, this patch set enforces userspace to handle the exit reason
due to GetQuote as the initial support, because KVM doesn't know if userspace
is able to handle the exit reason or not without userspace's opt-in, unless
it's handled by default in userspace.

>>   So that we would actually require an opt-in is not
>> guaranteed.
>>
>> Another consideration could be how to handle GetQuote for an eventual TDVMCALL
>> opt-in interface, should it be needed. The problem would be GetQuote would be
>> opted in by default and make the interface weird. But we may not want to have a
>> TDVMCall specific opt-in interface. There could be other TDX behaviors that we
>> need to opt-in around. In which case the opt-in interface could be more generic,
>> and by implementing the TDVMCall opt-in interface ahead of time we would end up
>> with two opt-in interfaces instead of one.

Maybe we can use a TDX specific opt-in interface instead of TDVMCALL specific
interface.
But not sure we should add it now or later.

>>
>> So how about just adding a field to struct kvm_tdx_capabilities to describe the
>> KVM TDVMcalls? Or some other place? But don't invent an opt-in interface
>> until/if we need it.
> Oh, and there already is a hypercall exit opt-in interface, so
> KVM_CAP_TDX_USER_EXIT_TDVMCALL would overlap with it, right?
Not sure what does "overlap" mean here.

They have different namespaces, so they don't impact each other.

Or did you mean it's a duplication both having KVM_CAP_EXIT_HYPERCALL and
KVM_CAP_TDX_USER_EXIT_TDVMCALL?

