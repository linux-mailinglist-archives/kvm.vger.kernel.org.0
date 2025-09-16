Return-Path: <kvm+bounces-57763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F7CB59EBF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2A4716F4B9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8EB2F5A07;
	Tue, 16 Sep 2025 17:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ri0XvzVg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F23032D5D2;
	Tue, 16 Sep 2025 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758042261; cv=none; b=DZawtsNkqIW+lGTJtDxxFJEaZbNPfXQ2MADd1fEFX7kSzcDMd2XwU5mRZmLiKWVN/SWTajBUgWvNpYbpTFKBu1bke1pWYqIZCuY1bBt/R09zaRiXPEUBNqr3s8OPg2V0WZQyzDX2vQ+Z2rFjY1Dh0hokC7QwWmkOSxP/Vd1C0dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758042261; c=relaxed/simple;
	bh=g48DcOYQA5sUQjQM9MnHFiVSge6boXSJwKW7LJka7Oc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PzFDbjCfWCoucHBMBArHnRA6SPN3kNAKzX/NyBY18qO4TE4EesUyQ/YVCqRQ57YbOhAKbTzpUbCoL5vubz+K8NeRcE3iyblGpmPDcY3ZCYV/IG7qbrAExUqg3dE4JwJaMqpKSrhjGVCaAtpSuFEpxSrUIt04Thnv48nbEQeps/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ri0XvzVg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GB6hBm030372;
	Tue, 16 Sep 2025 17:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lCn4Qn
	K4pEd7x9VKTvHDpZ8e4tUWennVbW9NS3+V1Gw=; b=Ri0XvzVgkThkQfeMpLwI6q
	DEbgZADM0DCxI5vnNOrYRoT1xBC61sDmMvi6JPaXd7w5l5Vu202Gr9lX+W+KVnsJ
	RSND5hzyxAdjXX8c90R6/ANAnX8SHHr91X45pTZmoGD9r3TZ29VAaiACmHUlHa71
	izFeRDQfrN93n3OQCwr8rhjQ7sX7M6fJgnvsuZ+JMgkQDfwrF/VjzAsXQB87Esfy
	CqttFPow2fYGAztz3NX+j/huG6F3u/n5l7Ke+5edfBOlQXBWyhkUrJDytORF4MPo
	Yr/Miz73WYsR3XAlpoVsMnUqXSfo44VOEjaLWc2pJBZG9WoLKdTh8M7RMfzp/sUw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1thv83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:04:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEZdg2027268;
	Tue, 16 Sep 2025 17:04:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men4ych-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:04:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GH4C6X52494614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:04:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CAEC620043;
	Tue, 16 Sep 2025 17:04:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 978A520040;
	Tue, 16 Sep 2025 17:04:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 17:04:12 +0000 (GMT)
Date: Tue, 16 Sep 2025 19:04:10 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 09/20] KVM: s390: KVM page table management
 functions: clear and replace
Message-ID: <20250916190410.65a18e34@p-imbrenda>
In-Reply-To: <20250916164731.27229Haa-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-10-imbrenda@linux.ibm.com>
	<20250916164731.27229Haa-hca@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c99891 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=fb4BLzweWxGTFI_-gEIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: j2Rblf-Kys7_R3jslS-AhLz4mqChsz2Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX3C/Cxu6mHTA5
 Aq7lt5eaVarFcBofyfCRHNgf4m9IxTFZXakY8QJ4V8gSriDWFe/5DU1gTE+W8hSUhCWPvsa3phl
 rtrJGLdmHRKotwhtQsz5R2R5zq5wLK5jI+1NGc286iD2aCv+829xn9pWO96FXvedUHx78LIcIT6
 QqWC6DvTo39Em+guTEA1vJJ6uI1Rd6sG+ynzRTxDRB0I7X2257bFu3r2jowmi02voP4jNSLOXJ7
 pQjZqwfZ1zIsGcsQ/NXa62xa6KJ59DAKPomOQCfLUJuodyJls/cYBYMLSQ6gb4NOHUtqQbmuTX5
 /W0Cxh3ojsbzm2ObuhES/ouDmXR0iV8nMdDMVBwldM66gOp3yHBFM3BhooZbtTJUiwDS1/PDH1O
 QgoFjyRT
X-Proofpoint-GUID: j2Rblf-Kys7_R3jslS-AhLz4mqChsz2Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001

On Tue, 16 Sep 2025 18:47:31 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 10, 2025 at 08:07:35PM +0200, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds functions to clear, replace or exchange DAT table
> > entries.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/dat.c | 120 ++++++++++++++++++++++++++++++++++++++++++++
> >  arch/s390/kvm/dat.h |  40 +++++++++++++++
> >  2 files changed, 160 insertions(+)  
> 
> ...
> 
> > +bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
> > +			    union asce asce)
> > +{
> > +	if (old.h.i)
> > +		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
> > +	if (cpu_has_edat2())
> > +		return crdte_crste(crstep, old, new, gfn, asce);
> > +	if (cpu_has_idte())
> > +		return cspg_crste(crstep, old, new);  
> 
> FWIW, CSPG is present if EDAT1 is installed. So this should be
> cpu_has_edat1() instead, I would guess.

no, CSPG is present with the DAT-Enhancement facility (z990), which also
brings IDTE. EDAT1 is more modern (z10)

