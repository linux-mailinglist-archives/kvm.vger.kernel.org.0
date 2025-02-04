Return-Path: <kvm+bounces-37231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFA2A27291
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A689E165707
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06DE2116F3;
	Tue,  4 Feb 2025 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AAidGAkr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D9120CCE1;
	Tue,  4 Feb 2025 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738673745; cv=none; b=mkrJrL3hdOPn8S5VcUlnXNnH8s/hH1Ped7Hf0egAQOhMGGWdnEpSqayEotRlQQx3fH7uE2sWq7rIJkT8bmVoTJgW9M9avgQXwulButs1f9shjhOE8sUrxDmhG16hmIHGcyUDXLUkeY6uEcOY73W3bKu4wd/EQIXq3/m3uRl0UVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738673745; c=relaxed/simple;
	bh=OGjwQuPfWetksAPEcycdLMVdfygEutePpDK2iVnlDkc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=C/8axExxQ7wPC4hXCXyB7FDyI4GVF0TpmO/L5qEZsucXR5MB9kIAlNNpIuCPJLHUwIFf9IOG6uWJ5DGu6qN3doyT0rprOyI7uWkc/GR+QSHJIKmEiBfVj4bMFt00HThYYzn8Y/qSE1ZrEQexdHH4MRCCXP7I1vZz9Ng1vEacv1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AAidGAkr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5147X9hA011331;
	Tue, 4 Feb 2025 12:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=k0tDC6
	qlek+GMfcSTjHy7j7g2ghMuipMt7SckPEgcgA=; b=AAidGAkrLjZHJb8EbfpMIO
	5GH5Fi3mFQRk5859xEiaQSaYvTP5YOKUbvj2nXNrXLIjgtzoOvEI2z190gjzO4Hz
	bOf7lJCGJS/AkE9T7j5Tpbm/N6NzB2nKedc6R7jpe3jAwnMxX6XE9I+0W/oTHU96
	fIztAU7Svqr2qNRNTwHShKPere7UFG9V9ctDdzCJfCQvhOb8U/mDGYSV0lq3c73g
	2i2gpFWyTUclcDLXC4ZmnMHxSFaJe0/L/bzoBeyC3cdr004sTDfkL2xIe4rt6LRR
	DSJwl0uKz/CVd7PBwqScBxt/dmD9Im4dO6NbyMyEQPr0ZmSvQaE9VVXXQTk+GT0Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44kekp1dj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 12:55:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 514C8MJU024510;
	Tue, 4 Feb 2025 12:55:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxn3hnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 12:55:42 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 514CtcVm58524096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Feb 2025 12:55:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D30620043;
	Tue,  4 Feb 2025 12:55:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B2CB20040;
	Tue,  4 Feb 2025 12:55:38 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.3.166])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Feb 2025 12:55:38 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Feb 2025 13:55:37 +0100
Message-Id: <D7JOEGIKCINO.1NX73MSQGVGYZ@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <imbrenda@linux.ibm.com>,
        <hca@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] lib: s390x: css: Name inline assembly
 arguments and clean them up
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.18.2
References: <20250204100339.28158-1-frankja@linux.ibm.com>
In-Reply-To: <20250204100339.28158-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vGFXpT8pKvEmPrCDD7-aZbfgEGJdjMYk
X-Proofpoint-GUID: vGFXpT8pKvEmPrCDD7-aZbfgEGJdjMYk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_06,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 mlxlogscore=757 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502040100

On Tue Feb 4, 2025 at 10:51 AM CET, Janosch Frank wrote:
> @@ -215,9 +215,9 @@ static inline int xsch(unsigned long schid)
> =20
>  	asm volatile(
>  		"	xsch\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=3Dd" (cc)
> +		"	ipm	%[cc]\n"
> +		"	srl	%cc,28"

Should this be:
		"	srl	%[cc],28"
instead?

With that fixed (if it needs fixing):

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

