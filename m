Return-Path: <kvm+bounces-11304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0A787510B
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 14:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65E7D28CAC6
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 13:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE84312D744;
	Thu,  7 Mar 2024 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dwVVHwsY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC515F86B
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709819784; cv=none; b=Kivu9y5DAhPo6V+aG/VeJMcGurv73jtxXu5qRt9oYD5GTXKTOlhz1TB5tFHhDAXbLYg8Om7bwRGgUvASSVSX8ehsPAXNI5z8oRipgbPuQnw2Jv9qooC3bw9axRRKoRUQI71jo50Oy4yb0D50F5hPtPOPJs1Z3A1i1zDHQsD0gKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709819784; c=relaxed/simple;
	bh=TL28DIDonAWW1PTseFRK4e69qaMPCqvqMINdIwZSmuo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fhHVH0V1gy26hI46qrMP/VMkGTB/y5Ggv9vxnwmIQcNYRwG/JzPP1zsw0REaKILnKPRDYzlqBlC89DNBwYZtY1Zn2tQXs2RYYEkd9ExNtya/uW1ljsoc+Lef5SIBfXaPRWoUCqzb5QnJaF7aQMTVhl4DvyfhiGNXtw7L8nTzSUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dwVVHwsY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709819780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8cvkgaBtTuoC3Wc+2TSS7zKm5F0tiDeYXB0fHBJZoHc=;
	b=dwVVHwsY1f/ZgZb97Pp15M8q0ZQN+OA+gCaynGYmy5A5wXiilJ6KXphzSvHnKcVasRz/bG
	0GlvxG2OfDmvP4IJg0Me+Xm33C3Bl8QcSjghkSadJ5lR/d0EQwBVQPntOzbSPFfDEcn1QM
	iayqVoAmpGS8qRWIPU9BcXLofOvmMwE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-ujLVtXAtM5ufl9nioQN28g-1; Thu,
 07 Mar 2024 08:56:17 -0500
X-MC-Unique: ujLVtXAtM5ufl9nioQN28g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95AF41E441D5;
	Thu,  7 Mar 2024 13:56:16 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F4C017A96;
	Thu,  7 Mar 2024 13:56:16 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4030821E6A24; Thu,  7 Mar 2024 14:56:15 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Peter Xu <peterx@redhat.com>,  Cornelia Huck
 <cohuck@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric
 Blake <eblake@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  kvm@vger.kernel.org,  qemu-devel@nongnu.org,  Michael Roth
 <michael.roth@amd.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd
 Hoffmann <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,
  Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 30/65] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
In-Reply-To: <0f3df4b7-ffb9-4fc5-90eb-8a1d6fea5786@intel.com> (Xiaoyao Li's
	message of "Thu, 7 Mar 2024 19:24:04 +0800")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-31-xiaoyao.li@intel.com>
	<87edcv1x9j.fsf@pond.sub.org>
	<f9774e89-399c-42ad-8fa8-dd4050ee46da@intel.com>
	<871q8vxuzx.fsf@pond.sub.org>
	<4602df24-029e-4a40-bdec-1b0a6aa30a3c@intel.com>
	<87v85yv3j9.fsf@pond.sub.org>
	<0f3df4b7-ffb9-4fc5-90eb-8a1d6fea5786@intel.com>
Date: Thu, 07 Mar 2024 14:56:15 +0100
Message-ID: <87ttli87sw.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 3/7/2024 4:39 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>=20
>>> On 2/29/2024 9:25 PM, Markus Armbruster wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> On 2/29/2024 4:37 PM, Markus Armbruster wrote:
>>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>>
>>>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>>
>>>>>>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of=
 a TD
>>>>>>> can be provided for TDX attestation. Detailed meaning of them can be
>>>>>>> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4=
813f4e0ff92@intel.com/
>>>>>>>
>>>>>>> Allow user to specify those values via property mrconfigid, mrowner=
 and
>>>>>>> mrownerconfig. They are all in base64 format.
>>>>>>>
>>>>>>> example
>>>>>>> -object tdx-guest, \
>>>>>>>      mrconfigid=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0Vni=
avN7wEjRWeJq83v,\
>>>>>>>      mrowner=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN=
7wEjRWeJq83v,\
>>>>>>>      mrownerconfig=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0=
VniavN7wEjRWeJq83v
>>>>>>>
>>>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> [...]
>>>>
>>>>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>>>>> index 89ed89b9b46e..cac875349a3a 100644
>>>>>>> --- a/qapi/qom.json
>>>>>>> +++ b/qapi/qom.json
>>>>>>> @@ -905,10 +905,25 @@
>>>>>>>    #     pages.  Some guest OS (e.g., Linux TD guest) may require t=
his to
>>>>>>>    #     be set, otherwise they refuse to boot.
>>>>>>>    #
>>>>>>> +# @mrconfigid: ID for non-owner-defined configuration of the guest=
 TD,
>>>>>>> +#     e.g., run-time or OS configuration (base64 encoded SHA384 di=
gest).
>>>>>>> +#     (A default value 0 of SHA384 is used when absent).
>>>>>>
>>>>>> Suggest to drop the parenthesis in the last sentence.
>>>>>>
>>>>>> @mrconfigid is a string, so the default value can't be 0.  Actually,
>>>>>> it's not just any string, but a base64 encoded SHA384 digest, which
>>>>>> means it must be exactly 96 hex digits.  So it can't be "0", either.=
  It
>>>>>> could be
>>>>>> "0000000000000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000".
>>>>>
>>>>> I thought value 0 of SHA384 just means it.
>>>>>
>>>>> That's my fault and my poor english.
>>>>
>>>> "Fault" is too harsh :)  It's not as precise as I want our interface
>>>> documentation to be.  We work together to get there.
>>>>
>>>>>> More on this below.
>>>>>>
>>>>>>> +#
>>>>>>> +# @mrowner: ID for the guest TD=E2=80=99s owner (base64 encoded SH=
A384 digest).
>>>>>>> +#     (A default value 0 of SHA384 is used when absent).
>>>>>>> +#
>>>>>>> +# @mrownerconfig: ID for owner-defined configuration of the guest =
TD,
>>>>>>> +#     e.g., specific to the workload rather than the run-time or OS
>>>>>>> +#     (base64 encoded SHA384 digest). (A default value 0 of SHA384=
 is
>>>>>>> +#     used when absent).
>>>>>>> +#
>>>>>>>    # Since: 9.0
>>>>>>>    ##
>>>>>>>    { 'struct': 'TdxGuestProperties',
>>>>>>> -  'data': { '*sept-ve-disable': 'bool' } }
>>>>>>> +  'data': { '*sept-ve-disable': 'bool',
>>>>>>> +            '*mrconfigid': 'str',
>>>>>>> +            '*mrowner': 'str',
>>>>>>> +            '*mrownerconfig': 'str' } }
>>>>>>>    ##
>>>>>>>    # @ThreadContextProperties:
>>>>>>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>>>>>>> index d0ad4f57b5d0..4ce2f1d082ce 100644
>>>>>>> --- a/target/i386/kvm/tdx.c
>>>>>>> +++ b/target/i386/kvm/tdx.c
>>>>>>> @@ -13,6 +13,7 @@
>>>>>>>    #include "qemu/osdep.h"
>>>>>>>    #include "qemu/error-report.h"
>>>>>>> +#include "qemu/base64.h"
>>>>>>>    #include "qapi/error.h"
>>>>>>>    #include "qom/object_interfaces.h"
>>>>>>>    #include "standard-headers/asm-x86/kvm_para.h"
>>>>>>> @@ -516,6 +517,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **=
errp)
>>>>>>>        X86CPU *x86cpu =3D X86_CPU(cpu);
>>>>>>>        CPUX86State *env =3D &x86cpu->env;
>>>>>>>        g_autofree struct kvm_tdx_init_vm *init_vm =3D NULL;
>>>>>>> +    size_t data_len;
>>>>>>>        int r =3D 0;
>>>>>>>        object_property_set_bool(OBJECT(cpu), "pmu", false, &error_a=
bort);
>>>>>>> @@ -528,6 +530,38 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error *=
*errp)
>>>>>>>        init_vm =3D g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>>>>>>                            sizeof(struct kvm_cpuid_entry2) * KVM_MA=
X_CPUID_ENTRIES);
>>>>>>> +#define SHA384_DIGEST_SIZE  48
>>>>>>> +
>>>>>>> +    if (tdx_guest->mrconfigid) {
>>>>>>> +        g_autofree uint8_t *data =3D qbase64_decode(tdx_guest->mrc=
onfigid,
>>>>>>> +                              strlen(tdx_guest->mrconfigid), &data=
_len, errp);
>>>>>>> +        if (!data || data_len !=3D SHA384_DIGEST_SIZE) {
>>>>>>> +            error_setg(errp, "TDX: failed to decode mrconfigid");
>>>>>>> +            return -1;
>>>>>>> +        }
>>>>>>> +        memcpy(init_vm->mrconfigid, data, data_len);
>>>>>>> +    }
>>>>>>
>>>>>> When @mrconfigid is absent, the property remains null, and this
>>>>>> conditional is not executed.  init_vm->mrconfigid[], an array of 6
>>>>>> __u64, remains all zero.  How does the kernel treat that?
>>>>>
>>>>> A all-zero SHA384 value is still a valid value, isn't it?
>>>>>
>>>>> KVM treats it with no difference.
>>>>
>>>> Can you point me to the spot in the kernel where mrconfigid is used?
>>>
>>> https://github.com/intel/tdx/blob/66a10e258636fa8ec9f5ce687607bf2196a92=
341/arch/x86/kvm/vmx/tdx.c#L2322
>>>
>>> KVM just copy what QEMU provides into its own data structure @td_params=
. The format @of td_params is defined by TDX spec, and @td_params needs to =
be passed to TDX module when initialize the context of TD via SEAMCALL(TDH.=
MNG.INIT): https://github.com/intel/tdx/blob/66a10e258636fa8ec9f5ce687607bf=
2196a92341/arch/x86/kvm/vmx/tdx.c#L2450
>>>
>>>
>>> In fact, all the three SHA384 fields, will be hashed together with some=
 other fields (in td_params and other content of TD) to compromise the init=
ial measurement of TD.
>>>
>>> TDX module doesn't care the value of td_params->mrconfigid.
>>
>> My problem is that I don't understand when and why users would omit the
>> optional @mrFOO.
>
> When users don't care it and don't have an explicit value for them, they =
can omit it. Then a default all-zero value is used.
>
> If making it mandatory field, then users have to explicit pass a all-zero=
 value when they don't care it.
>
>> I naively expected absent @mrFOO to mean something like "no attestation
>> of FOO".
>>
>> But I see that they default to
>> "00000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000".
>>
>> If this zero value is special and means "no attestation", then we
>> accidentally get no attestation when whatever is being hashed happens to
>> hash to this zero value.  Unlikely, but possible.
>>
>> If it's not special, then when and why is the ability to omit it useful?
>
> At some point, the zero value is special, because it is the default value=
 if no explicit one provided by user. But for TDX point of view, it is not =
special. The field is a must for any TD, and whatever value it is, it will =
be hashed into MRTD (Build-time Measurement Register) for later attestation.
>
> TDX architecture defines what fields are always hashed into measurement a=
nd also provide other mechanism to hash optional field into measurement. Al=
l this is known to users of TDX, and users can calculate the final measurem=
ent by itself and compare to what gets reported by TDX to see they are iden=
tical.
>
> For these three fields, they are must-to-have fields to be hashed into me=
asurement. For user's convenience, we don't want to make it mandatory input=
 because not everyone cares it and have a specific value to input.
> What people needs to know is that, when no explicit value is provided for=
 these three field, a all-zero value is used.

Alright, the doc comment is not the place to educate me about TDX.
Perhaps we can go with

# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
#     Defaults to all zeroes.


