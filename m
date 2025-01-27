Return-Path: <kvm+bounces-36644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 290D5A1D352
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E4E53A2AF7
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A9F1FCFEC;
	Mon, 27 Jan 2025 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HBlR2sAU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ECC1FCFC5;
	Mon, 27 Jan 2025 09:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737970031; cv=none; b=L/Ktfdt1cW1ghhUuyLNK1RkCXfOTj0AjydC2IlwvHE9uItg4/VnHZTU7z+d0X80jhKrU3LAJ7B1bOUkSiRR0a7l0Lah4nT+42gbMUvU8kDLJGN+c53nifvFZF//jGPlwMPHrlJUJSE964RXu+4QpMreCQ+w5YzTclN+xqAgPjZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737970031; c=relaxed/simple;
	bh=3i+juMU230kXGhrdhCcf9tu3D11O1PpM4u06mu1DK94=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=C6UB1f1w9Q+3YHEOfalkqXGmaIbHLmfCiokAayN6L8HPYhIX2eVHMe5FdfChoq/qyrabzTcGMJm9F6dq/k6MLSLocmFJMPfOAOBYBAgjAzFLqipD/el3cwiUwfKicVu2znibrFIQ32V2fOnILaeIqIjLYb2DpN6mQX0tp6AKiK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HBlR2sAU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R8Hwc5020432;
	Mon, 27 Jan 2025 09:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VQHmfF
	OkufSZQbRXjEr2yrfY+R8Pj1wUn/PhPyqQyP0=; b=HBlR2sAUTx7affX2hwmklx
	oq6BLICGfISL0frKp0ixYWu8lZouSy6BKuqQNcShmqdswc9KCH9LzKEuFQG4On1J
	+Z5+d1XRE+zKapCJ0wlFP0YFXSUhsZE/EF7CPfX9QJI++p90yh9MYtcj2fi6Sv2R
	6N09gX36q1nPMhD0g+yWVlyHQYW1wQIUSHUzaTcR17ruX4O0NPdWPmHic74fRbm9
	SMJceRatsdnuCXBBfymH0WN4CJAc5GN4NdUcP/i1/MFHSMe118v3pSGfcxUu6FW6
	n7K85Uu4lCRYFK1CUBB1QziKRMIJ/HIFkYrO0sX1owBxJP1a4qLfzQHVyoo2xQHg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44dqaybccs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:27:01 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R9R1Vj032172;
	Mon, 27 Jan 2025 09:27:01 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44dqaybcck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:27:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R6o5Oh012343;
	Mon, 27 Jan 2025 09:27:00 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44danxwr5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:26:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R9Qum461276466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 09:26:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4571F20088;
	Mon, 27 Jan 2025 09:26:56 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03E622004F;
	Mon, 27 Jan 2025 09:26:56 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 09:26:55 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 10:26:50 +0100
Message-Id: <D7CQY8J97N3P.FJAGEDK984AJ@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 10/15] KVM: s390: stop using page->index for
 non-shadow gmaps
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-11-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-11-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oH52ocEMed_afNeuLsuERV8g2mYFqw3k
X-Proofpoint-GUID: u5url1BFSVNkJzjI63ohwAYrCk3Bo13V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=969 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501270072

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> The host_to_guest radix tree will now map userspace addresses to guest
> addresses, instead of userspace addresses to segment tables.
>
> When segment tables and page tables are needed, they are found using an
> additional gmap_table_walk().
>
> This gets rid of all usage of page->index for non-shadow gmaps.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c | 105 +++++++++++++++++++++++---------------------
>  1 file changed, 54 insertions(+), 51 deletions(-)

[...]


