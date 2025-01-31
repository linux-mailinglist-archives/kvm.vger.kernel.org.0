Return-Path: <kvm+bounces-36964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F55A23AE7
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03C3F188632F
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 08:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E364F16A959;
	Fri, 31 Jan 2025 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jm1bOVnW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA77158A19;
	Fri, 31 Jan 2025 08:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738313679; cv=none; b=P5vF6ozUVMtTzH1ZF9TegWJiGo/Y1K/zq9UqlSrKrFJYkDhru/pgfIrh1GN5WyXX5H1q6O47GrQAaGxuYvkoiB2MhN1p+d+GffI8vV4G57mvs4I1K6F3/6cigLXmGUTmXAbJKIsV3RIK/QHFZTiLF10dm00H84S9/KICnrA/s2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738313679; c=relaxed/simple;
	bh=0yeoWHsptm0KXQm6mUBpcl/+kDScxLraHXzPrT7SMYU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ldoKe4fQL8KkGNUbBnYIkTUE3/hvL/tSRO14GR4hZgxBeHcW/GjjKUCJVY0dQ8AAqUVy7DAEw0qovp0T6EKPXG0LX8YUb/nAmP5bkigFfNPX4GKz0/JhG3ilepOL4LQcSAoykG4vtW04cLdNc0Br3MNRtH/Kjedd6GZS0nnwpQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jm1bOVnW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OALS030285;
	Fri, 31 Jan 2025 08:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0yeoWH
	sptm0KXQm6mUBpcl/+kDScxLraHXzPrT7SMYU=; b=Jm1bOVnWWeG/LTOgF7Qgzi
	s9uYuUENnn8AQBg0IKy8U5Ae9oHkJFmaGak0hKlvTgVSwr2VYOOGlclMlYjLUU34
	T3ohRt7u+X6ijdJoHXQOahQbOdYS3rSjOsxUBpqgPLGqCSzMdHkoG1JSwgBqis6M
	yBO/sspmmv/N66Z6a+ZoHomfrL2HNG7dx4JxCmmM4OGwnvkzVto/hSerySZ1hIMJ
	j/Tvn9iI39ED4zqntMm/txPAo/yudtsJqFSGM5EwctjQukUDZQazR4H5c3OlwaYR
	9wcpmhkrC+mZBkRgg8RucjJDaQQnFR4d6ezhAUitlx58nZu43F+NhXUXnv4+IHGA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5anxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 08:54:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V81VGv013887;
	Fri, 31 Jan 2025 08:54:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gf93areq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 08:54:34 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50V8sUY621037456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 08:54:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 924DB200C9;
	Fri, 31 Jan 2025 08:54:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 714CC200CA;
	Fri, 31 Jan 2025 08:54:30 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.71])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 08:54:30 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jan 2025 09:54:30 +0100
Message-Id: <D7G4RNPQ6OMB.1QPZ0SXHRI1IK@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x/Makefile: Add auxinfo.o to
 cflatobjs
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.18.2
References: <20250128100639.41779-1-mhartmay@linux.ibm.com>
 <20250128100639.41779-3-mhartmay@linux.ibm.com>
In-Reply-To: <20250128100639.41779-3-mhartmay@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7OHoxltFa_Hj-KA79rVCXu38PQBke8lR
X-Proofpoint-GUID: 7OHoxltFa_Hj-KA79rVCXu38PQBke8lR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_03,2025-01-30_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=679 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310064

On Tue Jan 28, 2025 at 11:06 AM CET, Marc Hartmayer wrote:
> This makes sure that the file is removed in case of `make clean` as the t=
op
> Makefile cleans all objects defined in 'cflagsobjs'.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

