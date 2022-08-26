Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3F5A2733
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 13:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiHZLzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 07:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245744AbiHZLz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 07:55:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D211E3E9;
        Fri, 26 Aug 2022 04:55:26 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QAN47U009955;
        Fri, 26 Aug 2022 11:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FiBljqrIEVjKMy2wC5BpSUUQNIEv8UWlZrLIySIxAUg=;
 b=tANuad1WT9Hv50lSGEi67CkQkhqIMW+5yjBtjCcWL9i+OKwtSsnFoAPI5ZhpbuZ9RkoT
 cbCFIA+815POI4hxAHFAQj13T38gnDJV0QX1AaIjJM9yD/t773a5p7c1HrrcLRe+gKzu
 jVaPNYxDkxF0u3AK9yCcWEr7qLEsqKefQkodPxZEDv35MjFel760vnowjKHFoWretO3n
 Kqi6kRIvDfuoH/SUniA8uog5LsYuPCekC/IV9zVHI9eKTh/1C8BjKfTfMZWFuaarlYKk
 s33BzDbB9cai6D7luCY0l52DoclLnkGwk/fWhF7d+SQ33zvEuoZEvcekzWUTjMcoOac1 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6vchjdxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 11:55:19 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27QBiWaG017602;
        Fri, 26 Aug 2022 11:55:18 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6vchjdxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 11:55:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27QBpS90014568;
        Fri, 26 Aug 2022 11:55:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88yp2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 11:55:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27QBtDXB31719808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 11:55:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D30CCA4040;
        Fri, 26 Aug 2022 11:55:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C05BA404D;
        Fri, 26 Aug 2022 11:55:13 +0000 (GMT)
Received: from [9.145.186.191] (unknown [9.145.186.191])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 11:55:13 +0000 (GMT)
Message-ID: <8aa423e5-39e9-155d-b1ed-df4ebef72757@linux.ibm.com>
Date:   Fri, 26 Aug 2022 13:55:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        qemu-s390x@nongnu.org
References: <20220720142526.29634-1-scgl@linux.ibm.com>
 <20220720142526.29634-2-scgl@linux.ibm.com>
 <1d0ef541-2b83-3c61-ec22-d5bf9a7698af@linux.ibm.com>
 <c7d094b7eb2d06449f8afe2d8486a0e853858483.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/2] s390x: Add specification exception
 test
In-Reply-To: <c7d094b7eb2d06449f8afe2d8486a0e853858483.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wfTNMdiSVx8P-H8DkhOkmOELSP8fZ3_C
X-Proofpoint-GUID: GnsFrYPRRdKHjRhJAk4Mc7XQjQm2nNYp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/22 13:23, Janis Schoetterl-Glausch wrote:
> On Wed, 2022-08-24 at 11:35 +0200, Janosch Frank wrote:
>> On 7/20/22 16:25, Janis Schoetterl-Glausch wrote:
>>> Generate specification exceptions and check that they occur.
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> ---
>>>    s390x/Makefile           |   1 +
>>>    lib/s390x/asm/arch_def.h |   5 ++
>>>    s390x/spec_ex.c          | 180 +++++++++++++++++++++++++++++++++++++++
>>>    s390x/unittests.cfg      |   3 +
>>>    4 files changed, 189 insertions(+)
>>>    create mode 100644 s390x/spec_ex.c
>>>
>>>
>>> +
>>> +/*
>>> + * Load possibly invalid psw, but setup fixup_psw before,
>>> + * so that fixup_invalid_psw() can bring us back onto the right track.

Not sure if the second line is needed as fixup_psw is a descriptive name 
already.

>>> + * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
>>> + */
>>> +static void load_psw(struct psw psw)
>>> +{
>>> +	uint64_t scratch;
>>> +
> 
> [...]
> 
>> /*
>> Store a valid mask and the address of the nop into the fixup PSW.
>> Then load the possibly invalid PSW.
>> */
> 
> This seems a bit redundant given the function comment, but I can
> drop a comment in here describing how the fixup psw is computed.

Well, I skipped the function comment, got confused by the addr asm 
variable and then decided to propose the comment.

It's a bit confusing since you have the invalid PSW and the global fixup 
PSW in one function.

Maybe something like:
/* From here to the lpswe we're computing and setting the fixup PSW */

> 
>>
>>> +	fixup_psw.mask = extract_psw_mask();
>>> +	asm volatile ( "larl	%[scratch],0f\n"
>>> +		"	stg	%[scratch],%[addr]\n"
>>> +		"	lpswe	%[psw]\n"
>>> +		"0:	nop\n"
>>> +		: [scratch] "=&d"(scratch),
>>> +		  [addr] "=&T"(fixup_psw.addr)
>>
>> s/addr/psw_addr/ ?
>>
>>> +		: [psw] "Q"(psw)
>>> +		: "cc", "memory"
>>> +	);
>>> +}
>>> +
>>> +static void load_short_psw(struct short_psw psw)
>>> +{
>>> +	uint64_t scratch;
>>> +
>>> +	fixup_psw.mask = extract_psw_mask();
>>> +	asm volatile ( "larl	%[scratch],0f\n"
>>> +		"	stg	%[scratch],%[addr]\n"
>>> +		"	lpsw	%[psw]\n"
>>> +		"0:	nop\n"
>>> +		: [scratch] "=&d"(scratch),
>>> +		  [addr] "=&T"(fixup_psw.addr)
>>> +		: [psw] "Q"(psw)
>>> +		: "cc", "memory"
>>> +	);
>>
>> Same story.
> 
> Do you want me to repeat the comments here or just rename addr?

Just rename addr

> 
> [...]
> 
>>> +static int not_even(void)
>>> +{
>>> +	uint64_t quad[2] __attribute__((aligned(16))) = {0};
>>> +
>>> +	asm volatile (".insn	rxy,0xe3000000008f,%%r7,%[quad]" /* lpq %%r7,%[quad] */
>>> +		      : : [quad] "T"(quad)
>>
>> Is there a reason you never put a space after the constraint?
> 
> TBH I never noticed I'm unusual in that regard. I guess I tend to think
> of the operand and constraint as one entity.
> I'll add the spaces.
> 
>>
>>> +		      : "%r7", "%r8"
>>> +	);
>>> +	return 0;
>>> +}
>>> +
> 
> [...]

