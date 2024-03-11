Return-Path: <kvm+bounces-11505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F5B877B53
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CC8A1F21191
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 07:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F3C107A6;
	Mon, 11 Mar 2024 07:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2f+yMU2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C02101E2
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710142153; cv=none; b=W8SyfbRaBUrfm/PG12PyuZIbBGP+uQew27IHJvHUoT0mA6Ns8HAcZqPJu6XddZkihyQmsqkiJ0o6MMW+p5MFG0A7mfyIBRtPWvRLZFPcxkq4O2zzZEXpzA+D0IBuV7yqNDaiuq30r9Ml1u8QTY1YZwf3CpwQb6cgxuyvxJn8lMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710142153; c=relaxed/simple;
	bh=n99vdo5Gmb2UJvrWqk7Av+5gKCk9m7lilFjXP8Ljep0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AwIKdFnpQ2c9laaWpc5XA4jl6xLWlToAMgVahFEfoPsz1zfS5yibkOqgBharQ6IRHxd7ZEK8pJz2G5TqWAJ44criWTUtVg0Orhtd9Pq/6B3ceOhGptU3XaFZCmgztSZFBIBsq6M3thWMn599FDOia+deAlt82YFtxcPtQh7MeYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2f+yMU2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710142149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EF/lQ6AcWDo9er79rF8lhoXUfncFaGy7PoQxJj8hn1s=;
	b=X2f+yMU2ZAhjCt13yNGDO2P1RzKQGoDsjCPt3c+BFGRTa+g6KIoyWqzxwlK76QMT5vkRP3
	jfXo2tCzvUa2a7kgFUpWhFG7k4KIW98ElDUAclmmtGnXX9GwGS4O4gl+SvAWmWGFEvPLmH
	KYbIvWX5EezprWa8as0FHifuWCcbSgI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-xybE5VPSMHCNtQSbpKXdXA-1; Mon, 11 Mar 2024 03:29:05 -0400
X-MC-Unique: xybE5VPSMHCNtQSbpKXdXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88083185A789;
	Mon, 11 Mar 2024 07:29:04 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.138])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 437C71121306;
	Mon, 11 Mar 2024 07:29:04 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 34B9A21E6A24; Mon, 11 Mar 2024 08:29:03 +0100 (CET)
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
Subject: Re: [PATCH v5 52/65] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
In-Reply-To: <95e623e1-ccf3-4d8f-9751-7767db100e2b@intel.com> (Xiaoyao Li's
	message of "Mon, 11 Mar 2024 09:28:37 +0800")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-53-xiaoyao.li@intel.com>
	<874jdr1wmt.fsf@pond.sub.org>
	<d5cb6e5e-0bc1-40bd-8fc1-50a03f42e9cf@intel.com>
	<87y1au881k.fsf@pond.sub.org>
	<95e623e1-ccf3-4d8f-9751-7767db100e2b@intel.com>
Date: Mon, 11 Mar 2024 08:29:03 +0100
Message-ID: <87plw1uszk.fsf@pond.sub.org>
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

> On 3/7/2024 9:51 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>=20
>>> On 2/29/2024 4:51 PM, Markus Armbruster wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>>>>
>>>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> ---
>>>>> Changes in v5:
>>>>> - mention additional error information in gpa when it presents;
>>>>> - refine the documentation; (Markus)
>>>>>
>>>>> Changes in v4:
>>>>> - refine the documentation; (Markus)
>>>>>
>>>>> Changes in v3:
>>>>> - Add docmentation of new type and struct; (Daniel)
>>>>> - refine the error message handling; (Daniel)
>>>>> ---
>>>>>    qapi/run-state.json   | 31 +++++++++++++++++++++--
>>>>>    system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++=
++++
>>>>>    target/i386/kvm/tdx.c | 24 +++++++++++++++++-
>>>>>    3 files changed, 110 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>>>>> index dd0770b379e5..b71dd1884eb6 100644
>>>>> --- a/qapi/run-state.json
>>>>> +++ b/qapi/run-state.json

[...]

>>>>> @@ -564,6 +567,30 @@
>>>>>              'psw-addr': 'uint64',
>>>>>              'reason': 'S390CrashReason'}}
>>>>> +##
>>>>> +# @GuestPanicInformationTdx:
>>>>> +#
>>>>> +# TDX Guest panic information specific to TDX, as specified in the
>>>>> +# "Guest-Hypervisor Communication Interface (GHCI) Specification",
>>>>> +# section TDG.VP.VMCALL<ReportFatalError>.
>>>>> +#
>>>>> +# @error-code: TD-specific error code
>>>>> +#
>>>>> +# @message: Human-readable error message provided by the guest. Not
>>>>> +#     to be trusted.
>>>>> +#
>>>>> +# @gpa: guest-physical address of a page that contains more verbose
>>>>> +#     error information, as zero-terminated string.  Present when the
>>>>> +#     "GPA valid" bit (bit 63) is set in @error-code.
>>>>
>>>> Uh, peeking at GHCI Spec section 3.4 TDG.VP.VMCALL<ReportFatalError>, I
>>>> see operand R12 consists of
>>>>
>>>>       bits    name                        description
>>>>       31:0    TD-specific error code      TD-specific error code
>>>>                                           Panic =E2=80=93 0x0.
>>>>                                           Values =E2=80=93 0x1 to 0xFF=
FFFFFF
>>>>                                           reserved.
>>>>       62:32   TD-specific extended        TD-specific extended error c=
ode.
>>>>               error code                  TD software defined.
>>>>       63      GPA Valid                   Set if the TD specified addi=
tional
>>>>                                           information in the GPA param=
eter
>>>>                                           (R13).
>>>> Is @error-code all of R12, or just bits 31:0?
>>>> If it's all of R12, description of @error-code as "TD-specific error
>>>> code" is misleading.
>>>
>>> We pass all of R12 to @error_code.
>>>
>>> Here it wants to use "error_code" as generic as the whole R12. Do you h=
ave any better description of it ?
>>=20
>> Sadly, the spec is of no help: it doesn't name the entire thing, only
>> the three sub-fields TD-specific error code, TD-specific extended error
>> code, GPA valid.
>>=20
>> We could take the hint, and provide the sub-fields instead:
>>=20
>> * @error-code contains the TD-specific error code (bits 31:0)
>>=20
>> * @extended-error-code contains the TD-specific extended error code
>>    (bits 62:32)
>>=20
>> * we don't need @gpa-valid, because it's the same as "@gpa is present"
>>=20
>> If we decide to keep the single member, we do need another name for it.
>> @error-codes (plural) doesn't exactly feel wonderful, but it gives at
>> least a subtle hint that it's not just *the* error code.
>
> The reason we only defined one single member, is that the=20
> extended-error-code is not used now, and I believe it won't be used in=20
> the near future.

Aha!  Then I recommend

* @error-code contains the TD-specific error code (bits 31:0)

* Omit bits 62:32 from the reply; if we later find an actual use for
  them, we can add a suitable member

* Omit bit 63, because it's the same as "@gpa is present"

> If no objection from others, I will use @error-codes (plural) in the=20
> next version.

I recommend to keep the @error-code name, but narrow its value to the
actual error code, i.e. bits 31:0.

>>>> If it's just bits 31:0, then 'Present when the "GPA valid" bit (bit 63)
>>>> is set in @error-code' is wrong.  Could go with 'Only present when the
>>>> guest provides this information'.

[...]


