Return-Path: <kvm+bounces-46838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6236BABA19E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E49E2165A5D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679CE2701A7;
	Fri, 16 May 2025 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sPO0BWrS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A020D50C;
	Fri, 16 May 2025 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415296; cv=none; b=ovagO1sw4lsHM3aLmN9AmXthyPnckY2U2+8xmut5UMO7iSL6WeTB2hjIiTWm00HEQcPp2LsWtXxuKq94+u4m+NULNhpSwFnL8CWwGJsRiDhi8da3NzThRGP0Ln6RBXKeYpjVpqJKz4o+QF0Bjq2m6EB//T0wTGIk1cK0QtDo3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415296; c=relaxed/simple;
	bh=D4nh/p3rGy8bs/0DL+q9ngAuVpsmPitUfEbzGeaXiSk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAlyo544Y9lwq9SVkgC96ekVgn1gU4of2QinVTsXzTJuFHW/++PzbPKb+4xhqNbWS6KxaAARpFBulVQf4BQcY/zbvg4Pi68w5FRDgF7FyEo4WCy/3ibwvJuQIwUYTmnPLLXdBQDKJYN3iO7w0VmtBHK/glMUdWrvkbWe0HQMylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sPO0BWrS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54GGeScU024369;
	Fri, 16 May 2025 17:08:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=l9XaRt
	t7nqTQopEcJ6psPRLnUWut+d/TtKq81TymnfM=; b=sPO0BWrSkY7Vlbv4ZLrqdw
	HmBl9M+mfcmxwy1NKC+fPUE/hosEomsXDOhHQztnPW1wisvOCfulpMPqrp4wVxd0
	pFJCCGwVpcGPitc8NdrSzjk0w3nqf8x8gKcdbNp/+U9pZELq4seT0+mJrqqds9kT
	rncygBj+DJvIsK8BGbJcK42DTd0vIkKYooUt5NXYKJDk28tbFViWrL8EEDs5TDbN
	sTRXy9S47axe75SfqfHQ/XYtUlYy6at/joNYz8R1q77O9yKWqPPV3T/pR6TiEwSi
	JeXkiPZzkKw4kjkMLa6bO4pexF3EUyVL/4xrRHSdy98bCfKBel/b3CEsXDZny70g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46nyytk4kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 17:08:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54GEOitU019443;
	Fri, 16 May 2025 17:08:02 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfs0mhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 17:08:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54GH7wah23134642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 17:07:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32C16200CF;
	Fri, 16 May 2025 17:07:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5642200CB;
	Fri, 16 May 2025 17:07:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 May 2025 17:07:57 +0000 (GMT)
Date: Fri, 16 May 2025 19:07:55 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Zi
 Yan <ziy@nvidia.com>,
        Sebastian Mitterle <smitterl@redhat.com>
Subject: Re: [PATCH v1 0/3] s390/uv: handle folios that cannot be split
 while dirty
Message-ID: <20250516190755.32917d48@p-imbrenda>
In-Reply-To: <20250516123946.1648026-1-david@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cbLRk8KAcORrniPp6oJAntkKow6roWiN
X-Proofpoint-ORIG-GUID: cbLRk8KAcORrniPp6oJAntkKow6roWiN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE2NyBTYWx0ZWRfX3xqHC4oBj9bo YZYdBu/Paw1MLiE/054CZBnb7aVupy8kUOokX55rXkThUKc6DqCIX4/qSbwmU0L3SIyOoqTROnQ mxKIoQA42qkEUh6VM8NAnLYSdSXq53cu7rjBRViArtPm63dcfWsZc8Tx3XthPQg4p2VD9E6LZ4j
 dhu/E8LF/TcOZRTlyhaRxAIDlhXnW50twx5/aDlB4oQIC5RZFA+3PUnZJHSgX02kb99IkQGwD/m 9prYMk4clzlIeJ4VAiWqRi9QcakrSqkBjC7eFIkIiTN9PvF66CcjyZEB0rEjAiHMR+MGrrqrBeM +amziRU8KT96wLkfFI1jGVw6w3URX5ag005MocrhZ1y79Hzov3qd7XFHwxqYs3td0W4IFlChVRY
 T/TR90EACXZGgdZ0HKeEUdSI1zYOzNZKlSFysdn2xTm7/GAOR1qFDHdYv/hkrFASGuCPAegZ
X-Authority-Analysis: v=2.4 cv=ZcMdNtVA c=1 sm=1 tr=0 ts=682770f3 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=Ikd4Dj_1AAAA:8
 a=bI5ggvasLi50PZegio4A:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 clxscore=1011 bulkscore=0 priorityscore=1501 mlxlogscore=744
 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505160167

On Fri, 16 May 2025 14:39:43 +0200
David Hildenbrand <david@redhat.com> wrote:

> From patch #3:
> 
> "
> Currently, starting a PV VM on an iomap-based filesystem with large
> folio support, such as XFS, will not work. We'll be stuck in
> unpack_one()->gmap_make_secure(), because we can't seem to make progress
> splitting the large folio.
> 
> The problem is that we require a writable PTE but a writable PTE under such
> filesystems will imply a dirty folio.
> 
> So whenever we have a writable PTE, we'll have a dirty folio, and dirty
> iomap folios cannot currently get split, because
> split_folio()->split_huge_page_to_list_to_order()->filemap_release_folio()
> will fail in iomap_release_folio().
> 
> So we will not make any progress splitting such large folios.
> "
> 
> Let's fix one related problem during unpack first, to then handle such
> folios by triggering writeback before immediately trying to split them
> again.
> 
> This makes it work on XFS with large folios again.
> 
> Long-term, we should cleanly supporting splitting such folios even
> without writeback, but that's a bit harder to implement and not a quick
> fix.

yet another layer of duck tape

I really dislike the current interaction between secure execution and
I/O, I hope I can get a cleaner solution as soon as possible


meanwhile, let's keep the boat afloat; whole series:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


David: thanks for fixing this mess!

> 
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Sebastian Mitterle <smitterl@redhat.com>
> 
> David Hildenbrand (3):
>   s390/uv: don't return 0 from make_hva_secure() if the operation was
>     not successful
>   s390/uv: always return 0 from s390_wiggle_split_folio() if successful
>   s390/uv: improve splitting of large folios that cannot be split while
>     dirty
> 
>  arch/s390/kernel/uv.c | 85 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 72 insertions(+), 13 deletions(-)
> 
> 
> base-commit: 088d13246a4672bc03aec664675138e3f5bff68c


