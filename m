Return-Path: <kvm+bounces-28384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B49A998074
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BD391C261C8
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8EB1CF2BB;
	Thu, 10 Oct 2024 08:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Yh4qEqu0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E788C1CF29B;
	Thu, 10 Oct 2024 08:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548773; cv=none; b=d9uwAdU6ZA9U51vFWXP4UccgaVweFPjpRkS0Asnpu+jXd260hB1PHehn69jBh8B4ZgBiByGt3xTHwyq0E/fnnLdIHpZJrXMOnBkDqHo5Iq61Vv7n8/Mmo0iGw7POw0H8ZSXisyZ5TbP6iEsKsI0sAa5hvFytx7XuhzJqedauBS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548773; c=relaxed/simple;
	bh=ZxX4OfI/kCq0lStsqGLt5kEyPTRSWWpipAtO80BXEpU=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=M8OwTRVNvPlq1V5ONGsVctiuoOUkIlQlSiqq2wVkVeAyLB1xzQVmUzMnKblXtv4eIkxHY70hyaA/Q5H0ovnAtO5SbTa00MQMITgTOtZvDKAh3vR1WLcXHr9rsunLv+1OcxCwmqaIrew4RRnBopgC7r96ZGiQwuUgmSsRb1XRUdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Yh4qEqu0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A6X2jG028430;
	Thu, 10 Oct 2024 08:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=trFh+0
	770+ceus4QNYjoOL3gZZgllQ1nT8J9QpsQFgI=; b=Yh4qEqu0sIrc7Qk/BpdsH0
	uzNIMd35KitWL1DHTu2ni16obOLAms4sb7wopCU9Dl3Nkyt8A7KRuvVvrkzUq3op
	vh2i/5L29bJ76NL85qP2eCZuRI70MlR/KU+CAQC6VgqISpm/T1RH0xZK2tcKESzf
	65df4HXUE9e0D+XT6+V+K+DlVna0nrstQQqSLlbuYUARZLT9FLKJIEjBQ+H14ImF
	OueOHVBUNN0mtgPitD8JNC47QKXAC6YhnTCDJoMXHKdIUOGolK8yGntJGuV4tQph
	Lr+ziWaW6iZh6XCc561XIc4cOUTCKfQnwp1vq3kIbtgmQcKp6bNgbZdOvtWtTTbg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4269rn8hy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:25:54 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A8Pr7a012700;
	Thu, 10 Oct 2024 08:25:54 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4269rn8hy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:25:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A7CWOJ022835;
	Thu, 10 Oct 2024 08:25:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 423jg16bh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 08:25:53 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A8PnAh22675732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 08:25:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEAB72004B;
	Thu, 10 Oct 2024 08:25:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB1C220043;
	Thu, 10 Oct 2024 08:25:49 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.62.90])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Oct 2024 08:25:49 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240620141700.4124157-2-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com> <20240620141700.4124157-2-nsg@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: Add pseudo random functions
From: Nico Boehr <nrb@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
To: Andrew Jones <andrew.jones@linux.dev>, Nicholas Piggin <npiggin@gmail.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Date: Thu, 10 Oct 2024 10:25:47 +0200
Message-ID: <172854874748.172737.3850110698077968232@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -mQ-vuCHyAtprzVl_qI0Nvp2CCtS0OV8
X-Proofpoint-GUID: R5bSIbPtGDtZisiXO_7FoG3XyvYFRIpG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_05,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=444
 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410100052

Quoting Nina Schoetterl-Glausch (2024-06-20 16:16:54)
> Add functions for generating pseudo random 32 and 64 bit values.
> The implementation uses SHA-256 and so the randomness should have good
> quality.
> Implement the necessary subset of SHA-256.
> The PRNG algorithm is equivalent to the following python snippet:
>=20
> def prng32(seed):
>     from hashlib import sha256
>     state =3D seed.to_bytes(8, byteorder=3D"big")
>     while True:
>         state =3D sha256(state).digest()
>         for i in range(8):
>             yield int.from_bytes(state[i*4:(i+1)*4], byteorder=3D"big")

Thomas, Andrew,
do you want to take this patch or is it OK it if comes with the whole
series via s390x tree?

