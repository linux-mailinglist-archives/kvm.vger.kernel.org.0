Return-Path: <kvm+bounces-30207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 242619B8086
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D43E7287C32
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9A81BD027;
	Thu, 31 Oct 2024 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Rjcp0NH2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F093313AA2E;
	Thu, 31 Oct 2024 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730393257; cv=none; b=FrpoYcP5UnWs6V0hw/RBaHp1ouk6cAkMvoHzUlj3AMlyF0EeSlTYysWn0AOrDXpzcNJvnzziZDMOPNU9QRyjarNDzg/e5gMhsKrWbPR60a5ZDnS2Eww/aj77Nck2QKtE3NBX3ADVtNxXE51EZqmf3NBXzQV52SvzHWCRsbUw3KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730393257; c=relaxed/simple;
	bh=dqimpLyUtuEISJ7hDkyO9aLEu9TTudJ6z9SNLmUWMJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QwnTimZ77znwOgGmPIa6jh+f7GjEXXD+09JboSAevzjvSVWiSGxeSWFuIMlXL/rM4Wb9s7Q1CssSMWfwI5YaZ8rSwU+KiCn2dxMh8XmzUI0opLk9XPUgFdFS7koM92mO1vUzk2qPa9eSXN+yXs736z51nbLZhPaUJcN4iUYqIww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Rjcp0NH2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V6u5X5011265;
	Thu, 31 Oct 2024 16:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iDQbGS
	thL9NIBCmet6Nza+qWa9NMXVWwPp9kcHEfhLk=; b=Rjcp0NH2fzwrJWR8xuvOIs
	FVQp10VeuVHDRzvzjhG7IjQ8lq6onIE8fiyXxRhjdbxdd5C8nsL9RBwE7k9Upe27
	uSBIafZtlRpKTGj545v0Na3QyiMwBuPH846sdBiyfnKCu6JMl9EFdO3RHb3Vdhd1
	UAunTUpprTMh6Nw4XDjmQe1YtxxpozA5mYNT9835rzZlJ03ovuDvS5TlORx0/lUC
	TnQsaqLYsd7ZlQzT2Mk3/TH670Pet4KT3HWmxD2IptoGZ6yzoQhQaDl2UI9pXaCB
	3FfXRSNYQcs4JwOJsvEzanDGMVIFei0Kd/+gPzvnQIazHhxlx2x56q+wExEPWAsg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42m52cahwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 16:47:24 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49VGhumr006415;
	Thu, 31 Oct 2024 16:47:23 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42m52cahwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 16:47:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VDB918028275;
	Thu, 31 Oct 2024 16:47:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hb4y5u61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 16:47:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VGlI0158393008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 16:47:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 756ED20043;
	Thu, 31 Oct 2024 16:47:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 181C420040;
	Thu, 31 Oct 2024 16:47:18 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.155.203.167])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 31 Oct 2024 16:47:18 +0000 (GMT)
Date: Thu, 31 Oct 2024 17:47:16 +0100
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
Message-ID: <ZyO0lPkLPGnpDKrr@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <ZyOv2E-WEcppbf3G@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ZyOv2E-WEcppbf3G@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2fYb0_1hUdsilMPefDeXzatZ_u7SIlxn
X-Proofpoint-ORIG-GUID: EE5zUcBVCv3XTHcsLGWjfGYsKUGxvYhL
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410310125

On Thu, Oct 31, 2024 at 05:27:06PM +0100, Sumanth Korikkar wrote:
> On Fri, Oct 25, 2024 at 04:14:45PM +0200, David Hildenbrand wrote:
> > Let's finally add s390 support for virtio-mem; my last RFC was sent
> > 4 years ago, and a lot changed in the meantime.
> > 
> > The latest QEMU series is available at [1], which contains some more
> > details and a usage example on s390 (last patch).
> > 
> > There is not too much in here: The biggest part is querying a new diag(500)
> > STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".
> > 
> > The last three patches are not strictly required but certainly nice-to-have.
> > 
> > Note that -- in contrast to standby memory -- virtio-mem memory must be
> > configured to be automatically onlined as soon as hotplugged. The easiest
> > approach is using the "memhp_default_state=" kernel parameter or by using
> > proper udev rules. More details can be found at [2].
> > 
> > I have reviving+upstreaming a systemd service to handle configuring
> > that on my todo list, but for some reason I keep getting distracted ...
> > 
> > I tested various things, including:
> >  * Various memory hotplug/hotunplug combinations
> >  * Device hotplug/hotunplug
> >  * /proc/iomem output
> >  * reboot
> >  * kexec
> >  * kdump: make sure we properly enter the "kdump mode" in the virtio-mem
> >    driver
> > 
> > kdump support for virtio-mem memory on s390 will be sent out separately.
> > 
> > v2 -> v3
> > * "s390/kdump: make is_kdump_kernel() consistently return "true" in kdump
> >    environments only"
> >  -> Sent out separately [3]
> > * "s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM memory
> >    devices"
> >  -> No query function for diag500 for now.
> >  -> Update comment above setup_ident_map_size().
> >  -> Optimize/rewrite diag500_storage_limit() [Heiko]
> >  -> Change handling in detect_physmem_online_ranges [Alexander]
> >  -> Improve documentation.
> > * "s390/sparsemem: provide memory_add_physaddr_to_nid() with CONFIG_NUMA"
> >  -> Added after testing on systems with CONFIG_NUMA=y
> > 
> > v1 -> v2:
> > * Document the new diag500 subfunction
> > * Use "s390" instead of "s390x" consistently
> > 
> > [1] https://lkml.kernel.org/r/20241008105455.2302628-1-david@redhat.com
> > [2] https://virtio-mem.gitlab.io/user-guide/user-guide-linux.html
> > [3] https://lkml.kernel.org/r/20241023090651.1115507-1-david@redhat.com
> > 
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Cc: Sven Schnelle <svens@linux.ibm.com>
> > Cc: Thomas Huth <thuth@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: Janosch Frank <frankja@linux.ibm.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Cc: "Eugenio P?rez" <eperezma@redhat.com>
> > Cc: Eric Farman <farman@linux.ibm.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > 
> > David Hildenbrand (7):
> >   Documentation: s390-diag.rst: make diag500 a generic KVM hypercall
> >   Documentation: s390-diag.rst: document diag500(STORAGE LIMIT)
> >     subfunction
> >   s390/physmem_info: query diag500(STORAGE LIMIT) to support QEMU/KVM
> >     memory devices
> >   virtio-mem: s390 support
> >   lib/Kconfig.debug: default STRICT_DEVMEM to "y" on s390
> >   s390/sparsemem: reduce section size to 128 MiB
> >   s390/sparsemem: provide memory_add_physaddr_to_nid() with CONFIG_NUMA
> > 
> >  Documentation/virt/kvm/s390/s390-diag.rst | 35 +++++++++++++----
> >  arch/s390/boot/physmem_info.c             | 47 ++++++++++++++++++++++-
> >  arch/s390/boot/startup.c                  |  7 +++-
> >  arch/s390/include/asm/physmem_info.h      |  3 ++
> >  arch/s390/include/asm/sparsemem.h         | 10 ++++-
> >  drivers/virtio/Kconfig                    | 12 +++---
> >  lib/Kconfig.debug                         |  2 +-
> >  7 files changed, 98 insertions(+), 18 deletions(-)
> > 
> > 
> > base-commit: ae90f6a6170d7a7a1aa4fddf664fbd093e3023bc
> > -- 
> > 2.46.1
> > 
> 
> Tested successfully various memory hotplug operations on lpar.
> 
Just to be more precise, tested memory hotplug/hotunplug combinations +
Device hotplug/hotunplug operations on guest.

> Tested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>

