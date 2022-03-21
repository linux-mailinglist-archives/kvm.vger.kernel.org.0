Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26944E20CC
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 07:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344661AbiCUG5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 02:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344643AbiCUG5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 02:57:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4594F24587
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 23:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647845774; x=1679381774;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nhvADs+tynBIlqMFJkoupURGmVmdXZA4EkmDJ1XRbig=;
  b=XJVI5tY20Fdd++bo8e3NtpcyOO/IUZbKJJHBMhwjmdVtr9TS+DWJAtTN
   pdojyo+z6xrWqVZejJYAmchnJTg5qMLJBtPeAWslyxBAD3QdVKtyktXO+
   z/WnOhliUH13zcc+OHw2azAI3sfLSM7+0kANm2tOqez8AX/UmIff2mnH/
   sOo2L2ldjSBj49aBNYgGgXuBGld+joak5ALybMGbgXQr8qHdZyRP+Y48J
   gqlRS8rAzwcFd3ivNax5ITP930G8efNawuTg5CzV9NnII/UQHyZPSkCeF
   ACcVrpDmqBOWYpZYMhlOL2rdN7YOsI0OcPwvs1SvOOQxRvUggjZA8PWhG
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="244955932"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="244955932"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:56:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559734025"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:56:08 -0700
Message-ID: <680200c2-d0c5-d36b-c88e-4721bab63443@intel.com>
Date:   Mon, 21 Mar 2022 14:56:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 06/36] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
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
 <20220317135913.2166202-7-xiaoyao.li@intel.com>
 <20220318020838.GB4006347@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318020838.GB4006347@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/2022 10:08 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:58:43PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index e3b94373b316..bed337e5ba18 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -14,10 +14,77 @@
>>   #include "qemu/osdep.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>> +#include "sysemu/kvm.h"
>>   
>>   #include "hw/i386/x86.h"
>>   #include "tdx.h"
>>   
>> +enum tdx_ioctl_level{
>> +    TDX_VM_IOCTL,
>> +    TDX_VCPU_IOCTL,
>> +};
>> +
>> +static int __tdx_ioctl(void *state, enum tdx_ioctl_level level, int cmd_id,
>> +                        __u32 metadata, void *data)
>> +{
>> +    struct kvm_tdx_cmd tdx_cmd;
>> +    int r;
>> +
>> +    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
>> +
>> +    tdx_cmd.id = cmd_id;
>> +    tdx_cmd.metadata = metadata;
>> +    tdx_cmd.data = (__u64)(unsigned long)data;
>> +
>> +    switch (level) {
>> +    case TDX_VM_IOCTL:
>> +        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
>> +        break;
>> +    case TDX_VCPU_IOCTL:
>> +        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
>> +        break;
>> +    default:
>> +        error_report("Invalid tdx_ioctl_level %d", level);
>> +        exit(1);
>> +    }
>> +
>> +    return r;
>> +}
>> +
>> +#define tdx_vm_ioctl(cmd_id, metadata, data) \
>> +        __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, metadata, data)
>> +
>> +#define tdx_vcpu_ioctl(cpu, cmd_id, metadata, data) \
>> +        __tdx_ioctl(cpu, TDX_VCPU_IOCTL, cmd_id, metadata, data)
> 
> No point to use macro.  Normal (inline) function can works.
> 

OK. Will change it to inline function.
