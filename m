Return-Path: <kvm+bounces-37453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C78BBA2A284
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7B401889820
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0F0225406;
	Thu,  6 Feb 2025 07:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="otZRwA0X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AE72144A8;
	Thu,  6 Feb 2025 07:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827659; cv=none; b=OFVxmfODV9ID00P+ZkWBHKd7n922pvB34Tle++THRq33uBd/V5Vn8fbm04tnJCfoNDmWHmLDdBFqAe8aN4ADzFIESQhYhz4ELLxeeNGeX+Z/FTrZM76DJHlOb80CiRLX0cdw4vaHBpTuxb5T0up58DqLCCHiXk5B0wavCZVua40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827659; c=relaxed/simple;
	bh=rznXd4x1zW1//N/BsvDJtIAkg2PEYTFKtcqRLhHYAI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7mrdtIEkwd/bUYz/AcLX2qXb5kt2Zlflpvio1ISNE90MvRjpDIhDd1CTNFGMdMxzHb8Xm6uSnoVqKfrKLmO5wLDQPWFMkp8ZWTd7xPYbhSeAYQ86fZ2MMcUjoyTl2vj87cTV2PMVOyaub04Y4EnhuK94a1EcUJ86Enx2xYZzHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=otZRwA0X; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5167XcIe006184;
	Thu, 6 Feb 2025 07:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BZQGey
	7aq0bOIsiLZo/USNAPvLQFjQQ8oT67LMfXifo=; b=otZRwA0XJUW+/h+Ac1USfU
	UdeCj+jvK5yeJ4m18jsBDDLls0FzuvKj6pMCy1UXPB6IEX3tmhnMRxRMtMHIrrQD
	nS9U13aOuphUtYa6iT43KZJ12ydpbz2/L44C/LlMlMJ8Rs+qfrlVUt0g++BOMpJ1
	PVM0GQb/KSlewjDm3gFnFyylNgWrXQ1PwJZMjd343+08Gu0Qn0oEg6hJe5IuMLRI
	jnAPusdAJ270y+XInxlWjO6SQgR/FrGSaGR2cacopLoul/sMAGDLDhEpSMsxmTS2
	us3ZP+XDXZqjCAot8yR8fzEar9qoAtww3hHNGiOKBr3Pce3VSoJU0zmgYO4DbHmA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mrsp010x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 07:40:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5167DH0K016416;
	Thu, 6 Feb 2025 07:40:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxsnaf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 07:40:52 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5167enaZ46072166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 07:40:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 392B020218;
	Thu,  6 Feb 2025 07:40:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC36F20217;
	Thu,  6 Feb 2025 07:40:48 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.15.176])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  6 Feb 2025 07:40:48 +0000 (GMT)
Date: Thu, 6 Feb 2025 08:40:47 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <Z6RnfwawWop0v1CW@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <f69bba4b-a97e-4166-9ce1-c8a2ad634696@linux.ibm.com>
 <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1af50b3-f966-445d-ab89-3d213f55b93a@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fqtzxi7VF_dh9dJf88Qgv9YE_uAhhBV4
X-Proofpoint-ORIG-GUID: fqtzxi7VF_dh9dJf88Qgv9YE_uAhhBV4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_01,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502060061

On Wed, Feb 05, 2025 at 12:47:55PM -0500, Anthony Krowiak wrote:
> > > How this patch is synchronized with the mentioned QEMU series?
> > > What is the series status, especially with the comment from Cédric
> > > Le Goater [1]?
> > > 
> > > 1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce
...
> > Hey Alex, sorry for the long delay. This patch is synchronized with the
> > QEMU series by registering an event notifier handler to process AP
> > configuration
> > 
> > change events. This is done by queuing the event and generating a CRW.
> > The series status is currently going through a v2 RFC after implementing
> > changes
> > 
> > requested by Cedric and Tony.
> > 
> > Let me know if there's anything else you're concerned with
> > 
> > Thanks!
> 
> I don't think that is what Alex was asking. I believe he is asking how the
> QEMU and kernel patch series are going to be synchronized.
> Given the kernel series changes a value in vfio.h which is used by QEMU, the
> two series need to be coordinated since the vfio.h file
> used by QEMU can not be updated until the kernel code is available. So these
> two sets of code have
> to be merged upstream during a merge window. which is different for the
> kernel and QEMU. At least I think that is what Alex is asking.

Correct.
Thanks for the clarification, Anthony!

