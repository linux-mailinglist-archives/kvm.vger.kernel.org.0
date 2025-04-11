Return-Path: <kvm+bounces-43159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25295A85DC1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 14:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06A179A21C9
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8E92367D0;
	Fri, 11 Apr 2025 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NV4jkFtV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6BE2367A2;
	Fri, 11 Apr 2025 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744375658; cv=none; b=mWrc7xAXoSDg2NcwqSbL+D2Uv7I6Mu2QSOlz4mNndbjJD6GYo7BqFQMv65HmrT2pJ/x0U4g9EvJ/KdrML/83iNeuZI4roSx0HiBWhqaufET31kumY33dh6zBaVgzcff+Rae6/rkIZZUYEOrVWQdqoACwEE9YU0d4oTLjbkGWA8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744375658; c=relaxed/simple;
	bh=yEXSM0GUEEbC1EoQQ2NsENJB2K834/66CU5+MxF3xnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iEmwPXyVHtCmxWYAW3q2OzPS36E/R5rEJCrcf+wTwdIde71RidusccgQQEUSmofmONa1cQk4tHIS1XxBiKwCwF1EOU/1LAp4z0k4d5rqT3qh2SIdHEhzyFklEGr8CRJDUGi7CKXp4u2GejFLM3cF/Eqpvy2fcjakmWt774mYT9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NV4jkFtV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53B67S5t029160;
	Fri, 11 Apr 2025 12:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=elmg/s
	bueavbN5pHa2hAlrKAi+l5t4tQL/Ymj5aLTmU=; b=NV4jkFtVGO759WjFnqDC3f
	BSrYh4byJiIimvAhsAX+xM90M1ca5fQR3+BtUFVj/q2NM1W4IUx2k6TaR74kNfsQ
	NN8L9+rIQLZLv4HNURVcmdI6XzmhxMxodWBfvNQxyLRKNeQLPFJHO/c/btx5zDGi
	oj2L3bb+dNsUq9D1SgRNtX71ibPkj/2MGMB01/5346z0SC/byOTH7te8G0JSOkFj
	QKpS+pLMotP5+QJ5MRIK4Hz4NmrQxizKy9RhoRkJHknDUNpZOzlhtvml76vQ40jy
	zTeNhMFDx5cqPbrDnReFTT1rj7oQOLMfNUebrK1/hvnLQFle93hp9mG+L9kPqJxg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45xj5xmj39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 12:47:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53B9OuEc025546;
	Fri, 11 Apr 2025 12:47:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45ugbmaxvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 12:47:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BClQBr14156088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 12:47:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31E6A2004B;
	Fri, 11 Apr 2025 12:47:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6ECA820043;
	Fri, 11 Apr 2025 12:47:25 +0000 (GMT)
Received: from [9.171.62.213] (unknown [9.171.62.213])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Apr 2025 12:47:25 +0000 (GMT)
Message-ID: <d2806f87-05e1-4bf4-b9b9-21f35c419cf0@linux.ibm.com>
Date: Fri, 11 Apr 2025 14:47:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: Heiko Carstens <hca@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
        Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250402203621.940090-1-david@redhat.com>
 <065d46ba-83c1-473a-9cbe-d5388237d1ea@redhat.com>
 <a6f667b2-ef7d-4636-ba3c-cf4afe8ff6c3@linux.ibm.com>
 <20250411124242.123863D16-hca@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250411124242.123863D16-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a5lN-y0hY8Qb0l291hvTgndCFPPa854X
X-Proofpoint-ORIG-GUID: a5lN-y0hY8Qb0l291hvTgndCFPPa854X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 mlxlogscore=919 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504110080


Am 11.04.25 um 14:42 schrieb Heiko Carstens:
> On Fri, Apr 11, 2025 at 01:11:55PM +0200, Christian Borntraeger wrote:
>> Am 10.04.25 um 20:44 schrieb David Hildenbrand:
>> [...]
>>>> ---
>>>
>>> So, given that
>>>
>>> (a) people are actively running into this
>>> (b) we'll have to backport this quite a lot
>>> (c) the spec issue is not a s390x-only issue
>>> (d) it's still unclear how to best deal with the spec issue
>>>
>>> I suggest getting this fix here upstream asap. It will neither making sorting out the spec issue easier nor harder :)
>>>
>>> I can spot it in the s390 fixes tree already.
>>
>> Makes sense to me. MST, ok with you to send via s390 tree?
> 
> Well, it is already part of a pull request:
> https://lore.kernel.org/r/20250411100301.123863C11-hca@linux.ibm.com/

Oh, I missed that.
> 
> ...and contains all the Acks that were given in this thread.

Thanks.

