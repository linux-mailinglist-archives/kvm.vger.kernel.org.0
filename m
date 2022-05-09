Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B471B51FEA7
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbiEINn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 09:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiEINny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 09:43:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082E925F783;
        Mon,  9 May 2022 06:40:01 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249Cnfqi010056;
        Mon, 9 May 2022 13:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KaM6NfPO229QO+fiaKS2LcD29LG5ybLesYObQGJaSO0=;
 b=VFxN66Hm4wQWQQaSevdP1h794j1hxUnY4e1tBXmayHeoltBfAHCAdDVJRl0mpVA/yyAI
 ih8tZOm5lKUbuHw4xvKs383el+68TUoYy62zVfMshdOgXGT9X2fwX5+mmw5qUqo8HMGb
 /wLzYHHiLDATrxvTj6HSm/qPg+1haHUTEt4e+tArvW66NAI69SWwEuzeVmQvcatRIu1H
 1ROvVSa+7Y1EB9QHwF+M1e/eGgTpelhM4F0n8m/Qgtk1wmsmv4yWAeIgTunvTd/V3BHI
 wkDximwTqVm8N1cY9E6kP7+Bcy0l1ye6dIYEm83NImIIncPPfkHoAp5S3qA2jIUQz45q 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy3a792g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 13:40:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249DV4fu015223;
        Mon, 9 May 2022 13:40:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy3a792f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 13:40:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249Dd7Z1025516;
        Mon, 9 May 2022 13:39:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j2m3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 13:39:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249Ddsbm33882496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 13:39:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43A54A405C;
        Mon,  9 May 2022 13:39:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14C3A4054;
        Mon,  9 May 2022 13:39:53 +0000 (GMT)
Received: from [9.171.38.150] (unknown [9.171.38.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 May 2022 13:39:53 +0000 (GMT)
Message-ID: <47b31afb-f202-2ac1-f614-4eae867f534d@linux.ibm.com>
Date:   Mon, 9 May 2022 15:39:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Test TEID values in storage key
 test
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
 <20220505124656.1954092-3-scgl@linux.ibm.com>
 <20220506173705.78f223dd@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220506173705.78f223dd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nmbY523c_bsuZUtwRS10hDUxNMIqAEK_
X-Proofpoint-ORIG-GUID: ZHUot8jpSVTCB_bEr4I_kYjoKqIrc79n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090077
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 17:37, Claudio Imbrenda wrote:
> On Thu,  5 May 2022 14:46:55 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> On a protection exception, test that the Translation-Exception
>> Identification (TEID) values are correct given the circumstances of the
>> particular test.
>> The meaning of the TEID values is dependent on the installed
>> suppression-on-protection facility.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  lib/s390x/asm/facility.h | 21 ++++++++++++++
>>  lib/s390x/sclp.h         |  2 ++
>>  lib/s390x/sclp.c         |  2 ++
>>  s390x/skey.c             | 60 ++++++++++++++++++++++++++++++++++++----
>>  4 files changed, 79 insertions(+), 6 deletions(-)
>>

[...]

>>  
>> +enum access {
>> +	ACC_FETCH = 2,
>> +	ACC_STORE = 1,
>> +	ACC_UPDATE = 3,
>> +};
> 
> why not in numerical order?

The numbers are chosen such that the bit masking in the function below
is nicer, but the ordering is basically arbitrary.
Somehow fetch, store, update seems natural to me, but I can sort it.
I had ACC_NONE for a bit, but as I don't need it, I removed it.
> 
>> +
>> +enum protection {
>> +	PROT_STORE = 1,
>> +	PROT_FETCH_STORE = 3,
>> +};
> 
> what happened to 2?

There is no such thing as fetch only protection, so that's a result
of the choice of values for masking.
> 
>> +
>> +static void check_key_prot_exc(enum access access, enum protection prot)
>> +{
>> +	struct lowcore *lc = 0;
>> +	union teid teid;
>> +
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	report_prefix_push("TEID");
>> +	teid.val = lc->trans_exc_id;
>> +	switch (get_supp_on_prot_facility()) {
>> +	case SOP_NONE:
>> +	case SOP_BASIC:
>> +		break;
>> +	case SOP_ENHANCED_1:
>> +		if ((teid.val & (BIT(63 - 61))) == 0)
> 
> why not teid.m?

I considered using .m, but the name does not contain any more information
on the meaning than just the number.
The PoP talks of the bits by their numbers in the suppression on detection
chapter, so this is the most straight forward translation into code.
> 
>> +			report_pass("key-controlled protection");
>> +		break;
>> +	case SOP_ENHANCED_2:
>> +		if ((teid.val & (BIT(63 - 56) | BIT(63 - 61))) == 0) {
> 
> maybe here you need to expand struct teid a little to accomodate for
> bit 56.

I could not think of a good name.
> 
>> +			report_pass("key-controlled protection");
>> +			if (teid.val & BIT(63 - 60)) {
>> +				int access_code = teid.fetch << 1 | teid.store;
>> +
>> +				report_info("access code: %d", access_code);
> 
> I don't like an unconditional report_info (it's ok to aid debugging if
> something fails)

In the case of update references the value you get is unspecified, so I found
it interesting to see what happens in LPAR.
I could only print it for update references, but I'm also fine with just
dropping it. What do you think?
> 
>> +				if (access_code == 2)
>> +					report((access & 2) && (prot & 2),
>> +					       "exception due to fetch");
>> +				if (access_code == 1)
>> +					report((access & 1) && (prot & 1),
>> +					       "exception due to store");
> 
> what about cases 0 and 3?

Case 0 is specified to not contain any information and 3 is reserved,
so also no information.

> if they should never happen, handle it properly
> and if they can happen... handle it properly
> 
>> +			}
>> +		}
>> +		break;
>> +	}
>> +	report_prefix_pop();
>> +}
>> +
>>  /*
>>   * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
>>   * with access key 1.
>> @@ -199,7 +247,7 @@ static void test_store_cpu_address(void)
>>  	expect_pgm_int();
>>  	*out = 0xbeef;
>>  	store_cpu_address_key_1(out);
>> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	check_key_prot_exc(ACC_STORE, PROT_STORE);
>>  	report(*out == 0xbeef, "no store occurred");
>>  	report_prefix_pop();
>>  
>> @@ -210,7 +258,7 @@ static void test_store_cpu_address(void)
>>  	expect_pgm_int();
>>  	*out = 0xbeef;
>>  	store_cpu_address_key_1(out);
>> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	check_key_prot_exc(ACC_STORE, PROT_STORE);
>>  	report(*out == 0xbeef, "no store occurred");
>>  	report_prefix_pop();
>>  
>> @@ -228,7 +276,7 @@ static void test_store_cpu_address(void)
>>  	expect_pgm_int();
>>  	*out = 0xbeef;
>>  	store_cpu_address_key_1(out);
>> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	check_key_prot_exc(ACC_STORE, PROT_STORE);
>>  	report(*out == 0xbeef, "no store occurred");
>>  	report_prefix_pop();
>>  
>> @@ -314,7 +362,7 @@ static void test_set_prefix(void)
>>  	set_storage_key(pagebuf, 0x28, 0);
>>  	expect_pgm_int();
>>  	set_prefix_key_1(prefix_ptr);
>> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
>>  	report(get_prefix() == old_prefix, "did not set prefix");
>>  	report_prefix_pop();
>>  
>> @@ -327,7 +375,7 @@ static void test_set_prefix(void)
>>  	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>>  	set_prefix_key_1((uint32_t *)0);
>>  	install_page(root, 0, 0);
>> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
>>  	report(get_prefix() == old_prefix, "did not set prefix");
>>  	report_prefix_pop();
>>  
>> @@ -351,7 +399,7 @@ static void test_set_prefix(void)
>>  	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>>  	set_prefix_key_1((uint32_t *)2048);
>>  	install_page(root, 0, 0);
>> -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>> +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
>>  	report(get_prefix() == old_prefix, "did not set prefix");
>>  	report_prefix_pop();
>>  
> 

