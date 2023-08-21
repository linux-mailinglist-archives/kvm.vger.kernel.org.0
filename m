Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA777782AA9
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbjHUNhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 09:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjHUNhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 09:37:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF85B4
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 06:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692625054; x=1724161054;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M+ae2WWZJRbnkbrcvS/1ir92dZk28ks8tEhtEglPDk4=;
  b=dgc+cBdgbYSnRDsGyZSjW+Ta9mIYLPWX0uh/iYSrN0I9+gqSM4WrT56C
   2ukdD9BWrqDb9u4QH9n5T3zUHcplN1PnFs2hue0VvmDTW9a+ZbBguEzsr
   pmiQOzDTX1YPhHt07BH1+oPWDDv8c8+XDiANyPx4i+16pCNb3uPh5dOjs
   amB2Fr8mqVthI0eBYKei4IH0YKzE+Nb8iYWZkqYO6iuP1I4zQifFwMprf
   mIcJqDHJVszhy5mEaNrG2ZEAXN7wgS5/m/4D+pFjzoxDuhcOmU0lSldEE
   B26IEJjKzwg17X/M9NJBbRQ8DMUnzzsc9k8TV/zvF9UPez05JeZgo3Bi5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="376340149"
X-IronPort-AV: E=Sophos;i="6.01,190,1684825200"; 
   d="scan'208";a="376340149"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 06:37:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="1066606579"
X-IronPort-AV: E=Sophos;i="6.01,190,1684825200"; 
   d="scan'208";a="1066606579"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 06:37:17 -0700
Message-ID: <e031e715-8962-831f-a56a-935a006b8aa8@intel.com>
Date:   Mon, 21 Aug 2023 21:37:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 03/58] target/i386: Parse TDX vm type
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-4-xiaoyao.li@intel.com> <ZOMf6AMe1ShL3rjC@redhat.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZOMf6AMe1ShL3rjC@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/2023 4:27 PM, Daniel P. Berrangé wrote:
> On Fri, Aug 18, 2023 at 05:49:46AM -0400, Xiaoyao Li wrote:
>> TDX VM requires VM type KVM_X86_TDX_VM to be passed to
>> kvm_ioctl(KVM_CREATE_VM).
>>
>> If tdx-guest object is specified to confidential-guest-support, like,
>>
>>    qemu -machine ...,confidential-guest-support=tdx0 \
>>         -object tdx-guest,id=tdx0,...
>>
>> it parses VM type as KVM_X86_TDX_VM.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/kvm.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 62f237068a3a..77f4772afe6c 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -32,6 +32,7 @@
>>   #include "sysemu/runstate.h"
>>   #include "kvm_i386.h"
>>   #include "sev.h"
>> +#include "tdx.h"
>>   #include "xen-emu.h"
>>   #include "hyperv.h"
>>   #include "hyperv-proto.h"
>> @@ -158,6 +159,7 @@ static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
>>   static const char* vm_type_name[] = {
>>       [KVM_X86_DEFAULT_VM] = "default",
>>       [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
>> +    [KVM_X86_TDX_VM] = "tdx",
>>   };
>>   
>>   int kvm_get_vm_type(MachineState *ms, const char *vm_type)
>> @@ -170,12 +172,18 @@ int kvm_get_vm_type(MachineState *ms, const char *vm_type)
>>               kvm_type = KVM_X86_DEFAULT_VM;
>>           } else if (!g_ascii_strcasecmp(vm_type, "sw-protected-vm")) {
>>               kvm_type = KVM_X86_SW_PROTECTED_VM;
>> -        } else {
>> +        } else if (!g_ascii_strcasecmp(vm_type, "tdx")) {
>> +            kvm_type = KVM_X86_TDX_VM;
>> +        }else {
>>               error_report("Unknown kvm-type specified '%s'", vm_type);
>>               exit(1);
>>           }
>>       }
> 
> This whole block of code should go away - as this should not exist
> as a user visible property. It should be sufficient to use the
> tdx-guest object type to identify use of TDX.
> 

yes, agreed.

It's here because this series is based on the gmem series, which 
introduced property. I'm sorry that I forgot to mention it in the commit 
message.

Next gmem series will drop the implementation of kvm-type property [1] 
and above code will be dropped in next version as well.

[1] 
https://lore.kernel.org/qemu-devel/9b3a3e88-21f4-bfd2-a9c3-60a25832e698@intel.com/


