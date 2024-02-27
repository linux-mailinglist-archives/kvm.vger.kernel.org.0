Return-Path: <kvm+bounces-10073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B30D868F70
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9C992887D1
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8623413A249;
	Tue, 27 Feb 2024 11:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WK/ODyMC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F17F139592
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 11:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709034691; cv=none; b=PEK/N12qoTC9w0a+xQNs4XWkYUX3OA8GmAdyDjWN+wLCNiV06pjSlDKdM6kVzkvKcxPJvG6DeywFzbB2HDVFeFl8mSOlJZs6ip++yEs3pAehMnvOAmxHoKON7oHKENCSm/4Lb6UoG3vKYIf+8j/ctM7llXHbU+i4NgN3a0qKqP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709034691; c=relaxed/simple;
	bh=/fLNa64fp+YJt2139uOJrdUMUcv/WkCfWMTMc/QnAgM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XIgm2cLobcq569Hau4DEjiy/2PW+4vlFsUtejs3MwshM8y1q1VP7KTdsdssm6oek0P0WwmWrwzPVcDYUb9MKIFX1LW4BE4T3nH86JARPGKbcPeoMt19v2qzwaubX+f9V/bDAth4ZlyyOXvhZreBMuiqr/FV8DYBn4yCTsH7l7A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WK/ODyMC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709034688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uk9fiadTynJu7VqDaSTH+1mkCCzDcstFTbqQ/wNRaiI=;
	b=WK/ODyMCA3zg4/PRh9QCJsqULnkevVYvpOh5afDHY7UyjK7OJ1/YT9/f1JWv/V1eOtpXGy
	cB6z/zIFvHkvnLemtzKA8t82Z3sIVLO+2OD/JH90RUVSQxjGqdBEt3UN8e0tIaBlCsyIJm
	M/QcvD0ogqc71iNGwbcOzLkmo3h2Nps=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-jfHY44QbNXiUfmDsqOXBVQ-1; Tue,
 27 Feb 2024 06:51:25 -0500
X-MC-Unique: jfHY44QbNXiUfmDsqOXBVQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ABFA1C04B5F;
	Tue, 27 Feb 2024 11:51:25 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3AB492BD7;
	Tue, 27 Feb 2024 11:51:24 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B702C21E66D0; Tue, 27 Feb 2024 12:51:23 +0100 (CET)
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
Subject: Re: [PATCH v4 53/66] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
In-Reply-To: <1d7f7c1b-cfaa-4de6-80a0-8d1104440f54@intel.com> (Xiaoyao Li's
	message of "Tue, 27 Feb 2024 17:51:05 +0800")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-54-xiaoyao.li@intel.com>
	<87v86kehts.fsf@pond.sub.org>
	<1d7f7c1b-cfaa-4de6-80a0-8d1104440f54@intel.com>
Date: Tue, 27 Feb 2024 12:51:23 +0100
Message-ID: <87le76dt1g.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 2/19/2024 8:53 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> 
>>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>>
>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>> Changes in v4:
>>> - refine the documentation; (Markus)
>>>
>>> Changes in v3:
>>> - Add docmentation of new type and struct; (Daniel)
>>> - refine the error message handling; (Daniel)
>>> ---
>>>   qapi/run-state.json   | 28 ++++++++++++++++++++--
>>>   system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>>>   target/i386/kvm/tdx.c | 24 ++++++++++++++++++-
>>>   3 files changed, 103 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>>> index 08bc99cb8561..5429116679e3 100644
>>> --- a/qapi/run-state.json
>>> +++ b/qapi/run-state.json
>>> @@ -485,10 +485,12 @@
>>>  #
>>>  # @s390: s390 guest panic information type (Since: 2.12)
>>>  #
>>> +# @tdx: tdx guest panic information type (Since: 8.2)
>>> +#
>>>  # Since: 2.9
>>>  ##
>>>  { 'enum': 'GuestPanicInformationType',
>>> -  'data': [ 'hyper-v', 's390' ] }
>>> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>>>   
>>>  ##
>>>  # @GuestPanicInformation:
>>> @@ -503,7 +505,8 @@
>>>    'base': {'type': 'GuestPanicInformationType'},
>>>    'discriminator': 'type',
>>>    'data': {'hyper-v': 'GuestPanicInformationHyperV',
>>> -          's390': 'GuestPanicInformationS390'}}
>>> +          's390': 'GuestPanicInformationS390',
>>> +          'tdx' : 'GuestPanicInformationTdx'}}
>>>   
>>>  ##
>>>  # @GuestPanicInformationHyperV:
>>> @@ -566,6 +569,27 @@
>>>             'psw-addr': 'uint64',
>>>             'reason': 'S390CrashReason'}}
>>>   
>>> +##
>>> +# @GuestPanicInformationTdx:
>>> +#
>>> +# TDX Guest panic information specific to TDX GCHI
>>> +# TDG.VP.VMCALL<ReportFatalError>.
>>> +#
>>> +# @error-code: TD-specific error code
>> 
>> Where could a user find information on these error codes?
>
> TDX GHCI (Guset-host-communication-Interface)spec. It defines all the 
> TDVMCALL leaves.
>
> 0: panic;
> 0x1 - 0xffffffff: reserved.

Would it make sense to add a reference?

>>> +#
>>> +# @gpa: guest-physical address of a page that contains additional
>>> +#     error data, in forms of zero-terminated string.
>> 
>> "in the form of a zero-terminated string"
>
> fixed.
>
>>> +#
>>> +# @message: Human-readable error message provided by the guest. Not
>>> +#     to be trusted.
>> 
>> How is this message related to the one pointed to by @gpa?
>
> In general, @message contains a brief message of the error. While @gpa 
> (when valid) contains a verbose message.
>
> The reason why we need both is because sometime when TD guest hits a 
> fatal error, its memory may get corrupted so we cannot pass information 
> via @gpa. Information in @message is passed through GPRs.

Well, we do pass information via @gpa, always.  I guess it page's
contents can be corrupted.

Perhaps something like

    # @message: Human-readable error message provided by the guest.  Not
    #     to be trusted.
    #
    # @gpa: guest-physical address of a page that contains more verbose 
    #     error information, as zero-terminated string.  Note that guest
    #     memory corruption can corrupt the page's contents.

>>> +#
>>> +# Since: 9.0
>>> +##
>>> +{'struct': 'GuestPanicInformationTdx',
>>> + 'data': {'error-code': 'uint64',
>>> +          'gpa': 'uint64',
>>> +          'message': 'str'}}

Note that my proposed doc string has the members in a different order.
Recommend to use the same order here.

>>> +
>>>   ##
>>>   # @MEMORY_FAILURE:
>>>   #
>> 
>> [...]
>> 


