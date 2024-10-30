Return-Path: <kvm+bounces-30003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E4E59B5EC6
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1794F1C21093
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 09:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB59D1E22EE;
	Wed, 30 Oct 2024 09:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GUfZKJt4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12255192D79;
	Wed, 30 Oct 2024 09:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730280223; cv=none; b=Sb7QbsnnrsBEjx4Zgue0Vq6IPVh9GcR8j8WGLmE2KSHFYXI+lW8uA1Ee9qQeOnPraYtFqVm0CqYvoopkdb7aErlsQF8YNCCULrrseD9l45X2x2KaKdZ5TySq+DpXKGG2kRtvOSma7dH9ICDjDMXmDvFe3o4ZcNtpbWz8rMukE/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730280223; c=relaxed/simple;
	bh=GRS7RqK+vg/opnKhU6HnMr81dM3bjA1pgnAF5w22634=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZ1hJb+gdFewMYuCDL3dmRp/AO0EBUd4wgxuZ9SxcrldHrLjPVm4QuPZI7M20q0QwnvOBRrIZ3hM3y/Bv/oYwj2lD0+ezz6/vFQ/7NgJJnXBw94K4gBIkJgBOOaNO/H7gZZ9nRFGRAihde1CHaHOA6vkXSWE6jtZetRDzzEw1s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GUfZKJt4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2dDm0003625;
	Wed, 30 Oct 2024 09:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=h2QyrifHMzH2OclDL/eDVhaglcA9L6
	ksjE5JpdclRwI=; b=GUfZKJt44k/8X711P74wYRfR9AZa6D/OzlQ+G3wbiUXJ6t
	X8ShV0n0b3bxVaD2zlzalIMneUR+03VlWA9eICcQ/UyR4x79wKBG9hm2riqri1Gn
	nDzmb7xBcFORsXS/kjpXACAqUM7eC9ynNrS/VN8zCYno64saB81frrLtMN6thPbd
	4x5tVL1VA0H+fTjuv7msWGLgZLbE8/AMABqepwJk3QkquSIllxCRF1n9FmgU5wmB
	vlzLBXtKwFV+9OwIqEMAihBQklAJN63kmyS2iT+uRpHYhVSs5jQDQyIi/LvjVehM
	Izl0h+L6cbNB1duNVBfSRpag9RQZmil/AkDUKfRQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nsx921-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:23:31 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49U9NVo4015023;
	Wed, 30 Oct 2024 09:23:31 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nsx91w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:23:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49U8tfXw015831;
	Wed, 30 Oct 2024 09:23:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hdf1f0ft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:23:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49U9NQvp57540930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:23:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7603420043;
	Wed, 30 Oct 2024 09:23:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 361BC20040;
	Wed, 30 Oct 2024 09:23:26 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 09:23:26 +0000 (GMT)
Date: Wed, 30 Oct 2024 10:23:24 +0100
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
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v3 3/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <20241030092324.6264-E-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 7PV8sDhpy2m3WwtMDwIzKVS974As3b8o
X-Proofpoint-GUID: CoroKk4SrxJOF8YMxe_DpfevRiAUCXDD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=753 clxscore=1015 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300072

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

Looks like I couldn't convince you to implement a query subcode.
But anyway, let's move on.

Acked-by: Heiko Carstens <hca@linux.ibm.com>

However, I would like to see an Ack or review from Alexander Gordeev
or Vasily Gorbik for this patch.

