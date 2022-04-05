Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FCB4F3AF4
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344149AbiDELuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380288AbiDELm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 07:42:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CFE10854E;
        Tue,  5 Apr 2022 04:06:02 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2358H5I0002424;
        Tue, 5 Apr 2022 11:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PnHuDp0qoRGofvyUmqOaD/yM/brSQiiILKgqM5AShoM=;
 b=NpbWlBjShTEJpx/lytk1q3y8wUALLG4S59dQJAflXiL5eYKmsKYxjs+tduIFtQV+OHXW
 rC2NO9Bm4DuvIfir/B1c1XaT0va8eR/cE8zve1DpTnjnPIwvxOa79PdDhFQPBzzG2NXG
 yNJqb0mJDw8RA8bZOvMYuHxGx/XFxtpktnvNptwFcmfpTpLsnHZTWixb/mQ83389V5d5
 QYTHprEshdQOtZYlwww3QxHChGhqS8tUrHxqVp0yRqXu+oju1SCvn8KOCj9vygNszTna
 mDX84YEp1bVOo3ocDToM6TWeDDC7IyYvr+HvI/+9mZTf6R9IlfThUbk8nhODcrqHI/c5 vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv70j9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:02 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235AtRvV014082;
        Tue, 5 Apr 2022 11:06:01 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv70j8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:01 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235B3FNL019425;
        Tue, 5 Apr 2022 11:06:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3f6e48vk99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:05:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235B5unq36241758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 11:05:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D798A4060;
        Tue,  5 Apr 2022 11:05:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F351CA4054;
        Tue,  5 Apr 2022 11:05:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 11:05:55 +0000 (GMT)
Date:   Tue, 5 Apr 2022 12:59:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: css: Skip if we're not run by
 qemu
Message-ID: <20220405125958.60cbec96@p-imbrenda>
In-Reply-To: <20220405075225.15903-2-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
        <20220405075225.15903-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4FnF6cjoiEEvvKAit-h7yU9XJbi9ObIC
X-Proofpoint-GUID: TqfmvOwZ6ZSWbp-f6igD-VZhZn2E2Gz6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Apr 2022 07:52:18 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> There's no guarantee that we even find a device at the address we're
> testing for if we're not running under QEMU.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/css.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index a333e55a..52d35f49 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -15,6 +15,7 @@
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
>  #include <alloc_page.h>
> +#include <hardware.h>
>  
>  #include <malloc_io.h>
>  #include <css.h>
> @@ -641,6 +642,12 @@ int main(int argc, char *argv[])
>  {
>  	int i;
>  
> +	/* There's no guarantee where our devices are without qemu */
> +	if (detect_host() != HOST_IS_KVM && detect_host() != HOST_IS_TCG) {

you could also do !host_is_kvm() && !host_is_tcg() , I think it's more
readable, but I do not have strong opinions regarding that

> +		report_skip("Not running under QEMU");
> +		goto done;
> +	}
> +
>  	report_prefix_push("Channel Subsystem");

the prefix push should probably go before the if

>  	enable_io_isc(0x80 >> IO_SCH_ISC);
>  	for (i = 0; tests[i].name; i++) {
> @@ -648,7 +655,8 @@ int main(int argc, char *argv[])
>  		tests[i].func();
>  		report_prefix_pop();
>  	}
> -	report_prefix_pop();
>  
> +done:
> +	report_prefix_pop();
>  	return report_summary();
>  }

