Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D694E202C
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 06:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344415AbiCUFhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 01:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiCUFhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 01:37:10 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6C010242C
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 22:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647840945; x=1679376945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iorjzoFBCiA3DGnxeiK5iW/hRVMlM2AMh4EOjCZYqO0=;
  b=P+xhxXlJL/6ZRyBANnbg1BvA/xqZdR//0GOl6z0WaaJCaRBgfqtdXNxF
   d3q0i2fHYx4B3YRA1Wc3xLZXCaEy00TCteq2oWZE1Ht+g4WBvZESUOew5
   8+9RFzkbGTQzAP12MM2j7l3solf/T3v1Y+JnyDTsZLq72g8Tqncz33VJt
   fDqeAFyiGGbumIqjZGzfAmCFRnNRcELsmESGPxwSxB+7EFffUmZeESOaE
   mrE2NqXDST8jf5NEpG9tK9sWj2qvQbbHJSxb593yMuqBpr0k2xoobH7/C
   FFKurbrattXACeILH5zwDcAQaAGzWIgBClJnZfYBhAwpwArfcBIyxxYAt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="318182244"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="318182244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 22:35:24 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559708921"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 22:35:18 -0700
Message-ID: <55273e78-d4bb-c15a-2e2e-471b3bfd4719@intel.com>
Date:   Mon, 21 Mar 2022 13:35:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 05/36] i386/tdx: Implement tdx_kvm_init() to
 initialize TDX VM context
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
 <20220317135913.2166202-6-xiaoyao.li@intel.com>
 <20220318020700.GA4006347@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318020700.GA4006347@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/2022 10:07 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:58:42PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> Introduce tdx_kvm_init() and invoke it in kvm_confidential_guest_init()
>> if it's a TDX VM. More initialization will be added later.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/kvm.c       | 15 ++++++---------
>>   target/i386/kvm/meson.build |  2 +-
>>   target/i386/kvm/tdx-stub.c  |  9 +++++++++
>>   target/i386/kvm/tdx.c       | 13 +++++++++++++
>>   target/i386/kvm/tdx.h       |  2 ++
>>   5 files changed, 31 insertions(+), 10 deletions(-)
>>   create mode 100644 target/i386/kvm/tdx-stub.c
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 70454355f3bf..26ed5faf07b8 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -54,6 +54,7 @@
>>   #include "migration/blocker.h"
>>   #include "exec/memattrs.h"
>>   #include "trace.h"
>> +#include "tdx.h"
>>   
>>   //#define DEBUG_KVM
>>   
>> @@ -2360,6 +2361,8 @@ static int kvm_confidential_guest_init(MachineState *ms, Error **errp)
>>   {
>>       if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_SEV_GUEST)) {
>>           return sev_kvm_init(ms->cgs, errp);
>> +    } else if (object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
>> +        return tdx_kvm_init(ms, errp);
>>       }
>>   
>>       return 0;
>> @@ -2374,16 +2377,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>       Error *local_err = NULL;
>>   
>>       /*
>> -     * Initialize SEV context, if required
>> +     * Initialize confidential guest (SEV/TDX) context, if required
>>        *
>> -     * If no memory encryption is requested (ms->cgs == NULL) this is
>> -     * a no-op.
>> -     *
>> -     * It's also a no-op if a non-SEV confidential guest support
>> -     * mechanism is selected.  SEV is the only mechanism available to
>> -     * select on x86 at present, so this doesn't arise, but if new
>> -     * mechanisms are supported in future (e.g. TDX), they'll need
>> -     * their own initialization either here or elsewhere.
>> +     * It's a no-op if a non-SEV/non-tdx confidential guest support
>> +     * mechanism is selected, i.e., ms->cgs == NULL
>>        */
>>       ret = kvm_confidential_guest_init(ms, &local_err);
>>       if (ret < 0) {
>> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
>> index b2d7d41acde2..fd30b93ecec9 100644
>> --- a/target/i386/kvm/meson.build
>> +++ b/target/i386/kvm/meson.build
>> @@ -9,7 +9,7 @@ i386_softmmu_kvm_ss.add(files(
>>   
>>   i386_softmmu_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
>>   
>> -i386_softmmu_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
>> +i386_softmmu_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'), if_false: files('tdx-stub.c'))
>>   
>>   i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>>   
>> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
>> new file mode 100644
>> index 000000000000..1df24735201e
>> --- /dev/null
>> +++ b/target/i386/kvm/tdx-stub.c
>> @@ -0,0 +1,9 @@
>> +#include "qemu/osdep.h"
>> +#include "qemu-common.h"
>> +
>> +#include "tdx.h"
>> +
>> +int tdx_kvm_init(MachineState *ms, Error **errp)
>> +{
>> +    return -EINVAL;
>> +}
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index d3792d4a3d56..e3b94373b316 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -12,10 +12,23 @@
>>    */
>>   
>>   #include "qemu/osdep.h"
>> +#include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>>   
>> +#include "hw/i386/x86.h"
>>   #include "tdx.h"
>>   
>> +int tdx_kvm_init(MachineState *ms, Error **errp)
>> +{
>> +    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
>> +                                                    TYPE_TDX_GUEST);
> 
> The caller already checks it.  This is redundant. Maybe assert?

the cast is to get TdxGuest pointer for later usage. I can move it the 
patch that really uses tdx pointer.

Thanks,
-Xiaoyao

> 

