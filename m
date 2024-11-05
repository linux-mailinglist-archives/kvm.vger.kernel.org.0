Return-Path: <kvm+bounces-30727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 613609BCC11
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 800221C21A12
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29E91D47A8;
	Tue,  5 Nov 2024 11:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fYMasCVn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2A81D45EA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806982; cv=none; b=QR+7YL8nUGZ+gLwFXvCGy88Z1oY9P4gdL3mosew9TnRr+DAzLWEMGRmOK4uC9vfrNOZFE17hZNOL5HJ33n23L+eUPWzPBWws4cVIgGT+ZL21miP/d2dJOqPeB8sCvVh4/QnJ90hfOmOmtkXO8S9uzH1rIYQ15I+MKE8MrURRaBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806982; c=relaxed/simple;
	bh=IuMwbEqHYzNU4b0tImQbyd+xY4ayicHaMmQyrbno1BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NsJfjQQnnqzPtFSMCPhppFN/WJs2e2xPAd9mgygqSSYm0TjWA/6LUo+eJkLI0zjdTw/APSZ4/fOyife4Z7KBDvv0Cz1yo1dz+kZqhv+IDhxgrSd4SUHcD7xNVGC4Lz0skJ3WHJb+8utsl57Lix6onANBklxcoHwBP8mOr5M6HXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fYMasCVn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730806981; x=1762342981;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IuMwbEqHYzNU4b0tImQbyd+xY4ayicHaMmQyrbno1BM=;
  b=fYMasCVndkSLiA2XUxNMQzUXy75z//ziXoaZTSnFSe13/VNdywzbamU6
   t3VTxHpEX8oLXmOQu3FDlZtM87b+n6Q3rkzU+YTjeRKa742n628G0QMCB
   MWsMyF0vXQwGoNkMBc42qcIJCumt8uLSoM9QtfWz7wkMe3oNK2O61dYvv
   XhuHqAmq7Lj5z7AAIEBLZRMFGbZ/vzMNQ488YL8Voz0yhwOC/ZnVDcOJ1
   G4eYCgJtyIo1JBnp6sghwctDkALjhTzsnSnnyBjiRqF052xcd/1QUA/cr
   TXJu2CYxKeERKW/3Xyi6bsw+gIoI7PUgzXE7OPXmonaLHyZN2XgVUxHau
   w==;
X-CSE-ConnectionGUID: 7urFlAEzTtW2tJsknpuZGg==
X-CSE-MsgGUID: HyzX9J9CTxuLOO2VAuQWoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="48056448"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="48056448"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:42:59 -0800
X-CSE-ConnectionGUID: DUnSpACTR1ikFABROsCcJQ==
X-CSE-MsgGUID: SDYmxzbvR3m6ghio/+GE4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="83505350"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:42:55 -0800
Message-ID: <dae753b1-513b-40d8-8393-5c62d1e81f56@intel.com>
Date: Tue, 5 Nov 2024 19:42:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/60] i386: Introduce tdx-guest object
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-3-xiaoyao.li@intel.com> <ZynxD6crcL5Qouhe@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZynxD6crcL5Qouhe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 6:18 PM, Daniel P. Berrangé wrote:
> On Tue, Nov 05, 2024 at 01:23:10AM -0500, Xiaoyao Li wrote:
>> Introduce tdx-guest object which inherits X86_CONFIDENTIAL_GUEST,
>> and will be used to create TDX VMs (TDs) by
>>
>>    qemu -machine ...,confidential-guest-support=tdx0	\
>>         -object tdx-guest,id=tdx0
>>
>> It has one QAPI member 'attributes' defined, which allows user to set
>> TD's attributes directly.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> Acked-by: Markus Armbruster <armbru@redhat.com>
>> ---
>> Chanegs in v6:
>>   - Make tdx-guest inherits X86_CONFIDENTIAL_GUEST;
>>   - set cgs->require_guest_memfd;
>>   - allow attributes settable via QAPI;
>>   - update QAPI version to since 9.2;
>>
>> Changes in v4:
>>   - update the new qapi `since` filed from 8.2 to 9.0
>>
>> Changes in v1
>>   - make @attributes not user-settable
>> ---
>>   configs/devices/i386-softmmu/default.mak |  1 +
>>   hw/i386/Kconfig                          |  5 +++
>>   qapi/qom.json                            | 15 ++++++++
>>   target/i386/kvm/meson.build              |  2 ++
>>   target/i386/kvm/tdx.c                    | 45 ++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h                    | 19 ++++++++++
>>   6 files changed, 87 insertions(+)
>>   create mode 100644 target/i386/kvm/tdx.c
>>   create mode 100644 target/i386/kvm/tdx.h
>>
>> diff --git a/configs/devices/i386-softmmu/default.mak b/configs/devices/i386-softmmu/default.mak
>> index 4faf2f0315e2..bc0479a7e0a3 100644
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
>> index 32818480d263..86bc10377c4f 100644
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
>> index 321ccd708ad1..129b25edf495 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -1008,6 +1008,19 @@
>>               '*host-data': 'str',
>>               '*vcek-disabled': 'bool' } }
>>   
>> +##
>> +# @TdxGuestProperties:
>> +#
>> +# Properties for tdx-guest objects.
>> +#
>> +# @attributes: The 'attributes' of a TD guest that is passed to
>> +#     KVM_TDX_INIT_VM
>> +#
>> +# Since: 9.2
>> +##
> 
> Since QEMU soft-freeze for 9.2 is today, you've missed the
> boat for that. Please update any version tags in this series
> to 10.0, which is the first release of next year.

Noted.

Hope KVM part can get merged not too late. Otherwise, QEMU support will 
land in 10.1, 10.2, or even 11.0.

>> +{ 'struct': 'TdxGuestProperties',
>> +  'data': { '*attributes': 'uint64' } }
>> +
>>   ##
>>   # @ThreadContextProperties:
>>   #
>> @@ -1092,6 +1105,7 @@
>>       'sev-snp-guest',
>>       'thread-context',
>>       's390-pv-guest',
>> +    'tdx-guest',
>>       'throttle-group',
>>       'tls-creds-anon',
>>       'tls-creds-psk',
>> @@ -1163,6 +1177,7 @@
>>                                         'if': 'CONFIG_SECRET_KEYRING' },
>>         'sev-guest':                  'SevGuestProperties',
>>         'sev-snp-guest':              'SevSnpGuestProperties',
>> +      'tdx-guest':                  'TdxGuestProperties',
>>         'thread-context':             'ThreadContextProperties',
>>         'throttle-group':             'ThrottleGroupProperties',
>>         'tls-creds-anon':             'TlsCredsAnonProperties',
>> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
>> index 3996cafaf29f..466bccb9cb17 100644
>> --- a/target/i386/kvm/meson.build
>> +++ b/target/i386/kvm/meson.build
>> @@ -8,6 +8,8 @@ i386_kvm_ss.add(files(
>>   
>>   i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
>>   
>> +i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
>> +
>>   i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>>   
>>   i386_system_ss.add_all(when: 'CONFIG_KVM', if_true: i386_kvm_ss)
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> new file mode 100644
>> index 000000000000..166f53d2b9e3
>> --- /dev/null
>> +++ b/target/i386/kvm/tdx.c
>> @@ -0,0 +1,45 @@
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
> 
> FYI, since KVM Forum we decided that we would prefer newly
> created files to just use SPDX tags for license info.

Thanks for the info. Will update it.

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
>> +                                   X86_CONFIDENTIAL_GUEST,
>> +                                   { TYPE_USER_CREATABLE },
>> +                                   { NULL })
>> +
>> +static void tdx_guest_init(Object *obj)
>> +{
>> +    ConfidentialGuestSupport *cgs = CONFIDENTIAL_GUEST_SUPPORT(obj);
>> +    TdxGuest *tdx = TDX_GUEST(obj);
>> +
>> +    cgs->require_guest_memfd = true;
>> +    tdx->attributes = 0;
>> +
>> +    object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
>> +                                   OBJ_PROP_FLAG_READWRITE);
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
>> index 000000000000..de687457cae6
>> --- /dev/null
>> +++ b/target/i386/kvm/tdx.h
>> @@ -0,0 +1,19 @@
>> +#ifndef QEMU_I386_TDX_H
>> +#define QEMU_I386_TDX_H
> 
> Missing license info.

Will add it.

thanks!

>> +
>> +#include "confidential-guest.h"
>> +
>> +#define TYPE_TDX_GUEST "tdx-guest"
>> +#define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
>> +
>> +typedef struct TdxGuestClass {
>> +    X86ConfidentialGuestClass parent_class;
>> +} TdxGuestClass;
>> +
>> +typedef struct TdxGuest {
>> +    X86ConfidentialGuest parent_obj;
>> +
>> +    uint64_t attributes;    /* TD attributes */
>> +} TdxGuest;
>> +
>> +#endif /* QEMU_I386_TDX_H */
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel


