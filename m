Return-Path: <kvm+bounces-2855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A38527FEAAE
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 364F6B20F5F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0885736B0E;
	Thu, 30 Nov 2023 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LwvDbeR9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D79F172B
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701333113; x=1732869113;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ysZ3/9er4by0oGguDKTL7b7QQM3l5NmKPgsTSrYiT1o=;
  b=LwvDbeR9ATbAopi4tWdl8sm8uO64O4dOilPN1LtD/GYqolVmsatcbZpR
   0Ppdopcp8XDT5dWQliNTOng1Tm2FP+b+adcSQ3mq+np8eNfbSeNyu3YbL
   DAs+GUubdBLk0+BsMfNT6yrn/WttDO/WCfNlp+FRpBFcP6ehkv+li/aG9
   OQSTercR9hlkNf998Q3DaRmNFFivP/lFKOkG0l3E+5dzbIZz/LvTWuJK9
   rgM73HCVPJQLInLz8afP3U4+U7wbvVuHBiAy//2E/08zvJRmyMoBZeAlm
   wxLneumPYW511d+CB5rg340QZs6bHbbdc+YBkPVwZ3LXQmO0hDtNm5O62
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="11995702"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="11995702"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 00:31:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="772982457"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="772982457"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 00:31:46 -0800
Message-ID: <e6f52c81-0be6-4e37-8da3-0a3411d6f2c6@intel.com>
Date: Thu, 30 Nov 2023 16:31:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 isaku.yamahata@intel.com
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-3-xiaoyao.li@intel.com>
 <20231117203528.GA1645850@ls.amr.corp.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20231117203528.GA1645850@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/2023 4:35 AM, Isaku Yamahata wrote:
> On Wed, Nov 15, 2023 at 02:14:11AM -0500,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> diff --git a/system/physmem.c b/system/physmem.c
>> index fc2b0fee0188..0af2213cbd9c 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1841,6 +1841,20 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>>           }
>>       }
>>   
>> +#ifdef CONFIG_KVM
>> +    if (kvm_enabled() && new_block->flags & RAM_GUEST_MEMFD &&
>> +        new_block->guest_memfd < 0) {
>> +        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
>> +        uint64_t flags = 0;
>> +        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
>> +                                                        flags, errp);
>> +        if (new_block->guest_memfd < 0) {
>> +            qemu_mutex_unlock_ramlist();
>> +            return;
>> +        }
>> +    }
>> +#endif
>> +
> 
> We should define kvm_create_guest_memfd() stub in accel/stub/kvm-stub.c.
> We can remove this #ifdef.

Nice suggestion! Will use stub.

