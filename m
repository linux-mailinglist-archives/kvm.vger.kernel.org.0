Return-Path: <kvm+bounces-38457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 201EBA3A2FE
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89FE3168345
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AAE26E65D;
	Tue, 18 Feb 2025 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VEMKe/Zo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BCF24336D;
	Tue, 18 Feb 2025 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896723; cv=none; b=Y89r5okxjDYgefXMjy9pmcf8xPmqzeN8DpUU+JXDlBrWUCYHsqTGYpLUZimDE/OROp77TTCapJv0zd/5kNPtqPYxNOYSokfAx1y6OPglLviT+Z1QNa3iQQ2oZ6X8x7nLzQiHx/Aypv/JThioQk3D1mFHVHDOcRpqaRWR3auQHME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896723; c=relaxed/simple;
	bh=Jr2XeqFa7wILBc9ajjjmwJuulxiR+E1gLDxz38v3qMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUC5MxBUOwvxtUBsAz7Oj/25doVEQqFIE4Hfk2VmxSkqLUNvwmkL80BZ/+nm/lPmpo8s8VWTRMwtl1LHwy7mkozrkMGcwk7jUicGUIBroJneANagnlVjFRRVAy4YvHOnMW1VApr6AZYNVzwdnkPjVEf1Ej1E1nJ4PSIeLskUIVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VEMKe/Zo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ICsfkP000995;
	Tue, 18 Feb 2025 16:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5Nl9G0E+MY+LQNb1Fl4PTgZed9Nw1L
	2PXWSuck02l9w=; b=VEMKe/Zo2B3H4e41q1f6ievffRcJJAgMA14Rse9Uxz8Ask
	eFIslL/t1QATbfRoceJxlt6Nb8iKeF21hL96rP9YKj8HrK1Je562WxBKFMLsDFew
	SC55tChO4wolxWYmjTjlD/T+lN/ITQtUG3xXDQDhWRQZTSpFJm9v+6m1mToSLADw
	5hrCw+tcsGf3YLvGpgQfT8oU1wKMmgAgxqoGvJycx0zSJ15lveBTbiQxcz0LjrVw
	/37zHdy0OaDpfb7jbiiMIi22oCeyoAys08DwBVZPZ9Z3y8uATg1w5I/H0dpusI0Z
	k1kBF77mlmImXGIkjW3ix0SBwwf6iIkiJwv6Kcxg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44vh203rwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Feb 2025 16:38:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51IDQadB001641;
	Tue, 18 Feb 2025 16:38:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44u5myv9d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Feb 2025 16:38:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51IGc96Z47645152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 16:38:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D00B20043;
	Tue, 18 Feb 2025 16:38:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B75C20040;
	Tue, 18 Feb 2025 16:38:08 +0000 (GMT)
Received: from localhost (unknown [9.179.25.213])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Feb 2025 16:38:08 +0000 (GMT)
Date: Tue, 18 Feb 2025 17:38:06 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Subject: Re: [PATCH 0/2] s390/vfio-*: make mdev_types unlike a fake flex array
Message-ID: <your-ad-here.call-01739896686-ext-9687@work.hours>
References: <20250217100614.3043620-1-pasic@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250217100614.3043620-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pmzFKryF_fYebefZeqqwO3X7z98vGZJn
X-Proofpoint-ORIG-GUID: pmzFKryF_fYebefZeqqwO3X7z98vGZJn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_08,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxlogscore=231
 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502180119

On Mon, Feb 17, 2025 at 11:06:12AM +0100, Halil Pasic wrote:
> 
> One sized trailing array members can look like fake flex arrays and
> confuse people. Let us try to make the mdev_types member of the parent
> devices in vfio-ap and vfio-ccw less confusing.
> 
> 
> Halil Pasic (2):
>   s390/vfio-ap: make mdev_types not look like a fake flex array
>   s390/vfio-ccw: make mdev_types not look like a fake flex array
> 
>  drivers/s390/cio/vfio_ccw_drv.c       | 6 +++---
>  drivers/s390/cio/vfio_ccw_private.h   | 2 +-
>  drivers/s390/crypto/vfio_ap_ops.c     | 4 ++--
>  drivers/s390/crypto/vfio_ap_private.h | 2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)

Applied, thank you!

