Return-Path: <kvm+bounces-68838-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNP3OsOEcWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68838-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:00:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 963B060A1C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F257F441D70
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D7F324B23;
	Thu, 22 Jan 2026 01:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RBbdOv3G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CA921FF2A;
	Thu, 22 Jan 2026 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769046999; cv=none; b=WeFlcsGvVb4UwdP6lu8aduoH1XmvuIWlpF6hnNTH1za0Ag9nergLPQx4+FwMQZvzy0Vi88bRQm+f30M9sImX+lNTa5aNKaLriLtjvfcklkyNBVH6XtA8aWG4WgA//obdJcTwDwgEouIVIbEoDyol2KiSNE5Sd4MuiLr34V/MI9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769046999; c=relaxed/simple;
	bh=K8POTX/EWrtUBQC7e/W+tjYHRymC+sx3FmIKBhfwxJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=njszXKy65XNlsWbgBuGP0T6f/eIyHiJ46p8ztNiNNxK0eCcSI6I4OncJPBtiSdwt3K56R25dmspOEagSPD+9gXsv/3Dk1NjRkwtpIc8i1FcWiViCoC7grI+Sp4P8aRtqR2WXAR2TnteA98gTfeXCnRDs88lhSvef//9CWypJQB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RBbdOv3G; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769046998; x=1800582998;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K8POTX/EWrtUBQC7e/W+tjYHRymC+sx3FmIKBhfwxJE=;
  b=RBbdOv3GH9gadwAWezxxQerr0K9VgSPc0azNXbcqXgIMYbRloX+YDnYI
   BEoxL1/C8LXfitd5nIUO9rcXi1PckS5ghTjpZwSgU707jShkcHxDUe2x4
   9/y6/ZbTt9z8czKk0xWEvAIdtAwb7xtu9MCRi83qOayjRHEIvlTc9BKsl
   G5vaWK4FsbAaNoftYG7ruqDm4u77CRzEPFZ7YrAKL2yjYUbmOUAwW+sHW
   Ln3AGq9JAeMYj+LrkFJHGMPvRJd1pxqLUg4XtPf2AihClMNcMcOENqmjg
   MjKDvAmUguopOMwcnWCq5zI2urEqIfhpxbX7+u9aAf3ml+zvvX5RhBy94
   Q==;
X-CSE-ConnectionGUID: eIKrghMaTaSd1HSacH1bSw==
X-CSE-MsgGUID: L/TUnMneRL2Q/Iy/dCigcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="74146761"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="74146761"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 17:56:37 -0800
X-CSE-ConnectionGUID: Wk5B67w1Tg+yq9WpDLNriw==
X-CSE-MsgGUID: ePIcLA5xRqOUhJ7HSxtT4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="244195330"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 17:56:32 -0800
Message-ID: <c0d27d52-ae86-4a48-a942-980280542985@linux.intel.com>
Date: Thu, 22 Jan 2026 09:56:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org, sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
 <9F630202-905B-43D7-9DBF-6E4551BAF082@zytor.com>
 <B01C8160-4999-43B9-B89C-45913E94DA55@zytor.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <B01C8160-4999-43B9-B89C-45913E94DA55@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68838-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,zytor.com:email,linux.intel.com:mid]
X-Rspamd-Queue-Id: 963B060A1C
X-Rspamd-Action: no action



On 1/22/2026 8:45 AM, Xin Li wrote:
> 
> 
>> On Jan 21, 2026, at 10:14 AM, Xin Li <xin@zytor.com> wrote:
>>
>>
>>
>>> On Jan 20, 2026, at 10:44 PM, Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>
>>>> +#ifdef CONFIG_X86_64
>>>
>>> Nit:
>>>
>>> Is this needed?
>>>
>>> FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, this
>>> path is not reachable.
>>> There should be no compilation issue without #ifdef CONFIG_X86_64 / #endif.
>>>
>>> There are several similar patterns in this patch, using  #ifdef CONFIG_X86_64 / 
>>> #endif or not seems not consistent. E.g. __vmx_vcpu_reset() and init_vmcs()
>>> doesn't check the config, but here does.
>>
>>
>> I tried removing all such #ifdef, and it turned out that I had to keep this
>> per the last round of build checks.
>>
>> Anyway, I will do another build check on x86_32.
>>
> 
> 
> The trouble comes from __this_cpu_ist_top_va():

Oh, right! 
Sorry for the noise.


> 
> arch/x86/kvm/vmx/vmx.c: In function ‘vmx_vcpu_load_vmcs’:
> arch/x86/kvm/vmx/vmx.c:1608:59: error: implicit declaration of function ‘__this_cpu_ist_top_va’ [-Werror=implicit-function-declaration]
>  1608 |                         vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
>       |                                                           ^~~~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/vmx/vmx.c:1608:81: error: ‘ESTACK_DB’ undeclared (first use in this function)
>  1608 |                         vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
>       |                                                                                 ^~~~~~~~~
> arch/x86/kvm/vmx/vmx.c:1608:81: note: each undeclared identifier is reported only once for each function it appears in
>   CC [M]  crypto/md4.o
>   CC      lib/crypto/sha512.o
> arch/x86/kvm/vmx/vmx.c:1609:81: error: ‘ESTACK_NMI’ undeclared (first use in this function)
>  1609 |                         vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
>       |                                                                                 ^~~~~~~~~~
> arch/x86/kvm/vmx/vmx.c:1610:81: error: ‘ESTACK_DF’ undeclared (first use in this function)
>  1610 |                         vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
>       |                                                                                 ^~~~~~~~~
> 


