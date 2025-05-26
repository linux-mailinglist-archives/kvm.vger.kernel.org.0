Return-Path: <kvm+bounces-47680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE790AC3BB7
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:29:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5674B1895336
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512A91E520F;
	Mon, 26 May 2025 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dP0lau5M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C421198E81;
	Mon, 26 May 2025 08:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748248131; cv=none; b=QFPdvUx7Ax71zHJQLjWcF7Yhg7ib8zQOEGbGHL737DGoGe3p5hHMqfLKyxTfHOy6uqKUSZMWh8Mv0o/idkJ+JpG8a2esYrSt3NZqudnYrHJTv5uKpmgV8BHsWlmecUWOynqLkZVLe8hz9RQFRO+S+3PQX8KvV6y44OYpPKbCxz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748248131; c=relaxed/simple;
	bh=R/mh6Zul9ir7yyGc3dY7ZlTq7zWtuvIib1tyCskeWX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlkdPPqFhkSdF1tmOzyWC+6Yv7XKQxY4R+rsNN5mr4y24huPQtBNsAbBD+6D1LQp3BFOWnEIPvWsRtJBIggonzzLqHFeZii9KRZ8giDOHyIqeURAb69ZbX/robQHMk5EKtesRnjLZJxwQr7OxFV52SFzRSlZ4rcYuGF1drlytRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dP0lau5M; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54PNIw2x004992;
	Mon, 26 May 2025 08:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UfGDp6cM5QSoaUR5RyKlw8Qo+AeCPo
	zfCu0VyqhsXJk=; b=dP0lau5MFoIUozB3UZt+1X04xRY1KNVTsk2+C6lK0zeoSL
	F4HgzxG2izg1J2KtxapEX2cufdKwJC9AZqpNZOzYix2r+fefcSHhSRa9k9rA5pmV
	oCGUxba/KkMGTUILea//yA2v/bLjTnDQpemfHDULgFXWYpfTNqumgOXNzD0m4Cqo
	hUKAg/f85841UHbYMSfVN5cLgQ7ysYbnNW6DxaPOXIJ+4NkIVCmN4ltEg6ryiF18
	KKqiIHl1i8KquF2f4uyFPrmkuc8ZKg6KLm8LeHnqv0hD9jVjznYO5tT32aHviDHP
	no5ue3ZiKrFcJ8K7p8P3wUG6AAxnTfs7ToM5xvEQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u5t0g3pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 08:28:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q7lwZV010712;
	Mon, 26 May 2025 08:28:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46uru0den1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 08:28:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54Q8Sfp639452968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 08:28:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7C5820049;
	Mon, 26 May 2025 08:28:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28DAB20040;
	Mon, 26 May 2025 08:28:41 +0000 (GMT)
Received: from osiris (unknown [9.111.60.222])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 May 2025 08:28:41 +0000 (GMT)
Date: Mon, 26 May 2025 10:28:39 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v4 1/4] s390: remove unneeded includes
Message-ID: <20250526082839.13937B8b-hca@linux.ibm.com>
References: <20250523130348.247446-1-imbrenda@linux.ibm.com>
 <20250523130348.247446-2-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523130348.247446-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDA2MiBTYWx0ZWRfX5RLdyH5SEKvp 6UVaPuqxdpG+j92dOLnaHsGk1ZcyEVKpH8L0IDYZMlCejwdZq9780syCEqXE0xOwDKzvy1XqJIL 1SQW86scc62OKci4P3ku1SCeD/1u8vouIGOK+UD09n08iRBNYKwfARRB68JUfGc5pD0LTwzvfWN
 rKu9CC5S8y+IxBBYfceDf3j8Hp0Xzt01XWpKLC+CvENaBMnoni9Gj8Fn7dFDnoDpKAOUfBdNEAT 4Wv0WsQavA51G4KQRTp8t/h8MpZ8BsFsXhgivlp4KCSVbnn2Oi5fA97R/GQM9qSCFNgsmt8HSoM tDQ9VXZ7a+CUOAcpUf6yjBPa9lEbpEkpNGpdPqereJfli0sJGp5ozZw8CpubHOLvyBoESkt1VJe
 IrOiDRHF7NiL581n9yZ/tEecOJPPNbbvFKGystaYnacpFLSqhjuFU0IMx0dwXW6xNKqBQZ2r
X-Authority-Analysis: v=2.4 cv=INACChvG c=1 sm=1 tr=0 ts=6834263f cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=BorKYyAo29sJGMwN-gMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Hk57UNPgzIm7SiruqINlBRreqaQVUxcc
X-Proofpoint-GUID: Hk57UNPgzIm7SiruqINlBRreqaQVUxcc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=637 priorityscore=1501
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260062

On Fri, May 23, 2025 at 03:03:45PM +0200, Claudio Imbrenda wrote:
> Many files don't need to include asm/tlb.h or asm/gmap.h.
> On the other hand, asm/tlb.h does need to include asm/gmap.h.
> 
> Remove all unneeded includes so that asm/tlb.h is not directly used by
> s390 arch code anymore. Remove asm/gmap.h from a few other files as
> well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/include/asm/tlb.h | 1 +
>  arch/s390/include/asm/uv.h  | 1 -
>  arch/s390/kvm/intercept.c   | 1 +
>  arch/s390/mm/fault.c        | 1 -
>  arch/s390/mm/gmap.c         | 1 -
>  arch/s390/mm/init.c         | 1 -
>  arch/s390/mm/pgalloc.c      | 2 --
>  arch/s390/mm/pgtable.c      | 1 -
>  8 files changed, 2 insertions(+), 7 deletions(-)

Please change the subject so the first character after "s390: " is an
upper case character, like it is supposed to be the case for all s390
related patches. For "KVM: s390:" there seems to be no consistent
rule, but that's your playground.

Anyway:
Acked-by: Heiko Carstens <hca@linux.ibm.com>

