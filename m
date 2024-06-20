Return-Path: <kvm+bounces-20074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9B7910431
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CB16B2123A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 12:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114A21ACE61;
	Thu, 20 Jun 2024 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ek6xzTqf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214021991DC;
	Thu, 20 Jun 2024 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718886598; cv=none; b=C55UluH0JIh5eYJqL3+scGdLy8lOL4cjEv9xe0epZ7OCbpgeDPl/rr1KJVD9KyxVkzzo7LHSxKuZ5IZYlEIwTHyj8mXdIDbl+2dtI7ybM+Wvd2hIbjwwWdkt4CfK3EnD9cUYtvDMlq4M1827D2dUzN9n+MtU8I7e4gtFwQlYqmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718886598; c=relaxed/simple;
	bh=+Q6wp3tvbGNSDlHVAa4xeJsGtjsBnA9MkZEq3IT5n9Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S/01H1zjRWxifQeSXFfEuBBLgt/GhbA/9RxicCjl0w0uPqIYdb7RncfDmUlV73i6oMllyqaWOgZA38wsuGu5v4/2AsynsATi4Z6COkH1wE0R6cazRJiINXqJRKo6ZXL8a7J8g6TdP9Mr4YT0FfatxUKMHo2UY4bFpvnM8P2mPac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ek6xzTqf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KBPmD6010899;
	Thu, 20 Jun 2024 12:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	+Q6wp3tvbGNSDlHVAa4xeJsGtjsBnA9MkZEq3IT5n9Y=; b=Ek6xzTqf60gxulMp
	nGl7f1Bk5jxKrSPstTCQOplQhgiCyYm6KJDLg6pIXQrJX2tRUY75kMk7FjrppokB
	kv0F3CwVOwf/Th7kSb41Kmp49kL3D0WhJ8i7wR5QEEzSo7bzrOPLuoC4/6JyTDdb
	0zv+BYCIOveZD30Cd+Yc+QNJ6geN4XSKp9BV51bkHWb81dHhIDx2LmMGNmr/0DyS
	i6cYAUcuZQ4r2eibpz9zpMs/ZafMCfoGtXSbwoqRcVAjswyyZzk8hw7n8tZf5LbR
	vULBsRb0832efMrX4dCClS09JSQWjAOfVupSAvwq6Om61TJ10kVos/UOiNBorUSU
	cyb7yQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvg2s8pcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 12:29:50 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KCTnsm008184;
	Thu, 20 Jun 2024 12:29:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvg2s8pck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 12:29:49 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KAfdNP011037;
	Thu, 20 Jun 2024 12:29:49 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yspsnnre2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 12:29:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KCThpR51249462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:29:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 670EA2004D;
	Thu, 20 Jun 2024 12:29:43 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E97E20040;
	Thu, 20 Jun 2024 12:29:43 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 12:29:43 +0000 (GMT)
Message-ID: <af89c1a0cd8ad8e729b7675e7fa3abd6f97201e7.camel@linux.ibm.com>
Subject: Re: [PATCH v3 2/3] vfio/pci: Tolerate oversized BARs by disallowing
 mmap
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>,
        Christoph Hellwig
	 <hch@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason
 Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 20 Jun 2024 14:29:38 +0200
In-Reply-To: <ecbd75e7c9a96ac38846a17917339d2cae6fe74c.camel@linux.ibm.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
	 <20240529-vfio_pci_mmap-v3-2-cd217d019218@linux.ibm.com>
	 <20240618095134.41478bbf.alex.williamson@redhat.com>
	 <ZnKEuCP7o6KurJvq@infradead.org>
	 <76a840711f7c073e52149107aa62045c462d7033.camel@linux.ibm.com>
	 <ZnOrlB6fqYC4S-RJ@infradead.org>
	 <ecbd75e7c9a96ac38846a17917339d2cae6fe74c.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m4aU38zbebI3mNAamlD0p9X44SbPrTgw
X-Proofpoint-ORIG-GUID: OcVkhUfOJcornAzFBu1IslYqSOp7JJM8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=837 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200089

On Thu, 2024-06-20 at 14:06 +0200, Niklas Schnelle wrote:
> On Wed, 2024-06-19 at 21:09 -0700, Christoph Hellwig wrote:
> > On Wed, Jun 19, 2024 at 12:56:47PM +0200, Niklas Schnelle wrote:
> > > In short, the ISM BAR 0 is stupidly large but this is
> > > intentional. It not fitting in the VMAP is simply the least crazy
> > > filter I could come up with to keep the ISM device from causing
> > > trouble for use of vfio-pci mmap() for other, normal, PCI
> > > devices.
> >=20
> > Then maybe add a PCI quirk to prevent mapping it.=C2=A0 This would also
> > affect the sysfs resource0 file unless I'm missing something.
> >=20
>=20
> The resource<N> files are globally disabled on s390x due to lack of
> HAVE_PCI_MMAP/ARCH_GENERIC_PCI_MMAP_RESOURCE at the moment. I might
> change that in the future with a analogous argument as for
> VFIO_PCI_MMAP but for its not there. Once we add it we of course need
> the same special ISM treatment there too.
>=20
> Looking at the existing PCI quirks I don't see anything that would
> fit so I'm guessing you would want to add a new quirk? As I
> understand it we would then have to export something like a
> is_pci_mmap_broken(pdev) function while currently the only quirk
> function that seems to be exported is pxi_fixup_device(). But then
> what happens if CONFIG_PCI_QUIRKS=3Dn? Also the header comment in
> drivers/pci/quirks.c says that platform specific devices shouldn't go
> in there and ISM is platform specific.

I took a cursory look at that file as well and arrived at a similar
conclusion that drivers/pci/quirks.c (as is) does not sound like a good
match for the required functionality


> Instead of exporting IOREMAP_START/IOREMAP_END maybe there is another
> reasonable maximum resource length? Or maybe we could create a size_t
> ioremap_area_size() helper similar to is_ioremap_addr() but not
> inlined. The latter already uses IOREMAP_START/IOREMAP_END so not
> sure how that works when IOREMAP_END is not exported?

But seeing how the PCI quirks filter against Vendor and Device ID,
I just had the idea if it would make sense to create a similar
infrastructure in the form of VFIO PCI quirks - and simply reject mmap
on ISM devices regardless of the size of iomap'able address spaces?
Sound rather coarse-grained, though...

> Thanks,
> Niklas

Just a thought,
Gerd

