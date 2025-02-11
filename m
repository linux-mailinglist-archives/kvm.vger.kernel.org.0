Return-Path: <kvm+bounces-37821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6EFA3050D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C73691882A66
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13911EF0B9;
	Tue, 11 Feb 2025 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nqMsmtvg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31C1EE006;
	Tue, 11 Feb 2025 07:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739260725; cv=none; b=VaAlwnC+EN7Ng31o/72HwiKirm3shPFF3XTuVZ/JsPQwpkJZnT/L9/HHu1ybgUlokEXD1Cp2Fm5ePcADH2iHYGZ+qKh9JERb/MClonBqMxZeXPSNmG5m4JPrWbKb9EeG/jaaUuAwJFYdFHUFeYV3tPpyOgw2kjDMMQPD0QDBqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739260725; c=relaxed/simple;
	bh=MfEtWbLPgXZpUzRVrDPwsHWz/9YeYn+wWSSA9lyf3bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPBN5T+DuuRvouTU+B25BGcCRtybv2RdJrDkGcFna3ZeSGejHzPu2ls5PLUBDXavWhMPF4YkRHL9dI7HjVn+fblUdzi4KJOQ+6iYyTkP8cY24hB0oMWFQtJG67gnLGVCb3MCJ2pgZqCYq9HqVCusjh43Tr+1corV2E606f6rdM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nqMsmtvg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B1go7G005901;
	Tue, 11 Feb 2025 07:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WlxeSK
	+CAkCyLAKyw0C9HbWTW9TRohs2UDyT8UneP/8=; b=nqMsmtvgA6XO9pvNt4HSjv
	ugyIlux65V1i3HWg7l9s8hWyLWqkK4O7bwzAFbmP5oFHgHLV3IgC/qHq6FXdym/U
	Rh2TqdtLA8t/53dmVmXqZceQupP2pqduaRPUnNzk0eiaz00cCQbNU7ue61hkzVsW
	QKta95IW5cgInyy5CJZCT2ZVa4Y4jGewEfCOp2z+LzEkCl5eKwhZQQJY+dXs92Sf
	26R/FfZ0jJ5kMJYimG1rojaUtrWA3wcCGvBG5XoDSeMZxSMag5SY1nnmnLaIgD1i
	Z6b27mOiRVNyQEB3Wm8KqjWiowQiLgwutA+AHWwB+AiSHvrEDR/8A/QuhNlqB8vA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44qvma1bdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 07:58:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51B4Yn7D000924;
	Tue, 11 Feb 2025 07:58:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44pjkn29rd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 07:58:39 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51B7wZBq33358334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 07:58:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D95920043;
	Tue, 11 Feb 2025 07:58:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A243820040;
	Tue, 11 Feb 2025 07:58:34 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.13.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 11 Feb 2025 07:58:34 +0000 (GMT)
Date: Tue, 11 Feb 2025 08:58:33 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Rorie Reyes <rreyes@linux.ibm.com>
Cc: Anthony Krowiak <akrowiak@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <Z6sDKeA6WzAgagiZ@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
 <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
 <Z6RnfwawWop0v1CW@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <02675184-0ce5-4f08-9d5d-f42987b77b5b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02675184-0ce5-4f08-9d5d-f42987b77b5b@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SEkIxNSiV1jJ20CL6-C0sYFI2LnPE0Ur
X-Proofpoint-ORIG-GUID: SEkIxNSiV1jJ20CL6-C0sYFI2LnPE0Ur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_03,2025-02-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502110044

On Thu, Feb 06, 2025 at 09:12:27AM -0500, Rorie Reyes wrote:

Hi Rorie,

> On 2/6/25 2:40 AM, Alexander Gordeev wrote:
> > On Wed, Feb 05, 2025 at 12:47:55PM -0500, Anthony Krowiak wrote:
> > > > > How this patch is synchronized with the mentioned QEMU series?
> > > > > What is the series status, especially with the comment from Cédric
> > > > > Le Goater [1]?
> > > > > 
> > > > > 1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
...
> > > I don't think that is what Alex was asking. I believe he is asking how the
> > > QEMU and kernel patch series are going to be synchronized.
> > > Given the kernel series changes a value in vfio.h which is used by QEMU, the
> > > two series need to be coordinated since the vfio.h file
> > > used by QEMU can not be updated until the kernel code is available. So these
> > > two sets of code have
> > > to be merged upstream during a merge window. which is different for the
> > > kernel and QEMU. At least I think that is what Alex is asking.
> > Correct.
> > Thanks for the clarification, Anthony!
> 
> Tony, thank you for the back up!
> 
> Alexander, is there anything else you need from my end for clarification?

The original question still stays - is it safe to pull this patch now,
before the corresponding QEMU change is integrated?

Thanks!

