Return-Path: <kvm+bounces-25132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BF69604A2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 10:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E98CB23BD7
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 08:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E0C198E74;
	Tue, 27 Aug 2024 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="q/ax28mg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1038D19644B;
	Tue, 27 Aug 2024 08:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748021; cv=none; b=SH9vIDO+eK7ths/VnD9nWbpSJRuWpmNtoMrf2BuN5PNORMSeVP0BzB8eL/4V85M3QgSwkhQ3YThYJSkUh2VLDH4wrLAR0eE184EkGp27PAoQBIanZ7YPQC8S65v5S2FTSdsF6eeO42DTMDjiNmqGJTfIv7P4y4sXprW6gOA44nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748021; c=relaxed/simple;
	bh=I/G91AzYyxJ/Qw/KczvEnmEbcxysBhEMePXpiCprlA8=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=U/b5qurw2wrV/ThUYiHBLXxTBlq2NcAnBrcE1xlRs0bcOtZPzUSdr8k5aNo2Vtqqg+5hAseoJwEHFoNd/mDjZotihkmu9zx9ZsjAfSRpOqltm6BJzgxsMxRFXAPc6vixnvnvqzK2vuCBg+iE+4HQXCozx3FL9UYmRjgdQRPU6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=q/ax28mg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47R1tLeT032160;
	Tue, 27 Aug 2024 08:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=8ejJR8
	KeyUEAz4M7HJQ3mnqPHzFbb/T1UuXcIom9Fi8=; b=q/ax28mgDJTEnQ14m+/x38
	5LW6xlc+MUTWOmKWWDwSGC/PFWeCT6l2zWPxm1uB7iksfkxYZLONk7r61KAIKY/N
	lTvtydF3e4HV9Fe4FFktgkL6W0xh/st8M/F8AwvIEIsFCzCyrdXeLWiesVKJS+hb
	bOXIyCsxnuTffbY6kz3EDqJR2LBqx2vgUAvxPAvCO96SpT84nBe9MAo7QfYHJ2fS
	ieL28oPl/TzOHXAqWz/padfX/gB3HHS+sDlx9+lUWHVVx8vBsbrFx5j6fwsrK0me
	vWOqAoLFjCd3k4tCmH3nVsjps75n+G5I5WpAUBg7o5eLTFDWMLYJAoltYSMTgUlg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 417gedaenm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 08:40:16 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47R8eGC8027464;
	Tue, 27 Aug 2024 08:40:16 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 417gedaenh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 08:40:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 47R8GNID008228;
	Tue, 27 Aug 2024 08:40:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 417v2mhs89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 08:40:15 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47R8eBN338338816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Aug 2024 08:40:12 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5BA52004D;
	Tue, 27 Aug 2024 08:40:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9826520043;
	Tue, 27 Aug 2024 08:40:11 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.19.253])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Aug 2024 08:40:11 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240621102212.3311494-1-nsg@linux.ibm.com>
References: <20240621102212.3311494-1-nsg@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Split and rework cpacf query functions
From: Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Date: Tue, 27 Aug 2024 10:40:10 +0200
Message-ID: <172474801046.31767.8212475479414171264@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jOQXOBWgKVzwFIKWJawT8A0AUeQCfIL-
X-Proofpoint-GUID: 9OQWNbNgE3jc1Psd89KKD0XhibNmn-h7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-27_05,2024-08-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=943
 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1011 impostorscore=0
 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408270063

Quoting Nina Schoetterl-Glausch (2024-06-21 12:22:12)
> Cherry-pick 830999bd7e72 ("s390/cpacf: Split and rework cpacf query funct=
ions")
> from the kernel:
>=20
>     Rework the cpacf query functions to use the correct RRE
>     or RRF instruction formats and set register fields within
>     instructions correctly.
>=20
> Fixes: a555dc6b16bf ("s390x: add cpacf.h from Linux")
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

