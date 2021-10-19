Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A13434083
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 23:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJSV04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 17:26:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229790AbhJSV0z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 17:26:55 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JKmvA8003889;
        Tue, 19 Oct 2021 17:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mQPAKHdHgKlOZTBNm1OjmfNiqGzyQSM0iUDWVQSTjRs=;
 b=sxynQ3cjMn9aHWwvxPGNJbqV//GVf0zahh3ab+mtNc5FenUwRPFbTUVmtypI9Bu/SIqt
 exiZnIs6VaP0hUKxy8f0eg0UcLWIZNbBRPh7r0SkLDPjmWYhkqEa7wJeCChJgDZyglUs
 wp1h3lavTsykaIOERuxc/fg1OolPB7fuuicFfmnvbLTT38COp/wNPeAJPmAp7sID4he0
 dKRB2HUzGzzXQWjGFysB5Pm6HNqu9fLcJQSJJ8j+Esq0KmBBoh9MGuvZkHugYNrr6pIc
 LFxchcrIRkPeDOR7HrQFL1vQm8mt6dNpVjUvuFLTjlCIhItCfzHz4X62VYcwomPGSqLa 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt362c2vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:24:41 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JK8BMC017358;
        Tue, 19 Oct 2021 17:24:40 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bt362c2uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 17:24:40 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JLCIE4032115;
        Tue, 19 Oct 2021 21:24:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3bqp0k4925-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 21:24:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JLOZ5A52494836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 21:24:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B6714C050;
        Tue, 19 Oct 2021 21:24:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0A3E4C04E;
        Tue, 19 Oct 2021 21:24:34 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.54.36])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 21:24:34 +0000 (GMT)
Subject: Re: [PATCH 2/3] KVM: s390: preserve deliverable_mask in
 __airqs_kick_single_vcpu
To:     Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e8faa255-5157-4afb-b79f-710c961ef159@de.ibm.com>
Date:   Tue, 19 Oct 2021 23:24:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019175401.3757927-3-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8YUA7e5jHvjyBjmkC1j-tXi4Hs0Vxn_a
X-Proofpoint-ORIG-GUID: fDWV0cTXB5mDtPQVT3Ac9K-F6mH_qqoz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=966 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 19.10.21 um 19:54 schrieb Halil Pasic:
> Changing the deliverable mask in __airqs_kick_single_vcpu() is a bug. If
> one idle vcpu can't take the interrupts we want to deliver, we should
> look for another vcpu that can, instead of saying that we don't want
> to deliver these interrupts by clearing the bits from the
> deliverable_mask.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

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
