Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF759DE51
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358587AbiHWL4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359106AbiHWL4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:56:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD03C61B18
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 02:33:43 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N9PkDO006145
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=b6dqE6UCH9iwpg7GH/G2+Owpl3OruNl8AoChxtxWGgs=;
 b=BNu7DeYHeYYyPGGfPK35iUkO5rtT96Nhf48Q2tW3sKrVLR6LvxTsMkcg4FPMMh0QrtxN
 QGdcZJgacZkjxnrveGBLU0YGR2dW6nLbt4gIV3kw/CFWw/B3olAlLMrzWUjab7mvCh0r
 M7TEnfRxGsVSXRnT0Y7hviyXdkXz44P9uLDa3IucSHkq35yylU51XYIRBaTwGJLZwR2n
 47gjfuGBQqihsjJtGpLQBdylh9/mEpaHtmKcjKYoc1ByOMc7gWPpCVl2sWUAZ5IBMwYy
 I1k0AHokGT9vVZ4jX24ikuBrOJ9psgEAH1J9kAk9+pfWwO1MlNtVuMlv2ljxVx3InJ2t 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4v8nr5ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:33:02 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27N9RY2g010596
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:33:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4v8nr5db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:33:01 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27N9LHY1022447;
        Tue, 23 Aug 2022 09:32:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3j2q88tk52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 09:32:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27N9Wuac31785420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:32:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D133A405B;
        Tue, 23 Aug 2022 09:32:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08CFBA4054;
        Tue, 23 Aug 2022 09:32:56 +0000 (GMT)
Received: from [9.145.84.26] (unknown [9.145.84.26])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 09:32:55 +0000 (GMT)
Message-ID: <46d331ac-5a87-2ea5-4def-ce3076595420@linux.ibm.com>
Date:   Tue, 23 Aug 2022 11:32:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v5 2/4] lib/s390x: add CPU timer related
 defines and functions
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220823084525.52365-1-nrb@linux.ibm.com>
 <20220823084525.52365-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220823084525.52365-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gtsRVD6wwAWDupr7IzBfxp3ZyU7TEPAb
X-Proofpoint-GUID: J6juC6_x7O8nwv5mqZ4UkjdJBNvjjNvX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208230036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/22 10:45, Nico Boehr wrote:
> Upcoming changes will make use of the CPU timer, so add some defines and
> functions to work with the CPU timer.
> 
> Since shifts for both CPU timer and TOD clock are the same, introduce a
> new define S390_CLOCK_SHIFT_US. The respective shifts for CPU timer and

introduce the new constant "S390_CLOCK_SHIFT_US" for that value

> TOD clock reference it, so the semantic difference between the two
> defines is kept.
> 
> Also add a define for the CPU timer subclass mask.

Constant

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/asm/arch_def.h |  1 +
>   lib/s390x/asm/time.h     | 17 ++++++++++++++++-
>   2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index e7ae454b3a33..b92291e8ae3f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -78,6 +78,7 @@ struct cpu {
>   #define CTL0_EMERGENCY_SIGNAL			(63 - 49)
>   #define CTL0_EXTERNAL_CALL			(63 - 50)
>   #define CTL0_CLOCK_COMPARATOR			(63 - 52)
> +#define CTL0_CPU_TIMER				(63 - 53)
>   #define CTL0_SERVICE_SIGNAL			(63 - 54)
>   #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
>   
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..d8d91d68a667 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -11,9 +11,13 @@
>   #ifndef _ASMS390X_TIME_H_
>   #define _ASMS390X_TIME_H_
>   
> -#define STCK_SHIFT_US	(63 - 51)
> +#define S390_CLOCK_SHIFT_US	(63 - 51)
> +
> +#define STCK_SHIFT_US	S390_CLOCK_SHIFT_US
>   #define STCK_MAX	((1UL << 52) - 1)
>   
> +#define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
> +
>   static inline uint64_t get_clock_us(void)
>   {
>   	uint64_t clk;
> @@ -45,4 +49,15 @@ static inline void mdelay(unsigned long ms)
>   	udelay(ms * 1000);
>   }
>   
> +static inline void cpu_timer_set_ms(int64_t timeout_ms)
> +{
> +	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
> +
> +	asm volatile (
> +		"spt %[timer_value]\n"
> +		:
> +		: [timer_value] "Q" (timer_value)
> +	);
> +}
> +
>   #endif

