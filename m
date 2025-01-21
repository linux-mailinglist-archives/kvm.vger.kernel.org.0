Return-Path: <kvm+bounces-36124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DF0A180D5
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:12:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BA5C188497E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA391F4282;
	Tue, 21 Jan 2025 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BsnM74gO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FAA1F37D8;
	Tue, 21 Jan 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737472332; cv=none; b=kUMnsovSC6EDaa13uqWWpDx+MjAoNL5wZxrWKauSyLYgHI4oR3PfRPVqhdlvMpDRctczKL12wjZH4iSUqjxy1gMmunPU+qeGk90yijJKs/RMpHxZvZ75QJ2xJ0TetOvnmFjU12t0i4pVrw5dNO4AOVvBPTcmTfebmuBALsxagkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737472332; c=relaxed/simple;
	bh=iNHn+qMSUtgr+X956ZogUa4B4ToZNVhgGcSdCr3UJP4=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=PnOiOVIjrcypAl0c2IrFq+MmVhEmeURH0IKTAafmSzf7tOn9zxXu5qacT9d39dFQSY3k7jpls88ELa04aJ6L4AZg8/iOZhxe6U6AMyRHI0T1VKy2kCn9J7AycLAeLNU9/2erbdPaavQER/ncDEBsiOZA501YosSXPTCIk/SfeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BsnM74gO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LCu4KJ022932;
	Tue, 21 Jan 2025 15:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ytqRTP
	aEnD+aJhUB3ME+8uhTgsQRHhHY85iDOG4pC0Q=; b=BsnM74gOhAD8I1R9np62SJ
	Rs1qOMkKdQrVxjALyLZQpTsw/ZG0rNtzIHhecBtrmzSo6YBEENq6AyQqwtR3FP1n
	KaxcWuivm7PgOicx4ucIyblYGTS6eNnCoIu6elSBew+GleGeeTvdzimC6D2N2N9d
	caOywu26d90rDggsmSo6plFVboUinJSRpHsEUMEWtxTtderBN0oONmT0KoOKbjm9
	rLfEUFmWABmxhvluJHKUgrUKw1XRZ2enZjgsbUxRK2xsWnLhVdSFmzLw5VNu6cVL
	adbYvgztYxKjI/RcFb4C3CuDvs8CND7ce+6ncw2Ds31/PW8Jz/MPA067l4oEDQjA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a1n9bf81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 15:12:05 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50LFC4R9023493;
	Tue, 21 Jan 2025 15:12:04 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44a1n9bf7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 15:12:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50LDkYxN029587;
	Tue, 21 Jan 2025 15:12:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448qmnbpjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 15:12:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50LFBxOd58065244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 15:11:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E95A20043;
	Tue, 21 Jan 2025 15:11:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D3FF20040;
	Tue, 21 Jan 2025 15:11:59 +0000 (GMT)
Received: from darkmoore (unknown [9.179.17.46])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jan 2025 15:11:59 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Jan 2025 16:11:54 +0100
Message-Id: <D77UJ5ZYZEFX.6K7XSR64M7KF@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/15] KVM: s390: use __kvm_faultin_pfn()
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-7-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-7-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RHptOCL1GzweJk0t1wrK-4ItByUiRyKe
X-Proofpoint-GUID: K4qFgGtkXiz276fyaef03nFH0gc8T1x5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_06,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=388
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501210122

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> Refactor the existing page fault handling code to use __kvm_faultin_pfn()=
.
>
> This possible now that memslots are always present.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 122 ++++++++++++++++++++++++++++++---------
>  arch/s390/kvm/kvm-s390.h |   6 ++
>  arch/s390/mm/gmap.c      |   1 +
>  3 files changed, 102 insertions(+), 27 deletions(-)

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>


