Return-Path: <kvm+bounces-42652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3DCA7BE9C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4C98189BE9C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 14:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FAF1F2C5B;
	Fri,  4 Apr 2025 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GhGmXufM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73BCD27E;
	Fri,  4 Apr 2025 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743775241; cv=none; b=AnxiqdVHYDHdKfEDFBcSy2cnzxIf5eeqr/oAyRxMCYHpMNZDa8J6zApZkgXb25iHYSYEK8ZWlG4I3mNdkozOmhiVzb5TxT4lKeHlNM4GoKcMKqhPaMpNSFnqgYZR7nzcBZXfWh9NU7UpdM0I+UZ0QZYC/Sj0f7NwEwQEaa1dP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743775241; c=relaxed/simple;
	bh=9/SEMBOZxsAvotN2MKqo8m8V8upKHV9GlI2jswR+Q0E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7WKPod6FvmRK2gQR3RcCkpr2Zhk4O/qFHkOis6sUHr2QEyIzVeF/pyMmTDZS1dvbwU376hOTMl6wFdvtNyazbiCWZbXqXWmUvh1RNrtdznL+3BdH1ZW3MtMYGqs4cdEKFxAc8W4UEuHybbR8IkfBQlekwYGQJG+cSETlzVhjQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GhGmXufM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534Coit4007039;
	Fri, 4 Apr 2025 14:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wAawdn
	WjwVjA4C1L7fy+HM31JjiouPF2X2FNhOABGsY=; b=GhGmXufMH0t8f5D/1QUoDe
	ggEuNiqKYizEBy4qbM0kE07lf2JBR87rZ003uNt0JIaTPlqJJzwuILHGMpNmkl+n
	mbKm3ycTDuIIS5UGZEY4EqQr9xLZs1aVjrsWbZsvcpsOUg8hRGYfsAQfEwIaGDm7
	9fN3A4QgavDdTuSg7de3wgogQjeT0bbTWc6Tbma+G+8oEJpo4dtXxsA4HtwpVyz9
	Zcv0KsxdzJvEvDdsa5OFluSLnnedU7n/4+i9EVf90K73HSSqanJRKNo3LUUoD0+y
	iETaJp8exhIYbNCjk6XSXIO9HMvP7EHJ4bC4hvqS7VAQxrltkIKybSyXGZsPwnoA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45t356bmfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 14:00:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 534B7vTo021240;
	Fri, 4 Apr 2025 14:00:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45t2e7b82j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 14:00:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 534E0RtN25690792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 14:00:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E4CD20040;
	Fri,  4 Apr 2025 14:00:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C91892004B;
	Fri,  4 Apr 2025 14:00:26 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  4 Apr 2025 14:00:26 +0000 (GMT)
Date: Fri, 4 Apr 2025 16:00:25 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        Chandra Merla
 <cmerla@redhat.com>, Stable@vger.kernel.org,
        Cornelia Huck
 <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Eric Farman
 <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wei Wang
 <wei.w.wang@intel.com>, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250404160025.3ab56f60.pasic@linux.ibm.com>
In-Reply-To: <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
References: <20250402203621.940090-1-david@redhat.com>
	<20250403161836.7fe9fea5.pasic@linux.ibm.com>
	<e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
	<20250404063619.0fa60a41.pasic@linux.ibm.com>
	<4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
	<d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
	<20250404153620.04d2df05.pasic@linux.ibm.com>
	<d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JnDzwSSKtyNvcNoZEbvl6f2JDRGMxQ4D
X-Proofpoint-ORIG-GUID: JnDzwSSKtyNvcNoZEbvl6f2JDRGMxQ4D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_06,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0 spamscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504040097

On Fri, 4 Apr 2025 15:48:49 +0200
David Hildenbrand <david@redhat.com> wrote:

> > Sounds good to me! But I'm still a little confused by the "holes".
> > What confuses me is that i can think of at least 2 distinct types of
> > "holes": 1) Holes that can be filled later. The queue conceptually
> > exists, but there is no need to back it with any resources for now
> > because it is dormant (it can be seen a hole in comparison to queues
> > that need to materialize -- vring, notifiers, ...)
> > 2) Holes that can not be filled without resetting the device: i.e. if
> >     certain features are not negotiated, then a queue X does not
> > exist, but subsequent queues retain their index.  
> 
> I think it is not about "negotiated", that might be the wrong
> terminology.
> 
> E.g., in QEMU virtio_balloon_device_realize() we define the virtqueues 
> (virtio_add_queue()) if virtio_has_feature(s->host_features).
> 
> That is, it's independent of a feature negotiation (IIUC), it's static 
> for the device --  "host_features"
> 
> 
> Is that really "negotiated" or is it "the device offers the feature X"
> ?

It is offered. And this is precisely why I'm so keen on having a precise
wording here.

Usually for compatibility one needs negotiated. Because the feature
negotiation is mostly about compatibility. I.e. the driver should be
able to say, hey I don't know about that feature, and get compatible
behavior. If for example VIRTIO_BALLOON_F_FREE_PAGE_HINT and
VIRTIO_BALLOON_F_PAGE_REPORTING are both offered but only
VIRTIO_BALLOON_F_PAGE_REPORTING is negotiated. That would make reporting_vq
jump to +1 compared to the case where VIRTIO_BALLOON_F_FREE_PAGE_HINT is
not offered. Which is IMHO no good, because for the features that the
driver is going to reject in most of the cases it should not matter if
it was offered or not.

@MST: Please correct me if I'm wrong!

Regards,
Halil

