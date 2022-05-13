Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF45258FE
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 02:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359743AbiEMAh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 20:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345691AbiEMAh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 20:37:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64D15C67A
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 17:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652402246; x=1683938246;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CzWtyjaPDnpjUSDTI6/vwHA0qtMMF9tsA/I5mdOgz5s=;
  b=P19kDuicyivwrjSJ06gMTR/7bC9opdsQy8dHq+hugZIpT91xKiDLuJ4Q
   cYE9TEU/Ha5q3JKsoFEenudnv4TGibvX8jtebuWzegf2x/EynzcNQuD8I
   +o5QOgXBRwaoVAFbTqCP7lFqpR09pb4UOT6NnewWDq3vCCnarBBVuu5A6
   Oz6ajoudbUCgMFLYCnFQu68KGTUPbmNzCF/t8gGSNlUQOfysG3PIsFTGs
   1AFVK6IdXrG7+JngEGXQZkRoRgiKEh5GVr58lWIoiQkvdRiZKZ9uytSTa
   MzGJqQfwFuHHTdp87SCz2yc4cIOSnOwjpCpJ8BoEjnTuVpX/U6fJF9L2O
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270109634"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270109634"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:37:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="594952856"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.214]) ([10.249.175.214])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:37:21 -0700
Message-ID: <b6c748b3-bb59-cb02-f7a7-8ae15a1baded@intel.com>
Date:   Fri, 13 May 2022 08:37:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v4 10/36] i386/kvm: Move architectural CPUID leaf
 generation to separate helper
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
 <20220512031803.3315890-11-xiaoyao.li@intel.com>
 <20220512174814.GE2789321@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220512174814.GE2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/2022 1:48 AM, Isaku Yamahata wrote:
> On Thu, May 12, 2022 at 11:17:37AM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
>> index b434feaa6b1d..5c7972f617e8 100644
>> --- a/target/i386/kvm/kvm_i386.h
>> +++ b/target/i386/kvm/kvm_i386.h
>> @@ -24,6 +24,10 @@
>>   #define kvm_ioapic_in_kernel() \
>>       (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
>>   
>> +#define KVM_MAX_CPUID_ENTRIES  100
> 
> In Linux side, the value was bumped to 256.  Opportunistically let's make it
> same.
> 
> 3f4e3eb417b1 KVM: x86: bump KVM_MAX_CPUID_ENTRIES

I don't think so.

In KVM, KVM_MAX_CPUID_ENTRIES is used to guard IOCTL 
KVM_SET_CPUID/KVM_SET_CPUID2/KVM_GET_SUPPORTED_CPUID/KVM_GET_EMULATED_CPUID, 
that KVM handles at most
the number of KVM_MAX_CPUID_ENTRIES entries.

However, in QEMU, KVM_MAX_CPUID_ENTRIES is used as the maximum total 
number of CPUID entries that generated by QEMU. It's used to guard the 
number in kvm_x86_arch_cpuid().

I think we can increase the number when we actually hit the check in 
kvm_x86_arch_cupid().

>> +uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
>> +                            uint32_t cpuid_i);
>> +
>>   #else
>>   
>>   #define kvm_pit_in_kernel()      0
>> -- 
>> 2.27.0
>>
>>
> 

