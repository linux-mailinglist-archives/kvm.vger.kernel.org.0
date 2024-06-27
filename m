Return-Path: <kvm+bounces-20601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAB691A4B5
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 13:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 923B5283217
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5140C1487DF;
	Thu, 27 Jun 2024 11:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oxTyxtji"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C018613BACC;
	Thu, 27 Jun 2024 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719486767; cv=none; b=ki3yUlGpMHIFELZGUxHmYgDGMJEQKyAZ60LJbBNHjZ1jOszrcdI5UHyYD+ZaG2PsmwiCoULvs/Z4pUjq0Nqd2ERs7TF5l5LAw7Cn7S4BSAChYVGyzSpVuShYEJr2hpsNfB2tc7Em4tNyRDejgNiwTzSAwwccj8NQ0FTvzxotUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719486767; c=relaxed/simple;
	bh=lk+uxUgLA36GsKtPSA8M1XnFcuk3WuKEScDxKXqpBM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d21utuW2bUbge3FK3K68abVaWiApAfsXRhmX0EgpV+Nxn4k0L+n5C5uOCbqeKIbmFfJ/VqEVM7OWZ/Xrl6O4v9xw7Y6hDRXw1NEFsJqsDklsE43e75nHgaL3fqI9TEwNOx1Gv081WrzpdvW1BcAj1nI1EwRbRISR+Cqhy1PFAj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oxTyxtji; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RARhNB009098;
	Thu, 27 Jun 2024 11:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=m
	I3rl3LJgo1QOmkf34a0l7mVqik6Is3q+jHvXeib2zU=; b=oxTyxtjikaSjd72ts
	0Gc0caboxcC896YTDrXAMpWpLcHvJIq/Zmehe5d740781U8/zbEwxduXSBrrzGfB
	dUPOnQ/zA8chnbzq+kSHD0x4RK3X1KSj/o3+JoR/NYMU8ObFiPWMHFehtBAcVJCc
	xEjdZJyvzRvC8mvMI2BwxPF0v7wVKgj80xZJfGn64rSU9BOJukMKFnIpC054dakj
	Z15CYyBvUjokvhtBS/x/NYr9lPWfgC/oqVNH50RBjSEznMkSmUpcPbD7/xN31PtV
	NpdFfA1X1IuNH47c8Xg5TiVvtcjw9DiqANobuB1H4m5hqLBzXGo/NeGecjeQZ2C6
	D+7wQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4014ks8bqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 11:12:37 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45RBCbxs012346;
	Thu, 27 Jun 2024 11:12:37 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4014ks8bqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 11:12:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45R8Yqs3019897;
	Thu, 27 Jun 2024 11:12:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5mt46s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 11:12:36 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RBCUER47251790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 11:12:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1AC720043;
	Thu, 27 Jun 2024 11:12:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 728482004B;
	Thu, 27 Jun 2024 11:12:30 +0000 (GMT)
Received: from [9.152.224.141] (unknown [9.152.224.141])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 11:12:30 +0000 (GMT)
Message-ID: <d9f7f49b-1a77-4825-95e8-f3f840f84fc9@linux.ibm.com>
Date: Thu, 27 Jun 2024 13:12:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] s390/pci: Add quirk support and set
 pdev-non_compliant_bars for ISM devices
Content-Language: en-US
To: Niklas Schnelle <schnelle@linux.ibm.com>,
        Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
 <20240626-vfio_pci_mmap-v4-2-7f038870f022@linux.ibm.com>
 <b22a641f84b3e3259777ff54576f3a2f1435785b.camel@linux.ibm.com>
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <b22a641f84b3e3259777ff54576f3a2f1435785b.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8zUs8eYoqJSdVo-SMBO8D4qNM-xe6LBG
X-Proofpoint-ORIG-GUID: UiT0DF6NIiawy8tqbuBjCnGK0xGwfSVa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_06,2024-06-27_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1011 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270082



On 26.06.24 13:20, Niklas Schnelle wrote:
> On Wed, 2024-06-26 at 13:15 +0200, Niklas Schnelle wrote:
>> On s390 there is a virtual PCI device called ISM which has a few
>> pecularities. For one it claims to have a 256 TiB PCI BAR which leads to
>> any attempt to ioremap() in its entirety failing. This is problematic
>> since mapping the whole BAR is the default behavior of for example QEMU
>> with VFIO_PCI_MMAP enabled.
>>
>> Even if one tried to map this BAR only partially the mapping would not
>> be usable on systems with MIO support enabled unless using the function
>> handle based PCI instructions directly. This is because of another
>> oddity in that this virtual PCI device does not support the newer memory
>> I/O (MIO) PCI instructions and legacy PCI instructions are not
>> accessible through writeq()/readq() or by user-space when MIO is in use.
>>
>> Indicate that ISM's BAR is special and does not conform to PCI BAR
>> expectations by setting pdev->non_compliant_bars such that drivers not
>> specifically developed for ISM can easily ignore it. To this end add
>> basic PCI quirks support modeled after x86's arch/x86/pci/fixup.c and
>> move the ISM device's PCI ID to the common header to make it accessible.
>> Also enable CONFIG_PCI_QUIRKS whenever CONFIG_PCI is enabled.
>>
>> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> ---
>>
> 
> 
> Fixed the '-' instead of '->' typo in the patch subject locally.
> Chances are we get a v5 anyway.
> 
> Thanks,
> Niklas
> 

For a v5:
I am not an expert in English grammar, but I think some commas (',')
may help with reading your very good commit messages.

Acked-by: Alexandra Winter <wintera@linux.ibm.com>


