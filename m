Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121B9434073
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 23:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJSVZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 17:25:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhJSVZK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 17:25:10 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JKN8Mf031590;
        Tue, 19 Oct 2021 17:22:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tpCMg0qmbVnvItA2GpsRSgJ9lIaWzuLFmpsNZZvQqo0=;
 b=Fq3Fv+wV3Txxo7+7S9n9q/Z3LoNeLeXpZ9ou4TctaeBn+dMayt40QPUlOewGeVibdmsJ
 a89ej2nmdMdo4aAHMYpymiqTCrqBrZZm9TyzbXVdjgvTTEGtdWHTEaxgwtbBdgikeCS7
 81cVN51TwasSzol5eVpuRkVNEkJj3TSq9rpu7oVWQRGcq+lGzmzIcDr66n73ffCpFWnP
 /lckw17yAqwiBcJEcFm1qu8aKc8MtayXp8rmoc/DZKcyYNJApszoi0N2OFCr90iHxl4i
 DQZqrYDhVLlnHGB70K1O1Ffsw02p8Ni3YEcC5qGPonD9CUwp4BvRZss63FbM/OTLYth0 sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt50ss76g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:22:56 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JKNPk3032240;
        Tue, 19 Oct 2021 17:22:56 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt50ss75y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:22:56 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JLDSlB010929;
        Tue, 19 Oct 2021 21:22:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9m7xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 21:22:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JLMoQ346072110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 21:22:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 345A14C05E;
        Tue, 19 Oct 2021 21:22:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AE7C4C04E;
        Tue, 19 Oct 2021 21:22:49 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.54.36])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 21:22:49 +0000 (GMT)
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
To:     Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
 <20211019175401.3757927-2-pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <6f57d209-ac92-2470-50f9-e790a45979e1@de.ibm.com>
Date:   Tue, 19 Oct 2021 23:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019175401.3757927-2-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BYhzYGwr6iGVaQg5aIRVT_RBNbTZoIFl
X-Proofpoint-ORIG-GUID: 20339vxHPlT-oe0__8-DtHSh4Fb4kx9R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 19.10.21 um 19:53 schrieb Halil Pasic:
> The idea behind kicked mask is that we should not re-kick a vcpu that
> is already in the "kick" process, i.e. that was kicked and is
> is about to be dispatched if certain conditions are met.
> 
> The problem with the current implementation is, that it assumes the
> kicked vcpu is going to enter SIE shortly. But under certain
> circumstances, the vcpu we just kicked will be deemed non-runnable and
> will remain in wait state. This can happen, if the interrupt(s) this
> vcpu got kicked to deal with got already cleared (because the interrupts
> got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
> would return false, and the vcpu would remain in kvm_vcpu_block(),
> but this time with its kicked_mask bit set. So next time around we
> wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
> that we just kicked it.
> 
> Let us make sure the kicked_mask is cleared before we give up on
> re-dispatching the vcpu.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/kvm/kvm-s390.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..1c97493d21e1 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3363,6 +3363,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>   {
> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
>   	return kvm_s390_vcpu_has_irq(vcpu, 0);
>   }
>   
> 
