Return-Path: <kvm+bounces-10086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E04A6869166
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 14:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 557961F252AB
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293C013AA59;
	Tue, 27 Feb 2024 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FznDZiGt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7931332A7
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 13:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709039391; cv=none; b=fAZbRdPuPuSkd9bUG1luaBk6WjB4ivrjc4NAY/wT3TeNsEHeP9KGtsRJK8p56yscjfuGrUT3bsMW9/YNtA32YKOjTp9SYUHss8xuwNoLhvKikpd0VHHVqosqOwwk3cwofSukb2yJd01q2Z6RFNx+1++v5S08n2Jy0NAf5jP7ajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709039391; c=relaxed/simple;
	bh=BLY4etjbmQkfQHGdPfpf/g4JZGr7fibyT5+pPpsDCb4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pbh6Vk6dYqQehPtIF5eqtTlR7OvZFpjNZqts2fGG1tLUDd8ZvY787Qay7mGXBgR6Jx/Q0NaafY8CplWp1UEuFRIUxqA+x3bQS1vMpUP6XsKY5gJQURVZxPKUAym9H5MVSV5M/jZ5ImvLx4ZRsC+1eAvPuCccWMl4VI5eg7SDM34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FznDZiGt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709039388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y9rPD00F7OIDy6VyYPXw2CahA2P7o8tC42UrT8Kk1Ds=;
	b=FznDZiGto6JPIYbVmzLzANfTZaS5iwAb0rMT6RToxU3O2OdkUV1rxyDMC5yIiSZrH9xJTn
	/j57bK4dCgq4GqujLbuHddIi3ZXlIO5NG7Rhqhdp5t0YeLLhC9eKzvp0bYWvGopW8hDoOO
	xnaDurcydj+KRgTYZkXFQ/roTs8XtFI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-rWDsa9VKPLqNx6Z2cH-3Xw-1; Tue,
 27 Feb 2024 08:09:44 -0500
X-MC-Unique: rWDsa9VKPLqNx6Z2cH-3Xw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 281A73C0F185;
	Tue, 27 Feb 2024 13:09:44 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96C3F40166A5;
	Tue, 27 Feb 2024 13:09:43 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 7D82D21E6740; Tue, 27 Feb 2024 14:09:41 +0100 (CET)
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
In-Reply-To: <09c5fd9b-be96-45b6-b48e-772d5b5aad16@intel.com> (Xiaoyao Li's
	message of "Tue, 27 Feb 2024 20:09:41 +0800")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-54-xiaoyao.li@intel.com>
	<87v86kehts.fsf@pond.sub.org>
	<1d7f7c1b-cfaa-4de6-80a0-8d1104440f54@intel.com>
	<87le76dt1g.fsf@pond.sub.org>
	<09c5fd9b-be96-45b6-b48e-772d5b5aad16@intel.com>
Date: Tue, 27 Feb 2024 14:09:41 +0100
Message-ID: <87wmqqawa2.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 2/27/2024 7:51 PM, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> 
>>> On 2/19/2024 8:53 PM, Markus Armbruster wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>>>>>
>>>>> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> ---
>>>>> Changes in v4:
>>>>> - refine the documentation; (Markus)
>>>>>
>>>>> Changes in v3:
>>>>> - Add docmentation of new type and struct; (Daniel)
>>>>> - refine the error message handling; (Daniel)
>>>>> ---
>>>>>    qapi/run-state.json   | 28 ++++++++++++++++++++--
>>>>>    system/runstate.c     | 54 +++++++++++++++++++++++++++++++++++++++++++
>>>>>    target/i386/kvm/tdx.c | 24 ++++++++++++++++++-
>>>>>    3 files changed, 103 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/qapi/run-state.json b/qapi/run-state.json
>>>>> index 08bc99cb8561..5429116679e3 100644
>>>>> --- a/qapi/run-state.json
>>>>> +++ b/qapi/run-state.json

[...]

>>>>> @@ -566,6 +569,27 @@
>>>>>              'psw-addr': 'uint64',
>>>>>              'reason': 'S390CrashReason'}}
>>>>>    
>>>>> +##
>>>>> +# @GuestPanicInformationTdx:
>>>>> +#
>>>>> +# TDX Guest panic information specific to TDX GCHI
>>>>> +# TDG.VP.VMCALL<ReportFatalError>.
>>>>> +#
>>>>> +# @error-code: TD-specific error code
>>>>
>>>> Where could a user find information on these error codes?
>>>
>>> TDX GHCI (Guset-host-communication-Interface)spec. It defines all the
>>> TDVMCALL leaves.
>>>
>>> 0: panic;
>>> 0x1 - 0xffffffff: reserved.
>> 
>> Would it make sense to add a reference?
>
> https://cdrdv2.intel.com/v1/dl/getContent/726792

URLs have this annoying tendency to rot.

What about

# @error-code: Error code as defined in "Guest-Hypervisor Communication
#     Interface (GHCI) Specification for Intel TDX 1.5"

>>>>> +#
>>>>> +# @gpa: guest-physical address of a page that contains additional
>>>>> +#     error data, in forms of zero-terminated string.
>>>>
>>>> "in the form of a zero-terminated string"
>>>
>>> fixed.
>>>
>>>>> +#
>>>>> +# @message: Human-readable error message provided by the guest. Not
>>>>> +#     to be trusted.
>>>>
>>>> How is this message related to the one pointed to by @gpa?
>>>
>>> In general, @message contains a brief message of the error. While @gpa
>>> (when valid) contains a verbose message.
>>>
>>> The reason why we need both is because sometime when TD guest hits a
>>> fatal error, its memory may get corrupted so we cannot pass information
>>> via @gpa. Information in @message is passed through GPRs.
>> 
>> Well, we do pass information via @gpa, always.  I guess it page's
>> contents can be corrupted.
>
> No. It's not always. the bit 63 of the error code is "GPA valid" bit. 
> @gpa is valid only when bit 63 of error code is 1.
>
> And current Linux TD guest implementation doesn't use @gpa at all.
> https://github.com/torvalds/linux/blob/45ec2f5f6ed3ec3a79ba1329ad585497cdcbe663/arch/x86/coco/tdx/tdx.c#L131 

Aha!

Why would we want to include @gpa when the "GPA valid" bit is off?

If we do want it, then

# @gpa: guest-physical address of a page that contains more verbose
#     error information, as zero-terminated string.  Valid when the
#     "GPA valid" bit is set in @error-code.

If we don't, then make @gpa optional, present when valid, and document
it like this:

# @gpa: guest-physical address of a page that contains more verbose
#     error information, as zero-terminated string.  Present when the
#     "GPA valid" bit is set in @error-code.

>> Perhaps something like
>> 
>>      # @message: Human-readable error message provided by the guest.  Not
>>      #     to be trusted.
>>      #
>>      # @gpa: guest-physical address of a page that contains more verbose
>>      #     error information, as zero-terminated string.  Note that guest
>>      #     memory corruption can corrupt the page's contents.
>> 
>>>>> +#
>>>>> +# Since: 9.0
>>>>> +##
>>>>> +{'struct': 'GuestPanicInformationTdx',
>>>>> + 'data': {'error-code': 'uint64',
>>>>> +          'gpa': 'uint64',
>>>>> +          'message': 'str'}}
>> 
>> Note that my proposed doc string has the members in a different order.
>> Recommend to use the same order here.
>> 
>>>>> +
>>>>>    ##
>>>>>    # @MEMORY_FAILURE:
>>>>>    #
>>>>
>>>> [...]
>>>>
>> 


