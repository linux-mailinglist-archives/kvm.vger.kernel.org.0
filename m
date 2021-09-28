Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD6241AD90
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 13:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbhI1LIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 07:08:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37450 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240378AbhI1LIP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 07:08:15 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8XcLk016130;
        Tue, 28 Sep 2021 07:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1mpgBy81r5FdFxJZiUWxd+sXDCw4TLJf2XVitgyiAms=;
 b=Ei8KyJPPCres3lucKTDLFVi6hzoOKNvW0z1qBpbXd/JflA14M1N/RF+ve31BWBY+XfjG
 jpJ/cDX1L4fJSP0H5EijMkQRuOA3OIHGaqJlz+ac844PxnerTEnN5W4qwSFJU5cPt3ZQ
 YALeuRaK+3gjbBhzmnSQQF4rtcG1UQrGCQUVy9oggY46IsdCVrIItP6UTv6iaaskgR7o
 Fq7lX4+B43b4WRit7pSmszyni3n3YFgOEBCjxoQPEpr3dWqmA0Xm9+E2iSL/HdCxp5SQ
 LgyoBayNOHcDEvGiOR08GOWbPQavfhJ3cBh6K4Fu0oN9AjNMz6MON2K4wWHNbp+pJq4D iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbyn82xem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:06:34 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18SB4i2q016019;
        Tue, 28 Sep 2021 07:06:34 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbyn82xe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:06:33 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SB1tnp007615;
        Tue, 28 Sep 2021 11:06:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3b9ud9kj2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 11:06:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SB6Rjj42205456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:06:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99FF65208C;
        Tue, 28 Sep 2021 11:06:27 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.40.159])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D9F565208B;
        Tue, 28 Sep 2021 11:06:26 +0000 (GMT)
Subject: Re: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations
 for page table walkers
To:     Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <20210909162248.14969-1-david@redhat.com>
 <YVL1iwSicgWg1qx+@osiris>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <98061eff-f856-fc1d-9f04-a31ac5fcd790@de.ibm.com>
Date:   Tue, 28 Sep 2021 13:06:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YVL1iwSicgWg1qx+@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v6ZpB-tt9vrgOnGrtd7cBEZrbFucJ2xE
X-Proofpoint-GUID: 6Ey1BHB2gKtyVKQWMQVPkoWs1sYwhLkN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 28.09.21 um 12:59 schrieb Heiko Carstens:
> On Thu, Sep 09, 2021 at 06:22:39PM +0200, David Hildenbrand wrote:
>> Resend because I missed ccing people on the actual patches ...
>>
>> RFC because the patches are essentially untested and I did not actually
>> try to trigger any of the things these patches are supposed to fix. It
>> merely matches my current understanding (and what other code does :) ). I
>> did compile-test as far as possible.
>>
>> After learning more about the wonderful world of page tables and their
>> interaction with the mmap_sem and VMAs, I spotted some issues in our
>> page table walkers that allow user space to trigger nasty behavior when
>> playing dirty tricks with munmap() or mmap() of hugetlb. While some issues
>> should be hard to trigger, others are fairly easy because we provide
>> conventient interfaces (e.g., KVM_S390_GET_SKEYS and KVM_S390_SET_SKEYS).
>>
>> Future work:
>> - Don't use get_locked_pte() when it's not required to actually allocate
>>    page tables -- similar to how storage keys are now handled. Examples are
>>    get_pgste() and __gmap_zap.
>> - Don't use get_locked_pte() and instead let page fault logic allocate page
>>    tables when we actually do need page tables -- also, similar to how
>>    storage keys are now handled. Examples are set_pgste_bits() and
>>    pgste_perform_essa().
>> - Maybe switch to mm/pagewalk.c to avoid custom page table walkers. For
>>    __gmap_zap() that's very easy.
>>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: Janosch Frank <frankja@linux.ibm.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>> Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> 
> For the whole series:
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> 
> Christian, given that this is mostly about KVM I'd assume this should
> go via the KVM tree. Patch 6 (pci_mmio) is already upstream.

Right, I think I will queue this even without testing for now.
Claudio, is patch 7 ok for you with the explanation from David?
