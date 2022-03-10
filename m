Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451FF4D43EC
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 10:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbiCJJyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 04:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241071AbiCJJyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 04:54:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF0CB2D76
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 01:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646905990; x=1678441990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vWvNGBndoP9u0NnLj5isCC5B+TWZCf6jGCisRxbK9a0=;
  b=h9f0QKKxTpDgQS5EwcONT4BLDP8xyvpegP7oyalnnIjDejGr1o6MIOiS
   UJ2d78px1j0WcowgAyUIwaJ7r1JoFJS93RV1/kx/x7d62WQI6tyHIzff7
   94FwnVHwx/oFA1c//k3vKfNfvQfbJxe9Jobb/FkebjNvcPWcwisjd95P0
   oi1oz+JezuRR1tV8Ja3T4Ta+JWIPXvXWUTM6dwHuVlekVO1rIo4T7VtA1
   ZijOfVdKr71E/PLkQBYfpFoJufXFWVjhWxdUl9fhEnnnXrm5hVcgh4Pxj
   R13EjAPUHpHHjMl65o28A+B7i0+tgyvoFHjaqVmU2Y3Ss2u4XwY87ryyE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="255399382"
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="255399382"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 01:53:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="712299489"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.149]) ([10.238.1.149])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 01:53:07 -0800
Message-ID: <43c55ff9-eab6-7dc5-c634-9817b5a523cd@intel.com>
Date:   Thu, 10 Mar 2022 17:53:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.2
Subject: Re: [PATCH 2/2] i386: Add notify VM exit support
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <20220310090205.10645-1-chenyi.qiang@intel.com>
 <20220310090205.10645-3-chenyi.qiang@intel.com> <YinCH/GbShwG1fRF@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YinCH/GbShwG1fRF@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/10/2022 5:17 PM, Daniel P. Berrangé wrote:
> On Thu, Mar 10, 2022 at 05:02:05PM +0800, Chenyi Qiang wrote:
>> There are cases that malicious virtual machine can cause CPU stuck (due
>> to event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
>> IRQ) can be delivered. It leads the CPU to be unavailable to host or
>> other VMs. Notify VM exit is introduced to mitigate such kind of
>> attacks, which will generate a VM exit if no event window occurs in VM
>> non-root mode for a specified amount of time (notify window).
>>
>> A new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT is exposed to user space
>> so that the user can query the capability and set the expected notify
>> window when creating VMs.
>>
>> If notify VM exit happens with VM_INVALID_CONTEXT, hypervisor should
>> exit to user space with the exit reason KVM_EXIT_NOTIFY to inform the
>> fatal case. Then user space can inject a SHUTDOWN event to the target
>> vcpu. This is implemented by defining a new bit in flags field of
>> kvm_vcpu_event in KVM_SET_VCPU_EVENTS ioctl.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   hw/i386/x86.c         | 24 ++++++++++++++++++
>>   include/hw/i386/x86.h |  3 +++
>>   target/i386/kvm/kvm.c | 58 ++++++++++++++++++++++++++++---------------
>>   3 files changed, 65 insertions(+), 20 deletions(-)
>>
>> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>> index b84840a1bb..25e6c50b1e 100644
>> --- a/hw/i386/x86.c
>> +++ b/hw/i386/x86.c
>> @@ -1309,6 +1309,23 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
>>       qapi_free_SgxEPCList(list);
>>   }
>>   
>> +static void x86_machine_get_notify_window(Object *obj, Visitor *v,
>> +                                const char *name, void *opaque, Error **errp)
>> +{
>> +    X86MachineState *x86ms = X86_MACHINE(obj);
>> +    int32_t notify_window = x86ms->notify_window;
>> +
>> +    visit_type_int32(v, name, &notify_window, errp);
>> +}
>> +
>> +static void x86_machine_set_notify_window(Object *obj, Visitor *v,
>> +                               const char *name, void *opaque, Error **errp)
>> +{
>> +    X86MachineState *x86ms = X86_MACHINE(obj);
>> +
>> +    visit_type_int32(v, name, &x86ms->notify_window, errp);
>> +}
>> +
>>   static void x86_machine_initfn(Object *obj)
>>   {
>>       X86MachineState *x86ms = X86_MACHINE(obj);
>> @@ -1319,6 +1336,7 @@ static void x86_machine_initfn(Object *obj)
>>       x86ms->oem_id = g_strndup(ACPI_BUILD_APPNAME6, 6);
>>       x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
>>       x86ms->bus_lock_ratelimit = 0;
>> +    x86ms->notify_window = -1;
>>   }
> 
> IIUC from the kernel patch, this negative value leaves the protection
> disabled, and thus the host remains vulnerable to the CVE. I would
> expect this ought to set a suitable default value to fix the flaw.
> 

Hum, I missed some explanation in commit message.
We had some discussion about the default behavior of this feature. There 
are some concerns. e.g.
There's a possibility, however small, that a notify VM exit happens
with VM_CONTEXT_INVALID set in exit qualification, which means VM
context is corrupted. To avoid the false positive and a well-behaved
guest gets killed, we decide to make this feature opt-in.

> Regards,
> Daniel
