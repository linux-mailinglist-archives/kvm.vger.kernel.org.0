Return-Path: <kvm+bounces-57885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1D7B7F2B0
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CF96624A2A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47B731A80B;
	Wed, 17 Sep 2025 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KARdc1hn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A671A9FBE;
	Wed, 17 Sep 2025 13:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114836; cv=none; b=i7cIS2RtZBO08k+6ExZnfOVkKSb08BmHVSWLkIW5kp+2zKDudM/8rlfOLwrpNXQflZKTZr0MOSRsDLiAM29/QXRdeHVwVTOL0uS4FUuB5F/t3yMByyUs2i+RIk8lquHm+hbfv8chZXXUuNceT94eB4wQgAcEXTawnn3xH2J9HPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114836; c=relaxed/simple;
	bh=kf1UcpfsuE9daxZ3IUg6B/j73RqWL3xM2J8LUiPYkls=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVcP2Y2UJwl84Fe/sWSmBigTvHR4OLz+HmlC8mLjZj+ZBz3taZ2tybXtsTI46W9DlSuvj0vvtHq31FaKwbB5vT7UZuMqOfNsyDxt6ZcC/9Sx4ne0crSuUY4vMnUP2wbBs3drkS9SjxN42sqTGaDEWNfirIC0c0f2lBTkbwNOxwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KARdc1hn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H3V0tO006031;
	Wed, 17 Sep 2025 13:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dfM3Gg
	efuhSX3qu56DtLJsjZ+HfrhMzVNu9ACHR14Ho=; b=KARdc1hnYKnMJJh7JCyAJD
	0n1SO1iivQR2QvCxXJE4PpX5pcp8+j9IvugcBaTgsz+4dyDs2UudkW3aDraM0KcV
	WoYDvDo7njE1jEnzEv4vySJuDV9zEWEOs75qbEso8sXA/0Alky0bLDuEOhL4Nqyc
	g3am8heTkAKBy6tMTMc2T6tug2VrG52YoFOVonBRwISMZzTDEwr9IBZDOfmfKiJl
	RC/aaLdccnn4A1qvT1a9l4h/+Ab9Fgu3qV3dRe2JqCvc3h6tfI2uLdZDrCS++2jX
	PrVOc90bF4ZgLMnnxWo1cpiNrxayUkVObTiG1rYBOnMUrxhv7UPBp+xt59e29tfw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nbnsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:13:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAvl1S027349;
	Wed, 17 Sep 2025 13:13:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men99nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:13:50 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HDDlB860031390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:13:47 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F280520043;
	Wed, 17 Sep 2025 13:13:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAF9A20040;
	Wed, 17 Sep 2025 13:13:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 13:13:46 +0000 (GMT)
Date: Wed, 17 Sep 2025 15:13:44 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management
 functions: walks
Message-ID: <20250917151344.75311b9d@p-imbrenda>
In-Reply-To: <20250917125529.7515Df6-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-11-imbrenda@linux.ibm.com>
	<20250917125529.7515Df6-hca@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cab40f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7j37GtS7utVOAVQezkYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: YYgktApnSkiPO_fPTLeJw6aAIFoMO5bZ
X-Proofpoint-ORIG-GUID: YYgktApnSkiPO_fPTLeJw6aAIFoMO5bZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX5zoxO0ms+0JB
 X4uwnizeiiT8zGtCbU4sajLlJO0NMZycqK4yZ1MplDiGBWcWom0+W1kq/aYtmJNyXkTlgMVri+q
 Mtuf6tXYC9V2z3J3Ggrsv+OKFYG7TaNpwnNrdD+9N6Xvqmcg9Y5dMDy2rhMlwQHsvhEJ8DLpmdl
 Gh17h8+qicxfwhXFVmimOVd4LHBV041cwEy/xrk1L1cUS+CNID5RpVU4L3R4TnBAnLDs77AWuzh
 UH4J4SCc23rlAXWq0/RsVza6R/Ora8StKP2VO2IBRfPA2rLUblm2lzV/oIylS7juGKzII0juyOZ
 FiT6YQW1l4ADxA+YPMWFVTZiEauaMCNQxfDaRFu1nDeoBYUJVB0J07DbEUf9aFMol8bLLfohHtB
 ue0aFoso
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, 17 Sep 2025 14:55:29 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 10, 2025 at 08:07:36PM +0200, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds functions to walk to specific table entries, or to
> > perform actions on a range of entries.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/dat.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
> >  arch/s390/kvm/dat.h |  38 +++++
> >  2 files changed, 389 insertions(+)  
> 
> ...
> 
> > +/*
> > + * dat_split_pmd is assumed to be called with mmap_lock held in read or write mode
> > + */
> > +static int dat_split_pmd(union pmd *pmdp, gfn_t gfn, union asce asce)
> > +{
> > +	struct page_table *pt;
> > +	union pmd new, old;
> > +	union pte init;
> > +	int i;
> > +
> > +	old = READ_ONCE(*pmdp);
> > +
> > +	/* Already split, nothing to do */
> > +	if (!old.h.i && !old.h.fc)
> > +		return 0;
> > +
> > +	pt = dat_alloc_pt_noinit();
> > +	if (!pt)
> > +		return -ENOMEM;
> > +	new.val = virt_to_phys(pt);
> > +
> > +	while (old.h.i || old.h.fc) {
> > +		init.val = pmd_origin_large(old);
> > +		init.h.p = old.h.p;
> > +		init.h.i = old.h.i;
> > +		init.s.d = old.s.fc1.d;
> > +		init.s.w = old.s.fc1.w;
> > +		init.s.y = old.s.fc1.y;
> > +		init.s.sd = old.s.fc1.sd;
> > +		init.s.pr = old.s.fc1.pr;
> > +		if (old.h.fc) {
> > +			for (i = 0; i < _PAGE_ENTRIES; i++)
> > +				pt->ptes[i].val = init.val | i * PAGE_SIZE;
> > +			/* no need to take locks as the page table is not installed yet */
> > +			dat_init_pgstes(pt, old.s.fc1.prefix_notif ? PGSTE_IN_BIT : 0);
> > +		} else {
> > +			dat_init_page_table(pt, init.val, 0);
> > +		}
> > +
> > +		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce))
> > +			return 0;
> > +		old = READ_ONCE(*pmdp);
> > +	}
> > +
> > +	dat_free_pt(pt);
> > +	return 0;
> > +}  
> 
> Just to annoy you again: is there a particular reason why this function isn't
> called "dat_split_segment()" instead of "_pmd()"? I'm still trying to convince
> you to get rid of pmd(p) usage, whenever possible. IMHO this would make the

hmm I can rename it

> code easier to understand and maintain as it doesn't mix things, as I already
> stated previously.
> 
> > +	if (asce.dt >= ASCE_TYPE_REGION2) {
> > +		*last = table->crstes + p4d_index(gfn_to_gpa(gfn));
> > +		entry = READ_ONCE(**last);
> > +		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_P4D)))
> > +			return -EINVAL;
> > +		if (crste_hole(entry) && !ign_holes)
> > +			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
> > +		if (walk_level == LEVEL_P4D)  
> 
> Also this (even though also as stated earlier): IMHO it would be good to get
> rid of the LEVEL defines and use the corresponding TABLE_TYPEs instead.
> 
> > +	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
> > +		walk_level = LEVEL_PTE;  
> 
> Hm, ok, there is no TABLE_TYPE for this level. Invention required :)

yes, this is why I have the LEVEL_* macros :)

do you think I should instead  #define TABLE_TYPE_PAGE_TABLE -1  ?


