Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621333BE4D2
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGGI7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 04:59:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231195AbhGGI7n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 04:59:43 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1678Xg3j180981;
        Wed, 7 Jul 2021 04:57:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KDpKjoslFLUj36UWkbF3lTER8U+ihOf8UMMKyQlZUIw=;
 b=Wm7YBPNyuHa5yydcmmuoWEBGYsvk1ZcyUFeCS193LUZdvDznjk1rQ94CQRjFQQjdj+A3
 iUvzLOA5SaGLOw7ZqlePZILNq2pDsTojSwNu88eTXfMShZF3EWup31ztlWdiKY6XE4xL
 9TxbsMRIDtjXbUn7gJOQ/PqfmwIvazKz860aeV5JGh9pXadiwwX83KUbl0jArMa3aUXw
 JHe3KOgjNCc7KUC1+LfyQ4bIcdJX3xDOoAM2LdtbUu/Ytq+GtjkAFlV8EbkElMP2ImUI
 4ud2usba9lJopWHyDrZpY2Ce37fiZCsyMO1hQyG0NW0mBIlI4FxnyCQXZvqUbRdaGuFv 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkev0yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:57:00 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1678YkVt185643;
        Wed, 7 Jul 2021 04:56:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mbkev0xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:56:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1678cKIa002326;
        Wed, 7 Jul 2021 08:56:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8sn9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:56:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1678usrA31457730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 08:56:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA216AE08F;
        Wed,  7 Jul 2021 08:56:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AE52AE065;
        Wed,  7 Jul 2021 08:56:53 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.25.185])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 08:56:53 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
 <05430c91-6a84-0fc9-0af4-89f408eb691f@de.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <c61223e4-0076-18c1-64bd-8ba899e91eb4@linux.vnet.ibm.com>
Date:   Wed, 7 Jul 2021 10:56:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <05430c91-6a84-0fc9-0af4-89f408eb691f@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y2QuoV-bDBKUBRBZOvJTecMlZ_IeZtTK
X-Proofpoint-ORIG-GUID: K1PIvK5-ynjtwKjZ4THaCwQglsXQ-oig
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_05:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 10:30 AM, Christian Borntraeger wrote:
> 
> 
> On 06.07.21 13:47, Janis Schoetterl-Glausch wrote:
>> When this feature is enabled the hardware is free to interpret
>> specification exceptions generated by the guest, instead of causing
>> program interruption interceptions.
>>
>> This benefits (test) programs that generate a lot of specification
>> exceptions (roughly 4x increase in exceptions/sec).
>>
>> Interceptions will occur as before if ICTL_PINT is set,
>> i.e. if guest debug is enabled.
> 
> I think I will add
> 
> There is no indication if this feature is available or not and the hardware
> is free to interpret or not. So we can simply set this bit and if the
> hardware ignores it we fall back to intercept 8 handling.

Might also mention vSIE and/or incorporate into first paragraph:

When this feature is enabled the hardware is free to interpret
specification exceptions generated by the guest, instead of causing
program interruption interceptions, but it is not required to.
There is no indication if this feature is available or not,
so we can simply set this bit and if the hardware ignores it
we fall back to intercept 8 handling.
The same applies to vSIE, we forward the guest hypervisor's bit
and fall back to injection if interpretation does not occur.
> 
> 
> With that
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

[...]
