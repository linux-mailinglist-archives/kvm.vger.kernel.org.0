Return-Path: <kvm+bounces-28855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4672399E153
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C68991F236BB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577931D9A70;
	Tue, 15 Oct 2024 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JEjWhIpj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377601CF296;
	Tue, 15 Oct 2024 08:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728981485; cv=none; b=S1swl6tVtLpemCvTm0a1qFB7I4HesvcfkFS9Xk0E1iaR3A/x7P6TxCZmgOvyx7lMKEvqXGu9b9cpT8BkC0bmtnUOzd1G+fKaEFBLakvncNYIrOFnKG3cJe6kfwSgtkXeWh4uevF9mYPFQR0Zppx/zXep5MUGJWBfvAz4AdYHWnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728981485; c=relaxed/simple;
	bh=jKaAsxcZ4lli6nFjz4Ti9IlwPa+9AB62Liyvq0UwBkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jf3xAwNbHPMlF7inaW8DBFsIKxn/Esw4SHZINs6C3evbZ5C1d4c3wIy8fdhY2GkPCAJQxJVEiuYucAsPm5JPcEpucUgJEWjamayzmQbTTNEfPCH/MqKNRXdfH50u+1DPzcX9Nna5FIpjMcUYCu0KCoT4LO8tIVr5U1TDAvnvR/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JEjWhIpj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F6Ppvn026537;
	Tue, 15 Oct 2024 08:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QUa+46E8NUZzcXxa505gxyZiwH0Jg/
	Ul9dVsztozd6I=; b=JEjWhIpjVfTfi7z8OrTAhPneHnsuC4U6IitiIygejiksTc
	pDxJxkYqF0VMxrNOytzrqHQOOxZECextTJTQa1KSTnVHAPoqf0MU0tEsd+ote66H
	c3uLwvz8zqvnyw8/RxC7TnQ0qamZ+I1Tpsrcdzdq1nbr/yUYDZeRqjxct6Kf1TyM
	R1d1Rael0AvJFsk7ypTEsx/ODbSBI1aIN8nvmEk5nbxYY1K6UlZEF8cJdrmdCPXY
	5p1mHWG1mJ2cwB1nFjfPH+ruXHrajo0Hapgk+YPnyswWnSxnT8ra9ryZ/NP1QmDD
	jWV33tJc3zrLsmg3h+3iFvZaYiIsXF7NQ8WPs/Kg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429k3xrkwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:37:57 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F8burM018568;
	Tue, 15 Oct 2024 08:37:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429k3xrkwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:37:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F5aS24005951;
	Tue, 15 Oct 2024 08:37:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650tdx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:37:55 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F8bphN56623400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 08:37:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE97C20043;
	Tue, 15 Oct 2024 08:37:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F3AD20040;
	Tue, 15 Oct 2024 08:37:51 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 08:37:51 +0000 (GMT)
Date: Tue, 15 Oct 2024 10:37:50 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 5/7] virtio-mem: s390 support
Message-ID: <20241015083750.7641-D-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-6-david@redhat.com>
 <20241014184824.10447-F-hca@linux.ibm.com>
 <ebce486f-71a0-4196-b52a-a61d0403e384@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebce486f-71a0-4196-b52a-a61d0403e384@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EXXMZwwgVWyiaGSiPXsoCFFtmuGvYVXs
X-Proofpoint-ORIG-GUID: Nmz2DOBP5V42-CA2w3FaC3Dux5ZSF5pS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 mlxlogscore=418
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150056

On Mon, Oct 14, 2024 at 09:16:45PM +0200, David Hildenbrand wrote:
> On 14.10.24 20:48, Heiko Carstens wrote:
> > On Mon, Oct 14, 2024 at 04:46:17PM +0200, David Hildenbrand wrote:
> > > to dump. Based on this, support for dumping virtio-mem memory can be
> > Hm.. who will add this support? This looks like a showstopper to me.
> 
> The cover letter is clearer on that: "One remaining work item is kdump
> support for virtio-mem memory. This will be sent out separately once initial
> support landed."
> 
> I had a prototype, but need to spend some time to clean it up -- or find
> someone to hand it over to clean it up.
> 
> I have to chose wisely what I work on nowadays, and cannot spend that time
> if the basic support won't get ACKed.
> 
> > Who is supposed to debug crash dumps where memory parts are missing?
> 
> For many production use cases it certainly needs to exist.
> 
> But note that virtio-mem can be used with ZONE_MOVABLE, in which case mostly
> only user data (e.g., pagecache,anon) ends up on hotplugged memory, that
> would get excluded from makedumpfile in the default configs either way.
> 
> It's not uncommon to let kdump support be added later (e.g., AMD SNP
> variants).

I'll leave it up to kvm folks to decide if we need kdump support from
the beginning or if we are good with the current implementation.

