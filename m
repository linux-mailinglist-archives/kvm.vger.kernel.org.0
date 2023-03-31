Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E556D1ADC
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 10:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCaIwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 04:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCaIwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 04:52:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFF5D50E;
        Fri, 31 Mar 2023 01:52:40 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V87uow009609;
        Fri, 31 Mar 2023 08:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cZEUURmtTVuUK0MDRwsX/TKBZK1xujBKBauZKi96U7Y=;
 b=HRPT+O3IhznKGHV4tBtGYPc+9P5LZ/I3/4Kee5bX1QxcHKJ170S4P9836vN7wRvRTzXl
 2otHLf/jqrsfNiYWB648R6e9k01WjMm2GuBO3njqNihP8uXe8IiZIzw+5dJ2OqoIsVm9
 sR06Q8WyEQnYU5gHZPwyLn7cJnTaR10vBr/PfWvKKUn2qSd5glhc1ym2/7np2UxC3XOC
 vLj+r7MGcl5Lirt0w7wLgpPa4xlWZvNwN5XRG1A5i01Q7lQSsWe/fk+rFWOc9hnE9xuJ
 nyiy678Hy3s/kAc4o3rYQ5tU8nEbnG9Z1pJRA94rPJQ/mQ0fOnfcL8o5qRs13UiGFk7O vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnrf7n922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:52:40 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V8KLYg024335;
        Fri, 31 Mar 2023 08:52:39 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnrf7n91k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:52:39 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32V1I3NL013053;
        Fri, 31 Mar 2023 08:52:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fpkq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:52:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V8qXVM8520266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 08:52:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9561E2004B;
        Fri, 31 Mar 2023 08:52:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4232C20043;
        Fri, 31 Mar 2023 08:52:33 +0000 (GMT)
Received: from [9.171.33.158] (unknown [9.171.33.158])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 08:52:33 +0000 (GMT)
Message-ID: <5a768b62-0552-1174-2040-a9ee04fbc49a@linux.ibm.com>
Date:   Fri, 31 Mar 2023 10:52:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20230330114244.35559-1-frankja@linux.ibm.com>
 <20230330114244.35559-3-frankja@linux.ibm.com>
 <20230330183431.3003b391@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: Add guest 2 AP test
In-Reply-To: <20230330183431.3003b391@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4oXW-bWzKutIZJKrKPeEkUUM9gmxREW_
X-Proofpoint-GUID: FkojFadE93KE8wp8aVc_thEPtlwwWh-I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310070
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/23 18:34, Claudio Imbrenda wrote:
> On Thu, 30 Mar 2023 11:42:41 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Add a test that checks the exceptions for the PQAP, NQAP and DQAP
>> adjunct processor (AP) crypto instructions.
>>
>> Since triggering the exceptions doesn't require actual AP hardware,
>> this test can run without complicated setup.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
> 
> [...]
> 
>> +
>> +static void test_pgms_pqap(void)
>> +{
>> +	unsigned long grs[3] = {};
>> +	struct pqap_r0 *r0 = (struct pqap_r0 *)grs;
>> +	uint8_t *data = alloc_page();
>> +	uint16_t pgm;
>> +	int fails = 0;
>> +	int i;
>> +
>> +	report_prefix_push("pqap");
>> +
>> +	/* Wrong FC code */
>> +	report_prefix_push("invalid fc");
>> +	r0->fc = 42;
> 
> maybe make a macro out of it, both to avoid magic numbers and to change
> it easily if code 42 will ever become defined in the future.

I don't really see a benefit to that.

> 
>> +	expect_pgm_int();
>> +	pqap(grs);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	memset(grs, 0, sizeof(grs));
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("invalid gr0 bits");
>> +	for (i = 42; i < 6; i++) {
> 
> 42 is not < 6, this whole thing will be skipped?

Right, I've fixed this.

[...]
>> +
>> +static void test_pgms_nqap(void)
>> +{
>> +	uint8_t gr0_zeroes_bits[] = {
>> +		32, 34, 35, 40
>> +	};
>> +	uint64_t gr0;
>> +	bool fail;
>> +	int i;
>> +
>> +	report_prefix_push("nqap");
>> +
>> +	/* Registers 0 and 1 are always used, the others are
>> even/odd pairs */
>> +	report_prefix_push("spec");
>> +	report_prefix_push("r1");
>> +	expect_pgm_int();
>> +	asm volatile (
>> +		".insn	rre,0xb2ad0000,3,6\n"
>> +		: : : "cc", "memory", "0", "1", "2", "3");
> 
> I would say
> "0", "1", "2", "3", "4", "6", "7"
> 
> since there are two ways of doing it wrong when it comes to even-odd
> register pairs (r and r+1, r&~1 and r&~1+1)

R1 & R1 + 1 should never change, same goes for R2.
GR0, GR1, R2 + 1 could potentially change.

But the more interesting question is: Does it make sense to clobber 
anything other than cc (if at all) for the PGM checks? If the PGM fails 
we're in uncharted territory. Seems like I need to look up what the 
other tests do.
