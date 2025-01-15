Return-Path: <kvm+bounces-35524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C349EA11F16
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 11:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2FB4167FD4
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 10:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B2120B1F5;
	Wed, 15 Jan 2025 10:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PB8OzkBf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395371DB138;
	Wed, 15 Jan 2025 10:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736936428; cv=none; b=s2gpMcqpZegBJfDuLq9Bo2/QyXkXS+Iwjt6IypbvfgkWhPU/5V8spPn54nahXJ2OukN3oRmfe7+iRmO2MSNJ21GsMTJ+pudgK4ShZoLJPmz4pSke2s6KdLfDEM4WeJU287VSzua4Xq3NB0XKnAbIO3GZeKU+qHWoWgmykPYJ97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736936428; c=relaxed/simple;
	bh=34JBOL+zmXvpqgSI8+nty0X501Jw+lBz7cs5HMeIv/4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ecwnq2DZ+prf7wCq7hyUyGwuToUcLqYqLGQFJDI+lAt3BDuYGmY9Ven2W5cm/g1fz+GYByGL/6RpMAUS+4gl0i/1Nxnd0H7j69tcJNIGhFQOLAU7jheB/P4XInj2fUnuxGzHd2gjh38I/eeZYxGAWaViuzPOi6f+QITA5mDEicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PB8OzkBf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F85gHI017620;
	Wed, 15 Jan 2025 10:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JJ6HKq
	fUSWCMS+eOo8zfcV7T2eVAkhZjQRFPu2Ff1zI=; b=PB8OzkBfArqOv82ewgehZ9
	rE72inVzN4BP9ZCPGzdTlXJaYalXZOaz9cCPRR+rc2Sqk8ftNQ+xvUzU9bCOu0cn
	NiOJoY7/nDWbWgc2/q/FwmOqnw8QbsXozABtCDhGPL8/1ldHHT5hgw2q0LPpVh9+
	7OqUu9x3ztCmb4bslo8A56gK2zKBOxkxIJuzIk0PXTkr9OQdRYQlaHkEvI54V0s9
	QGz8ZQmrAGF4Hq9vABRQL6q8rLAdCLDwMNTvSIdEwufht+jhaE3P2hiEgPpGZ4am
	87Eu9cI9/ai9SfOpQb4H1wxhWdJrxub/gTYUv71Cj2CTzHYbFiwoOdaFtEKNI5MA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4469730hxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 10:20:21 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50F6gAqd007386;
	Wed, 15 Jan 2025 10:20:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443yn7s1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 10:20:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FAKGxY56164818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 10:20:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B47F2004E;
	Wed, 15 Jan 2025 10:20:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 644A92004D;
	Wed, 15 Jan 2025 10:20:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 10:20:16 +0000 (GMT)
Date: Wed, 15 Jan 2025 11:20:14 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 07/13] KVM: s390: move some gmap shadowing functions
 away from mm/gmap.c
Message-ID: <20250115112014.19ca99f2@p-imbrenda>
In-Reply-To: <91c13ac1-ad31-46e2-8a07-9b759caaf33d@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-8-imbrenda@linux.ibm.com>
	<91c13ac1-ad31-46e2-8a07-9b759caaf33d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0ZhncPHzJScdkmu-7GRgnKKpGkoDVVg4
X-Proofpoint-GUID: 0ZhncPHzJScdkmu-7GRgnKKpGkoDVVg4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_04,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 suspectscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=773 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150076

On Wed, 15 Jan 2025 09:56:11 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/8/25 7:14 PM, Claudio Imbrenda wrote:
> > Move some gmap shadowing functions from mm/gmap.c to kvm/vsie.c and
> > kvm/kvm-s390.c .
> >   
> 
> Why though?

to start removing stuff from mm

> 
> I don't really want to have gmap code in vsie.c
> If you want to add a new mm/gmap-vsie.c then do so but I don't see a 

will do

> need to move gmap code from mm to kvm and you give no explanation 
> whatsoever.

the goal is to remove gmap from mm, as mentioned in the cover letter

> 
> Maybe add a vsie-gmap.c in kvm but I'm not so thrilled about that for 
> the reasons mentioned above.


