Return-Path: <kvm+bounces-35300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A14B8A0BCEB
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:09:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 651B218857A1
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BDD20AF86;
	Mon, 13 Jan 2025 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UAIFBPLD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7470645945;
	Mon, 13 Jan 2025 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736784534; cv=none; b=GDjQ3dRQ2yWS0jbLvcQ7l08Z+QSBaZIBLiD77nUuVXY8Dy/lqCO0kUU6ivWmV5G4YalVXRJmD0QTG7LFncBBV3MaQIXAc8pfpwxS0BIhx8vQO7f2pFnBv7LstHmzlgdERx7VMCVLGcV82AlbGTtNzwc0dxN7M8NDrekeYl36Prk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736784534; c=relaxed/simple;
	bh=JHfgiOVZ3kLPrz6ejjpDxG31jJfV95eh99T19uv51Yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqJGWH0qqMtsIJ6sMS+12Vl4aPxACdNQhEv0oQRpeYNyye3wVzc5MeHl4qSfgshWGmxsP382NmXkEXTyzmX8JU01+v/9/+Mu6pAjaqHbXFxa74SlvL370N48peFyzFVmtayKkXoJjwflpJTV4VQ5wKt8OkGHoLWwDTK7J1AjiYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UAIFBPLD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DF75J9002257;
	Mon, 13 Jan 2025 16:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JHfgiO
	VZ3kLPrz6ejjpDxG31jJfV95eh99T19uv51Yc=; b=UAIFBPLDiJAPw2KEuuDHPU
	A+sq0bkFPMdxnCD6kGa0SdH3Oci3+JikeJ7WfB3ugVOngEECRyyROHKrXNtGVT+W
	lEipQkdWG+lTTQ2AXx+pT+J7sYQaPG8b5ERLWEOpdsL4vIvhzjMTpzWHyUYynIv4
	zRSccM/TgWHmOge/8x0FQ3s2msLTgx0fAq2SvrZYoNklpwmX0/lGhqkyyyxG7scz
	2IHUFdLASCIy1JhPNV/fU4/A4d1wx4CkxhgZAi6go3kGNpynDw+MzgV5BG/t1Zog
	NAesg1/J4XCBJiLEvH8Jl3HvZ3hKnrDZB868eDXwKq6FLncxFHuKMnTrY6hpWvYQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 444uagtwa8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 16:08:50 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50DFi1Ko002666;
	Mon, 13 Jan 2025 16:08:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443bxy2v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 16:08:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50DG8jsp42795418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 16:08:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21D3E20043;
	Mon, 13 Jan 2025 16:08:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CA9720040;
	Mon, 13 Jan 2025 16:08:44 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.0.127])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 13 Jan 2025 16:08:44 +0000 (GMT)
Date: Mon, 13 Jan 2025 17:08:42 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Rorie Reyes <rreyes@linux.ibm.com>,
        Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <Z4U6iu5JidJUxDgX@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250107183645.90082-1-rreyes@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eSx8QjMx2URm8bB67dzCRw1s-UhxAk_6
X-Proofpoint-GUID: eSx8QjMx2URm8bB67dzCRw1s-UhxAk_6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=889
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501130132

On Tue, Jan 07, 2025 at 01:36:45PM -0500, Rorie Reyes wrote:

Hi Rorie, Antony,

> Note that there are corresponding QEMU patches that will be shipped along
> with this patch (see vfio-ap: Report vfio-ap configuration changes) that
> will pick up the eventfd signal.

How this patch is synchronized with the mentioned QEMU series?
What is the series status, especially with the comment from Cédric Le Goater [1]?

1. https://lore.kernel.org/all/20250107184354.91079-1-rreyes@linux.ibm.com/T/#mb0d37909c5f69bdff96289094ac0bad0922a7cce

Thanks!

