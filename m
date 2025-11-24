Return-Path: <kvm+bounces-64414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B5EE5C81ED8
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 422684E8020
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D87314D1E;
	Mon, 24 Nov 2025 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PXbJGhz9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508EB2C11D5;
	Mon, 24 Nov 2025 17:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764005767; cv=none; b=BBOFZjTtctF+JCjXeioCUe1/X6tJoiT+YDO4JBCqkN7VNkBvUA4MHXrNZRgkNETG08iozaXfUa93LFAdWB0AIh5b+8kmp5nBhAdHj05isEomFBma6B9cmKlhLRT+Rp3cQgeAZR5NnZkUGKcS6xe2ze0GUIyUnbmPxdY2DXAyRIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764005767; c=relaxed/simple;
	bh=e/oycxQ/8H7/jZ06LoMfFWT6Vzos45lv7jGbtm4/2K4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IeuaBNLDl0oA9GqMm3NliYknA0KouAlQvJbws9qNQVqqK8O+g/ZeQRibpP4OwIwjCNuBeGq2/oUlUw8SylELYrsAGLgss6UIlyKY4J6DblefNX71qWhGp3RqqDX5AcT7qBR3gJkD3N6mC+7zMBeY7UB+PRIy8JGdtr46sminrT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PXbJGhz9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOF7O7k002998;
	Mon, 24 Nov 2025 17:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cr0G9s
	p4L9wvGN7NRxufPm3C//qjm5o8gj8+qxa/2J8=; b=PXbJGhz9pGkF+ucxXOd77v
	s3zxuouSAkglnMscj09PWaaVZ2K6NPGrg6aexxn3HXEP/qixMvv1Qrz1dTEbgqv2
	XCt2H9aqX60vOUHOCumR5g0MJcI6CbZtNsIZFYJNLJGss/Po4K6P1s0ull9OOlcS
	S+Y0Nvf1bXhUWId98oltPH1o5RnKhntRVgIt8bsmlxOOVtdpDPqB6lkvnZ5MJooU
	l3Z4Ib3dTLtgRUT/KTpJTvErIvAPz45MFcFmSzDK5qD6nuHxAz4hRtZg0oNVoFZ/
	uykpSV52iqnqct7uHei/eIMizWVh93Y2DfiyQliQSW5NDyNfmo4iW0PUyWdjyd+w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4w99dj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 17:36:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOHFcgx030775;
	Mon, 24 Nov 2025 17:36:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgs7c8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 17:36:00 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOHZtFF48234968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 17:35:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E9A12004B;
	Mon, 24 Nov 2025 17:35:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DB4120040;
	Mon, 24 Nov 2025 17:35:54 +0000 (GMT)
Received: from [9.111.66.87] (unknown [9.111.66.87])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 17:35:54 +0000 (GMT)
Message-ID: <da705f02-9f8f-4a4c-96c6-b507c88f92b8@de.ibm.com>
Date: Mon, 24 Nov 2025 18:35:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/23] KVM: s390: Enable 1M pages for gmap
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
 <20251124115554.27049-23-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20251124115554.27049-23-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfXza/731TfrDiI
 5L40wnscnsSQOnWAMD8TeMGMdSo3t01ICDX+AtFBbpAK+FR15GD8S+OWfSeue0QeJ16el2FWfUL
 hjDA+rCcm7xurav2ZVFpfwJ6g2wNcACEOuKfp85Csc8dOxkiNoWYfJ1K4XVBfwN+T+y+8Get4FK
 B27T9p4NWm8/IwEvZ5bo/tmM7WjZMLUsR0lfRmB3ZxwTFn9+OFMQy6z/lh9QomgY/WtyCAGtt77
 uq1haiPXDPj81YJfzH1rn7jNW6xXjtqPaHz5YMxXu/V32IGZZc/9JOAl/2SzkTBhhg4JCQ0BHoq
 YCQu7rpqANk+xN2LuBXb5gl9IHcUXE5BJ3j69izCLUAn+6QPjaRtpiH+/M+vChAWGrrlJHbQOxt
 2ZbxJDU459qwcZnTRNlePKrsXN/zLA==
X-Proofpoint-ORIG-GUID: jnma2gun4kttsFkuBsXLiryh0XB5LEOz
X-Proofpoint-GUID: jnma2gun4kttsFkuBsXLiryh0XB5LEOz
X-Authority-Analysis: v=2.4 cv=TMJIilla c=1 sm=1 tr=0 ts=69249781 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QnHJmA3E2XFGw8ITv2AA:9 a=QEXdDO2ut3YA:10 a=yzbO-VOS5BcA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

Am 24.11.25 um 12:55 schrieb Claudio Imbrenda:
[...]

> @@ -5837,11 +5838,6 @@ static int __init kvm_s390_init(void)
>   		return -ENODEV;
>   	}
>   
> -	if (nested && hpage) {
> -		pr_info("A KVM host that supports nesting cannot back its KVM guests with huge pages\n");
> -		return -EINVAL;
> -	}
> -
Yay. As a followup (when things have settled) we should set either set the default of hpage
to 1 or even remove the hpage kernel parameter alltogether.

