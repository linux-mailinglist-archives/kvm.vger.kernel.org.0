Return-Path: <kvm+bounces-35968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AD2A16ABE
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76532166308
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE501B87D7;
	Mon, 20 Jan 2025 10:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GCl1y35Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889151B414F;
	Mon, 20 Jan 2025 10:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737368962; cv=none; b=eR9NCTQmW/2wnxAfqzGhB0Jq+oJViTYhRwaq0lyIr0OM/2kAloEcI9VXrZpYkhMq9fG/xa2nCuauwOE8wA69pD+3ujJKjkWHn7WyVXV8AgpTPBthBYVr5ncoyz/R4Lzi8nMe4Nav2egSqG+3xFZKzDTl0N4hoe90iJpTlvWAgnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737368962; c=relaxed/simple;
	bh=EZyi+DifkMh9z7Pg3fXcrAESt38J4MudsVcp8wSDpPU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVYLv/7YZtF3e9gNyvFbBhnvjJaX7dRWYnYzGyorsisGkLVQGF0pYP+kMBVSxWLhlhnoGQwt91nz/NVaCkYbP2TVpPt0hrCYdEZye2kGy6SzveOi7G/TSGYzKcDFVQxG6hQTDmvyXp9Y/46PxoCZYtfT6sbBQEzxjFngXQ9KXRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GCl1y35Z; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K8Hs8x014957;
	Mon, 20 Jan 2025 10:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Geo8iO
	Gle5q31YH/VRjqk8ikIxhtahO/knYFt3KRSDI=; b=GCl1y35ZrVPaplHSGUozQk
	QI2sW1TKI1qwLht8yWZrZTWuArlYf924B5+JY2F8EEMPrIivyI9boIRHcUra2uRE
	MZ2S1ep8qc1Cr6eAxF9H01FqEQrswvdZXEFgia6RWxx54n5dFem54rhH4ITg8J9t
	orBTQ89S7J4f9dO+FqMZaFiDa2P9zXThclc7WZNFDyVgfAtcpLjzZvtP5BoADlnL
	Ss+25Ihy99f/K8DFcTuDFAvqxEc67A9t4uljt+tseb7+rZmrKAxrlAVLLLu/kXcB
	/2Z6Au99RbHUiCibg4tSLTaiS58u0LZvtwldayyQrg6wlP1rSa57VEBYNHHXeQXw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4493ny3mh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 10:29:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50K90UUv020986;
	Mon, 20 Jan 2025 10:28:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb15ht0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 10:28:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KASoLo34013572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 10:28:50 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F86D2004B;
	Mon, 20 Jan 2025 10:28:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CEED20043;
	Mon, 20 Jan 2025 10:28:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 10:28:50 +0000 (GMT)
Date: Mon, 20 Jan 2025 11:28:48 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, willy@infradead.org, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 13/13] KVM: s390: remove the last user of page->index
Message-ID: <20250120112848.1547a439@p-imbrenda>
In-Reply-To: <e548aa1e-d954-4fab-8b74-302c140c04f7@redhat.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-14-imbrenda@linux.ibm.com>
	<4175795f-9323-4a2c-acef-d387c104f8b3@linux.ibm.com>
	<e548aa1e-d954-4fab-8b74-302c140c04f7@redhat.com>
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
X-Proofpoint-ORIG-GUID: Z_52PMInAeRVQqyNwLHlx3Crh9sgqSS5
X-Proofpoint-GUID: Z_52PMInAeRVQqyNwLHlx3Crh9sgqSS5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_02,2025-01-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200087

On Mon, 20 Jan 2025 10:43:15 +0100
David Hildenbrand <david@redhat.com> wrote:

> >> +static inline unsigned long gmap_pgste_get_index(unsigned long *pgt)
> >> +{
> >> +	unsigned long *pgstes, res;
> >> +
> >> +	pgstes = pgt + _PAGE_ENTRIES;
> >> +
> >> +	res = (pgstes[0] & PGSTE_ST2_MASK) << 16;
> >> +	res |= pgstes[1] & PGSTE_ST2_MASK;
> >> +	res |= (pgstes[2] & PGSTE_ST2_MASK) >> 16;
> >> +	res |= (pgstes[3] & PGSTE_ST2_MASK) >> 32;
> >> +
> >> +	return res;
> >> +}  
> > 
> > I have to think about that change for a bit before I post an opinion.  
> 
> I'm wondering if we should just do what Willy suggested and use ptdesc 
> -> pt_index instead?  

we will need to store more stuff in the future; putting things in the
PGSTEs gives us 512 bytes per table (although I admit it looks... weird)

> 
> It's not like we must "force" this removal here. If we'll simply 
> allocate a ptdesc memdesc in the future for these page tables (just like 
> for any other page table), we have that extra space easily available.
> 
> The important part is getting rid of page->index now, but not 
> necessarily ptdesc->pt_index.
> 


