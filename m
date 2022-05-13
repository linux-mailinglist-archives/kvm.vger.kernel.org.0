Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1E952590E
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 02:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359777AbiEMAqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 20:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243156AbiEMAqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 20:46:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1383035876
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 17:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652402771; x=1683938771;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9fnPH0v8cZtL48+Hc//a1Dvk1egsHCzu2d3Fh4K7vq8=;
  b=K4ywWxsPLZuLhQcbxE5qw1yMAxz8ig4EMlDQIU5uyqM/uDvcfLWo1PMw
   RoGqFKkqoJTqfQawoaND+rYBzuEogSq2/zZawXy5OeinqAjoe3Wer/2dG
   oeXImAJ1LEsoW9u3eqCbdMjqJvoLCZOeW/AlD2nuJcCX4ohZ0seu6t+sN
   WOuCRM38Sf+MdIVG5OLCtLurNvmCTyuEK7/v+o5Ph381YooexyG87+BO/
   tsF0QjvWxP0PYXjDVH5fLYHqZvLvmxAtw/lYJiuMS9rOUnBB0kn//R6hs
   QAj3+1xh2fFVlN271XCuMRjXHoiU1y57zo91QTPlf11yy8tFHDGVB/1CT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="252223179"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="252223179"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:46:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="594955647"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.214]) ([10.249.175.214])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:46:03 -0700
Message-ID: <73349f35-f9ba-36da-7741-3de0da249009@intel.com>
Date:   Fri, 13 May 2022 08:46:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v4 14/36] i386/tdx: Implement user specified tsc
 frequency
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Gerd Hoffmann <kraxel@redhat.com>,
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
 <20220512031803.3315890-15-xiaoyao.li@intel.com>
 <20220512180412.GG2789321@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220512180412.GG2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/2022 2:04 AM, Isaku Yamahata wrote:
> On Thu, May 12, 2022 at 11:17:41AM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and pass it
>> to KVM_TDX_INIT_VM.
>>
>> Besides, sanity check the tsc frequency to be in the legal range and
>> legal granularity (required by TDX module).
> 
> Just to make it sure.
> You didn't use VM-scoped KVM_SET_TSC_KHZ because KVM side patch is still in
> kvm/queue?  Once the patch lands, we should use it.

I didn't use VM-scoped KVM_SET_TSC_KHZ is because

1) corresponding TDX KVM v6 series still provides tsc_khz in
    struct kvm_tdx_init_vm

2) Use KVM_SET_TSC_KHZ to set VM-scoped TSC seems possible to be applied 
to all VMs, not limited to TDs. It doesn't look like a small task.

I need more time to evaluate the efforts.

> Thanks,
> 
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/kvm.c |  8 ++++++++
>>   target/i386/kvm/tdx.c | 18 ++++++++++++++++++
>>   2 files changed, 26 insertions(+)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index f2d7c3cf59ac..c51125ab200f 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -818,6 +818,14 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
>>       int r, cur_freq;
>>       bool set_ioctl = false;
>>   
>> +    /*
>> +     * TD guest's TSC is immutable, it cannot be set/changed via
>> +     * KVM_SET_TSC_KHZ, but only be initialized via KVM_TDX_INIT_VM
>> +     */
>> +    if (is_tdx_vm()) {
>> +        return 0;
>> +    }
>> +
>>       if (!env->tsc_khz) {
>>           return 0;
>>       }
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 9f2cdf640b5c..622efc409438 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -35,6 +35,9 @@
>>   #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
>>   #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
>>   
>> +#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
>> +#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
>> +
>>   static TdxGuest *tdx_guest;
>>   
>>   /* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
>> @@ -211,6 +214,20 @@ int tdx_pre_create_vcpu(CPUState *cpu)
>>           goto out;
>>       }
>>   
>> +    r = -EINVAL;
>> +    if (env->tsc_khz && (env->tsc_khz < TDX_MIN_TSC_FREQUENCY_KHZ ||
>> +                         env->tsc_khz > TDX_MAX_TSC_FREQUENCY_KHZ)) {
>> +        error_report("Invalid TSC %ld KHz, must specify cpu_frequency between [%d, %d] kHz",
>> +                      env->tsc_khz, TDX_MIN_TSC_FREQUENCY_KHZ,
>> +                      TDX_MAX_TSC_FREQUENCY_KHZ);
>> +        goto out;
>> +    }
>> +
>> +    if (env->tsc_khz % (25 * 1000)) {
>> +        error_report("Invalid TSC %ld KHz, it must be multiple of 25MHz", env->tsc_khz);
>> +        goto out;
>> +    }
>> +
>>       r = setup_td_guest_attributes(x86cpu);
>>       if (r) {
>>           goto out;
>> @@ -221,6 +238,7 @@ int tdx_pre_create_vcpu(CPUState *cpu)
>>   
>>       init_vm.attributes = tdx_guest->attributes;
>>       init_vm.max_vcpus = ms->smp.cpus;
>> +    init_vm.tsc_khz = env->tsc_khz;
>>   
>>       r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
>>       if (r < 0) {
>> -- 
>> 2.27.0
>>
>>
> 

