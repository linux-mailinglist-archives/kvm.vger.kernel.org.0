Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE153FAAF
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbiFGKBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiFGKBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:01:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176A8813EF;
        Tue,  7 Jun 2022 03:01:19 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2579rveZ009486;
        Tue, 7 Jun 2022 10:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DdXnFoDyvEZvRsgOCHS0FTqAN71Ch9Da1EZHst0fpM0=;
 b=hVizCYHfuov5uAi0zCo8XmIoMYtDZ95m9e4PcvYvmlzo2fTfQogRnMNDLiUpQwpcJp2Q
 12KXiembdW4Ro1+L95uceXRLiehMrpx+q819VKpc+MgmylIWMqjmQi2HDykgJzd7Ebd/
 HpS7Yv0mR4fjqUrVyU6qF8m1wJnGskGvA7UmTBlmuCrkf9psI8mXu8BBI2CX4DfIlS21
 6AGjrF9akqOQ0Ua+XEh2bM/uC2ypbT2s8zeWQYG4pZXocj8h+K1nvCr+UE4/YPmrD7Ib
 666i+SM8ynV+V5mbnCo3Kmt2cImHBdfW8VNqkjPVd12x+f06MPGjx3PSJx/Y8iqOxrmV JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj4evg3nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 10:01:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2579tbbo020641;
        Tue, 7 Jun 2022 10:01:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj4evg3ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 10:01:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2579q9d0003980;
        Tue, 7 Jun 2022 10:01:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3gfy19asuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 10:01:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257A1Cr718678070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 10:01:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E8C1A405B;
        Tue,  7 Jun 2022 10:01:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 149CCA405C;
        Tue,  7 Jun 2022 10:01:12 +0000 (GMT)
Received: from [9.171.6.132] (unknown [9.171.6.132])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jun 2022 10:01:11 +0000 (GMT)
Message-ID: <5552dc4a-4c1f-2f01-eaa7-fa42042d4455@linux.ibm.com>
Date:   Tue, 7 Jun 2022 12:01:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        pmorel@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
 <20220603154037.103733-3-imbrenda@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220603154037.103733-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5CQa5OpdGeNyiYxlHUiHNHJXUl6eBpE4
X-Proofpoint-GUID: l7VD2XkYZ83-rmERvhxMBKt6LxAgjq97
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_03,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206070039
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 17:40, Claudio Imbrenda wrote:
> Use per-CPU flags and callbacks for Program, Extern, and I/O interrupts
> instead of global variables.
> 
> This allows for more accurate error handling; a CPU waiting for an
> interrupt will not have it "stolen" by a different CPU that was not
> supposed to wait for one, and now two CPUs can wait for interrupts at
> the same time.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |  7 ++++++-
>  lib/s390x/interrupt.c    | 38 ++++++++++++++++----------------------
>  2 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 72553819..3a0d9c43 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -124,7 +124,12 @@ struct lowcore {
>  	uint8_t		pad_0x0280[0x0308 - 0x0280];	/* 0x0280 */
>  	uint64_t	sw_int_crs[16];			/* 0x0308 */
>  	struct psw	sw_int_psw;			/* 0x0388 */
> -	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
> +	uint32_t	pgm_int_expected;		/* 0x0398 */
> +	uint32_t	ext_int_expected;		/* 0x039c */
> +	void		(*pgm_cleanup_func)(void);	/* 0x03a0 */
> +	void		(*ext_cleanup_func)(void);	/* 0x03a8 */
> +	void		(*io_int_func)(void);		/* 0x03b0 */

If you switch the function pointers and the *_expected around,
you can use bools for the latter, right?
I think, since they're names suggest that they're bools, they should
be. Additionally I prefer true/false over 1/0, since the latter raises
the questions if other values are also used.

> +	uint8_t		pad_0x03b8[0x11b0 - 0x03b8];	/* 0x03b8 */
>  	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
>  	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
>  	uint64_t	fprs_sa[16];			/* 0x1200 */
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 27d3b767..e57946f0 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -15,14 +15,11 @@
>  #include <fault.h>
>  #include <asm/page.h>
>  
> -static bool pgm_int_expected;
> -static bool ext_int_expected;
> -static void (*pgm_cleanup_func)(void);
>  static struct lowcore *lc;
>  
>  void expect_pgm_int(void)
>  {
> -	pgm_int_expected = true;
> +	lc->pgm_int_expected = 1;
>  	lc->pgm_int_code = 0;
>  	lc->trans_exc_id = 0;
>  	mb();

[...]

>  void handle_pgm_int(struct stack_frame_int *stack)
>  {
> -	if (!pgm_int_expected) {
> +	if (!lc->pgm_int_expected) {
>  		/* Force sclp_busy to false, otherwise we will loop forever */
>  		sclp_handle_ext();
>  		print_pgm_info(stack);
>  	}
>  
> -	pgm_int_expected = false;
> +	lc->pgm_int_expected = 0;
>  
> -	if (pgm_cleanup_func)
> -		(*pgm_cleanup_func)();
> +	if (lc->pgm_cleanup_func)
> +		(*lc->pgm_cleanup_func)();

[...]

> +	if (lc->io_int_func)
> +		return lc->io_int_func();
Why is a difference between the function pointer usages here?

