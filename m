Return-Path: <kvm+bounces-48639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFB7ACFE84
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:48:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E0FD175A11
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 08:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527282857D7;
	Fri,  6 Jun 2025 08:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HKCghDeL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091F2219317;
	Fri,  6 Jun 2025 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749199711; cv=none; b=XIKmTR18BgGoRbW9TkKTZzlc49NNn4Wx6L1vieOAnS9q9cgnbqmaR15QM3CGB4j6zT2FCn23TLrG+YcrT/hjta0IvULPZJ5rqAfSRYdf7rmr57KjyiN6uYS4Hh/+tQgNy9WXaVDRspuqtGOdt5H9PFnqT4F7zUYduxq74UTl8GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749199711; c=relaxed/simple;
	bh=EzSOvL1yin7qcG8YaPOT04MSTiEZWpFOybwDAE+Kl4s=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=PoTUnb21Bx6B7oS8tDkbvIQ/bBQCG6ma1l7ShwauoSWgCQD4mOhZYQlRVyrt2mwDIV/s9wpBnSKGfsxKpujxev4T+Bk4G0ab5PSdGjJzHO5FXGoX31knmx9hvHnyX/Azx3Pc3JgC1xCJGYpzaxPjCQscPyoDd38K8Qr4FDYUjjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HKCghDeL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5563j6Lb004261;
	Fri, 6 Jun 2025 08:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EzSOvL
	1yin7qcG8YaPOT04MSTiEZWpFOybwDAE+Kl4s=; b=HKCghDeLLyX1cyBU8mx0gr
	KtJT95ZZFOo4fyOlhhGovqbl2HqchzBOuYxUmNMYZz9XU1nd2k4kSvPtlPr32X/g
	mjhi2BVkcuOAfHbbUnZP1PpZjkmwb8IAYpLkkxHcW69lX5GcWV0+U+2NhqnEscwZ
	Wt4PwGRdSpz5Q7ZVAFAIw4b87VqJY/cdmiIWDOnSKUDiGDxdAEpK5rlSXajvKy3U
	Pmlj1Go9qIhqGCnkzmQcvDhy5SIx8S+o4yRcImRn3hb6XFS9qaAuhdpKQdZjAT6R
	tZ/QrXrRYE1p9/yeorVGy3/4ueE0RTB/M4JWc4igWJhwNbGtl9TB9x/TRhEkjegg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47332yq1ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 08:48:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5567CmKR019886;
	Fri, 6 Jun 2025 08:48:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3p8nth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 08:48:26 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5568mMDg58393080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Jun 2025 08:48:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78F9D20043;
	Fri,  6 Jun 2025 08:48:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B3D320040;
	Fri,  6 Jun 2025 08:48:22 +0000 (GMT)
Received: from darkmoore (unknown [9.111.92.69])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Jun 2025 08:48:22 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Jun 2025 10:48:17 +0200
Message-Id: <DAFBJJE5QR8S.1ZL5NPV5EJB6I@linux.ibm.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: S390: Remove sca_lock
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle" <svens@linux.ibm.com>
X-Mailer: aerc 0.20.1
References: <20250605-rm-sca-lock-v2-1-74922f4f946e@linux.ibm.com>
 <c024e066-0565-4af3-ae61-bfb995eeea19@linux.ibm.com>
In-Reply-To: <c024e066-0565-4af3-ae61-bfb995eeea19@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NqMDd5RK3UAdUBvWKx34BaZLbDmvWlRE
X-Proofpoint-ORIG-GUID: NqMDd5RK3UAdUBvWKx34BaZLbDmvWlRE
X-Authority-Analysis: v=2.4 cv=SO9CVPvH c=1 sm=1 tr=0 ts=6842ab5b cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=UXfCCEaf6KHchlgvdskA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA2MDA3OCBTYWx0ZWRfX8DbIFDuoHDnw 922qEJzRFJvfCmeisVsmJKff8lPIgu+4CJ28AVO5fiUOA7a3wN2Gzjb/b5nUbKonU5XI9Bu6QGM Vwy77XgstsRKG1QyOr+i8IMVJjv61qk8zx/O32xQBglwSOBOO8tYDzXn7aArKdu0AcO80DPHHx1
 r2fY7dN1A9fX2BWbv1WiKxOHVG5O9LtEVF4xZpHb46/tBwIPKfMfLPeLGz2nh5WBifJwpmZZK6k y2mSHNHR87tct3tiLvh1/5aouZn04aPVNg4NuOSvPrdmsU6ofSe+RsgIcirr+r+5VT0LV37ZAn7 z9cfW3alJ4XUosz9S/7CZAS5L/pZI7yMb0iMfTZej0eqltfyOZagcs7gPsWCkpPGuxrmzSUgbgO
 GYln+BzKjUymtUrDlZ4fGRSipJUusPKrRihJlolh8jFTDB1EQskigURvRcaL1C3znijPZ0D3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-06_02,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=682 clxscore=1015 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506060078

On Fri Jun 6, 2025 at 10:14 AM CEST, Janosch Frank wrote:
> On 6/5/25 6:14 PM, Christoph Schlameuss wrote:
>> Since we are no longer switching from a BSCA to a ESCA we can completely
>> get rid of the sca_lock. The write lock was only taken for that
>> conversion.
>>=20
>> After removal of the lock some local code cleanups are possible.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>> The patch depends on "KVM: s390: Use ESCA instead of BSCA at VM init"
>>=20
>> Link: https://lore.kernel.org/r/20250603-rm-bsca-v5-1-f691288ada5c@linux=
.ibm.com
>
> I'm throwing this into the CI.
>
> If people suggest something, *cough* me for instance *cough*, it doesn't=
=20
> hurt to add a suggested-by tag.

Noted. Will add that if I have to touch this again. Otherwise I assume we c=
an
add this in picking?

