Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F00574524
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 08:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiGNGhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 02:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiGNGhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 02:37:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD4E1F2CB;
        Wed, 13 Jul 2022 23:37:45 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E5iRH6022033;
        Thu, 14 Jul 2022 06:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OVIFUQBVmbaFCeXKmyPphqtEAztZSPlm/YqCBMSZDK0=;
 b=kgJlvEuPkbEtfV/4csg5NUqyxzoty0y5UZzP1TCNorWwhoZ+MFWPLZbqFTaH3UqXAL98
 CkVi8T1jMy0iCQt1mEZDTPw5yh4djPGPMV6CMvi4kK3f3JwpEIKiIgXiwYUVMr0KW9p6
 hL+KdWU68OLKo2OH4VrIl0QZNtjIgZLTIbeb0+gCGm0e2eic9GQ+je+buV3uACxC0j/M
 aZzWe3exvYga334nofjeomwMfOa/6qpa6j6YfVSxMrwgaprXWwgMYnFsXB/21RLh61St
 430/kycqIl/RbiXi48LlEilm1R0Xj7IKGYUbKpmzVthJ/gB1bEcRBoFUT5SeAaRvjGO2 KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3had8js5mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 06:37:44 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26E6VO2D027282;
        Thu, 14 Jul 2022 06:37:44 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3had8js5kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 06:37:44 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26E6KYW7026461;
        Thu, 14 Jul 2022 06:37:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3ha19s0jcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 06:37:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26E6bdhv16122206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 06:37:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 774B2A405F;
        Thu, 14 Jul 2022 06:37:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30CB1A405B;
        Thu, 14 Jul 2022 06:37:39 +0000 (GMT)
Received: from [9.145.62.186] (unknown [9.145.62.186])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 06:37:39 +0000 (GMT)
Message-ID: <9c4d9623-8abf-244f-3c27-8bb88dc5ae03@linux.ibm.com>
Date:   Thu, 14 Jul 2022 08:37:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v4 3/3] lib: s390x: better smp interrupt
 checks
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
References: <20220713174000.195695-1-imbrenda@linux.ibm.com>
 <20220713174000.195695-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220713174000.195695-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KeLzoNAKiGtsyMr7Bi4CyPhmOaDw_R_W
X-Proofpoint-ORIG-GUID: uNgMcKc54I4KA8Qi70DEg65kYZwezbbd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_04,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140025
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 19:40, Claudio Imbrenda wrote:
> Use per-CPU flags and callbacks for Program and Extern interrupts,
> instead of global variables.
> 
> This allows for more accurate error handling; a CPU waiting for an
> interrupt will not have it "stolen" by a different CPU that was not
> supposed to wait for one, and now two CPUs can wait for interrupts at
> the same time.
> 
> This will significantly improve error reporting and debugging when
> things go wrong.
> 
> Both program interrupts and external interrupts are now CPU-bound, even
> though some external interrupts are floating (notably, the SCLP
> interrupt). In those cases, the testcases should mask interrupts and/or
> expect them appropriately according to need.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Small nit below

> ---
>   lib/s390x/asm/arch_def.h  | 17 ++++++++-
>   lib/s390x/asm/interrupt.h |  3 +-
>   lib/s390x/smp.h           |  8 +---
>   lib/s390x/interrupt.c     | 77 +++++++++++++++++++++++++++++++--------
>   lib/s390x/smp.c           | 11 ++++++
>   s390x/skrf.c              |  2 +-
>   6 files changed, 92 insertions(+), 26 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 358ef82e..6e664f62 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,18 @@ struct psw {
>   	uint64_t	addr;
>   };
>   
> +struct cpu {
> +	struct lowcore *lowcore;
> +	uint64_t *stack;
> +	void (*pgm_cleanup_func)(struct stack_frame_int *);
> +	void (*ext_cleanup_func)(struct stack_frame_int *);
> +	uint16_t addr;
> +	uint16_t idx;
> +	bool active;
> +	bool pgm_int_expected;
> +	bool ext_int_expected;
> +};
> +
>   #define AS_PRIM				0
>   #define AS_ACCR				1
>   #define AS_SECN				2
> @@ -125,7 +137,8 @@ struct lowcore {
>   	uint8_t		pad_0x0280[0x0308 - 0x0280];	/* 0x0280 */
>   	uint64_t	sw_int_crs[16];			/* 0x0308 */
>   	struct psw	sw_int_psw;			/* 0x0388 */
> -	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
> +	struct cpu *	this_cpu;			/* 0x0398 */

Move the * to the variable name

> +	uint8_t		pad_0x03a0[0x11b0 - 0x03a0];	/* 0x03a0 */
>   	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
>   	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
>   	uint64_t	fprs_sa[16];			/* 0x1200 */
> @@ -148,6 +161,8 @@ _Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
