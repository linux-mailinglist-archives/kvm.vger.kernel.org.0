Return-Path: <kvm+bounces-13903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4214B89C95E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74C881C244C8
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 16:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5331422AF;
	Mon,  8 Apr 2024 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hh11yg9T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2015E13E8AB
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712592631; cv=none; b=ZnVJmNHIzG8c5yRXjT70KzvpKp8wiLmvYrqaHAqLfTEGOem4e3s+SaGLDhPwdIkyxE6bQ/0E6w/y67EGPi863WdOv77PVVCqdSlZDHKDiwe9rYPQjJWUBAvdT85aBcZaxfVSNpoRg4GY3btgKkFy/WZSVK+GuOpeqXROLb0J5rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712592631; c=relaxed/simple;
	bh=HVk4V+H6AcSK4NXZ2NPWRuHJAXEaePw7F7vTMWqUVO4=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:To:From:
	 Subject:Message-ID:Date; b=flNQB8XHYNqXxFVUC41OrpTsdhsoPiry4PWKL/NK+iYMmKBJ+Hleqs5jGuWO7QpDHy/ilB6J4wkTPXqo+FCWfoPBCl+dFZpNTyR7u236LNsDxD+M91Ye8T0DrOeU1AQf38BNBgJxH0p7knTrdoF5JJKVXL3bkkZCLG5eq23/8EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hh11yg9T; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438FtSQ9031182;
	Mon, 8 Apr 2024 16:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=t2oqjx5y/bBLhaRIy5Vdy9J7ShKMCKJHfkQkT+d6L4Y=;
 b=Hh11yg9TuKe3E8XnAing+WIuw2cM+LaBVSaaTqIAOzfi4P9Vl8VSFGcXAaVOz8omcawi
 rbP6hQAEuvDLEMowVta9QLm+XmUSHPc+l72fpk1HxF9kjozLmvTc++iURJAbdND+r7A+
 3oH+cJ6pxVxNpcTsO8g7W3aT5G6BExqL1WSMO4wUW1MXTJ1MWZgn8QvUx6gvUyQZC3B1
 E9IREybAFBMF7hxqqWEM/vUSIabu2jzJd2HcfM/ldL14UKzkpfnZ6U46DUO+UGDT/RNI
 p5K5T9bkqwsYZqXajKRVQzwL6/6s+vEpsOrFhT/yocneioAnEPSHsh4VIZRoDLqq/SuQ GA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xck8082s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 16:10:22 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438G8iQx020506;
	Mon, 8 Apr 2024 16:10:22 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xck8082s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 16:10:22 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 438EZj9w013550;
	Mon, 8 Apr 2024 16:10:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbgqt98y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 16:10:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 438GAH0O34734746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Apr 2024 16:10:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85D4420040;
	Mon,  8 Apr 2024 16:10:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F0832004B;
	Mon,  8 Apr 2024 16:10:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.39.74])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Apr 2024 16:10:17 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240405083539.374995-14-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com> <20240405083539.374995-14-npiggin@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
From: Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v8 13/35] doc: start documentation directory with unittests.cfg doc
Message-ID: <171259261691.48513.14896006668285709723@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 08 Apr 2024 18:10:16 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LagbMeRnhD-pqaI5ovZSd4tYgMaYyJis
X-Proofpoint-GUID: wSiV3cAFIYsX_S7sme6Z-MALI3DUO7vi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_14,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=875 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080124

Quoting Nicholas Piggin (2024-04-05 10:35:14)
> Consolidate unittests.cfg documentation in one place.
>=20
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/unittests.cfg     | 26 ++-----------
>  docs/unittests.txt    | 89 +++++++++++++++++++++++++++++++++++++++++++
>  powerpc/unittests.cfg | 25 ++----------
>  riscv/unittests.cfg   | 26 ++-----------
>  s390x/unittests.cfg   | 18 ++-------
>  x86/unittests.cfg     | 26 ++-----------
>  6 files changed, 107 insertions(+), 103 deletions(-)
>  create mode 100644 docs/unittests.txt

This is a nice improvement, thanks!

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

