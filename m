Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA434F3B1E
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbiDELuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380267AbiDELmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 07:42:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471E878FEA;
        Tue,  5 Apr 2022 04:05:58 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235AJgWn005878;
        Tue, 5 Apr 2022 11:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZDUhnOzG9Za+86RgkHrKfJ3OjXyFXL5JcxtENPqJ/Rw=;
 b=T/KXNJ43j7VKSnjdwWmeIa0i989g25mkqFEZXXl5ANnHP3255xYDRM/KIFx7lcDcvz5B
 NsUKHM9CViKml4F0s5KGzRTnHV92g5g0/dX+T9gB0z3LEgpv5nzetLdLHx9qkgz7Zv0E
 81xr0HPzgBeKUE65FMpbmULXaTQ+iBSe0aQ9V9Zf+MThsqeZCwgBsBnXVtMsOX7RvSGm
 YSYHzwBqu1YfnJTn2+PE6xouNAREAqms/hGz/dVk2dYU21oKdFRbkJdLDliBxCs2HF8m
 uhkaUODbHBD4rgiSoipt9DT7Dtf5q2x4voGfkAGo9g8317hA4yBxgeY02Zseu4KM0OWv kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8a70byvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:58 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235AfY68014075;
        Tue, 5 Apr 2022 11:05:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8a70byv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235B39JF026327;
        Tue, 5 Apr 2022 11:05:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e48wjuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235B5xXg39059774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 11:05:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 502E2A4062;
        Tue,  5 Apr 2022 11:05:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F008EA4067;
        Tue,  5 Apr 2022 11:05:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 11:05:51 +0000 (GMT)
Date:   Tue, 5 Apr 2022 13:04:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 5/8] s390x: pv-diags: Cleanup includes
Message-ID: <20220405130437.2c72504b@p-imbrenda>
In-Reply-To: <20220405075225.15903-6-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
        <20220405075225.15903-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rlHofh6FvLGAGVh3jezckTGB6rhlgh6s
X-Proofpoint-ORIG-GUID: CuUPjLeUUbmsB4rLZU0zUxaXshkGC0VK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Apr 2022 07:52:22 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> This file has way too much includes. Time to remove some.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/pv-diags.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 6899b859..9ced68c7 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -8,23 +8,10 @@
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
> -#include <asm/asm-offsets.h>
> -#include <asm-generic/barrier.h>
> -#include <asm/interrupt.h>
> -#include <asm/pgtable.h>
> -#include <mmu.h>
> -#include <asm/page.h>
> -#include <asm/facility.h>
> -#include <asm/mem.h>
> -#include <asm/sigp.h>
> -#include <smp.h>
> -#include <alloc_page.h>
> -#include <vmalloc.h>
> -#include <sclp.h>
>  #include <snippet.h>
>  #include <sie.h>
> -#include <uv.h>
> -#include <asm/uv.h>
> +#include <sclp.h>
> +#include <asm/facility.h>
>  
>  static struct vm vm;
>  

