Return-Path: <kvm+bounces-37482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70484A2A8A7
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 13:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CE6D16413B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 12:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415AA22DF93;
	Thu,  6 Feb 2025 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hYGDmumW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF4C225A2F;
	Thu,  6 Feb 2025 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738845761; cv=none; b=MNPUbKQTpKxC1lt7uJrXboZ6BzVRLvFiXt1fZB1bYgELqi4dn7AjYSxDcMXmHRBZJIwsnG/u7JkxoviSZV7eznZs6hitO/CTERyD9Lzju29qtn1q5fdh8RoNz7urHldICwOPy0Hkn9Q5pUAMdsQVbQgc1876ysDlmnaDSWhraCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738845761; c=relaxed/simple;
	bh=t3QSoBAqI5Z9Br5rpMNkKkLBbWevnj/aBKJHylgokuw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=qHFW1m1uWUptEIUCsmSJgZAcNNjrppXZ79aC1X5i6V3WYXiz62QzdHB7sFaYfJz1gEKU8jzmAY2rztb242uWQSB+ax9xwJ+o5GRJ2TZcLoHIe9xpMjj3pZzCRt0ByFCVH/sdk5EgI3dRRxGhvbZA0viEhLRZPwxuIiqwxV6p6Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hYGDmumW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5169pcUc024286;
	Thu, 6 Feb 2025 12:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=t3QSoB
	AqI5Z9Br5rpMNkKkLBbWevnj/aBKJHylgokuw=; b=hYGDmumWU4aNIq2lYvvU2W
	HxpenjauBsYguj0grv+fxSuECXuzL5Za3hQipapbdg0m5eKhvYUe30bvs7oOCU9K
	Bwzrqyez9ltrI1vXwXxm6FMMKSokxTbjgyIwNd6VYS2YUOIqjH72ab6q2IkitGoY
	KBmIIbtcwjIRlZ2Io9iIU/M7wrUr0SRolL1aQlmKCY9qIWGWe65HUFCiNgNHn56b
	IUoAnenIdscgVP7kKzDv7nrAwSuKHvGPGGjx5KLX2rc+/lfxBQZfwoF7+DV/InNr
	SbIc35VBoLE4geYlETDCNPWW0n4K73XaDoGgNVDs0Twlpv/e6/Ypg2LE5PkbImgw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mattdfyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 12:42:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516Ai8Q3016416;
	Thu, 6 Feb 2025 12:42:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxspj8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 12:42:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516CgYP354657428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 12:42:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 202BE20076;
	Thu,  6 Feb 2025 12:42:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 496822006C;
	Thu,  6 Feb 2025 12:42:26 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.19.54])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Feb 2025 12:42:26 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Feb 2025 13:42:26 +0100
Message-Id: <D7LDDFZYNOQG.2VS87QUG4AK92@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, <hca@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] lib: s390x: css: Name inline assembly
 arguments and clean them up
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Janosch Frank" <frankja@linux.ibm.com>,
        "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250204100339.28158-1-frankja@linux.ibm.com>
 <20250205112550.45a6b2cd@p-imbrenda>
 <97262c67-b04e-4015-a081-f1024e8a31a2@linux.ibm.com>
In-Reply-To: <97262c67-b04e-4015-a081-f1024e8a31a2@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ual57odDLMIHnNd0mk1PsBhMRpyJdH5A
X-Proofpoint-ORIG-GUID: Ual57odDLMIHnNd0mk1PsBhMRpyJdH5A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=837 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060104

On Thu Feb 6, 2025 at 11:36 AM CET, Janosch Frank wrote:
[...]
> Heiko suggested to drop the two "m" clobbers and just add a generic=20
> memory clobber. If we even want to touch this at all...

We are a testing framework and don't care about the last bit of
performance. I would argue that we can just always go with a memory
clobber, since they are less error-prone and easier to understand.

If you don't mind, go with a memory clobber in v2. Otherwise let me know, I
think I may have a few other cleanups lying around and could do it when I
send them out.

