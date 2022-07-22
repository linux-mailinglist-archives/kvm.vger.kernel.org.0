Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9157DBA9
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 10:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiGVIA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 04:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiGVIAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 04:00:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D1550F4
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 01:00:49 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M7VLV1015746
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:00:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wLAP8+UosC3bipynSKDEDCjV5dRGVMNcc9xz9vyJXIk=;
 b=f/KFiEoEUxPsoD7TmMPf6iEa8kdYLVK2KZFEyKu8gShxudJi2F82IQ0YBT8LOH2oabUz
 88Xxx15SFjFxUwrl4/WOJHjZQo/ZAq50cPKyLCQ7HT9yLnlPwLVYoK5kvHSPPNPBHZA4
 rik76W8t9LNOprUFMLRdB3+i/MPp/6MnABD2dG1VQIWDIBPKYT/ZC7EQborRvrtWPzuh
 TSc0GtK/zIzDS2r4JJm/7Zr4e7hJUlua4n2M0EXOxfkr79mB4S8kauLuqWToZYTW0+5+
 paWMkweozJeLaC0b8MDir2Bgv/8LljdKYme1vxzl24C2Hgk4bqW2IF9HQSN4MAG9DzcP Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfqk1gn76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:00:48 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M7ZC2F031091
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 08:00:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfqk1gn60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:00:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M7oqHm003586;
        Fri, 22 Jul 2022 08:00:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8yydm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 08:00:46 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M7wrjG21561768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 07:58:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BFFDA405B;
        Fri, 22 Jul 2022 08:00:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEFBEA4054;
        Fri, 22 Jul 2022 08:00:42 +0000 (GMT)
Received: from [9.145.175.204] (unknown [9.145.175.204])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 08:00:42 +0000 (GMT)
Message-ID: <b620492e-6e02-8946-40cd-d92769f209c8@linux.ibm.com>
Date:   Fri, 22 Jul 2022 10:00:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 1/3] s390x: smp: move sigp calls with
 invalid cpu address to array
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220722072004.800792-1-nrb@linux.ibm.com>
 <20220722072004.800792-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220722072004.800792-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OtqMI-Wott2rSQEqbq6RTmX1-0BQ6pkk
X-Proofpoint-GUID: LscMNW-SzoWA3PuUCoNfn8fWMwJJJmJo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/22 09:20, Nico Boehr wrote:
> We have the nice array to test SIGP calls with invalid CPU addresses.
> Move the SIGP cases there to eliminate some of the duplicated code in
> test_emcall and test_cond_emcall.
> 
> Since adding coverage for invalid CPU addresses in the ecall case is now
> trivial, do that as well.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/smp.c | 18 +++---------------
>   1 file changed, 3 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 0df4751f9cee..34ae91c3fe12 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -30,6 +30,9 @@ static const struct sigp_invalid_cases cases_invalid_cpu_addr[] = {
>   	{ SIGP_STOP,                  "stop with invalid CPU address" },
>   	{ SIGP_START,                 "start with invalid CPU address" },
>   	{ SIGP_CPU_RESET,             "reset with invalid CPU address" },
> +	{ SIGP_COND_EMERGENCY_SIGNAL, "conditional emcall with invalid CPU address" },
> +	{ SIGP_EMERGENCY_SIGNAL,      "emcall with invalid CPU address" },
> +	{ SIGP_EXTERNAL_CALL,         "ecall with invalid CPU address" },
>   	{ INVALID_ORDER_CODE,         "invalid order code and CPU address" },
>   	{ SIGP_SENSE,                 "sense with invalid CPU address" },
>   	{ SIGP_STOP_AND_STORE_STATUS, "stop and store status with invalid CPU address" },
> @@ -329,7 +332,6 @@ static void emcall(void)
>   static void test_emcall(void)
>   {
>   	struct psw psw;
> -	int cc;
>   	psw.mask = extract_psw_mask();
>   	psw.addr = (unsigned long)emcall;
>   
> @@ -343,13 +345,6 @@ static void test_emcall(void)
>   	wait_for_flag();
>   	smp_cpu_stop(1);
>   
> -	report_prefix_push("invalid CPU address");
> -
> -	cc = sigp(INVALID_CPU_ADDRESS, SIGP_EMERGENCY_SIGNAL, 0, NULL);
> -	report(cc == 3, "CC = 3");
> -
> -	report_prefix_pop();
> -
>   	report_prefix_pop();
>   }
>   
> @@ -368,13 +363,6 @@ static void test_cond_emcall(void)
>   		goto out;
>   	}
>   
> -	report_prefix_push("invalid CPU address");
> -
> -	cc = sigp(INVALID_CPU_ADDRESS, SIGP_COND_EMERGENCY_SIGNAL, 0, NULL);
> -	report(cc == 3, "CC = 3");
> -
> -	report_prefix_pop();
> -
>   	report_prefix_push("success");
>   	set_flag(0);
>   

