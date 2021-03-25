Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97B9349655
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhCYQDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:03:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229972AbhCYQDQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:03:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PFY2It113640
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YG9YPdoZ+FePdMDEnkrNud0FQKluXlu0vNVRjKKuthM=;
 b=XdNUr4M88wMEH9H3pxK1bgIX98+1o6ux0yjtvCYnjFvg2jDBSDfDG7hsRUcjO/MJhkvy
 lBglW9rgc0Zywk5L1sVpMdI+xyL9s7IwHD3RK5W6ZvD2unA58Z/Dhq5nmMplY9gJ2vhQ
 LYfEGWnS0pQa8UmVoKYE1uacIFp8bva/w7SKmdDhku2R1MCcnEe4BTss5vb2KFdkzd8J
 xcKTVW0nA1NcQtlVkEq921giN2O6nEWCh6SPdCobBGL0k1mrdvkmhM2BiVjoQABVnrc3
 XQ+AlJV6OjfNmtFYAZ7gJdXoWjpGvgtm1sRvzCr1m5WVz+teAwa27dIB6WfJmeZu5Q+b WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gvnuad86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:15 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PFYfDH119814
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:14 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37gvnuad7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:03:14 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PFxChk022577;
        Thu, 25 Mar 2021 16:03:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 37d9bptwhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:03:12 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PG2pVr37552602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:02:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C0AA42042;
        Thu, 25 Mar 2021 16:03:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09F984203F;
        Thu, 25 Mar 2021 16:03:09 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:03:08 +0000 (GMT)
Date:   Thu, 25 Mar 2021 16:24:08 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait
 for IRQ and check I/O completion
Message-ID: <20210325162408.798bbaba@ibm-vm>
In-Reply-To: <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 clxscore=1015 adultscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103250112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:03 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We will may want to check the result of an I/O without waiting
> for an interrupt.
> For example because we do not handle interrupt.
> Let's separate waiting for interrupt and the I/O complretion check.
                                                   ^^^^^^^^^^^
                                                   completion

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 13 ++++++++++---
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 0058355..5d1e1f0 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -317,6 +317,7 @@ int css_residual_count(unsigned int schid);
>  
>  void enable_io_isc(uint8_t isc);
>  int wait_and_check_io_completion(int schid);
> +int check_io_completion(int schid);
>  
>  /*
>   * CHSC definitions
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f5c4f37..1e5c409 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -487,18 +487,25 @@ struct ccw1 *ccw_alloc(int code, void *data,
> int count, unsigned char flags) }
>  
>  /* wait_and_check_io_completion:
> + * @schid: the subchannel ID
> + */
> +int wait_and_check_io_completion(int schid)
> +{
> +	wait_for_interrupt(PSW_MASK_IO);
> +	return check_io_completion(schid);
> +}
> +
> +/* check_io_completion:
>   * @schid: the subchannel ID
>   *
>   * Makes the most common check to validate a successful I/O
>   * completion.
>   * Only report failures.
>   */
> -int wait_and_check_io_completion(int schid)
> +int check_io_completion(int schid)
>  {
>  	int ret = 0;
>  
> -	wait_for_interrupt(PSW_MASK_IO);
> -
>  	report_prefix_push("check I/O completion");
>  
>  	if (lowcore_ptr->io_int_param != schid) {

