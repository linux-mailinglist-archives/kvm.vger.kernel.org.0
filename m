Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36D3584C6F
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiG2HOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 03:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiG2HOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 03:14:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555D552446
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 00:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659078850; x=1690614850;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XQxjxHX2C+sC18rbptR/ov9GQsB4VVhSQEUddJTFw1M=;
  b=KkY9rJJiCVS2YxTVvZiGlSXOYkO9yQO5rnF00ByW3fa1tXr2J31J1rko
   RzPUogm56DHaIFcL9RKClV+Dy68AA7sBkdVVBzDn+WubdaPe/ip5Qz57Y
   jO2u+vsgscDRyCEIlVN7gEEAnpZDRj/bKZPCYh6Br2nka/0y43/aijDdx
   o3fdcCtQ1rqn+6RvOAhxISM87dwwhK4UYzNE8lhHX4NHoKFlMsJ22/7sd
   3Wlv6q1c98DZe+KYr7GPq6vS2enmIi72gr2l9F7z4QIOekPrFiDyLkxz2
   FC7txtC+5PZbS+uqJbHmmJhxTm/oc8QLYagJpFnBLEFUZmdphqw5BeWjj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="314509722"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="314509722"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 00:14:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="660125746"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.53]) ([10.249.175.53])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 00:14:05 -0700
Message-ID: <ad425c66-ce61-3e21-307e-55fc7131d954@intel.com>
Date:   Fri, 29 Jul 2022 15:14:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v4 18/36] i386/tdx: Skip BIOS shadowing setup
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
 <20220512031803.3315890-19-xiaoyao.li@intel.com>
 <20220524070804.tcrsg7cwlnbkzhjz@sirius.home.kraxel.org>
 <b294af31-fe92-f251-5d3e-0e439a59ee1e@intel.com>
 <20220530114904.242xqql3xfugy2a7@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220530114904.242xqql3xfugy2a7@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/2022 7:49 PM, Gerd Hoffmann wrote:
> On Thu, May 26, 2022 at 10:48:56AM +0800, Xiaoyao Li wrote:
>> On 5/24/2022 3:08 PM, Gerd Hoffmann wrote:
>>> On Thu, May 12, 2022 at 11:17:45AM +0800, Xiaoyao Li wrote:
>>>> TDX guest cannot go to real mode, so just skip the setup of isa-bios.
>>>
>>> Does isa-bios setup cause any actual problems?
>>> (same question for patch #19).
>>
>> It causes mem_region split and mem_slot deletion on KVM.
>>
>> TDVF marks pages starting from 0x800000 as TEMP_MEM and TD_HOB, which are
>> TD's private memory and are TDH_MEM_PAGE_ADD'ed to TD via
>> KVM_TDX_INIT_MEM_REGION
>>
>> However, if isa-bios and pc.rom are not skipped, the memory_region
>> initialization of them is after KVM_TDX_INIT_MEM_REGION in
>> tdx_machine_done_notify(). (I didn't figure out why this order though)
>>
>> And the it causes memory region split that splits
>> 	[0, ram_below_4g)
>> to
>> 	[0, 0xc0 000),
>> 	[0xc0 000, 0xe0 000),
>> 	[0xe0 000, 0x100 000),
>> 	[0x100 000, ram_below_4g)
>>
>> which causes mem_slot deletion on KVM. On KVM side, we lose the page content
>> when mem_slot deletion.  Thus, the we lose the content of TD HOB.
> 
> Hmm, removing and re-creating memory slots shouldn't cause page content
> go away.   I'm wondering what the *real* problem is?  Maybe you loose
> tdx-specific state, i.e. this removes TDH_MEM_PAGE_ADD changes?
> 
>> Yes, the better solution seems to be ensure KVM_TDX_INIT_MEM_REGION is
>> called after all the mem region is settled down.
> 
> Yes, especially if tdx can't tolerate memory slots coming and going.

Actually, only the private memory that is assumed as already-accepted 
via SEAMALL(TDH.MEM.PAGE.ADD) in the point of view of TDVF cannot 
tolerate being removed. TDVF assumes those memory has initialized 
content and can be accessed directly. In other words, QEMU needs to 
always calls SEAMALL(TDH.MEM.PAGE.ADD) to "add" those memory before TDVF 
runs.

>> But I haven't figured out the reason why the isa-bios and pc.rom
>> initialization happens after machine_init_done_notifier
> 
> Probably happens when a flatview is created from the address space.
> 
> Maybe that is delayed somehow for machine creation, so all the address
> space updates caused by device creation don't lead to lots of flatviews
> being created and thrown away.

sorry for the late response.

I did some tracing for this, and the result differs for q35 machine type 
and pc machine type.

- For q35, the memslot update for isa-bios/pc.rom happens when 
mc->reset() that is triggered via

   qdev_machine_creation_done()
     -> qemu_system_reset(SHUTDOWN_CASE_NONE);

It's surely later than TDX's machine_init_done_notify callback which 
initializes the part of private memory via KVM_TDX_INIT_MEM_REGION

- For pc machine type, the memslot update happens in i440fx_init(), 
which is earlier than TDX's machine_init_done_notify callback

I haven't fully understand in what condition will QEMU carry out the 
memslot update yet. I will keep learning and try to come up a solution 
to ensure TDX's machine_init_done_notify callback executed after all the 
memslot settle down.

>> on the other hand, to keep isa-bios and pc.rom, we need additional work to
>> copy the content from the end_of_4G to end_of_1M.
> 
> There is no need for copying, end_of_1M is a alias memory region for
> end_of_4G, so the backing storage is the same.

It is a reason that current alias approach cannot work for TDX. Because 
in TDX a private page can be only mapped to one gpa. So for simplicity, 
I will just skip isa-bios shadowing for TDX instead of implementing a 
non-alias + memcpy approach.

For pc.rom in next patch, I don't have strong reason to skip it. But I 
will keep it in next version to make whole TDX patches work for q35 
machine type until I think up a good solution to ensure the memslot 
update happens before TDX's machine_init_done_notify callback.

>> I'm not sure if isa-bios and pc.rom are needed from people on TD guest, so I
>> just skip them for simplicity,
> 
> Given that TDX guests start in 32bit mode not in real mode everything
> should work fine without isa-bios.
> 
> I'd prefer to avoid creating a special case for tdx though.  Should make
> long-term maintenance a bit easier when this is not needed.
> 
> take care,
>    Gerd
> 

