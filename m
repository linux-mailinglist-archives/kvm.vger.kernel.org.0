Return-Path: <kvm+bounces-37963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0671FA32404
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 11:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34BED3A5505
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 10:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6C5209F43;
	Wed, 12 Feb 2025 10:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qFv6IwAc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40383206F2C;
	Wed, 12 Feb 2025 10:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739357735; cv=none; b=GgisVumj29jcXZs2BzlHAVyGC8HKSGMYbvGXkQDOXM91IJT7oUxO1yM6fJH1/5pn+/zO0gMtHGaNObPYFrT9zkStaVOcx0Xrjk2JC3MGp7mk3P5Q92nnWN8xPNwSRCG8R9J5KjVIWJQWoSvfxgrOV4vjvG8OSrL7hFBCECKErDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739357735; c=relaxed/simple;
	bh=YDUw1jwbWOCs7kM+qnqYD6rz2Rv/Ove2R3hjhj9wfy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omb/1wQEcdnmKHf+UZlLhNkSQ7FQJ6zw2DVbfcyKYCAN74XOc3+rk8S4rpZKW1YwRKTWzgMkcFDIuPM+XkyQ9RgevOxyOvqStHubDupbVCBXzHTiYwLSWCSYjcCWL0c1EiSpsETTVQ0UYmTs/Yw0dq6hGSVfc2wzqDY3cFXB3Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qFv6IwAc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51C5OOsD003168;
	Wed, 12 Feb 2025 10:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=76M3I/
	Nc/8XmmC/SMhr1RgaBDyLEl3IK3DLNAMMdyNI=; b=qFv6IwAcKyJUOs5NQiHwUz
	WgNZSG4w9inXXryzWQRxFQTaC29PglujalbfHX670LGAHhSsicEgIiF7vsEyU48a
	ZEt0JcJEL6kyMEHc2g0wzvwl5HhJNxr3xq/grLUZ1iNRG/YotaMBX2nCk8rZ4pk+
	EUG5IvQCTSCL2gv7F6cSfwsqQIkRALk6KnbHET1LzZ+2V8y2nGH27RXXTOWxcscN
	g2AnmyHZ2R/Wj4B1li+fwkZNameLn73tk+UQVpay4Cje742FT5+Ujo5oyRBGrv4L
	RJZqeMIva2KFu055VnRWdIECbqiKBB+Ne53hSe896kJOl7C62u3PVwnuW5zql52Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rnf89f6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 10:55:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51C9dw5c001358;
	Wed, 12 Feb 2025 10:55:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pjkn84q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 10:55:30 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51CAtQbl13763026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 10:55:26 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 351E620040;
	Wed, 12 Feb 2025 10:55:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6834320043;
	Wed, 12 Feb 2025 10:55:25 +0000 (GMT)
Received: from localhost (unknown [9.171.83.73])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 12 Feb 2025 10:55:25 +0000 (GMT)
Date: Wed, 12 Feb 2025 11:55:19 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Rorie Reyes <rreyes@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <your-ad-here.call-01739357719-ext-1861@work.hours>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
 <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
 <Z6RnfwawWop0v1CW@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <02675184-0ce5-4f08-9d5d-f42987b77b5b@linux.ibm.com>
 <Z6sDKeA6WzAgagiZ@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <e5ca9a2c-ec7d-4e0e-ad06-2d312b511b90@linux.ibm.com>
 <8767c6ce-28cf-4e23-baf8-e6c9ec854c60@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8767c6ce-28cf-4e23-baf8-e6c9ec854c60@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w8EkwTQy5rQ8urYUuHVDmhH98dk6ODc_
X-Proofpoint-GUID: w8EkwTQy5rQ8urYUuHVDmhH98dk6ODc_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_03,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502120081

On Tue, Feb 11, 2025 at 03:24:05PM -0500, Anthony Krowiak wrote:
> 
> 
> 
> On 2/11/25 10:02 AM, Rorie Reyes wrote:
> > 
> > On 2/11/25 2:58 AM, Alexander Gordeev wrote:
> > > On Thu, Feb 06, 2025 at 09:12:27AM -0500, Rorie Reyes wrote:
> > > 
> > > Hi Rorie,
> > > 
> > > > On 2/6/25 2:40 AM, Alexander Gordeev wrote:
> > > > > On Wed, Feb 05, 2025 at 12:47:55PM -0500, Anthony Krowiak wrote:
> > > > > > > > How this patch is synchronized with the mentioned QEMU series?
> > > > > > > > What is the series status, especially with the comment from Cédric
> > > > > > > > Le Goater [1]?
> > > > > > > > 
> > > > > > > > 1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
> > > ...
> > > > > > I don't think that is what Alex was asking. I believe he
> > > > > > is asking how the
> > > > > > QEMU and kernel patch series are going to be synchronized.
> > > > > > Given the kernel series changes a value in vfio.h which
> > > > > > is used by QEMU, the
> > > > > > two series need to be coordinated since the vfio.h file
> > > > > > used by QEMU can not be updated until the kernel code is
> > > > > > available. So these
> > > > > > two sets of code have
> > > > > > to be merged upstream during a merge window. which is
> > > > > > different for the
> > > > > > kernel and QEMU. At least I think that is what Alex is asking.
> > > > > Correct.
> > > > > Thanks for the clarification, Anthony!
> > > > Tony, thank you for the back up!
> > > > 
> > > > Alexander, is there anything else you need from my end for
> > > > clarification?
> > > The original question still stays - is it safe to pull this patch now,
> > > before the corresponding QEMU change is integrated?
> 
> This patch has to be pulled before the QEMU patches are integrated. The
> change to the
> include/uapi/linux/vfio.h file needs to be merged before the QEMU version of
> that file
> can be generated for a QEMU build. I have given my r-b for this patch, so I
> think it is
> safe to pull it now.

Ok, applied, thank you!

