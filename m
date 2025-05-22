Return-Path: <kvm+bounces-47397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93373AC137C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F02311BA6920
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 18:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8C51D54D8;
	Thu, 22 May 2025 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hrIqrLg9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA961754B;
	Thu, 22 May 2025 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747939221; cv=none; b=jvgrG4QdepBBAOt8nRJnMdhqJFX2ImJsjjuXx6eqV/tCv3wYNwb0tviW6yYN2wXD27HhzQH3Vnwa5KBRHOFwOzmMbyFcgOSf6HE/0l2EHDRdLptbWKG5J2ADZMEUA+ihHVYSJ4i0hDyggvfNdPGZcBBvrGpffWcqT8v/3PxxLbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747939221; c=relaxed/simple;
	bh=AFofXElkAhmkpRFDBLFw9vKz74c/zXyf0JT7/zM93ok=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To:
	 References:In-Reply-To; b=OO+pPq9mrshzYi+LE3Ehtxd40k0pWrgE9mMFYFcGoRxFJhg3cN5n4ovC+uIwpRS6ysx/zfoQGCOULyctKG50lrZN0gkdxHN33MaDAJuP6+FsvL2abhuV5lvJYBOllOXPQnns3jp4P0s7dcC218i3+aOp6e4rrzZ3RoO0G+q/4j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hrIqrLg9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54MGVmds003213;
	Thu, 22 May 2025 18:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ICRlwm
	OFBVmYXPqHcJNlglcgxxegBefmUdMKnvYmHfQ=; b=hrIqrLg93L/fYcUYCloC0Z
	Z4g5Do5wYa0lNJTrUe6RSoCT7iDF5iZi/Orz4wI6Tlzqh7lrczfQInizNpVwWclO
	GXI8ruMGvGdPI7/9An75Igf8+i2Pm/pQn1UAveuSs2+xQi5hdSS1HqOqHb8LHtxP
	XRmWFLItMMawvSQvs7vltKofWr2HJFdHgMpfZrn0bPVhvZwXGlFDeNPBJsXaSAzY
	dZBFU5jxGw3RPP0WmV6V5i6VtfBic9QHYAuQitUaWoG4bGysA6joADLiWNzHV+Zk
	ptHCjClzwRMYiEmEueMjXcBPwfO89O3iRzIdO8WQi3wn8i5yJZP3k1EOqU2ImeiQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh75v4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 18:40:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MHMGZF024617;
	Thu, 22 May 2025 18:40:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwkras24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 18:40:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MIeAA833882860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 18:40:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E056E2004B;
	Thu, 22 May 2025 18:40:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB90820043;
	Thu, 22 May 2025 18:40:10 +0000 (GMT)
Received: from darkmoore (unknown [9.111.55.188])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 18:40:10 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 May 2025 20:40:05 +0200
Message-Id: <DA2WQHJVQTVF.I7EBYCRLLWEW@linux.ibm.com>
Subject: Re: [PATCH v3 4/4] KVM: s390: simplify and move pv code
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <seiden@linux.ibm.com>, <nsg@linux.ibm.com>, <nrb@linux.ibm.com>,
        <david@redhat.com>, <hca@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>, <gor@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-5-imbrenda@linux.ibm.com>
In-Reply-To: <20250522132259.167708-5-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDE4NyBTYWx0ZWRfX5wQFowz08rK0 GJp/+ixhDHecRSLfJ953MhkmwvfuCyVvY35MGLmwkp4yyX04iC0Scl6CUIlCNep0t4N3jpkG7+4 hmVeRIPRN5Pzt0Wcx4qKQ6Dj+aPrdjlV1L3tGtm8BDCZ0tfxIx43RyYs80ENAaqvHpjU5pfQ0kP
 3pnyotPXkVEp6Ocve1uLQpVBCXG4pEeM+zYIb6eccGXEE0flxGBVx1IF832Np5XL56G354Az71D 8QWXP9LBkN7xN9lypmJc7U5QR5nWoysZi3HFKQCgGgMa3NMZwSgNJfHw75+Px8f5HKV4VwOtPLu ekAbxcFjuD8EYF7MJST3pgmVJs9NxRyd0nUr5MMS1InpYmdI07KtqUHRXtPbPhlsrBMi9MWMDnL
 VdpgeGCVtIe5rEGngnfm9riCKSKghfEz3pQqUrj09Fzv+9LB1i3+iMNtwWScxbn4R2zyA5GS
X-Proofpoint-GUID: 7a5pZeJ1Btroad3V3ZtnIG-CM8hjPiWa
X-Proofpoint-ORIG-GUID: 7a5pZeJ1Btroad3V3ZtnIG-CM8hjPiWa
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682f6f90 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w2SwtR9liJ8HvoPeYG4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_09,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=753
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220187

On Thu May 22, 2025 at 3:22 PM CEST, Claudio Imbrenda wrote:
> All functions in kvm/gmap.c fit better in kvm/pv.c instead.
> Move and rename them appropriately, then delete the now empty
> kvm/gmap.c and kvm/gmap.h.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kernel/uv.c     |  12 ++--
>  arch/s390/kvm/Makefile    |   2 +-
>  arch/s390/kvm/gaccess.c   |   3 +-
>  arch/s390/kvm/gmap-vsie.c |   1 -
>  arch/s390/kvm/gmap.c      | 121 --------------------------------------
>  arch/s390/kvm/gmap.h      |  39 ------------
>  arch/s390/kvm/intercept.c |  10 +---
>  arch/s390/kvm/kvm-s390.c  |   5 +-
>  arch/s390/kvm/kvm-s390.h  |  42 +++++++++++++
>  arch/s390/kvm/pv.c        |  61 ++++++++++++++++++-
>  arch/s390/kvm/vsie.c      |  19 +++++-
>  11 files changed, 133 insertions(+), 182 deletions(-)
>  delete mode 100644 arch/s390/kvm/gmap.c
>  delete mode 100644 arch/s390/kvm/gmap.h

