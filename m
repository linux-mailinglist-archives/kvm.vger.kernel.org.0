Return-Path: <kvm+bounces-62994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D821CC56B19
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:53:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 990773BAD3E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E822DECB9;
	Thu, 13 Nov 2025 09:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WxmujwFi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8876F191F98;
	Thu, 13 Nov 2025 09:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763027218; cv=none; b=QzUXeNRV1l9fxGrwfVQF7nbYK+FEuyzMkBZwtgoHW4cKglZz2UmskUFnd4tElSRQYtUW4liS4AL+eyHE4RD6OqGJ/RXCf0YUumU8Fc/ReMY9UPPltSvtvsXiR0xrOwXANJhBfwtsj55NfHXFiwe+gXokl3LrI/3S9y9Y95Obm4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763027218; c=relaxed/simple;
	bh=BrF7KV9vM3iWbrGyla0n5tBW2SqeBqkbRM4DSGaR4cc=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=oO74aD6JhhPnKMdl3aHb8zIJNiBonCoMrdHsrdMYxk+z9PCk/w+/BromID1L5E/MO25nHR/F8du/hOmq65cM8sI57iqcMRzp+WmRvcT8l9gbm0gNFZvT5l5Hdyr9jHHKdhHovviFKzCMJErlJ87JoGeGxm77eQJZRtMpYQa7eHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WxmujwFi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD3FpCq003733;
	Thu, 13 Nov 2025 09:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Gw60Xn
	TtTR5az3nS7A6jWR6aux7N3lgFOy6HZnA2UPo=; b=WxmujwFibhqpShydKgHQKy
	N+k/lQGKjbzM/axYHoUBI1Do+c7yrhJx3jUhrffcDngEqkXz9qEJMMqqU2gC/9U6
	RnvR1PT8jNG5QiupPKPJdqVCHdwIpmeVrgkXDQa4ZSbyNxJo6DarGXOb3MEfwWuD
	BdeqbS0IBw032qE98SoH+4n/jjXRUiTBn18am7A6JrA1HqUic6NjP2WiBYK/2UBc
	aRKKqO7oW1ODdXd8iBDxo4JMsUp7I3cRFdzxmTTc0T5rRNyMAAHiYOBBWbwq94R3
	N0hiQprsi9x+rtvjwz2IPGPvYLghAfj3YwjXXh89n+ENX8X3MaBQHtrOCDzR9wUg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cje0r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 09:46:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD978RK008193;
	Thu, 13 Nov 2025 09:46:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aah6n53f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 09:46:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AD9kmmi42271050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 09:46:48 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B8E52004B;
	Thu, 13 Nov 2025 09:46:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45D2E20040;
	Thu, 13 Nov 2025 09:46:48 +0000 (GMT)
Received: from darkmoore (unknown [9.111.1.139])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Nov 2025 09:46:48 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Nov 2025 10:46:42 +0100
Message-Id: <DE7GZFXIC55G.756F85AT78FI@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@redhat.com>,
        <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/23] KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
X-Mailer: aerc 0.21.0
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-6-imbrenda@linux.ibm.com>
In-Reply-To: <20251106161117.350395-6-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=6915a90e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=i86kpRh-DkRGr5TmzxkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX9MrfPiiZ0nm6
 7lRUu6igdO9I57JkSAmSaCwgUq19nWrOgh5TSIR7W6n+gXekQvVAdxXM48naFi5vhS6EhwTvoj2
 gIN0zLPeTkcLBtJIqecxwHcCUzU57ZfUcSn3h21wzphBNGaGgEjRpUraTCC8wtQlEj7hE4xhSba
 Wdu/VgjHIXoqaBpr2lTFRhCIZ3Soy+ZxnQwUEO0AkqJVbuK7lk5XxxbyQYV96NKIPu7JanjNy0D
 r1okIDo0nltirbEXtRc+OEIv8v8+/piJfWx9npFcR1B/16k2k/5ee9w/jV/0e37m4ShWxD43+S6
 hHwGO41jHMeCeECDzE66uA2eNy1UXjWkZSaFxraShhjm4kVaDfdGK/PudN7FFlLi6YlySsn0tme
 UgtyGFjR9+6GmKTth+9DtHv+xp+YEg==
X-Proofpoint-GUID: fv1F60HAnCH-YoQUgMt_Riv6eie-PAxB
X-Proofpoint-ORIG-GUID: fv1F60HAnCH-YoQUgMt_Riv6eie-PAxB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_01,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

On Thu Nov 6, 2025 at 5:10 PM CET, Claudio Imbrenda wrote:
> Enable KVM_GENERIC_MMU_NOTIFIER, for now with empty placeholder callbacks=
.
>
> Also enable KVM_MMU_LOCKLESS_AGING and define KVM_HAVE_MMU_RWLOCK.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/kvm/Kconfig            |  3 ++-
>  arch/s390/kvm/kvm-s390.c         | 45 +++++++++++++++++++++++++++++++-
>  3 files changed, 47 insertions(+), 2 deletions(-)
>
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index c2ba3d4398c5..f5f87dae0dd9 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h

