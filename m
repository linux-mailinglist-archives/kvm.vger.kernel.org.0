Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D145EA90C
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbiIZOw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiIZOvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:51:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8973CD10A;
        Mon, 26 Sep 2022 06:18:11 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QCxFIg004827;
        Mon, 26 Sep 2022 13:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3C1Rv6ElMGAfXtC1uY6XrX/SfqS1FuT25fzPSU8Z3ls=;
 b=tbWeUPzTXUR4uHMVHeFHUOU58JunB8FbxQLfb5/WEQ0fL8Bxe4ibH/mPYU34yE9sezvq
 5Jgd8eqZuycMHNpyQc8NCYUvyfs40zn1KJej7e9ZhFZAfeLpNRo8NTlzdws+N0omWk7u
 xy03qucOM8QrCZ02T5oALWw04o9/fJI+0l9PaKOudVwvXPYSyXG+uk8l7HjthDzYkgg1
 5LRi73MaJTRRLs8wkLl3zNrdS2yjVuQ689/e6KLCGcr+f2s94iUXrtIPlRgVau3t9MCX
 jiOm7CmQwLwwWsvqhOStwhQvTdUktPZqac+QFuJbjBu3J9P8Fwd1dgeWydfUPQhBU30N ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jucjr8jcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 13:18:10 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28QCxYNn005993;
        Mon, 26 Sep 2022 13:18:10 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jucjr8jc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 13:18:10 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28QD6ceQ009166;
        Mon, 26 Sep 2022 13:18:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3jssh91u80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 13:18:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28QDDrXx46727502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 13:13:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 131CEAE051;
        Mon, 26 Sep 2022 13:18:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE28BAE045;
        Mon, 26 Sep 2022 13:18:04 +0000 (GMT)
Received: from [9.171.72.93] (unknown [9.171.72.93])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Sep 2022 13:18:04 +0000 (GMT)
Message-ID: <c88bc732-1b4e-2ec3-360b-80998fd32dc7@linux.ibm.com>
Date:   Mon, 26 Sep 2022 15:18:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220826161112.3786131-1-scgl@linux.ibm.com>
 <20220826161112.3786131-3-scgl@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/2] s390x: Test specification
 exceptions during transaction
In-Reply-To: <20220826161112.3786131-3-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QWo_3spIAdttnUG0rg3jGBEvaKOqXAOL
X-Proofpoint-ORIG-GUID: sUKa6P1zX8eSZCZUII8Zb772KAehb_ob
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260083
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/22 18:11, Janis Schoetterl-Glausch wrote:
> Program interruptions during transactional execution cause other
> interruption codes.
> Check that we see the expected code for (some) specification exceptions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

First off a disclaimer stating that I don't know anything about our TB 
facility and I'm currently lacking the time to read the documentation.

But the code looks good to me and I don't see a reason that keeps me 
from picking this.

Acked-by: Janosch Frank <frankja@linux.ibm.com>

Minor nits below

> ---
>   lib/s390x/asm/arch_def.h |   1 +
>   s390x/spec_ex.c          | 199 ++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 195 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index b6e60fb0..c841871c 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -73,6 +73,7 @@ struct cpu {
>   #define PSW_MASK_BA			0x0000000080000000UL
>   #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>   
> +#define CTL0_TRANSACT_EX_CTL			(63 -  8)
>   #define CTL0_LOW_ADDR_PROT			(63 - 35)
>   #define CTL0_EDAT				(63 - 40)
>   #define CTL0_FETCH_PROTECTION_OVERRIDE		(63 - 38)
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 68469e4b..56f26564 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -4,13 +4,19 @@
>    *
>    * Specification exception test.
>    * Tests that specification exceptions occur when expected.
> + * This includes specification exceptions occurring during transactional execution
> + * as these result in another interruption code (the transactional-execution-aborted
> + * bit is set).
>    *
>    * Can be extended by adding triggers to spec_ex_triggers, see comments below.
>    */
>   #include <stdlib.h>
> +#include <htmintrin.h>
>   #include <libcflat.h>
>   #include <bitops.h>
> +#include <asm/barrier.h>
>   #include <asm/interrupt.h>
> +#include <asm/facility.h>
>   
>   /* toggled to signal occurrence of invalid psw fixup */
>   static bool invalid_psw_expected;
> @@ -148,20 +154,22 @@ static int not_even(void)
>   /*
>    * Harness for specification exception testing.
>    * func only triggers exception, reporting is taken care of automatically.
> + * If a trigger is transactable it will also  be executed during a transaction.

Double space

> +
> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
> +{
> +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
> +				      | PGM_INT_CODE_TX_ABORTED_EVENT;

I usually prefer having | and & at the end so it's easier to read.

> +	union {
> +		struct __htm_tdb tdb;
> +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
> +	} diag;
> +	unsigned int i;
> +	int trans_result;
> +


