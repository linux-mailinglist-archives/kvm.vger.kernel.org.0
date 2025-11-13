Return-Path: <kvm+bounces-62998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 356C9C56CFD
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 11:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 55AD74E6806
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F606314A86;
	Thu, 13 Nov 2025 10:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jdmo17yd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BA914AD20;
	Thu, 13 Nov 2025 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029137; cv=none; b=knYYk0rTpq3q9M0PG4r8xbUW9n/COT+HjeM9J9koPUTDuMLMdbhXokYf8zIhfX5SQ12kMLC746PmecMCnH5wLf3bSbveCkDSulMhAPuQ39x2ZjTSiGc/KUu3ymAEBVAjtxU2uS/iHk95L53D3zWi9Dwt/bRHnKho8MhqwbF+iWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029137; c=relaxed/simple;
	bh=XyHOGRyLyTBRyQsxtR1tnGdoFyijF2WgBu/BGuiL+U4=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=NP/yv/Bl3P6koN3rLUzx88mUNNYcNH51APpq4Rq9kAGnFHLcVRGkmt/Qw1KcMZA/Q0ufj7Ige0W3+z992m0TF+cyCnNiiJuj4P8miqt+kio9KFsoju5du8MMeOrHo1IIe2tJlV2arL4KQCuKEp0o2hLMd/DL5/8q7ZPb/e6YHLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jdmo17yd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD5ZXad009449;
	Thu, 13 Nov 2025 10:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0mKJmP
	AETsGmfv3UOpULntHIsQEeG1GgBH8GJm96EEI=; b=Jdmo17ydqWXkOkdq59jzAx
	zWDgypTPjnJ9DskJHqdjbN9PeXZUEHvBGg0b/cQLmGjvrglcBUooWP4ny4reNw1W
	FSxx9eUEJQdhxdrunG7d0kui6MdUdrJPxczPXhFWKtf/emzZjNp+xV3cE7RX1oFX
	W15K1Z7IF342FUidOKjZXmYPe/MvTaYokSTQZuk3/2PrcqBwJVsMulxK378OPK39
	BWNoBVc4DH4T/QdBEgj5eKcvilcRm2ncwmi99Nw1mLV7EUYZ4myKG1axVAP3itDY
	BytQWNLTrWdKKLdKt0UsjqA2GEtx00xWgT8UsE7lNTJ1bbKQMc8bty746JEX9WFw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk8fb9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 10:18:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD8cxi3028859;
	Thu, 13 Nov 2025 10:18:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aag6sncva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 10:18:52 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ADAImxa62456162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 10:18:48 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE64820043;
	Thu, 13 Nov 2025 10:18:48 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96A8F20040;
	Thu, 13 Nov 2025 10:18:48 +0000 (GMT)
Received: from darkmoore (unknown [9.111.1.139])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Nov 2025 10:18:48 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Nov 2025 11:18:43 +0100
Message-Id: <DE7HNY4I79TM.1EAA75D8OW13C@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 07/23] KVM: s390: KVM-specific bitfields and helper
 functions
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@redhat.com>,
        <gerald.schaefer@linux.ibm.com>
X-Mailer: aerc 0.21.0
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-8-imbrenda@linux.ibm.com>
In-Reply-To: <20251106161117.350395-8-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX+EJ0nH+bMoWd
 VB5IAUfJHUVhxTLV9i18peLzF0pg1YB4lT09gKo3RnSOHPhK7kjC27CdNs7E/uTaauGQaP6zBWk
 wO7rj/cdA9RgLe0Aw8XQ0+X8PCDe4Sm4EeB8iNtxoWfGEkLjmq+uFUfup2MIx5hNqjGsQyLXHgf
 imZpqd3NbUD7HA7ZsnYl58b50AOE13GxpY84Eu+YKFR/wdfzWCc8+eppUxsGsGk2If9XFKfabIq
 UT6f6XGGTk1o746PLH62GgmGrEUlcqoNfoJ0F8ltae7URovm/XOQIogC8062u7NRzyWSHcW8XHG
 ex7M0kfG/jJrBzB/BFsHR758+CBpQKJ3wYjvGLb3wLjiJg3PxCnXKvCNmGEF8PMqxvTxE0I+K7H
 joybQljdGPX2d3axUqPRuswekUIqSw==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=6915b08d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=1VCRT6WqKb7475BWb5YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: BQeDGuVaLkAloej7Wate6MvldPMBh_On
X-Proofpoint-GUID: BQeDGuVaLkAloej7Wate6MvldPMBh_On
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_01,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On Thu Nov 6, 2025 at 5:11 PM CET, Claudio Imbrenda wrote:
> Add KVM-s390 specific bitfields and helper functions to manipulate DAT
> tables.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/dat.h | 726 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 726 insertions(+)
>  create mode 100644 arch/s390/kvm/dat.h
>
> diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
> new file mode 100644
> index 000000000000..9d10b615b83c
> --- /dev/null
> +++ b/arch/s390/kvm/dat.h
> @@ -0,0 +1,726 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + *  KVM guest address space mapping code
> + *
> + *    Copyright IBM Corp. 2007, 2024
> + *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
> + *               Martin Schwidefsky <schwidefsky@de.ibm.com>

nit:
As this is a new file with new content.
Remove Martin here and set the copyright to 2025?

...

