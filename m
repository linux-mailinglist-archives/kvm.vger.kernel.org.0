Return-Path: <kvm+bounces-28868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B9899E37C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 413EB1F24180
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2C91E570C;
	Tue, 15 Oct 2024 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="orD2fuzx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C671E379B;
	Tue, 15 Oct 2024 10:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728986951; cv=none; b=C2LxnlqpmtA6vk6ugvp20BdxvZYVaFKCYLQa5yypXRHx+YX0o3rkUTjK57VImdfPtzzXjYMUXF8uabxwaexItUriEf6V+7306FMXEG1zVRA5v5kLbPWGAYIsnW54LTjja20BITW9AXl1zKcH0xtMR2eApMjPPRSrZZllfZKz07o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728986951; c=relaxed/simple;
	bh=L/+YSZd9FgzSTjtlgoEb7AhHZrvE5ViY4redsR5s1EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WErFpEgnsFcu1WZKU7JX74CpBNqNSb4e57ApebGHXTddwfEU4z4ezbJPaz8VuWZXSu9TCSSkAjxy4uU4vfuCyBK1lupE5oYqXpv1MBQHve7PFQXNTcuF1iDP3XSdD0k//td36MFatXfC6uXhLZKWOGuwFd7OuKq9ftEmg55H/7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=orD2fuzx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8PIdt023808;
	Tue, 15 Oct 2024 10:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/c7LV/XQCFoM90nvgmsgvrUkllUDo6
	cElhrXfABkZfQ=; b=orD2fuzxADOT2+HxgEydnL3W+PkhEdGjS5UKKVau1xhD5b
	EgtbAK4cINCp6W7feBhvjPexGoQbNGSBMg4Niu20J3NYWfq4ti551CFDS9F7UUs4
	uJI6QQgPmfNYxb8ejTqzwUby7nEIfRJaG12732FzvJ9RkqL6t+fWS0kMANy5ss/E
	olzppJ2JbaqWLgxLdiG4guUDpoRWRYSpBmIjjHw6ahq69x6/xv08Q5rV4ekCr6fu
	jFK/7dSCrKf6xaML6LtYFhz9dxxBnfUoS7zOBhVRnoE4TfZ7PVFEckqULqo6Z3ej
	2iDVmL5pjdwfZBhIGkxCw/D4iKme8VVz3FkbS8iA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mv4rh6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 10:09:02 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49FA91wf019574;
	Tue, 15 Oct 2024 10:09:01 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mv4rh6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 10:09:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8hDOg005377;
	Tue, 15 Oct 2024 10:09:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285nj2w6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 10:09:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FA8uJs53608814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 10:08:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75FC52004B;
	Tue, 15 Oct 2024 10:08:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3088B20049;
	Tue, 15 Oct 2024 10:08:56 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 10:08:56 +0000 (GMT)
Date: Tue, 15 Oct 2024 12:08:54 +0200
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
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
Message-ID: <20241015100854.7641-J-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-2-david@redhat.com>
 <20241014182054.10447-D-hca@linux.ibm.com>
 <f93b2c89-821a-4da1-8953-73ccd129a074@redhat.com>
 <20241015083040.7641-C-hca@linux.ibm.com>
 <0c7e876f-5648-4a82-b809-ca48f778b4a6@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c7e876f-5648-4a82-b809-ca48f778b4a6@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B4FoBzXg4xRB3GzcXvcGiFpFwcYSCEoJ
X-Proofpoint-ORIG-GUID: ydJ8NcHofxE6nimFbJhOvYGvELg379sK
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=468
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150068

On Tue, Oct 15, 2024 at 10:41:21AM +0200, David Hildenbrand wrote:
> On 15.10.24 10:30, Heiko Carstens wrote:
> > On Mon, Oct 14, 2024 at 09:26:03PM +0200, David Hildenbrand wrote:
> > > On 14.10.24 20:20, Heiko Carstens wrote:
> > > > Looks like this could work. But the comment in smp.c above
> > > > dump_available() needs to be updated.
> > > 
> > > A right, I remember that there was some outdated documentation.

...

> My concern is that we'll now have
> 
> bool is_kdump_kernel(void)
> {
>        return oldmem_data.start && !is_ipl_type_dump();
> }
> 
> Which matches 3), but if 2) is also called "kdump", then should it actually
> be
> 
> bool is_kdump_kernel(void)
> {
>        return oldmem_data.start;
> }
> 
> ?
> 
> When I wrote that code I was rather convinced that the variant in this patch
> is the right thing to do.

Oh well, we simply of too many dump options. I'll let Alexander and
Mikhail better comment on this :)

Alexander, Mikhail, the discussion starts here, and we need a sane
is_kdump_kernel() for s390:
https://lore.kernel.org/all/20241014144622.876731-1-david@redhat.com/

