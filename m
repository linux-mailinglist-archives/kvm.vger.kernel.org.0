Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703053F8371
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhHZH7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 03:59:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233064AbhHZH7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 03:59:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17Q7aKXh057548;
        Thu, 26 Aug 2021 03:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hNH2hqMNaA7XNPQ6uB+BLVCJH6+gdWNWY5ohFJP3D7w=;
 b=MqsQIizyaV3BRt4ptSb20/bgHG1NEj4GZ6lQNzVUhg/BvRATPHlytLh8a926om4ZQ6wU
 KG1QwqD/K4k1X6S0QIFHHJb0pzY1cO/2LJQYdk2mJj9ZLqFuVt/ymXxzTxUVWKXw3VCe
 2kZdHSyVYgJzMVw0kpMj8JYqKRjdp8Y4XbfzvYXaoONvsV474+J2jp7C89Ytt0+X96gD
 K91ePhO/c5z03L7GdrPy3a4PxMSFD+xCbKxY3mP5F22hpMzYUaRFoMpto4FWOZHjTrbz
 e2EEPX5oIwX3OVKfux9mFo90muRLv+46seaEzWa0a+XjdseaL3iodicKLoYx3dgjDf1B Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ap1skqfdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 03:58:28 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17Q7aeR3058907;
        Thu, 26 Aug 2021 03:58:28 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ap1skqfcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 03:58:27 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17Q7umw5013463;
        Thu, 26 Aug 2021 07:58:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ajs48fctg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 07:58:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17Q7wJvC24838586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 07:58:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AEA5A4DDC;
        Thu, 26 Aug 2021 07:58:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE111A4DD8;
        Thu, 26 Aug 2021 07:58:17 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.32.161])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Aug 2021 07:58:17 +0000 (GMT)
Subject: Re: [PATCH v4 10/14] KVM: s390: pv: usage counter instead of flag
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-11-imbrenda@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <8cca2dd4-ede1-87f9-c287-6189e89d1b39@linux.vnet.ibm.com>
Date:   Thu, 26 Aug 2021 09:58:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-11-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yf5D8FZo6iQlrX0yyisRAsfwmkAR05g5
X-Proofpoint-GUID: wMRn6d_IWJ22r6gdM7CjGB3v518MYwuk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-26_01:2021-08-25,2021-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108260044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.08.21 um 15:26 schrieb Claudio Imbrenda:
> Use the is_protected field as a counter instead of a flag. This will
> be used in upcoming patches.

Maybe it should also be renamed to reflect that?
> 
> Increment the counter when a secure configuration is created, and
> decrement it when it is destroyed. Previously the flag was set when the
> set secure parameters UVC was performed.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/pv.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 47db80003ea0..ee11ff6afc4f 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -173,7 +173,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
>  			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
>  	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> -	atomic_set(&kvm->mm->context.is_protected, 0);
> +	if (!cc)
> +		atomic_dec(&kvm->mm->context.is_protected);
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
>  	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
>  	/* Intended memory leak on "impossible" error */
> @@ -214,11 +215,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
> @@ -241,8 +245,6 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>  	*rrc = uvcb.header.rrc;
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
>  		     *rc, *rrc);
> -	if (!cc)
> -		atomic_set(&kvm->mm->context.is_protected, 1);
>  	return cc ? -EINVAL : 0;
>  }
> 

