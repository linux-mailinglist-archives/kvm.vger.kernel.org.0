Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26F328F40E
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 15:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgJON5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 09:57:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729498AbgJON5j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 09:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602770257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KViyPGdm6olCnz8EV44efLrs3jK+B9YKvvQ8JydTcFg=;
        b=Uw6Mz4hUP7s3I5xi4p+vbmvsWOMkAOyX0fisRo9Tv/g+MVSwJOPTgkKUjlPna4hGFOZNnJ
        gzPGRso712kc7ODiTwTL9B6+d8DgBy/o5HCB6SgPWer74kb5p1MXVauzmo0cHWvVzNXIdJ
        Wm84l0FspOJDOukvJLZo5ROu/WoWAP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-A0Cs4yKIMbmI_qNayNxgVQ-1; Thu, 15 Oct 2020 09:57:36 -0400
X-MC-Unique: A0Cs4yKIMbmI_qNayNxgVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08D1410309BC;
        Thu, 15 Oct 2020 13:56:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-184.ams2.redhat.com [10.36.113.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1048D5D9D5;
        Thu, 15 Oct 2020 13:56:44 +0000 (UTC)
Subject: Re: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
To:     Janosch Frank <frankja@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com
References: <20201014192710.66578-1-walling@linux.ibm.com>
 <d90a2c37-46b7-5fc9-efb8-c5a6bb1c6d7e@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e5b92b5c-93ef-462f-e597-e5436f414f21@redhat.com>
Date:   Thu, 15 Oct 2020 15:56:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d90a2c37-46b7-5fc9-efb8-c5a6bb1c6d7e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/2020 14.40, Janosch Frank wrote:
> On 10/14/20 9:27 PM, Collin Walling wrote:
>> The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged call
>> that must be intercepted via SIE, handled in userspace, and the
>> information set by the instruction is communicated back to KVM.
> 
> It might be nice to have a few words in here about what information can
> be set via the diag.
> 
>>
>> To test the instruction interception, an ad-hoc handler is defined which
>> simply has a VM execute the instruction and then userspace will extract
>> the necessary info. The handler is defined such that the instruction
>> invocation occurs only once. It is up the the caller to determine how the
>> info returned by this handler should be used.
>>
>> The diag318 info is communicated from userspace to KVM via a sync_regs
>> call. This is tested during a sync_regs test, where the diag318 info is
>> requested via the handler, then the info is stored in the appropriate
>> register in KVM via a sync registers call.
>>
>> The diag318 info is checked to be 0 after a normal and clear reset.
>>
>> If KVM does not support diag318, then the tests will print a message
>> stating that diag318 was skipped, and the asserts will simply test
>> against a value of 0.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> 
> Checkpatch throws lots of errors on this patch.
> Could you check if my workflow misteriously introduced windows line
> endings or if they were introduced on your side?

How did you feed the patch into checkpatch? IIRC mails are often sent with
CR-LF line endings by default - it's "git am" that is converting the line
endings back to the Unix default. So for running a patch through checkpatch,
you might need to do "git am" first and then export it again.

>> +uint64_t get_diag318_info(void)
>> +{
>> +	static uint64_t diag318_info;
>> +	static bool printed_skip;
>> +
>> +	/*
>> +	 * If KVM does not support diag318, then return 0 to
>> +	 * ensure tests do not break.
>> +	 */
>> +	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
>> +		if (!printed_skip) {
>> +			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "
> 
> Whitespace after .
> 
>> +				"Skipping diag318 test.\n");

It's a multi-line text, so the whitespace is needed, isn't it?

>> +			printed_skip = true;
>> +		}
>> +		return 0;
>> +	}

 Thomas

