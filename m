Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4447D4E20E0
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 08:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343540AbiCUHDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 03:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344695AbiCUHDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 03:03:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A9D4924C
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 00:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647846132; x=1679382132;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0iRvrFKjuNuyC9lG4vhN/9p1QBkTE+Phuzunp0EN+tg=;
  b=dFjlEBv5T88PLsXgPxj/lHsZDKqh+OXqyv5KGHiMq6j+GeXM4hjz6XQF
   TyHoChx9N9YplJ6AsG9EA6+tfpfOfSHSclc4UezVOJLI6vN8iQkEVN+5I
   Y0KWDEJMkthwvnl4Nb46d2TS4IUT3mbVd/48F3lu3sNRh6uYNwKRMRNFr
   RhhWfsgunGRczjA448RkLjgF7JdkCrPd3AaT2wOkoKGgqaizRvW5rh9a/
   IhdzJIVJis1kKEQrTpJJrpwM6wnXjI7NSIlzz+8D+z+Yn7fXasYMRSPQe
   DK0A6To0dETjHcg2NjqpY/vISl6Lnjz+50ZpNRZB3M2Ag2zy2fvoD55jP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="282309522"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="282309522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 00:02:12 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559736846"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 00:02:06 -0700
Message-ID: <9de4a579-b1f7-294e-34b1-09849f6d79b3@intel.com>
Date:   Mon, 21 Mar 2022 15:02:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 09/36] KVM: Introduce kvm_arch_pre_create_vcpu()
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
 <20220317135913.2166202-10-xiaoyao.li@intel.com>
 <20220318165627.GB4049379@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318165627.GB4049379@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/2022 12:56 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:58:46PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
>> work prior to create any vcpu. This is for i386 TDX because it needs
>> call TDX_INIT_VM before creating any vcpu.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c    | 7 +++++++
>>   include/sysemu/kvm.h   | 1 +
>>   target/arm/kvm64.c     | 5 +++++
>>   target/i386/kvm/kvm.c  | 5 +++++
>>   target/mips/kvm.c      | 5 +++++
>>   target/ppc/kvm.c       | 5 +++++
>>   target/s390x/kvm/kvm.c | 5 +++++
>>   7 files changed, 33 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 27864dfaeaaa..a4bb449737a6 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -465,6 +465,13 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>   
>>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>>   
>> +    ret = kvm_arch_pre_create_vcpu(cpu);
>> +    if (ret < 0) {
>> +        error_setg_errno(errp, -ret,
>> +                         "kvm_init_vcpu: kvm_arch_pre_create_vcpu() failed");
>> +        goto err;
>> +    }
>> +
>>       ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
>>       if (ret < 0) {
>>           error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index a783c7886811..0e94031ab7c7 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -373,6 +373,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
>>   
>>   int kvm_arch_init(MachineState *ms, KVMState *s);
>>   
>> +int kvm_arch_pre_create_vcpu(CPUState *cpu);
>>   int kvm_arch_init_vcpu(CPUState *cpu);
>>   int kvm_arch_destroy_vcpu(CPUState *cpu);
>>   
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index ccadfbbe72be..ae7336851c62 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -935,6 +935,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>       return kvm_arm_init_cpreg_list(cpu);
>>   }
>>   
>> +int kvm_arch_pre_create_vcpu(CPUState *cpu)
>> +{
>> +    return 0;
>> +}
>> +
> 
> Weak symbol can be used to avoid update all the arch.

OK. will use __attribute__ ((weak))

> Thanks,

