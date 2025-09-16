Return-Path: <kvm+bounces-57758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0FAB59E33
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25012580C2F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EB53016E8;
	Tue, 16 Sep 2025 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l4GGmeFZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDFF2F260A;
	Tue, 16 Sep 2025 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041268; cv=none; b=Cu9zr4/XZXsHQQEWOU2Ea1vUWUjwYGcdx82tAMubIAbiEW2KXCoJ0qghIb/Ha+tHN3UE7NEdw2pFGCmEEcIi2rNV+oI3xxqZPKbVIBDK86YOaYKXFUl9j323VvaC9p/ShwZHtgQ0nrEfHJM6TCoHPrNG7xuuBhcjGYLyBXe8nZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041268; c=relaxed/simple;
	bh=fj0IVPb/SwPHuOK8W79P/MytQ8xewjyteJZ6se+YbsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EAWDJlB4xM+swJ/bv0iENUtGGgYgGCOksLsmJsQkoROOKgfnpdX94UM8VmzqVmU46/GkzWpK/ZtintvaFf1bF709uKfkKWOpTMDLungVc1F88eiReQJbEnBZ3G3RlZpted6pzLbnbMEyz0C9UjXwuLpBZxYvkKig5/V6zBUUeAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l4GGmeFZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEW7aZ008844;
	Tue, 16 Sep 2025 16:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=udpsgbYJheIjhUUrXdzl0U6zrZ59HY
	dqlINwbgYQ0OQ=; b=l4GGmeFZ+Q6oLOl+kAauBuJFUzmlyF3IePlLh0UD97Tlvw
	HYCk1slJQM1HBGDFTi7lABizEVTjK35zOY5vm+p0nZcxQBMlyEDNZwRCJ2/pEIW5
	OAgM0EBWZKgfzYvi8MlOhJ4NKtHLTr+ZibjwGQ9vWjtCC33WLQmw1gneBo2yAeeV
	pmJY6nOsHYj67tJt1d2LQHpP62zZFTppiP1H1vsnDjnKEScrogDXIaZ1U+e1q4O+
	6wA9QymARku5YEDflA3CsAWRIB7N9LuvMMNpXjA/gY7umwz6C0pNOPrw3oSnYQkC
	Z/dZ7Qdt4Rk05j/UTVP3GqoYYkLGkiXuWb+75AFQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509yarau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:47:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GDvl4P029817;
	Tue, 16 Sep 2025 16:47:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb0w4bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:47:37 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GGlXgi55640432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:47:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51E9C2004B;
	Tue, 16 Sep 2025 16:47:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BABF42004D;
	Tue, 16 Sep 2025 16:47:32 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 16:47:32 +0000 (GMT)
Date: Tue, 16 Sep 2025 18:47:31 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 09/20] KVM: s390: KVM page table management functions:
 clear and replace
Message-ID: <20250916164731.27229Haa-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-10-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-10-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyMCBTYWx0ZWRfX8SOCkxV4vj3I
 ed/b7pgMwgVuzjogvqv8P/5mS2fy23kUePvHx9FadGt5pmzhoHcOZMm8nxPvK3UJpF+86DIMovU
 0A753zMxCcm6mFrD59e/HHFeIUn3D1/C/P9enDZWhNmKuz8NLomLaDz4WAC4WxfAmrSwoeNgnt0
 OJECEJAv2+Q+8vjRzaHpEHE2ZEBXooNcVCJnU0W2FBfW3/TLJskSJhN3IawmIiSvOIyAvEqudME
 lS6tBm7ODftEJC4ZeOKtULeUGQysEFjwfLHtX2dEcxnu4IVQT+47WOz8Nrww3T9aM6tuCqQHKm3
 5ZLhNgMKlViqjwPjxJwH/O5K/u+Plg8fswQWugN6R3tJf603p39hMoKmCdvPAj8yNGxOBObVpB/
 CWedwYaf
X-Authority-Analysis: v=2.4 cv=OPYn3TaB c=1 sm=1 tr=0 ts=68c994aa cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=MAvXTjdga-6Jqg6AyVUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: J2fe9z77Z-S93UXGnE6H8ee-kglnbUZ-
X-Proofpoint-ORIG-GUID: J2fe9z77Z-S93UXGnE6H8ee-kglnbUZ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130020

On Wed, Sep 10, 2025 at 08:07:35PM +0200, Claudio Imbrenda wrote:
> Add page table management functions to be used for KVM guest (gmap)
> page tables.
> 
> This patch adds functions to clear, replace or exchange DAT table
> entries.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/dat.c | 120 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/dat.h |  40 +++++++++++++++
>  2 files changed, 160 insertions(+)

...

> +bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
> +			    union asce asce)
> +{
> +	if (old.h.i)
> +		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
> +	if (cpu_has_edat2())
> +		return crdte_crste(crstep, old, new, gfn, asce);
> +	if (cpu_has_idte())
> +		return cspg_crste(crstep, old, new);

FWIW, CSPG is present if EDAT1 is installed. So this should be
cpu_has_edat1() instead, I would guess.

