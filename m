Return-Path: <kvm+bounces-42619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A908EA7B6BD
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 06:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AF133B8174
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 04:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8787615382E;
	Fri,  4 Apr 2025 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fsLZ5Bc8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F0C3C38;
	Fri,  4 Apr 2025 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743739342; cv=none; b=INFICToOpgDhD1Rja9bceuFigmeSCfhmbo9IIpaqlpQ1am1wprlktgeEK+r3klHyl/8d3qPEjx3ZzmZvUloJA42JAhjueN+5dLcJCfd1Od9djB4U9AvQG7lE35KcwsAnz+khDFZyjN2EexW8ZynRkZanKGhruVALueLH4TZ26s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743739342; c=relaxed/simple;
	bh=YvtjewQEpVtgIn6mwzy8Dw47VaTv42DwrZuOQFX1KeE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SAU3wBSyx3Z4keTCsRWpdjz2U+hW8DD/rc6FyAAzFiwJfnHur9elisahSMxDncmi+215teh7JwQltDsDpgw/IfkLHCxRzZbsHLA59g8VaeukCL1Ls9gv8ViXyB/zn7rzLPQEbPCvQEMQuVID9uT9EQ+IimkUquY0lVsBNqt8Xz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fsLZ5Bc8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5341hNnV017801;
	Fri, 4 Apr 2025 04:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NqI6Ve
	W0KeMnDUyRqzQsLFcFou5YGNJcmhyFenC6qC0=; b=fsLZ5Bc8iSTg/UC9a+a8q6
	vJ//s8KpFfK6qegZli0ddaZqwOpSi4t1zhZBFA3EVetIq7mTdVlZw/hKW1PStMaf
	fR8h6IiVoVTrqP/tFeH6dlY2mRtBADW60gOcscQIwHkJJszmftNHsFiSEFl5ROqn
	eSF/9/G9jB3WcUpvq/HyQdubUjdOEM35QeGQGi6kNyc6HRhOOj4+A3S2igFUtNku
	KxxdD/2Z3IDAw1LyrDdH2C50MiIkiAjnTSDZVzePyvNz94N1lBb9TjI6L6c7uYXJ
	z7QumGRyCrsYUNsVf+CjvMSgmCQUzn4UqGXz2654pBMrTWCyRko+reXr5IvlEQaQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45t2qb142g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 04:02:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5341v5IZ001911;
	Fri, 4 Apr 2025 04:02:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45t2ch1910-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 04:02:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 534427IS55771406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 04:02:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76C642004B;
	Fri,  4 Apr 2025 04:02:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B12F20040;
	Fri,  4 Apr 2025 04:02:06 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.55.30])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  4 Apr 2025 04:02:06 +0000 (GMT)
Date: Fri, 4 Apr 2025 06:02:04 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
        Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth
 <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Wei Wang
 <wei.w.wang@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250404060204.04db301d.pasic@linux.ibm.com>
In-Reply-To: <20250403103127-mutt-send-email-mst@kernel.org>
References: <20250402203621.940090-1-david@redhat.com>
	<20250403161836.7fe9fea5.pasic@linux.ibm.com>
	<20250403103127-mutt-send-email-mst@kernel.org>
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
X-Proofpoint-ORIG-GUID: gISA65PQoz6Bvv7M61Dig1bJNQBipG94
X-Proofpoint-GUID: gISA65PQoz6Bvv7M61Dig1bJNQBipG94
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_01,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=831 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2504040025

On Thu, 3 Apr 2025 10:35:33 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Apr 03, 2025 at 04:18:36PM +0200, Halil Pasic wrote:
> > On Wed,  2 Apr 2025 22:36:21 +0200
[..]
> > 
> > 5.5.2 Virtqueues
> > 
> > 0
> >     inflateq 
> > 1
> >     deflateq 
> > 2
> >     statsq 
> > 3
> >     free_page_vq 
> > 4
> >     reporting_vq  
> 
> Indeed. Unfortunately, no one at all implemented this properly as
> per spec :(.
> 
> Balloon is the worst offender here but other devices are broken
> too in some configurations.
> 
> 
> Given it has been like this for many years I'm inclined in this
> instance to fix the spec not the implementations.
> 

I understand! For me at least knowing if we are going to change the
spec or the implementations is pretty important. It would probably
make sense to spin a patch for the spec, just for the unlikely case that
somebody did end up implementing this by the spec and wants to protest.

I think, a consequence of this design is that all queues need to be
created and allocated at initialization time.

I mean in the spec we have something like 
"""
5.1.6.5.6.1 Driver Requirements: Automatic receive steering in multiqueue mode
The driver MUST configure the virtqueues before enabling them with the VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command. 
"""

For example one could want to hotplug 2 more vCPUs and still have a
queue-pair per cpu (and a controlq). Those 2 extra queue-pairs could
in theory be allocated on-demand instead of having to allocate memory
for the rings for all the queues corresponding to the maxed out setup.
I've had a look at the Linux virtio-net and it does allocate all the
queues up front.

Also with this design, I believe we would effectively prohibit "holes".
Now if holes are prohibited, IMHO it does not make a whole lot of
sense for the virtio_find_vqs() to support holes. Because the holes
and a fair amount of complexity. Of course that would make sense as a
cleanup on top.

Regards,
Halil

