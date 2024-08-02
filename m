Return-Path: <kvm+bounces-23044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A3D945E90
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE06B284C35
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799241E3CD4;
	Fri,  2 Aug 2024 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hGIA/lph"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB2D1DAC4F;
	Fri,  2 Aug 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604886; cv=none; b=dm7lzcUVf1Bp1ehbAGiOa7dVZmgJEbHUbsNgacQYDF6ry2XqoCmoOUzpohYNjZ1zWnr5zrxEb7EZHAOSFgQRdWQ3dhIzDjXQjzPG+SuRHU20lNI7dAsdUozlmKfcferTlG7tVpgHaiVnYSNRvctsb9aXlbJK9Gj4Lxn72MNn+bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604886; c=relaxed/simple;
	bh=gaxQziG+19kt9tKi4GEgcSthI9LmrKjbFClLOOj+WyA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iU5QZeYFQ8HFkR52s/pdUVLHOTADiK1YcScIIWfHGKdxiVah/LNloMIM2vjPFDN2uhnNTz3fr52qm1HSntGG+iinYrWdgfpyZa/TX+vnPDZA0qZTeFiqBqfOVljLyHAvAez9CiKXSYj8/DWeXFd27Kvoyp95H/c4Mr8iSJSREks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hGIA/lph; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472DJZef015050;
	Fri, 2 Aug 2024 13:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	yJNIzwbN5Ub+RvdYLjR5AUp1pLahK8yIphOQulB3Cog=; b=hGIA/lph5cg+znEO
	NGUiDHQSoE8ymHIOLs0zXaz04kyZQ4tgD+sq7TbhZoAZ3Yv8PhD1JTd7fNhl4K3V
	NwHMEr4jZr+JJ0KmLrpdsU22AfBqgSp9+W4S78BDj1FhtUuvWAqAX9jWxcO4aCV7
	QG2pVXdse9mdSXe9cLHD+6THptLuHjMGSMiDWrx3i30a+RSBg4KtoGikWPSadyss
	BADQSpcw7VFE8Pl4DhwzcD8DyakxZdPx8ZBBO43YDfZRYN9Jb7jgDrqaPtce/CBG
	GRzSHh/Xs03+ycDZ5Y/IUa7BHZa558KT2Ep35SX7+J581VeeXndQYqACvfYCFfy3
	AlZQDA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ru3grq04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 13:21:22 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 472DLMlM018332;
	Fri, 2 Aug 2024 13:21:22 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ru3grpyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 13:21:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 472CPClJ003856;
	Fri, 2 Aug 2024 13:21:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 40ndemy3jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 13:21:21 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 472DLFQv31785242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Aug 2024 13:21:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A81A2004D;
	Fri,  2 Aug 2024 13:21:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CA2C20040;
	Fri,  2 Aug 2024 13:21:15 +0000 (GMT)
Received: from darkmoore (unknown [9.171.84.102])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  2 Aug 2024 13:21:15 +0000 (GMT)
Date: Fri, 2 Aug 2024 15:21:12 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, npiggin@gmail.com, nsg@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: Move SIE assembly into new
 file
Message-ID: <20240802152112.1598d808.schlameuss@linux.ibm.com>
In-Reply-To: <e9cb5130-75dc-4f8f-8b79-c3355896ae1d@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-4-frankja@linux.ibm.com>
	<20240725163408.724e456c.schlameuss@linux.ibm.com>
	<e9cb5130-75dc-4f8f-8b79-c3355896ae1d@linux.ibm.com>
Organization: IBM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v6J5fvQEfoqKqojmNhisDWSZzk0mVAYe
X-Proofpoint-ORIG-GUID: y3Ekla_4grlu429wPYAgKiVq2N342r3C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_08,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408020088

On Fri, 2 Aug 2024 11:33:06 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/25/24 4:34 PM, Christoph Schlameuss wrote:
> > On Thu, 18 Jul 2024 10:50:18 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> In contrast to the other functions in cpu.S it's quite lengthy so
> >> let's split it off.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>   s390x/Makefile             |  2 +-
> >>   s390x/{cpu.S => cpu-sie.S} | 59 +----------------------------------
> >>   s390x/cpu.S                | 64 --------------------------------------
> >>   3 files changed, 2 insertions(+), 123 deletions(-)
> >>   copy s390x/{cpu.S => cpu-sie.S} (56%)  
> > 
> > [...]
> >   
> >> diff --git a/s390x/cpu.S b/s390x/cpu-sie.S
> >> similarity index 56%
> >> copy from s390x/cpu.S
> >> copy to s390x/cpu-sie.S
> >> index 9155b044..9370b5c0 100644
> >> --- a/s390x/cpu.S
> >> +++ b/s390x/cpu-sie.S
> >> @@ -1,6 +1,6 @@
> >>   /* SPDX-License-Identifier: GPL-2.0-only */
> >>   /*
> >> - * s390x assembly library
> >> + * s390x SIE assembly library
> >>    *
> >>    * Copyright (c) 2019 IBM Corp.
> >>    *  
> > 
> > Should we not also update the Copyright here? At least to
> > "Copyright (c) 2019, 2024 IBM Corp."?
> >   
> 
> Why?
> Did I add something important to this file?
> I'm effectively moving code around.
> 

That is how interpreted the copyright rules so far. But I might
absolutely be wrong about that when only moving existing code.
I do agree that this change is only moving the code to a new file.

I would leave this decision up to you.

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>


