Return-Path: <kvm+bounces-68196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE77D25C2C
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D2AD9303BAB6
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7183B9617;
	Thu, 15 Jan 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfuWaXK+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3273321A95D;
	Thu, 15 Jan 2026 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768494471; cv=none; b=lLsFUNIRG/zZpVsC2JRPCDtxIqXlmRfgMp/Zv2p7wY88A1cev7eCX6dR4HSn8yUojHpDFm47oRH5EdU+2FRwsqCbt/Z4KZvkBV3+aTSYf3msxb6F1gDL7zUe3csPSgT0ETyF17Gf9Ui92kbJuEA537iuWMppY/sIquI/1ILfX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768494471; c=relaxed/simple;
	bh=ysSGL02zB7qDzVyJUo0vs8vAHFNDJiiTIOYk+Ztc1Yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mm3QucTPhgQwPZrq/PWPwJCLuZveA1KeQ1tY/ugt4h2mGScFY7vBFwIqKlz5KEjRHdky50y4n2TnW3TkAXKIqe1mkUHuhgpc6Qa9x992RVHnWFjL7GmUWTP/CaqZpNa6KvVb5+sq3hrveWIcdoODxW5dwZuKj2ydXZ4t11U46yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfuWaXK+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768494470; x=1800030470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ysSGL02zB7qDzVyJUo0vs8vAHFNDJiiTIOYk+Ztc1Yc=;
  b=EfuWaXK+xA2Tq+YF7TzhwCT3wnWU27wsLjit1CrTt2ddOIkr6H+Omu3Z
   oxbHPAiuPviz5CF3Elj2FyeShZ6YzloMLWqGuQXdv8H2sTC3zaFXQkeRF
   bVz39XnLVk+hxk1o/1XAQbZQGjMyNiZsZ0lWGWGIE70pRWILlhif+gU02
   KI29ki/oYMuYZEcRJBnkyEYc/dnLZkukmGdY9XqNPKcUp+Ta5+7CpjPor
   CBzheiFeovu0lpEUr2ybzIIpSXl+dpqXhMMz2nGIVQJvwRDWef2rNem2i
   F2QfTBgcfnyDtL0Bxuz3oXsjtZSs6U9a0si2ZtQ3yyLG5b9UYZQ70ReXc
   g==;
X-CSE-ConnectionGUID: 8Eg5OzH7TF6RiBh94IRlNA==
X-CSE-MsgGUID: RGstYaAJTQWs724+2JUz1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69717561"
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="69717561"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 08:27:44 -0800
X-CSE-ConnectionGUID: HxmnwnQBRWGKcEPf5u5g1Q==
X-CSE-MsgGUID: ZlDj5km8S9uLnh9BxptRUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="210042115"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.111.74]) ([10.125.111.74])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 08:27:44 -0800
Message-ID: <dde77ed7-3fde-4b81-85be-68db82138454@intel.com>
Date: Thu, 15 Jan 2026 08:27:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 stable@vger.kernel.org
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
 <CALMp9eSWwjZ83VQXRSD3ciwHmtaK5_i-941KdiAv9V9eU20B8g@mail.gmail.com>
 <aVxiowGbWNgY2cWD@google.com>
 <CALMp9eToT-af8kntKK2TiFHHUcUQgU25GaaNqq49RZZt2Buffg@mail.gmail.com>
 <9beb7ca4-7bcf-45f1-aefa-f8e6e8122ede@intel.com>
 <43474e30-6a14-4ab1-aa2c-5f079503637d@redhat.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <43474e30-6a14-4ab1-aa2c-5f079503637d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 08:12, Paolo Bonzini wrote:
...
>> I'm _sure_ they discussed tying XFD[i] and XINUSE[i] together and there
>> was a good reason they did not.
> 
> Is there anything that prevents an SMM handler (or more likely, an SMI
> transfer monitor) to do an XSAVE/XRSTOR and destroy tile data?

I think you're saying: let's assume XFD[18]=1 and XINUSE[18]=1 and
there's an SMI. The SMI handler does:

	XSAVE(RFBM=-1, &buf)
	... run some gunk
	XRSTOR(RFBM=-1, &buf)

to try and save everything. But, that XSAVE is subject to this behavior
from the SDM:

	If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state
	component i, the instruction does not generate #NM when XCR0[i]
	= IA32_XFD[i] = 1; instead, it operates as if XINUSE[i] = 0 (and
	the state component was in its initial state)

So 'buf' will end up having XFEATURES[18]=0. The XRSTOR will see
XFEATURES[18]=0 and set feature 18 to its init state, effectively
zapping its contents.

I guess the only thing preventing that in practice is the lack of XSAVE
use in SMM handlers. But I see your point.

