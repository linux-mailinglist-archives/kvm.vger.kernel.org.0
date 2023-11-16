Return-Path: <kvm+bounces-1875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 318E87EDB7D
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 07:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C8A81C20950
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 06:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE09EFBF5;
	Thu, 16 Nov 2023 06:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HS2cU+s7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F34199
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 22:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700115738; x=1731651738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gChZ8kXGSnsMJ49nAHlrxMAXv6e+y+3woeR6B7wkO4Q=;
  b=HS2cU+s7rNiIcw3+uihBZNR4NhDxQgLfhDgeaCzl7GJtux3Y1L83GqnG
   gSghW0SKUIp5js7NM/SdYCKxYN29uhyBIxjVxKzzSryjGTRT9MtfnuYHf
   KqxUGlwVYXY7i6Uz3K6yqKwMjsIF8PEECaM4/ktZifuqjPZL7HQPrpC3U
   xa9+7aKRRCPHXY9JFUKoJ1b+eUX318floZbaW5mPeUonlukovxbA7izmr
   Qb43IR2Qj3W2fMbG2giPwvm+9doXo5oH5QSGLkFbqQLnvC41/D3NC9jyR
   hOlRWRrEMFX2zbcKMTtwg2s0S+p1+KGBVNKOOnZFV2SarNeBfsSNm78J7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="381420404"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="381420404"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 22:22:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="765209370"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="765209370"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 22:22:11 -0800
Message-ID: <ce253f32-4e53-41e3-92e5-3c81078002a1@intel.com>
Date: Thu, 16 Nov 2023 14:22:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/70] target/i386: Implement mc->kvm_type() to get VM
 type
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-15-xiaoyao.li@intel.com>
 <ZVSiSygaFI41vze9@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZVSiSygaFI41vze9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/2023 6:49 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 15, 2023 at 02:14:23AM -0500, Xiaoyao Li wrote:
>> Implement mc->kvm_type() for i386 machines. It provides a way for user
>> to create SW_PROTECTE_VM.
> 
> Small typo there missing final 'D' in 'PROTECTED'

Thanks for catching it.

I find the "PROTECTED_VM" part is the leftover of previous series. Since 
this version drop the "protected-vm" part, it should be fall back the 
earlier version like 
https://lore.kernel.org/qemu-devel/20220802074750.2581308-4-xiaoyao.li@intel.com/

I will merge next patch into this one, in next version.

>>
>> Also store the vm_type in machinestate to other code to query what the
>> VM type is.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   hw/i386/x86.c              | 12 ++++++++++++
>>   include/hw/i386/x86.h      |  1 +
>>   target/i386/kvm/kvm.c      | 25 +++++++++++++++++++++++++
>>   target/i386/kvm/kvm_i386.h |  1 +
>>   4 files changed, 39 insertions(+)
>>
>> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>> index b3d054889bba..55678279bf3b 100644
>> --- a/hw/i386/x86.c
>> +++ b/hw/i386/x86.c
>> @@ -1377,6 +1377,17 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
>>       qapi_free_SgxEPCList(list);
>>   }
>>   
>> +static int x86_kvm_type(MachineState *ms, const char *vm_type)
>> +{
>> +    X86MachineState *x86ms = X86_MACHINE(ms);
>> +    int kvm_type;
>> +
>> +    kvm_type = kvm_get_vm_type(ms, vm_type);
>> +    x86ms->vm_type = kvm_type;
>> +
>> +    return kvm_type;
>> +}
>> +
>>   static void x86_machine_initfn(Object *obj)
>>   {
>>       X86MachineState *x86ms = X86_MACHINE(obj);
>> @@ -1401,6 +1412,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
>>       mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
>>       mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
>>       mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
>> +    mc->kvm_type = x86_kvm_type;
>>       x86mc->save_tsc_khz = true;
>>       x86mc->fwcfg_dma_enabled = true;
>>       nc->nmi_monitor_handler = x86_nmi;
>> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
>> index da19ae15463a..ab1d38569019 100644
>> --- a/include/hw/i386/x86.h
>> +++ b/include/hw/i386/x86.h
>> @@ -41,6 +41,7 @@ struct X86MachineState {
>>       MachineState parent;
>>   
>>       /*< public >*/
>> +    unsigned int vm_type;
>>   
>>       /* Pointers to devices and objects: */
>>       ISADevice *rtc;
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index b4b9ce89842f..2e47fda25f95 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -161,6 +161,31 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
>>   static RateLimit bus_lock_ratelimit_ctrl;
>>   static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
>>   
>> +static const char* vm_type_name[] = {
> 
> nitpick   'char *vm_type_name[]', is normal style

will fix it. Thanks!

>> +    [KVM_X86_DEFAULT_VM] = "default",
>> +    [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
>> +};
>> +
>> +int kvm_get_vm_type(MachineState *ms, const char *vm_type)
>> +{
>> +    int kvm_type = KVM_X86_DEFAULT_VM;
>> +
>> +    /*
>> +     * old KVM doesn't support KVM_CAP_VM_TYPES and KVM_X86_DEFAULT_VM
>> +     * is always supported
>> +     */
>> +    if (kvm_type == KVM_X86_DEFAULT_VM) {
>> +        return kvm_type;
>> +    }
>> +
>> +    if (!(kvm_check_extension(KVM_STATE(ms->accelerator), KVM_CAP_VM_TYPES) & BIT(kvm_type))) {
>> +        error_report("vm-type %s not supported by KVM", vm_type_name[kvm_type]);
>> +        exit(1);
>> +    }
>> +
>> +    return kvm_type;
>> +}
>> +
>>   bool kvm_has_smm(void)
>>   {
>>       return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
>> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
>> index 30fedcffea3e..55fb25fa8e2e 100644
>> --- a/target/i386/kvm/kvm_i386.h
>> +++ b/target/i386/kvm/kvm_i386.h
>> @@ -37,6 +37,7 @@ bool kvm_hv_vpindex_settable(void);
>>   bool kvm_enable_sgx_provisioning(KVMState *s);
>>   bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
>>   
>> +int kvm_get_vm_type(MachineState *ms, const char *vm_type);
>>   void kvm_arch_reset_vcpu(X86CPU *cs);
>>   void kvm_arch_after_reset_vcpu(X86CPU *cpu);
>>   void kvm_arch_do_init_vcpu(X86CPU *cs);
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel


