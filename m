Return-Path: <kvm+bounces-57735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 271DAB59CA8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C9973BCC24
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A62372885;
	Tue, 16 Sep 2025 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZrNs6Hrn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57BF371EAB;
	Tue, 16 Sep 2025 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758038179; cv=none; b=jyc2zumSO/H4nR4j5woC0ri3BBxEKtieuQESjwd1SBLZHsbGpVpR19ifzAVqu+xxim1eDESXXtSikPLjRUs2JAKXbqSt3uvwBO1NGtIII4wtuFS2ss77bE4gYJdmcK3vlX5Wmj+6uiL/ixK/0dn1gu1rGZGFVUHTIBtfY6E/61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758038179; c=relaxed/simple;
	bh=NugMR4ojuQHJLCwEJKWJ9YnSu02+g/F2ghj5y2kslow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1uQXOfKOLZ/ZO0nLqkEFXF4UkGf5uZbKc+uTWe8ANnt5akWRAkGFEWyic6c164bPdByQWLULxT7GAg5bXoZXefH2BC4UZppclk0Yw/TWaUESltOZvpenK7+KYcmOqxFUrnFUuLndG4MGM61Yy83M8/Ib5FnfsizNKuZbpYdCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZrNs6Hrn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G8F4jR024216;
	Tue, 16 Sep 2025 15:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6LQOVkkyW5/HnWO4zdFq999Za8EDtg
	Fow0FksTNlEWs=; b=ZrNs6Hrnr9jbaixPJnJHsXiZwJlQIoYjQ/KmbogvdFFBxn
	4t8FJQjKbu8Vnn9tFzA9OldtXw1fyrkfnZjfmomu8g6XaI30adFamIzwWq1w/31a
	EmAMtkxxmsUu6qspNILIGZq/RMGT9ZdVLYGkOY9s4If3EuKyiTedE5gQ+hsE3d+J
	tHOLv0BaqbCbN+PDGC9PeOl97b4mQs9kAdNKUoTDa6dr4OleJLKCMZIufLnqqw7I
	okc6IXTOSbFLHqx/1SguLM5E/XIrzdWi12pJOMWPXYFLnCqZcDYL7zXBRhkmFOU6
	5S75thn76hWUUlBG4y9atM9IdJD1FjEZHnNLXEAg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avnt9kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 15:56:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GFZ0iu009395;
	Tue, 16 Sep 2025 15:56:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3ccvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 15:56:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GFuAF148824830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 15:56:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EAE120043;
	Tue, 16 Sep 2025 15:56:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9673C20040;
	Tue, 16 Sep 2025 15:56:09 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 15:56:09 +0000 (GMT)
Date: Tue, 16 Sep 2025 17:56:08 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 09/20] KVM: s390: KVM page table management functions:
 clear and replace
Message-ID: <20250916155608.27229E26-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-10-imbrenda@linux.ibm.com>
 <91f044a5-803f-4672-960b-cd83f725af44@linux.ibm.com>
 <20250911151932.2bce5e01@p-imbrenda>
 <9bff1dd8-d8f9-426b-83c4-0ac2d0cbd4f2@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bff1dd8-d8f9-426b-83c4-0ac2d0cbd4f2@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iD2Sc0Ht-4C1A9t6rCmZ50rsBN3Geug9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfX7Bmsa1r8qC29
 UWORRlpIeZL/X44NLyg2jtRPTmo29GwxPFgZP9J8rAz2C0VrHkUqQz5+CHYWjOIimGmSvhMb166
 17i7oQdvzuBr+ymnfeCDFgZ4cXZou6qhS+Q8UkFAjQpYk8Oe+bGCZodacDQPIT972oJyVr/ofMw
 uNdxfn8O/Of9t68dryQvGch8NWy6ug3xkWwy+CMRsIUTPa+Fu2KbHGwJVphd8e6ft4mXnjfssDa
 HfRlVGGfl5FsmgJFwD4EqqZZAPY5PmV92oNk0/Glb4FkJX9UUlxp46PWF8IPfKnR0tl1yLr6YSA
 YYBQzbnJYXXNEmkJGfgtX4Kh2X7psHsChzXQP6G3dqwVDWMkkCXZ2Ml+P8geJyVeFAGKI8D6161
 UkFbdN92
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c9889e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=hojQ0DijzFZNpfwxlroA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: iD2Sc0Ht-4C1A9t6rCmZ50rsBN3Geug9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028

On Thu, Sep 11, 2025 at 03:27:39PM +0200, Janosch Frank wrote:
> On 9/11/25 3:19 PM, Claudio Imbrenda wrote:
> > > > +void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce)
> > > > +{
> > > > +	if (crstep->h.i) {
> > > > +		WRITE_ONCE(*crstep, new);
> > > > +		return;
> > > > +	} else if (cpu_has_edat2()) {
> > > > +		crdte_crste(crstep, *crstep, new, gfn, asce);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	if (machine_has_tlb_guest())
> > > > +		idte_crste(crstep, gfn, IDTE_GUEST_ASCE, asce, IDTE_GLOBAL);
> > > > +	else if (cpu_has_idte())
> > > > +		idte_crste(crstep, gfn, 0, NULL_ASCE, IDTE_GLOBAL);
> > > > +	else
> > > > +		csp_invalidate_crste(crstep);
> > > 
> > > I'm wondering if we can make stfle 3 (DTE) a requirement for KVM or
> > > Linux as a whole since it was introduced with z990 AFAIK.
> > 
> > AFAIK we don't support machines older than z10 anyway
> > 
> > but in that case we can only get rid of csp_invalidate_crste(), which
> > is not much.
> > 
> > I can remove it, if you really think it's ugly
> 
> That was more of a general question, I think we have more of those checks in
> non-kvm code. Your code is fine as is.

Until now we have a check for all privileged instructions before
executing them, since at least in theory they can go away in future
machines.

The only exception is the mvcos instruction, since it is used all over
the place.

Unless there is a really good reason (e.g. large amounts of code could
be removed, or performance) I'd like to keep it like that.

