Return-Path: <kvm+bounces-35677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9161FA13FCB
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 17:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDD5C7A1533
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDEF22CBC1;
	Thu, 16 Jan 2025 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Osu5ErKM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFD117C8B;
	Thu, 16 Jan 2025 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737045972; cv=none; b=cHz9pUnCwlp++HpXvgTP5KaOnKSz1zimxWl5LEXk8yPfpo5+2TdgGnqDHSmc2hrVfoFpw+M6Uur8ZimZGXsapVg9a0nDLWgSycL+zr80sNfAw/7EJ+iBQQqHzi+fpFrksNggd7J+2D4/5EFm/JEDxoRtiyBUNUX26fA6sEiRT9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737045972; c=relaxed/simple;
	bh=zIERFy2eV2i6sZJ8wMr6BvL0kfZviyc3iYzcFNxjSKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gS7jr5IJy6qf79yqo4XvIIC3F6Y1gG7TYo7yxXy9yKAk1qCYHF3X+HUZG/5qboT3Dn0si7mZ0GIvcs0rTKskyeX+Df2aTv/+jQ6okNoBC01lUBGsK8zsz4SkKBDsA971/JkcdjJ5a6fuTCSibqycGFlC02csWWkdBnygLXbCA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Osu5ErKM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G85liL020691;
	Thu, 16 Jan 2025 16:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HTU4Lp
	6uv1FEpAg4rBXEaW9xaFip+Au1NzDWhjLvDpc=; b=Osu5ErKMQmP2f2uOE7uuEl
	9Z7wr0RcdPxCfd1PFAv/10OcNsil6/K7yS2sHkdVWXnKn/P/9pIfbN5ZtBWvLPS0
	drkliEC6Hjf6WzWudclJ3di5i/vPsKdV6KdUPBJ9HUJwpd2zYp4wFoU45gsL9jf+
	ShUuoiBb98hEb88OQcSIiGMuDE3wEmR9v7R90b8H+LP/JWksURi4z09rIW3eIxAh
	DL035+JTxHrTSW41OGKkqHDfhivSnGFaV19ljhnEAqdMXxGx5OwSYy6XL1Vln9TN
	CVl1/m25Ji/xo/4Px/on90jUBKRxVzPiOpYRvgwGD5m0kTD/vNYqtvNDnaG3cxdg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446xa3agg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 16:46:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GF0Wkr016490;
	Thu, 16 Jan 2025 16:46:05 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1xbw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 16:46:05 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GGk4UB31588940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 16:46:04 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B5F75805D;
	Thu, 16 Jan 2025 16:46:04 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7FCD5805B;
	Thu, 16 Jan 2025 16:46:02 +0000 (GMT)
Received: from [9.61.176.130] (unknown [9.61.176.130])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 16:46:02 +0000 (GMT)
Message-ID: <d1b36877-14ea-4110-84c1-941defc8d3a2@linux.ibm.com>
Date: Thu, 16 Jan 2025 11:46:02 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: freude@linux.ibm.com, Rorie Reyes <rreyes@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <45d553cd050334029a6d768dc6639433@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <45d553cd050334029a6d768dc6639433@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ok5TMgexn1KyPpBewFrZ9VpDM0f2ijAq
X-Proofpoint-ORIG-GUID: Ok5TMgexn1KyPpBewFrZ9VpDM0f2ijAq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501160124

>
> Rorie, this is to inform listeners on the host of the guest.
> The guest itself already sees this "inside" with uevents triggered
> by the AP bus code.
>
> Do you have a consumer for these events?

There is a series of QEMU patches that register a notification handler 
for this
event. When that handler gets called, it generates and queues a CRW to 
the guest
indicating there is event information pending which will cause the AP 
bus driver
to get notified of the AP configuration change via its ap_bus_cfg_chg 
notifier call.

The QEMU series can be seen at:
https://lore.kernel.org/qemu-devel/7171c479-5cb4-4748-ba37-da4cf2fac35b@linux.ibm.com/T/ 


Kind regards,
A Krowiak



