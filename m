Return-Path: <kvm+bounces-29250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4E79A5A72
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1074AB2154F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6BCA1D07BD;
	Mon, 21 Oct 2024 06:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ARnhkOK5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DECA194C6C;
	Mon, 21 Oct 2024 06:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492446; cv=none; b=t5+Q8phWfxZ5ezGudR2dG5bsB+M4/vOj3ahUkPnE9jr3xV9xzjAdk+ZJNPHJrgwHIJgIeY33Jr+YJ7MUlKAfulwE2tNOnP1RfzrUEMdU20zEgWNp/fJrXhXiubYiof+aBsmcwkJ93VJYq143nVKoX/IekpaAl4dwx8PxOrOnMlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492446; c=relaxed/simple;
	bh=d+Vn5Dqu0W7NzPHX/GrXXUEhW3wXOthQtBtO6LLwieE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AOl/krtWkGWX6nJC91l5W/C+9BTiXokGdaV/wGcODwiw0Kd4iiOYVDt+CdT6eY+e/jeAvUcBJdNSd0xhDXiJdW9wRLcDOyWX6gnp//Jbjz2rF5kchj8Hbd8Uc1iUX3p4G7zlZ9jJcVdfsyPN/XiZPoGWBXhmY0qEJj8Mo//nl/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ARnhkOK5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2KHwX002179;
	Mon, 21 Oct 2024 06:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QKaq4B
	5URAFGBy0bwe2UmpkraYPJ2j4a6Afx8H1P0X8=; b=ARnhkOK5gLJCohv7zvJln5
	KtBlrpHd5u3tMrI0NxOHaHponCeVVkq+d2/uugPxNBEydz/TQr3zG9tDX2Uc2Ldm
	Q3SLMBz2vLtKHpPzDUoZJk2vmkake10+YLeA440DsVzkph5gTILQBs1+QW66G5nh
	61xO4c1/475UDzmjFOPtsMXO1+jhnceejSNmVOSmPW+hKQaHajFPtE70X8KuXsD+
	ZkNHcK6Lfud1hzWf1ew+WhQomIZ1FRHRHwZBdHjXyDPh4KEx765d4/6/P9/iERA/
	ExBU+gCvB0BeXPWtkCxtPssI6rLKitct5U36/KNdHRmt+8CIhiKmw87KnzTBzj1A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5gcfeq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 06:33:53 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49L6Xqjk000729;
	Mon, 21 Oct 2024 06:33:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5gcfeq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 06:33:52 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L5O8fs029401;
	Mon, 21 Oct 2024 06:33:51 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42crkjvmyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 06:33:51 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49L6XliM49938792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 06:33:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B96F2004B;
	Mon, 21 Oct 2024 06:33:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FB6A20040;
	Mon, 21 Oct 2024 06:33:46 +0000 (GMT)
Received: from [9.179.24.137] (unknown [9.179.24.137])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Oct 2024 06:33:46 +0000 (GMT)
Message-ID: <fbee219a-cc88-414b-8f5f-2cb3b4c9f470@linux.ibm.com>
Date: Mon, 21 Oct 2024 08:33:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] virtio-mem: s390 support
To: Heiko Carstens <hca@linux.ibm.com>, David Hildenbrand <david@redhat.com>
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
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-6-david@redhat.com>
 <20241014184824.10447-F-hca@linux.ibm.com>
 <ebce486f-71a0-4196-b52a-a61d0403e384@redhat.com>
 <20241015083750.7641-D-hca@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20241015083750.7641-D-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MZ1yrbyezdS4zll8wFGufHjjP4N0smer
X-Proofpoint-ORIG-GUID: 37ZgR9RiC9b_Gof1v4vav0KFZsJWLwy9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=853 clxscore=1011 suspectscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210043



Am 15.10.24 um 10:37 schrieb Heiko Carstens:
> On Mon, Oct 14, 2024 at 09:16:45PM +0200, David Hildenbrand wrote:
>> On 14.10.24 20:48, Heiko Carstens wrote:
>>> On Mon, Oct 14, 2024 at 04:46:17PM +0200, David Hildenbrand wrote:
>>>> to dump. Based on this, support for dumping virtio-mem memory can be
>>> Hm.. who will add this support? This looks like a showstopper to me.
>>
>> The cover letter is clearer on that: "One remaining work item is kdump
>> support for virtio-mem memory. This will be sent out separately once initial
>> support landed."
>>
>> I had a prototype, but need to spend some time to clean it up -- or find
>> someone to hand it over to clean it up.
>>
>> I have to chose wisely what I work on nowadays, and cannot spend that time
>> if the basic support won't get ACKed.
>>
>>> Who is supposed to debug crash dumps where memory parts are missing?
>>
>> For many production use cases it certainly needs to exist.
>>
>> But note that virtio-mem can be used with ZONE_MOVABLE, in which case mostly
>> only user data (e.g., pagecache,anon) ends up on hotplugged memory, that
>> would get excluded from makedumpfile in the default configs either way.
>>
>> It's not uncommon to let kdump support be added later (e.g., AMD SNP
>> variants).
> 
> I'll leave it up to kvm folks to decide if we need kdump support from
> the beginning or if we are good with the current implementation.

If David confirms that he has a plan for this, I am fine with a staged approach
for upstream.

