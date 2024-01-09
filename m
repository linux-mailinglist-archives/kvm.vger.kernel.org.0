Return-Path: <kvm+bounces-5899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0313828A0A
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F6A7284434
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 16:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36493A8CF;
	Tue,  9 Jan 2024 16:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JdSUXQnr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7513A8C1
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704817952; x=1736353952;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lq/alh0+QIDMJk8UzRpq0dUPGFZAHpyHNUvoUPsvRgQ=;
  b=JdSUXQnr09tcB81H/KQJosdXGf1JbXgiSVeuARovJDriJV54yOMj42+Z
   0RxVEH+HgDMWo33XVui3uUvWNrfGV3P92ZCUjtY8ys4ibm3tqhmxxkAQA
   ff9+dv8FDhBM5d7D/P2REcACiK+Aah6FsuH2TJbmg8Na0G5gWUHl8cFTh
   JsVq90ClRq2Cs9m+ibMappPaMFSOVjve3g9YDaL6jGtw6MFG+2usG0Re+
   FORzPq3d2KTSy5Vyl2zMFNqLa8NlnD2DIk7jP3BHY4gHl0G1phMyecotS
   G89kc8dyxwxuAve2NVCMSAXJ2mgaOJh9kAtrzfYhS4OHnb1RY7GqzG3J3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="4996533"
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="scan'208";a="4996533"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 08:32:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="872290734"
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="scan'208";a="872290734"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 08:32:24 -0800
Message-ID: <bd2679e7-46af-4875-ba42-b4ea413ec0a1@intel.com>
Date: Wed, 10 Jan 2024 00:32:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Content-Language: en-US
To: "Wang, Wei W" <wei.w.wang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, "Qiang, Chenyi" <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
 <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
 <DS0PR11MB63737AFCA458FA78423C0BB7DC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <a0289f6d-2008-48d7-95fb-492066c38461@intel.com>
 <DS0PR11MB63730289975875A5B90D078CDC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <1bc76559-20e7-4b20-a566-9491711f7a21@intel.com>
 <DS0PR11MB637348501D03A18EE7C394C4DC6A2@DS0PR11MB6373.namprd11.prod.outlook.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <DS0PR11MB637348501D03A18EE7C394C4DC6A2@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/2024 10:53 PM, Wang, Wei W wrote:
> On Tuesday, January 9, 2024 1:47 PM, Li, Xiaoyao wrote:
>> On 12/21/2023 9:47 PM, Wang, Wei W wrote:
>>> On Thursday, December 21, 2023 7:54 PM, Li, Xiaoyao wrote:
>>>> On 12/21/2023 6:36 PM, Wang, Wei W wrote:
>>>>> No need to specifically check for KVM_MEMORY_ATTRIBUTE_PRIVATE
>> there.
>>>>> I'm suggesting below:
>>>>>
>>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
>>>>> 2d9a2455de..63ba74b221 100644
>>>>> --- a/accel/kvm/kvm-all.c
>>>>> +++ b/accel/kvm/kvm-all.c
>>>>> @@ -1375,6 +1375,11 @@ static int kvm_set_memory_attributes(hwaddr
>>>> start, hwaddr size, uint64_t attr)
>>>>>         struct kvm_memory_attributes attrs;
>>>>>         int r;
>>>>>
>>>>> +    if ((attr & kvm_supported_memory_attributes) != attr) {
>>>>> +        error_report("KVM doesn't support memory attr %lx\n", attr);
>>>>> +        return -EINVAL;
>>>>> +    }
>>>>
>>>> In the case of setting a range of memory to shared while KVM doesn't
>>>> support private memory. Above check doesn't work. and following IOCTL
>> fails.
>>>
>>> SHARED attribute uses the value 0, which indicates it's always supported, no?
>>> For the implementation, can you find in the KVM side where the ioctl
>>> would get failed in that case?
>>
>> I'm worrying about the future case, that KVM supports other memory attribute
>> than shared/private. For example, KVM supports RWX bits (bit 0
>> - 2) but not shared/private bit.
> 
> What's the exact issue?
> +#define KVM_MEMORY_ATTRIBUTE_READ               (1ULL << 2)
> +#define KVM_MEMORY_ATTRIBUTE_WRITE             (1ULL << 1)
> +#define KVM_MEMORY_ATTRIBUTE_EXE                  (1ULL << 0)
> 
> They are checked via
> "if ((attr & kvm_supported_memory_attributes) != attr)" shared above in
> kvm_set_memory_attributes.
> In the case you described, kvm_supported_memory_attributes will be 0x7.
> Anything unexpected?

Sorry that I thought for wrong case.

It doesn't work on the case that KVM doesn't support memory_attribute, 
e.g., an old KVM. In this case, 'kvm_supported_memory_attributes' is 0, 
and 'attr' is 0 as well.

