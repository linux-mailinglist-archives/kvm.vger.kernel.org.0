Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4B5ED2F4
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 04:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiI1CVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 22:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiI1CVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 22:21:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C319F752
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 19:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664331664; x=1695867664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uDN29sYSmcMH5T9cuz/5RBk9La1Uw3+WsHSV0QNg284=;
  b=UZ4+TaRMwb/wxdk4vSygSrnTLmbHLxUYEiEJYf3fs09jA5Tv+SOE0LNZ
   zDst1wptDTX67NRP74Y364X7+LaUYL310vqYV+sZSsmVfrVOiX2dv99SQ
   RjxQ84D8VLKFtNeTQ3Gog85cWyEC/zm8HROGK1sCaRJA5vO5t8uksU8ap
   FtghczXN8GEM+VvShhdzb4fvIZ2vfDvmh64ViBD9APUZms2xNFb7TRv7Y
   d6lMGfDTuFRGK5yu07n/7ELvK9Vgshgv0lqBQjJVLPfWHumeCjAtvGW+f
   cjhXS+Tmw6u9/sqLd63NOOYf6qVzujYADQSzxlJyvYIgFy+FPH4XWH3Mq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="302395237"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="302395237"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 19:21:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="652502843"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="652502843"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.255.29.135]) ([10.255.29.135])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 19:21:01 -0700
Message-ID: <f6caeb4e-82a8-9245-2cb6-22580af559ae@intel.com>
Date:   Wed, 28 Sep 2022 10:20:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH v7 2/2] i386: Add notify VM exit support
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220923073333.23381-1-chenyi.qiang@intel.com>
 <20220923073333.23381-3-chenyi.qiang@intel.com>
 <dc8d4a33-7246-222b-66b5-6ba784fac56e@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <dc8d4a33-7246-222b-66b5-6ba784fac56e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/2022 9:43 PM, Paolo Bonzini wrote:
> On 9/23/22 09:33, Chenyi Qiang wrote:
>> Because there are some concerns, e.g. a notify VM exit may happen with
>> VM_CONTEXT_INVALID set in exit qualification (no cases are anticipated
>> that would set this bit), which means VM context is corrupted. To avoid
>> the false positive and a well-behaved guest gets killed, make this
>> feature disabled by default. Users can enable the feature by a new
>> machine property:
>>      qemu -machine notify_vmexit=on,notify_window=0 ...
> 
> Some comments on the interface:
> 
> - the argument should be one of "run" (i.e. do nothing and continue, the
> default), "internal-error" (i.e. raise a KVM internal error), "disable"
> (i.e. do not enable the capability).  You can add the enum to
> qapi/runstate.json and use object_class_property_add_enum to define
> the QOM property.
> 

So, IIUC, the three options of notify-vmexit would be:
1. run (enable the capability but do nothing if the vmexit happens)
2. internal-error (enable the capability and raise a KVM internal error 
if it happens)
3. disable (do not enable the capability)

For the invalid context case, exit and raise a KVM internal error 
unconditionally.

> - properties should have a dash ("-") in the name, not an underscore
> 
> - the property should be added to "-accel kvm,..." (on x86 only).  See
> after my signature for a preparatory patch that adds a new
> kvm_arch_accel_class_init hook.
> 
> The default would be either "run" or "disable".  Honestly I think it
> should be "run", otherwise there's no point in adding the feature;
> if it is not enabled by default, it is very likely that no one would
> use it.
> 

Yeah, personally speaking, I also prefer to enable it by default. In 
previous KVM patch discussion, we were worried about the buggy silicon 
to cause the invalid context case, which will kill the benign VM. But 
since there is little possibility and we can't tell if it is a false 
positive when it happens. I think default to "run" is acceptable.

>> A new KVM exit reason KVM_EXIT_NOTIFY is defined for notify VM exit. If
>> it happens with VM_INVALID_CONTEXT, hypervisor exits to user space to
>> inform the fatal case. Then user space can inject a SHUTDOWN event to
>> the target vcpu. This is implemented by injecting a sythesized triple
>> fault event.
> 
> I don't think a triple fault is a good match for an event that "should
> not happen" and is the fault of the processor rather than the guest.
> This should be a KVM internal error.  The workaround is to disable the
> notify vmexit.
> 
>> +        warn_report_once("KVM: encounter a notify exit with %svalid 
>> context in"
>> +                         " guest. It means there can be possible 
>> misbehaves in"
>> +                         " guest, please have a look.",
>> +                         ctx_invalid ? "in" : "");
> 
> The warning should be unconditional if the context is invalid.
> 

In valid context case, the warning can also notify the admin that the 
guest misbehaves. Is it necessary to remove it?

>> +    object_class_property_add(oc, X86_MACHINE_NOTIFY_WINDOW, "uint32_t",
> 
> uint32 (not uint32_t)
> 

...

>> +                              x86_machine_get_notify_window,
>> +                              x86_machine_set_notify_window, NULL, 
>> NULL);
>> +    object_class_property_set_description(oc, X86_MACHINE_NOTIFY_WINDOW,
>> +            "Set the notify window required by notify VM exit");
> 
> "Clock cycles without an event window after which a notification VM exit 
> occurs"
> 

Will Fix it. Thanks a lot!

> Thanks,
> 
> Paolo
> 
>  From a5cb704991cfcda19a33c622833b69a8f6928530 Mon Sep 17 00:00:00 2001
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Tue, 27 Sep 2022 15:20:16 +0200
> Subject: [PATCH] kvm: allow target-specific accelerator properties
> 
> Several hypervisor capabilities in KVM are target-specific.  When exposed
> to QEMU users as accelerator properties (i.e. -accel kvm,prop=value), they
> should not be available for all targets.
> 
> Add a hook for targets to add their own properties to -accel kvm; for
> now no such property is defined.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 5acab1767f..f90c5cb285 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3737,6 +3737,8 @@ static void kvm_accel_class_init(ObjectClass *oc, 
> void *data)
>           NULL, NULL);
>       object_class_property_set_description(oc, "dirty-ring-size",
>           "Size of KVM dirty page ring buffer (default: 0, i.e. use 
> bitmap)");
> +
> +    kvm_arch_accel_class_init(oc);
>   }
> 
>   static const TypeInfo kvm_accel_type = {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index efd6dee818..50868ebf60 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -353,6 +353,8 @@ bool kvm_device_supported(int vmfd, uint64_t type);
> 
>   extern const KVMCapabilityInfo kvm_arch_required_capabilities[];
> 
> +void kvm_arch_accel_class_init(ObjectClass *oc);
> +
>   void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run);
>   MemTxAttrs kvm_arch_post_run(CPUState *cpu, struct kvm_run *run);
> 
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index e5c1bd50d2..d21603cf28 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1056,3 +1056,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   {
>       return true;
>   }
> +
> +void kvm_arch_accel_class_init(ObjectClass *oc)
> +{
> +}
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 21880836a6..22b3b37193 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5472,3 +5472,7 @@ void kvm_request_xsave_components(X86CPU *cpu, 
> uint64_t mask)
>           mask &= ~BIT_ULL(bit);
>       }
>   }
> +
> +void kvm_arch_accel_class_init(ObjectClass *oc)
> +{
> +}
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index caf70decd2..bcb8e06b2c 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -1294,3 +1294,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   {
>       return true;
>   }
> +
> +void kvm_arch_accel_class_init(ObjectClass *oc)
> +{
> +}
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 466d0d2f4c..7c25348b7b 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2966,3 +2966,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   {
>       return true;
>   }
> +
> +void kvm_arch_accel_class_init(ObjectClass *oc)
> +{
> +}
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 70b4cff06f..30f21453d6 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -532,3 +532,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   {
>       return true;
>   }
> +
> +void kvm_arch_accel_class_init(ObjectClass *oc)
> +{
> +}
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 7bd8db0e7b..840af34576 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2574,3 +2574,7 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   {
>       return true;
>   }
> +
> +void kvm_arch_accel_class_init(ObjectClass *oc)
> +{
> +}
> 
