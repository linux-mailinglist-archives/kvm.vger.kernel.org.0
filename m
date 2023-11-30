Return-Path: <kvm+bounces-2850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6213C7FE9C9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B8D728205B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 07:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D38E200C1;
	Thu, 30 Nov 2023 07:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwSXMkse"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E64CB9
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 23:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701329740; x=1732865740;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=99FlI+lUby8pT37iELGoU1c/gT0psdPhOS/BFhYOTBY=;
  b=fwSXMkseLRUvd+A7n2bPL+FUbsoNsMQ6cJk5e0O5rJlyGiAJRTejjsEl
   m7iSYeobTOYT1wDwYQTV0tPAtf2W6cS+q+Kc+m0CwsiVvLFnT5pycas8S
   MhqEtKRGbf7KtsLLLy4geqdQKsqpLgIQINL1b7f0jFP8DW42XMSkFdscR
   Bn8GZZw8Leb/gROmkxkSzvZYC5sX3ZzO/Vf14BywMdv82jYoDiyhJJCKA
   ubG++APuFveReWVMJLmhEHhF3qqsi3uertOf4lBcNBP+Ozz8trlVGMex4
   TnYKagw7Plri6+Q8LAratgk+JNYJL5qfK6Hzip0psLKRnfCC83w6hnU2x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="6555323"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="6555323"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:35:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="719045110"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="719045110"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:35:35 -0800
Message-ID: <994afc73-1929-4706-9510-e33bb7048487@intel.com>
Date: Thu, 30 Nov 2023 15:35:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-3-xiaoyao.li@intel.com>
 <ed599765-65b7-4253-8de2-61afba178e2d@redhat.com>
 <37b5ba85-021a-418b-8eda-8a716b7b7fb3@intel.com>
 <c3a7704f-12d8-457e-aad2-1c2ece896286@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c3a7704f-12d8-457e-aad2-1c2ece896286@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/2023 5:19 PM, David Hildenbrand wrote:
> On 16.11.23 03:45, Xiaoyao Li wrote:
>> On 11/16/2023 1:54 AM, David Hildenbrand wrote:
>>> On 15.11.23 08:14, Xiaoyao Li wrote:
>>>> Add KVM guest_memfd support to RAMBlock so both normal hva based memory
>>>> and kvm guest memfd based private memory can be associated in one
>>>> RAMBlock.
>>>>
>>>> Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM 
>>>> ioctl to
>>>> create private guest_memfd during RAMBlock setup.
>>>>
>>>> Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
>>>> confidential guests, such as TDX VM. How and when to set it for memory
>>>> backends will be implemented in the following patches.
>>>
>>> Can you elaborate (and add to the patch description if there is good
>>> reason) why we need that flag and why we cannot simply rely on the VM
>>> type instead to decide whether to allocate a guest_memfd or not?
>>>
>>
>> The reason is, relying on the VM type is sort of hack that we need to
>> get the MachineState instance and retrieve the vm type info. I think
>> it's better not to couple them.
>>
>> More importantly, it's not flexible and extensible for future case that
>> not all the memory need guest memfd.
>>
> 
> Okay. In that case, please update the documentation of all functions 
> where we are allowed to pass in RAM_GUEST_MEMFD. There are a couple of 
> them in include/exec/memory.h

sure, thanks!

> I'll note that the name/terminology of "RAM_GUEST_MEMFD" is extremely 
> Linux+kvm specific. But I cannot really come up with something better 
> right now.
> 


