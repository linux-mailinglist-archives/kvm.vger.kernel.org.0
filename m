Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFA93FA979
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 08:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhH2G0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 02:26:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53074 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229889AbhH2G0J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Aug 2021 02:26:09 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17T6AmIN007798;
        Sun, 29 Aug 2021 02:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1Vk1w6N7Defqj+no473Bhai+LgvnPPAardePIMhLEqg=;
 b=UliAjHYkgfx7GIJ340DpMgDMGWxfJmVz6rMQ3DGkuris0Omp0Q7JhkkYKaRdfCkUVAar
 3bdtRkxBFvj2AgXnloKCXc0icPqfZ24jeP3xLAfZcrjDZ3nsz84gtOq5ugXpKHZAIfLS
 2clZ3lFmWnD4CH0rviVLc9Ylcut0HfAmJSlS0xDY5sE9tJccp0vRpNUTi/dW+tOUBE1v
 2ab7Cxnw4x/D0xFrG5MQN8wtv/LV7CNXlcBOkqzSRh/FRWi02OxkzbG9yKAM3e7WUAS3
 1FnBPvUyucpW95FlaM4EuOkE/kovCia5XZIG34JGkKKykDakWpwJYbusdHugkY4BlRAH gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar2es2ghj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:25:17 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17T6BSOM008921;
        Sun, 29 Aug 2021 02:25:17 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar2es2gh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:25:16 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17T6IO1K021309;
        Sun, 29 Aug 2021 06:25:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3aqcs8sekk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 06:25:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17T6PBKU53543382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 06:25:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 368A74C059;
        Sun, 29 Aug 2021 06:25:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C07CA4C04E;
        Sun, 29 Aug 2021 06:25:10 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.11.228])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 29 Aug 2021 06:25:10 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Mueller <mimu@linux.ibm.com>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
 <20210827160616.532d6699@p-imbrenda>
 <e9d2f79c-b784-bc6b-88dc-2d0f7cc08dbe@de.ibm.com>
 <20210827232344.431e3114.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <be84123f-4f1b-2efb-fba2-e8d644b71b8f@de.ibm.com>
Date:   Sun, 29 Aug 2021 08:25:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827232344.431e3114.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xAyEYvN7uL_jCRx0oMwn9daTi7Atj7gv
X-Proofpoint-GUID: X3ggBqi7uCAlhN0_PllS0UEzYJo54Krk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-29_02:2021-08-27,2021-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108290035
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.08.21 23:23, Halil Pasic wrote:
> On Fri, 27 Aug 2021 18:36:48 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 27.08.21 16:06, Claudio Imbrenda wrote:
>>> On Fri, 27 Aug 2021 14:54:29 +0200
>>> Halil Pasic <pasic@linux.ibm.com> wrote:
>>>    
>>>> While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,
> 
> s/vcp_id/vcpu_id/
> 
>>>> it may not always be, and we must not rely on this.
>>>
>>> why?
>>>
>>> maybe add a simple explanation of why vcpu_idx and vcpu_id can be
>>> different, namely:
>>> KVM decides the vcpu_idx, userspace decides the vcpu_id, thus the two
>>> might not match
>>>    
>>>>
>>>> Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
>>>> that code like
>>>> for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
>>>>                   vcpu = kvm_get_vcpu(kvm, vcpu_id);
>>>
>>> you can also add a sentence to clarify that kvm_get_vcpu expects an
>>> vcpu_idx, not an vcpu_id.
>>>    
>>>> 		do_stuff(vcpu);
>>
>> I will modify the patch description accordingly before sending to Paolo.
>> Thanks for noticing.
> 
> Can you also please fix the typo I pointed out above (in the first line
> of the long description).

I already queued, but I think this is not a big deal.
