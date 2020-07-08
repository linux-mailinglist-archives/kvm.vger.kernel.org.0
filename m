Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A62185EB
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgGHLS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:18:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728385AbgGHLS6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 07:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594207137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wh9gaSriXf+QysCDGCiE4StfqHWwUApSrUMp7zznhQE=;
        b=DPjlwUXuHDr3XhQ8wdj4AwjQO/lTdHlLlIOkoYqQfxxW79F2wZH0TtnPhDYRRfxcklhHIe
        RetzsUAcR8oGj3q1WUlYh+27sBNbHFdqjMYvHDMtV4jlJNMUrZxUUBz6lLzl+DYjJ1rB7N
        5Zudfe+LUS0NDjV7ToLCRnPiT2zFnc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-E1xRkDSqMyCdP2RcM-nIPQ-1; Wed, 08 Jul 2020 07:18:54 -0400
X-MC-Unique: E1xRkDSqMyCdP2RcM-nIPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD783107ACF5;
        Wed,  8 Jul 2020 11:18:53 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-90.ams2.redhat.com [10.36.114.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF23B5D9F3;
        Wed,  8 Jul 2020 11:18:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests v2 PATCH] s390x/cpumodel: The missing DFP
 facility on TCG is expected
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200707104205.25085-1-thuth@redhat.com>
 <20200707134415.39e47538.cohuck@redhat.com>
 <ca2ad96f-1d74-723f-e6c0-7345a90b35f8@redhat.com>
 <09d34daa-a770-defd-260c-81d3c5c49a3d@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e0a5d0df-4c4e-af0b-5b6c-ea1896dc767f@redhat.com>
Date:   Wed, 8 Jul 2020 13:18:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <09d34daa-a770-defd-260c-81d3c5c49a3d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/2020 17.09, Janosch Frank wrote:
> On 7/7/20 1:45 PM, David Hildenbrand wrote:
>> On 07.07.20 13:44, Cornelia Huck wrote:
>>> On Tue,  7 Jul 2020 12:42:05 +0200
>>> Thomas Huth <thuth@redhat.com> wrote:
>>>
>>>> When running the kvm-unit-tests with TCG on s390x, the cpumodel test
>>>> always reports the error about the missing DFP (decimal floating point)
>>>> facility. This is kind of expected, since DFP is not required for
>>>> running Linux and thus nobody is really interested in implementing
>>>> this facility in TCG. Thus let's mark this as an expected error instead,
>>>> so that we can run the kvm-unit-tests also with TCG without getting
>>>> test failures that we do not care about.
>>>>
>>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>>> ---
>>>>  v2:
>>>>  - Rewrote the logic, introduced expected_tcg_fail flag
>>>>  - Use manufacturer string instead of VM name to detect TCG
>>>>
>>>>  s390x/cpumodel.c | 49 ++++++++++++++++++++++++++++++++++++++++++------
>>>>  1 file changed, 43 insertions(+), 6 deletions(-)
>>>
>>> (...)
>>>
>>>> +static bool is_tcg(void)
>>>> +{
>>>> +	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
>>>> +	bool ret = false;
>>>> +	uint8_t *buf;
>>>> +
>>>> +	buf = alloc_page();
>>>> +	if (!buf)
>>>> +		return false;
>>>> +
>>>> +	if (stsi(buf, 1, 1, 1)) {
>>>> +		goto out;
>>>> +	}
>>>
>>> This does an alloc_page() and a stsi() every time you call it...
>>>
>>>> +
>>>> +	/*
>>>> +	 * If the manufacturer string is "QEMU" in EBCDIC, then we are on TCG
>>>> +	 * (otherwise the string is "IBM" in EBCDIC)
>>>> +	 */
>>>> +	if (!memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic)))
>>>> +		ret =  true;
>>>> +out:
>>>> +	free_page(buf);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +
>>>>  int main(void)
>>>>  {
>>>>  	int i;
>>>> @@ -46,11 +81,13 @@ int main(void)
>>>>  
>>>>  	report_prefix_push("dependency");
>>>
>>> ...so maybe cache the value for is_tcg() here instead of checking
>>> multiple times in the loop?
>>
>> Maybe move it to common code and do the detection early during boot? The
>> n provide is_tcg() or sth. like that. Could be helpful in other context
>> maybe.
>>
> 
> Well we also already have a check for zvm 6 with stsi 3.2.2 in skey.c
> I'm not completely convinced that I want to loose two pages and a few
> cycles on every startup for two separate test cases.

It certainly does not make sense to run the stsi calls during each and
every startup ... but I can move the is_tcg() function to the library
and make it a little bit smarter. I'll prepare a v3...

 Thomas

