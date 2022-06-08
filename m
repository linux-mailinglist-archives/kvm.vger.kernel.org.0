Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69254221D
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiFHE3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 00:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbiFHEZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 00:25:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A45F368F86
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 18:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654653097; x=1686189097;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2nQ38fddFLZDd8gkGjJtsrfacBKUhyjbYVezamAfui8=;
  b=RaWngcdmRPMGiT3lm4wf6BG5pKrnxaVq5LK9Z8F7f3f4N4/YEkq8pxpb
   lAExvUTyi/9WxmmI2eo/S1vhKfc9Ex5kZKjvvq7IyTD8yrXshbkCbLcRZ
   o7QdYY+0HFK89GeVW07I5UjzrnKkIWr4a++aFMpr5hX84stHMLbvaqNTb
   TvgavzAS3hg1aORtr93MG7iiPgrtSAFNQyWxgdhvKwUfYMmrk901IxS3j
   1dRole7lVoFeIeaN0hCr6iXhALfX1EFoFkQ+5R4Ifpf9FKrNiw5kgQhjW
   JJTYBomanfJQ57THZFpMVW2MmoYH+DoD3mo6Lpg5frmkRYdMBGlWrpAws
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="340800262"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="340800262"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:50:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="636468942"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.211]) ([10.255.31.211])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:50:44 -0700
Message-ID: <83f56255-f15d-f36b-4897-06d8f954061c@intel.com>
Date:   Wed, 8 Jun 2022 09:50:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 11/36] i386/tdx: Initialize TDX before creating TD
 vcpus
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
 <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
 <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
 <20220524065719.wyyoba2ke73tx3nc@sirius.home.kraxel.org>
 <39341481-67b6-aba4-a25a-10abb398bec4@intel.com>
 <20220601075453.7qyd5z22ejgp37iz@sirius.home.kraxel.org>
 <9d00fd58-b957-3b8e-22ab-12214dcbbe97@intel.com>
 <20220607111651.2zjm7mx2gz3irqxo@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220607111651.2zjm7mx2gz3irqxo@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/2022 7:16 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>>> I guess it could be helpful for the discussion when you can outine the
>>> 'big picture' for tdx initialization.  How does kvm accel setup look
>>> like without TDX, and what additional actions are needed for TDX?  What
>>> ordering requirements and other constrains exist?
>>
>> To boot a TDX VM, it requires several changes/additional steps in the flow:
>>
>>   1. specify the vm type KVM_X86_TDX_VM when creating VM with
>>      IOCTL(KVM_CREATE_VM);
>> 	- When initializing KVM accel
>>
>>   2. initialize VM scope configuration before creating any VCPU;
>>
>>   3. initialize VCPU scope configuration;
>> 	- done inside machine_init_done_notifier;
>>
>>   4. initialize virtual firmware in guest private memory before vcpu running;
>> 	- done inside machine_init_done_notifier;
>>
>>   5. finalize the TD's measurement;
>> 	- done inside machine init_done_notifier;
>>
>>
>> And we are discussing where to do step 2).
>>
>> We can find from the code of tdx_pre_create_vcpu(), that it needs
>> cpuid entries[] and attributes as input to KVM.
>>
>>    cpuid entries[] is set up by kvm_x86_arch_cpuid() mainly based on
>>    'CPUX86State *env'
>>
>>    attributes.pks is retrieved from env->features[]
>>    and attributes.pmu is retrieved from x86cpu->enable_pmu
>>
>> to make VM-socpe data is consistent with VCPU data, we do choose the point
>> late enough to ensure all the info/configurations from VCPU are settle down,
>> that just before calling KVM API to do VCPU-scope configuration.
> 
> So essentially tdx defines (some) vcpu properties at vm scope?  

Not TDX, but QEMU. Most of the CPU features are configrued by "-cpu" 
option not "-machine" option.

> Given
> that all vcpus typically identical (and maybe tdx even enforces this)
> this makes sense.
> 
> A comment in the source code explaining this would be good.
> 
> thanks,
>    Gerd
> 

