Return-Path: <kvm+bounces-29286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0AAF9A68EE
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55B301F218C5
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD491F7082;
	Mon, 21 Oct 2024 12:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FllWIjqg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB591E7C18;
	Mon, 21 Oct 2024 12:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729514785; cv=none; b=mlRhnELxLjIPOyfvmpEopwr3UouTQIff3kpCvTFopXD1Exq+mHRu0XK1q1gA0usHVkU06BPuylS+rHuZqMOFMLmrdVHzBV7tjEzR6xQYz/a5l/Xlo1MxMMO0+nNFwMe+02JleiguMKBEA22Bs2JM39Cy7Pc9XMs+ZJaKE8pnzyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729514785; c=relaxed/simple;
	bh=pWofFWrN4meoxrlDgXFp+FDqGZwULUzvgV2VK4OrfvI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=s42qijc+ecmtS/A9rHO1f76Z/QbxayeMCc8Ze6TUf0wJitr1GuTv05tzJnLeUmhEmb0R5+4ZQOZ75kNhy2acAtKFouTveEiNO+qXbK4uIL7k2kHW8NPtz1Uc9pE9u1vjYLe2afQlrZLoVB9+7x94nZTTME69YdOLHyMMtkOinN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FllWIjqg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2KIwL030363;
	Mon, 21 Oct 2024 12:46:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=lR0jO/0xiV9IX40bSvxOvJgQf4enhl
	qTnliqRfVPuDQ=; b=FllWIjqgF7s33e3vF82ifvOX4m/HI/xa7RUFy9iUYyvQER
	bTwNkzmdSYyBB5Ju5Xp4lXOULnvRGV4b/LIkw7M//GFVSCGV7AcjOVTi9/HaVq6S
	qlYl1/ewPa1Pkk/WST5jGhCPE/ZrZLQ0LnTY+Z5yL95WWM+eCJr5zFhLCuxaasRv
	d7j6VoXY7zWM2v2IaQPSldfTXWFp5bASAh/fnek1pucpLvKDTdgUcpy3K6rfR062
	/nQS3flCd73yoM/g0rQsH0Lb82GcHBdKg1/Zj8v4tkYh0i9ggytzquEP5RtLwNSu
	m4IfdnInJwOor/hml/Q7lJVN+tzVL6nIMNXrbzZw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fsrtp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 12:46:12 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49LCkBt7028404;
	Mon, 21 Oct 2024 12:46:11 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fsrtp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 12:46:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49LBV0hn028864;
	Mon, 21 Oct 2024 12:46:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42cqfxefp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 12:46:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49LCk6Y853281068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 12:46:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8F0220043;
	Mon, 21 Oct 2024 12:46:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C10F120040;
	Mon, 21 Oct 2024 12:46:06 +0000 (GMT)
Received: from localhost (unknown [9.152.212.62])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Oct 2024 12:46:06 +0000 (GMT)
From: Alexander Egorenkov <egorenar@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: agordeev@linux.ibm.com, akpm@linux-foundation.org,
        borntraeger@linux.ibm.com, cohuck@redhat.com, corbet@lwn.net,
        eperezma@redhat.com, frankja@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, jasowang@redhat.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, mcasquer@redhat.com, mst@redhat.com,
        svens@linux.ibm.com, thuth@redhat.com, virtualization@lists.linux.dev,
        xuanzhuo@linux.alibaba.com, zaslonko@linux.ibm.com
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
In-Reply-To: <76f4ed45-5a40-4ac4-af24-a40effe7725c@redhat.com>
References: <87ed4g5fwk.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
 <76f4ed45-5a40-4ac4-af24-a40effe7725c@redhat.com>
Date: Mon, 21 Oct 2024 14:46:06 +0200
Message-ID: <87sespfwtt.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4UF9Fv-AK_XRBxOtezlAQD7YmT9k-wuq
X-Proofpoint-ORIG-GUID: gPbbIZU3umCCUjsbfFgI52rfW3pmqV0a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=690 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2410210090

Hi David,

David Hildenbrand <david@redhat.com> writes:

> Makes sense, so it boils down to either
>
> bool is_kdump_kernel(void)
> {
>           return oldmem_data.start;
> }
>
> Which means is_kdump_kernel() can be "false" even though /proc/vmcore is 
> available or
>
> bool is_kdump_kernel(void)
> {
>           return dump_available();
> }
>
> Which means is_kdump_kernel() can never be "false" if /proc/vmcore is 
> available. There is the chance of is_kdump_kernel() being "true" if 
> "elfcorehdr_alloc()" fails with -ENODEV.

Do you consider is_kdump_kernel() returning "true" in case of zfcpdump or
nvme/eckd+ldipl dump (also called NGDump) okay ? Because
dump_available() would return "true" in such cases too.
If yes then please explain why, i might have missed a previous
explanation from you.

I'm afraid everyone will make wrong assumptions while reading the name
of is_kdump_kernel() and assuming that it only applies to kdump or
kdump-alike dumps (like stand-alone kdump), and, therefore, introduce
bugs because the name of the function conveys the wrong idea to code
readers. I consider dump_available() as a superset of is_kdump_kernel()
and, therefore, to me they are not equivalent.

I have the feeling you consider is_kdump_kernel() equivalent to
"/proc/vmcore" being present and not really saying anything about
whether kdump is active ?

Regards
Alex

