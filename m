Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE063FC8EB
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 15:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhHaN4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 09:56:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239787AbhHaN4M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 09:56:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17VDnZmJ123807;
        Tue, 31 Aug 2021 09:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GNld3ZAakhTzCAjLeVyROgSf6RN4dScPLaqttdrbqtc=;
 b=tBHHndK+doas9DbdixV+v06plbyjkKxJC/fz6ytP8jlFtMAS47ivp7EL5ab4u+EIw8ZW
 HlPzIf92JNloFsEzchUgTyNEUu0TF8QsvtyZRbVuFcKO3rplipubh4KDuwysi+v90aft
 RrfX9nEo7npS0ATIiw1prox/VXBBwhdFrj/PIOXVjBA+o3K6b0OrfnUZifspNay5O0oe
 sHTWKXWNT3exdqgQM00hIH7vtT8u9CtdSErb1Szq4lTwfq9hsiyMs8oJTzCq5aXBNr4p
 bbtBeJ4VpfXI9HYhlqGoBzvJK6LmJROYyQFtd3FWugqiN/gxAZ7syOYm6Yg4C6E2lQSi /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asndwrpyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 09:55:16 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17VDowSx131715;
        Tue, 31 Aug 2021 09:55:16 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asndwrpxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 09:55:16 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VDVdEQ019546;
        Tue, 31 Aug 2021 13:55:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3aqcs92kss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 13:55:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17VDp9Kc14811598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 13:51:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA71DAE055;
        Tue, 31 Aug 2021 13:55:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52B90AE068;
        Tue, 31 Aug 2021 13:55:08 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.164.122])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Aug 2021 13:55:08 +0000 (GMT)
Subject: Re: [PATCH v4 02/14] KVM: s390: pv: avoid double free of sida page
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-3-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ad1a386e-3ae9-13d7-430b-c24ed0cc4c85@de.ibm.com>
Date:   Tue, 31 Aug 2021 15:55:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8DqG5T1CPtRRsY3bQcdBaUv5P-6bqo4p
X-Proofpoint-GUID: na_nhoeSdqaXKSyqHp9qb6ZoatWJ67Zv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_05:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=768 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.08.21 15:26, Claudio Imbrenda wrote:
> If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
> free_page on a random page, since the sidad field is aliased with the
> gbea, which is not guaranteed to be zero.
> 
> The solution is to simply return successfully immediately if the vCPU
> was already non secure.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")

Patch looks good. Do we have any potential case where we call this twice? In other words,
do we need the Fixes tag with the code as of today or not?
> ---
>   arch/s390/kvm/pv.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c8841f476e91..0a854115100b 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -16,18 +16,17 @@
>   
>   int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>   {
> -	int cc = 0;
> +	int cc;
>   
> -	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
> -		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
> -				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +	if (!kvm_s390_pv_cpu_get_handle(vcpu))
> +		return 0;
> +
> +	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +
> +	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> +		     vcpu->vcpu_id, *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
>   
> -		KVM_UV_EVENT(vcpu->kvm, 3,
> -			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> -			     vcpu->vcpu_id, *rc, *rrc);
> -		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
> -			  *rc, *rrc);
> -	}
>   	/* Intended memory leak for something that should never happen. */
>   	if (!cc)
>   		free_pages(vcpu->arch.pv.stor_base,
> 
