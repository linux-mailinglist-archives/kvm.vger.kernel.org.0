Return-Path: <kvm+bounces-35774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3D5A14FAC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B044188AFB5
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 12:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C2F1FF1BB;
	Fri, 17 Jan 2025 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n0oC/Sb7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB3A1F7917;
	Fri, 17 Jan 2025 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737118219; cv=none; b=PYfa6D1uq2X1YkRzl0zEYmwV9WKghaYCs8NefiG55prDSYWzv9hYwA/gMKSG/7FOLaNlfQUzW9tpePcvZnSE2iP6EhJVSx6TwIOd6attkVbAF6/M0XH+FYDj7n6HIwSsDFnJd6L4jjLLk6cPzvcTK5zYo+v80Fh8iDrvKhuv+6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737118219; c=relaxed/simple;
	bh=sSmZcI8irpdAfP2XVGXWPQKzns4X5jw73D3mVkhKvfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GI5mHs12Myv7SmhPcYuuhrVS+9A7Sl5qAgl5oMXO57zbQClkJL7wg1C56PuiCum3iBUWVXa/H1qk0wGW1PWmsjZ+6tsTU6dMGxXhtUKHpn96LYcr2tAQ094wfoP/JnMjPu60GX7uJrRttfb8EMFOrxiOYA1T4s0EpLAbnTMHt3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n0oC/Sb7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HBUmvE008889;
	Fri, 17 Jan 2025 12:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LMgPRu
	hg0m25Pz8CkMDYBXjlRqfGVoa56c+IZoy+Gq8=; b=n0oC/Sb7e27j6Lk8q0rh6H
	M2xfN/KOnq8ntDO9CZSYoBWpeDj8ESU47ZYLIi7OUo+ufF12/7geslf52fhk8Ksh
	x4h5K9QLo3n63Z7rVLOBVGCaod/L7GH+F1AgxLfikgbWLi9tATAJrZB3ZN3q24TZ
	SX9Rzh4RjutOMgRXEVB/rzS4cbHr4XAR/xrj6XMM+pvOmFPWhvcRsPSECYj0DPoU
	MjrhbfvfOuRCwwvgwZDJgUDjN35Pbo1bYfIneeRtRkObv1RqJP1TbcdcumQZZi3l
	6AcpMb1BUek83T8PvCpOpblwJraHdLnowpJla5pi5UXLqlppR/zgo/nyEPz9iGeg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jax8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:50:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HA5Uor017366;
	Fri, 17 Jan 2025 12:50:13 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkjv86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 12:50:13 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HCoCtr32506408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 12:50:12 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A4BB5805F;
	Fri, 17 Jan 2025 12:50:12 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F8CC5805C;
	Fri, 17 Jan 2025 12:50:11 +0000 (GMT)
Received: from [9.61.176.130] (unknown [9.61.176.130])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 12:50:11 +0000 (GMT)
Message-ID: <4860bb2d-30ec-4fad-a2b2-752c3412771e@linux.ibm.com>
Date: Fri, 17 Jan 2025 07:50:10 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
To: Halil Pasic <pasic@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        jjherne@linux.ibm.com
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
 <20250114150540.64405f27.alex.williamson@redhat.com>
 <5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
 <20250116011746.20cf941c.pasic@linux.ibm.com>
 <89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
 <20250116115228.10eeb510.alex.williamson@redhat.com>
 <20250116201858.1a5f7e7f.pasic@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20250116201858.1a5f7e7f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Zz9fdY-5_yA__lq-k8ZLu--Wu_P7KAl
X-Proofpoint-ORIG-GUID: 5Zz9fdY-5_yA__lq-k8ZLu--Wu_P7KAl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170100




On 1/16/25 2:18 PM, Halil Pasic wrote:
> On Thu, 16 Jan 2025 11:52:28 -0500
> Alex Williamson <alex.williamson@redhat.com> wrote:
>
>>>> Alex, does the above answer your question on what guards against UAF (the
>>>> short answer is: matrix_dev->mdevs_lock)?
>> Yes, that answers my question, thanks for untangling it.  We might
>> consider a lockdep_assert_held() in the new
>> signal_guest_ap_cfg_changed() since it does get called from a variety
>> of paths and we need that lock to prevent the UAF.
> Yes I second that! I was thinking about it myself yesterday. And there
> are also a couple of other functions that expect to be called with
> certain locks held. I would love to see lockdep_assert_held() there
> as well.
>
> Since I went through that code last night I could spin a patch that
> catches some of these at least. But if I don't within two weeks, I
> won't be grumpy if somebody else picks that up.

Sure, sounds like a good idea. Don't worry about it, I can take care of 
it. Thanks.

>
> Regards,
> Halil


