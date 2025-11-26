Return-Path: <kvm+bounces-64623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC18C88B80
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:47:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D94254E6DB5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CB4319867;
	Wed, 26 Nov 2025 08:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gvgKxi2V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7925E30BF72;
	Wed, 26 Nov 2025 08:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146838; cv=none; b=Bk6qmJIAyx/5AZvaGD/AU5NfkwmHF6FFSrPDr5blj2xxrcke6QTnWMXdmsu3fnWGyF3a/hcjGmZdDMPehkfGblsbLlnTYVLrQrWYFTU2Y4op9fqM6OXPROcWI2uJvEne6OF4nkqMHcAXfkLel2rC9uME7+9uKwme96OLGGWQP3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146838; c=relaxed/simple;
	bh=4884PjYNYLy/xKFUpOP9uKArPti15+ekOnRERZzbSkM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iVb2LRYIQeVkcN+MVxzO162US7Xe2mDKLhRlvfw1KBzjFUEMguh6icB3ou6KGzC6xHe24ba4F9fxqF4NjXTea543GWDpLSYpOoMrDV0/iGBdyuUhkMQS9VKCbgieax5cC1bXLJew0FNoyh4WieSvZPWesEVeLHTMTwtMoF/FOGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gvgKxi2V; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ5sJ4I019431;
	Wed, 26 Nov 2025 08:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XeQRaR
	6mY4vnMp4IwTeKlJpFD2ZqbWnJJ46FFSr2xwU=; b=gvgKxi2V+bZNIluQGI6cCa
	nELufzcnOPefGqo1FmVMZujF1w/d/HL1eqb14o7fq1ApkhOCLhmrQerUS2siUgAo
	vR1iP7iHAQd7EHf2Ow9EPY6qJZZ5FKxpJo4PcLspxWdqWz8I7pz9iD1OeH3Bw74V
	AilkQPkPmZEuVST2sCzd78oAtyCVyyCbsUNkxopk14tyd6lLH7Hin4j108yazpQK
	cGFFbx9bXzLwwodTPuKeWhN3WQFR4PvG25gM52zTUvR+AqWVemogPlrIfy/DJw2S
	zIb8rvOJMPXPiW9vRDjLg/jdrqfdAMTR77vrA7H24kZM5EEUt00EOXtnIM2ASYng
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kq227u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:47:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ8NSZ1030778;
	Wed, 26 Nov 2025 08:47:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgsh7bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:47:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ8l94559638186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 08:47:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6354920043;
	Wed, 26 Nov 2025 08:47:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 027FA20040;
	Wed, 26 Nov 2025 08:47:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.55.53])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 26 Nov 2025 08:47:07 +0000 (GMT)
Date: Wed, 26 Nov 2025 09:47:04 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v5 21/23] KVM: S390: Remove PGSTE code from linux/s390
 mm
Message-ID: <20251126094704.184c4987@p-imbrenda>
In-Reply-To: <20251126083818.10107A70-hca@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
	<20251124115554.27049-22-imbrenda@linux.ibm.com>
	<20251125192412.7336A36-hca@linux.ibm.com>
	<20251126083818.10107A70-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX1Z6MYE5jLt6r
 S3W/TkfzzXPtDhGc+QqT4xV4qqrtIz0qJmj8hVe0/Pdvve6emAB9sp9RpkDeIcbFRi6bW5QWbD0
 x02LU69O93fJu9EftfEitXO0z1PYszEOZVcKcACBJDG+ZWmO8cAS8Z99XY0p6F0IFF90kSVPiYM
 9oRsnZvzlmS6BS/C2i0TkpkMbM8ClYuBkEKIwp5qLdv/h4OlgSk8g8Ku8oEuO2+lvolQ5tAl6zN
 SuarLhr+K4lTNd7HVE6RnO3HUwMJBh/mCx/Mt9N+4XkVLN8EG1zzAYMzEAx8Wg4HBTPmyzjihDd
 CdHLhQEeF1RsThzkY3odFA9n9lYRobNbjETuAA3NyAT8sUplga+gBCnYyJl7p3k4fdiZzV0sEv3
 UgnNFgnmikyy1BOaIURxdiNkTIuDaw==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=6926be92 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=NnlkKe5a_FjY2rWv0OIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: jMgqjiBl3dYhPlmDhVEzUpjs_aVozzif
X-Proofpoint-ORIG-GUID: jMgqjiBl3dYhPlmDhVEzUpjs_aVozzif
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

On Wed, 26 Nov 2025 09:38:18 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Nov 25, 2025 at 08:24:12PM +0100, Heiko Carstens wrote:
> > On Mon, Nov 24, 2025 at 12:55:52PM +0100, Claudio Imbrenda wrote:  
> > > Remove the PGSTE config option.
> > > Remove all code from linux/s390 mm that involves PGSTEs.
> > > 
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > ---
> > >  arch/s390/Kconfig               |   3 -
> > >  arch/s390/include/asm/mmu.h     |  13 -
> > >  arch/s390/include/asm/page.h    |   4 -
> > >  arch/s390/include/asm/pgalloc.h |   4 -
> > >  arch/s390/include/asm/pgtable.h | 121 +----
> > >  arch/s390/kvm/dat.h             |   1 +
> > >  arch/s390/mm/hugetlbpage.c      |  24 -
> > >  arch/s390/mm/pgalloc.c          |  24 -
> > >  arch/s390/mm/pgtable.c          | 829 +-------------------------------
> > >  mm/khugepaged.c                 |   9 -
> > >  10 files changed, 17 insertions(+), 1015 deletions(-)  
> > 
> > ...
> >   
> > >  pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr,
> > >  			     pte_t *ptep)
> > >  {
> > > +	preempt_disable();
> > > +	return ptep_flush_lazy(vma->vm_mm, addr, ptep, 1);
> > >  }
> > >  
> > >  void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
> > >  			     pte_t *ptep, pte_t old_pte, pte_t pte)
> > >  {  
> ...
> > > +	set_pte(ptep, pte);
> > > +	preempt_enable();
> > >  }  
> > 
> > Why did you add the preempt_disable()/preempt_enable() pair?
> > This causes preempt_count overflows.
> > 
> > See modify_prot_start_ptes() + modify_prot_commit_ptes()...  
> 
> Ah, I guess this is probably just a rebase error, which by accident
> re-introduced the code which was removed with commit 57834ce5a6a4
> ("s390/mm: Prevent possible preempt_count overflow").

that would indeed explain where that code comes from...

I'll fix it

