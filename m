Return-Path: <kvm+bounces-10494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D7A86CA35
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 167602871E1
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D927E585;
	Thu, 29 Feb 2024 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHVgm8Ma"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F91B7E56E
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 13:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709213145; cv=none; b=nKDsh/t9HIgvB4muZKT3qLvtjKBtDEGh4uObSNXDM/sKv3DopVir03SBU1tjn+BjHuhXu+ssFabhLNplE/+EhbjyVNE/tsS0AYc0dKIXv+/WqlTBe5+7raz4h+exPXffvDs3YX4AX+T/Ltw3KF9vcpawnLAPS+2uGcP7hTp1ToY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709213145; c=relaxed/simple;
	bh=K7XLUgmbiQBXMGieSRzoY2/OaTAuVjqOGXnK3PWq++0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gEuNhd4+NF60z4hNxwHfTjIY2os+Ng0p8QKDk3zPEBoUGiCtL7nLVioCLLzPdrTm5vhceVwqzey4a1jYc7FUIVy3tOqYa8pJpO0lfRbBhKl2Z+2nj2VxCdO/KylrddAIkL2f8FZsnBa/F+YZJM2UXwc9vi5YF4AeWWZSDSvcYI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jHVgm8Ma; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709213142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/Hl7pQ4Z4cAY4nx3F9i8aXSpaP1bJtS2DoSDq1LRJE=;
	b=jHVgm8Mawn//j/2Y6qmAUgn8eqKXfAqbg+w7wf+ExPx8/HxTn8WeERy3cds/fGM2EkRwJg
	0uRvoib1smE+qk6XA4zJCbIiaLaxsH929z4XAH8mO9A58nrP2woo3kCMoFH+kWQbqCkduv
	4omfe3v5G1dN1jPS6TO3P3npRtsIdb0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-ZclP6RS-O9GnLwQcZBTHtw-1; Thu, 29 Feb 2024 08:25:40 -0500
X-MC-Unique: ZclP6RS-O9GnLwQcZBTHtw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B644083106C;
	Thu, 29 Feb 2024 13:25:39 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31CC01121312;
	Thu, 29 Feb 2024 13:25:39 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 34C4921E6740; Thu, 29 Feb 2024 14:25:38 +0100 (CET)
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
In-Reply-To: <f9774e89-399c-42ad-8fa8-dd4050ee46da@intel.com> (Xiaoyao Li's
	message of "Thu, 29 Feb 2024 18:50:04 +0800")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-31-xiaoyao.li@intel.com>
	<87edcv1x9j.fsf@pond.sub.org>
	<f9774e89-399c-42ad-8fa8-dd4050ee46da@intel.com>
Date: Thu, 29 Feb 2024 14:25:38 +0100
Message-ID: <871q8vxuzx.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 2/29/2024 4:37 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>=20
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
>>> can be provided for TDX attestation. Detailed meaning of them can be
>>> found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f=
4e0ff92@intel.com/
>>>
>>> Allow user to specify those values via property mrconfigid, mrowner and
>>> mrownerconfig. They are all in base64 format.
>>>
>>> example
>>> -object tdx-guest, \
>>>    mrconfigid=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wE=
jRWeJq83v,\
>>>    mrowner=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRW=
eJq83v,\
>>>    mrownerconfig=3DASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN=
7wEjRWeJq83v
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

[...]

>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>> index 89ed89b9b46e..cac875349a3a 100644
>>> --- a/qapi/qom.json
>>> +++ b/qapi/qom.json
>>> @@ -905,10 +905,25 @@
>>>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>>  #     be set, otherwise they refuse to boot.
>>>  #
>>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>>> +#     e.g., run-time or OS configuration (base64 encoded SHA384 digest=
).
>>> +#     (A default value 0 of SHA384 is used when absent).
>>
>> Suggest to drop the parenthesis in the last sentence.
>>
>> @mrconfigid is a string, so the default value can't be 0.  Actually,
>> it's not just any string, but a base64 encoded SHA384 digest, which
>> means it must be exactly 96 hex digits.  So it can't be "0", either.  It
>> could be
>> "00000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000".
>
> I thought value 0 of SHA384 just means it.
>
> That's my fault and my poor english.

"Fault" is too harsh :)  It's not as precise as I want our interface
documentation to be.  We work together to get there.

>> More on this below.
>>=20
>>> +#
>>> +# @mrowner: ID for the guest TD=E2=80=99s owner (base64 encoded SHA384=
 digest).
>>> +#     (A default value 0 of SHA384 is used when absent).
>>> +#
>>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>>> +#     e.g., specific to the workload rather than the run-time or OS
>>> +#     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
>>> +#     used when absent).
>>> +#
>>>  # Since: 9.0
>>>  ##
>>>  { 'struct': 'TdxGuestProperties',
>>> -  'data': { '*sept-ve-disable': 'bool' } }
>>> +  'data': { '*sept-ve-disable': 'bool',
>>> +            '*mrconfigid': 'str',
>>> +            '*mrowner': 'str',
>>> +            '*mrownerconfig': 'str' } }
>>>  ##
>>>  # @ThreadContextProperties:
>>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>>> index d0ad4f57b5d0..4ce2f1d082ce 100644
>>> --- a/target/i386/kvm/tdx.c
>>> +++ b/target/i386/kvm/tdx.c
>>> @@ -13,6 +13,7 @@
>>>  #include "qemu/osdep.h"
>>>  #include "qemu/error-report.h"
>>> +#include "qemu/base64.h"
>>>  #include "qapi/error.h"
>>>  #include "qom/object_interfaces.h"
>>>  #include "standard-headers/asm-x86/kvm_para.h"
>>> @@ -516,6 +517,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>      X86CPU *x86cpu =3D X86_CPU(cpu);
>>>      CPUX86State *env =3D &x86cpu->env;
>>>      g_autofree struct kvm_tdx_init_vm *init_vm =3D NULL;
>>> +    size_t data_len;
>>>      int r =3D 0;
>>>      object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
>>> @@ -528,6 +530,38 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **err=
p)
>>>      init_vm =3D g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>>                          sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUI=
D_ENTRIES);
>>> +#define SHA384_DIGEST_SIZE  48
>>> +
>>> +    if (tdx_guest->mrconfigid) {
>>> +        g_autofree uint8_t *data =3D qbase64_decode(tdx_guest->mrconfi=
gid,
>>> +                              strlen(tdx_guest->mrconfigid), &data_len=
, errp);
>>> +        if (!data || data_len !=3D SHA384_DIGEST_SIZE) {
>>> +            error_setg(errp, "TDX: failed to decode mrconfigid");
>>> +            return -1;
>>> +        }
>>> +        memcpy(init_vm->mrconfigid, data, data_len);
>>> +    }
>>
>> When @mrconfigid is absent, the property remains null, and this
>> conditional is not executed.  init_vm->mrconfigid[], an array of 6
>> __u64, remains all zero.  How does the kernel treat that?
>
> A all-zero SHA384 value is still a valid value, isn't it?
>
> KVM treats it with no difference.

Can you point me to the spot in the kernel where mrconfigid is used?

[...]


