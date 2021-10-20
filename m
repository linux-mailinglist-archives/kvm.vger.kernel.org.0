Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622A5434969
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhJTKyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:54:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTKyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:54:50 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KAPN99031982;
        Wed, 20 Oct 2021 06:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uEjpzIz3iaI9bxQp1J3Sc/M4D7jV3FdCgUWlHWIGP5c=;
 b=lkym+TGxMT1SC7t4SlWKlN0pFlxjzjy3KUOTBBJachZc+yLXE3xIjkXO4gNoNe/f2NyL
 hoXktfAFLed8wAwlQLkj0Cyl/XzGupc+MBCYRfh2ixbQn9zHqUB+eKonqF9lTgKYg739
 mXkZrVsK7o6ZlZlsq/6K5zoeVV8ojrJGX+naZDh8eiHUY0Wu6HOyYfGuSJmAFhiaUmFX
 tGJ8X8w7vPZ+jpwqfQQETxhrY+PXh1qVFJy+uXLoUvrySkpns7NamavgsYrTmdBX1R/l
 w+Vz1Xdfva6ux+N731Zq+71VRsK0ev6hHA9kA+MynkPhlAy5UayiykbKMmir+eymVkSY aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btep1c3hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:52:36 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K7vkiU015996;
        Wed, 20 Oct 2021 06:52:35 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btep1c3h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:52:35 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KAnrBT009534;
        Wed, 20 Oct 2021 10:52:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpca12dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 10:52:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KAqTfn56754548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:52:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24D9F52079;
        Wed, 20 Oct 2021 10:52:29 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.54.36])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 73AD652073;
        Wed, 20 Oct 2021 10:52:28 +0000 (GMT)
Subject: Re: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
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
 <20211019175401.3757927-4-pasic@linux.ibm.com>
 <8cb919e7-e7ab-5ec1-591e-43f95f140d7b@linux.ibm.com>
 <ae8b3b11-2eef-0712-faee-5e3467d3e985@de.ibm.com>
 <20211020124513.6b90a15b.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ba6c17f2-bb10-fcd3-be6a-b2edd667ea2b@de.ibm.com>
Date:   Wed, 20 Oct 2021 12:52:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211020124513.6b90a15b.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UZRxnofDHxbDZZDwgSx-rI0EhNEEvNcJ
X-Proofpoint-GUID: NOh07Y2zhoLQSxyPGexQcS52umJVfRn3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=973 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.10.21 um 12:45 schrieb Halil Pasic:
> On Wed, 20 Oct 2021 12:31:19 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>>> Before releasing something like this, where none of us is sure if
>>> it really saves cpu cost, I'd prefer to run some measurement with
>>> the whole kicked_mask logic removed and to compare the number of
>>> vcpu wake ups with the number of interrupts to be processed by
>>> the gib alert mechanism in a slightly over committed host while
>>> driving with Matthews test load.
>>
>> But I think patch 1 and 2 can go immediately as they measurably or
>> testable fix things. Correct?
> 
> I think so as well. And if patch 3 is going to be dropped, I would
> really like to keep the unconditional clear in kvm_arch_vcpu_runnable(),
> as my analysis in the discussion points out: I think it can save us
> form trouble this patch is trying to address.

Yes, lets keep patch 1 and 2 as us and let us look deeper into this patch.
I will apply and queue 1 and 2 soon.
