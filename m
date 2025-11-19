Return-Path: <kvm+bounces-63701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB3FC6E2B6
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 12:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id BA0972CFFD
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2BE34BA4E;
	Wed, 19 Nov 2025 11:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lYF3o3eb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E081E766E;
	Wed, 19 Nov 2025 11:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763550822; cv=none; b=SL95TyxBiCQkyDXrA97MisU/jsDoV/iPRRxaRxa+aUPsfdRKhrkHjgOxe9b3XrdTRfad0SAfq8IW/d2lE+dGipSXcfYjVnUC6TbeslLYJ1Vmyl7Bg77kiVdx48ZlOb2xbdptZtTt4CKCYhIRr4zdV7JFoErx7topEBwaSh8AsZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763550822; c=relaxed/simple;
	bh=X88ETSeWNp23csy3YYqDWCNPielw/Ry9oPEjqSdLVWM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkeNIGUEpy//CEmqq900xLODTp6+cBl49JPzaXO9XOfwoPa3lpnIjatg9D3fOWvYNQhkk/ivPf3OsUY+0XUe2hJ5ltLeaHV4FBkaSQSeU7nAzAWYp0ixfx9o65aZMWWBK7Ny05MO2bHeyWLXZDmQUiYIz5yFchXetWF12oi90Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lYF3o3eb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ8HHUP031486;
	Wed, 19 Nov 2025 11:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rBxqM0
	7p1e6rNrwsQKNE75ZVvOhiE64dsaLDroQarSU=; b=lYF3o3ebrf876qZ3q2uCp5
	YDrUTf4PbcpWwZXdXk48g11aW8tzCncAkbKDWQjLCFWNesgQ61xy4Z83Joiu8MHO
	yvylPucUBBvdPAKdeEM4wg9FsgVtwifxaw2f0qZQujilj9KKylSGpXVHnMMKvLr6
	Fw5H/FA67xaxT9OQlJyCkipwkwdNrW/YKygOAInBpr15oKDa/4fS3D0uL+RRlZdm
	3EXf7reDYDl4sgb56C7aRa70UJq4CexAKJP/xPRC397+WYHSoYxDQMOR3AvkjfzX
	cqdPp4xoECgsB9rf3PEducad0iuCljxNxRkwZGdiKPba3uYD4/siur+OOjDqmfSw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka008r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:13:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ81spr006964;
	Wed, 19 Nov 2025 11:13:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af62jg13u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:13:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJBDX4840632806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 11:13:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A43F720043;
	Wed, 19 Nov 2025 11:13:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 616E920040;
	Wed, 19 Nov 2025 11:13:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.156.96])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 19 Nov 2025 11:13:32 +0000 (GMT)
Date: Wed, 19 Nov 2025 12:13:29 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 18/23] KVM: s390: Switch to new gmap
Message-ID: <20251119121329.5882ce97@p-imbrenda>
In-Reply-To: <20251118151818.9674C62-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
	<20251106161117.350395-19-imbrenda@linux.ibm.com>
	<20251118151818.9674C62-hca@linux.ibm.com>
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
X-Proofpoint-GUID: 5rn_kGTQqiHiFphAD1qtvh6VBqAA-aFQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXw6ZfJ1UP4vaF
 O7udPwQt/yRAaOgW+ERF7XjRNZc4wfQEMIrb1giw0A4KKH88pDTqJbrbWWx9cjf9clw1gvmpTmd
 GreV/q9o8m4K9q+MmUwV8pPqx6OulxJ4jJxxbya4SmmjcLhuFcxKfeyMTyPB/SJNu03wx8H6dsi
 DrN2h70LWt+FImY/zsgA8q1t/nab2kMMmkf8zVuiEwSX7cKUv9HRXrtdYoVF93V5wBS+My+kegD
 sO8K0fHRVJ4HNdOD9VvrK3L4yuXQQu/QZ0gPjCgM8gw7t20HepFUo1cDkOBjpdT1CDHC57zob7h
 UpFkSSYtyLlZXkhe8kzxHt+qb3P5vdOlyRYMsc/G6SjNoRDwIQ880RS6mwW71WYkZPyVeA97I/X
 pZCPT4eH1+M7bBMsF/EQ665gPe3X6w==
X-Proofpoint-ORIG-GUID: 5rn_kGTQqiHiFphAD1qtvh6VBqAA-aFQ
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691da662 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=yTzIwsH_hqlntiTJneoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Tue, 18 Nov 2025 16:18:18 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Thu, Nov 06, 2025 at 05:11:12PM +0100, Claudio Imbrenda wrote:
> > Switch KVM/s390 to use the new gmap code.
> > 
> > Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
> > existing users of the old gmap functions to use the new ones instead.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/Kconfig                   |   2 +-
> >  arch/s390/include/asm/kvm_host.h    |   5 +-
> >  arch/s390/include/asm/mmu_context.h |   4 -
> >  arch/s390/include/asm/tlb.h         |   3 -
> >  arch/s390/kvm/Makefile              |   2 +-
> >  arch/s390/kvm/diag.c                |   2 +-
> >  arch/s390/kvm/gaccess.c             | 552 +++++++++++----------
> >  arch/s390/kvm/gaccess.h             |  16 +-
> >  arch/s390/kvm/gmap-vsie.c           | 141 ------
> >  arch/s390/kvm/gmap.c                |   6 +-
> >  arch/s390/kvm/intercept.c           |  15 +-
> >  arch/s390/kvm/interrupt.c           |   2 +-
> >  arch/s390/kvm/kvm-s390.c            | 727 ++++++++--------------------
> >  arch/s390/kvm/kvm-s390.h            |  20 +-
> >  arch/s390/kvm/priv.c                | 207 +++-----
> >  arch/s390/kvm/pv.c                  |  64 +--
> >  arch/s390/kvm/vsie.c                | 117 +++--
> >  arch/s390/mm/gmap_helpers.c         |  29 --
> >  18 files changed, 710 insertions(+), 1204 deletions(-)
> >  delete mode 100644 arch/s390/kvm/gmap-vsie.c  
> 
> ...
> 
> > +static int _gaccess_do_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
> > +			      unsigned long saddr, struct pgtwalk *w)
> > +{  
> 
> ...
> 
> > +	/*
> > +	 * Skip levels that are already protected. For each level, protect
> > +	 * only the page containing the entry, not the whole table.
> > +	 */
> > +	for (i = gl ; i > w->level; i--)
> > +		gmap_protect_rmap(mc, sg, entries[i - 1].gfn, gpa_to_gfn(saddr),
> > +				  entries[i - 1].pfn, i, entries[i - 1].writable);
> > +  
> 
> Why is it ok to ignore the potential -ENOMEM return value of
> gmap_protect_rmap()?

because it isn't! I'll fix it

