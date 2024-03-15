Return-Path: <kvm+bounces-11877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F7D87C763
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 03:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FB1C1C2171F
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 02:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E802A7476;
	Fri, 15 Mar 2024 02:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AlQ57S/A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BD7613D;
	Fri, 15 Mar 2024 02:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710468669; cv=none; b=nFhwnGKtUOBdiuhF6FpQmck7FCN3GYaUPYeqd5f/PhWo09yxdPYs7kE5JRbA6/zMdGKtDtJvzG7dxsxXXDauDvC15KqGyEY2VaP4k3vdS6WWVFFifwrnMMWM8qe3KAk2XwrLzUkw9TwuluS6dKNbvan6OvPzc5Pxqp7nMX4aM3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710468669; c=relaxed/simple;
	bh=8TkQWxUkIXsgjC9vDNQgkuuZuaa2KSqmPIJGceGkLew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0Vft+bmLiQbRztlOCJRe7d15J+8LXi2MFcZczPW5iWdK7NwsvrV8oz5gJL/8F2AbCy9RdN+uJyHKVdlcUbWnRtwlM/JO5GS6YPUP3juZICgs+v3Mgg8GYu2EdbLENIdT7LlM/ijJxjlhWO4ze6wjqQnb81HWlW2rIkW/tihMOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AlQ57S/A; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710468663; x=1742004663;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8TkQWxUkIXsgjC9vDNQgkuuZuaa2KSqmPIJGceGkLew=;
  b=AlQ57S/AaJykU4ie0p+GdwQuR/T9fF7wwVkj7G7nKthTP5dF9rm14eep
   Uz4cXG+OWO1qbWLB1CvjkMcIj0yJuEu3k3MZHY4nF1cmsVOmgUcd2OdeL
   V1UC2YjBMz9Oyko2dbKpyVWM8+Ry3WTIlKTHHeFDMKFbboCyQXmycQArq
   2cv+F51ygvggVdzpDVQ0M4pmzkNNyUFbXuwWuWOjAHqxgjNlUs7i0kgFt
   b2+gz0G4g4vwJs+lW+po0c/xZTaTPoJkC/naA8uCuzmvxLVWF1RH/mdOn
   xIb6rH6r+AemtWYp+oP5lePzhB3ifzcdx8Rtb7Ac2TFInpdsS5XK1QolJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5191960"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="5191960"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 19:11:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="12425872"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 19:10:58 -0700
Message-ID: <f492f669-4abb-406f-ad7b-2d134332644c@intel.com>
Date: Fri, 15 Mar 2024 10:10:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Content-Language: en-US
To: "Huang, Kai" <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: x86@kernel.org, dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
 peterz@infradead.org, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 isaku.yamahata@intel.com, jgross@suse.com
References: <cover.1709288433.git.kai.huang@intel.com>
 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
 <bd61e29d-5842-4136-b30f-929b00bdf6f9@intel.com>
 <1c8537b8-bb91-48ee-ae9a-5f54b828b49c@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1c8537b8-bb91-48ee-ae9a-5f54b828b49c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/2024 8:24 AM, Huang, Kai wrote:
> 
> 
> On 13/03/2024 4:44 pm, Xiaoyao Li wrote:
>> On 3/1/2024 7:20 PM, Kai Huang wrote:
>>> KVM will need to read a bunch of non-TDMR related metadata to create and
>>> run TDX guests.  Export the metadata read infrastructure for KVM to use.
>>>
>>> Specifically, export two helpers:
>>>
>>> 1) The helper which reads multiple metadata fields to a buffer of a
>>>     structure based on the "field ID -> structure member" mapping table.
>>>
>>> 2) The low level helper which just reads a given field ID.
>>
>> How about introducing a helper to read a single metadata field 
>> comparing to 1) instead of the low level helper.
>>
>> The low level helper tdx_sys_metadata_field_read() requires the data 
>> buf to be u64 *. So the caller needs to use a temporary variable and 
>> handle the memcpy when the field is less than 8 bytes.
>>
>> so why not expose a high level helper to read single field, e.g.,
>>
>> +int tdx_sys_metadata_read_single(u64 field_id, int bytes, void *buf)
>> +{
>> +       return stbuf_read_sys_metadata_field(field_id, 0, bytes, buf);
>> +}
>> +EXPORT_SYMBOL_GPL(tdx_sys_metadata_read_single);
> 
> As replied here where these APIs are (supposedly) to be used:
> 
> https://lore.kernel.org/kvm/e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com/
> 
> I don't see why we need to use a temporary 'u64'.  We can just use it 
> directly or type cast to 'u16' when needed, which has the same result of 
> doing explicit memory copy based on size.

The way to cast a u64 to u16 is based on the fact that the variable is 
u64 at first.

Given

	u16 feild_x;

We have to have a u64 tmp, passed to tdx_sys_metadata_field_read() to 
hold the output of metadata read, then

	filed_x = (u16) tmp;

If we pass field_x into tdx_sys_metadata_field_read(), the following 
(64-16) bits might be corrupted.

> So I am not convinced at this stage that we need the code as you 
> suggested.  At least I believe the current APIs are sufficient for KVM 
> to use.
> 
> However I'll put more background on how KVM is going to use into the 
> changelog to justify the current APIs are enough.


