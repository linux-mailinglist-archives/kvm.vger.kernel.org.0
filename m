Return-Path: <kvm+bounces-36965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 740BBA23AE9
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 09:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4758163938
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 08:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBA016ABC6;
	Fri, 31 Jan 2025 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XUoFmKLZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7153485260;
	Fri, 31 Jan 2025 08:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738313802; cv=none; b=uk76BWpOLegrGb3drJxPfouAUrTOxieAqdIUkn6y0QyaV6gCLXky5Ug/mQcSlZZiUvBhr49iRGIpNP9YQ+5zRtEOMiHpNFYt+xDpvpwmF/zEjlJ6jyduR94GRz0LLV6NH6GUI0sESDvgB9eK0GLAznDa4uQ1CKLCL5Nm5kB7TDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738313802; c=relaxed/simple;
	bh=p4IR+mEn8NGcfomUhFfWmtewWrRS2R+frm6WviSIM3Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=gx4nMtcYb3oDTKAPD36I5OQlnfH80uy6rSBl8sP/q8s7M/Cm67YAbeSFUG6qAVgZbGPsDKOhyYcRFHUMFum2FHCiR2OYkt6Wwf3uSGtg11WRjEAYitkFnQTKbXDjaofo/xLM7RBQKvaFgpKQ+Ahg9GMlzswUsAeuu2cW7hOviv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XUoFmKLZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2OR9A030633;
	Fri, 31 Jan 2025 08:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=p4IR+m
	En8NGcfomUhFfWmtewWrRS2R+frm6WviSIM3Y=; b=XUoFmKLZlSQjDIIrTqbFMy
	EEylZrOiL4jwOBbX0B2hogsgci8RNCqlCdhrlI8UIBjIqvacKZOW6Dz3XXRcvYZo
	YoVbSS26IFLMmpPO5nt9VDU6+4rAfh8opvC/XO/N78K4V1mHsTQ1LfnB14cT+F+t
	LBZFBDGzTF5rRBsAXa8u8b5/ipxyT4xYuDFiwbQ0jCDKOXEWHJcUCBaBwQnkaAav
	LfYnkPoWVaNwCRMDvKqZvS72igR2rF9lHc/MD4xS1vC2kDAEQCKY5LDvf4ZcuslG
	p3OecFfGxb4gV8gRqxYV+Tp23Jes4WQOEiGjHIIpX58Y/Nuf+D8G7zlphmKuYnBQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5ap4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 08:56:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8BKoI024533;
	Fri, 31 Jan 2025 08:56:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gf912s0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 08:56:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50V8uXSV50790856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 08:56:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DDBA2008C;
	Fri, 31 Jan 2025 08:56:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BC7C2008B;
	Fri, 31 Jan 2025 08:56:33 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 08:56:33 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jan 2025 09:56:33 +0100
Message-Id: <D7G4T877QYSO.33DIMA4IQXFKX@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x/Makefile: Make sure the
 linker script is generated in the build directory
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
        "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.18.2
References: <20250128100639.41779-1-mhartmay@linux.ibm.com>
 <20250128100639.41779-2-mhartmay@linux.ibm.com>
In-Reply-To: <20250128100639.41779-2-mhartmay@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nvSwfKuoPUU1382jZbS8GOcn-flfuOSC
X-Proofpoint-GUID: nvSwfKuoPUU1382jZbS8GOcn-flfuOSC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_03,2025-01-30_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=802 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310064

On Tue Jan 28, 2025 at 11:06 AM CET, Marc Hartmayer wrote:
> This change makes sure that the 'flat.lds' linker script is actually gene=
rated
> in the build directory and not source directory - this makes a difference=
 in
> case of an out-of-source build.
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

