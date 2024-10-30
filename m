Return-Path: <kvm+bounces-30030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A45DE9B65F7
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06B0BB20E5E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 14:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3EA1F8907;
	Wed, 30 Oct 2024 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HbWDG2Ic"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD951F81A2;
	Wed, 30 Oct 2024 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730298639; cv=none; b=HhR+KoOtD4SYevsXHtLL6wiOyjMR48UXooQvYjaLtP9AdNKS8broEyAEbVTIkldrKD6ECLxZvNtgKFKzlAh6tiPpwROMNwgzONy+8gb2Fz8kzPORwWlvJ4zgyw86OCQqoHI/BKn2YLJkFSM7cZbBjWtEeQWByMn3kS2TtODflrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730298639; c=relaxed/simple;
	bh=gzjIFKrEXj7Aftc4CfgtSmWNjrDVzXiGbesbIvaaSxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWIcWqkgLS7ZxJc+1HEL1W8wHXvi9n6WtXXr1HxP6ecBawZX27vRRlQLWy4uIPWN9nMy+W3WrvmgegO0d8VEs50Ah+y3mOfF5wJPxZEfC+c2a9KcBSxiNWMOnV5O6ohT0+urNXNGxABVbAdVYmSpKpM+UEJ5+9IvORomgIDDNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HbWDG2Ic; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDw4Tk027057;
	Wed, 30 Oct 2024 14:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QoT7eE2k9HBigUNotJEuDjW8wq/kBu
	Ua4MTBBYTqlWI=; b=HbWDG2Ic65XlMqb/D3TwV1oPEqcF5RCxQ9TgUawZNO/cqm
	Tnp24tsoW/Yjbi3C0skNfiIGSg7D4RgRHMhB+sOoG0jH42U8eQUbakTlQf4MHUIv
	jMTUrhx27tuhiPfBQEo8zVpryMy1EAo1IhxMSRKLuREM+rMVaXBliBAST9uH7Z/N
	XClRoh83sBAvy0M/9lN+Bt+DcSLaKJMAlGS1HcT+eH5fEdx3Tzz9CIG/4lKSr8rJ
	01dGny0S6N+sfaQQELe+lTMxfp53r/jeou/ANEqINjs+orALVgrTgUkjVdG5lmFy
	laKJ0gzsMXThqGRL7OwEA0v028PFmwFRosHB+b/g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j43g7pmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 14:30:26 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49UEUQVq009391;
	Wed, 30 Oct 2024 14:30:26 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j43g7pmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 14:30:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UBsO9F018383;
	Wed, 30 Oct 2024 14:30:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hc8k8aw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 14:30:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UEUKMk55116176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 14:30:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 752C120043;
	Wed, 30 Oct 2024 14:30:20 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C2E02004B;
	Wed, 30 Oct 2024 14:30:20 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 14:30:20 +0000 (GMT)
Date: Wed, 30 Oct 2024 15:30:18 +0100
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
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <ZyJC+s5L6JI3xO44@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-5-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jcbMrInueqgSbuMhblYjsLoimVoh1fDK
X-Proofpoint-ORIG-GUID: zWiWWhTbdgzaKB2WcP0riaikdeezGz5v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=742 clxscore=1011
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410300111

On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:

Hi David,

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
> Tested-by: Mario Casquero <mcasquer@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/boot/physmem_info.c        | 46 ++++++++++++++++++++++++++--
>  arch/s390/include/asm/physmem_info.h |  3 ++
>  2 files changed, 46 insertions(+), 3 deletions(-)

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>

Thanks!

