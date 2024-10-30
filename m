Return-Path: <kvm+bounces-30065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F559B698A
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:49:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 008A81C2133D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F593215036;
	Wed, 30 Oct 2024 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dzr+tNNu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0072144C4;
	Wed, 30 Oct 2024 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730306974; cv=none; b=kfBFtsYjzHtN/D+gUzEHEilzFlhK1KSkzogU8xjQusEmL3QjKxrzJwXI+mm15TidodrwZJQMel3Euyiyzp9+IqJsA5fJtIT8Ny3sPtaEynRpSEzcMOsdGqQFxaStQnIGrRcWMIWpivIXH6ckTmjJqDfm6k8dPcXYNSmuotYNYyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730306974; c=relaxed/simple;
	bh=RkVeWxeRRkmjJB4/R7UwIT9Q1ckLvtqNuXSUaE0JnBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JPec4y9hZD7lyE9y/qt9yKjTPAB820piO8LOsqWZMKsPotA1TqRHbDC2YeLadbmkKLaNvrClVgsLFv8RV4DoX1yH+bU31gmxq6BMHeHIPidH9iq93OJOXbKWZGj3TcP+yNxsFec/KR3jn9FtoQZk/smUsCGXtsz21/M5Yu7LNvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dzr+tNNu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDw8OD013373;
	Wed, 30 Oct 2024 16:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KZ6C4b
	GdYZUKbQoFAev6EjLz2yF6JNszEp8+h5mO/4w=; b=Dzr+tNNufTYPEu1dQYorW5
	dK/D6fZITiadDV9BMVF1AG27hir1YVtc/gdNGJU23+WMbxnlZdAxz6L5GarfzTxw
	qnYx68Agj/yZYYdrva5TpVHqYDA4et5S4qzTeS3ms47QQlyr2FR0V/8Clgih+CD2
	oazy+hJphs/3RDNDdFC3V09lFa12aIQc7UR0DMdjap+wL4y3o5cJhbylyuEHLwjd
	PrdT0zpL3wmzSeyPdP4+NhkL2wvPXMqZssLb+lgKwsawKuyTrOH2liSxOOAdna28
	SqDj+Cv9dMH68rRdFJQMhyFfecx49oDQguRdn3X/SScBn+L7rvP3bxhE6dk0pEaw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65knun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:49:22 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49UGnMiH014907;
	Wed, 30 Oct 2024 16:49:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65knuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:49:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UGEWDl018808;
	Wed, 30 Oct 2024 16:49:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hc8k8ttu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:49:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UGnHmj58720682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:49:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EDAD2004B;
	Wed, 30 Oct 2024 16:49:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4805720040;
	Wed, 30 Oct 2024 16:49:16 +0000 (GMT)
Received: from [9.171.2.34] (unknown [9.171.2.34])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Oct 2024 16:49:16 +0000 (GMT)
Message-ID: <67a85d88-6705-4e8e-ba48-7b945aca4d8f@linux.ibm.com>
Date: Wed, 30 Oct 2024 17:49:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] virtio-mem: s390 support
To: Heiko Carstens <hca@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241030093453.6264-H-hca@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20241030093453.6264-H-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qom_Th8fefJ6KQNAeS0Ea6VlUPdeBuG0
X-Proofpoint-GUID: lghy8jOAyVd359QXEI4RS9zRmCQXmgAp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300131



Am 30.10.24 um 10:34 schrieb Heiko Carstens:
> On Fri, Oct 25, 2024 at 04:14:45PM +0200, David Hildenbrand wrote:
>> Let's finally add s390 support for virtio-mem; my last RFC was sent
>> 4 years ago, and a lot changed in the meantime.
>>
>> The latest QEMU series is available at [1], which contains some more
>> details and a usage example on s390 (last patch).
>>
>> There is not too much in here: The biggest part is querying a new diag(500)
>> STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
> 
> ...
> 
>> David Hildenbrand (7):
>>    Documentation: s390-diag.rst: make diag500 a generic KVM hypercall
>>    Documentation: s390-diag.rst: document diag500(STORAGE LIMIT)
>>      subfunction
>>    s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM
>>      memory devices
>>    virtio-mem: s390 support
>>    lib/Kconfig.debug: default STRICT_DEVMEM to "y" on s390
>>    s390/sparsemem: reduce section size to 128 MiB
>>    s390/sparsemem: provide memory_add_physaddr_to_nid() with CONFIG_NUMA
>>
>>   Documentation/virt/kvm/s390/s390-diag.rst | 35 +++++++++++++----
>>   arch/s390/boot/physmem_info.c             | 47 ++++++++++++++++++++++-
>>   arch/s390/boot/startup.c                  |  7 +++-
>>   arch/s390/include/asm/physmem_info.h      |  3 ++
>>   arch/s390/include/asm/sparsemem.h         | 10 ++++-
>>   drivers/virtio/Kconfig                    | 12 +++---
>>   lib/Kconfig.debug                         |  2 +-
>>   7 files changed, 98 insertions(+), 18 deletions(-)
> 
> I'll apply the whole series as soon as there are ACKs for the third
> patch, and from the KVM guys for the whole series.
> Christian, Janosch, Claudio?

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
for the series.

@Eric Farman,
Was someone from your team planning to look into this (testing, review whatever)?

