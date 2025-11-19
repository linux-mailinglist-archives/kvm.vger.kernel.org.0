Return-Path: <kvm+bounces-63702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF21C6E323
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 12:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 43F034F41D0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5369C34D4CA;
	Wed, 19 Nov 2025 11:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fhR0D4Uj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DBB1A9F82;
	Wed, 19 Nov 2025 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763550876; cv=none; b=ImANa2eE+r+fzb7ZQOlVt3zU+fx0w+IipTYQTFW674bWPjpREcAFjHic09DAOYpSKguNUt81+4CbV0Kko+yiZ/JeOfErZQQz22eQcjPh0k+LqnRf8M7I7bEJ36dtKH0EYaum1186InlX8VSCDtThyXVJ5koT1/I1YdLBXgjtbt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763550876; c=relaxed/simple;
	bh=jsmtQLV4JXs+M6rPTREEq0FvF1v2IjEOj95XqAe7yYo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOrWmEaSSWrqi55X1q/W3TNFuYrUuIKPXeXNH6jubsgD1ngexb4cNEIi9+fKopBIjRW/ddoITQY+8ULMF/RhQzk6znSnDsEG+2FMZAl31HunIHicd/Ck2wzb1BViCVObs5zcQ33OxTZZmUdkYcED8dbmI9gcJ1ocRhUIC9IkjQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fhR0D4Uj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7sKj6006274;
	Wed, 19 Nov 2025 11:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8SX7rP
	iVJJj4dFuCyE8l1m5+dIclAfUIEWtSADA8J+0=; b=fhR0D4UjG0zC2GdYtANtcw
	bRDrnNamuNHCcp+/kq+njoQQRBQsJR+1oF48JWTZ+XRugBAFxRQBnqvBg/o8lJen
	okOiWHzv4D4/jvZCeXgfHS3xkcobUoouzRkBYdDYtPvjz+qmOq1epqX1NdJxtMOB
	6HWUR/p5tMmVxGn1fWcmM8CoyUEv1zhEvGcB8u2/r9r0dADjCFcVr5Q3D0zb+LZf
	HB+qQGZvsMof1TiaBZfOOj+jW/5vt+pyg5XmICmlH3U+fPhZJauX1HDWJcjrOdec
	oJATXF6UstuO1NPpk/4LUafSf7k7V1oo/rbZuNGvOTFhVGRLp4jHGI7RTX5yAPNw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjty8dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:14:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJB9Ija030813;
	Wed, 19 Nov 2025 11:14:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af47y0bk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:14:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJBERLY25100746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 11:14:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A230E20043;
	Wed, 19 Nov 2025 11:14:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4998B20040;
	Wed, 19 Nov 2025 11:14:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.156.96])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 19 Nov 2025 11:14:26 +0000 (GMT)
Date: Wed, 19 Nov 2025 12:14:23 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 00/23] KVM: s390: gmap rewrite, the real deal
Message-ID: <20251119121423.4e7bd49c@p-imbrenda>
In-Reply-To: <20251118152815.9674D33-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
	<20251118152815.9674D33-hca@linux.ibm.com>
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
X-Proofpoint-GUID: F03S8SmhuyAIPi8XuehajxHmauHxgDf5
X-Proofpoint-ORIG-GUID: F03S8SmhuyAIPi8XuehajxHmauHxgDf5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX4+20ZwEizHcA
 yPjizWTstXMtpheovWE/i8sTjH3cMNFcSgmJ4CDD5zYsU6XE9gbgmenjg8Ugf3KeUj6GZ72A/uv
 xF6p9YLG0xe74Sbc2MdkBxRToeiqxTm5Vbw7GHtdTQUpbGizjEHDQt57ZUEBNT/4TvwuonAAgRH
 m9GIFwfP/+2NspXNF68pJ+Hp8tsXViCnXiw1MBQdgDAEP784j5NJ+0w9XSS/ahdoJS3eIIUaP3L
 L33FZGwtdjVECpuWEJa++5+YJfqjD4YJ+IysRx8UeDLRfy86Y0WSCfgSb0oF3wYyk8jx6WnHRSc
 7MB+FwnDBwyL2JuOOVeI5tlIkZiR/Mc8yma1mvRJgmSrRrMxlKu/82Zx/EEN7ueM0NpSqyXApRe
 wAhqK9oBOZZosrc0yJw2xyJ7Auhzbg==
X-Authority-Analysis: v=2.4 cv=SvOdKfO0 c=1 sm=1 tr=0 ts=691da698 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=pOQq90W_ryS87XKuLhcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

On Tue, 18 Nov 2025 16:28:15 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Thu, Nov 06, 2025 at 05:10:54PM +0100, Claudio Imbrenda wrote:
> > This series is the last big series of the gmap rewrite. It introduces
> > the new code and actually uses it. The old code is then removed.
> > 
> > The insertions/deletions balance is negative both for this series, and
> > for the whole rewrite, also considering all the preparatory patches.
> > 
> > KVM on s390 will now use the mmu_notifier, like most other
> > architectures. The gmap address space is now completely separate from
> > userspace; no level of the page tables is shared between guest mapping
> > and userspace.
> > 
> > One of the biggest advantages is that the page size of userspace is
> > completely independent of the page size used by the guest. Userspace
> > can mix normal pages, THPs, hugetlbfs, and more.
> > 
> > Patches 1 to 6 are mostly preparations; introducing some new bits and
> > functions, and moving code around.
> > 
> > Patch 7 to 16 is the meat of the new gmap code; page table management
> > functions and gmap management. This is the code that will be used to
> > manage guest memory.
> > 
> > Patch 18 is unfortunately big; the existing code is converted to use
> > the new gmap and all references to the old gmap are removed. This needs
> > to be done all at once, unfortunately, hence the size of the patch.
> > 
> > Patch 19 and 20 remove all the now unused code.
> > 
> > Patch 21 and 22 allow for 1M pages to be used to back guests, and add
> > some more functions that are useful for testing.
> > 
> > Patch 23 fixes storage key manipulation functions, which would
> > otherwise be broken by the new code.  
> 
> I would guess patch 23 also needs to go into the already huge patch which
> switches everything to the new gmap code, since otherwise bisect will not work
> for anything that is storage key related.

yeah I was thinking of that.... I don't like it, but I can't see a
nicer solution either

> 
> Anyway, I can imagine some addon cleanups, but that can wait after this series
> is upstream.
> 
> At least from a "core s390 code view", without considering kvm this looks good
> to me. There is at least one known bug hiding in this huge rewrite - but just
> wanted to let you know that my concerns with the previous version have been
> addressed.


