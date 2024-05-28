Return-Path: <kvm+bounces-18213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBB58D2001
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 17:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D3291F24170
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF3F173337;
	Tue, 28 May 2024 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eJey/ovC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D087172799;
	Tue, 28 May 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716909198; cv=none; b=VqK1L30KvNaKS2JCWGQ8cJu9jfB3a0awQkUD/p2by39tM8OQVXK5auT7tXx68NQsecXQ1o/uLnLJfCR47EQbCqxV4QmOxvBsJxU1ewBYu2bGo4K0p/FwQJ0Gct70YRUGTqUB6oPeyvn3r2CynBVEXc9vC1mNfY/MuYvTqzwFlUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716909198; c=relaxed/simple;
	bh=FbYmI34nJahx0nlpKY6ItVPO3W3y5qI1gQvoOLMGCao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uUKFphySE004Rm99GQErFoq1VjbgdFRBKIeTSxtzcAnRd0eVxC0r4Bw3QSEoMxkpMsQpjGNkGEQRJonhSzPAWg0l+v6Ve5BxguDIDMukj+YKFUevrFFSzNXhEEsLc9yVhIOZazvt18o5Z/YRtsvqoOn+K1gCoyGMPTpJIJ9+yRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eJey/ovC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SEfHEx031966;
	Tue, 28 May 2024 15:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=4zJGf5RyH6cu1QoWMyiKVsiZc+naiwu38j7cpURQRMQ=;
 b=eJey/ovC5zk9NQfnptHS2Tkkg4kbSgaJ9Y6150ZCEGHCxhWs4615cLtg8j1MN14lFY++
 HvgEhs5zo6BTtVTW0+fzVumhR0uT1iofA9JwX+cb1EulBjOvnbNk4Vwg32U398pmq/xV
 nmOw718p8Cpo+j6Al6MDkoav3UIpfYFztR+mBQo16BU4z70lStfkoSGRHMnJjTbcO5RL
 ewb0WTu9rhGtuXJhU6Q2Z+qdPvD8ec2cSTAhyw96mOxUp0BxVOK1siFkejHwgyoUxmo4
 aqvPrVDRlvr3A3HrnGSoFYsxYG5IzrnqYrXaBNAFMN8Ew2tJvxM5eigKFg7RlOt4ZJBQ 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydh46r3r4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 15:13:16 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44SFDFSB032535;
	Tue, 28 May 2024 15:13:15 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydh46r3r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 15:13:15 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44SCQtEq011106;
	Tue, 28 May 2024 15:13:14 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ybtq07pgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 15:13:14 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44SFDBgI6423096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 15:13:13 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68EE958052;
	Tue, 28 May 2024 15:13:11 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E67E25805E;
	Tue, 28 May 2024 15:13:09 +0000 (GMT)
Received: from [9.61.37.147] (unknown [9.61.37.147])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 May 2024 15:13:09 +0000 (GMT)
Message-ID: <17c8e878-719b-45cb-b13c-73237024d333@linux.ibm.com>
Date: Tue, 28 May 2024 11:13:09 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
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
 <20240523-vfio_pci_mmap-v2-1-0dc6c139a4f1@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20240523-vfio_pci_mmap-v2-1-0dc6c139a4f1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U5HT6cuKpwyXcG4iRDebThGza3dYIe-S
X-Proofpoint-GUID: fTVbVP5Me9EDNca_z5PHab-J6h1ujqQd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_11,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=995
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405280113

On 5/23/24 7:10 AM, Niklas Schnelle wrote:
> The s390 MMIO syscalls when using the classic PCI instructions do not
> cause a page fault when follow_pte() fails due to the page not being
> present. Besides being a general deficiency this breaks vfio-pci's mmap()
> handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
> access. Fix this by following a failed follow_pte() with
> fixup_user_page() and retrying the follow_pte().
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

FYI, as of -rc1 this patch has a merge conflict with 29ae7d96d166 ("mm: pass VMA instead of MM to follow_pte().")



