Return-Path: <kvm+bounces-20891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8829925869
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 12:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 454A9B21D8C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 10:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E5A16DEAC;
	Wed,  3 Jul 2024 10:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rlGk763x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964B5158853;
	Wed,  3 Jul 2024 10:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720002256; cv=none; b=Qn3eQ8tsvhTG+OH/ZiXgtbO2uRxHLkRocOkIs2c+G59TpKTDcddiYJNAZ3dPW7j+iDhWq3t2zI8uKIz9iYLgoYUlEODk5QxvipjiZ40HqDV/Oz/WFTOgi+vCqi9VCdqcILo2AVx1w3UD0OTkx5a3wLlFcjGv1nJiqGFNcAoo268=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720002256; c=relaxed/simple;
	bh=BzRK3DQo9rDWkV+bHSK9IhSz5Nn4nBN70yT9zUh0vjk=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:To:From:
	 Cc:Message-ID:Date; b=NzlnoIdLr0AlINgmCRM2SG9WJQccywjuX4qGwy0qssSWyjfM+xVaXzQmAOiy9bD8by/+oV6wfN0Fc7SYR2BQWUgAx6gd44VQV8OBVdTjCohp5kNGSFxqV2QIHuaE/WG/LVdjVHYYiEpMZa7XiSdRaMWtgyQddfsML677Ug1uxGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rlGk763x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4639wBtq011290;
	Wed, 3 Jul 2024 10:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:to:from:cc:message-id:date; s=pp1; bh=BzRK3D
	Qo9rDWkV+bHSK9IhSz5Nn4nBN70yT9zUh0vjk=; b=rlGk763xUIOP5H5YK8u9Py
	IPRcxXtc38ScLKRSZXpqdGCX+7TXe7SdC+AfTxufnUF25TEfyTNGP74yKtTQcB7M
	y/g6pPTdTTHKBp5kGnq6fO55DAk78dihrT7nH4NUGsp1qx09cqc5Yj+8HmQisay4
	kLUYar4RRU/+wxY4ZyJ5HF2VRWJwV/ITp3ZNQytKNm/QP27Lx90Hphp6MVcUZras
	EAhTQQ8Evx89v6enw+PD1W3Hsj6FCKnU5c9okJQzxAKtuZ8eKR72LXCrXAADpJdR
	UQHj4Nj7WlOEmRjq03dWBnZNq5l2LlVvrJGwLiXKjeegePJxDwAw+ssWV6VM2U7w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40535mg9a1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 10:24:12 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 463AOBRn019919;
	Wed, 3 Jul 2024 10:24:11 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40535mg99s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 10:24:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4638AiNd009121;
	Wed, 3 Jul 2024 10:24:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402w00t775-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 10:24:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 463AO3RY53149992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jul 2024 10:24:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12A4C20049;
	Wed,  3 Jul 2024 10:24:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3FCC20040;
	Wed,  3 Jul 2024 10:24:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.66.26])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jul 2024 10:24:02 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240702155606.71398-1-imbrenda@linux.ibm.com>
References: <20240702155606.71398-1-imbrenda@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: remove useless include
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
From: Nico Boehr <nrb@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, david@redhat.com
Message-ID: <172000224247.95833.192495937410933992@t14-nrb>
User-Agent: alot/0.8.1
Date: Wed, 03 Jul 2024 12:24:02 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w6BLjPKQY3jcHRzB0w8QZuT9ddkL-9lm
X-Proofpoint-ORIG-GUID: VJ-Uzz8DFIE_DfKOYbqyIVyt1NXX7Vaq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_06,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1011 mlxlogscore=303
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407030077

Quoting Claudio Imbrenda (2024-07-02 17:56:06)
> arch/s390/include/asm/kvm_host.h includes linux/kvm_host.h, but
> linux/kvm_host.h includes asm/kvm_host.h .
>=20
> It turns out that arch/s390/include/asm/kvm_host.h only needs
> linux/kvm_types.h, which it already includes.
>=20
> Stop including linux/kvm_host.h from arch/s390/include/asm/kvm_host.h .
>=20
> Due to the #ifdef guards, the code works as it is today, but it's ugly
> and it will get in the way of future patches.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

