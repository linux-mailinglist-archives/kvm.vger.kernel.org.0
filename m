Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7C34E21FE
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 09:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345210AbiCUIRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 04:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345229AbiCUIRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 04:17:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A616F1265AA
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 01:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647850525; x=1679386525;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=emHGj6ghKUk9AmDI87yzqr6a+usVYgHge4IUp6jmt9M=;
  b=Krl8vsOTBJxRFeTAuFPbYIxgymlTktr2dTExz0s9vU27kh8qrrMDljJf
   xKih35zZsLvSUqwiumm1NPcdTiE5J1OhHsNofr3XxcmOon2J5+79fUlEl
   8Qn5dWO3gexDBRYU3sMEScc+2xfl2EJReEwYt0FvjUlioT7d5/aHSAJND
   s/o56a4fC9A26RIuj8ZJ0IyvQRsH9Kto/KkMoE7IhALv/ycwIq11SfnUC
   Vyp8EIzKPFXAfZRgbi2KNBSq+f7/wn8qlTBaiF709wf9m4lfQ42xdXMzD
   a2O02hK/ozSSihBNk76o5b+cRjPbsgPhGjhqG8GjCT2eQiTRerv4zsBaf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="237440229"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="237440229"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 01:15:24 -0700
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="500092839"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.249]) ([10.255.28.249])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 01:15:19 -0700
Message-ID: <398611c0-cccc-2d4c-171f-68a93b55dea5@intel.com>
Date:   Mon, 21 Mar 2022 16:15:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 16/36] i386/tdx: Set kvm_readonly_mem_enabled to
 false for TDX VM
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-17-xiaoyao.li@intel.com>
 <20220318171117.GC4049379@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318171117.GC4049379@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/2022 1:11 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:58:53PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> TDX only supports readonly for shared memory but not for private memory.
>>
>> In the view of QEMU, it has no idea whether a memslot is used by shared
>> memory of private. Thus just mark kvm_readonly_mem_enabled to false to
>> TDX VM for simplicity.
>>
>> Note, pflash has dependency on readonly capability from KVM while TDX
>> wants to reuse pflash interface to load TDVF (as OVMF). Excuse TDX VM
>> for readonly check in pflash.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   hw/i386/pc_sysfw.c    | 2 +-
>>   target/i386/kvm/tdx.c | 9 +++++++++
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
>> index c8b17af95353..75b34d02cb4f 100644
>> --- a/hw/i386/pc_sysfw.c
>> +++ b/hw/i386/pc_sysfw.c
>> @@ -245,7 +245,7 @@ void pc_system_firmware_init(PCMachineState *pcms,
>>           /* Machine property pflash0 not set, use ROM mode */
>>           x86_bios_rom_init(MACHINE(pcms), "bios.bin", rom_memory, false);
>>       } else {
>> -        if (kvm_enabled() && !kvm_readonly_mem_enabled()) {
>> +        if (kvm_enabled() && (!kvm_readonly_mem_enabled() && !is_tdx_vm())) {
> 
> Is this called before tdx_kvm_init()?

yes.

pc_init1()/ pc_q35_init()
  pc_memory_init()
     pc_system_firmware_init()

is called after configure_accelerator() to configure kvm.
