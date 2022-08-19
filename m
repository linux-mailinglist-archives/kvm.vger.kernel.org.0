Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C0E599848
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347130AbiHSIwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 04:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343696AbiHSIwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 04:52:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB46EA16D
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 01:52:48 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J8kSZJ031903
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 08:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9hLc+F45S3nZexOnehf2213qKsOKj28WpJwcnlorK+w=;
 b=hV6Y7Zk9Uh0xo7lkduuLZhHcYimVvJQS6ITCOcaDW3pehH5z8eGH6zbZbsi3ROBATebM
 4YLQpzBMCIGdql3SoTUPf4mpzhh6xPHI1EhK0suNFx64tBHqsGiBMJcxVqzw+1hUzLq5
 zCYgyeaBWWSPS++ZvpYkjXiBric9PYbadsZxx66eVoqUr4IrUFub6ZQ2xz7VP4fbujrf
 J9VPWTyAgibnXUqGxIsQSbDXU7IlOSOpDe/Sg7ARmoVbwprgsbgZkehWHXtxw9c/KoPE
 r3c3/HHKri1lEs6RpImVU9rsqQFLm9POzwz6lie68tUdGsL8XUrAy9+KTYz3HSuzTnQB fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27a884ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 08:52:47 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27J8ke9Z032304
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 08:52:47 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27a884ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:52:47 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J8pspK009930;
        Fri, 19 Aug 2022 08:52:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3hx3k8w6sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:52:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J8r15q32178516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 08:53:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3609AE045;
        Fri, 19 Aug 2022 08:52:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9909BAE04D;
        Fri, 19 Aug 2022 08:52:41 +0000 (GMT)
Received: from [9.145.49.220] (unknown [9.145.49.220])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:52:41 +0000 (GMT)
Message-ID: <d65e5beb-e417-b13d-f5f6-eb0e91ccc1f3@linux.ibm.com>
Date:   Fri, 19 Aug 2022 10:52:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        seiden@linux.ibm.com
References: <20220818152114.213135-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] lib/s390x: fix SMP setup bug
In-Reply-To: <20220818152114.213135-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gq-xbaSE8p7ePYyGqjDgQ9wSYuw7ZnK3
X-Proofpoint-ORIG-GUID: XnULm51bNAKvUnM6I923VJTp7PMJ6dlN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/22 17:21, Claudio Imbrenda wrote:
> The lowcore pointer pointing to the current CPU (THIS_CPU) was not
> initialized for the boot CPU. The pointer is needed for correct
> interrupt handling, which is needed in the setup process before the
> struct cpu array is allocated.
> 
> The bug went unnoticed because some environments (like qemu/KVM) clear
> all memory and don't write anything in the lowcore area before starting
> the payload. The pointer thus pointed to 0, an area of memory also not
> used. Other environments will write to memory before starting the
> payload, causing the unit tests to crash at the first interrupt.
> 
> Fix by assigning a temporary struct cpu before the rest of the setup
> process, and assigning the pointer to the correct allocated struct
> during smp initialization.
> 
> Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I've considered letting the IPL cpu have a static struct cpu and setting 
it up in cstart64.S. But that would mean that we would need extra 
handling when using smp functions and that'll look even worse.

Reported-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/io.c  | 9 +++++++++
>   lib/s390x/smp.c | 1 +
>   2 files changed, 10 insertions(+)
> 
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index a4f1b113..fb7b7dda 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -33,6 +33,15 @@ void puts(const char *s)
>   
>   void setup(void)
>   {
> +	struct cpu this_cpu_tmp = { 0 };

We can setup these struct members here and memcpy in smp_setup()
.addr = stap();
.stack = stackptr;
.lowcore = (void *)0;
.active = true;


> +
> +	/*
> +	 * Set a temporary empty struct cpu for the boot CPU, needed for
> +	 * correct interrupt handling in the setup process.
> +	 * smp_setup will allocate and set the permanent one.
> +	 */
> +	THIS_CPU = &this_cpu_tmp;
> +
>   	setup_args_progname(ipl_args);
>   	setup_facilities();
>   	sclp_read_info();
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 0d98c17d..03d6d2a4 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -353,6 +353,7 @@ void smp_setup(void)
>   			cpus[0].stack = stackptr;
>   			cpus[0].lowcore = (void *)0;
>   			cpus[0].active = true;
> +			THIS_CPU = &cpus[0];

/* Override temporary struct cpu address with permanent one */

>   		}
>   	}
>   	spin_unlock(&lock);

