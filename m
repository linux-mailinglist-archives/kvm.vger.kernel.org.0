Return-Path: <kvm+bounces-57760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D240B59E4B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6E37581FCF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1319D3016F3;
	Tue, 16 Sep 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gn5sz2AM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC553016FB;
	Tue, 16 Sep 2025 16:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041349; cv=none; b=uS2Qd6Cpunr+fUiDjy2bvGPvEr4vfww7FSyYlmE9jdaitlkPpOwKE2uCE6+j/oeYnqE2J9IOlo2q7m5LcPfxWMNyK1G5CufvKsaeGwAxQhNubM6UEyAcXSKxsEIxiTs62ZMKXp+QfdZfDk+uA4zgxFYkjGU91aOA4vWvwZO9HFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041349; c=relaxed/simple;
	bh=Hyi8LfBR7Qtis9Fa2/EK4PU3bOjcXp5x/vJaSoxZ2zk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AqmS3G8cITA8hA4vCg4t23l9kXbdvMRnMzI6AOnORdlF1KG83evJpdpUtuYebflhbmjy4BWSFC7mbtlCX0fAw9teFipsyi5o8XcN2+DnERU2RIDe2HZ3KgpJsCqwIvqpqdyW+xa0wF1VKTw1ymYgZ+3l77hUMeBMRNQWePF2ZA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gn5sz2AM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GCbJvF011685;
	Tue, 16 Sep 2025 16:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Vnv6y2
	Qm4cs41oT66WBxccZMFoBzFLhDBwSnn9Jy+/E=; b=Gn5sz2AMO4Z6I18bG7rmeJ
	9K+V2HsdqQUAh3M9sE9YRw8WJ0xMmmVv94PtGYAvl19oJsrE1qMb8DHwCKN3w2u+
	+fgr92PMSDSukGD9hWW3sQhknlL0Bm6SunVVxQLgm0RWP6MGlviwV8c9NqIRioFE
	IvHItXhgdrSWUaZ6/UdoekNIwb11rk0pH70HOcMhmPU3fsr2dSr9PIVyr2WsHzqN
	fph3jOsXm/kImpfsagU9GcLfuk5TzYBcS7No96nUCJUqW0KS5bTAQdnGdynN7w82
	hgFmLLNIKZjGCFMsKRopdtD9pAjxqPhCYBbaDbOuuciE5GzMJKYjhaQGtgqmVFig
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494y1x9n1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:48:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GGl0u2006360;
	Tue, 16 Sep 2025 16:48:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu55m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:48:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GGmsdE37814740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:48:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FA822004E;
	Tue, 16 Sep 2025 16:48:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BB8920040;
	Tue, 16 Sep 2025 16:48:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 16:48:54 +0000 (GMT)
Date: Tue, 16 Sep 2025 18:48:52 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management
 functions: walks
Message-ID: <20250916184852.50ab6a67@p-imbrenda>
In-Reply-To: <20250916162203.27229F62-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-11-imbrenda@linux.ibm.com>
	<20250916162203.27229F62-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMCBTYWx0ZWRfXzON5GK/KJk8s
 QrSKd3+jtHsOv9GD3i8F9QwO0tZLoPT1h9AcqfIHeCxrFr9YJUABkxC4MOc1Ui9vOqmzNSPkPG6
 vCEdkkj5A/vWxo8BRYHcQ453hzTktvefgNwll3BUWiQpkDv9cXl4esQK2bG6SIObsJUW4Be4BLo
 xmKfOUcDkTp4pjjOrdcR5RMIV/BLfAPS6W+0gJ8KSlYlrmg9tFPsZGTZBzjI58EUIewakYxOby8
 NaFJVOpnJZ6ypv6dGg7XQ7u9UvTy7VQtPeZBy3TfWaaQL2QthXcaNgdvPZHF8uYOBY3qjR5CAjh
 v/fKxsFS8uQkzrTKxBvPwLhaHrHxg235H0p/vHilb4wzzd0Mkwq5819U13t0/rWvDfTxqvjdT4H
 N0yc5tpq
X-Proofpoint-ORIG-GUID: szTIrlIXCSy9gtaIbzwYWnwSXfFldcMd
X-Authority-Analysis: v=2.4 cv=euPfzppX c=1 sm=1 tr=0 ts=68c994fb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=RUxn0sPGPTxKxFsC86kA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: szTIrlIXCSy9gtaIbzwYWnwSXfFldcMd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130010

On Tue, 16 Sep 2025 18:22:03 +0200
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
> > +int dat_entry_walk(gfn_t gfn, union asce asce, int flags, int walk_level,
> > +		   union crste **last, union pte **ptepp)
> > +{  
> 
> ...
> 
> > +	table = dereference_asce(asce);
> > +	if (asce.dt >= ASCE_TYPE_REGION1) {
> > +		*last = table->crstes + pgd_index(gfn_to_gpa(gfn));
> > +		entry = READ_ONCE(**last);
> > +		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))
> > +			return -EINVAL;  
> 
> Since I've seen this all over the place: this looks just wrong to me.
> 
> This is mixing some random software definition "LEVEL_PGD" with hardware
> bits. A "correct" table type compare would compare with TABLE_TYPE_REGION1

they are defined to be the same for this reason, but I understand what
you mean, and I can use the TABLE_TYPE_* macros instead

> instead. Also using pgd_index() & friends here is semantically wrong.

how so? in the end all the various p?d_index() macros are just a
shift-and-mask. I think it's more readable than open coding
((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1)) each time?

> 
> For normal processes the pgd is always the top page table level (present and
> used), and lower levels like p4d may be folded. This is not the case with this
> code, where pgd, p4d, etc. seem to have a completely different meaning and are
> mapped to specific hardware page table levels / types, where the top levels
> (pgd, ...) are optional.

yes, and we do not use pte_t or any of the p?d_t types in KVM for that
reason

> 
> Why is this mixed? To me this looks like the potential source for a _lot_ of
> confusion and potential bugs.


