Return-Path: <kvm+bounces-39768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBC9A4A578
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 22:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ED52189BBE8
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 21:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03CB1DE2CD;
	Fri, 28 Feb 2025 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GGO27PwH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFD617AE11;
	Fri, 28 Feb 2025 21:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740779810; cv=none; b=k4rw6/ry8GsML6oM10bNdafJRbXL1uPIEQEiNS8AVD7RaqHWAVWqCcNnXdB9Gtkc6imseGjfFw80a/CbeCtyU+IqIJ0y3uLjppVlNsjYx4bfBZvymSSiuQAzCgIlmv566YnZUpEpRgy2B7quSLpIy22jCc3OliTHt9b+zkxw4pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740779810; c=relaxed/simple;
	bh=xgx74KAnryMdHk4aMsU+wncygKbmuulKZLa5olrGhpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DW0vp9TgovnRdQrTsjeP/Ka39C3d3YCANRNmcFbiKqVbaqUoEmEflhsQe14jwajMIMQhLCvx6qx2kPQu6z5eawxwM7txJvYuLtfKh7p46FrdwN0j+z6eos8SAhkywgED5wnaxTi3Pu+AtNtP+KcWTO58GkxGl7yq1QJhAyXN344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GGO27PwH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51SFC0ck000301;
	Fri, 28 Feb 2025 21:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nIutNh
	5CojQX5gU0YW+eYx7cac50enWAOuwLkZTQy0U=; b=GGO27PwH2EimTeWguYwiPo
	x3f4lBvxRUg7KDtUKyznYjR+G+ZNpihoa/44pwmSU50SkIpVB0T1I/MuCBLTbweL
	VXWRH9oJtY5O4/fsWG9O+yG+RIjXNhUgtXktNZdK2d4LrN7h5bDuTffvqoJ8+UY2
	stssnILhmQuMT16CmQIxpPcszKGCgHHscTkdRBowTYGRdlzgnZ0uURi2eWXaKsK9
	TJJbF7zdHHr1wbtKHRdc9j8Q+m20Qd6ldPy7GFSKDSWvzJVtNlPhpNCZR6PJv/tA
	n9kpCd4wgsM9bZ/flapOCjeT3pviPO6GnpR3ZsZFlacADdunSxHGtnVYcLzLnQtQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4536y8ct9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Feb 2025 21:56:40 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51SLr7RZ002906;
	Fri, 28 Feb 2025 21:56:40 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4536y8ct9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Feb 2025 21:56:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51SJx7gL012735;
	Fri, 28 Feb 2025 21:56:39 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwt92p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Feb 2025 21:56:39 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51SLubbJ26214992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 21:56:37 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 865B358056;
	Fri, 28 Feb 2025 21:56:37 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 289405803F;
	Fri, 28 Feb 2025 21:56:36 +0000 (GMT)
Received: from [9.61.46.135] (unknown [9.61.46.135])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Feb 2025 21:56:36 +0000 (GMT)
Message-ID: <8cff6617-634c-4e10-bd1d-7719edf484ea@linux.ibm.com>
Date: Fri, 28 Feb 2025 16:56:35 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
To: Niklas Schnelle <schnelle@linux.ibm.com>,
        Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Julian Ruess <julianr@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20250226-vfio_pci_mmap-v7-0-c5c0f1d26efd@linux.ibm.com>
 <20250226-vfio_pci_mmap-v7-1-c5c0f1d26efd@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20250226-vfio_pci_mmap-v7-1-c5c0f1d26efd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hOaKjlQZxMFi8CAbzE3LfAeOcKj-Pidr
X-Proofpoint-ORIG-GUID: OA0cRxaMfrKCLZAKccGnkHvvkihMq1rK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-28_06,2025-02-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 mlxlogscore=923 mlxscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502280156

On 2/26/25 7:07 AM, Niklas Schnelle wrote:
> The s390 MMIO syscalls when using the classic PCI instructions do not
> cause a page fault when follow_pfnmap_start() fails due to the page not
> being present. Besides being a general deficiency this breaks vfio-pci's
> mmap() handling once VFIO_PCI_MMAP gets enabled as this lazily maps on
> first access. Fix this by following a failed follow_pfnmap_start() with
> fixup_user_page() and retrying the follow_pfnmap_start(). Also fix
> a VM_READ vs VM_WRITE mixup in the read syscall.
> 
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

