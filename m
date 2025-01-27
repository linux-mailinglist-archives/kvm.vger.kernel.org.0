Return-Path: <kvm+bounces-36647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1A1A1D38E
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4288D1886A8A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C471FDA61;
	Mon, 27 Jan 2025 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BeFK4W0b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D024E28E7;
	Mon, 27 Jan 2025 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737970602; cv=none; b=dKAEiNmBqmUMY/hlSXM1wDqS+x4CajiS+i4aJ774rofgv3ojXwdg664p/sTU2mgZsaTvbCik5Pb7cPQvGdwcnWkmJXfGSMvazWGb4b8/cvjznrbnX1FZqb+igwAq/4G3galGIVAwYJY8yxqArpwNuusj+B50VSjClMAFaKSpxFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737970602; c=relaxed/simple;
	bh=VPDzPb5NjKz6hdJTq/8I7fVvwttunGSiyGbXY6BhSm0=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=MlfsJlXjjYoFyEvi0jmQ4QIo1aSz1QPhN+lh15N5FpyS+v4B1lwsgkiswxqNYX24RsOYOf6DhP+zHIdE/M77jeSgGwXDi26ISk2Uf3q+CnQ8F1AZCuj7wk/aNg5HOw3pwIYDpk02jo7HShJo7B2cUE15DtfrZmbn0LGjQaJ9vso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BeFK4W0b; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R5OZou032161;
	Mon, 27 Jan 2025 09:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cXdddj
	LUnu0gQeuEi10r/8s/KDDc/twI8eWiQT2eNBQ=; b=BeFK4W0bYK9UHeKcB7XLcf
	lR5JATWd1U+/gbTGOhhChWr7iV/cZItd0cynrg8lFrDzSBpxGp6vnk+2dF6PA45n
	toWIhMnbH8p43wgbyoJLcywQfBwFtCoa/9Gvn9pJGy7CaxNm+zTWfMbnuEy8L+w2
	y3AXH0e3/Pobsf4KsUXLMXFxpPirawWuBktYcuJQAgnb9Ar2ZSr7EsTD9/Pf5rat
	iqAS+IHeZqFwb3ZpBjnqicU2INgsjJVvaRwTJdXpyd880++68fmkhXpQ02rDN6fG
	UEZKIMvm2KBy2M6qKWHE76gnd6kZrlVW9I1jhnuZyKn16DNjGSQxvHUGfEULfOEw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e3y7s2qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:36:36 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R9Clcv022571;
	Mon, 27 Jan 2025 09:36:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e3y7s2q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:36:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R6vV9Y003924;
	Mon, 27 Jan 2025 09:36:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44da9s5tf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:36:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R9aVlP35586508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 09:36:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7D4520300;
	Mon, 27 Jan 2025 09:36:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D46B202FF;
	Mon, 27 Jan 2025 09:36:31 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 09:36:31 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 10:36:25 +0100
Message-Id: <D7CR5KUC16EM.1A0N64H8AANMK@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 15/15] KVM: s390: remove the last user of page->index
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-16-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-16-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IkstaotqtBQGj0NWoB3a9PF2Rf8tuLnI
X-Proofpoint-GUID: l0ucfSsLh7pHthxfgq1bdIvbJtMVf6It
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=827 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501270076

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> Shadow page tables use page->index to keep the g2 address of the guest
> page table being shadowed.
>
> Instead of keeping the information in page->index, split the address
> and smear it over the 16-bit softbits areas of 4 PGSTEs.
>
> This removes the last s390 user of page->index.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/pgtable.h | 15 +++++++++++++++
>  arch/s390/kvm/gaccess.c         |  6 ++++--
>  arch/s390/mm/gmap.c             | 22 ++++++++++++++++++++--
>  3 files changed, 39 insertions(+), 4 deletions(-)

[...]


