Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232F5529D2A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 11:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbiEQJDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 05:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiEQJDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 05:03:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546213EF1C;
        Tue, 17 May 2022 02:03:18 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24H7SPLv031736;
        Tue, 17 May 2022 09:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3QUhmZXPVcQxci8cAYYk9IckjbbSox3CEqv5p5nNCS8=;
 b=CS9cDs3UbgGbGlKH3gFjeEFKU7vt6u3JucA9TWOHh6GE+RiKAzfHD2OF9gWiELx5V2c1
 FFOxfndhMTqY0UMNzKg5K8fejvRYfIPHqY0zCC2Vgl/cmtHlrtXwkN3PAs4VTaHguKhQ
 9J7mQvvnCeSa9TgvD2KKLeqk+KcMpkh9zeMpVWbKGIpf/YbzhKUXTeTWfVKtypf3H0BJ
 /FERr8KJykNQ19tlFETcIY082zqMsJGrmz1XzV4Myfb2FXlRWWK5ulTe7RGXxeq01dq5
 1/oyRVPJ8RPNidAT7y+4lqgjU5AcNCxiJ1ktJG6hTYnYYzmtPeD4+qPc3R0EgJjiV48o 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g47bmsym8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 09:03:17 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24H8uUqr004603;
        Tue, 17 May 2022 09:03:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g47bmsyk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 09:03:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24H92X9B021498;
        Tue, 17 May 2022 09:03:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428u40f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 09:03:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24H92dkU34931164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 09:02:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8540CA4040;
        Tue, 17 May 2022 09:03:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36532A404D;
        Tue, 17 May 2022 09:03:11 +0000 (GMT)
Received: from [9.145.157.61] (unknown [9.145.157.61])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 09:03:11 +0000 (GMT)
Message-ID: <719224db-3a24-d38f-6678-2d3f08963ac0@linux.ibm.com>
Date:   Tue, 17 May 2022 11:03:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 3/6] s390x: uv-host: Test uv immediate
 parameter
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-4-frankja@linux.ibm.com>
 <8c852bcd-6b42-4b54-d3ff-5d63a389b05d@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <8c852bcd-6b42-4b54-d3ff-5d63a389b05d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZReUu0c3jMRKIcsFxq2sdwNgP_o_UURC
X-Proofpoint-ORIG-GUID: jCDmW6tfBM9wMKiD60Xcs6Ihk4HMqyFg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170055
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 10:29, Steffen Eiden wrote:
> Hey Janosch,
> 
> On 5/13/22 11:50, Janosch Frank wrote:
>> Let's check if we get a specification PGM exception if we set a
>> non-zero i3 when doing a UV call.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/uv-host.c | 23 +++++++++++++++++++++++
>>    1 file changed, 23 insertions(+)
>>
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index f846fc42..fcb82d24 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -64,6 +64,28 @@ static struct cmd_list cmds[] = {
>>    	{ NULL, 0, 0 },
>>    };
>>    
>> +static void test_i3(void)
>> +{
>> +	struct uv_cb_header uvcb = {
>> +		.cmd = UVC_CMD_INIT_UV,
>> +		.len = sizeof(struct uv_cb_init),
>> +	};
>> +	unsigned long r1 = 0;
> Did you forgot 'r2' or is it missing for a reason?

The uvcb is the r2, have a look at the clobbers below

> 
>> +	int cc;
>> +
>> +	report_prefix_push("i3");
>> +	expect_pgm_int();
>> +	asm volatile(
>> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],4,2\n"
>> +		"		ipm	%[cc]\n"
>> +		"		srl	%[cc],28\n"
>> +		: [cc] "=d" (cc)
>> +		: [r1] "a" (r1), [r2] "a" (&uvcb)
>> +		: "memory", "cc");
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	report_prefix_pop();
>> +}
>> +
>>    static void test_priv(void)
>>    {
>>    	struct uv_cb_header uvcb = {};
>> @@ -585,6 +607,7 @@ int main(void)
>>    		goto done;
>>    	}
>>    
>> +	test_i3();
>>    	test_priv();
>>    	test_invalid();
>>    	test_uv_uninitialized();

