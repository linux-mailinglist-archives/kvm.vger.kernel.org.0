Return-Path: <kvm+bounces-30006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6829B5EFB
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0486A1F23A1B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 09:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9181E2313;
	Wed, 30 Oct 2024 09:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gDpmYFwI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363921E22F2;
	Wed, 30 Oct 2024 09:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730280913; cv=none; b=rgq0l1IAsYqs6ormWb5+deOOhm2HXFtZpPLgjfs8ftfUw0ghg64oiayEzO2yoDqjyn1+qQ0kp2xQaYC61jgdu0DOKiL8KUgbZPn8VU5zjORd41NRe2bFbiqTwxfYpVApIxLEUj9bTVJ2RLTOxkGFZZ+H7mR31D52AXYl2+SVR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730280913; c=relaxed/simple;
	bh=AfBOp28JT01hwfV9cXc03kgjuWVGzhiFFC+0MZ73cec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WGMlhyae3UPGdMqjQqmPnTEMzJpOOcOsaZnWOVxcWnmyZ5P2I+itsEhcZgI2+1K3PPFueMJuyxW6E+AYbjVQIrZxu+VrvX6AK9EpBTviQdTM0SXM42EjG1O1DnVoDMbzIwFgbiDdQ2zeSJ3et3y7Io4rhQysEfUO70lW29oP5hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gDpmYFwI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2d34j025620;
	Wed, 30 Oct 2024 09:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=IeullnzOmr+h9se1xjTwCHafbkTeUK
	hwri4FyGB0XEg=; b=gDpmYFwI0vSEkjy7+KDBBUoZ94rosHSV0Yt8bsdynNLiMg
	jyYX0/QqP3M+uGEqT6x102Fejv19Z33Ioqn8rPQFMDQlwbIW7nSZj88zsn9aWsk4
	JhVUozXA+kmK7v/7C3Tf2xSeocInVH8a8XPm/a3ZdhPlVFVXNRRAE65qFTqyvWvk
	jqHtukfnK3ktwmxMzfWTT7NgyLG7I2whB94fd9rCim80rzHAe9d2xyQPiWTPHnbC
	yqer7ZHX3HcvCBfuo0eRrSPxeQU8S8wmBZpzEV7M/93YTa1LinMJI87wcX1SmiOz
	EiF7JE9FWsHyohtO1zY0zNhnMt2kdSVsqMto7ulA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65hq6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:35:00 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49U9Z0Eo020669;
	Wed, 30 Oct 2024 09:35:00 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65hq6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:35:00 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49U6WrWA017410;
	Wed, 30 Oct 2024 09:34:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42harsfke1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:34:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49U9Ytqt34144992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:34:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FC9E2004B;
	Wed, 30 Oct 2024 09:34:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E74F20040;
	Wed, 30 Oct 2024 09:34:55 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 09:34:55 +0000 (GMT)
Date: Wed, 30 Oct 2024 10:34:53 +0100
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
Message-ID: <20241030093453.6264-H-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: RJmLhjYk0o0VpS1HltgmETm6DAOC35nw
X-Proofpoint-GUID: tBAswqFNk76bAn1jDNlPMUI8PjC9pDN0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=615
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300072

On Fri, Oct 25, 2024 at 04:14:45PM +0200, David Hildenbrand wrote:
> Let's finally add s390 support for virtio-mem; my last RFC was sent
> 4 years ago, and a lot changed in the meantime.
> 
> The latest QEMU series is available at [1], which contains some more
> details and a usage example on s390 (last patch).
> 
> There is not too much in here: The biggest part is querying a new diag(500)
> STORAGE_LIMIT hypercall to obtain the proper "max_physmem_end".

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

I'll apply the whole series as soon as there are ACKs for the third
patch, and from the KVM guys for the whole series.
Christian, Janosch, Claudio?

