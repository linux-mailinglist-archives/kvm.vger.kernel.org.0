Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4679392ABC
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 11:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbhE0JbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 05:31:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235608AbhE0JbN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 05:31:13 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R92e8Y041964;
        Thu, 27 May 2021 05:29:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M5xuCEVvPBaEIEc6OCW7xYa9va/DlzwC9UTwv3y0UMU=;
 b=rM5FYWCYpK1qpevLuhwmSMaVGCzY76s5TVjOL4toqYC05o/JW8HZURCArYIMbg9angKN
 mRrujQarSL0A7m85Ettnn//0NbxBbzbiQDUvRVLfIxXwNrrxpEYZiat2KOUq00bG7wPK
 0zJ10xAeUKJJeO76/biAzBjz6Jbei2otBHgrItRUFZ9HLdwQ/NZJwpq66hI5EnCNxWh1
 OW9ofCwZA/qxnaWEzdIJuKHOMyX5VHNKRmJTTqmWJ6VpL6zIB08083RktokYLTkSCEDq
 8bS0V1dNupM2eJa6fyHEGcCSdQmo79FAoCtczurW6iwjL3YCQd6oQPx8VpQRPFaiPdFb 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38t74ubqcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 05:29:40 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14R93MwX044142;
        Thu, 27 May 2021 05:29:40 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38t74ubqbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 05:29:39 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14R9HQ4n016704;
        Thu, 27 May 2021 09:29:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2rurg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 09:29:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14R9TYYB15008252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 09:29:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F4B411C04C;
        Thu, 27 May 2021 09:29:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D272711C04A;
        Thu, 27 May 2021 09:29:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.86.253])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 09:29:33 +0000 (GMT)
Subject: Re: [PATCH v1 06/11] KVM: s390: pv: usage counter instead of flag
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210517200758.22593-7-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <e3e47640-2ee6-3529-24da-fcf0694be858@linux.ibm.com>
Date:   Thu, 27 May 2021 11:29:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517200758.22593-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gE_QXIrLfGa540eSuIYWDqpwCdlPyMv-
X-Proofpoint-GUID: DtkjGaIfeKvHw9FnHG49xFLToFKgyg7p
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/21 10:07 PM, Claudio Imbrenda wrote:
> Use the is_protected field as a counter instead of a flag. This will
> be used in upcoming patches.
> 
> Increment the counter when a secure configuration is created, and
> decrement it when it is destroyed. Previously the flag was set when the
> set secure parameters UVC was performed.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/kvm/pv.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c3f9f30d2ed4..59039b8a7be7 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -218,7 +218,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>  			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
>  	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> -	atomic_set(&kvm->mm->context.is_protected, 0);
> +	if (!cc)
> +		atomic_dec(&kvm->mm->context.is_protected);
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
>  	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
>  	/* Intended memory leak on "impossible" error */
> @@ -259,11 +260,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	/* Outputs */
>  	kvm->arch.pv.handle = uvcb.guest_handle;
>  
> +	atomic_inc(&kvm->mm->context.is_protected);
>  	if (cc) {
> -		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
> +		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
>  			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
> -		else
> +		} else {
> +			atomic_dec(&kvm->mm->context.is_protected);
>  			kvm_s390_pv_dealloc_vm(kvm);
> +		}
>  		return -EIO;
>  	}
>  	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
> @@ -286,8 +290,6 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>  	*rrc = uvcb.header.rrc;
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
>  		     *rc, *rrc);
> -	if (!cc)
> -		atomic_set(&kvm->mm->context.is_protected, 1);
>  	return cc ? -EINVAL : 0;
>  }
>  
> 

