Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30466D66BB
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjDDPF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjDDPFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:05:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F526A3
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ouwnrwLljSsx4XjHN7ba8E7vy+InPl3MvOgp+B1gAZ0=;
        b=X1V0XpDBrmm+4eMZBJstdx6yonXdDd7T3cRa72hfN/ABgZKO5kWoroou+SDHZxx5LdWhPj
        BrHyL448msaCq2oCZFqQf4Bq8+CykC4uyuEQJuDJN6b3NyM3X5hg9aCdOm1p97FmRS4inR
        BamNP8rlmkcLEHVIyomRPl2hh7iwqks=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-X6px5fQSNJufQdzj-rzb7A-1; Tue, 04 Apr 2023 11:05:07 -0400
X-MC-Unique: X6px5fQSNJufQdzj-rzb7A-1
Received: by mail-qk1-f197.google.com with SMTP id s2-20020a37a902000000b0074a28a891baso4329404qke.18
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620706;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouwnrwLljSsx4XjHN7ba8E7vy+InPl3MvOgp+B1gAZ0=;
        b=k77gwi0JrbIyOmsQmP9qZ5FNsShOtmjxQdiBmXqKH0GqGSChIPrh+e9Npe8xvYArOG
         T4Rp2imqPMbxQ/aBod0Um/7rdsOoa2PKFdApqY//RB9C7sYx8YcvK54HX+q3vsr/JbHG
         zCPkePdDpVxrqb890gH02pV/cVcExCPX5EGLpw6ECTDrl1frbAIfIuPWVPg7Uho9Tr2Y
         IveVOd1F7n5kP+/hfV5gwxdUWFYMsR1pFiXUDyOuBCK2kqvQtn2ARi5heFK3WiKxzzQr
         MsAqRttjRE1u9G8kqb5JZfMwccfGCmH9fcA53b5luw3BwqmLTSOFHUbnz5W33yNGOuju
         Lz7A==
X-Gm-Message-State: AAQBX9e9sHLqfVINySWGkacjy3IOBwO+gmiaxLtiV9Ac+lt9j9Cz11sL
        v0TzkPCRx9OXpBwEnhIOPbktpKyJ/FmTloMeCT1sHVZfe5bCM/8c22Byh7VRYZHkZ+1NW2P6fkQ
        RP09Xbw1ti9fG
X-Received: by 2002:ac8:5990:0:b0:3bf:e364:1d19 with SMTP id e16-20020ac85990000000b003bfe3641d19mr3897446qte.54.1680620705994;
        Tue, 04 Apr 2023 08:05:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZAYCjRu36qI6PQNhCBXi+Qhv7qtmZ3FrDFqLk0kdHuVbhbaxj0F7Gz3Phty+/c04UnneHmHw==
X-Received: by 2002:ac8:5990:0:b0:3bf:e364:1d19 with SMTP id e16-20020ac85990000000b003bfe3641d19mr3897388qte.54.1680620705523;
        Tue, 04 Apr 2023 08:05:05 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id m9-20020ac84449000000b003e37ee54b5dsm3287551qtn.90.2023.04.04.08.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 08:05:04 -0700 (PDT)
Message-ID: <bf0f892e-7b7d-5806-b038-8392144da644@redhat.com>
Date:   Tue, 4 Apr 2023 17:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
        andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20230404113639.37544-1-nrb@linux.ibm.com>
 <20230404113639.37544-12-nrb@linux.ibm.com>
 <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com>
 <06fd3ebc7770d1327be90cee10d12251cca76dd3.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests GIT PULL v2 11/14] s390x: Add tests for
 execute-type instructions
In-Reply-To: <06fd3ebc7770d1327be90cee10d12251cca76dd3.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/04/2023 16.54, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-04 at 16:15 +0200, Thomas Huth wrote:
>> On 04/04/2023 13.36, Nico Boehr wrote:
>>> From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>>
>>> Test the instruction address used by targets of an execute instruction.
>>> When the target instruction calculates a relative address, the result is
>>> relative to the target instruction, not the execute instruction.
>>>
>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Link: https://lore.kernel.org/r/20230317112339.774659-1-nsg@linux.ibm.com
>>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>>> ---
>>>    s390x/Makefile      |   1 +
>>>    s390x/ex.c          | 188 ++++++++++++++++++++++++++++++++++++++++++++
>>>    s390x/unittests.cfg |   3 +
>>>    .gitlab-ci.yml      |   1 +
>>>    4 files changed, 193 insertions(+)
>>>    create mode 100644 s390x/ex.c
>>>
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index ab146eb..a80db53 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>>>    tests += $(TEST_DIR)/panic-loop-pgm.elf
>>>    tests += $(TEST_DIR)/migration-sck.elf
>>>    tests += $(TEST_DIR)/exittime.elf
>>> +tests += $(TEST_DIR)/ex.elf
>>>    
>>>    pv-tests += $(TEST_DIR)/pv-diags.elf
>>>    
>>> diff --git a/s390x/ex.c b/s390x/ex.c
>>> new file mode 100644
>>> index 0000000..dbd8030
>>> --- /dev/null
>>> +++ b/s390x/ex.c
>>> @@ -0,0 +1,188 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright IBM Corp. 2023
>>> + *
>>> + * Test EXECUTE (RELATIVE LONG).
>>> + * These instructions execute a target instruction. The target instruction is formed
>>> + * by reading an instruction from memory and optionally modifying some of its bits.
>>> + * The execution of the target instruction is the same as if it was executed
>>> + * normally as part of the instruction sequence, except for the instruction
>>> + * address and the instruction-length code.
>>> + */
>>> +
>>> +#include <libcflat.h>
>>> +
>>> +/*
>>> + * Accesses to the operand of execute-type instructions are instruction fetches.
>>> + * Minimum alignment is two, since the relative offset is specified by number of halfwords.
>>> + */
>>> +asm (  ".pushsection .text.exrl_targets,\"x\"\n"
>>> +"	.balign	2\n"
>>> +"	.popsection\n"
>>> +);
>>> +
>>> +/*
>>> + * BRANCH AND SAVE, register register variant.
>>> + * Saves the next instruction address (address from PSW + length of instruction)
>>> + * to the first register. No branch is taken in this test, because 0 is
>>> + * specified as target.
>>> + * BASR does *not* perform a relative address calculation with an intermediate.
>>> + */
>>> +static void test_basr(void)
>>> +{
>>> +	uint64_t ret_addr, after_ex;
>>> +
>>> +	report_prefix_push("BASR");
>>> +	asm volatile ( ".pushsection .text.exrl_targets\n"
>>> +		"0:	basr	%[ret_addr],0\n"
>>> +		"	.popsection\n"
>>> +
>>> +		"	larl	%[after_ex],1f\n"
>>> +		"	exrl	0,0b\n"
>>> +		"1:\n"
>>> +		: [ret_addr] "=d" (ret_addr),
>>> +		  [after_ex] "=d" (after_ex)
>>> +	);
>>> +
>>> +	report(ret_addr == after_ex, "return address after EX");
>>> +	report_prefix_pop();
>>> +}
>>> +
>>> +/*
>>> + * BRANCH RELATIVE AND SAVE.
>>> + * According to PoP (Branch-Address Generation), the address calculated relative
>>> + * to the instruction address is relative to BRAS when it is the target of an
>>> + * execute-type instruction, not relative to the execute-type instruction.
>>> + */
>>> +static void test_bras(void)
>>> +{
>>> +	uint64_t after_target, ret_addr, after_ex, branch_addr;
>>> +
>>> +	report_prefix_push("BRAS");
>>> +	asm volatile ( ".pushsection .text.exrl_targets\n"
>>> +		"0:	bras	%[ret_addr],1f\n"
>>> +		"	nopr	%%r7\n"
>>> +		"1:	larl	%[branch_addr],0\n"
>>> +		"	j	4f\n"
>>> +		"	.popsection\n"
>>> +
>>> +		"	larl	%[after_target],1b\n"
>>> +		"	larl	%[after_ex],3f\n"
>>> +		"2:	exrl	0,0b\n"
>>> +/*
>>> + * In case the address calculation is correct, we jump by the relative offset 1b-0b from 0b to 1b.
>>> + * In case the address calculation is relative to the exrl (i.e. a test failure),
>>> + * put a valid instruction at the same relative offset from the exrl, so the test continues in a
>>> + * controlled manner.
>>> + */
>>> +		"3:	larl	%[branch_addr],0\n"
>>> +		"4:\n"
>>> +
>>> +		"	.if (1b - 0b) != (3b - 2b)\n"
>>> +		"	.error	\"right and wrong target must have same offset\"\n"
>>> +		"	.endif\n"
>>
>> FWIW, this is failing with Clang 15 for me:
>>
>> s390x/ex.c:81:4: error: expected absolute expression
>>                   "       .if (1b - 0b) != (3b - 2b)\n"
>>                    ^
>> <inline asm>:12:6: note: instantiated into assembly here
>>           .if (1b - 0b) != (3b - 2b)
> 
> Seems gcc is smarter here than clang.

Yeah, the assembler from clang is quite a bit behind on s390x ... in the 
past I was only able to compile the k-u-t with Clang when using the 
"-no-integrated-as" option ... but at least in the most recent version it 
seems to have caught up now enough to be very close to compile it with the 
built-in assembler, so it would be great to get this problem here fixed 
somehow, too...

> Just deleting that .if block would work, it's basically only a static assert.
> What do you think?
> Other than that I can't think of anything.

Yes, either delete it ... or maybe you could return the two values (1b - 0b) 
and (3b - 2b) as output from the asm statement and do an assert() in C instead?

  Thomas

