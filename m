Return-Path: <kvm+bounces-42585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31525A7A500
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 16:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E5721888CFB
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6522224EAB2;
	Thu,  3 Apr 2025 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GQ6VNzh8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FB424E016;
	Thu,  3 Apr 2025 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743689930; cv=none; b=GUxl68F9FLktwqmBCHxDlduo7QNCqIo9DDect2wdiT2cp1c/artmr38o/pEQKmXUQcUOvFkqxB9BmLzDZNsvojZ71U1EIXXRLhrCt6uZiKDG7IkVDwP3nYC2Az4qg61Ospi5B9pNl/ZrkZE2Z+0FEPxwjqaLlMNut5tqRPZVPPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743689930; c=relaxed/simple;
	bh=Iswj5llC+bCivl9I7vNMk/SGqfO4NmXyJ7I05pVoD6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LlxRgnouuB0sQZBUNm7YFs9H0Irp2SJPb6DF9drdBlvSdPsB3CpT21GOn9vGk4SvILAsU6C2xH3YewrOw722OnaxJeR+URHDY+l4TpZLxtNEDhlpwCI7KkA1aUrTFkAiZiPSlYp5qwuAaN1iUnfvjRgASWoJn7c3U7SQi7As+kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GQ6VNzh8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533E5HpB007071;
	Thu, 3 Apr 2025 14:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UdVFC3
	gMmR8A8vEKwuLjQ+oaRxh3zvSCFaxNtJgaW1o=; b=GQ6VNzh8vfeTp9lu0x6ShU
	whpfSP3lf6++B7Am22Epr/po/qLnx/RGoRcZb85QG9JKHoXGUoTIfGrUbi2bQnHF
	eXcjFeznSUYWvEZjhMJt9JQMCmzicDsA/84DrwtQHEq0/KwOT79gAWTR0Y//oxmB
	/gbFSUDsSNom/L92YX44ofu2RA232NpdOzyhdfjO+FqwlnJDiU3/KdBaeTd+y5ft
	WoO8cwTmgn9FXbhfX1w3eQCu01dhV0Se6DywqeWJGxp31tX/rPeaw8X9novgYNLq
	Bg2sdzM4U+3N9EcPkTC8pUU9EQwr6vst0GthStulX0+a3WsC6oF4uC4zqe/IosMg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45sjq9ts8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Apr 2025 14:18:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 533AOe9H009999;
	Thu, 3 Apr 2025 14:18:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45pv6p55p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Apr 2025 14:18:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 533EIbkq53149986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Apr 2025 14:18:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EB0B20074;
	Thu,  3 Apr 2025 14:18:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C6662006C;
	Thu,  3 Apr 2025 14:18:37 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Apr 2025 14:18:37 +0000 (GMT)
Date: Thu, 3 Apr 2025 16:18:36 +0200
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
Message-ID: <20250403161836.7fe9fea5.pasic@linux.ibm.com>
In-Reply-To: <20250402203621.940090-1-david@redhat.com>
References: <20250402203621.940090-1-david@redhat.com>
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
X-Proofpoint-GUID: XIIU7-lVPLDDOvh_qH_h0D0LfjkTeoHj
X-Proofpoint-ORIG-GUID: XIIU7-lVPLDDOvh_qH_h0D0LfjkTeoHj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1011 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504030064

On Wed,  2 Apr 2025 22:36:21 +0200
David Hildenbrand <david@redhat.com> wrote:

> If we finds a vq without a name in our input array in
> virtio_ccw_find_vqs(), we treat it as "non-existing" and set the vq pointer
> to NULL; we will not call virtio_ccw_setup_vq() to allocate/setup a vq.
> 
> Consequently, we create only a queue if it actually exists (name != NULL)
> and assign an incremental queue index to each such existing queue.

First and foremost: thank you for addressing this! I have to admit, I'm
still plagued by some cognitive dissonance here. Please bear with me.

For starters the commit message of a229989d975e ("virtio: don't
allocate vqs when names[i] = NULL") goes like this:
"""
    virtio: don't allocate vqs when names[i] = NULL
    
    Some vqs may not need to be allocated when their related feature bits
    are disabled. So callers may pass in such vqs with "names = NULL".
    Then we skip such vq allocations.
"""

In my reading it does not talk about "non-existent" queues, but queues
that do not need to be allocated. This could make sense for something
like virtio-net where controlq 2N is with N being max_virtqueue_pairs.

I guess for the guest it could make sense to not set up some of the
queues initially, but those, I guess would be perfectly existent queues
spec-wise and we would expect the index of controlq being 2N. And the
queues that don't get set up initially can get set up later. At least
this is my naive understanding at the moment.

Now apparently there is a different case where queues may or may not
exist, but we would, for some reason like to have the non-existent
queues in the array, because for an other set of features negotiated
those queues would actually exist and occupy and index. Frankly
I don't fully comprehend it at the moment, but I will have another look
at the code and at the spec.

So lookign at the spec for virtio-ballon I see:



5.5.2 Virtqueues

0
    inflateq 
1
    deflateq 
2
    statsq 
3
    free_page_vq 
4
    reporting_vq

statsq only exists if VIRTIO_BALLOON_F_STATS_VQ is set.

free_page_vq only exists if VIRTIO_BALLOON_F_FREE_PAGE_HINT is set.

reporting_vq only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set. 

Which is IMHO weird.  I used to think about the number in front of the
name as the virtqueue index. But based on this patch I'm wondering if
that is compatible with the approach of this patch.

What does for example mean if we have VIRTIO_BALLOON_F_STATS_VQ not
offered, VIRTIO_BALLOON_F_FREE_PAGE_HINT offered but not negotiated
and VIRTIO_BALLOON_F_PAGE_REPORTING negotiated.

One reading of the things is that statq is does not exist for sure,
free_page_vq is a little tricky because "is set" is not precise enough,
and reporting_vq exists for sure. And in your reading of the spec, if
I understood you correctly and we assume that free_page_vq does not
exist, it has index 2. But I from the top of my head, I don't know why
interpreting the spec like it reporting_vq has index 4 and indexes 2
and 3 are not mapped to existing-queues would be considered wrong.

And even if we do want reportig_vq to have index 2, the virtio-balloon
code could still give us an array where reportig_vq is at index 2. Why
not?

Sorry this ended up being a very long rant. the bottom line is that, I
lack conceptual clarity on where the problem exactly is and how it needs
to be addressed. I would like to understand this properly before moving
forward.

[..]
> 
> There was recently a discussion [1] whether the "holes" should be
> treated differently again, effectively assigning also non-existing
> queues a queue index: that should also fix the issue, but requires other
> workarounds to not break existing setups.
> 

Sorry I have to have a look at that discussion. Maybe it will answer
some my questions.

> Let's fix it without affecting existing setups for now by properly ignoring
> the non-existing queues, so the indicator bits will match the queue
> indexes.

Just one question. My understanding is that the crux is that Linux
and QEMU (or the driver and the device) disagree at which index
reporting_vq is actually sitting. Is that right?

Regards,
Halil

