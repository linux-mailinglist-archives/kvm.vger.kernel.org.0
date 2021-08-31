Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0B3FC968
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 16:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhHaOLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 10:11:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64465 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229514AbhHaOLY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 10:11:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17VE4OFv096980;
        Tue, 31 Aug 2021 10:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jzA+ZFVNxi4+GfcKW6hWIgIZRc8anhJmPU4P65ynJqI=;
 b=DvLkrC5dPIz7W7J+ay8b16e7qWOAwtGP24mBreTAAFczCyKeG0xtT6Nu04TkBY3qp8Xs
 eoI2mHRZzxWHJa6IZjeQCh13yvTUGaO2GxRyE3gTYJj7WcvK2+uvyUtzvUg96TW/DBL7
 u+Nw6rMqZ7Cst6fJrN+3Qz+L/k6+9Zbf6lkyuv93ydB2+QRKuGS7WOczE/GZGSIoVDLa
 MZqXaktC8yuD7qciAYZ+sf4udcZEaB19YsaRt4nXo6Zm+R6GKAr2gsFgKgMEuekrIxaK
 jQ3zR58/RG5128AHZyw01+it3NpWhA8xd1ZfL/I7lAc1LM7kqJTX6cK1mH3WKfuQhB8M 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asnt7rcpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 10:10:28 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17VE55nm101357;
        Tue, 31 Aug 2021 10:10:28 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asnt7rcnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 10:10:28 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VDvZe9032105;
        Tue, 31 Aug 2021 14:10:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3aqcdjbt7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 14:10:26 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17VEAK2330605606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 14:10:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93065AE063;
        Tue, 31 Aug 2021 14:10:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31059AE055;
        Tue, 31 Aug 2021 14:10:20 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.164.122])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Aug 2021 14:10:20 +0000 (GMT)
Subject: Re: [PATCH v4 03/14] KVM: s390: pv: avoid stalls for
 kvm_s390_pv_init_vm
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-4-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <efa07fc5-2f74-d785-e90f-571698ae8f54@de.ibm.com>
Date:   Tue, 31 Aug 2021 16:10:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6W3BmA6yqlGBT8SO7cZY3jYG2_-oJNw4
X-Proofpoint-ORIG-GUID: zfAQUFfz3oyvS3kW_ENYQeQz306D59Cb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_05:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.08.21 15:26, Claudio Imbrenda wrote:
> When the system is heavily overcommitted, kvm_s390_pv_init_vm might
> generate stall notifications.
> 
> Fix this by using uv_call_sched instead of just uv_call. This is ok because
> we are not holding spinlocks.

I guess this should only happen for really large guests where the donated memory is also large?
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/kvm/pv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 0a854115100b..00d272d134c2 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -195,7 +195,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
>   	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
>   
> -	cc = uv_call(0, (u64)&uvcb);
> +	cc = uv_call_sched(0, (u64)&uvcb);
>   	*rc = uvcb.header.rc;
>   	*rrc = uvcb.header.rrc;
>   	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
> 
