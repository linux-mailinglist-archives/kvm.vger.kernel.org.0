Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14DA6D18A3
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCaHdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 03:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCaHdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 03:33:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBA5C159;
        Fri, 31 Mar 2023 00:33:00 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V6eUWr002220;
        Fri, 31 Mar 2023 07:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NuUvwi7suuijAC5viwO7kOzpWj340sI6b8SEypL4Foo=;
 b=gA1zFled//gdRZUtSTnS2HpmZAQbmrjPR6dMges9EtYQU3hmgrLxsT41p2XBo46QYPEM
 B3uHQsE4rT8wWZvXWp7/mOKdNkR1aMJmafCl6rrpW07IXigHiWmJt06Df26SlNkMqs+e
 XcBB7bGnf+1YvowCsHiRKPHmA/xfCybNojLC/kj3pBKEkJ+viWd6hhDRzNnlygUViech
 YykfOKdqYKx04BbaAl8BAbHuMqVJjkIXqYHM16HdCfuMzO4hQa7A0flmvC4zvz/FRcto
 W7j6C3mmEdRDnny/HL+IYxf0Wo+iH8hz0xHLRJ4DF1UPxXc07tRFElChSpDIP8Hr7b1Q 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnssahtfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 07:32:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32V7IRbB014072;
        Fri, 31 Mar 2023 07:32:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnssahtem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 07:32:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32V3NtTH002045;
        Fri, 31 Mar 2023 07:32:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6pjj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 07:32:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32V7WrBF27328882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 07:32:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CFC420043;
        Fri, 31 Mar 2023 07:32:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B93E20040;
        Fri, 31 Mar 2023 07:32:53 +0000 (GMT)
Received: from [9.171.33.158] (unknown [9.171.33.158])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 07:32:52 +0000 (GMT)
Message-ID: <48211984-10a3-9f78-728b-efc41d0fde5d@linux.ibm.com>
Date:   Fri, 31 Mar 2023 09:32:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: Add ap library
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20230330114244.35559-1-frankja@linux.ibm.com>
 <20230330114244.35559-2-frankja@linux.ibm.com>
 <20230330180900.723c060d@p-imbrenda>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230330180900.723c060d@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PjMI5-8Xo0MQ4O-BiBoY5Twnn1ywjAu-
X-Proofpoint-GUID: ue8BPWnI3YZW4d4_6hxA81JUEIvMFZaK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_02,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310058
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/23 18:09, Claudio Imbrenda wrote:
> On Thu, 30 Mar 2023 11:42:40 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Add functions and definitions needed to test the Adjunct
>> Processor (AP) crypto interface.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>
> 
> [...]
> 
>> +bool ap_check(void)
>> +{
>> +	struct ap_queue_status r1 = {};
>> +	struct pqap_r2 r2 = {};
>> +
>> +	/* Base AP support has no STFLE or SCLP feature bit */
> 
> this is true, but you are also indiscriminately using a feature for
> which there is a STFLE feature. since it seems you depend on that, you
> might as well just check bit for STFLE.12 and assume the base support
> is there if it's set

Fair enough.

> 
>> +	expect_pgm_int();
>> +	ap_pqap_tapq(0, 0, &r1, &r2);
>> +
>> +	if (clear_pgm_int() == PGM_INT_CODE_OPERATION)
>> +		return false;
>> +
>> +	return true;
>> +}
> 
> [...]
> 
>> +struct ap_config_info {
>> +	uint8_t apsc	 : 1;	/* S bit */
>> +	uint8_t apxa	 : 1;	/* N bit */
>> +	uint8_t qact	 : 1;	/* C bit */
>> +	uint8_t rc8a	 : 1;	/* R bit */
>> +	uint8_t l	 : 1;	/* L bit */
>> +	uint8_t lext	 : 3;	/* Lext bits */
>> +	uint8_t reserved2[3];
>> +	uint8_t Na;		/* max # of APs - 1 */
>> +	uint8_t Nd;		/* max # of Domains - 1 */
>> +	uint8_t reserved6[10];
>> +	uint32_t apm[8];	/* AP ID mask */
> 
> is there a specific reason why these are uint32_t?
> uint64_t would maybe make your life easier in subsequent patches (see my
> comments there)

That's how the architecture specifies it.
That part of the IO architecture works with words, it seems to be quite old.
