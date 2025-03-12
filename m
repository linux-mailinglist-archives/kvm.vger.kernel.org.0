Return-Path: <kvm+bounces-40831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6A4A5E02A
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 16:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78F7719C06DE
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 15:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01526256C94;
	Wed, 12 Mar 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N6Qz6MBJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4BF253B4A;
	Wed, 12 Mar 2025 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741792754; cv=none; b=A/SCRslzWQ9DcxbemdFTokYTWpvEHlf2XGcWQgZ1ANAXsrTY6L6B3hBLC1Fvw+iefMCYKP6AXu9ssYIct126RrgApRzWa4cdSoS903UKl1YBh3LFWtrJe5QICaIZK67JcceBwiWe8QAxifvuy0+sZ0WmdjRksdosq1bvwdDldWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741792754; c=relaxed/simple;
	bh=jNb7ofhEY6SToOBHz5m6ErUAC0PyqJ9CZaND4c4AKDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tjA8utZqxbz4RoJsyvNcgAonPArrXfI9ej2qJGPjNsBoSis5ChBulMgzm9ySsXsWbIXTs5bokkemRTW5bPRGvWkShrGrXsCwVcNSNidmn0Zb7wcQxngb615beIG6npOByBcIJR8aQrhyyWmAeWCsnWcG5cR5PFnpM/wWYsO8byo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N6Qz6MBJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52CE3FvS023107;
	Wed, 12 Mar 2025 15:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ok6GZB
	71aBRQITqSs+UG3I4EO7p/C6x1/eDKvx/Ld5M=; b=N6Qz6MBJkKEFfQEQfTwQ/6
	FwhWphgSJAM0uD+E7GIZZQXJL0aHSEIgsS+pOHWhsMaoKRok+y9omYf9r5dJR0IE
	te7deJadVzh6zyrtZru0f+ZHXYV+Ku7/7HTuqnEwPHDSIPdiGKfThungoULt1vOX
	GJHqMTY8TWcQsunDiQH5Ci3phaHYRbbfBxEZT28Fya0fccPCUexjzTLvypEJcqDo
	daFbc9O5sNpB84o7UzwvYrgB9VSGPui70wnbiY/emIwEDF8KvMdJqyW/un13YAdZ
	SaQTORHjbYL3mTeMLK+R/IUbL1oAZjEfQpaw+djp7BYX1+s/miLJBaNtukPyHCXQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45bbpprekh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Mar 2025 15:19:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52CDjQpK026048;
	Wed, 12 Mar 2025 15:19:08 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45atspcs6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Mar 2025 15:19:08 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52CFJ6lQ55378362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 15:19:07 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9A075805A;
	Wed, 12 Mar 2025 15:19:06 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0F2658052;
	Wed, 12 Mar 2025 15:19:05 +0000 (GMT)
Received: from [9.61.55.227] (unknown [9.61.55.227])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Mar 2025 15:19:05 +0000 (GMT)
Message-ID: <b763cd33-fb89-498a-841d-1a5423b7ef9b@linux.ibm.com>
Date: Wed, 12 Mar 2025 11:19:05 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: lock mdev object when handling mdev remove
 request
To: Anthony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@linux.ibm.com,
        alex.williamson@redhat.com, clg@redhat.com, stable@vger.kernel.org
References: <20250221153238.3242737-1-akrowiak@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20250221153238.3242737-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ch44e_yl2Ni0C-dx_O-Zjlp6RSe5zxgc
X-Proofpoint-GUID: ch44e_yl2Ni0C-dx_O-Zjlp6RSe5zxgc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-12_05,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=958 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503120102

On 2/21/25 10:32 AM, Anthony Krowiak wrote:
> The vfio_ap_mdev_request function in drivers/s390/crypto/vfio_ap_ops.c
> accesses fields of an ap_matrix_mdev object without ensuring that the
> object is accessed by only one thread at a time. This patch adds the lock
> necessary to secure access to the ap_matrix_mdev object.
> 
> Fixes: 2e3d8d71e285 ("s390/vfio-ap: wire in the vfio_device_ops request callback")
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Cc: <stable@vger.kernel.org>

The new code itself seems sane.

But besides this area of code, there are 2 other paths that touch matrix_mdev->req_trigger:

the one via vfio_ap_set_request_irq will already hold the lock via vfio_ap_mdev_ioctl (OK).

However the other one in vfio_ap_mdev_probe acquires mdevs_lock a few lines -after- initializing req_trigger and cfg_chg_trigger to NULL.  Should the lock also be held there since we would have already registered the vfio device above?  We might be protected by circumstance because we are in .probe() but I'm not sure, and we bother getting the lock already to protect mdev_list...


