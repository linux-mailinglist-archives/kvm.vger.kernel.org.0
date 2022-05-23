Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979FC531378
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbiEWPnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 11:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiEWPnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 11:43:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AE925582
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653320598; x=1684856598;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q+ZiO1z9B8ZfHHXuPMSjVYlMGYaRBpz3wImSx3yeLTc=;
  b=k2nVTbmf79PuTq8ApfbCWQpsnz6rApUkYs5d6VTWhK8yf/XZ3GO41K5o
   UPGh6COzRf48MoPQo7EFEsO8pBui7YXH3Bf3Vi3AhhYkWSZr5S7V2LZwk
   c70fpP4nOUcucFGkwYOQHnJNIRwFBeZPfwivsnVZZNTmf5d/gEYgZ29IA
   MDasnQf3uBOnQSoxy5u/xJcmNEzcDQLczIiWE6m4pPILbLkS8r/9RaFvf
   qlk8CtliYDKva6kFXcGEoey/FW4HyybGqbYsrvA6ljzJ2sQ0USMs4yJOM
   ieP1tsgGhm3BfvFpVrvCR46EqwNIdJ2CzoPj1Tsc/Bhaackyi9NBSt/tm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="260865041"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="260865041"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:42:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="600713440"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.127]) ([10.249.171.127])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:42:51 -0700
Message-ID: <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
Date:   Mon, 23 May 2022 23:42:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 11/36] i386/tdx: Initialize TDX before creating TD
 vcpus
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
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
 <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/2022 5:20 PM, Gerd Hoffmann wrote:
>> +int tdx_pre_create_vcpu(CPUState *cpu)
>> +{
>> +    MachineState *ms = MACHINE(qdev_get_machine());
>> +    X86CPU *x86cpu = X86_CPU(cpu);
>> +    CPUX86State *env = &x86cpu->env;
>> +    struct kvm_tdx_init_vm init_vm;
>> +    int r = 0;
>> +
>> +    qemu_mutex_lock(&tdx_guest->lock);
>> +    if (tdx_guest->initialized) {
>> +        goto out;
>> +    }
>> +
>> +    memset(&init_vm, 0, sizeof(init_vm));
>> +    init_vm.cpuid.nent = kvm_x86_arch_cpuid(env, init_vm.entries, 0);
>> +
>> +    init_vm.attributes = tdx_guest->attributes;
>> +    init_vm.max_vcpus = ms->smp.cpus;
>> +
>> +    r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
>> +    if (r < 0) {
>> +        error_report("KVM_TDX_INIT_VM failed %s", strerror(-r));
>> +        goto out;
>> +    }
>> +
>> +    tdx_guest->initialized = true;
>> +
>> +out:
>> +    qemu_mutex_unlock(&tdx_guest->lock);
>> +    return r;
>> +}
> 
> Hmm, hooking *vm* initialization into *vcpu* creation looks wrong to me.

That's because for TDX, it has to do VM-scope (feature) initialization 
before creating vcpu. This is new to KVM and QEMU, that every feature is 
vcpu-scope and configured per-vcpu before.

To minimize the change to QEMU, we want to utilize @cpu and @cpu->env to 
grab the configuration info. That's why it goes this way.

Do you have any better idea on it?

> take care,
>    Gerd
> 

