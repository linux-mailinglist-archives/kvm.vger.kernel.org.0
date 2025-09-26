Return-Path: <kvm+bounces-58846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1EEBA273B
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 07:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8C022A3AFD
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 05:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B7B27817F;
	Fri, 26 Sep 2025 05:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YjMUtGfO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFADE1FCFEF;
	Fri, 26 Sep 2025 05:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758865019; cv=none; b=rh0LksvtMVwYYQGxw4PrGh26jRA55NuB6rrFIGe+AhA9gquImt7+7lcXZxpM9VBE55Gx3BzNSKYCBVkTn95XxW953Eo46i+d970G6rTCQOS8Nx79gqeV0JD7s5N90ol3qR4kPsomn+7ZqBc7Cfr7HdAqiU7XD6uB4U6tSIMEfOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758865019; c=relaxed/simple;
	bh=9nb9C7yie/OSQdbh2G7LM3IWi8GLACvnVZn1kIDNYYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j65mOqOrJFDzYWw7RE8KTQhXMxTppTzrFNQLQPguWFekOTl8HXYp2ZhgxCHHxFqazqJO9BCMJsgjZIK7q+D6JnHYkrlSCGdNppOoBDzwSP8Xh2kiA3lXzftctaJHl+6XB6KO0f9fibMrSwFsbJNLy1VNVHxBKgoTLN/Koj+NuCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YjMUtGfO; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758865018; x=1790401018;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9nb9C7yie/OSQdbh2G7LM3IWi8GLACvnVZn1kIDNYYA=;
  b=YjMUtGfOlnyl4yQXWbpZ3puNgRiB9IKt/u/63XqZ6ydqUZyHTQwAzN/i
   Ckqhu+FjALnoLzodwWsVKK4wiEfvyNgwbanpk/JKOZ1JRwiMxmhz9bHQg
   0N3iGKwCk68J6A8RzhinnVfAyqjrk3QkC+WJmsXx1rPdrmz94GhLFez92
   /uFGVTL5kM2e3EMpgOZ3sM2axPS5l36zcF3Njp7ByxAMWO2FSyAJK8RGk
   C5v6/aTq/wWkwKTXXKO1NlvC8ssACbH69W0V9ijZlWp1d4Zk/lq+LEGTh
   iuGnpib3YjBUdmXeSXBKrOx6IHgzwya8T8pMisEDP/xOQpU35bwnjeHh0
   g==;
X-CSE-ConnectionGUID: 93zm3ElRSn2m1t/ZqxNsxA==
X-CSE-MsgGUID: dlHsCd8yT1yXjXo+ESND+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="60403363"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="60403363"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 22:36:57 -0700
X-CSE-ConnectionGUID: 0kxMoV0bQ1aifC21CNIs/Q==
X-CSE-MsgGUID: 8XrxLRCnSFupWmBt/YS6Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="177456482"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 22:36:53 -0700
Message-ID: <c26dd87a-a92a-4a1d-a57a-4c7c8b2aa1fa@linux.intel.com>
Date: Fri, 26 Sep 2025 13:36:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
 <76019bfc-cd06-4a03-9e1e-721cf63637c4@linux.intel.com>
 <ce717a9a5a7539b38b19115e0d3fa11306ddf9c3.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ce717a9a5a7539b38b19115e0d3fa11306ddf9c3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/26/2025 7:09 AM, Edgecombe, Rick P wrote:
> On Tue, 2025-09-23 at 13:49 +0800, Binbin Wu wrote:
>>> +/*
>>> + * SW-defined error codes.
>>> + *
>>> + * Bits 47:40 == 0xFF indicate Reserved status code class that never used
>>> by
>>> + * TDX module.
>>> + */
>>> +#define TDX_ERROR			_BITULL(63)
>>> +#define TDX_NON_RECOVERABLE		_BITULL(62)
>> TDX_ERROR and TDX_NON_RECOVERABLE are defined in TDX spec as the classes of
>> TDX
>> Interface Functions Completion Status.
>>
>> For clarity, is it better to move the two before the "SW-defined error codes"
>> comment?
> This hunk is a direct copy, any reason to change it in this patch?
yeah, it can be done separately.

