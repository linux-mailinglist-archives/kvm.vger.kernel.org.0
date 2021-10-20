Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B1243467E
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 10:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhJTILM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 04:11:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhJTILK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 04:11:10 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K7EP8W001882;
        Wed, 20 Oct 2021 04:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qbg7CLBot4uVy5aQfP5y60v7vL6d/6Y0PBOd79oTOkA=;
 b=MsjCXrWWO+URiMt+UoXLtPo2fI44oJPv5QxyjKcUo7uzdK7R//X5W8BpL93GAi72aong
 DFlgpesVXgJZX5ScGIDyoWN9JdQagRFPDp4PpHF9t8PioaAXSh2jDTC9zAyru7MMBQtK
 PU5cNOZSrbmV7A4P97Cx8oVzk6P6zffZukfmukzNgsvclCPA92WaMcDvrig5fHTwJWyN
 uML4IeacUeyxZwyztBmqWb2UBWS+/oZ1+bm9BIwNfaz/nmXnN09+h5WqkB3V509AgJBG
 IWnKbFmrouda/R8O/JPgnVChcoK87BsRAjD6kBCQSt6q4oF5UJ75u6nZ0/Pe9gCZVsQo fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt3an6bg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 04:08:56 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K88t1D023535;
        Wed, 20 Oct 2021 04:08:55 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt3an6bfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 04:08:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K7vWoE018272;
        Wed, 20 Oct 2021 08:08:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9qq82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:08:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K82uec48431378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 08:02:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 806015204F;
        Wed, 20 Oct 2021 08:08:49 +0000 (GMT)
Received: from ant.fritz.box (unknown [9.145.151.144])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C52A252052;
        Wed, 20 Oct 2021 08:08:48 +0000 (GMT)
Subject: Re: [PATCH 2/3] KVM: s390: preserve deliverable_mask in
 __airqs_kick_single_vcpu
To:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
 <20211019175401.3757927-3-pasic@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Message-ID: <103bd82f-b53d-78cb-c850-8669e10bea37@linux.ibm.com>
Date:   Wed, 20 Oct 2021 10:08:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019175401.3757927-3-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wdQsipm55CMUKPy_YlU5zzjASVh_5ARQ
X-Proofpoint-ORIG-GUID: TphcIZ-CESOLkbIwLF7RbjNb4W06vGHJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxlogscore=973 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.10.21 19:54, Halil Pasic wrote:
> Changing the deliverable mask in __airqs_kick_single_vcpu() is a bug. If
> one idle vcpu can't take the interrupts we want to deliver, we should
> look for another vcpu that can, instead of saying that we don't want
> to deliver these interrupts by clearing the bits from the
> deliverable_mask.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

> ---
>   arch/s390/kvm/interrupt.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 10722455fd02..2245f4b8d362 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3053,13 +3053,14 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
>   	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
>   	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>   	struct kvm_vcpu *vcpu;
> +	u8 vcpu_isc_mask;
>   
>   	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
>   		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
>   		if (psw_ioint_disabled(vcpu))
>   			continue;
> -		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
> -		if (deliverable_mask) {
> +		vcpu_isc_mask = (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
> +		if (deliverable_mask & vcpu_isc_mask) {
>   			/* lately kicked but not yet running */
>   			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
>   				return;
> 
