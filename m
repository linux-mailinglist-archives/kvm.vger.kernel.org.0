Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE82CF503
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgLDTrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:47:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727661AbgLDTrq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 14:47:46 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4JiHTi196020;
        Fri, 4 Dec 2020 14:47:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8a77UUMiq9aXpaoXgk2MT/s4sQkpAeEjN2QJ/tkV+K4=;
 b=cO1uDNppvNO2CkyQUg8ACR2pufJzvcgbVoTSxtmBsHYOxe7jDFvo7HGyQk4NzYII5h3j
 sVJ9A2yB4NdC1GpgROya/B7gZgyrZIfolhdB87KkxR0kg0HVox5vdeGMtTTMsvgk7r/1
 Cw2N+kUNUdknWbfhgTuCRiS9IfvhCOjHxU/2Inn6wzJTkfaoawr9NsCpXKnwsvbDpltQ
 dqBHpezmYRdBCza4Z8qmUfcudmgYWOPxXRuyqpgYpwu2Kk/7CgeXx4v2OAUm6Z3lRP+9
 e8Qgu6nXMQCPjX3yNh/+Ds3PJU+mlwC2T0WBIJVXNHb2jZS7GCjIYiSEGwB5qyLELS7w VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357t9w20r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:46:56 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4JiJ2Y196131;
        Fri, 4 Dec 2020 14:46:55 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357t9w1yq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:46:55 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Jfd1Q022608;
        Fri, 4 Dec 2020 19:46:32 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 355rf88pxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 19:46:32 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4JkVAD35914066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 19:46:31 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73F7C28058;
        Fri,  4 Dec 2020 19:46:31 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F18EE28064;
        Fri,  4 Dec 2020 19:46:30 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.205])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Dec 2020 19:46:30 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
 <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
 <20201204200502.1c34ae58.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <cf2c6632-bcdc-fb93-471b-bfd834d87902@linux.ibm.com>
Date:   Fri, 4 Dec 2020 14:46:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201204200502.1c34ae58.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_09:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=3 clxscore=1015 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/4/20 2:05 PM, Halil Pasic wrote:
> On Fri, 4 Dec 2020 09:43:59 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>> +{
>>>> +	if (matrix_mdev->kvm) {
>>>> +		(matrix_mdev->kvm);
>>>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
>>> to take more care?
>>>
>>> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
>>> kvm->arch.crypto.crycb.
>> I do not think so. The CRYCB is used by KVM to provide crypto resources
>> to the guest so it makes sense to protect it from changes to it while
>> passing
>> the AP devices through to the guest. The hook is used only when an AQIC
>> executed on the guest is intercepted by KVM. If the notifier
>> is being invoked to notify vfio_ap that KVM has been set to NULL, this means
>> the guest is gone in which case there will be no AP instructions to
>> intercept.
> If the update to pqap_hook isn't observed as atomic we still have a
> problem. With torn writes or reads we would try to use a corrupt function
> pointer. While the compiler probably ain't likely to generate silly code
> for the above assignment (multiple write instructions less then
> quadword wide), I know of nothing that would prohibit the compiler to do
> so.

I see that in the handle_pqap() function in arch/s390/kvm/priv.c
that gets called when the AQIC instruction is intercepted,
the pqap_hook is protected by locking the owner of the hook:

         if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
             return -EOPNOTSUPP;
         ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);

Maybe that is what we should do when the kvm->arch.crypto.pqap_hook
is set to NULL?

>
> I'm not certain about the scope of the kvm->lock (if it's supposed to
> protect the whole sub-tree of objects). Maybe Janosch can help us out.
> @Janosch: what do you think?
>
> Regards,
> Halil

