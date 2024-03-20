Return-Path: <kvm+bounces-12301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 884928811C9
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 068DCB224A8
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B027B3FE2C;
	Wed, 20 Mar 2024 12:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5jqvwsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C2C3EA62
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710938636; cv=none; b=bPmYfMjzJN422/VEIBfZFY0GuommDGf36pwxuJ93S/NIm9DOZyCGoi558hAMGbb7QTt770zUEFCR0C+UYI64HzyVe0c08IVSvTv6gXYOEDgfZme4GEWIktojBmC4tUO16LjIETx7J+nlIaV1Dmebu+Mxw+YNAo+8pPvMFXm/qHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710938636; c=relaxed/simple;
	bh=WQRuq3hosaq8AklV8ipALSq5HIOOVOi9Ij25lva5twA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ox5yonrX5uj0FqYSLFHL4qgbJvi9Mh4GK92siYEl1uVPmsa6XYeRKR2jqAnQN3vy+r3BzRicYq5qAoNYyBjioeClAS3wavQK+NIl9ccdFrHwMLn0PXpUSWsk10+yy2zA+RzIg250o2X2nP57oNpvWcWNrWBmiFBthDUL1fbDjAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5jqvwsf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710938635; x=1742474635;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WQRuq3hosaq8AklV8ipALSq5HIOOVOi9Ij25lva5twA=;
  b=f5jqvwsflxUvdytxVdbzrfJlkKkj/qhlr1X3/R8hIkDeeZ27Ea2AsLgC
   /xkULi77W6LEsEKJA+A3h9kow2NqgYNCF/godpT3IGiHuxqsCCyL+8v7c
   jfzbMN3uv8KQqZoUk3sOk+aKfVDN4ojd9yKSf3UvX2oZCilb52nYnI0C3
   nZe+k09U+tPgFmOATCfFs5bGLhF/Bi01x9I93ldmBX5liZ5g9xlkbtLXV
   BPE4bG+FEiP6N4aSqMiKHXR0ep1iYQN6wUp53OJ7apFcCyvxUQrMJP1lh
   UVMbBO/4sir1D5HFdwCIVoqn3CRGCUmfH3cg9Et9/x/HfNSw/79+uPfB7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5980112"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="5980112"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 05:43:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14119340"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 05:43:50 -0700
Message-ID: <8498f23d-0e11-46a6-8519-fc3261457ec3@intel.com>
Date: Wed, 20 Mar 2024 20:43:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/49] physmem: Introduce
 ram_block_discard_guest_memfd_range()
To: David Hildenbrand <david@redhat.com>, Michael Roth
 <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-12-michael.roth@amd.com>
 <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/20/2024 5:37 PM, David Hildenbrand wrote:
> On 20.03.24 09:39, Michael Roth wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> When memory page is converted from private to shared, the original
>> private memory is back'ed by guest_memfd. Introduce
>> ram_block_discard_guest_memfd_range() for discarding memory in
>> guest_memfd.
>>
>> Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> "Co-developed-by"

Michael is using the patch from my TDX-QEMU v5 series[1]. I need to fix it.

>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> Your SOB should go here.
> 
>> ---
>> Changes in v5:
>> - Collect Reviewed-by from David;
>>
>> Changes in in v4:
>> - Drop ram_block_convert_range() and open code its implementation in the
>>    next Patch.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> I only received 3 patches from this series, and now I am confused: 
> changelog talks about v5 and this is "PATCH v3"

As above, because the guest_memfd patches in my TDX-QEMU v5[1] were 
directly picked for this series, so the change history says v5. They are 
needed by SEV-SNP as well.

I want to raise the question, how do we want to proceed with the guest 
memfd patches (patch 2 to 10 in [1])? Can they be merged separately 
before TDX/SNP patches?

> Please make sure to send at least the cover letter along (I might not 
> need the other 46 patches :D ).
> 


[1] 
https://lore.kernel.org/qemu-devel/20240229063726.610065-1-xiaoyao.li@intel.com/

