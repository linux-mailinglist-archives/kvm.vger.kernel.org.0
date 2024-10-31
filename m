Return-Path: <kvm+bounces-30189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 517459B7D68
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D212B1F2208B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D6D1A38C4;
	Thu, 31 Oct 2024 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W+boXa2k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614D81A01C6;
	Thu, 31 Oct 2024 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386632; cv=none; b=GZt4PbneADZ6TwDGQ0n4Bku8cggsJVBK+IKz4YELmhqeHLk00OTvtI5vlb5LqvvDVxqoppvWxKFoyVnVTVKHEhc9gqaFS8xc754nYcb/zrTDl7tkYyHuRk58iwaM/5jQ96nGwJDqAeS4q/XD1XluqUcj9Xmf1O1PJa0yLMunKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386632; c=relaxed/simple;
	bh=1yQ5OPuuQi/uXkPJsoL1Q6gToqNfv0k7XkIu1spX//4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LA1slQWUNIaM32Wy42J1K5OsE9zUniAApdgsrPPKzIOsI5YA20GKuMvvAtZdgwBnk7jT8WeDAZzGqzEkZDpyNLq3cO5kbLPwhyLthoIm6FnVGhJHwtOyBfrBOHJlCThinMRfdjrydpErBePyCGLuhrmwTx0MvcBNg0uYm0vXIQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W+boXa2k; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V2jDmC000401;
	Thu, 31 Oct 2024 14:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LSh8xK
	5yqliL0HYBXZmT0bHiP4UGC1lgBePWTbzhDl0=; b=W+boXa2ks9A85zEPDlwg2T
	3k2d89L7aOopYe9WHjEgbhAFmx26IiEQfrYvRogMIkADaeH0oQdVSjJJorjspcf4
	EQDs69ej2EP9a0WKVgv6t80CKT3BsL+r54qbaPku0CGNFKiwZ0ZpT9ezP8slWFHu
	+BMzqo1/SSsNq0QVSMx3tlu3R5aGZC49/2/KZY2/VYIoAJHRjoMryqJNuxlqFUG3
	5KCALLkGcHBlzqzXlOyvoA+zuUOt9tRYOTyp4NxEkOTdA2U2vaa2etD/WHnIhG/W
	Bzpyqjkgt6k7hz/1/VO9FwlLacb/V0F5x+oSsxHzTweOKVmgRqGNyZ8GneaTpwRw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65rfu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:56:58 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49VEuvtw018322;
	Thu, 31 Oct 2024 14:56:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65rfu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:56:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VEG86S013670;
	Thu, 31 Oct 2024 14:56:57 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hbrn5a23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:56:57 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VEuuTj49545726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 14:56:56 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03C1058056;
	Thu, 31 Oct 2024 14:56:56 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DF0758052;
	Thu, 31 Oct 2024 14:56:54 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.67.19.177])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 31 Oct 2024 14:56:53 +0000 (GMT)
Message-ID: <7aa84534df1a6637bebd60e628500f6dbad47c05.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/7] Documentation: s390-diag.rst: make diag500 a
 generic KVM hypercall
From: Eric Farman <farman@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck
 <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Date: Thu, 31 Oct 2024 10:56:53 -0400
In-Reply-To: <20241025141453.1210600-2-david@redhat.com>
References: <20241025141453.1210600-1-david@redhat.com>
	 <20241025141453.1210600-2-david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1T_xI4u9IKJpgvf4LBInHV3e2-xkpAfW
X-Proofpoint-GUID: n_TgE2SuFctjzTmTDSTHmywe8zj19dOf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=634
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310110

On Fri, 2024-10-25 at 16:14 +0200, David Hildenbrand wrote:
> Let's make it a generic KVM hypercall, allowing other subfunctions to
> be more independent of virtio.
>=20
> While at it, document that unsupported/unimplemented subfunctions result
> in a SPECIFICATION exception.
>=20
> This is a preparation for documenting a new hypercall.

s/hypercall/subfunction/ ?

>=20
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/virt/kvm/s390/s390-diag.rst | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>

