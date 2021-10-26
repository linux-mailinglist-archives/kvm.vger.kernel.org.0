Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD9443AE66
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 10:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhJZIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 04:55:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234512AbhJZIzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 04:55:12 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q73qBY004234;
        Tue, 26 Oct 2021 08:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zJN69bfYk5hk1V/sV3CAdS2aj+/MyIKIFZx5fllE52w=;
 b=sVRwj1ijPu4dI+HL1ehz1M2i8g/4mIDQnbMIp4/5uBvqnM9QOGj7WEcIK+CngrTzoJyB
 sLWzAI/tiFsEblUAWakkUjrV5j3OJ/BJWgUBKG0cLyCqBwG1O5X2pwMH1qus+mdAkB0N
 OoxbO2mZnWiItamr8Ytf/FFRY7ivVuDfNh67fDMo823FVDhtMkPoYjc1I2SG8kRsXJOk
 A4KUBsgn1jG1C4z9vz2YnlkxRtFfCDpNMA4dDM6YUnf+Ea1RgqxC4PjBLQ4FcjqEbOLD
 Ik8FJ62eIGpXHLLZGn0aDsJCINdSq0Eh4LSY7SG9L4vstQJwWVCdc18CUFedHPX90pOu 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx56wntxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 08:52:48 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19Q8YkLT006329;
        Tue, 26 Oct 2021 08:52:47 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx56wntwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 08:52:47 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19Q8ngcq017635;
        Tue, 26 Oct 2021 08:52:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bx4edkmex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 08:52:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19Q8qfHa55378314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 08:52:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD03CA4060;
        Tue, 26 Oct 2021 08:52:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09647A4064;
        Tue, 26 Oct 2021 08:52:41 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.51.215])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Oct 2021 08:52:40 +0000 (GMT)
Subject: Re: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
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
 <c5c84a99-c56a-2232-7574-a6d207d7c11f@de.ibm.com>
 <20211020095208.5e34679a.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e4e21f7a-ee60-c00a-c8d9-32a6ebe195b7@de.ibm.com>
Date:   Tue, 26 Oct 2021 10:52:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211020095208.5e34679a.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qGLl-JjD4FpEopENE2JmiTg-ATGxRPHy
X-Proofpoint-GUID: 9LY2un2UzZo2vnIoEE_NnlxicvMKH7rI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=932 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.10.21 um 09:52 schrieb Halil Pasic:
> On Tue, 19 Oct 2021 23:35:25 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>>> @@ -426,6 +426,7 @@ static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
>>>    {
>>>    	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
>>>    	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
>>> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
> 
> BTW, do you know are bit-ops garanteed to be serialized as seen by
> another cpu even when acting on a different byte? I mean
> could the kick_single_vcpu() set the clear of the kicked_mask bit but
> not see the clear of the idle mask?

clear_bit explicitely says.
  * This is a relaxed atomic operation (no implied memory barriers).

so if we really need the ordering, then we need to add a barrier.

> 
> If that is not true we may need some barriers, or possibly merging the
> two bitmasks like idle bit, kick bit alterating to ensure there
> absolutely ain't no race.
> 
