Return-Path: <kvm+bounces-30206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CCB9B800F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7FEB1F22411
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1161BDAAF;
	Thu, 31 Oct 2024 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gcEJKgEM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602C1BBBEA;
	Thu, 31 Oct 2024 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730392043; cv=none; b=OntE6zcxOHI/UR+qYM2brRk3xAG7ypV7KEkn7QoM3oA2T9oIYaIJkb97w5oHvxSnHUPkFJwldIYVQTpTspBhCH6WVw+g1jrumPVRouSuS7dkkU4UVOTkf685NEob4lkCZ2nRf2SRhOe/WapPpG0VgYv3Uq01Kt9betJ4F4siKmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730392043; c=relaxed/simple;
	bh=iH150H7FJWPWLYdUaAdEfQ/13mpK7ahZMpkRQ1FD1a8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OWBlgwzYyk2xKO7qASaXG8NdPjw9hBmgDwcqUlpje8wAAPgAnLDxIe3Se0z2YcTKu+NhqtfKcMupBsGXnAXa+OCsuEskCMbx30GWY0ovTW32/+Rzb44iUR4GetwFBhDdKAMni9Aw32DZzbcsADPsn9B5ghurWqCDKQUf1Jefb2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gcEJKgEM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49VFvV8u013288;
	Thu, 31 Oct 2024 16:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zjAryE
	KOETloLGYkEAicJv4Ye9LzgIY+dPDahJh00aE=; b=gcEJKgEMejrm5iqP0v7tYM
	BWMvCeiJg5ESHTTh2J2QG7m9dmvuUyn4rtC5N0pXMc8B0ARkcqjECWrRxRkuVT/H
	qJKKaYspyo0hpdOBhygBs8F98X1nXJ4bvEEk/qK1I5mQx9XwCj8jzr94eIaeoZEl
	db7dilRan6XoCnh1GKH5HjcndQAeDMcOutFK6gyDhb137IMwJEcDavqhKZrwxiNM
	IOjZ0RVLEGwzF2RwK5i2Ye6eAmV08a7y14fr5g4J3XHCkXf+LDgsjKk+USXEP+Ib
	oVHWQIpybx4dwom7lkX00oRgiqMXuEC57UoxFbv3c5FAz3+nBGZhTtC3dD8PPoqg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42kkbn6vt0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 16:27:11 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49VGRAee010519;
	Thu, 31 Oct 2024 16:27:10 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42kkbn6vst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 16:27:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VFYgsw015899;
	Thu, 31 Oct 2024 16:27:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hdf1n9xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 16:27:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VGR66Q33948176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 16:27:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F93C2004B;
	Thu, 31 Oct 2024 16:27:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD43120040;
	Thu, 31 Oct 2024 16:27:05 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.155.203.167])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 31 Oct 2024 16:27:05 +0000 (GMT)
Date: Thu, 31 Oct 2024 17:27:04 +0100
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
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
        Eric Farman <farman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 0/7] virtio-mem: s390 support
Message-ID: <ZyOv2E-WEcppbf3G@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20241025141453.1210600-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KkOr9GvzLSxQCyUeFHljQwa7fRHX3lDZ
X-Proofpoint-GUID: YSSxnDKxiBsunEDZsaYs1a7k8GlH0CKE
Content-Transfer-Encoding: 8bit
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310121

On Fri, Oct 25, 2024 at 04:14:45PM +0200, David Hildenbrand wrote:
> Let's finally add s390 support for virtio-mem; my last RFC was sent
> 4 years ago, and a lot changed in the meantime.
> 
> The latest QEMU series is available at [1], which contains some more
> details and a usage example on s390 (last patch).
> 
> There is not too much in here: The biggest part is querying a new diag(500)
> STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
> 
> The last three patches are not strictly required but certainly nice-to-have.
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
>  * kdump: make sure we properly enter the "kdump mode" in the virtio-mem
>    driver
> 
> kdump support for virtio-mem memory on s390 will be sent out separately.
> 
> v2 -> v3
> * "s390/kdump: make is_kdump_kernel() consistently return "true" in kdump
>    environments only"
>  -> Sent out separately [3]
> * "s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM memory
>    devices"
>  -> No query function for diag500 for now.
>  -> Update comment above setup_ident_map_size().
>  -> Optimize/rewrite diag500_storage_limit() [Heiko]
>  -> Change handling in detect_physmem_online_ranges [Alexander]
>  -> Improve documentation.
> * "s390/sparsemem: provide memory_add_physaddr_to_nid() with CONFIG_NUMA"
>  -> Added after testing on systems with CONFIG_NUMA=y
> 
> v1 -> v2:
> * Document the new diag500 subfunction
> * Use "s390" instead of "s390x" consistently
> 
> [1] https://lkml.kernel.org/r/20241008105455.2302628-1-david@redhat.com
> [2] https://virtio-mem.gitlab.io/user-guide/user-guide-linux.html
> [3] https://lkml.kernel.org/r/20241023090651.1115507-1-david@redhat.com
> 
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: "Eugenio P?rez" <eperezma@redhat.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> 
> David Hildenbrand (7):
>   Documentation: s390-diag.rst: make diag500 a generic KVM hypercall
>   Documentation: s390-diag.rst: document diag500(STORAGE LIMIT)
>     subfunction
>   s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM
>     memory devices
>   virtio-mem: s390 support
>   lib/Kconfig.debug: default STRICT_DEVMEM to "y" on s390
>   s390/sparsemem: reduce section size to 128 MiB
>   s390/sparsemem: provide memory_add_physaddr_to_nid() with CONFIG_NUMA
> 
>  Documentation/virt/kvm/s390/s390-diag.rst | 35 +++++++++++++----
>  arch/s390/boot/physmem_info.c             | 47 ++++++++++++++++++++++-
>  arch/s390/boot/startup.c                  |  7 +++-
>  arch/s390/include/asm/physmem_info.h      |  3 ++
>  arch/s390/include/asm/sparsemem.h         | 10 ++++-
>  drivers/virtio/Kconfig                    | 12 +++---
>  lib/Kconfig.debug                         |  2 +-
>  7 files changed, 98 insertions(+), 18 deletions(-)
> 
> 
> base-commit: ae90f6a6170d7a7a1aa4fddf664fbd093e3023bc
> -- 
> 2.46.1
> 

Tested successfully various memory hotplug operations on lpar.

Tested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>

