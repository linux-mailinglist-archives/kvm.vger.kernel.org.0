Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D536D76A68C
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 03:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjHABpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 21:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjHABpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 21:45:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC27E1988
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 18:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690854349; x=1722390349;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q3HqSAdiGDjuRHnjIkqW8UXAdbng499ewzU4TwytHbE=;
  b=CXDsEq4T9CK7asCUsTrLhAPd9cxJ3MCAGHLs+Asy3nrtbds2vtktJ4eB
   Kqn6CGIKvSktqKArVFMcrNoXHNi/5tmUqPIr13L9e5Pu4/V/2jnI1+X0z
   HUS/NfO2spFSpAGwHuVndfCDVxPee09yt33N0wDVDdP55aQQh8GfCVOHD
   ugejS6w4PJTluwbM/Uu5zHOZ8Fe1wWtznWVB7zK4hrggqxK+EIsvMkftN
   f+z4aNYXf/61/xQtkLadqOymVD4gc+1anvR/jxgKqK1ea3lUkZjY4X0wG
   LBXjhrquJ4MD4zHt1c2ySZQKJs8q98v/DYjH9IDF0WQLHXBFgHf/9+Zj4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="372798282"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="372798282"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 18:45:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="798465973"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="798465973"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 18:45:44 -0700
Message-ID: <9b3a3e88-21f4-bfd2-a9c3-60a25832e698@intel.com>
Date:   Tue, 1 Aug 2023 09:45:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 00/19] QEMU gmem implemention
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <ZMfmkCQImgsinE6T@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZMfmkCQImgsinE6T@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2023 12:51 AM, Daniel P. Berrangé wrote:
> On Mon, Jul 31, 2023 at 12:21:42PM -0400, Xiaoyao Li wrote:
>> This is the first RFC version of enabling KVM gmem[1] as the backend for
>> private memory of KVM_X86_PROTECTED_VM.
>>
>> It adds the support to create a specific KVM_X86_PROTECTED_VM type VM,
>> and introduces 'private' property for memory backend. When the vm type
>> is KVM_X86_PROTECTED_VM and memory backend has private enabled as below,
>> it will call KVM gmem ioctl to allocate private memory for the backend.
>>
>>      $qemu -object memory-backend-ram,id=mem0,size=1G,private=on \
>>            -machine q35,kvm-type=sw-protected-vm,memory-backend=mem0 \
>> 	  ...
>>
>> Unfortunately this patch series fails the boot of OVMF at very early
>> stage due to triple fault because KVM doesn't support emulate string IO
>> to private memory. We leave it as an open to be discussed.
>>
>> There are following design opens that need to be discussed:
>>
>> 1. how to determine the vm type?
>>
>>     a. like this series, specify the vm type via machine property
>>        'kvm-type'
>>     b. check the memory backend, if any backend has 'private' property
>>        set, the vm-type is set to KVM_X86_PROTECTED_VM.
>>
>> 2. whether 'private' property is needed if we choose 1.b as design
>>
>>     with 1.b, QEMU can decide whether the memory region needs to be
>>     private (allocates gmem fd for it) or not, on its own.
>>
>> 3. What is KVM_X86_SW_PROTECTED_VM going to look like? What's the
>>     purose of it and what's the requirement on it. I think it's the
>>     questions for KVM folks than QEMU folks.
>>
>> Any other idea/open/question is welcomed.
>>
>>
>> Beside, TDX QEMU implemetation is based on this series to provide
>> private gmem for TD private memory, which can be found at [2].
>> And it can work corresponding KVM [3] to boot TDX guest.
> 
> We already have a general purpose configuration mechanism for
> confidential guests.  The -machine argument has a property
> confidential-guest-support=$OBJECT-ID, for pointing to an
> object that implements the TYPE_CONFIDENTIAL_GUEST_SUPPORT
> interface in QEMU. This is implemented with SEV, PPC PEF
> mode, and s390 protvirt.
> 
> I would expect TDX to follow this same design ie
> 
>      qemu-system-x86_64 \
>        -object tdx-guest,id=tdx0,..... \
>        -machine q35,confidential-guest-support=tdx0 \
>        ...
> 
> and not require inventing the new 'kvm-type' attribute at least.

yes.

TDX is initialized exactly as the above.

This RFC series introduces the 'kvm-type' for KVM_X86_SW_PROTECTED_VM. 
It's my fault that forgot to list the option of introducing 
sw_protected_vm object with CONFIDENTIAL_GUEST_SUPPORT interface.
Thanks for Isaku to raise it 
https://lore.kernel.org/qemu-devel/20230731171041.GB1807130@ls.amr.corp.intel.com/

we can specify KVM_X86_SW_PROTECTED_VM this way:

qemu  \
   -object sw-protected,id=swp0,... \
   -machine confidential-guest-support=swp0 \
   ...

> For the memory backend though, I'm not so sure - possibly that
> might be something that still wants an extra property to identify
> the type of memory to allocate, since we use memory-backend-ram
> for a variety of use cases.  Or it could be an entirely new object
> type such as "memory-backend-gmem"

What I want to discuss is whether providing the interface to users to 
allow them configuring which memory is/can be private. For example, QEMU 
can do it internally. If users wants a confidential guest, QEMU 
allocates private gmem for normal RAM automatically.


