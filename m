Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F363B14B0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 09:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFWHg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 03:36:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229999AbhFWHg0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 03:36:26 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N7Y4wQ119687
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 03:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CzV1JrA3FQBzrMNhrDLFkViOFhPBSEtJ7E91RAS/TPU=;
 b=GNR5U26VFS6rG1dAggExiZT1WKgksdbVfCiaQPmcvPpeAHJvAlPL1WLgxuxO5jz4cbqq
 TPOdefzSA+EXJE8ZukMf5Z/g8yTXVielN/6qFLAHQZI6+Qb4Jn6CB35KD5d8NVtmP8/B
 bKhKPaOamdG+cjbGPh3JzB41E3Dcz3v61U1t+HM6kkvEx3JjpGgyHzpbIhgIVAwLYufJ
 NBSKEsvl7eqIwFql3IfD080Ityshm/uvSS5EHttkKrFsEvrI0GuTPeyfoz1h04KNetRA
 Y5k+HjWLvAiPELr5KulGz7fd4gXPcj9iDu9+apBHreP/uGbfoJWcmE28YnR83BnOWDtN GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39c0kqr36m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 03:34:08 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15N7Y8kf120147
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 03:34:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39c0kqr32s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 03:34:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15N7RKaP012679;
        Wed, 23 Jun 2021 07:34:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3998789u0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 07:34:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15N7XxFN28574106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 07:33:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5938A4053;
        Wed, 23 Jun 2021 07:33:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8329FA4051;
        Wed, 23 Jun 2021 07:33:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.77.251])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Jun 2021 07:33:58 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/4] lib/s390x: Fix the epsw inline
 assembly
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
 <20210622135517.234801-4-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <559e9999-3f52-5843-de28-481d90b41da5@linux.ibm.com>
Date:   Wed, 23 Jun 2021 09:33:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622135517.234801-4-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7jRKcPTzv5zOSV6iGJOBD9gUpl3bFP3Y
X-Proofpoint-GUID: gOwXjG09pc1kGjQrRRUfNWiiMOCleJ_X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/21 3:55 PM, Thomas Huth wrote:
> According to the Principles of Operation, the epsw instruction
> does not touch the second register if it is r0. With GCC we were
> lucky so far that it never tried to use r0 here, but when compiling
> the kvm-unit-tests with Clang, this indeed happens and leads to
> very weird crashes. Thus let's make sure to never use r0 for the
> second operand of the epsw instruction.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/asm/arch_def.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 3aa5da9..15cf7d4 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -265,7 +265,7 @@ static inline uint64_t extract_psw_mask(void)
>  
>  	asm volatile(
>  		"	epsw	%0,%1\n"
> -		: "+r" (mask_upper), "+r" (mask_lower) : : );
> +		: "=r" (mask_upper), "=a" (mask_lower));
>  
>  	return (uint64_t) mask_upper << 32 | mask_lower;
>  }
> 

With Claudio's nits fixed:
Acked-by: Janosch Frank <frankja@linux.ibm.com>
