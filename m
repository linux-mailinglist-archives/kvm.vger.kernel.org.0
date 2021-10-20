Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704C94349AC
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 13:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJTLG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 07:06:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhJTLG0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 07:06:26 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9HpSd007966;
        Wed, 20 Oct 2021 07:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hRDhLCN8GBjSMHXWCixLpR0S32DdAhVOdT9o9uLMALM=;
 b=KD4r1eP8WYuqnEpoxRBSH4jqODTCC+BMf/ZP8hiW5TLfrj2olpx/O8hkezwH6N5mMDA+
 EkI4DoNN6ZmCLtTIr1aRt/ppQaqlXS73vdNPKo15Uiwbj3kFRrAoWzDOzY8rUKgfdhzy
 j7xfpCvZYb68vwBBMV5Fkzd8XIMlrWqBnYKEbZ7xl/b8aEulgU09bQWa3FQ0DE5l4BFZ
 ipUplf0ROKOpc89TwrL0skTg3/2ZE7m1zKVMp7VO9ZsmhztaQv8uw3p+0vpcVn2cB2Dk
 8dLrCtDlisiQBbRWt4Q1kE9Z7TNs3jcp+KP8gRz9MZi5UFQnW0jbnSTY4yyYJLJIBB9J wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btgbv20qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 07:04:12 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19KAVDNc015210;
        Wed, 20 Oct 2021 07:04:12 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btgbv20q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 07:04:11 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KB3Xeh022514;
        Wed, 20 Oct 2021 11:04:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9s56u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 11:04:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KB46ll64946474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 11:04:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E15752099;
        Wed, 20 Oct 2021 11:04:06 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.54.36])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8F3295206C;
        Wed, 20 Oct 2021 11:04:05 +0000 (GMT)
Subject: Re: [PATCH 0/3] fixes for __airqs_kick_single_vcpu()
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <66c52e65-4e4c-253f-45bc-69c041e1230c@de.ibm.com>
Date:   Wed, 20 Oct 2021 13:04:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019175401.3757927-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QGq1slRpftlNyibFnYMdI4Hs06AjPEjw
X-Proofpoint-ORIG-GUID: rhfZ2vi6s9g3nroV70qzwsAsngyZWCev
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 19.10.21 um 19:53 schrieb Halil Pasic:
> The three fixes aren't closely related. The first one is the
> most imporant one. They can be picked separately. I deciced to send them
> out together so that if reviewers see: hey there is more broken, they
> can also see the fixes near by.
> 
> Halil Pasic (3):
>    KVM: s390: clear kicked_mask before sleeping again
>    KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu
>    KVM: s390: clear kicked_mask if not idle after set
> 
>   arch/s390/kvm/interrupt.c | 12 +++++++++---
>   arch/s390/kvm/kvm-s390.c  |  3 +--
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> 
> base-commit: 519d81956ee277b4419c723adfb154603c2565ba

I picked and queued patches 1 and 2. Thanks a lot for fixing.
I will need some time to dig through the code to decide about patch3.
