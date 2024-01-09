Return-Path: <kvm+bounces-5865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3527827E7F
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 06:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 524D228202F
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 05:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90732947A;
	Tue,  9 Jan 2024 05:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YNNQAR69"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1032D9470
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 05:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704779254; x=1736315254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Lr1c0pBgECUb034TWIjWoUsV0KEx7gxHpqnO/Hb2U1k=;
  b=YNNQAR69W+1y0/3BoBS9qXQH9+4UrJ9Vlm0OUkzOqGgPe4MqgqfzB5JB
   inbq9pr+iypUvyp6VsWF7dGjy5o8ni0clTNKkeOFK38x7H33yRC6hlNTU
   QdKJh+VW3JSU4TUa0ZSrN1otImG0HcGt8hkp9kNIKgFu4m1yfojFj0eQp
   MzZKDiOftjfyDlGBFS3ezTAzz4lKTUm59mCN1pxyGbWRCwdUbx2CaOKHd
   74JvW7mO/wV8Ovc6kkfb7NGCxqigTQj2tDMX7n7jvghWZSTgwn2RbGZ4z
   L1WRDvnvKT2HjLUdGtpIyY3qc+lzZJq77wgCvcfxKeshxnswHIe5VomYo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="401880787"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="401880787"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 21:47:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="23773185"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 21:47:28 -0800
Message-ID: <1bc76559-20e7-4b20-a566-9491711f7a21@intel.com>
Date: Tue, 9 Jan 2024 13:47:25 +0800
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
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <DS0PR11MB63730289975875A5B90D078CDC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/2023 9:47 PM, Wang, Wei W wrote:
> On Thursday, December 21, 2023 7:54 PM, Li, Xiaoyao wrote:
>> On 12/21/2023 6:36 PM, Wang, Wei W wrote:
>>> No need to specifically check for KVM_MEMORY_ATTRIBUTE_PRIVATE there.
>>> I'm suggesting below:
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c index
>>> 2d9a2455de..63ba74b221 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -1375,6 +1375,11 @@ static int kvm_set_memory_attributes(hwaddr
>> start, hwaddr size, uint64_t attr)
>>>        struct kvm_memory_attributes attrs;
>>>        int r;
>>>
>>> +    if ((attr & kvm_supported_memory_attributes) != attr) {
>>> +        error_report("KVM doesn't support memory attr %lx\n", attr);
>>> +        return -EINVAL;
>>> +    }
>>
>> In the case of setting a range of memory to shared while KVM doesn't support
>> private memory. Above check doesn't work. and following IOCTL fails.
> 
> SHARED attribute uses the value 0, which indicates it's always supported, no?
> For the implementation, can you find in the KVM side where the ioctl
> would get failed in that case?

I'm worrying about the future case, that KVM supports other memory 
attribute than shared/private. For example, KVM supports RWX bits (bit 0 
- 2) but not shared/private bit.

This patch designs kvm_set_memory_attributes() to be common for all the 
bits (and for future bits), thus it leaves the support check to each 
caller function separately.

If you think it's unnecessary, I can change the name of 
kvm_set_memory_attributes() to kvm_set_memory_shared_private() to make 
it only for shared/private bit, then the check can be moved to it.

> static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>                                             struct kvm_memory_attributes *attrs)
> {
>          gfn_t start, end;
> 
>          /* flags is currently not used. */
>          if (attrs->flags)
>                  return -EINVAL;
>          if (attrs->attributes & ~kvm_supported_mem_attributes(kvm)) ==> 0 here
>                  return -EINVAL;
>          if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
>                  return -EINVAL;
>          if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
>                  return -EINVAL;


