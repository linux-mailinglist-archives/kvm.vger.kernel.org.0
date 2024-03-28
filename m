Return-Path: <kvm+bounces-12949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 055C288F5CD
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADDD61F24BB5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775DB32C8C;
	Thu, 28 Mar 2024 03:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kfih91cp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25703847C;
	Thu, 28 Mar 2024 03:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595874; cv=none; b=IJn6LHUVjAbd8fMgV2B/4Nb572on0igkYVF2bjd93ybLaM+TYpo+PTQzzClZXaspTepV7eCupY12an25VUbgLtCusFK18YUcjkmiDat3QvT+b702fviXo1rV/Xw+hmHKHNO49qRwrDvZC7YIPDMccTMIs9zI1h857RCyKE5cOCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595874; c=relaxed/simple;
	bh=XTmhB6KCgprB9lbSRIt9hvN2bAm4xpXhWQrdKlPHOVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X6x1CrVBvodeoa99OvlQAfxvoWrrqxGyplLhtE265VRATZvlNUfR81KBuQ1HADoe3kUkCEVkycuW3MioJstSWPNbizD/JazI2eU9GqtZFoJXlCScXBMjACHV/UMQXcmAazb7sAwytVfCT3tLw78RoM7r24V06oOhhEKEX7AW9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kfih91cp; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711595871; x=1743131871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XTmhB6KCgprB9lbSRIt9hvN2bAm4xpXhWQrdKlPHOVk=;
  b=kfih91cpL4KsA/MCrUTeetAOgQSuYmWh2hUC3ycOfeyOEoqa5oRQ5HNC
   bPKnH4CsNr06UwExIx7VkvEi9HS4TW4PDjKMeFF03rx7MBp4Q/wA0MN6f
   FO5pqWBJqE74+xfdG6rZZCkiwzInfZ5pq5kTiiJlwtvixTdncGBy9XRQ9
   AafLYDfTUKdlh1t5E0F7CrewNOe1e6GVMMo/a1cdgzShwGiSzWsi3VN5h
   dbLN3Nns1LuA216TCmB0kmT0MaMDNKZfVgoMpzKoX4HJltZgxgNN1Jvnn
   X6CCCaJ+zvB7rQw+kms8zIkdA+E6EDVt7FL8D6kNvp5cub30yKMO9HsgV
   A==;
X-CSE-ConnectionGUID: /m3vnnwfTIOSyizIW8+bkg==
X-CSE-MsgGUID: SyBJQxkmSG6B7oxE5Tj7ig==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="32129556"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="32129556"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:17:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16529666"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:17:48 -0700
Message-ID: <d6285364-f6cd-49e6-a438-2ae87f965e4f@linux.intel.com>
Date: Thu, 28 Mar 2024 11:17:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
 <20240314181000.GC1258280@ls.amr.corp.intel.com>
 <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
 <ada65e3e977c8cde0044b7fa9de5f918e3b1b638.camel@intel.com>
 <20240315010940.GE1258280@ls.amr.corp.intel.com>
 <35090f7e-4f4d-403c-b95e-f09248fc272d@linux.intel.com>
 <20240328000205.GJ2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240328000205.GJ2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/28/2024 8:02 AM, Isaku Yamahata wrote:
> On Wed, Mar 27, 2024 at 09:49:14PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 3/15/2024 9:09 AM, Isaku Yamahata wrote:
>>> Here is the updated one. Renamed dummy -> mirroed.
>>>
>>> When KVM resolves the KVM page fault, it walks the page tables.  To reuse
>>> the existing KVM MMU code and mitigate the heavy cost of directly walking
>>> the private page table, allocate one more page to copy the mirrored page
>> Here "copy" is a bit confusing for me.
>> The mirrored page table is maintained by KVM, not copied from anywhere.
> How about, "maintain" or "keep"?

Or just use "for"?

i.e, allocate one more page for the mirrored page table ...



>
>>> table for the KVM MMU code to directly walk.  Resolve the KVM page fault
>>> with the existing code, and do additional operations necessary for the
>>> private page table.  To distinguish such cases, the existing KVM page table
>>> is called a shared page table (i.e., not associated with a private page
>>> table), and the page table with a private page table is called a mirrored
>>> page table.  The relationship is depicted below.
>>>
>>>
>>>                 KVM page fault                     |
>>>                        |                           |
>>>                        V                           |
>>>           -------------+----------                 |
>>>           |                      |                 |
>>>           V                      V                 |
>>>        shared GPA           private GPA            |
>>>           |                      |                 |
>>>           V                      V                 |
>>>       shared PT root      mirrored PT root         |    private PT root
>>>           |                      |                 |           |
>>>           V                      V                 |           V
>>>        shared PT           mirrored PT ----propagate---->  private PT
>>>           |                      |                 |           |
>>>           |                      \-----------------+------\    |
>>>           |                                        |      |    |
>>>           V                                        |      V    V
>>>     shared guest page                              |    private guest page
>>>                                                    |
>>>                              non-encrypted memory  |    encrypted memory
>>>                                                    |
>>> PT: Page table
>>> Shared PT: visible to KVM, and the CPU uses it for shared mappings.
>>> Private PT: the CPU uses it, but it is invisible to KVM.  TDX module
>>>               updates this table to map private guest pages.
>>> Mirrored PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
>>>                to propagate PT change to the actual private PT.
>>>
>>


