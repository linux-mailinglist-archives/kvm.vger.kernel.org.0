Return-Path: <kvm+bounces-64622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB20C88AEA
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 095CD4E2D84
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A64319875;
	Wed, 26 Nov 2025 08:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ROzxuS1l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD09030EF6B;
	Wed, 26 Nov 2025 08:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146310; cv=none; b=EEW2YoVNS3NQRlI4gH9FyI0DKU8gw/QV5OJ7wPSCVsKa2Ls/DQe5w0JBRRveIxAsciWP2o2sVkL0Apu4Mry3GOMpzb79NBwEPu/l046kIbupAy8UHqQgSW2EPKPk2dDW+122linRYRVNTqvDMk6wWwSzy9FOSMdaPoA1bWNb0XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146310; c=relaxed/simple;
	bh=EC+2jgjUmEOxy0RKZMKgz4WfrEw3bIenLy/gVn3WixM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1WSiDwDSh4m1kzXYHn+btrJ53McUiPnrbqIfq3MB+5grCiNyL7rD1eLjFupiMtGZ68XuvcVyjWsQ8jp2H9k/4M9cgGC3B8//5wvmSNzWGV8aKx2jtqAEV47iba6kB/G1XUbb2Ofs1xnU+wZZ6i5sp2RR+6PBPLcacJLRm8/D4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ROzxuS1l; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ26hCC008068;
	Wed, 26 Nov 2025 08:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZrhpnKCsBKBJ3FWX7lfJI+CFXRuOVC
	NjlYHni+5FeOE=; b=ROzxuS1laVpd6JeWNI1YdASpbid83ml+q/s+yCTVYl53UE
	KVjeS7A+XStD/FL+5On8VkW35QMwmcGFNGXYQqEHK/aYK4+kou9XNouzlAmEZIP7
	VWhGBHv3VHb0hthgEkTXjvQr/my9t2LswddVK/qoCgj4SeDSQmBGnD+FugNI1KWb
	oqN8HcpiF550nxsCnOfrsK1WZ0zuPx0zclUCpzQH9A7CEHDXc8j+A/itQugQ2NXL
	lyhCl3zHVy55kXbJB3WR/4hM1Gm/E2GmJB1tRrMGZVezWVVAs72eMGoEWZkzMhZo
	mg5ZeSVnDEE6cgWsnuW+ojYvMlRLthxxlS/vVKxA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kk1vx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:38:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ5Zpc1013916;
	Wed, 26 Nov 2025 08:38:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akrgn928h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:38:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ8cKp752953466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 08:38:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3ACD520040;
	Wed, 26 Nov 2025 08:38:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C241E20043;
	Wed, 26 Nov 2025 08:38:19 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 26 Nov 2025 08:38:19 +0000 (GMT)
Date: Wed, 26 Nov 2025 09:38:18 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v5 21/23] KVM: S390: Remove PGSTE code from linux/s390 mm
Message-ID: <20251126083818.10107A70-hca@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
 <20251124115554.27049-22-imbrenda@linux.ibm.com>
 <20251125192412.7336A36-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125192412.7336A36-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Myuton4zrC7-PJ_6jMUkeaNGxeat6X_b
X-Authority-Analysis: v=2.4 cv=frbRpV4f c=1 sm=1 tr=0 ts=6926bc80 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=gu-ZkYC6vqNpQ_s7iPcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Myuton4zrC7-PJ_6jMUkeaNGxeat6X_b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwOCBTYWx0ZWRfX3G3jTkMtg+QP
 nw73jvttXwtdNcVtkrOG3joraojgskzrSH3Qq8spbxQq0fPTh4Tc+gecE7/OaIzZXlyQncPGf+o
 d9fqkBmgbhljSeQpfrGiuh0yI3Mwye7R0bbbnzrehqQkwDT0edGzkO55WjHRRrEd7oz0fNUDm+S
 pIvpM3bpwErFyNtE9Z8BUlEoUMqW4Yh/LkZI0UsUQRW5t639/lzvw9AKBGrnkFWZfj27PSFUG0f
 Gv+XmhktbSM42TJf2M5DuaIUl0Lkpx3KoXqpwIrZD5x3xnojGOn/uO/S7uN3hfhpq3m9Onu174B
 7qROQCRV/ssW0sxN0ijZKA1bT0v2IPZHg7aRU1G8gz352qv/2nuJPn9k9ufoIhh8+NfFrDoWpcw
 TD8WjpQqrwQLZKDq6WG45ooztTInAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220008

On Tue, Nov 25, 2025 at 08:24:12PM +0100, Heiko Carstens wrote:
> On Mon, Nov 24, 2025 at 12:55:52PM +0100, Claudio Imbrenda wrote:
> > Remove the PGSTE config option.
> > Remove all code from linux/s390 mm that involves PGSTEs.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/Kconfig               |   3 -
> >  arch/s390/include/asm/mmu.h     |  13 -
> >  arch/s390/include/asm/page.h    |   4 -
> >  arch/s390/include/asm/pgalloc.h |   4 -
> >  arch/s390/include/asm/pgtable.h | 121 +----
> >  arch/s390/kvm/dat.h             |   1 +
> >  arch/s390/mm/hugetlbpage.c      |  24 -
> >  arch/s390/mm/pgalloc.c          |  24 -
> >  arch/s390/mm/pgtable.c          | 829 +-------------------------------
> >  mm/khugepaged.c                 |   9 -
> >  10 files changed, 17 insertions(+), 1015 deletions(-)
> 
> ...
> 
> >  pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr,
> >  			     pte_t *ptep)
> >  {
> > +	preempt_disable();
> > +	return ptep_flush_lazy(vma->vm_mm, addr, ptep, 1);
> >  }
> >  
> >  void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
> >  			     pte_t *ptep, pte_t old_pte, pte_t pte)
> >  {
...
> > +	set_pte(ptep, pte);
> > +	preempt_enable();
> >  }
> 
> Why did you add the preempt_disable()/preempt_enable() pair?
> This causes preempt_count overflows.
> 
> See modify_prot_start_ptes() + modify_prot_commit_ptes()...

Ah, I guess this is probably just a rebase error, which by accident
re-introduced the code which was removed with commit 57834ce5a6a4
("s390/mm: Prevent possible preempt_count overflow").

