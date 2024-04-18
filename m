Return-Path: <kvm+bounces-15072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C98458A99F8
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 684041F220D3
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA702E84F;
	Thu, 18 Apr 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oG7eI+fO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C25E1DA26
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713443944; cv=none; b=foNPouUHK3g1Z5GqSjE0dZN9PUUv+xJyFSp898f/5bTJ/K1su7D4k/uQgpe5FrJv5nOCYOhHRSPYSVJfxrNxoPreeZ27T1stntk9GEFDNLBrOX2yvewUCrJ7MjFf72/bvQNxAQMHrg6U4C5Fel9vAqVpPrKue2rM90To0P7WWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713443944; c=relaxed/simple;
	bh=7QNrsynsoRRLudHEt57fpHESGdHv9Wguo3aVcvKfLdM=;
	h=Content-Type:MIME-Version:In-Reply-To:References:To:Cc:From:
	 Subject:Message-ID:Date; b=eCI1rO+6qavykrDUvDpiQSbb3CziaSkeekvCjQHeXrfdSLCQLOi8cb/UE7Oa8rr/z85heVkryItZ14u9OVXGegm7w+nmgnAcUFomQCppett3CB6vZ6c5qMSbZakbagN5TmZu3VQ7KznndzdhFm/EJU2Wm24PNvQTXkIsOeTt2Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oG7eI+fO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43ICR0s3016901
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 cc : from : subject : message-id : date; s=pp1;
 bh=7QNrsynsoRRLudHEt57fpHESGdHv9Wguo3aVcvKfLdM=;
 b=oG7eI+fOuivbcLOv7lXgMmkeKPepkiXSvTLtpAJCzkAUwfMIn+q3u6IyitNJXHq9wWh1
 FIS8MZYnvMCzzRYLBZb4flsrjsGt4nXy3lG3a07wWb4FzoQaKeTL4DbPu21LWD47Fs5T
 JDuASzMyahGF3Wx2Tp3sd+38/0NX2gRLBNyFQR+efK7jrg7CreGwJgNElucrmPgSM1jN
 BgkVvQDLKgb81oqB6GCsNqiPh9ifhUoUStid4zdtSv3UVz3gunedP+qPvTsSsttdHKcX
 oS2OnXM0wsLK80Lnps9LpDvWVv0aJOQLO5X0sVpW8Pn4jwnbUitPny8WQjBi+jOebrht 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk3hh814p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:39:01 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43ICccUd009530
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:39:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk3hh814m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 12:39:00 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43IBRoUV023681;
	Thu, 18 Apr 2024 12:38:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg5cpam2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 12:38:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43ICcr1S48824744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 12:38:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E190F2004D;
	Thu, 18 Apr 2024 12:38:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C939F20043;
	Thu, 18 Apr 2024 12:38:53 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.34])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Apr 2024 12:38:53 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240418110140.62406-1-imbrenda@linux.ibm.com>
References: <20240418110140.62406-1-imbrenda@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, frankja@linux.ibm.com
Cc: david@redhat.com, thuth@redhat.com, kvm@vger.kernel.org
From: Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] lib: s390: fix guest length in uv_create_guest()
Message-ID: <171344393347.12843.4689373033536169756@t14-nrb>
User-Agent: alot/0.8.1
Date: Thu, 18 Apr 2024 14:38:53 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Pjq0kQzI09TXm6EQnrzrI0VXw0cCLvE
X-Proofpoint-ORIG-GUID: LHuCEF68XYK9Soo4smPvXxbDYZhahVNW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_10,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=695 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180090

Quoting Claudio Imbrenda (2024-04-18 13:01:40)
> The current code creates secure guests with significantly more memory
> than expected, but since none of that memory is ever touched,
> everything still works.
>=20
> Fix the issue by specifying the actual guest length.
>=20
> The MSL does not contain the length of the guest, but the address of
> the last 1M block of guest memory. In order to get the length, MSO
> needs to be subtracted, and 1M needs to be added.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

