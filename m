Return-Path: <kvm+bounces-8694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01545854F3D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0BC7283DE0
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 16:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1C760887;
	Wed, 14 Feb 2024 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bcp4Da1B"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52347604D9;
	Wed, 14 Feb 2024 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707929829; cv=none; b=l+TXiAczdAh+48ZrnUBrp3qrfnRwbEd6nVvCOPRu20A8C4jRc+D0hhSz4Giq/MHSqHQHd9PvOry60k4Ro9xtdpyn7GBkxiVfdST/Xz13OkjbHtm20Jvc8/AMCQYmYP6u33ONiE4SuYzdPGwFxGYYiCzW9SMSgtoU8pk6xIVHtbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707929829; c=relaxed/simple;
	bh=biuzYcQMelgQl+J54Kbot+3JqcMvoeGyuw3X50yl3uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Doth6bbzK9QQxGdZQ7ypCOWBdct5BFDMGquFXIlADHU0qBWMLNDfiCuZF1gLQWVHBSkqMGmSlfJXc2CUIoLr+Sv9w7MN1gGIckWxcSGr2iN4v3QncSm0QCi1wwjDbw5GMIJDpsoT9C4j9ul7VAfoC+rr4CinoFGjlAuVddjx5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bcp4Da1B; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.66.32.72] (unknown [108.143.43.187])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4C6E120B2000;
	Wed, 14 Feb 2024 08:56:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4C6E120B2000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1707929827;
	bh=ckiTjQJyYMqOqp6nmIcopayJUmMXUp+ALCH4tNreFgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bcp4Da1BitmockWhF96LYrtqTtYF1wsfqg1TsvWy2uwN7ngUJtjxpHOsFsOFkYRJo
	 Oc1JJKqKMD6tBVucLCv3I/J+wJYE56PeZVCCO7qQ3ND3CBRPqEuGxsTyjNc2QPe9EQ
	 6yEqS9dEv9MTe2x16MuoGJbktHyukuLjD1rAvyRk=
Message-ID: <b6f00233-0cbf-4d9a-aa8b-babc8a9ca696@linux.microsoft.com>
Date: Wed, 14 Feb 2024 17:56:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-mm@kvack.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 "liam.merwick@oracle.com Brijesh Singh" <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
 <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
 <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
 <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>
 <20240108170418.GDZZwrEiIaGuMpV0B0@fat_crate.local>
 <b5b57b60-1573-44f4-8161-e2249eb6f9b6@linux.microsoft.com>
 <20240109122906.GCZZ08Esh86vhGwVx1@fat_crate.local>
 <20240109124440.GDZZ0/uDY9RRPIOxOB@fat_crate.local>
Content-Language: en-US
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20240109124440.GDZZ0/uDY9RRPIOxOB@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/01/2024 13:44, Borislav Petkov wrote:
> On Tue, Jan 09, 2024 at 01:29:06PM +0100, Borislav Petkov wrote:
>> At least three issues I see with that:
>>
>> - the allocation can fail so it is a lot more convenient when the
>>   firmware prepares it
>>
>> - the RMP_BASE and RMP_END writes need to be verified they actially did
>>   set up the RMP range because if they haven't, you might as well
>>   throw SNP security out of the window. In general, letting the kernel
>>   do the RMP allocation needs to be verified very very thoroughly.
>>
>> - a future feature might make this more complicated
> 
> - What do you do if you boot on a system which has the RMP already
>   allocated in the BIOS?
> 
> - How do you detect that it is the L1 kernel that must allocate the RMP?
> 
> - Why can't you use the BIOS allocated RMP in your scenario too instead
>   of the L1 kernel allocating it?
> 
> - ...
> 
> I might think of more.
> 

Sorry for not replying back sooner.

I agree, lets get the base SNP stuff in and then talk about extensions.

I want to sync up with Michael to make sure he's onboard with what I'm
proposing. I'll add more design/documentation/usecase descriptions with the
next submission and will make sure to address all the issues you brought up.

Jeremi

