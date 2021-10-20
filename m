Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440F0434673
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 10:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhJTIJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 04:09:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229603AbhJTIJR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 04:09:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K7Hf0u028013;
        Wed, 20 Oct 2021 04:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=r+tgeonmr4Hq5LiaoRauNu+8++LgDAY5Au6mZi76bGA=;
 b=Svc38cPB2294kFYALDirLEfw+zhmyVImnEUokn1wYj2ho6OHncfkweC9QvPllkpaFnFp
 ajo7EXub/QlrsOwZTzXPUZZKVmnAK7yX712ahUL0hrPTJ7wjhACTl4e1BQUmPCcS0wm+
 hGfoyQLJjDobSy3EST7c3BQEUXRnfkPyW5oilUutH9KOiazZr8pCVHE3xbXBfLj5Xhzp
 33iSZ0kjYqK8HL0w0AupJBFNdbyiHwC97e4Q2PvSKwT5J3VVSR9P1EE0JZEFS1Ccch2X
 4/q0RpyQKBplgeNsYL0x5zJNIG1P2+JAm2MAStA+K/ov3EBONCFObC59qCr5INxF89cF Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btekm8w1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 04:07:03 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K7u2wk014966;
        Wed, 20 Oct 2021 04:07:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btekm8w0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 04:07:02 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K7vbNM024399;
        Wed, 20 Oct 2021 08:07:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpc9yq0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:06:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K86uig60228004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 08:06:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A00845205A;
        Wed, 20 Oct 2021 08:06:56 +0000 (GMT)
Received: from ant.fritz.box (unknown [9.145.151.144])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A58DA5204F;
        Wed, 20 Oct 2021 08:06:55 +0000 (GMT)
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
To:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
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
From:   Michael Mueller <mimu@linux.ibm.com>
Message-ID: <e26b8254-7e71-4079-bbbb-f43598c586e6@linux.ibm.com>
Date:   Wed, 20 Oct 2021 10:06:55 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019175401.3757927-2-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8KYMXSRSsdoxopFX2X1xXh1vRkC9H86D
X-Proofpoint-ORIG-GUID: pCXnAG6IhT0ZCRo4pZdb3-tJxtRK714X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=996 adultscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.10.21 19:53, Halil Pasic wrote:
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

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

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
