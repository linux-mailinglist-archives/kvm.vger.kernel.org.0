Return-Path: <kvm+bounces-24217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81070952609
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4BD71C213B2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76E414B08E;
	Wed, 14 Aug 2024 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tW5yhGUl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9D4146A7D
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723676273; cv=none; b=s14JrkE4MeuRSaC8A90Z/OpPETD4a9zBFK5Sy0TkjayOZuI0LGddnKRvsfSM7ievTOqBCCMoiiVTjjEHIzxngfNxAi0+OB0ZMkClabh0xOBQbU1orT2pnAh1BrH2i3QYFl61mYVqDldACCp8MZQY1dTYs3wUjljBVQs9sL/6vDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723676273; c=relaxed/simple;
	bh=R4rBzep3wt8cwF8iJPcpyPemhVqeacKhVyDXdn6hDLY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Of0AUl+VUnyV2rtSUgHe360Lcmmx8lNaSn4ZMzcDXyZ9l2IBRp3aUU9WgGQEy/CqOslt/rnqkymigsZ35MRBjopLhWOCkXD9Y/KD1gbQr+tZ4IRco3lJOoJvNnv+FDwUHwKtfvNZgF66R0LaU3+Q1olDF7rpGbOdp6sC2FtKZOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tW5yhGUl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47EHtNxv013013;
	Wed, 14 Aug 2024 22:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	R4rBzep3wt8cwF8iJPcpyPemhVqeacKhVyDXdn6hDLY=; b=tW5yhGUlNLsMKxnx
	iAGkV7fI2TRQ2u9plrjMlmK558/vzkX8m9+QtV4H6VsOE6m9yzWOmbD6la434cdP
	pXd9XhwMVA2619gzVu9j8xjOtOrbgvTovEbdTPFuWVtLlzTtUgRFw/fjhGZeZ/D7
	alyHhpSQXQ60YTHUA5JuN4Gjgkb8RY7CrEVghgqvsClXEt/xD1q/0rbEeYdcD+C0
	+rDi7NYdeD3uvr2Sz+prKgBSEBX4T9nG/ErFRlG9MJ26sqqccP6AApApxQr05ZA+
	rDPxJXRCtTgOVNy2ssinzVGA2sdRQ0ez3KhP1H1eF3UI1qfcjKf+HlCpJ9Ri3sfN
	7HMMIA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4111d693kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Aug 2024 22:57:43 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47EMurnq012331;
	Wed, 14 Aug 2024 22:57:42 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4111d693kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Aug 2024 22:57:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47EJe93x010088;
	Wed, 14 Aug 2024 22:57:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40xjx0uyr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Aug 2024 22:57:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47EMvb9M53674384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Aug 2024 22:57:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 447FB20043;
	Wed, 14 Aug 2024 22:57:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76E2A20040;
	Wed, 14 Aug 2024 22:57:36 +0000 (GMT)
Received: from [127.0.0.1] (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Aug 2024 22:57:36 +0000 (GMT)
Message-ID: <e7478b1e0116882c5cbbff61fac5f2221841877c.camel@linux.ibm.com>
Subject: Re: [PATCH v2 3/4] target/s390x: fix build warning (gcc-12
 -fsanitize=thread)
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Paolo
 Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wainer dos Santos
 Moschetta <wainersm@redhat.com>,
        qemu-s390x@nongnu.org,
        "Daniel P."
 =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
        =?ISO-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
        Richard
 Henderson <richard.henderson@linaro.org>,
        Alex =?ISO-8859-1?Q?Benn=E9e?=
 <alex.bennee@linaro.org>
Date: Thu, 15 Aug 2024 00:57:35 +0200
In-Reply-To: <20240814224132.897098-4-pierrick.bouvier@linaro.org>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
	 <20240814224132.897098-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AuD4AOgyxvUz_qqmdMkzwrQKCGm8U92K
X-Proofpoint-ORIG-GUID: tiqy8AfNNfwo-eIdKn9mriTFTZZj3Fqg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-14_18,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=841 phishscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408140157

On Wed, 2024-08-14 at 15:41 -0700, Pierrick Bouvier wrote:
> Found on debian stable.
>=20
> ../target/s390x/tcg/translate.c: In function =E2=80=98get_mem_index=E2=80=
=99:
> ../target/s390x/tcg/translate.c:398:1: error: control reaches end of
> non-void function [-Werror=3Dreturn-type]
> =C2=A0 398 | }
>=20
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>

