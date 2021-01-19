Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABFB2FBA4A
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404423AbhASOvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:51:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387682AbhASKND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:13:03 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JA1XXt151732;
        Tue, 19 Jan 2021 05:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IHF2oxG8Si6P7YX0CkWlhBKD7mnMBgPLLDeRApyFRIM=;
 b=PI4QZA9OT87UkSzavR2Wm1ZVYlbexLy2WrAg7JD0VWPBs1zILjhHVYX0dKVV/wdZvFC2
 8uiFtcLLh43b5TuNuMVr89Wsnx8YiuZJrVvvHHVegPh6BcALm7pzMdMJpyf/CgQuFu1x
 9mCkbPjks+BjQq3vHDWZ4XSLUy69l/VD0aPmWnpExba0r8cyfh/a9Zw74r0RuEKrqrXc
 btSvB6oi2Q964lz1nS35Yt7ASjf9xFNAmFxV8+HdqHC8y1dsEi/THb1cc/4AfqhPaher
 ywbhJo0S4Gz0Ip3eyRZvaKhdY6Bvxf/UcASKGJSC9pKFlynTTKL6Lsoql7cXc8p68x8x KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365vx10x2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:12:05 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JA1hdB152471;
        Tue, 19 Jan 2021 05:12:04 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365vx10x0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:12:03 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JA45Ow010746;
        Tue, 19 Jan 2021 10:11:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 365s0e83rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:11:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JABuPZ22807030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:11:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DDA84C044;
        Tue, 19 Jan 2021 10:11:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A91C74C04A;
        Tue, 19 Jan 2021 10:11:55 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.35.184])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:11:55 +0000 (GMT)
Subject: Re: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
To:     Janosch Frank <frankja@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-2-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d72e2823-f30f-02be-1ee5-445496ca9dbc@de.ibm.com>
Date:   Tue, 19 Jan 2021 11:11:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210119100402.84734-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.01.21 11:04, Janosch Frank wrote:
> The number reported by the query is N-1 and I think people reading the
> sysfs file would expect N instead. For users creating VMs there's no
> actual difference because KVM's limit is currently below the UV's
> limit.
> 
> The naming of the field is a bit misleading. Number in this context is
> used like ID and starts at 0. The query field denotes the maximum
> number that can be put into the VCPU number field in the "create
> secure CPU" UV call.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
> Cc: stable@vger.kernel.org
> ---
>  arch/s390/boot/uv.c        | 2 +-
>  arch/s390/include/asm/uv.h | 4 ++--
>  arch/s390/kernel/uv.c      | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index a15c033f53ca..afb721082989 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -35,7 +35,7 @@ void uv_query_info(void)
>  		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
>  		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
>  		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
> -		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
> +		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_num;
>  	}
>  
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 0325fc0469b7..c484c95ea142 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -96,7 +96,7 @@ struct uv_cb_qui {
>  	u32 max_num_sec_conf;
>  	u64 max_guest_stor_addr;
>  	u8  reserved88[158 - 136];
> -	u16 max_guest_cpus;
> +	u16 max_guest_cpu_num;

I think it would read better if we name this also max_guest_cpu_id.
Otherwise this looks good.
