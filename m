Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD8B5F6517
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 13:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJFLRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 07:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiJFLQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 07:16:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEE3631D1
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 04:16:57 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296BAC9c021300
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 11:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VqSn8OnyeTH5tkub4eCCKPNPYwHHckXfcrZdfL7YSL8=;
 b=QbX7KASXGKeEsvPPtbBPO74L72tgpwMNib5QsC3++pVtKdP7dmkMbYG6xx6R4a9fpt5V
 7A/xn0neCa6M/mEQM9sJ0zdVGdKPQkwMbK0LlIivSQOVOlmHfalm3E8nx3/VVE5QeBrr
 5izTGOa9pvuj1kwmRXHsdbWEwuOdwwO0sHDr0BsuDOwMWvWGjWU7uzHCfdeSpW8dw6+X
 d1Uih6rh+nj1LjJfJkgUNvxvy3i+w0W8cjSmpuiIOO8PtDuN+pYBDTZtw0nxig7yPKfi
 41gsl8BN8VJutCsYQRqgGwzurPX+e48FqblhKCQiFfvu7va/x3FTY/67GOtnNrHPSAtk Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1vg32h7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 11:16:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 296BBauZ029902
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 11:16:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1vg32h6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 11:16:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296B77Wg025429;
        Thu, 6 Oct 2022 11:16:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3jxd68w3xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 11:16:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296BGok664946600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 11:16:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C03E952051;
        Thu,  6 Oct 2022 11:16:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9443F5204E;
        Thu,  6 Oct 2022 11:16:50 +0000 (GMT)
Date:   Thu, 6 Oct 2022 13:16:48 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/2] lib/s390x: time: add wrapper for
 stckf
Message-ID: <20221006131648.3fdd3522@p-imbrenda>
In-Reply-To: <20220901150956.1075828-2-nrb@linux.ibm.com>
References: <20220901150956.1075828-1-nrb@linux.ibm.com>
        <20220901150956.1075828-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xfQZxec6lfg_oEnas8bAGPeYCixoQqq9
X-Proofpoint-ORIG-GUID: 7I-tkuDRkYRhFLqCM8iCB809t0irxEVT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210060066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Sep 2022 17:09:55 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will do performance measurements of instructions. Since
> stck is designed to return unique values even on concurrent calls, it is
> unsuited for performance measurements. stckf should be used in this
> case.
> 
> While touching that code, also add a missing cc clobber in
> get_clock_us() and avoid the memory clobber by moving the clock value to
> the output operands.
> 
> Hence, add a nice wrapper for stckf to the time library.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/time.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..8d2327a40541 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -14,11 +14,20 @@
>  #define STCK_SHIFT_US	(63 - 51)
>  #define STCK_MAX	((1UL << 52) - 1)
>  
> +static inline uint64_t get_clock_fast(void)
> +{
> +	uint64_t clk;
> +
> +	asm volatile(" stckf %0 " : "=Q"(clk) : : "cc");
> +
> +	return clk;
> +}
> +
>  static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
>  
> -	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
> +	asm volatile(" stck %0 " : "=Q"(clk) : : "cc");

this fix is not needed if you use the wrapper for stck from your
other patch series

>  
>  	return clk >> STCK_SHIFT_US;
>  }

