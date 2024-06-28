Return-Path: <kvm+bounces-20688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B03691C51B
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 19:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 255D21F238A8
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 17:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6041CD5D1;
	Fri, 28 Jun 2024 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KJWaBZZC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9711CCCBB;
	Fri, 28 Jun 2024 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719596683; cv=none; b=qQjP0EcKWgtxrE1qJ1sp1d8d65TmCpkFr90zMFtETWbJxwhD3MNo2jVKSDTmIdjqYqSnap1X72goO5Knjssc79GhHCMKfomYWzNNHbZr3VLKOtId/kNQ8YAVETlKqj3MY520b/KTxy21ljCGU4ZwZ9ZW7V1aaW/Q9W4ebRQBL+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719596683; c=relaxed/simple;
	bh=g1u+wiuG/EMk/O94sM/CCvl1CRAmDj8SpBlEI20QD9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AamTdRCh/Cs0oajHgLGHY4UgQI2j+EX5FpekNkQBJ0+TFVyz4abz7JNN+bdv0EHHwjGIvU9Gb9Q3239cFhgS8rs1yancQYPdmIRNCiWaqBMxbl0GEOp09FF+rIH21RDISLyMBjUgfaSmeD2Ub1OIy7J48OHvDepIIPTh5S8V+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KJWaBZZC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SHStPV027419;
	Fri, 28 Jun 2024 17:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=g
	1u+wiuG/EMk/O94sM/CCvl1CRAmDj8SpBlEI20QD9A=; b=KJWaBZZCHkMP0zxou
	wCks+gi5WQT6kbkTPLZaqKzoNkzMRifYzSopd9sGYqmEwFNMsem4LtmMhlbNgKxl
	BT1E5s3yF4srVRi6aSXr9nd9idK1q2wDRKanzb4bhy70QLD3ja5tTmTVzaHsqf4/
	TpFebmF/XRnGgjOXI74zdmw6Ez5Vu0YbWtHvXDKU7rokrs28Q+EfdwEUA09GKGc/
	epUqx2RTzQyHG02YT7v9ofgaJl9BaxCdR71QROU/oxAJma6uK6xH/N9wUPWN0hLd
	Uth7Ytii5csj0Yr1nG6lrom4efzaTT12q/mST+ccIkLk0i33HfeI9H4PVqKgL9ri
	XH4Vg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4021kt0164-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 17:44:39 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45SHfOJ1013582;
	Fri, 28 Jun 2024 17:44:39 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4021kt015u-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 17:44:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SEQjmX019897;
	Fri, 28 Jun 2024 16:55:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5n13qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 16:55:11 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SGt66618809268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 16:55:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C26E2004B;
	Fri, 28 Jun 2024 16:55:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF76820063;
	Fri, 28 Jun 2024 16:55:05 +0000 (GMT)
Received: from [9.171.56.135] (unknown [9.171.56.135])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 16:55:05 +0000 (GMT)
Message-ID: <845b1fcb-d976-4414-a883-7eacbe55ed02@linux.ibm.com>
Date: Fri, 28 Jun 2024 18:55:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
 <20240627095720.8660-D-hca@linux.ibm.com>
 <23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
 <20240628172259.1e172f35@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240628172259.1e172f35@p-imbrenda.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fnfXNAMDmAnupe0DUW9vo7BB1gbYOYr4
X-Proofpoint-ORIG-GUID: SXvg07TKRGw7AYrXPB0d3vNaKYXwYUru
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_12,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=749 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406280129



Am 28.06.24 um 17:22 schrieb Claudio Imbrenda:
[...]
> disp1 = sign_extend64(disp1, 20);

[...]

> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I dropped this RB since I did use 19 instead of 20 for sign_extend64

