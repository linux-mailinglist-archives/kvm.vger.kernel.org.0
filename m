Return-Path: <kvm+bounces-18674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A15578D8679
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 17:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6918B23859
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 15:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C138C135A51;
	Mon,  3 Jun 2024 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QwdmpTse"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B667013211F;
	Mon,  3 Jun 2024 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717429825; cv=none; b=mc9ljL5ZOIU6Cam0o7jccq/4uqUj9csoL5y2Ndn7SY4+BrmLiItKG0xZB3I5MDJvXGdUBuM78pODI//yZp4kI9LD6DcGp99R5O5M4mLAXCyQ9kdfnSespKAt5swhcgnRfPXBXt2SRoXmk6IpBVdx8zu+NdZN6hg/X6QO6++rNsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717429825; c=relaxed/simple;
	bh=09GW141vyhA3TWVs31bX+SwPdXlmzElACeiTQ7Wkt5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNj+Y4nvKe0Mj9J14FZOptjoTJFwZ24evBayO3k7qhrVto3QG7N3R4mqA5xx22XGl+4mzGkCFalOwhCDx3XB7nwfiYWl3mAuH5rgrR4owC4QxA8qpfGGIWGorgZRaG5Uvt6nOy39kXfZaog8Wdo/tnL5S85rHDPsXA77dzZ/HeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QwdmpTse; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453EML8h011843;
	Mon, 3 Jun 2024 15:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=ePULW9uS93kgG+OIgTAxeB/WyHwiznBkNJw1F1YpuBE=;
 b=QwdmpTseb4DoqUJZONNMyuTdOn1J31an/jDi+UobJiCyf74Hspz5UtUeCSG3XdegDFug
 /ocHPQ+NDJJZRtQI6WVbyOnQoQo4ODl3gCVBjdkhF2TDXEt3zZPikUz2J9t10IibTKrs
 y45w0qZoW05psOZYrC0HtUQgOytIqU7DYjm3AHNUiw7w2BH/TxPYXColqHcpjyBZ3fVf
 tRauuNhUJgdojrmahftaTWagN4zPKE/6h0EhGqU3HYeY2q0jqjtIaWfzZGxF+RZ/KrvN
 U0j6F5EQ73pZpG1Fv3fA9445yDqAt+Z4qxOg9zrJFHgL7NdihePu1ttXN5qCcxGxc9j4 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhfhf08yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 15:50:21 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453FoKMe027561;
	Mon, 3 Jun 2024 15:50:21 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhfhf08yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 15:50:20 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 453DsDn8022851;
	Mon, 3 Jun 2024 15:50:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygg6m0d8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 15:50:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453FoEY530212802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 15:50:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B1B32004D;
	Mon,  3 Jun 2024 15:50:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B41CF20043;
	Mon,  3 Jun 2024 15:50:13 +0000 (GMT)
Received: from [9.171.29.243] (unknown [9.171.29.243])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 15:50:13 +0000 (GMT)
Message-ID: <0a4622ce-3826-4b08-ab81-375887ab6a46@linux.ibm.com>
Date: Mon, 3 Jun 2024 17:50:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
To: Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yLwbTIUJCGJRQ7SW9Ff88cFp0q37B-SI
X-Proofpoint-ORIG-GUID: cCbs5DZtHoS1VFTHzvR-EER9Z_FDY-XW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_12,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 clxscore=1011 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 mlxlogscore=877
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030131

Am 29.05.24 um 13:36 schrieb Niklas Schnelle:
> With the introduction of memory I/O (MIO) instructions enbaled in commit
> 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> gained support for direct user-space access to mapped PCI resources.
> Even without those however user-space can access mapped PCI resources
> via the s390 specific MMIO syscalls. There is thus nothing fundamentally
> preventing s390 from supporting VFIO_PCI_MMAP allowing user-space drivers
> to access PCI resources without going through the pread() interface.
> To actually enable VFIO_PCI_MMAP a few issues need fixing however.
> 
> Firstly the s390 MMIO syscalls do not cause a page fault when
> follow_pte() fails due to the page not being present. This breaks
> vfio-pci's mmap() handling which lazily maps on first access.
> 
> Secondly on s390 there is a virtual PCI device called ISM which has
> a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo)
> which leads to any attempt to mmap() it fail with the following message:
> 
>      vmap allocation for size 281474976714752 failed: use vmalloc=<size> to increase size
> 
> Even if one tried to map this BAR only partially the mapping would not
> be usable on systems with MIO support enabled. So just block mapping
> BARs which don't fit between IOREMAP_START and IOREMAP_END.
> 
> Note:
> For your convenience the code is also available in the tagged
> b4/vfio_pci_mmap branch on my git.kernel.org site below:
> https: //git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/


I guess its now mostly a question of who picks those patches? Alex?

Any patch suitable for stable?

