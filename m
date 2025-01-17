Return-Path: <kvm+bounces-35775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFFCA14FB5
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:54:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268E9168DC7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF4E1FF1D5;
	Fri, 17 Jan 2025 12:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ExvSIVZo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A011FCCEE;
	Fri, 17 Jan 2025 12:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737118438; cv=none; b=h9DhS855FO1tZwwzneEgLj6dvg5ljka6tP6t5CIsZj1e0d8OEKAoPTxLjOFerXPC2qRnT6IpYmP3WxciAjps/V1/OP33G7g19LN0yZD0pThFYazDb3gyKB4D2osz4VVC+8HuE4dE7+KRgxRgVJMgbS32sSnysBUy501WIJjmEco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737118438; c=relaxed/simple;
	bh=doqCG7laBueB9EWBKznsARUguaOwhgETkntcUv2kxoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPJo/fEi9NShrRW9wB/pH+wg5UtP2yyIWeWQR1032hqoM14uAuwStIz5lR1FbJVnG64MnxoN3JYvOLeDzPnsBb2Ud//AkcFXjmv3Pp8mDMhNorYEHQTSKlYAZb/8TZnL0aG5MO89W8Ey+xNpVk1XOKl8Yc6a5GVBmJjrxTa2tUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ExvSIVZo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50H85ZDb000477;
	Fri, 17 Jan 2025 12:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xa7arA
	diXZcYl7b0Vx2hxLB0HVI9vKgwnvqk/kBUWXE=; b=ExvSIVZorMe067V8SAB7C/
	mHTKI9v94LG/vvQm/vkekTZIVo4zj3H4MZk1GBRR3Szi9ZFIvxOl7xbGdWWqZIis
	VQG2E2htwl7ANwnYztWJdqtuFQ6OYeuJHYySdHA3D1+x7YZ2LtQgkVFk5xEQ3Bpi
	8f1cQT3a+WUz1mQyDwYZ9/v3Tt1LDA1F363zXbScRjWTNCz4h8wt8ruTdpppzoJ/
	y5gTUz8QG1RJgQ2ghSxywL2XC4CrQvCBhybQmsr+WI1aghELxQC15Tza7Me9/ZV1
	MWtMUBVovElbZjsMhcuXwIW2z3dyjaBLd4mix1zdCKqMbmU47hgR3fcMbdTvP+xQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447kd3h7bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:53:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50H9BL2Q004529;
	Fri, 17 Jan 2025 12:53:54 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442yt344q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:53:54 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HCrrZN32178928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 12:53:53 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8E4F58059;
	Fri, 17 Jan 2025 12:53:52 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A5D7258058;
	Fri, 17 Jan 2025 12:53:51 +0000 (GMT)
Received: from [9.61.176.130] (unknown [9.61.176.130])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 12:53:51 +0000 (GMT)
Message-ID: <d31e8a98-a87e-41dd-ba41-ba8ac45eadba@linux.ibm.com>
Date: Fri, 17 Jan 2025 07:53:51 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        jjherne@linux.ibm.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <20250114150540.64405f27.alex.williamson@redhat.com>
 <5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
 <20250116011746.20cf941c.pasic@linux.ibm.com>
 <89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
 <20250116203034.2ec75969.pasic@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250116203034.2ec75969.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Mv-27D7ogrQnPD9h-TJkgL3BVEVGoLZr
X-Proofpoint-GUID: Mv-27D7ogrQnPD9h-TJkgL3BVEVGoLZr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=846
 priorityscore=1501 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170100




On 1/16/25 2:30 PM, Halil Pasic wrote:
> On Thu, 16 Jan 2025 10:38:41 -0500
> Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> Alex, does the above answer your question on what guards against UAF (the
>>> short answer is: matrix_dev->mdevs_lock)?
>> I agree that the matrix_dev->mdevs_lock does prevent changes to
>> matrix_mdev->cfg_chg_trigger while it is being accessed by the
>> vfio_ap device driver. My confusion arises from my interpretation of
>> Alex's question; it seemed to me that he was talking its use outside
>> of the vfio_ap driver and how to guard against that.
> BTW the key for understanding how we are protected form something
> like userspace closing he eventfd is that eventfd_ctx_fdget()
> takes a reference to the internal eventfd context,  which makes
> sure userspace can not shoot us in the foot and the context
> remains to be safe to use until we have done our put. Generally
> userspace is responsible for not shooting itself in the foot,
> so how QEMU uses its end is mostly QEMUs problem in my understanding.

I started digging through that code to try to find the reference to the
eventfd and whether/how it is protected, but got lost in the
twists and turns. Thanks for the info.

>
> Regards,
> Halil


