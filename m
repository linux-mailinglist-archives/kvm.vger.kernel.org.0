Return-Path: <kvm+bounces-34827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC04A0643D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 572B118896D5
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474A0201026;
	Wed,  8 Jan 2025 18:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MHlJxmO/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE5615853B;
	Wed,  8 Jan 2025 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360498; cv=none; b=pzQarMeVKC4NivZoYJs/1lV5PL5M+0Pr2Eam4n9b5Vb7cl9N8SG0ogXtcu+Jk03kl+BcJzO+67tVqA4O8bhCTu4OhRRYVgtWafS3ij8M0WvOwC+wh6Q7F67c0shsBnoIRDH6tekpoWTuLta7z7ZTTfPfsBn94T1NKDUoyNj0Ie0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360498; c=relaxed/simple;
	bh=j+ztVDrhcjGb3Iwq6kcC1Bao+mzRSURbi1fiHkFG54c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftZu+zInkd7Ag28ukarxNZ2/UXVsreYc5EHnjLtTm+1Z9wRaUnZY5KOpUuMUa//7orxECrkLusgJWt9gJ3ksMdav3jLSVX1+ASg5wi1x5MIVxUA5yG9PQMSEIvFPKn3wY8GANM9862vkqhPbHSeb7BohX82aH3kpUQAX38H/VZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MHlJxmO/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508E6qht001197;
	Wed, 8 Jan 2025 18:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kR5aJI
	SqarhpAbqLVoEBu63M39K0V0j2eLP4X9Jisms=; b=MHlJxmO/+T90YFLW6eUrO5
	zqBUs/y4FgwRdsjwpwt4xn8DYL6qyMDD9B8AzNznYEZQhur/IeOSvC/VMPUNZhdp
	vTFUZPEx847fwp0cQn3vGqbGgfw0lFoIEhse92ac84RC5xYhevZ+bM6DgDzg5F4X
	xexF3aY8Q0NlV8Ydxa//fP4o07RmJ38fnCZgVp0I+JmrshT5GguLaSgyG6dWkXaw
	Zs4lSeKiQjIEG45GxDI+lguf9o9uGRjZWkkQ8pYPvgcxI7qgwWVzXevATHFRyuSc
	odCt+XT09Vn2Mq3bf+4ONwgVj1UO8q4oU6EuEjOL+0F6LXqqy0Z73Os8DiWol8xg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441tu5h4gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:21:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508GHaLG003630;
	Wed, 8 Jan 2025 18:21:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yfat9amh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:21:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508ILRmf35979668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:21:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD46B20043;
	Wed,  8 Jan 2025 18:21:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B53820040;
	Wed,  8 Jan 2025 18:21:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:21:27 +0000 (GMT)
Date: Wed, 8 Jan 2025 19:21:17 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        "Matthew Wilcox (Oracle)"
 <willy@infradead.org>
Subject: Re: [PATCH v1 0/4] KVM: s390: vsie: vsie page handling fixes +
 rework
Message-ID: <20250108192117.51a2d2cb@p-imbrenda>
In-Reply-To: <20250107154344.1003072-1-david@redhat.com>
References: <20250107154344.1003072-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qebmI22e_lbCs6QB3HgM9s1cLBzTsZh0
X-Proofpoint-ORIG-GUID: qebmI22e_lbCs6QB3HgM9s1cLBzTsZh0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=729 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080148

On Tue,  7 Jan 2025 16:43:40 +0100
David Hildenbrand <david@redhat.com> wrote:

> We want to get rid of page->index, so let's make vsie code stop using it
> for the vsie page.
> 
> While at it, also remove the usage of page refcount, so we can stop messing
> with "struct page" completely.
> 
> ... of course, looking at this code after quite some years, I found some
> corner cases that should be fixed.
> 
> Briefly sanity tested with kvm-unit-tests running inside a KVM VM, and
> nothing blew up.

I like this! (aside from a very tiny nit in patch 4)

if a v2 is not needed, I'll put the split line in patch 4 back together
myself when picking, no need to send a v2 just for that.

whole series:
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> 
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> David Hildenbrand (4):
>   KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
>   KVM: s390: vsie: stop using page->index
>   KVM: s390: vsie: stop messing with page refcount
>   KVM: s390: vsie: stop using "struct page" for vsie page
> 
>  arch/s390/include/asm/kvm_host.h |   4 +-
>  arch/s390/kvm/vsie.c             | 104 ++++++++++++++++++++-----------
>  2 files changed, 69 insertions(+), 39 deletions(-)
> 
> 
> base-commit: fbfd64d25c7af3b8695201ebc85efe90be28c5a3


