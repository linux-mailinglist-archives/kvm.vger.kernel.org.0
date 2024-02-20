Return-Path: <kvm+bounces-9212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F4585C0E7
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA69B1F23832
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB4676C60;
	Tue, 20 Feb 2024 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epE+I2EV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD076908
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708445723; cv=none; b=qNsVAQz15p93wuinp7ClXtdgeaiXqLzYYlXLx1Su6T/oFwo1HM1lYz4TJaS1ETV+Pm6o77jKqpktU6MbZUkJ9YDMwKtHtDmCXz6azM7vvzyc8SRmu4B0YNaER8RB3SjxrxmkvH22dHHLh8k2nqm5fM7ZvE5gV46fK5vB1mTlZ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708445723; c=relaxed/simple;
	bh=SUXEC4WxQii//gTBmi+NPiWcpKzR+deKzND3uqVfzOc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f7Xy3ZkQdjW62y9Wt62l3OIrCnjDznlAe+scrRTZE86RMW62OLw9xqIY41tgghX37/g036RbtQFw3QDjdyxv7aoGkfn2durEH8PcQnUUUORvdcAKNWVs9X417R9inlZRnld/LbjLTQSLEfBLUmiM33WIxXUt2QcwXPqvZMaVHZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=epE+I2EV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708445701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7u28xwIheG3uxovuWZOpEtSYb8aZ/auv1OID/d5NrA=;
	b=epE+I2EVnjdC1JhU+soqHdtvMNC9uSmu51WG0J0MwgqFdJo14ryCcpi4trr0We3/6WsDgg
	gMCVpSIoZi4xwhBLF1aBw8LQyGpCUWYAr52CiBeO9dbjj0jHHw89oRmLC+RSXZ1QGcYLr4
	iNyr8xSfpAjo0elTPB05CYjzkov7up8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-jbZ68DtwOku-M8uuakTlmw-1; Tue,
 20 Feb 2024 11:14:58 -0500
X-MC-Unique: jbZ68DtwOku-M8uuakTlmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99F3E3814582;
	Tue, 20 Feb 2024 16:14:57 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C22810802;
	Tue, 20 Feb 2024 16:14:57 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 07D0B21E6740; Tue, 20 Feb 2024 17:14:55 +0100 (CET)
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
Subject: Re: [PATCH v4 29/66] i386/tdx: Support user configurable
 mrconfigid/mrowner/mrownerconfig
In-Reply-To: <cf9e91ea-825a-444c-9625-a571fdc3265a@intel.com> (Xiaoyao Li's
	message of "Tue, 20 Feb 2024 23:10:29 +0800")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-30-xiaoyao.li@intel.com>
	<875xykfwmf.fsf@pond.sub.org>
	<cf9e91ea-825a-444c-9625-a571fdc3265a@intel.com>
Date: Tue, 20 Feb 2024 17:14:55 +0100
Message-ID: <87le7f3yf4.fsf@pond.sub.org>
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

> On 2/19/2024 8:48 PM, Markus Armbruster wrote:
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
>>>
>>> ---
>>> Changes in v4:
>>>   - describe more of there fields in qom.json
>>>   - free the old value before set new value to avoid memory leak in
>>>     _setter(); (Daniel)
>>>
>>> Changes in v3:
>>>   - use base64 encoding instread of hex-string;
>>> ---
>>>   qapi/qom.json         | 14 ++++++-
>>>   target/i386/kvm/tdx.c | 87 +++++++++++++++++++++++++++++++++++++++++++
>>>   target/i386/kvm/tdx.h |  3 ++
>>>   3 files changed, 103 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>> index 2177f3101382..15445f9e41fc 100644
>>> --- a/qapi/qom.json
>>> +++ b/qapi/qom.json
>>> @@ -905,10 +905,22 @@
>>>   #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
>>>   #     be set, otherwise they refuse to boot.
>>>   #
>>> +# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
>>> +#     e.g., run-time or OS configuration.  base64 encoded SHA384 diges=
t.
>>=20
>> "base64 encoded SHA384" is not a sentence.
>>=20
>> Double-checking: the data being hashed here is the "non-owner-defined
>> configuration of the guest TD", and the resulting hash is the "ID"?
>
> yes. The "ID" here means the resulting hash.
>
> The reason to use "ID" here because in the TDX spec, it's description is
>
>    Software-defined ID for non-owner-defined configuration of the guest
>    TD - e.g., run-time or OS configuration.
>
> If ID is confusing, how about
>
>    SHA384 hash of non-owner-defined configuration of the guest TD, e.g.,
>    run-time of OS configuration.  It's base64 encoded.

I guess staying close to the TDX spec makes sense.

We still need to mention the base64 encoding.

What about something like

     ID for non-owner-defined configuration of the guest TD, e.g.,
     run-time or OS configuration (base64 encoded SHA384 digest)

or, if we decide that the fact it's SHA384 digest is irrelevant for QMP

     ID for non-owner-defined configuration of the guest TD, e.g.,
     run-time or OS configuration (base64 encoded)

>>> +#
>>> +# @mrowner: ID for the guest TD=E2=80=99s owner.  base64 encoded SHA38=
4 digest.
>>=20
>> Likewise.
>>=20
>>> +#
>>> +# @mrownerconfig: ID for owner-defined configuration of the guest TD,
>>> +#     e.g., specific to the workload rather than the run-time or OS.
>>> +#     base64 encoded SHA384 digest.
>>=20
>> Likewise.
>>=20
>>> +#
>>>   # Since: 9.0
>>>   ##
>>>   { 'struct': 'TdxGuestProperties',
>>> -  'data': { '*sept-ve-disable': 'bool' } }
>>> +  'data': { '*sept-ve-disable': 'bool',
>>> +            '*mrconfigid': 'str',
>>> +            '*mrowner': 'str',
>>> +            '*mrownerconfig': 'str' } }
>>=20
>> The new members are optional, but their description in the doc comment
>> doesn't explain behavior when present vs. behavior when absent.
>>=20
>>>=20=20=20
>>>   ##
>>>   # @ThreadContextProperties:
>>=20
>> [...]
>>=20
>>=20


