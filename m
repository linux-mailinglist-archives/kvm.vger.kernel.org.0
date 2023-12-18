Return-Path: <kvm+bounces-4722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 569138170C7
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B02AFB21211
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 13:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101421D123;
	Mon, 18 Dec 2023 13:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJT+7fCR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE76129EFA
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702907242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpTZCnyPB9urpgeAAc4RRyXIjpQ05VzuR/q4EVUTs4I=;
	b=hJT+7fCR3wV9WYfUG8EUksbbczTbd9P16BKF5ID0TmsFKJCQWWI3AZPV5Ta5XSb5AKPoCD
	ZMS9jR6hB26d6tpZvg8e+Dm/CpKxX9VpURQ6wyByjiiE9+c62oVgeduGvaiAQYm41/Tb4D
	649FNPs8LujY//BZLlz/EGzK4wswpWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-Z2_NQgy8ODaWZhTzKNGriQ-1; Mon, 18 Dec 2023 08:47:19 -0500
X-MC-Unique: Z2_NQgy8ODaWZhTzKNGriQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68D6788D4F6;
	Mon, 18 Dec 2023 13:46:59 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.129])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25F1FC15968;
	Mon, 18 Dec 2023 13:46:59 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 229B821E6920; Mon, 18 Dec 2023 14:46:58 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  "Michael S .
 Tsirkin" <mst@redhat.com>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Richard Henderson <richard.henderson@linaro.org>,  Peter Xu
 <peterx@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Cornelia Huck <cohuck@redhat.com>,  Daniel =?utf-8?Q?P=2EBerrang=C3=A9?=
 <berrange@redhat.com>,  Eric Blake <eblake@redhat.com>,  Marcelo Tosatti
 <mtosatti@redhat.com>,  qemu-devel@nongnu.org,  kvm@vger.kernel.org,
  Michael Roth <michael.roth@amd.com>,  Sean Christopherson
 <seanjc@google.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd Hoffmann
 <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,  Chenyi
 Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 31/70] i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
In-Reply-To: <31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com> (Xiaoyao Li's
	message of "Thu, 14 Dec 2023 11:07:21 +0800")
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
	<20231115071519.2864957-32-xiaoyao.li@intel.com>
	<87o7faw5k1.fsf@pond.sub.org>
	<31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com>
Date: Mon, 18 Dec 2023 14:46:58 +0100
Message-ID: <87edfjsjvx.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 12/1/2023 7:00 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>=20
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
>>> can be provided for TDX attestation.
>>>
>>> So far they were hard coded as 0. Now allow user to specify those values
>>> via property mrconfigid, mrowner and mrownerconfig. They are all in
>>> base64 format.
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
>>> ---
>>> Changes in v3:
>>>   - use base64 encoding instread of hex-string;
>>> ---
>>>   qapi/qom.json         | 11 +++++-
>>>   target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
>>>   target/i386/kvm/tdx.h |  3 ++
>>>   3 files changed, 98 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>> index 3a29659e0155..fd99aa1ff8cc 100644
>>> --- a/qapi/qom.json
>>> +++ b/qapi/qom.json
>>> @@ -888,10 +888,19 @@
>>>  #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>>  #     be set, otherwise they refuse to boot.
>>>  #
>>> +# @mrconfigid: base64 encoded MRCONFIGID SHA384 digest
>>> +#
>>> +# @mrowner: base64 encoded MROWNER SHA384 digest
>>> +#
>>> +# @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
>>
>> Can we come up with a description that tells the user a bit more clearly
>> what we're talking about?  Perhaps starting with this question could
>> lead us there: what's an MRCONFIGID, and why should I care?
>
> Below are the definition from TDX spec:
>
> MRCONFIGID: Software-defined ID for non-owner-defined configuration of th=
e guest TD =E2=80=93 e.g., run-time or OS configuration.
>
> MROWNER: Software-defined ID for the guest TD=E2=80=99s owner
>
> MROWNERCONFIG: Software-defined ID for owner-defined configuration of the=
 guest TD =E2=80=93 e.g., specific to the workload rather than the run-time=
 or OS

Have you considered using this for the doc comments?  I'd omit
"software-defined" in this context.

> They are all attestation related, and input by users who launches the TD =
. Software inside TD can retrieve them with TDREPORT and verify if it is th=
e expected value.
>
> MROWNER is to identify the owner of the TD, MROWNERCONFIG is to pass OWNE=
R's configuration. And MRCONFIGID contains configuration specific to OS lev=
el instead of OWNER.
>
> Below is the explanation from Intel inside, hope it can get you more clea=
r:
>
> "These are primarily intended for general purpose, configurable software =
in a minimal TD. So, not a legacy VM image cloud customer wanting to move t=
heir VM out into the cloud. Also it=E2=80=99s not necessarily the case that=
 any workload will use them all.
>
> MROWNER is for declaring the owner of the TD. An example use case would b=
e an vHSM TD. HSMs need to know who their administrative contact is. You co=
uld customize the HSM image and measurements, but then people can=E2=80=99t=
 recognize that this is the vHSM product from XYZ. So you put the unmodifie=
d vHSM stack in the TD, which will include MRTD/RTMRs that reflect the vHSM=
, and the owner=E2=80=99s public key in MROWNER. Now, when the vHSM starts =
up, to determine who is authorized to send commands, it does a TDREPORT, an=
d looks at MROWNER.
>
> Extending this model, there could be important configuration information =
from the owner. In that case, MROWNERCONFIG is set to the hash of the confi=
g file that the vHSM should accept.
>
> This results in an attestable environment that explicitly indicates that =
it=E2=80=99s a well recognized vHSM TD, being administered by MROWNER and l=
oading the configuration information that matches MROWNERCONFIG.
>
> Extending this idea of configuration of generally recognized software, it=
 could be that there is a shim OS under the vHSM that itself is configurabl=
e. So MRCONFIGID, which isn=E2=80=99t a great name, can include configurati=
on information intended for the OS level. The ID is confusing, but MRCONFIG=
ID was the name we used for this register for SGX, so we kept the name."

Include a reference to this document?

>>> +#
>>>  # Since: 8.2
>>>  ##
>>>  { 'struct': 'TdxGuestProperties',
>>> -  'data': { '*sept-ve-disable': 'bool' } }
>>> +  'data': { '*sept-ve-disable': 'bool',
>>> +            '*mrconfigid': 'str',
>>> +            '*mrowner': 'str',
>>> +            '*mrownerconfig': 'str' } }
>>>   ##
>>>   # @ThreadContextProperties:
>> [...]
>>=20


