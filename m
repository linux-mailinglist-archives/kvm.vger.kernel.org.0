Return-Path: <kvm+bounces-20768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECA991DA01
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22FAD1F21EDC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 08:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D418289C;
	Mon,  1 Jul 2024 08:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VxvXMkaO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D00782877;
	Mon,  1 Jul 2024 08:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719822834; cv=none; b=mjA4eAFDLexQhw60CLmRwcSdWOvQTyl3DZrPmtDIdjLGEr+Eo3L9RaO1HD/+7M9tHjLvXgmAWc+6UzOaPb6ahrfuBaOmg1sRu6oIG/OgOt2985pvva63KjAprlrfq4Hm+TAWo0WrCVq+TurBUguD/gbLQqJoxmzg856CricgDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719822834; c=relaxed/simple;
	bh=DUvmZAXSC7LWWyC2ShVGriO8VN0dKqPKspGZ11bT2rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=epA6wR47ROCwi5ExwXNmvcFLk+lc8wVnA4uxENRYspjg5SrMjiylvjC0h6GGA1PlExSq94n+sXbQTDHVjkYjWkyUjOXItIPLgekoFgO7eGZy2RkNXAD2woKy9u+7UaiyetwGYF5rRddpxhWVLms1uNPOER2ouJ1oA6seFPv8fM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VxvXMkaO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4618SZVr001225;
	Mon, 1 Jul 2024 08:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=pp1; bh=scm1KrP2i24O0KmJ/fFsdpctoMG
	6k1boABvq+LW131M=; b=VxvXMkaOBNKjhhfl7kBEqtyQkj9yPdG+OdLHlpudwRB
	rjOplpINvUzuPsdeUzPAO7BNWuyv7TsijwyusWuvjQ/LZYLILHH7UnutUy++f8IC
	jJU56KdIhsLBG34s77mF1mZBP1K8m81YRJiNtJQm6zhZksZ7aL71eomS0JGsMeum
	lhYU+o3bnSkt8wBmVgN/W/VvINbVoIAYNUxDotOJ1X0NrGLeI+wKPJQgFfGZbbDI
	geCtb6wE35AXEc+3AHAx77QUUHYUcZAFjvGEzdR+khIb3uARnGFici4JkqnqKuRY
	gdXcdMBjQR4weAI+zVuh4Lje/9OPuI22X41tuaEE41g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403ryn00bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 08:33:50 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4617K8sd009076;
	Mon, 1 Jul 2024 08:33:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402w00ed38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 08:33:49 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4618XiGL7340380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 08:33:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 098492004E;
	Mon,  1 Jul 2024 08:33:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72F912004F;
	Mon,  1 Jul 2024 08:33:43 +0000 (GMT)
Received: from osiris (unknown [9.171.74.29])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jul 2024 08:33:43 +0000 (GMT)
Date: Mon, 1 Jul 2024 10:33:41 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] s390/vfio_ccw: Fix target addresses of TIC CCWs
Message-ID: <20240701083341.11462-A-hca@linux.ibm.com>
References: <20240628163738.3643513-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240628163738.3643513-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wOGnOTOl0EwqMj-GF-Yc0wOXQzDsKiY0
X-Proofpoint-GUID: wOGnOTOl0EwqMj-GF-Yc0wOXQzDsKiY0
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_06,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=997
 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407010064

On Fri, Jun 28, 2024 at 06:37:38PM +0200, Eric Farman wrote:
> The processing of a Transfer-In-Channel (TIC) CCW requires locating
> the target of the CCW in the channel program, and updating the
> address to reflect what will actually be sent to hardware.
> 
> An error exists where the 64-bit virtual address is truncated to
> 32-bits (variable "cda") when performing this math. Since s390
> addresses of that size are 31-bits, this leaves that additional
> bit enabled such that the resulting I/O triggers a channel
> program check. This shows up occasionally when booting a KVM
> guest from a passthrough DASD device:
...
> Fixes: bd36cfbbb9e1 ("s390/vfio_ccw_cp: use new address translation helpers")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v2:
>      - [HC] Fix dma32/int warning on make C=1
>      - [HC] Rename cda variable to offset
>      - [HC] Fix similar bug in cp_update_scsw()
>     v1: https://lore.kernel.org/r/20240627200740.373192-1-farman@linux.ibm.com/
> 
>  drivers/s390/cio/vfio_ccw_cp.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

