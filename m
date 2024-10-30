Return-Path: <kvm+bounces-30031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F529B6612
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4501E1C211BB
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 14:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF29C1F12E0;
	Wed, 30 Oct 2024 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ojzq15pw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F1C1F942B;
	Wed, 30 Oct 2024 14:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730298766; cv=none; b=elqm7JfBQE333mFJOke2hbMltSjndq7wmEVMggAZovLVFZm22X6KvmxK4RfxFgkI0brzCIvwWkKOF7a3UEgxHoF1agAM+5jGLgzFQDaLQHriEv0ljfaMZIV+V7i2x1Mt2CFLX5Lc2gFFEumXfROj0sHySJDGc8JXiWOO3e4izjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730298766; c=relaxed/simple;
	bh=cn2teZpK3OPgToY7WNAOAX7QIfO6Mj7lweEWlJT0Wjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQEZb/L1kl7f5E6GzVJy+xf2ZK3wqRkLAZdgkwSgT6veIKtsZBrIXZaY2e4XOTtzqmqLFPvRSzvWvGccSVoDtPwcK2pyb9OZ0dvOXLufOnhA31lYIf4HQNwQmUvFJ6NJaQm0Q6HLrCLwpJzpf0OtE8VZPM+dqDVj9IuCRqvaAdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ojzq15pw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDwEwE012371;
	Wed, 30 Oct 2024 14:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=vmMkYxLTIEYmUUGwLeUXCP8MhWVjgD
	ZL4z98/WCvP3Q=; b=ojzq15pwZXZvaEtljHFqGLIRelwP7RfBZEGtZoP3r6Fb0m
	ms7uhp/eaWQ48jSnbPgZ0IDa7YVomELf2fXsnKL38EQTUAxtJz/1qkRzUWZVgmVz
	v9//JNA4RF9ZvNsj/Iazawrs+7KFF8d2QwcbjjrA1CIPgKTqGxNkzj0dQYMadD/B
	K9RSnB9YTny5ufxnDuRyrnxAvnIjqCtWQg5EweQ8DH6yswgKKZHjk3rTsO+Y4Kzl
	brsVnwjEn9Se0vogWrvhyD9GkAS8p/9zR387YvhHxJsWmp4BIkiiJBThzIkp5Ysc
	802BXMMtzweFZIw8jCVLKhtjBhLADvEiKESK0kag==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jyhbpbey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 14:32:33 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49UEWWXa001457;
	Wed, 30 Oct 2024 14:32:32 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jyhbpbet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 14:32:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UC3uHN013616;
	Wed, 30 Oct 2024 14:32:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hbrn0dmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 14:32:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UEWRWV22020408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 14:32:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E080820040;
	Wed, 30 Oct 2024 14:32:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CF5E20043;
	Wed, 30 Oct 2024 14:32:27 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 14:32:27 +0000 (GMT)
Date: Wed, 30 Oct 2024 15:32:26 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
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
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v3 3/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <ZyJDelNH7bvo/TnO@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241025141453.1210600-4-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025141453.1210600-4-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o0oMqycScrBsgJn-Wm-yIyXZO4bLMyZD
X-Proofpoint-ORIG-GUID: tkzhKRRM0rBtbKmnHezVCceiN8aV8C4d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=779 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300111

On Fri, Oct 25, 2024 at 04:14:48PM +0200, David Hildenbrand wrote:
> To support memory devices under QEMU/KVM, such as virtio-mem,
> we have to prepare our kernel virtual address space accordingly and
> have to know the highest possible physical memory address we might see
> later: the storage limit. The good old SCLP interface is not suitable for
> this use case.
> 
> In particular, memory owned by memory devices has no relationship to
> storage increments, it is always detected using the device driver, and
> unaware OSes (no driver) must never try making use of that memory.
> Consequently this memory is located outside of the "maximum storage
> increment"-indicated memory range.
> 
> Let's use our new diag500 STORAGE_LIMIT subcode to query this storage
> limit that can exceed the "maximum storage increment", and use the
> existing interfaces (i.e., SCLP) to obtain information about the initial
> memory that is not owned+managed by memory devices.
> 
> If a hypervisor does not support such memory devices, the address exposed
> through diag500 STORAGE_LIMIT will correspond to the maximum storage
> increment exposed through SCLP.
> 
> To teach kdump on s390 to include memory owned by memory devices, there
> will be ways to query the relevant memory ranges from the device via a
> driver running in special kdump mode (like virtio-mem already implements
> to filter /proc/vmcore access so we don't end up reading from unplugged
> device blocks).
> 
> Update setup_ident_map_size(), to clarify that there can be more than
> just online and standby memory.
> 
> Tested-by: Mario Casquero <mcasquer@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/boot/physmem_info.c        | 47 +++++++++++++++++++++++++++-
>  arch/s390/boot/startup.c             |  7 +++--
>  arch/s390/include/asm/physmem_info.h |  3 ++
>  3 files changed, 54 insertions(+), 3 deletions(-)

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>

