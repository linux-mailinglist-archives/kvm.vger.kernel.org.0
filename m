Return-Path: <kvm+bounces-21175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7287692B920
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D4B5282E13
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02623158A2C;
	Tue,  9 Jul 2024 12:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e84Y4NVc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C9F15697A;
	Tue,  9 Jul 2024 12:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720527368; cv=none; b=DfYnQ3NlFUY2lmQaDDXWa9FyTDyvhoMdevnb80gUUbMVlppdpNt/EhrNY4NICAk58zgSO7bsUcRr8HBoAm64fx6+yKJwjNNZ/VcaMDyKWtdOzB0ZpHONL+BToit13nb2KATmr/ZnEPJt78z+2r9ShEzZxpvDA6d/qkqGvsf5ut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720527368; c=relaxed/simple;
	bh=oRrs0MuZIvq2Y1akVTR1AuDyqGUT2GrHBAa2rkP0SkQ=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:From:To:
	 Subject:Message-ID:Date; b=R3MQ+5jl1GgMeybRfxizL4HbcmpCBIb0yWVYevl1jyKKWuBq11odzL9mf6AQVxBCpt8iB0Ihz6jkNLYifiZR7A+5kZslACrA4s5yXGGoq3xRSAlVe2hVqEvNzZrV6K7sydUGyPU2ZV1sZ9T9ClOUg7vR926SbU8KUv3KmHSuNXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e84Y4NVc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469Bw4Tl004352;
	Tue, 9 Jul 2024 12:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:cc:from:to:subject:message-id:date; s=pp1; bh=oRrs0M
	uZIvq2Y1akVTR1AuDyqGUT2GrHBAa2rkP0SkQ=; b=e84Y4NVcnBM3bAJVe85OML
	zS0bFECwSJkAUB+H2f/eLNLxBYv1HMWEyjzRWuNV7Q2Iwxs/3XSoxOzA8UOgPuq7
	E4VVS1Qjq/xUcobqmYveUb+s2580tMCTOipye+HNc9g7jRCUsbuGh5PfhHnZPRlR
	qvv9DmJHo+BbsrFbn+mYBSNqisWJqsBv6VtPWmNGzsKx6vaqd8nNDcjWsb5DUBC1
	LbmPE/LKy1Yf2EWNjTEnAu82Ivi4MxzHhI3WNaFsZ4YL30GEziutVM63wU2ZqzTT
	nuOdJ1aDid/Dv0zYrTg9IxxXFf7lY8tIBtROtMFjgOj2KJdKHN67vvyb8OaFV0dg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4090ug0q0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 12:16:04 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 469CG362032134;
	Tue, 9 Jul 2024 12:16:03 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4090ug0q0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 12:16:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4699q5vw006916;
	Tue, 9 Jul 2024 12:16:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 407jfmc3ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 12:16:02 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 469CFvnb44827082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jul 2024 12:15:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D7232005A;
	Tue,  9 Jul 2024 12:15:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFEA720040;
	Tue,  9 Jul 2024 12:15:56 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.72.32])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jul 2024 12:15:56 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240703155900.103783-2-imbrenda@linux.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com> <20240703155900.103783-2-imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        nsg@linux.ibm.com, seiden@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        david@redhat.com
From: Nico Boehr <nrb@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] s390/entry: Pass the asce as parameter to sie64a()
Message-ID: <172052735546.243722.14703760107770073376@t14-nrb>
User-Agent: alot/0.8.1
Date: Tue, 09 Jul 2024 14:15:55 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -PUDb3xl9FQ2r-YqMZSqz31ufm39yA-P
X-Proofpoint-ORIG-GUID: lRDjo753b571yoNq9vIutmHK9tsVFOy4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_02,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 impostorscore=0 mlxlogscore=822
 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407090079

Quoting Claudio Imbrenda (2024-07-03 17:58:59)
> Pass the guest ASCE explicitly as parameter, instead of having sie64a()
> take it from lowcore.
>=20
> This removes hidden state from lowcore, and makes things look cleaner.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

