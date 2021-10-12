Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA28B429F72
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhJLIOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:14:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234368AbhJLIOQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 04:14:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C7BuLA025379;
        Tue, 12 Oct 2021 04:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UBvR0dtMrJJZmdnD9mHyhJw/A6HCKHwPmazkWa5vO9c=;
 b=epY70z1pTMVyaAYpw6+EOZuc+ce2WC9ENLdLFRoFgo7i4MzzKANZZnD0SStTxS3VmECH
 znOSMIqns2PA91lWaBdaDIipMzAhNxkueRe+4H38DWzcyrNA8T8MKXZmeQTOupXRQxSG
 KDVjtuHC5bqMu1S8oAygqSRu13n13BxgzzOgPh//zaLOQfGY+MxwIcHdGYwDdq+LbOgG
 nY27KI43JFSrRIfFcDSBg0FV0tRbNZOBniSOIMz3DDk4o4CkeUWM81NH4pTzYFDD/47D
 VW77YShUCBynZ8AMr9RO3mUKG7p2wdo2RdmPKNl9fCQiGzcAiZdVxuudFqemPBxaPdQW Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn5rts8td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:12:15 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C7CE09025704;
        Tue, 12 Oct 2021 04:12:14 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn5rts8sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:12:14 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C8BRuD022897;
        Tue, 12 Oct 2021 08:12:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bk2q9vcjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:12:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C86Qr736241798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 08:06:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D28642041;
        Tue, 12 Oct 2021 08:12:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2A3E42042;
        Tue, 12 Oct 2021 08:12:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.88])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 08:12:00 +0000 (GMT)
Date:   Tue, 12 Oct 2021 09:45:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/6] KVM: s390: Add a routine for setting
 userspace CPU state
Message-ID: <20211012094531.5016a5a0@p-imbrenda>
In-Reply-To: <20211008203112.1979843-7-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
        <20211008203112.1979843-7-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PLOU9M1QafDizAEHqKcN9Q5wyzI6NnwD
X-Proofpoint-ORIG-GUID: bXoHR-PHWwH9kkQRgtXa5cj5N2zzNldz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 spamscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  8 Oct 2021 22:31:12 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> This capability exists, but we don't record anything when userspace
> enables it. Let's refactor that code so that a note can be made in
> the debug logs that it was enabled.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 6 +++---
>  arch/s390/kvm/kvm-s390.h | 9 +++++++++
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 33d71fa42d68..48ac0bd05bee 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2487,8 +2487,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	case KVM_S390_PV_COMMAND: {
>  		struct kvm_pv_cmd args;
>  
> -		/* protvirt means user sigp */
> -		kvm->arch.user_cpu_state_ctrl = 1;
> +		/* protvirt means user cpu state */
> +		kvm_s390_set_user_cpu_state_ctrl(kvm);
>  		r = 0;
>  		if (!is_prot_virt_host()) {
>  			r = -EINVAL;
> @@ -3801,7 +3801,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  	vcpu_load(vcpu);
>  
>  	/* user space knows about this interface - let it control the state */
> -	vcpu->kvm->arch.user_cpu_state_ctrl = 1;
> +	kvm_s390_set_user_cpu_state_ctrl(vcpu->kvm);
>  
>  	switch (mp_state->mp_state) {
>  	case KVM_MP_STATE_STOPPED:
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 57c5e9369d65..36f4d585513c 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -208,6 +208,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
>  	return kvm->arch.user_cpu_state_ctrl != 0;
>  }
>  
> +static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
> +{
> +	if (kvm->arch.user_cpu_state_ctrl)
> +		return;
> +
> +	VM_EVENT(kvm, 3, "%s", "ENABLE: Userspace CPU state control");
> +	kvm->arch.user_cpu_state_ctrl = 1;
> +}
> +
>  /* implemented in pv.c */
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);

