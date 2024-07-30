Return-Path: <kvm+bounces-22660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1C8940FCE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27C8A1C22AF1
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7211A0AFE;
	Tue, 30 Jul 2024 10:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lv6jdWRV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3411719FA86;
	Tue, 30 Jul 2024 10:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722336013; cv=none; b=LD6FZTXoluaGseu9iMVcDA1GbZzpINrWonOlUu9QDpfV5Uzh5WHmaA9wPM+UON9RxpSDEI1qgQKL51nw9uWopafBlelOIFJJLD82tvrib3j3B8VdXk5pRa0oAGeLQtJY8DAlpVnMJHGryhKOW2WbbCohCFTA56iN6H3NQbMtwPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722336013; c=relaxed/simple;
	bh=l4VpL9x+WgkqxnYD2dAEQ8MULWjm5ogOKxxCT/nRsKE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fCWGh/YjwPCJlJAeoi58rTjSc1rpOk99s3eYssG2CuuXbZm61eO73u+SbfLnbQx0Y6HlgJami7I9Iku9U9XSFuIqqu9BD3nbQpRof3mjwzGNvIGGXn425o+1xL2Zb3+E5FKuaMgU9UQcPwfdimb94DlmU/ZUqmjx7zqlIkdrrXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lv6jdWRV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46U9tKjU012030;
	Tue, 30 Jul 2024 10:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	DkGdvAdKyg11kiXdiASBE8PWg35HTN6fIm33pARXv0M=; b=lv6jdWRVC7uz0NIW
	l1NelhuPv8RIbUQotpKu8x6enuyXNRDQO+gIebwvS0VYFVDmi4K7pP2t6FHP4qgH
	LpSCyYXgBMnj8pUokGna9wxetuUKq27HgJhi35ppf+zmp77VY55N3yW+KTm6xXho
	d62+eQvjRXutiNE1lnGx3wpSxQ3jUuyL+k2EZoty07wJtX/bbqDLqANrCTJsymn7
	d+cqPk9qiz5Cli/YgrKec5Hlr3ZYadyi6SV2/staT720h+lxAAi6T5UxcBKksgdr
	IKN9Rgu3Q6o8/k8UE+AWVlzyhrlli28J9UQB0SBHEWGjRTdv6wyaP71b1IEVErvL
	T3nrcw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40pra21bqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 10:39:57 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46UAdund021238;
	Tue, 30 Jul 2024 10:39:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40pra21bqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 10:39:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46U85H98011151;
	Tue, 30 Jul 2024 10:39:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40ncqmm4kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 10:39:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46UAdoZB50921962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jul 2024 10:39:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C19820043;
	Tue, 30 Jul 2024 10:39:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1A5820040;
	Tue, 30 Jul 2024 10:39:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jul 2024 10:39:49 +0000 (GMT)
Date: Tue, 30 Jul 2024 12:39:48 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch
 Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1 0/3] mm: remove arch_make_page_accessible()
Message-ID: <20240730123948.6833576c@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240729183844.388481-1-david@redhat.com>
References: <20240729183844.388481-1-david@redhat.com>
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
X-Proofpoint-GUID: -D3mUbFgCBPLb-63vf3XcLrcobweWmky
X-Proofpoint-ORIG-GUID: JCR5ort0nw7-4C2vezlqKFBQVfD1e3XV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_11,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=654
 lowpriorityscore=0 clxscore=1011 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407300074

Thank you for taking care of this!


Whole series:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


On Mon, 29 Jul 2024 20:38:41 +0200
David Hildenbrand <david@redhat.com> wrote:

> Now that s390x implements arch_make_folio_accessible(), let's convert
> remaining users to use arch_make_folio_accessible() instead so we can
> remove arch_make_page_accessible().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> David Hildenbrand (3):
>   mm: simplify arch_make_folio_accessible()
>   mm/gup: convert to arch_make_folio_accessible()
>   s390/uv: drop arch_make_page_accessible()
> 
>  arch/s390/include/asm/page.h |  2 --
>  arch/s390/kernel/uv.c        |  5 -----
>  include/linux/mm.h           | 18 +-----------------
>  mm/gup.c                     |  8 +++++---
>  4 files changed, 6 insertions(+), 27 deletions(-)
> 
> 
> base-commit: 3bb434b9ff9bfeacf7f4aef6ae036146ae3c40cc


