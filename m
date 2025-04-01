Return-Path: <kvm+bounces-42296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A33A7764F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 10:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88FA11885B79
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 08:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18251E9B3A;
	Tue,  1 Apr 2025 08:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="St4nbDsC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A0B126C03;
	Tue,  1 Apr 2025 08:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743495859; cv=none; b=efSXaUI7tuIRVq4xFrq87feHbInGAiO2xXphlaL9RyIzOBI7eFVpI2QPDitP+TInceKvTwiZAyNlt86V4Jp/7dU4O8GqSTGJu+Jql9dEd0mK3Hn+2YJy+Y2SKxrBUAEJixN7gyBZen+UL1UtD0Da/mMofsrVT/oAvl1KZUF0QlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743495859; c=relaxed/simple;
	bh=9bg8JE963ebDl+kz9gvUnm5l7+j6XpHxOJuZmSbHKPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFIzBzToXc490bYT4E7Dw6SczyOlM1wMkDo0rsCYfRf2S4uSGJupp72LbpjFPP3A4U62QtLSFiHus27+9DV+xKpq2xK4xpCSoTXybJ/i/sPqguKOW9Hx+GetCg13VnQkeO9GNSqzYGuFUCOYGaVMbKkY9baTAAyhKnlZMdDCOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=St4nbDsC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5316NGY7029331;
	Tue, 1 Apr 2025 08:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KuN6HdO0gerIctf9ee3sQ9CHf8meU3
	/Hiacx5Y7p5UY=; b=St4nbDsCcGTZ2yYy0YOnn6fp5ABc7Fh8netA1YpQjcFVN5
	5JZhL1FtH99JUHHU/Y1DMN8UwQ+b4PXomKzhlhCoYG2LbuYJNDNulJPs5CI4SBBP
	hDF/pMZaoj6pfG31U57S3c4r0gbajQ7DF+FvBw7fNVtoVU1O1D7yLlTG2hfvAVvG
	quM+dRWo9fmreUkqbzNteaGIcb9ocKhr6COQes+mDkwSfCvI3d2TXBM/lcW4fKam
	z/NYXbUNae9BIpxnNi0cL129oMtHmglUkpNZFAh+7gsDOcZa0Ol7r6iVJIsrtqBo
	3IAI+YRiDZj0hLk8OTja9EB1/70ZZvMRDxTWnDOg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45qy7xba57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 08:24:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5315hBE1005431;
	Tue, 1 Apr 2025 08:24:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45pww29a32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 08:24:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5318OBwQ41091576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Apr 2025 08:24:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A196C20040;
	Tue,  1 Apr 2025 08:24:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87CB82004B;
	Tue,  1 Apr 2025 08:24:11 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  1 Apr 2025 08:24:11 +0000 (GMT)
Date: Tue, 1 Apr 2025 10:24:10 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gor@linux.ibm.com
Subject: Re: [PATCH v2] s390/vio-ap: Fix no AP queue sharing allowed message
 written to kernel log
Message-ID: <20250401082410.7691A4a-hca@linux.ibm.com>
References: <20250311103304.1539188-1-akrowiak@linux.ibm.com>
 <156b71cf-b94f-4fa0-a149-62bb8c2a797b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156b71cf-b94f-4fa0-a149-62bb8c2a797b@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WAteCHon0117U6igZbU1rI62dPkoyrzi
X-Proofpoint-GUID: WAteCHon0117U6igZbU1rI62dPkoyrzi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_03,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 mlxlogscore=738 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504010051

On Mon, Mar 31, 2025 at 06:22:42PM -0400, Anthony Krowiak wrote:
> 
> Gentlemen,
> 
> I got some review comments from Heiko for v1 and implemented his suggested
> changes. I have not heard from anyone else, but I think if Heiko agrees that
> the changes are sufficient, I think this can go upstream via the s390 tree.
> What say you?
> 
> Kind regards,
> Tony Krowiak

Applied, with subject fixed, and some minor coding style fixes.
Thanks!

