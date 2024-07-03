Return-Path: <kvm+bounces-20907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F709926763
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 19:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E213A283E2A
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A5F1850B8;
	Wed,  3 Jul 2024 17:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ckIFOcMz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3DD1C68D;
	Wed,  3 Jul 2024 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028759; cv=none; b=a8OzRxnMOWJGBeufXcqq8bVU40DmUubQxUPxWTc2xLmHwReK82t1XVd5KhxJ4eKHhIxtWKVMfEZ0z0jvSM7PG013IVc1Apq5U3Rsr/Q1tsaduh/RcU/nfLB01YlFtd6OSvlnDGTFOm4IyKBQcVU6NKbHIFUr/7tqelrSd1cqDIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028759; c=relaxed/simple;
	bh=H65y2CxWIKTt4u908QVncl8gHfIvS6NrOi/AJMAAvI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TWYY9uAWmYvrV2aBZvnHuV9Au3f9dNQKRd3P6fj7EWpGCfHLuRhTOVPZ1fB+G/Dbnd7R51FYu7c8ganp0ZNgpc5GSW6w7kFNXE7c7t/bgGR00mQhfj6S5u2leHid33obOcnClQ7toBQJZeskSHKEjqmeBWHjdOG4rh7lT1xd+CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ckIFOcMz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463HY1th027224;
	Wed, 3 Jul 2024 17:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=H
	65y2CxWIKTt4u908QVncl8gHfIvS6NrOi/AJMAAvI8=; b=ckIFOcMzPdMSOvsu9
	2C5GD/FqoNT/DTd2CxhlG6ZsV1tA0hKzmfQxEp4Ya5ndKG8DaW+RRt65CT/cOuLj
	WSIY56PMCxgBkQPmwPAXEA30cZJtV1LAy2MLP8VzUXgvbkQlUdGJ5ARZxeSeN8dk
	67lhKU+ElTzhnAOJ7+01iok0jxZDstivjKVThn/emoM9ZaExzJMJtMFHM2n0aVmK
	LPgJ0WCv//EsCb1UlUqX4MgugTCLA2NwyAUVYMlqL8sNFuDXVsmR6AU1HjlB4PY4
	uMYORlY3aopWUujpsgYYkFXeslSEFqNMh75ne9NMCmILOUB3iCIYlQhR+y4++gnm
	5BhjQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405a6p85mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 17:45:54 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 463HjsES011078;
	Wed, 3 Jul 2024 17:45:54 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405a6p85mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 17:45:54 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 463HDKkB009470;
	Wed, 3 Jul 2024 17:45:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 402xtmujjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 17:45:53 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 463HjmJK57540936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jul 2024 17:45:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1196820043;
	Wed,  3 Jul 2024 17:45:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D05A2006A;
	Wed,  3 Jul 2024 17:45:47 +0000 (GMT)
Received: from [9.179.31.79] (unknown [9.179.31.79])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jul 2024 17:45:47 +0000 (GMT)
Message-ID: <06d47a92-1ab7-45c5-97cd-9ffc51590096@linux.ibm.com>
Date: Wed, 3 Jul 2024 19:45:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE instruction on host intercepts
To: Janosch Frank <frankja@linux.ibm.com>, Eric Farman
 <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240301204342.3217540-1-farman@linux.ibm.com>
 <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
 <1deb0e32-7351-45d2-a342-96a659402be8@linux.ibm.com>
 <8fbd41c0fb16a5e10401f6c2888d44084e9af86a.camel@linux.ibm.com>
 <dceeac23-0c58-4c78-850a-d09e7b45d6e8@linux.ibm.com>
 <6dd02110-9cff-4a23-b823-a15c4ce1b065@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <6dd02110-9cff-4a23-b823-a15c4ce1b065@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QH_a6j4MMZz7yOxTYGavNAu2NMeBaENc
X-Proofpoint-ORIG-GUID: Ic0LQRHfxuuv32I1iPM2UxPPBcLEl7Bs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_12,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 impostorscore=0 mlxlogscore=706 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407030129



Am 03.07.24 um 16:59 schrieb Janosch Frank:
g>
> This patch has had contact with the CI for quite a while and I'm gathering patches.
> Is this an ack now?
yes

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com

