Return-Path: <kvm+bounces-28805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAF699D6E2
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 20:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A91E1C23595
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061F51CACFD;
	Mon, 14 Oct 2024 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b4XmhwEJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D274683;
	Mon, 14 Oct 2024 18:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728932236; cv=none; b=l6U9Ke8WlgYs3hpiNksQOJ5WdCIXGdtw0tEXLpoQWJqqAuf8dgPjvJPj6KtBjJl5R9ECC12cgk6Trj3Lvvs/xe48ONHWNVnR4skytQM0xQdb/BHIFiG143qyzpA4+skqWoEagCjJax+3MyfibV6USNU49aitTho5Bqyy1zmKLL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728932236; c=relaxed/simple;
	bh=fgr0i0rvV98CmIMqJYxJOVbmMJNJIhlNgjRfyq6A+4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbqxHpXq6ufjImlOjIimr0ixojpAvaYdLks88U8bkldDttyTgWa3hQ3fDLF4PbpoNPISDCo4Ch75OpWY3DioGtCvQIvOOrUTzH8EEetn35QMA8vLR201uIqTrhqE8JV5czPIB4HU64UZvjN0zIXNBl6CZlzO5DZUO3PxZK9Fy4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b4XmhwEJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHpttt016170;
	Mon, 14 Oct 2024 18:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=lqsWR+jAr90MdTD6bipNip5TTrR
	kZNsTNWK1ovh714w=; b=b4XmhwEJ8kZjtypCGp0cOsK6GQkjPMXqa4EzpZIs84d
	YOGBTXbn1W2WXMTpPReTFgrC7BeP9UmmiKBVpcY1P6f9Cykz30sStQ1Dc/F9BY9e
	YVM7X2n4afWsy4MYJZSRIA2LaSeJiz3GDOkllZCJQtQc6vx0sM/aHRdbAlt/Mktn
	Z0SuaGi7Kxq3pgF5SZuEWuDKpSkDS1XSD1p5U3PP3P9o0wosyUdhbS6l5vPIOeyi
	fWiImR2tF2RfFPzlooBztYRKnRvsUWiO+OdipYH9NvoqD2CBSROcH0kj893n4uyE
	XKAUPuz6f1Bxen++oKll3e9wILw36P4h5GE+JV5YZQg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42982qr7ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:57:07 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EIv6GJ020091;
	Mon, 14 Oct 2024 18:57:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42982qr7er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:57:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHdVwP027480;
	Mon, 14 Oct 2024 18:57:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txg63q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:57:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EIv2bP55050696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 18:57:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F30CA2004E;
	Mon, 14 Oct 2024 18:57:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03BE92004B;
	Mon, 14 Oct 2024 18:57:01 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 18:57:00 +0000 (GMT)
Date: Mon, 14 Oct 2024 20:56:59 +0200
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
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/7] virtio-mem: s390 support
Message-ID: <20241014185659.10447-H-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6uFDGy-zlz1QTPEIrQYEpX_XW_Pumpmi
X-Proofpoint-ORIG-GUID: Or6XZdCkJUWtzOmMfibubfT24pmJTuiG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140135

On Mon, Oct 14, 2024 at 04:46:12PM +0200, David Hildenbrand wrote:
> Let's finally add s390 support for virtio-mem; my last RFC was sent
> 4 years ago, and a lot changed in the meantime.
> 
> The latest QEMU series is available at [1], which contains some more
> details and a usage example on s390 (last patch).
> 
> There is not too much in here: The biggest part is querying a new diag(500)
> STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
> 
> The last two patches are not strictly required but certainly nice-to-have.
> 
> Note that -- in contrast to standby memory -- virtio-mem memory must be
> configured to be automatically onlined as soon as hotplugged. The easiest
> approach is using the "memhp_default_state=" kernel parameter or by using
> proper udev rules. More details can be found at [2].
> 
> I have reviving+upstreaming a systemd service to handle configuring
> that on my todo list, but for some reason I keep getting distracted ...
> 
> I tested various things, including:
>  * Various memory hotplug/hotunplug combinations
>  * Device hotplug/hotunplug
>  * /proc/iomem output
>  * reboot
>  * kexec
>  * kdump: make sure we don't hotplug memory
> 
> One remaining work item is kdump support for virtio-mem memory. This will
> be sent out separately once initial support landed.

Besides the open kdump question, which I think is quite important, how
is this supposed to go upstream?

This could go via s390, however in any case this needs reviews and/or
Acks from kvm folks.

