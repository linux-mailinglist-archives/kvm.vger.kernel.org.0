Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3E55FE671
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 03:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJNBCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 21:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJNBCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 21:02:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14944E4C3A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 18:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665709338; x=1697245338;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=N8onz1+4r0f6KBh2AenjHcSU6m4ESpWPrn5RzDkFSwI=;
  b=TTuE/YMv+//rRmQ83jTESHVRPgBlcHxJKO4GlBULUKzNoENKD///iOIq
   QjuGPsIa6jcWaH4F8qrJh3WCVPV/z+W8dLTpZ1u4v3SnPEpkxmJKFBJLT
   jbyq1nsSKNSqSRom1iLgES6+4BM2m0qaZf8W9NBy9ohKXLpdGbMoh+p1t
   UZRO3I8ZlwaWI8zYaNmgRqq/ErpAj7xRTUCiqfScrTpHzYXNOd4qh4jf8
   AsVWktVO3nanlYHx7j7FQaUE7i9W2Pm09fpiaGAUY/U0uXYF5DeDy13zC
   ad5SPuP8P3Up/hxsqvr+FeTR88C86mWjUa9d6q0zpvCT+JJUzpJRGUWtA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="302861009"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="302861009"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 18:01:40 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="696111821"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="696111821"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.209.200]) ([10.254.209.200])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 18:01:35 -0700
Message-ID: <cea2094f-72e7-a63d-ddca-86160240db7b@intel.com>
Date:   Fri, 14 Oct 2022 09:01:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3] target/i386: Set maximum APIC ID to KVM prior to vCPU
 creation
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20220825025246.26618-1-guang.zeng@intel.com>
 <2c9d8124-c8f5-5f21-74c5-307e16544143@intel.com>
In-Reply-To: <2c9d8124-c8f5-5f21-74c5-307e16544143@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PING again !
This QEMU patch is to optimize max APIC ID set for current VM session 
introduced since linux v6.0. It's also compatible with previous linux 
version.

Thanks.

On 9/5/2022 9:27 AM, Zeng Guang wrote:
> Kindly PING!
>
> On 8/25/2022 10:52 AM, Zeng Guang wrote:
>> Specify maximum possible APIC ID assigned for current VM session to KVM
>> prior to the creation of vCPUs. By this setting, KVM can set up VM-scoped
>> data structure indexed by the APIC ID, e.g. Posted-Interrupt Descriptor
>> pointer table to support Intel IPI virtualization, with the most optimal
>> memory footprint.
>>
>> It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
>> capability once KVM has enabled it. Ignoring the return error if KVM
>> doesn't support this capability yet.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>    hw/i386/x86.c              | 4 ++++
>>    target/i386/kvm/kvm-stub.c | 5 +++++
>>    target/i386/kvm/kvm.c      | 5 +++++
>>    target/i386/kvm/kvm_i386.h | 1 +
>>    4 files changed, 15 insertions(+)
>>
>> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>> index 050eedc0c8..4831193c86 100644
>> --- a/hw/i386/x86.c
>> +++ b/hw/i386/x86.c
>> @@ -139,6 +139,10 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
>>            exit(EXIT_FAILURE);
>>        }
>>    
>> +    if (kvm_enabled()) {
>> +        kvm_set_max_apic_id(x86ms->apic_id_limit);
>> +    }
>> +
>>        possible_cpus = mc->possible_cpu_arch_ids(ms);
>>        for (i = 0; i < ms->smp.cpus; i++) {
>>            x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
>> diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
>> index f6e7e4466e..e052f1c7b0 100644
>> --- a/target/i386/kvm/kvm-stub.c
>> +++ b/target/i386/kvm/kvm-stub.c
>> @@ -44,3 +44,8 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
>>    {
>>        abort();
>>    }
>> +
>> +void kvm_set_max_apic_id(uint32_t max_apic_id)
>> +{
>> +    return;
>> +}
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index f148a6d52f..af4ef1e8f0 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -5428,3 +5428,8 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
>>            mask &= ~BIT_ULL(bit);
>>        }
>>    }
>> +
>> +void kvm_set_max_apic_id(uint32_t max_apic_id)
>> +{
>> +    kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPU_ID, 0, max_apic_id);
>> +}
>> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
>> index 4124912c20..c133b32a58 100644
>> --- a/target/i386/kvm/kvm_i386.h
>> +++ b/target/i386/kvm/kvm_i386.h
>> @@ -54,4 +54,5 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
>>    bool kvm_enable_sgx_provisioning(KVMState *s);
>>    void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
>>    
>> +void kvm_set_max_apic_id(uint32_t max_apic_id);
>>    #endif
