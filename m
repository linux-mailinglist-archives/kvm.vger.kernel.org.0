Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E279178D1CF
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 03:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbjH3BqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 21:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241616AbjH3BqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 21:46:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8C0CC5
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 18:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693359967; x=1724895967;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p4Wy6jh1XftvGcwrqSfMaq2NtDuPyWExhKlq09mPg7E=;
  b=CkPv/9VW9zN9WfHpkT4NE3EZRaCpP5Sf/wBOPXjwrMtZi+zeMLgm0rqT
   OWgV/8s8q2bl1MaviGnCJpMrkU7sV4pZie6yhXUv80/YSBnqh5dU18J+8
   IzmddLO/2SeYaysjm5CzWgET87B9nZovFro4ZiQ6lrBk8R8BmB4bQparD
   uTWXx9nj2hhfMvFre3LXwJyI2Ay7FQhvHpb1n/w6Y6kP8A6yehMmVh/a/
   GOcEjuqDIoFlynQJ/Y03B37ozc5iarh36eQBlpR8Mpj9xLF3CAEjo12lu
   hENl5HZqHIrIsg63MjhJgeot0glCJqrNsu83q078rk+WpqmbgENcfr/vF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="365727194"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="365727194"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 18:46:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="862443162"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="862443162"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.81]) ([10.93.16.81])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 18:46:01 -0700
Message-ID: <6ea095cd-db21-c95a-b518-2d97b6098281@intel.com>
Date:   Wed, 30 Aug 2023 09:45:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 13/58] kvm: Introduce kvm_arch_pre_create_vcpu()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-14-xiaoyao.li@intel.com>
 <5bfefa59-6e1e-dcfd-a2a6-e49a0b71fded@linaro.org>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5bfefa59-6e1e-dcfd-a2a6-e49a0b71fded@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2023 10:40 PM, Philippe Mathieu-Daudé wrote:
> On 18/8/23 11:49, Xiaoyao Li wrote:
>> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
>> work prior to create any vcpu. This is for i386 TDX because it needs
>> call TDX_INIT_VM before creating any vcpu.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   accel/kvm/kvm-all.c  | 12 ++++++++++++
>>   include/sysemu/kvm.h |  1 +
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index c9f3aab5e587..5071af917ae0 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -422,6 +422,11 @@ static int kvm_get_vcpu(KVMState *s, unsigned 
>> long vcpu_id)
>>       return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
>>   }
>> +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu)
>> +{
>> +    return 0;
>> +}
> 
> kvm_arch_init_vcpu() is implemented for each arch. Why not use the
> same approach here?

Because only x86 needs it currently, for TDX. Other arches don't require 
an implementation.

If don't provide the _weak_ function, it needs to implement the empty 
function (justing return 0) in all the other arches just as the 
placeholder. If QEMU community prefers this approach, I can change to it 
in next version.

>>   int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>   {
>>       KVMState *s = kvm_state;
>> @@ -430,6 +435,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>> +    ret = kvm_arch_pre_create_vcpu(cpu);
>> +    if (ret < 0) {
>> +        error_setg_errno(errp, -ret, "%s: kvm_arch_pre_create_vcpu() 
>> failed",
>> +                        __func__);
>> +        goto err;
>> +    }
>> +
>>       ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
>>       if (ret < 0) {
>>           error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu 
>> failed (%lu)",
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index 49c896d8a512..d89ec87072d7 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -371,6 +371,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
>>   int kvm_arch_init(MachineState *ms, KVMState *s);
>> +int kvm_arch_pre_create_vcpu(CPUState *cpu);
>>   int kvm_arch_init_vcpu(CPUState *cpu);
>>   int kvm_arch_destroy_vcpu(CPUState *cpu);
> 

