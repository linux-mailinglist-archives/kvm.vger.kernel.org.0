Return-Path: <kvm+bounces-36646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3A2A1D38C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC03316369B
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C716E1FDE07;
	Mon, 27 Jan 2025 09:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VOEd7XY8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F21FC7E7;
	Mon, 27 Jan 2025 09:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737970560; cv=none; b=L5V0Si5ABDyMSHVTpPWTyQVDIFa5OMmFhgn1AbttEtdq6YySRMuocW8l+uU6k/fyWUY62YHnarBBTMWwQfhF3PGjggMt+Oo6yMejjhYFPnnT2YELxaX4Swfb5fligtfgAozKiK2iNXmho3O7C3V4/ogzsz8FmRmGgciulmtt6dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737970560; c=relaxed/simple;
	bh=9oVU1Y6SU5Ol3bmrLBXRGk8jc+KP2I7vlEgptHMXO+8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=po0NbBydchPD8tgyFSenxXb11vapnuht8t7t0kHSWb7xVIgTgzw42eEA65MWrbCOqvHVhWDBQ2ZJ/nxVjPwSPA7tBxIkF+/fWU7DgXqFmBcCfPdcVzIVbDaywa9rUo8nNdx/EGpxZ5s+3EY54JK9QURJ3UtyEJi4MEOB2vzA6gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VOEd7XY8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R18JP9000547;
	Mon, 27 Jan 2025 09:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iBnoUk
	IiGMFVDA0NG6tDyhek82cBQlG8eQjLhVGi1ok=; b=VOEd7XY8RK2ebm54dIuv40
	Q+GV85B0qiW2lg2GNBNnaBlqGb6TTpJ9372aG+GNoTRAL41lXuLH8OFJSNNrymU4
	fkPa07kcreO1Y6WvTXG+UenVnRLgj12mGY4Jzu0R0suCee0L+hzHzIXlajhHLmwy
	LsKDy1ClFktZ4bXsKt1DN96R0nxZ+dhMtZRKbIxLI91JN6EbZvv7PtX/JtNoUO9g
	Y/uL2c831VmMRZ2Y1E6YZA6nNLuWS5BmJE7IFrJVFPYJ1TL7GqLjiFaG2WIOPZt7
	wNmD1vltRND7amooIO0tZnTjbYF5SW9j7TmS/eMuNiYwdGiHFMO9sEOsDWWDJliA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e0799vg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:35:54 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R9VQZ4002461;
	Mon, 27 Jan 2025 09:35:53 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e0799vfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:35:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R58D9R018923;
	Mon, 27 Jan 2025 09:35:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dd015828-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:35:52 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R9ZnNe52822474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 09:35:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 474D9200A2;
	Mon, 27 Jan 2025 09:35:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFD69200A1;
	Mon, 27 Jan 2025 09:35:48 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 09:35:48 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 10:35:43 +0100
Message-Id: <D7CR51F5G99U.WGS4IFKXC07I@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 14/15] KVM: s390: move PGSTE softbits
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-15-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-15-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xl6j8Cs6FObchUFjNFozEWjQO9K1xp90
X-Proofpoint-GUID: OUtS9I9Z3jyB-1L17wS55keDFRjlhXxE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=464 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501270076

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> Move the softbits in the PGSTEs to the other usable area.
>
> This leaves the 16-bit block of usable bits free, which will be used in t=
he
> next patch for something else.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/pgtable.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

[...]


