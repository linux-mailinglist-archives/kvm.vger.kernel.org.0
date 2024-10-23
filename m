Return-Path: <kvm+bounces-29478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC749AC8B7
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DB132839B3
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3F61AA7BA;
	Wed, 23 Oct 2024 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KIYk3zFK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893831A0B1A;
	Wed, 23 Oct 2024 11:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729682263; cv=none; b=UWIBbn3+4K4p0qz4V78kM5OR6l185eFIUyrt9qJj8PBk5wt6nHrX3GrqB8eOCqZrRInH51SXFI4dRKKPhu2TQcCiaLynw1OaENCmqGyNkX3YlrrNZw96BvtwCAQDKRWKKVvf4DHb6t/q72Ufz7baltfrnZRJcdsYjY4gFzXwPkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729682263; c=relaxed/simple;
	bh=eCBwA2uVeaP+2Ms9EufdOjG1uAd6/PDeJZo0k69Rz0I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oysC20SoybLI5bIObfwjuwtcn7+HO49ggZqZ+Ft7tmQ19b/okfEOiG/IjQkrt7lQtjtjVGL4Papq0b5OguGMKZUOSzuqqJ+simBqQwu2Sg2gd9TnNCOeVWgfjOhbUCJEhGmM+iE8BYwts+c0jRR7r1nkr1BjN/jyyYgXEW3iMvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KIYk3zFK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49N0N2WV027060;
	Wed, 23 Oct 2024 11:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZE6D+HYETUE/ynzDtMdhfiXsH2K1dY
	hl0JDp52VsIME=; b=KIYk3zFKjt5NfqmqLpfkxYcX8Bh7E5ZOBX6MngDiUHPE7i
	za35AfTYZSqkN3qn84cGmanG6XJibAGMbIuZeE/0leRww3WfTrn9uja63UVmQyvD
	Dt3CgfWVW/IGXx4PzjP2G32bTqT68OB2pAvEJ3HubS7qc+d0yJmNEQYa/MB7WBfJ
	0OMsqSw9z6ZHAtCf8qUQhMdxawGtGtIL8edswVaZJYZN32wTfJOeT0YS694mWCkP
	QmMwUvvHS9V6eE5MPzUVbxG5due9OOfbRZ9SE4N1MHXPSXmSmlt5GkG79410yxEn
	1N9eXrQLZ6QyzC5Y5EFuO4LnUY48ytK/9LzZyYgw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emafjq2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 11:17:31 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49NBF8co023247;
	Wed, 23 Oct 2024 11:17:30 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emafjq2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 11:17:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49N7XXlk014287;
	Wed, 23 Oct 2024 11:17:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42emhfjjfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 11:17:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49NBHPJO41615756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 11:17:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74C2D2004B;
	Wed, 23 Oct 2024 11:17:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A65520049;
	Wed, 23 Oct 2024 11:17:25 +0000 (GMT)
Received: from localhost (unknown [9.155.200.179])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 23 Oct 2024 11:17:25 +0000 (GMT)
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
In-Reply-To: <64db4a88-4f2d-4d1d-8f7c-37c797d15529@redhat.com>
References: <87ed4g5fwk.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
 <76f4ed45-5a40-4ac4-af24-a40effe7725c@redhat.com>
 <87sespfwtt.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
 <64db4a88-4f2d-4d1d-8f7c-37c797d15529@redhat.com>
Date: Wed, 23 Oct 2024 13:17:25 +0200
Message-ID: <87wmhzt6ey.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CKYpV1nV98NDEQcpmjz79r4Re2RRu4UK
X-Proofpoint-GUID: nlELFtrFhiav0kiOq_i2qsR30bXf8Zr-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=804 adultscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410230065

Hi David,

David Hildenbrand <david@redhat.com> writes:


> Staring at the powerpc implementation:
>
> /*
>   * Return true only when kexec based kernel dump capturing method is used.
>   * This ensures all restritions applied for kdump case are not automatically
>   * applied for fadump case.
>   */
> bool is_kdump_kernel(void)
> {
> 	return !is_fadump_active() && elfcorehdr_addr != ELFCORE_ADDR_MAX;
> }
> EXPORT_SYMBOL_GPL(is_kdump_kernel);

Thanks for the pointer.

I would say power's version is semantically equivalent to what i have in
mind for s390 :) If a dump kernel is running, but not a stand-alone
one (apart from sa kdump), then it's a kdump kernel. 

Regards
Alex

