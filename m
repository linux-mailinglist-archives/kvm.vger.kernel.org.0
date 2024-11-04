Return-Path: <kvm+bounces-30485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D939C9BB0BD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C41281D39
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C6D1B0F2F;
	Mon,  4 Nov 2024 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bc2GFbbO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28E01B0F12;
	Mon,  4 Nov 2024 10:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715305; cv=none; b=bcmQXn4Anc+44k1EhSNY4oas2+pR0Rrm7OQ6+28djHc7E5/3v4QywhrqBkdiCCxK0j66NT7fkdKxedbaSlPxOTUciFZGA5PJeRuU340eoX0aG6F1INdj73gucxkuiKRGolZxT4KTgCvOu6j1pywAEqlDscv0vvVDiSZDSoK7mEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715305; c=relaxed/simple;
	bh=mcIce5Fq/hEFHVI7AkWHxaRExFRL0bAcIhE1CoWgubY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ec4fFsLVD50VTD1VUuhLiunct51+9GZFzfboSzX9Ujz/olBAUfg7Q3HhwZbhbOBAEnFSB+kKo8QxoBxCvWzkMQqHkpg0UIXsRhSRhnr9VpD084G03RQY/UnuUvKDqnqRNWTZUNOEybFGLF0iI+DyzKr1SHzIU25b9s3k4RGtIpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bc2GFbbO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A4AAXVT016625;
	Mon, 4 Nov 2024 10:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0pvu1h2wXjRKNrgWewAcE0S2SfJqBR
	QG0tc62qAKP1Q=; b=bc2GFbbOrUg75hb8XWifBlNgNziOkjtTBeEn/bsEhj4I45
	ELj+3HePqnGj2/YkyqgACqS+hWhpOjncwtFu1Mlc5bvFDsKSnBB8ye+hFW3l8f1d
	dK0IITttHJwU6DpIWhHFXYZEUGSKf3f2X6Os52VbjyqfVaJGUGWUUI3Qyya+mAx9
	/jCPOJhhfall7WT56KGgt6yqFTtbDbMZS+WZMcv/PDrUpUBy1f4653UbX4DqF7uZ
	zeu12fyHgh9mTOyV6AsonE3drxfFpXk+w+51ESoCVhgd+Gdl+k5lpnbaWKrvhQQq
	OVWrjYn8ABEmtULhfmBxnsiCdQrSvBJCAcyBdm5A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42pv9b80e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Nov 2024 10:14:54 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4A4ABm80018784;
	Mon, 4 Nov 2024 10:14:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42pv9b80e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Nov 2024 10:14:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A49iji3008453;
	Mon, 4 Nov 2024 10:14:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nywk3mwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Nov 2024 10:14:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A4AEn4J35062488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Nov 2024 10:14:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15E3B20076;
	Mon,  4 Nov 2024 10:14:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA99820073;
	Mon,  4 Nov 2024 10:14:47 +0000 (GMT)
Received: from osiris (unknown [9.171.95.25])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  4 Nov 2024 10:14:47 +0000 (GMT)
Date: Mon, 4 Nov 2024 11:14:46 +0100
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
        Eric Farman <farman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 0/7] virtio-mem: s390 support
Message-ID: <20241104101446.9483-B-hca@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025141453.1210600-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VHeFIyuzTNW6zfc61Cu-HEnOAgIKsDwU
X-Proofpoint-ORIG-GUID: sEYZz5grUf9yUrSKVVfQ3jI2KcH0p6Ka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=647 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411040089

On Fri, Oct 25, 2024 at 04:14:45PM +0200, David Hildenbrand wrote:
> Let's finally add s390 support for virtio-mem; my last RFC was sent
> 4 years ago, and a lot changed in the meantime.

...

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

Series applied. Thanks a lot!

