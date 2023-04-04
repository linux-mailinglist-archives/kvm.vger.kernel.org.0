Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E316D5DD2
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjDDKph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbjDDKpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:45:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3681FC8;
        Tue,  4 Apr 2023 03:45:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334AJH79012405;
        Tue, 4 Apr 2023 10:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Akhko0nt0u0dEUUYPSe1+bUWxwqoYqNpuwSr8RegF/c=;
 b=L/OpdZHj7ugOmk9WcmuWy6mTouwmgpNBhFnkoHKFGOOc0Mn4yWY9ad5U8yHF9PYdXLbn
 Re1j3yEF1HOx1A5Zp1IE+rk8+MWlTyhUyW9LWSxkrKL6cRO3AGFSf5CUJ30wgwOReNSl
 wllBg51WXQsUyw2icSLLc+YMtr54c5LUVke24j7AVn/DVg7n5uoIsCtuGXOOOeBp4Jwq
 eNn1rfOi2DQD5cIsU/kdIK+WzTYB5qWKp2tJE6TX78COvLCz9DMpW1GFpod3OzTiAzLB
 xdkR6nDPp7ClWRPe5MSWqBFm5sk4GcmzuQ3g0s3xrPGNqpRWwbvhxAqr4l5ibk57HjmO UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prj1q8hv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:45:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334AJsFL013915;
        Tue, 4 Apr 2023 10:45:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prj1q8htt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:45:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3344jDbn030602;
        Tue, 4 Apr 2023 10:45:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ppc86su4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 10:45:26 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334AjLQ852691452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 10:45:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B78620040;
        Tue,  4 Apr 2023 10:45:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0FBB20043;
        Tue,  4 Apr 2023 10:45:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 10:45:20 +0000 (GMT)
Date:   Tue, 4 Apr 2023 12:45:19 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Nico Boehr <nrb@linux.ibm.com>,
        linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Use the right constraints in
 intercept.c
Message-ID: <20230404124519.7e542cb6@p-imbrenda>
In-Reply-To: <20230404102437.174404-1-thuth@redhat.com>
References: <20230404102437.174404-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ky_bO4p4Cma7cs9E_lk9bHYYckBPymLM
X-Proofpoint-ORIG-GUID: 4PYgeQXBv4dKE9-L4AGORrqYI_zFs0GO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040093
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  4 Apr 2023 12:24:37 +0200
Thomas Huth <thuth@redhat.com> wrote:

> stpx, spx, stap and stidp use addressing via "base register", i.e.
> if register 0 is used, the base address will be 0, independent from
> the value of the register. Thus we must not use the "r" constraint
> here to avoid register 0. This fixes test failures when compiling
> with Clang instead of GCC, since Clang apparently prefers to use
> register 0 in some cases where GCC never uses register 0.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

maybe you can also add a couple of Fixes tags:

Fixes: 2667b05e ("s390x: Interception tests")
Fixes: 484a3a57 ("s390x: add stidp interception test")

in any case:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/intercept.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 9e826b6c..faa74bbb 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -36,16 +36,16 @@ static void test_stpx(void)
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> -	asm volatile(" stpx 0(%0) " : : "r"(8));
> +	asm volatile(" stpx 0(%0) " : : "a"(8));
>  	low_prot_disable();
>  	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>  
>  	expect_pgm_int();
> -	asm volatile(" stpx 0(%0) " : : "r"(1));
> +	asm volatile(" stpx 0(%0) " : : "a"(1));
>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  
>  	expect_pgm_int();
> -	asm volatile(" stpx 0(%0) " : : "r"(-8L));
> +	asm volatile(" stpx 0(%0) " : : "a"(-8L));
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>  }
>  
> @@ -70,13 +70,13 @@ static void test_spx(void)
>  
>  	report_prefix_push("operand not word aligned");
>  	expect_pgm_int();
> -	asm volatile(" spx 0(%0) " : : "r"(1));
> +	asm volatile(" spx 0(%0) " : : "a"(1));
>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  	report_prefix_pop();
>  
>  	report_prefix_push("operand outside memory");
>  	expect_pgm_int();
> -	asm volatile(" spx 0(%0) " : : "r"(-8L));
> +	asm volatile(" spx 0(%0) " : : "a"(-8L));
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>  	report_prefix_pop();
>  
> @@ -113,16 +113,16 @@ static void test_stap(void)
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> -	asm volatile ("stap 0(%0)\n" : : "r"(8));
> +	asm volatile ("stap 0(%0)\n" : : "a"(8));
>  	low_prot_disable();
>  	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>  
>  	expect_pgm_int();
> -	asm volatile ("stap 0(%0)\n" : : "r"(1));
> +	asm volatile ("stap 0(%0)\n" : : "a"(1));
>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  
>  	expect_pgm_int();
> -	asm volatile ("stap 0(%0)\n" : : "r"(-8L));
> +	asm volatile ("stap 0(%0)\n" : : "a"(-8L));
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>  }
>  
> @@ -138,16 +138,16 @@ static void test_stidp(void)
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> -	asm volatile ("stidp 0(%0)\n" : : "r"(8));
> +	asm volatile ("stidp 0(%0)\n" : : "a"(8));
>  	low_prot_disable();
>  	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>  
>  	expect_pgm_int();
> -	asm volatile ("stidp 0(%0)\n" : : "r"(1));
> +	asm volatile ("stidp 0(%0)\n" : : "a"(1));
>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  
>  	expect_pgm_int();
> -	asm volatile ("stidp 0(%0)\n" : : "r"(-8L));
> +	asm volatile ("stidp 0(%0)\n" : : "a"(-8L));
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>  }
>  

