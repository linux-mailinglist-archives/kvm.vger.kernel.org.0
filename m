Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003B9785175
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 09:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbjHWH1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 03:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjHWH1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 03:27:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473E0FB
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 00:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692775634; x=1724311634;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LBXTYANtONjYsEHm3f+upjKiDNW0J9OQ8YriJ7CuYFU=;
  b=UbKBxYr4Dh+rJEpSxEwROzCVbcci/eiQUKVM277IIXjhXInjJeJIFm6O
   ovxUzdjq7bFgTWwXX+h5+ibxFY1ap3HWfNSVSDXsjC2g73ayv0DYZeNrw
   s5WFgqXUEm16YYC2GmEXMchM2vjCcHoxD1ib8H4QKiVXd8GFP+GxGP8zI
   FCxfid4MW7ER4CqAmetMX99DD72DsCcJMt4tB2Snnezi5UuvLkyP/iHZg
   Hu0/+ksdPAo/sUlRqi3WgikEENJ8T+S8hvAE2ti59PhX5u2Oa47GBJt5i
   t6eUtNOIiTvRBTVQXyUS+tcVv0wiOXs29/TGAFBzqM54/7rcqvHaZ/me4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="460457787"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="460457787"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 00:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="713475381"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="713475381"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 00:27:06 -0700
Message-ID: <a94957f6-cde2-c5ac-0391-d1df245dc25f@intel.com>
Date:   Wed, 23 Aug 2023 15:27:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 02/58] i386: Introduce tdx-guest object
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-3-xiaoyao.li@intel.com> <87bkez7g0g.fsf@pond.sub.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87bkez7g0g.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/2023 2:22 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Introduce tdx-guest object which implements the interface of
>> CONFIDENTIAL_GUEST_SUPPORT, and will be used to create TDX VMs (TDs) by
>>
>>    qemu -machine ...,confidential-guest-support=tdx0	\
>>         -object tdx-guset,id=tdx0
> 
> Typo: tdx-guest

Will fix it.

>> It has only one property 'attributes' with fixed value 0 and not
>> configurable so far.
> 
> This must refer to TdxGuest member @attributes.
> 
> "Property" suggests QOM property, which @attributes isn't, at least not
> in this patch.  Will it become a QOM property later in this series?

At least not in this series. Maybe in the future there is request to 
directly configure the whole attributes via QOM property, but none from now.

I will change the description of it to avoid confusion.

> Hmm, @attributes appears to remain unused until PATCH 14.  Recommend to
> delay its addition until then.

IMHO, it's not suitable to introduce it in patch 14. Using a separate 
patch seems unnecessary. I'll leave it in this patch unless strong 
objection on it.

>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>> changes from RFC-V4
>> - make @attributes not user-settable
>> ---
>>   configs/devices/i386-softmmu/default.mak |  1 +
>>   hw/i386/Kconfig                          |  5 +++
>>   qapi/qom.json                            | 12 +++++++
>>   target/i386/kvm/meson.build              |  2 ++
>>   target/i386/kvm/tdx.c                    | 40 ++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h                    | 19 +++++++++++
>>   6 files changed, 79 insertions(+)
>>   create mode 100644 target/i386/kvm/tdx.c
>>   create mode 100644 target/i386/kvm/tdx.h
>>
>> diff --git a/configs/devices/i386-softmmu/default.mak b/configs/devices/i386-softmmu/default.mak
>> index 598c6646dfc0..9b5ec59d65b0 100644
>> --- a/configs/devices/i386-softmmu/default.mak
>> +++ b/configs/devices/i386-softmmu/default.mak
>> @@ -18,6 +18,7 @@
>>   #CONFIG_QXL=n
>>   #CONFIG_SEV=n
>>   #CONFIG_SGA=n
>> +#CONFIG_TDX=n
>>   #CONFIG_TEST_DEVICES=n
>>   #CONFIG_TPM_CRB=n
>>   #CONFIG_TPM_TIS_ISA=n
>> diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
>> index 9051083c1e78..929f6c3f0e85 100644
>> --- a/hw/i386/Kconfig
>> +++ b/hw/i386/Kconfig
>> @@ -10,6 +10,10 @@ config SGX
>>       bool
>>       depends on KVM
>>   
>> +config TDX
>> +    bool
>> +    depends on KVM
>> +
>>   config PC
>>       bool
>>       imply APPLESMC
>> @@ -26,6 +30,7 @@ config PC
>>       imply QXL
>>       imply SEV
>>       imply SGX
>> +    imply TDX
>>       imply TEST_DEVICES
>>       imply TPM_CRB
>>       imply TPM_TIS_ISA
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index e0b2044e3d20..2ca7ce7c0da5 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -866,6 +866,16 @@
>>               'reduced-phys-bits': 'uint32',
>>               '*kernel-hashes': 'bool' } }
>>   
>> +##
>> +# @TdxGuestProperties:
>> +#
>> +# Properties for tdx-guest objects.
>> +#
>> +# Since: 8.2
>> +##
>> +{ 'struct': 'TdxGuestProperties',
>> +  'data': { }}
>> +
>>   ##
>>   # @ThreadContextProperties:
>>   #
>> @@ -944,6 +954,7 @@
>>       'sev-guest',
>>       'thread-context',
>>       's390-pv-guest',
>> +    'tdx-guest',
>>       'throttle-group',
>>       'tls-creds-anon',
>>       'tls-creds-psk',
>> @@ -1010,6 +1021,7 @@
>>         'secret_keyring':             { 'type': 'SecretKeyringProperties',
>>                                         'if': 'CONFIG_SECRET_KEYRING' },
>>         'sev-guest':                  'SevGuestProperties',
>> +      'tdx-guest':                  'TdxGuestProperties',
>>         'thread-context':             'ThreadContextProperties',
>>         'throttle-group':             'ThrottleGroupProperties',
>>         'tls-creds-anon':             'TlsCredsAnonProperties',
> 
> Actually useful only when CONFIG_TDX is on, but can't make it
> conditional here, as CONFIG_TDX is poisoned.

In fact, I just followed what SEV did.

To me, it looks OK to make it conditional on CONFIG_TDX. Could you 
please elaborate "but can't make it conditional here, as CONFIG_TDX is 
poisoned." ?


>> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
>> index 40fbde96cac6..21ab03fe1349 100644
>> --- a/target/i386/kvm/meson.build
>> +++ b/target/i386/kvm/meson.build
>> @@ -11,6 +11,8 @@ i386_softmmu_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
>>   
>>   i386_softmmu_kvm_ss.add(when: 'CONFIG_SEV', if_false: files('sev-stub.c'))
>>   
>> +i386_softmmu_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
>> +
>>   i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>>   
>>   i386_system_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> new file mode 100644
>> index 000000000000..d3792d4a3d56
>> --- /dev/null
>> +++ b/target/i386/kvm/tdx.c
>> @@ -0,0 +1,40 @@
>> +/*
>> + * QEMU TDX support
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Xiaoyao Li <xiaoyao.li@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qom/object_interfaces.h"
>> +
>> +#include "tdx.h"
>> +
>> +/* tdx guest */
>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
>> +                                   tdx_guest,
>> +                                   TDX_GUEST,
>> +                                   CONFIDENTIAL_GUEST_SUPPORT,
>> +                                   { TYPE_USER_CREATABLE },
>> +                                   { NULL })
>> +
>> +static void tdx_guest_init(Object *obj)
>> +{
>> +    TdxGuest *tdx = TDX_GUEST(obj);
>> +
>> +    tdx->attributes = 0;
>> +}
>> +
>> +static void tdx_guest_finalize(Object *obj)
>> +{
>> +}
>> +
>> +static void tdx_guest_class_init(ObjectClass *oc, void *data)
>> +{
>> +}
>> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
>> new file mode 100644
>> index 000000000000..415aeb5af746
>> --- /dev/null
>> +++ b/target/i386/kvm/tdx.h
>> @@ -0,0 +1,19 @@
>> +#ifndef QEMU_I386_TDX_H
>> +#define QEMU_I386_TDX_H
>> +
>> +#include "exec/confidential-guest-support.h"
>> +
>> +#define TYPE_TDX_GUEST "tdx-guest"
>> +#define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
>> +
>> +typedef struct TdxGuestClass {
>> +    ConfidentialGuestSupportClass parent_class;
>> +} TdxGuestClass;
>> +
>> +typedef struct TdxGuest {
>> +    ConfidentialGuestSupport parent_obj;
>> +
>> +    uint64_t attributes;    /* TD attributes */
>> +} TdxGuest;
>> +
>> +#endif /* QEMU_I386_TDX_H */
> 
> QAPI schema
> Acked-by: Markus Armbruster <armbru@redhat.com>

Thank you!


