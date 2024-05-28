Return-Path: <kvm+bounces-18214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C53C8D2004
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A181FB23C73
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3CE17108F;
	Tue, 28 May 2024 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PfW2GoIF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256E7F9D6;
	Tue, 28 May 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716909224; cv=none; b=Ip1RXpGmKcKUKyEvqqc7oiIbsKkDDQUcEkAx6O3S+ytTD6oclbAnzv4YJScmeJRojT8bG5qkkHWgzjQtmqpHW6UYtqh6ta0vNdT+Zcl7bqn+dKsSbe65jOtwaQDWwfahEGMvekNpKk8ZdukLNTOfWLeh7dRT09mYu+QEQfBOzBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716909224; c=relaxed/simple;
	bh=+wg48Pe0yMxZQCJDUwVC11WijDo9w7CHZQOJikcc/lY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kFP+5m2mbZ5MwPYriYxbiPV87/3AcYp0q9oqtGEp7yblABt13XEkvaP3+8O4353+dDUi1cghtcQmjZzt1PbtZRPqRuuvEgGt5l6Lk6H4G423AjVBGnsNmUkLj+Ognm3xfvbxHWIWFE72uwUIWBn+E83i8Cz2GW8xwdKILAAwXoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PfW2GoIF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SDkCU0020650;
	Tue, 28 May 2024 15:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=V7VSE2+uYPCRI/RBA5OqDNx1FltHW8J5cwNzFsvCWA4=;
 b=PfW2GoIFpKZFwa9Z7bFPrA0YH0cYid8pfwhehd4CILeyGyiCCXuKbhXnvcCBgd4z8Uzz
 g3vZl2GrdaUHRUOJ2xCMsuXaUtt2sypsUov4QwpZxgPBijV1ghHlRVi5CmxAE8PHkWUT
 zg8oI6mYRAB/u2eLjWv0KBfR+GKbTdQSyWyOcHPy+zT0ffArhpkg1/Hc4TIGzKZXyKM+
 c9ohPabR1bW2wMqlr0HYnqYnqAn6V02MpDfBKzDAc/f13ajJCRpIEiEw4fZNNVkLr7f8
 cIf0TqQX3RIJsZ5tj43hzqUpWPZoGmKRmquT7CqWena6IKkfXKCsf3zaFPyXlC8oBqEY EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydf6jghdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 15:13:42 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44SFDfO7015446;
	Tue, 28 May 2024 15:13:41 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydf6jghdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 15:13:41 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44SDV7iw004505;
	Tue, 28 May 2024 15:13:40 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ybuanyffm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 15:13:40 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44SFDblY24969968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 15:13:39 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 457B25805F;
	Tue, 28 May 2024 15:13:37 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C122C58050;
	Tue, 28 May 2024 15:13:35 +0000 (GMT)
Received: from [9.61.37.147] (unknown [9.61.37.147])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 May 2024 15:13:35 +0000 (GMT)
Message-ID: <67fb5c3d-a53f-4ef3-93de-a307777ec044@linux.ibm.com>
Date: Tue, 28 May 2024 11:13:35 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] vfio/pci: Tolerate oversized BARs by disallowing
 mmap
To: Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20240523-vfio_pci_mmap-v2-0-0dc6c139a4f1@linux.ibm.com>
 <20240523-vfio_pci_mmap-v2-2-0dc6c139a4f1@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20240523-vfio_pci_mmap-v2-2-0dc6c139a4f1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1TMO_DwrdKXKL-FGAcPwUpCYKZuyh9d-
X-Proofpoint-GUID: YViOe4KNdkMX-dMiwr9B6EZb5UU2L43m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_11,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=909
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2405280113

On 5/23/24 7:10 AM, Niklas Schnelle wrote:
> On s390 there is a virtual PCI device called ISM which has a few rather
> annoying oddities. For one it claims to have a 256 TiB PCI BAR (not
> a typo) which leads to any attempt to mmap() it failing during vmap.
> 
> Even if one tried to map this "BAR" only partially the mapping would not
> be usable on systems with MIO support enabled however. This is because
> of another oddity in that this virtual PCI device does not support the
> newer memory I/O (MIO) PCI instructions and legacy PCI instructions are
> not accessible by user-space when MIO is in use. If this device needs to
> be accessed by user-space it will thus need a vfio-pci variant driver.
> Until then work around both issues by excluding resources which don't
> fit between IOREMAP_START and IOREMAP_END in vfio_pci_probe_mmaps().
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---


Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>



