Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790EC76A697
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 03:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjHABzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 21:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjHABzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 21:55:38 -0400
Received: from mgamail.intel.com (unknown [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44654199A
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 18:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690854937; x=1722390937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eQdIzvbewvwesb8c3esY+r02/rqLnE+EOFZ+QULBn5w=;
  b=HJY86Po1kkBpxAYsSiYE8zFr4WlIiXVI9u9V0LgS3lQj8xjUDqdrRL69
   YT2zcDZbTYstCvJB8XdfzTP3XiOtPeOkroADkULfDZ+qSw1uTUmElq2Bn
   DR4rZxv3qbdr2dP+lOobE55JOlELmL0GscdbG05u7G7md8Xqf6L1U4SRL
   2nCEy0ZdkRX0LC1VDFLxLsIxW5RUluxpV/+mhEeWEeld5l0jlHZULUY3x
   mL6MCstU3BeIawRoF9IXMVy3DTe4dNIJUMKg1os+/VnGLI4QvTj7gbsBd
   3WM3JzD107P37LNudEVo/Q8+ij/BpcFbxnFv4cxixXZBweeUApxlNsmho
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="368074443"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="368074443"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 18:55:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="678514344"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="678514344"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 18:55:30 -0700
Message-ID: <70746276-b748-aa5e-4a25-9399496c32e4@intel.com>
Date:   Tue, 1 Aug 2023 09:55:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 00/19] QEMU gmem implemention
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
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
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731171041.GB1807130@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230731171041.GB1807130@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2023 1:10 AM, Isaku Yamahata wrote:
> On Mon, Jul 31, 2023 at 12:21:42PM -0400,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
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
> 
> Hi Xiaoyao.  Because qemu has already confidential guest support, we should
> utilize it.  Say,
> qemu  \
>    -object sw-protected, id=swp0, <more options for KVM_X86_SW_PROTECTED_VM> \
>    -machine confidential-guest-support=swp0

thanks for pointing out this option. I thought of it and forgot to list 
it as option.

It seems better and I'll go this direction if no one has different opinion.

> 
>> 2. whether 'private' property is needed if we choose 1.b as design
>>
>>     with 1.b, QEMU can decide whether the memory region needs to be
>>     private (allocates gmem fd for it) or not, on its own.
> 
> 
> Memory region property (how to create KVM memory slot) should be independent
> from underlying VM type.  Some (e.g. TDX) may require KVM private memory slot,
> some may not.  Leave the decision to its vm type backend.  They can use qemu
> memory listener.

As I replied to Daniel, the topic is whether 'private' property is 
needed. Is it essential to let users decide which memory can be private? 
It seems OK that QEMU can make the decision based on VM type.
