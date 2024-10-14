Return-Path: <kvm+bounces-28797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1F499D5E1
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9D911F234EE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5311C7610;
	Mon, 14 Oct 2024 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MAWNDWJi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C8231C8A;
	Mon, 14 Oct 2024 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928433; cv=none; b=GuIE6OypqWJsIPEjzHv/JkiLD8/nNITM18tmNpcbGe3mAEhEJxJb6H+2O5bxmyxJtvYou7oPsohSaQyGANzo4LutuWu0OD/Kd+10zczhkM7vd2WqCunJS6OHD4/t6aZR21xTPsg1U8vyky6S9k4AM4YyhoYNarMtAu/rSrNqJtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928433; c=relaxed/simple;
	bh=v+mnqLFStPaJF5Mc8YcJfD7J7cx62hdqhcZqrfk1hHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSuc/tYL3whmf/AVXZor9KdNq+wr/Lf6F1+fwraHYH7Oidg2j7Zs3mIwxF7iI92t6SQHZLm81EEmxS6d4r9V/eWPEXIDeq/EGpro0YADQMEN8+JjjNCMFecpKsT344ibvWqqnWBo3D6+MJOvf/gQaA6ho85M9ZCur5I213WoNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MAWNDWJi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHpnhJ032095;
	Mon, 14 Oct 2024 17:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=brLW2EcSwr3dgFdZYov7EsAvpYw
	fb5CRO99N/OPunA4=; b=MAWNDWJiZRG4uc1TJl8OSC3XFdTTvCXrznd/Ha0VShH
	wxgDeEO1JHhiA4fNVeZRYmcXUpcYsWa8YNevpkEhEw4wLakdzpXw5fPfM5gqZ5AL
	lxtfNxAqRXGmX2nZ19xX43YlPHn/53QizNI4UlHrodNROKBuKqwaA/cZAtL8m5sM
	CQhIukttr9i2wao0GFPvKDuKk7M138WvhHBYi0/QKdhXh2BdLsRh7yNOls0DmfNo
	zwnXrqoEc2cY7rwOph6xiJrZTSc5u4x717kR/h8v8A00l8HzoA/+ssiXd47JFAF6
	vuiKZBIEJSXf5qaxo0XmvKJQG3hxTNnNwFgRJuTJAhQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42982kg05s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 17:53:44 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EHrhJk003502;
	Mon, 14 Oct 2024 17:53:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42982kg05j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 17:53:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHgPUo027432;
	Mon, 14 Oct 2024 17:53:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txfxmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 17:53:41 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EHrcwV46203318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 17:53:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3480020049;
	Mon, 14 Oct 2024 17:53:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 397BC20040;
	Mon, 14 Oct 2024 17:53:37 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 17:53:37 +0000 (GMT)
Date: Mon, 14 Oct 2024 19:53:35 +0200
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
Subject: Re: [PATCH v2 7/7] s390/sparsemem: reduce section size to 128 MiB
Message-ID: <20241014175335.10447-B-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-8-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-8-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5D_xC6nknQqUzkF7BmFqB2_0PkJpbEq7
X-Proofpoint-GUID: UKk9TP1S1FoYIjDngHQjul4Nmfsk5MhM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=4 mlxlogscore=143
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 mlxscore=4 bulkscore=0 spamscore=4 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140128

On Mon, Oct 14, 2024 at 04:46:19PM +0200, David Hildenbrand wrote:
> Ever since commit 421c175c4d609 ("[S390] Add support for memory hot-add.")
> we've been using a section size of 256 MiB on s390 and 32 MiB on s390.
> Before that, we were using a section size of 32 MiB on both
> architectures.
> 
> Likely the reason was that we'd expect a storage increment size of
> 256 MiB under z/VM back then. As we didn't support memory blocks spanning
> multiple memory sections, we would have had to handle having multiple
> memory blocks for a single storage increment, which complicates things.
> Although that issue reappeared with even bigger storage increment sizes
> later, nowadays we have memory blocks that can span multiple memory
> sections and we avoid any such issue completely.

I doubt that z/VM had support for memory hotplug back then already; and the
sclp memory hotplug code was always written in a way that it could handle
increment sizes smaller, larger or equal to section sizes.

If I remember correctly the section size was also be used to represent each
piece of memory in sysfs (aka memory block). So the different sizes were
chosen to avoid an excessive number of sysfs entries on 64 bit.

This problem went away later with the introduction of memory_block_size.

Even further back in time I think there were static arrays which had
2^(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS) elements.

I just gave it a try and, as nowadays expected, bloat-o-meter doesn't
indicate anything like that anymore.

> 128 MiB has been used by x86-64 since the very beginning. arm64 with 4k
> base pages switched to 128 MiB as well: it's just big enough on these
> architectures to allows for using a huge page (2 MiB) in the vmemmap in
> sane setups with sizeof(struct page) == 64 bytes and a huge page mapping
> in the direct mapping, while still allowing for small hot(un)plug
> granularity.
> 
> For s390, we could even switch to a 64 MiB section size, as our huge page
> size is 1 MiB: but the smaller the section size, the more sections we'll
> have to manage especially on bigger machines. Making it consistent with
> x86-64 and arm64 feels like te right thing for now.

That's fine with me.

Acked-by: Heiko Carstens <hca@linux.ibm.com>

