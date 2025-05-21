Return-Path: <kvm+bounces-47290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37ED9ABFA12
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA1E44E5C98
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20FE221FAD;
	Wed, 21 May 2025 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h+rWzec0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CF717BB0D;
	Wed, 21 May 2025 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842142; cv=none; b=I5olOYJSc4/gdgN+wnn2mMIJZTPYgkDU5eAxuZRQIapUHS3W4f6o8+T88+TOCMkZiru0sLNu0BmfxzPVMCBzirnFaxEdRlMaJgNS/ocieccgAaoCREVBPZDn/LHQhqC+WMEN4y2OMuHE7kDROkMftHNtc/o0liBu2u+fts4YCVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842142; c=relaxed/simple;
	bh=Z5WeOOl2RIE30hEUvrxYKZYWbf+BAy4cCx9ZqHmPJOE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tZljJM6Tfb7OY85BtlwPezohaGQ6dcUDQIbn42rnIoHzpi5DZ15ZQD6KiWeDTbC+AQZ+l/uBGPVXjaXE1iCk0rK6s+m3yGRtpxiRYYALma8DtE5dIJxqe5kds2TPtyLIIcc3kXWo07zEIu7jHMcvf232jcCWjiTCSVwLw/xcK5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h+rWzec0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L6IP5T001349;
	Wed, 21 May 2025 15:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Z5WeOO
	l2RIE30hEUvrxYKZYWbf+BAy4cCx9ZqHmPJOE=; b=h+rWzec017r6GaBX7NgK4d
	YKa3xMZ07nU+KaKC5Vkk8gCGd1o8TVW+YOHomDFsAHmsxp9KFRL/hey4fUmjenxz
	ZMu0d8L1uiklV5mz9ciE2E5wOjTwgxOszExjLZ78c/fsvHLug5rBp3PRTEIqAweu
	U6M3Lwu+OlQYzl+5xgcsVmZ/ElaiGhCMn0UaVPuODTdVSUYeTkZAHwpDD1Lif6cK
	zqTWwzhYzpcdfOwRPeBPkLSd24YIUJgPKCmozmQ5kyOHTPbTY3+wN27AHkssihZo
	n6+z+somnMaUVsjHdMKfyEILAxmWbjYegQlL+GHJ0TA29uhEU9c5ilykOAK/Pbkg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46s9estp58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:42:18 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDlwaD032087;
	Wed, 21 May 2025 15:42:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmcufg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:42:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LFgEev32702726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 15:42:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D1F02004B;
	Wed, 21 May 2025 15:42:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB36E20040;
	Wed, 21 May 2025 15:42:13 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.80])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 May 2025 15:42:13 +0000 (GMT)
Message-ID: <61cd1d044935523ea443634f656ba47f00024a39.camel@linux.ibm.com>
Subject: Re: [PATCH v1 5/5] KVM: s390: simplify and move pv code
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Wed, 21 May 2025 17:42:14 +0200
In-Reply-To: <20250514163855.124471-6-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
	 <20250514163855.124471-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 (3.56.1-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE1MyBTYWx0ZWRfX4URnpU0LPJDt 8SbMEbcMD6mDB0VNojoS7rZRBZmSs6mB2G+xnHA+ajQ4LBuZW8rg13BwcS1q6AdLcRQzhenC4gI vuilAdTagdz753tDwK0uQY5otIJYogWCztlW7qJ4rGjKEXfk+pnNgzdbGP2894oDLJ3nU5az440
 8XVIewBfJ6VK0/QgzWhdEbfXkqPN2sgsmH114299Gs2rG6JpOrLP6e9yMOa4/tazjkZoDlg+FbY EinsRllUBVN6CfYQiBU2SYDLYDGo4V2oIKrDEEk1mvzWhrktW46q0edXVKWjwZ2mVyibFD5Sx9H aPaYmvshB4CqX24C7QFuHJRwhDS6LM3z7u3pNfUlTvDNCWQepkn9d4477VSmV0GXUcLWCx/iWjk
 luHelxQdtrWjnCYuaDcx56pslTSyGKm1DwUh7/rE0xW091herFn9UwC76YuDD4DDHDkN4DKp
X-Proofpoint-ORIG-GUID: RR74rUPTd1j84C1CGHxjf2GUMCuMZYzh
X-Proofpoint-GUID: RR74rUPTd1j84C1CGHxjf2GUMCuMZYzh
X-Authority-Analysis: v=2.4 cv=PsWTbxM3 c=1 sm=1 tr=0 ts=682df45a cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=HVa9FsKFN9bTpKEVuYAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_05,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=996
 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505210153

On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> All functions in kvm/gmap.c fit better in kvm/pv.c instead.
> Move and rename them appropriately, then delete the now empty
> kvm/gmap.c and kvm/gmap.h.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

[...]

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294

