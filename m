Return-Path: <kvm+bounces-10098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2173E869ABC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9DD28756C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECB81474A5;
	Tue, 27 Feb 2024 15:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MH9ybYB/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F29146917
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709048568; cv=none; b=FvAeYG4O71T7yoUA/UKm8/O8dqMfBTB4k6CAQfauigG1jxbwrLM7V7gdS3aPpT0OwVnzaDLq78/VeUf6Kdqr66ALO9yieW3O3p8M9gAFDQgrSzB3cSsWf4XcPAY+ziK9R36+zp+81HzZZHuvsC9qm6BnKTz1GnYDCH6v63Br5K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709048568; c=relaxed/simple;
	bh=qO+8FLFokzFRx8rLqoZfW+KCa3K2zSsjFaU37y0SIok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=J3WFXLq44vsZkts+cuB3AtHsAhNNcMBcVSFzGN7IQl0J5WtUVCAJE727bUzn9W2QvzdoPabdbGvoG1uyPNGdUL9avI07t8r2WcHSYlvAiDm4ib+AwpzmCIMiEtgEHZKXOLlCtgMgC89C5z8XnfZ59FWe73BuW6V9W6PMxUHJZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MH9ybYB/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709048565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9F5yUOES5ELNg7LCNTzZy1CeXKfGhzhmrWj1sbHY2YE=;
	b=MH9ybYB/MtPO2aRnYVmTmzoSfJdmL23R7aIauMBhlF27zQczOzHY0oHz36viCIAPSB4dX0
	ttuFdQP245uAM1cyV+4QsVNBcKsuZj/RL95MtZtUwVewIfFRNBw9FMpMHRwxfS84HDMW/Y
	UGyZ7JmjOhNTixIM3DWrgdA8mZGfRS8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-YWvDMh15MFysBMssrCrO0g-1; Tue,
 27 Feb 2024 10:42:42 -0500
X-MC-Unique: YWvDMh15MFysBMssrCrO0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C87D03C0275E;
	Tue, 27 Feb 2024 15:42:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8165E2166B33;
	Tue, 27 Feb 2024 15:42:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6E16121E6740; Tue, 27 Feb 2024 16:42:40 +0100 (CET)
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
In-Reply-To: <7ef9d3c0-2bab-4edc-a5dc-156d17a467ed@intel.com> (Xiaoyao Li's
	message of "Tue, 27 Feb 2024 22:51:59 +0800")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-54-xiaoyao.li@intel.com>
	<87v86kehts.fsf@pond.sub.org>
	<1d7f7c1b-cfaa-4de6-80a0-8d1104440f54@intel.com>
	<87le76dt1g.fsf@pond.sub.org>
	<09c5fd9b-be96-45b6-b48e-772d5b5aad16@intel.com>
	<87wmqqawa2.fsf@pond.sub.org>
	<7ef9d3c0-2bab-4edc-a5dc-156d17a467ed@intel.com>
Date: Tue, 27 Feb 2024 16:42:40 +0100
Message-ID: <87o7c1ap73.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 2/27/2024 9:09 PM, Markus Armbruster wrote:
> [...]
>>>>>>> @@ -566,6 +569,27 @@
>>>>>>>               'psw-addr': 'uint64',
>>>>>>>               'reason': 'S390CrashReason'}}
>>>>>>>     
>>>>>>> +##
>>>>>>> +# @GuestPanicInformationTdx:
>>>>>>> +#
>>>>>>> +# TDX Guest panic information specific to TDX GCHI
>>>>>>> +# TDG.VP.VMCALL<ReportFatalError>.
>>>>>>> +#
>>>>>>> +# @error-code: TD-specific error code
>>>>>>
>>>>>> Where could a user find information on these error codes?
>>>>>
>>>>> TDX GHCI (Guset-host-communication-Interface)spec. It defines all the
>>>>> TDVMCALL leaves.
>>>>>
>>>>> 0: panic;
>>>>> 0x1 - 0xffffffff: reserved.
>>>>
>>>> Would it make sense to add a reference?
>>>
>>> https://cdrdv2.intel.com/v1/dl/getContent/726792
>> 
>> URLs have this annoying tendency to rot.
>> 
>> What about
>> 
>> # @error-code: Error code as defined in "Guest-Hypervisor Communication
>> #     Interface (GHCI) Specification for Intel TDX 1.5"
>
> I think it gets mentioned at the beginning of @GuestPanicInformationTdx
>
>    TDX Guest panic information specific to TDX GHCI
>    TDG.VP.VMCALL<ReportFatalError>.
>
> Do we still to mention it in every single member?

No, I didn't recognize the alphabet soup there as a reference :)

Let me try again:

##
# @GuestPanicInformationTdx:
#
# TDX Guest panic information specific to TDX, as specified in the
# "Guest-Hypervisor Communication Interface (GHCI) Specification",
# section TDG.VP.VMCALL<ReportFatalError>.
#
# @error-code: TD-specific error code
#
[...]
#
# Since: 9.0
##

>>>>>>> +#
>>>>>>> +# @gpa: guest-physical address of a page that contains additional
>>>>>>> +#     error data, in forms of zero-terminated string.
>>>>>>
>>>>>> "in the form of a zero-terminated string"
>>>>>
>>>>> fixed.
>>>>>
>>>>>>> +#
>>>>>>> +# @message: Human-readable error message provided by the guest. Not
>>>>>>> +#     to be trusted.
>>>>>>
>>>>>> How is this message related to the one pointed to by @gpa?
>>>>>
>>>>> In general, @message contains a brief message of the error. While @gpa
>>>>> (when valid) contains a verbose message.
>>>>>
>>>>> The reason why we need both is because sometime when TD guest hits a
>>>>> fatal error, its memory may get corrupted so we cannot pass information
>>>>> via @gpa. Information in @message is passed through GPRs.
>>>>
>>>> Well, we do pass information via @gpa, always.  I guess it page's
>>>> contents can be corrupted.
>>>
>>> No. It's not always. the bit 63 of the error code is "GPA valid" bit.
>>> @gpa is valid only when bit 63 of error code is 1.
>>>
>>> And current Linux TD guest implementation doesn't use @gpa at all.
>>> https://github.com/torvalds/linux/blob/45ec2f5f6ed3ec3a79ba1329ad585497cdcbe663/arch/x86/coco/tdx/tdx.c#L131
>> 
>> Aha!
>> 
>> Why would we want to include @gpa when the "GPA valid" bit is off?
>> 
>> If we do want it, then
>> 
>> # @gpa: guest-physical address of a page that contains more verbose
>> #     error information, as zero-terminated string.  Valid when the
>> #     "GPA valid" bit is set in @error-code.
>> 
>> If we don't, then make @gpa optional, present when valid, and document
>> it like this:
>> 
>> # @gpa: guest-physical address of a page that contains more verbose
>> #     error information, as zero-terminated string.  Present when the
>> #     "GPA valid" bit is set in @error-code.
>
> I will go this direction.
>
> thanks!

You're welcome!

[...]


