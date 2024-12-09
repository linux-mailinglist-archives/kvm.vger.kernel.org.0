Return-Path: <kvm+bounces-33281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 091379E8C73
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 08:42:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EE091633B6
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 07:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21946215065;
	Mon,  9 Dec 2024 07:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gPdo5J80"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9A221504E;
	Mon,  9 Dec 2024 07:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733730141; cv=none; b=ZvjHo8lJGLENgKqFu3rpka3KiGNhGL3lkgT3clgQJU2I26l5j0rIYMSUhmHz5BhJ/x3/riDqyuBw9Xl7JtuKqfmp80fpRbPM+Wfla1SqdNJHna1YVV8aLsUpGXg5LIwWCX0CbD5RPqR9c3qN/pBYUs1LPrOXD75lxjdUXoPD9x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733730141; c=relaxed/simple;
	bh=DdvPPggx1dx+YVAnE/ZNIR3mjh0h8TY6PO6szCvT8Zw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=baqiCFIW78/J59nlcldEbGQ5c2xMpLbJEjDHbV9kcXcTadNBVd2nEv7Zn7nE2Emm5xmiHKnXeBg0KSP3uoY91Dlsn9LyJRVWUhzygXbWnxi/kBNh3V6p0mMqe2f8QSsI0Qg8/12RkWw3R8RNuHvvu6TFZ6NNBOy8d1URNUrRtzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gPdo5J80; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8MFcep011164;
	Mon, 9 Dec 2024 07:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DdvPPg
	gx1dx+YVAnE/ZNIR3mjh0h8TY6PO6szCvT8Zw=; b=gPdo5J808nJWt1UeLcA4hu
	OAo0Xt78m301p9H2e2psditGZumQAJYELZryJ2tMqTEpJt7VYjbpzOeAxVCDvVZY
	1jgQq7v/nJHh2oa4fNBrrqBh3elr1DJcSOdpHNw4H3DWlyG2tSaPf9ps6BFqmVks
	dN9+FWPPSulq97ceFpdEwovT49zlq1eo7oyRkdqHfXmHcczIxgpC/BkBeOlM2XB0
	LI4AxoaCX9om2ebZT+FJmhTbdK0jkmF1Z4W4vkcBouBsvkBpAClsRY2GELG2+W7k
	odUOTWcdIjB0LpNDzT3jmN7AwWhrX9vuKBoS0+kqJz2fyLq/mOQXjMVrTnR1M/Eg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce0x72k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 07:42:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B95U67L016926;
	Mon, 9 Dec 2024 07:42:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12xwqk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 07:42:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B97gCtu41877892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 07:42:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3ADDF2004D;
	Mon,  9 Dec 2024 07:42:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 157572004B;
	Mon,  9 Dec 2024 07:42:12 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.250])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Dec 2024 07:42:12 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Dec 2024 08:42:11 +0100
Message-Id: <D6701F9KA8OK.1BSJ0503VS0CZ@linux.ibm.com>
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Support newer version of
 genprotimg
X-Mailer: aerc 0.18.2
References: <20241205160011.100609-1-mhartmay@linux.ibm.com>
In-Reply-To: <20241205160011.100609-1-mhartmay@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wnvvSqKg7bAWQsUR3y9xOZF7zR3xnYgD
X-Proofpoint-ORIG-GUID: wnvvSqKg7bAWQsUR3y9xOZF7zR3xnYgD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 impostorscore=0 mlxscore=0 mlxlogscore=799
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090058

On Thu Dec 5, 2024 at 5:00 PM CET, Marc Hartmayer wrote:
> Since s390-tools commit f4cf4ae6ebb1 ("rust: Add a new tool called 'pvimg=
'") the
> genprotimg command checks if a given image/kernel is a s390x Linux kernel=
, and
> it does no longer overwrite the output file by default. Disable the compo=
nent
> check, since a KUT test is being prepared, and use the '--overwrite' opti=
on to
> overwrite the output.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

