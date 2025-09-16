Return-Path: <kvm+bounces-57759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A723B59E36
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:49:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA8C581204
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051623016F3;
	Tue, 16 Sep 2025 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VEw1aiI2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDC627F16A;
	Tue, 16 Sep 2025 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041269; cv=none; b=Pgj5irc+ZWV/lwLj6MF+kCF4VdCz3Punv8rJDhsndH19LhzCeHHlcVKqGMGgJ0FapbJszcalknOxn1zVclanzwzwZj2+xxYrsm6ewc2aM/osVXGnNYo8DMiwXo5x/W6fn6l8/tBLCPSIf0y6/PiDFIY1e0uZhMijxw+Pd3Uu1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041269; c=relaxed/simple;
	bh=XZs1fmV1RWAiHhO/H7GufzCYcIj+rQxvJp62nan3ZhE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CSM5iP/HRp6/whIrFixgXX2q/WYL0wwDQV6uvizziCHEkbja5treDDk+NL1xpNfuNRexbVsdDH3HS+mMIwpsP/fAj1TlXOdStOpHf0/QQiRicsxGH9PIl4kaxa9ko081NtDWqJ3qKzTrciz9vwqY3P2U/FQimyksGaKb+7S8cnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VEw1aiI2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G9dB2w015474;
	Tue, 16 Sep 2025 16:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5Xi98c
	Bn+T5Yi/Kf9h95BF11E9scLT4yHZC0ZaDSpbs=; b=VEw1aiI21JBsAsSr7JqCxZ
	JQbMzTFfnMcEN433IpDBvpmRdUIQiooPbms5U6TkKbLV9bziRX+NmzirAb5db0Sq
	i5bY1McQP8CDwJsYAenVWX0tJ6i/Wcp68jhRGtKYkyIcvrlceBDdIFxhCaYeMegf
	r51otPMeYeNLskHL1EGzZIJPSCGyIeTwuIipsdyRv1SJ37bnI94k7lnGIK1nA9W5
	Hvek3zOt750jHmeo41kunM6K3pCKgnR+nGV/Oce3aucVzaYgRRBQbbnMTMVaZyj6
	gpPXrJRAhDO+LkcH90X1mr41SHKzJPGmPy0fHCDiEFqLki3djQZV/8x+5du1th6Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509yarb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:47:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GFOxm2009363;
	Tue, 16 Sep 2025 16:47:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3cmd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:47:43 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GGleFH61014352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:47:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1843120049;
	Tue, 16 Sep 2025 16:47:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C63D32004B;
	Tue, 16 Sep 2025 16:47:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 16:47:39 +0000 (GMT)
Date: Tue, 16 Sep 2025 18:47:37 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250916184737.47224f56@p-imbrenda>
In-Reply-To: <20250916162653.27229G04-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-9-imbrenda@linux.ibm.com>
	<20250916162653.27229G04-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyMCBTYWx0ZWRfXynYjk6ErHtR4
 QDH34kFph+uxaNJHTMAGOcKW2AqCpYcGC+6crh5wE6u+tVriw8kXGXEbphQpKfM7iLX7gLWxYWn
 iRr1M3n4QzG/RURTywfu2p0qDx6nxFihovroBz9SL2e3wb7bP1/zL+j+Eqq6Rc3HDw5qu6u4z4d
 I/sfGwkTLI5WpgIUxFtzkDKTnRzk75arJ84sI4p9XkaLDvuLE33QxEcek2ok+AG0KVgsaHTP8FF
 mIO4U248rgG3pQgmup7l9B8MNoBGRz1K5neUATz636jyE0DCx9twLAM84XW6BMwT/mAyrsuQ6IN
 D7xHqQ+3fB6l1CV3LuXMErBWpz+pu0tT+bP22Vl7sQgTQi+V9JBo/Sjxqzqx9/Fbp6gHdGnPcb+
 Ltbb2cW7
X-Authority-Analysis: v=2.4 cv=OPYn3TaB c=1 sm=1 tr=0 ts=68c994b0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=tt58nDBCtseFxLvUmBIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: TkA2IOmGeb4RVvbUaC9Hgogtj4rmomC_
X-Proofpoint-ORIG-GUID: TkA2IOmGeb4RVvbUaC9Hgogtj4rmomC_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130020

On Tue, 16 Sep 2025 18:26:53 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 10, 2025 at 08:07:34PM +0200, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds the boilerplate and functions for the allocation and
> > deallocation of DAT tables.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/Makefile     |  1 +
> >  arch/s390/kvm/dat.c        | 91 ++++++++++++++++++++++++++++++++++++++
> >  arch/s390/kvm/dat.h        |  4 ++
> >  arch/s390/mm/page-states.c |  1 +
> >  4 files changed, 97 insertions(+)
> >  create mode 100644 arch/s390/kvm/dat.c  
> 
> ...
> 
> > +static inline struct page_table *dat_alloc_pt_noinit(void)
> > +{
> > +	struct page *page;
> > +	void *virt;
> > +
> > +	page = alloc_pages(GFP_ATOMIC, 0);
> > +	if (!page)
> > +		return NULL;
> > +
> > +	virt = page_to_virt(page);
> > +	__arch_set_page_dat(virt, 1);
> > +	return virt;
> > +}  
> 
> Is GFP_ATOMIC a typo, and this should have been GFP_KERNEL?
> 
> Otherwise I would guess this will cause problems in the future when
> under memory pressure allocating guest page tables fails easily,
> while before this change such allocations never failed.

how so? the documentation in gfp_types.h says:

 * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
 * watermark is applied to allow access to "atomic reserves".
 * The current implementation doesn't support NMI and few other strict
 * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
 *
 * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
 * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.


I think GFP_ATOMIC actually gives more guarantees?

