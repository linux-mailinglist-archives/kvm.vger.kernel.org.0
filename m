Return-Path: <kvm+bounces-56676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5C1B41703
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DDDB188CBB6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 07:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8672DEA87;
	Wed,  3 Sep 2025 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T8MxCQ7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8712D7DD7;
	Wed,  3 Sep 2025 07:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756885279; cv=none; b=KyDyKlcfQvD+eoWiTy1NjVlMQICnW7izYC7+u0RbgLuNCm7h3oAQrIFNMi1QaXGenAnCCltin1qStqvSLS8O64CKdE1E5TRuLbc/CkH+TCM/Y3wkHpgXgWd6HuLbB/Ix0RJ5a/vZ1Op1kenrS5EqpJ/IR8lwNWV7f/JgIDvI9X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756885279; c=relaxed/simple;
	bh=poJK77Xodhwk86ZildhqYl2qko4ReuThLBA7bX1xDTU=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=SAVN0DhPiU8qj/CaMCmq6WLehQilDthLZDcutu2K6+8qka3RWAzzYvUqm50SCTn4V9IMZ/UjeWwwshmk9ZQmLOpDS837pPQ9on+qM6Z7oGJijdfCw/Bsa/HCDnNOjEgnMY9b/pHJntGlaqhFpwqlxGrtLr0akL7wRDBkZYukokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T8MxCQ7Y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5835fQUZ000501;
	Wed, 3 Sep 2025 07:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3SYJn+
	YqPvs28dIABwsepKxHMFbi8ujTMi5coQz13cI=; b=T8MxCQ7Y9/mCMd3RgM8jkz
	rexaHgjmm5axP19EQggm3ZWwK5+UiV01VfPY99HXmOgxY1HvSWNs/hf3E/s5W7Vp
	N5E5OIqZbjiabj4BsMrXZwdqPFWh10R5LSJq38x3hp9+QoE+i5t3IbQQGDdpzWbB
	XzgTFedYZ7+LII2AYSvP4fQmpcbsPhPS6fUG63A83bWgChUH3CXSp71zKLeFYZuI
	Jg/p46PvjFyyWq6zWU4qtHBTQQDpQV+7icGtrmVoX1D/PTGU2UUVzgzdwyy2/gsG
	U7CocsnFetuik9cmEIcTqhugE10cUV65vtfgo2EVSsyHOAtsAKs2S3055mygWE2A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48uswdat62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Sep 2025 07:41:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5835U76W017222;
	Wed, 3 Sep 2025 07:41:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48vc10pg14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Sep 2025 07:41:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5837f9wm52429156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Sep 2025 07:41:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3C042004B;
	Wed,  3 Sep 2025 07:41:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBCC120043;
	Wed,  3 Sep 2025 07:41:08 +0000 (GMT)
Received: from darkmoore (unknown [9.111.67.76])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Sep 2025 07:41:08 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 02 Sep 2025 11:22:16 +0200
Message-Id: <DCI7DI3ER63H.38SU2KS4NW8R8@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>, <david@redhat.com>,
        <frankja@linux.ibm.com>, <seiden@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <hca@linux.ibm.com>, <mhartmay@linux.ibm.com>,
        <borntraeger@de.ibm.com>
X-Mailer: aerc 0.20.1
References: <20250825151831.78221-1-imbrenda@linux.ibm.com>
 <20250825151831.78221-3-imbrenda@linux.ibm.com>
In-Reply-To: <20250825151831.78221-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PeP/hjhd c=1 sm=1 tr=0 ts=68b7f119 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=hKoHGS1yLziZwobD-tEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX2VLpBF5QPvpF
 xiYb0ATT55//QiSaPvrIhq27f4GxKNE1fVnv91Gr+OZc9v7rG2aZO4SUjSXZ1IwQthtxZ50iavS
 1GLyjDU9ImddDMNbRaSfL6rQUWBavi3SOaGomF6nubBuiHO1ASnJSqC2WJ4q0ygBRU2JnQQwieN
 ugL+RXshSrwJpeZPxwb3FepsnF6YTEJQZyNS25FiiMO6aRKrgHokxgbb8V/S0Fda/On6L+1Uirg
 9XU/wKglulMgOCI+QE2dlBletOsqWvCoXZgM26pdBP3SEjxi8aOcnHwj2ybOVmGIiVqkgOJPFmt
 mPrzGI/thxw3pcafWBwLM9nCxQf/hRM3+bA+ZHyAZaVYYQOXiraNqpm6a1GtbltSpx5Cmu5FMlF
 3C7KnNN/
X-Proofpoint-GUID: R5Kgp06ZWRe09sfJBmlNj4HLIjgGAXPM
X-Proofpoint-ORIG-GUID: R5Kgp06ZWRe09sfJBmlNj4HLIjgGAXPM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034

On Mon Aug 25, 2025 at 5:18 PM CEST, Claudio Imbrenda wrote:
> Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
> FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
> instead.
>
> This still works because they happen to have the same integer value,
> but it's a mistake, thus the fix.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interru=
pts in KVM")
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Christoph Schlameu=C3=9F <schlameuss@de.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

