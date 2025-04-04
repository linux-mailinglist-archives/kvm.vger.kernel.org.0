Return-Path: <kvm+bounces-42649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F24BDA7BDFD
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 15:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DF753B9EC5
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 13:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2681F0E47;
	Fri,  4 Apr 2025 13:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SSVC65l/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031781EBFE2;
	Fri,  4 Apr 2025 13:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773795; cv=none; b=Jdy+gqUuYqb3Fi9/TjR0xm3g97UVRN5xr5WKg8+dwt0mlwPyhGvX96yPSa0Q8gJ432XOa0yi/3V0Izj87R9ntWhAcgZBK4vYoO2aGu4/CLsVdHNB2PrueAj1pPO5EN+EImB2MuDq+Db8SO6Yf2bCsrSxmUC9KfzXyWQ1Xk3C5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773795; c=relaxed/simple;
	bh=I3vcLmVLsFwbGKKNAa5gOJi+kc6XdJdjzcVHrIDFyk0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhJSGgCNgVbA9no7k1o8CTKFESJ4QWQpkAyF6QhYvd4Gm+IUoWNFyoeERxnDshg+594OFszrS/vbqeiP6AmhDtFIXt0Aca+8We3H14AgtBubTie1Fepw/NSJe+vioZkaUFu95g7HXNABLyTmc1fAgSXPXOF8GXYHgFUmmE+G6gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SSVC65l/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534DRRHE001973;
	Fri, 4 Apr 2025 13:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f3aNq9
	6GpV4DJKKwJmf2EkJ9N2yWAajx4pMWzECAfes=; b=SSVC65l/4jt7jgIpSX0vPx
	pqkvmeJ7uQyK6UmqAAR45VUX0xZDUCOf/FAHYwAnOM7jKxPGo+jQiTVhkIV4LPTU
	8xe9HbXrtXaq3gTFmIhZvb1vxsXZ3NVopg4s4Q+xDtokl3CXSFWNpCePoqDm1ZYT
	RY5LxgyqkKchOKEB4fF2gG7jp9Sqzvb00c9V8rajrdTbGS71piYaOjplwz9bcjkE
	rzR1Em1L6LtKCei8ZvQUFSh9bl2QgD4any2tKgCH1aQduKlYbik0TbBI5t0p92ky
	xTUjt5LJl+n21ve+OgpZb+JF9ZRe6LEVhSzzJBd8p20zkLqX+9ajDk5rUa6BVy+w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45t2qakjtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 13:36:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 534AmuPK003240;
	Fri, 4 Apr 2025 13:36:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45t2cdu5r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 13:36:25 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 534DaMZ513173160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 13:36:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53CF62004B;
	Fri,  4 Apr 2025 13:36:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9D7320043;
	Fri,  4 Apr 2025 13:36:21 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  4 Apr 2025 13:36:21 +0000 (GMT)
Date: Fri, 4 Apr 2025 15:36:20 +0200
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
Message-ID: <20250404153620.04d2df05.pasic@linux.ibm.com>
In-Reply-To: <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
References: <20250402203621.940090-1-david@redhat.com>
	<20250403161836.7fe9fea5.pasic@linux.ibm.com>
	<e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
	<20250404063619.0fa60a41.pasic@linux.ibm.com>
	<4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
	<d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
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
X-Proofpoint-ORIG-GUID: jjbHEg6GGT9HznXQ3JvmOavD-8W0juTq
X-Proofpoint-GUID: jjbHEg6GGT9HznXQ3JvmOavD-8W0juTq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_05,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504040094

On Fri, 4 Apr 2025 12:55:09 +0200
David Hildenbrand <david@redhat.com> wrote:

> For virito-balloon, we should probably do the following:
> 
>  From 38e340c2bb53c2a7cc7c675f5dfdd44ecf7701d9 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Fri, 4 Apr 2025 12:53:16 +0200
> Subject: [PATCH] virtio-balloon: Fix queue index assignment for
>   non-existing queues
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   device-types/balloon/description.tex | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/device-types/balloon/description.tex b/device-types/balloon/description.tex
> index a1d9603..a7396ff 100644
> --- a/device-types/balloon/description.tex
> +++ b/device-types/balloon/description.tex
> @@ -16,6 +16,21 @@ \subsection{Device ID}\label{sec:Device Types / Memory Balloon Device / Device I
>     5
>   
>   \subsection{Virtqueues}\label{sec:Device Types / Memory Balloon Device / Virtqueues}
> +
> +\begin{description}
> +\item[inflateq] Exists unconditionally.
> +\item[deflateq] Exists unconditionally.
> +\item[statsq] Only exists if VIRTIO_BALLOON_F_STATS_VQ is set.
> +\item[free_page_vq] Only exists if VIRTIO_BALLOON_F_FREE_PAGE_HINT is set.
> +\item[reporting_vq] Only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set.

s/is set/is negotiated/?

I think we should stick to "feature is offered" and "feature is
negotiated".

> +\end{description}
> +
> +\begin{note}
> +Virtqueue indexes are assigned sequentially for existing queues, starting
> +with index 0; consequently, if a virtqueue does not exist, it does not get
> +an index assigned. Assuming all virtqueues exist for a device, the indexes
> +are:
> +
>   \begin{description}
>   \item[0] inflateq
>   \item[1] deflateq
> @@ -23,12 +38,7 @@ \subsection{Virtqueues}\label{sec:Device Types / Memory Balloon Device / Virtque
>   \item[3] free_page_vq
>   \item[4] reporting_vq
>   \end{description}
> -
> -  statsq only exists if VIRTIO_BALLOON_F_STATS_VQ is set.
> -
> -  free_page_vq only exists if VIRTIO_BALLOON_F_FREE_PAGE_HINT is set.
> -
> -  reporting_vq only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set.
> +\end{note}
>   
>   \subsection{Feature bits}\label{sec:Device Types / Memory Balloon Device / Feature bits}
>   \begin{description}

Sounds good to me! But I'm still a little confused by the "holes". What
confuses me is that i can think of at least 2 distinct types of "holes":
1) Holes that can be filled later. The queue conceptually exists, but
   there is no need to back it with any resources for now because it is 
   dormant (it can be seen a hole in comparison to queues that need to
  materialize -- vring, notifiers, ...)
2) Holes that can not be filled without resetting the device: i.e. if
   certain features are not negotiated, then a queue X does not exist,
   but subsequent queues retain their index.

Can we have both kinds or was/will be 1) and/or 2) never a thing?

This patch would make sure that neither 1) nor 2) applies to
virtio-balloon, which is good. But we are talking about a
transport fix here, and I would like to eventually make sure
that the abstractions make sense.

That being said, I think we should proceed with this patch, because I
don't think Linux uses type 1) holes.

Regards,
Halil

