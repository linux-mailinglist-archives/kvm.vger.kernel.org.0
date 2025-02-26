Return-Path: <kvm+bounces-39313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A234A468E6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBA697A7EF3
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5236236455;
	Wed, 26 Feb 2025 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SBV6QVa+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302F235C1D;
	Wed, 26 Feb 2025 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593159; cv=none; b=c01kGfgQDnIz/ni8ACRIXlWOCBKWKiThA+dFtwLZdyxD3i4xFncnNwhwfBTRDthrb1f3bq1EzafyOI+by/EUMRkFEBGNeu60D5wwluQ5v23WQilE2vRgBQFjH2VYb2w8fPsTeFKq+wyte9hVC2m0h2Lg5WR9IG5hLTzh+qcogiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593159; c=relaxed/simple;
	bh=VF043pIka15sJ1BK0E+G/cIHJyHcLh966Xv0M6dKIzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lgtTkJGvm7O81i3c3pw0vvRtOEa6UL8/VU1i7Z3d9IbQXt6r5J+BP1Nlw5yfEmla+VqQY8K6F1xItC0fz4kkA04euXRr7xQfcZkSrgI3/RMwoXS3KYR55O5jwzzLePB0g2Xqo4tr1RdY9XHzv+CUm5T3+NLCIuYJ2Um67xQIjuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SBV6QVa+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QGi0Ml005793;
	Wed, 26 Feb 2025 18:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wcRR48
	GIkKSbwu0Ax6WMNQbCjFwOZear2JpkHKXZOys=; b=SBV6QVa+CKL2J//YE9rCvJ
	UXTPbavQIcwnkEJ5yRscphPeRDroMqALELnY/g5s0A1JZACKxN3KcjznRSQPaS/C
	4bf2t1a3ivyap6vcdIOEssF9fA6ZzSxUDpLjOAHdd+1uL/gtBwHBoIupqha1HQTE
	IDWhbOUNNZD7QbaILNFBrP0AEbWiQI2HGUZz2WFZQSQlrA1hojwAb/yt4sdjz1Gj
	6POKZ6y9QuLxFgsy1M9ZL+gYiXFurxln5RneKlasl0YLfgx7kWCWXgGTBV5HBigP
	z8zPpUl/CPru4Ms4A24eyOb4TukLQSCOp8HAX8zk3XhfbUh/Q/OpUuAH4tvp+Nmw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 451xnp32b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:05:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51QHslMr012507;
	Wed, 26 Feb 2025 18:05:54 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9ymbyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Feb 2025 18:05:54 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51QI5qph24576662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 18:05:53 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE4D55803F;
	Wed, 26 Feb 2025 18:05:52 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 305BA5805A;
	Wed, 26 Feb 2025 18:05:52 +0000 (GMT)
Received: from [9.61.248.9] (unknown [9.61.248.9])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Feb 2025 18:05:52 +0000 (GMT)
Message-ID: <e420953e-418b-4ea5-a561-015597a59d9e@linux.ibm.com>
Date: Wed, 26 Feb 2025 13:05:51 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/2] Eventfd signal on guest AP configuration
 change
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: hca@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, akrowiak@linux.ibm.com
References: <20250226180353.15511-1-rreyes@linux.ibm.com>
Content-Language: en-US
From: Rorie Reyes <rreyes@linux.ibm.com>
In-Reply-To: <20250226180353.15511-1-rreyes@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4TvnBDIZi2vzTb6rONKQWKP5TF2a44l4
X-Proofpoint-GUID: 4TvnBDIZi2vzTb6rONKQWKP5TF2a44l4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=924 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502260142


On 2/26/25 1:03 PM, Rorie Reyes wrote:
> Changelog:
>
> v2:
> - Fixing remove notification for AP configuration
>
> --------------------------------------------------------------------------
>
> The purpose of this patch is to provide immediate notification of changes
> made to a guest's AP configuration by the vfio_ap driver. This will enable
> the guest to take immediate action rather than relying on polling or some
> other inefficient mechanism to detect changes to its AP configuration.
>
> Note that there are corresponding QEMU patches that will be shipped along
> with this patch (see vfio-ap: Report vfio-ap configuration changes) that
> will pick up the eventfd signal.
>
> Rorie Reyes (2):
>    s390/vfio-ap: Signal eventfd when guest AP configuration is changed
>    s390/vfio-ap: Fixing mdev remove notification
>
>   drivers/s390/crypto/vfio_ap_ops.c     | 65 ++++++++++++++++++++++++++-
>   drivers/s390/crypto/vfio_ap_private.h |  2 +
>   include/uapi/linux/vfio.h             |  1 +
>   3 files changed, 67 insertions(+), 1 deletion(-)
>
Please ignore this email. I sent the wrong version

