Return-Path: <kvm+bounces-29270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 382719A60AC
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE16628476B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68B11E4113;
	Mon, 21 Oct 2024 09:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nKXBgP7+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3985F1E32CC;
	Mon, 21 Oct 2024 09:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729504263; cv=none; b=SnrlvZqHVZ/wOxw9mMCg8kRCkQaFX+rnanbb9/In3aQ8R8Nnw4+YdLpRHybZDTWJLLvhxiK2u/0YwBDhmL0bTHAwbA4nh1I9R7CLP9EtAQgQcL3uAqGsNb6MwfjjAxjgK1oDiVC0umSYuTqNoagnRDsh9EWaw9L1vnbn3aBv6Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729504263; c=relaxed/simple;
	bh=ZfeOH7rYOlevYzT5SzGyHIjuXCx9BtiO7m4trFmlIRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYA1D2jFGUj2OEUzCiU71CkhM5xg/m1fptf/nvE42YZhLyfM59RAZOIqyQU81d2c6UKSlcwzmqwlpObxh18fffgiT5oEOse1cBQjsODFhCwP46A584/dfTy0ACQSY5t/oYbc8/gpfUrJcwsqT9OKr13IUaXlUQzFipgznoCWGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nKXBgP7+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2KIxW032571;
	Mon, 21 Oct 2024 09:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=GXIGiW8JBg082T38K2vrQgy8xxzE2l
	iAugbLGCj+vs4=; b=nKXBgP7+AUY0u7OHwIwXkBg39NAyYP1/rwfAtI/Zlztw6j
	WkWh7LAu9gG5EglglwSDQvrUvHmQr4duGbMAOqjQPiFlj4b6NHuFyPeAjSQyv1wY
	M1dnNXsO0rkdLrsWmh/rA24EgkgE24xHfihbpsZp8v4GxsRGk/7VfSxbZm1EE/ni
	MzGWRRTSvOD6TypvmY6IIVbC6HCTAA+el4R49CrFog9Irxz4Phv2G0d7ReavNM4Z
	liVQESbd49AzJaRYVP//0mV3nRt13vXJ3kn5jd2nthELYgJ49w9OpjHqEukbnufX
	M6Do7aASdXqnPj3IvjdmuoHBoKrczz0Ho5b1mD1A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5hm8dbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:51:01 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L9MY6I023825;
	Mon, 21 Oct 2024 09:51:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cst0w9yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:51:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49L9ou5C45023690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 09:50:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF24E20049;
	Mon, 21 Oct 2024 09:50:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46E1220040;
	Mon, 21 Oct 2024 09:50:56 +0000 (GMT)
Received: from osiris (unknown [9.171.37.192])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Oct 2024 09:50:56 +0000 (GMT)
Date: Mon, 21 Oct 2024 11:50:54 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 08/11] s390: Remove gmap pointer from lowcore
Message-ID: <20241021095054.6950-D-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
 <20241015164326.124987-9-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015164326.124987-9-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LAgR44xM_4-I_V0jz4p7YYLe9W7vwIaG
X-Proofpoint-GUID: LAgR44xM_4-I_V0jz4p7YYLe9W7vwIaG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=591 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210068

On Tue, Oct 15, 2024 at 06:43:23PM +0200, Claudio Imbrenda wrote:
> Remove the gmap pointer from lowcore, since it is not used anymore.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/include/asm/lowcore.h | 3 +--
>  arch/s390/kernel/asm-offsets.c  | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

