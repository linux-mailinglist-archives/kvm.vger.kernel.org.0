Return-Path: <kvm+bounces-57764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E41B59EC4
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8021616FB26
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D245A2F5A31;
	Tue, 16 Sep 2025 17:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LVDR62Hc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373BA2F5A02;
	Tue, 16 Sep 2025 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758042325; cv=none; b=o2Gu6JunzDgM4fFamyrDmuQEZrTlhcRiIaGa9huctYHyP17mvZGmhRNVRWcpuyQyqYejD9jNdDZUrkc7aQN+LDtCoTX37H4oCa59yfTZ9WQkykS1DBHHZFuxGyn90WsGX83RFEKMn5aRai+lQtS5PlQP35GYJSoLZwbwT2mcfUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758042325; c=relaxed/simple;
	bh=KnapNWGWaW/jvi400bahDIt8w75l0Qh3YuiA31uxDqw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hf7PvYo4++EmWUvdo9ZhCGewt4Fnfx1g5kV7nDHTOG+fwubrZGVX9nAr7fqm80SUSVG545Bagoc8PmoR6NCruEWWzD7IKidJDOHzZCQk2wc2iDVRRhvBKjvL8vxI24dttl7lB3dCq4V56TkcSl95k+RA2HKtyAM8xQ/OhgIrHLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LVDR62Hc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GAaG4a024205;
	Tue, 16 Sep 2025 17:05:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+lvmYI
	o997TBU95pQ6E6RKn7wQwZoAMZuqYSRlStR5I=; b=LVDR62HcV1s8gcMdYR2M76
	WDl8WVc1jtOYyPiMuhlBacsie8KFnDsh+u9wvAMb82rf0VVFczEoXRXiEwvQPjqH
	RXRDbo/dcNposxoUVuGRZ1b2kS0lrZCiL6m45NkQuX0o0W9kEaDS6Cuo5oPn3spR
	JHcKKN0VcMueCM28YFxPJ6C6fbAMOYwusYqTMZpDT/NvAqSYWzHOvJCwlh7N4H1N
	Dw3+q5rpxmYwxMUU/N0LaST8CY2fofd4JnXWQl099nobpS2QFXpTuz7mobFcWM4T
	u40K4P6/q1iyGrRJYkBseNeCAL6eGeK1H51vUWfmxOJw6QtQmgcs1F/fGL51hHLg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1thvdk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:05:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GE2TqB029484;
	Tue, 16 Sep 2025 17:05:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb0w75q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:05:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GH5GwJ55640424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:05:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B93DE20040;
	Tue, 16 Sep 2025 17:05:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77DF920043;
	Tue, 16 Sep 2025 17:05:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 17:05:16 +0000 (GMT)
Date: Tue, 16 Sep 2025 19:05:14 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250916190514.1a3082bd@p-imbrenda>
In-Reply-To: <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-9-imbrenda@linux.ibm.com>
	<20250916162653.27229G04-hca@linux.ibm.com>
	<20250916184737.47224f56@p-imbrenda>
	<63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c998d1 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=h2EQvK93Wfzv042FzokA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: mMaDog7l-2Cxg68I7DmOygu5u2vKtwFy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfXwfbeAD/L8YLK
 ZaUq92u6Cdc+FIt7KSD55Zhj7LX6JlkkwVJTss8uj/ZRPqdvP2a8QZPv86tnjLDscRmFw6Y86hJ
 aDqiRrUwvfLXdFUinGvKpzHIkrX/I3skjOSyquW+Gf0/6fNoJaYKLfI4FdeyGZMh7IE/EPeZkrc
 GzJT1Vy4fONC5mjMJLkDJSjA9LCRAeijtoI5c4PmNjMENhmY8biBN0U1nVxXdg0zkSv8Sp8C4fv
 O3UysVLbFeI/a3d/Ct5V/lO4nRax4hWM1IpkTHeBzKN5fi5mM1OTdIpKEEsSt6OSOrrSAIQ+CeU
 aJkM+qngknv9njRKIt1+ayxx8Izeuxue/vShPZNxUVkXvDsctI5y6MqTTj9ymKqNl5dFzpRVMUg
 yZBpdFRn
X-Proofpoint-GUID: mMaDog7l-2Cxg68I7DmOygu5u2vKtwFy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001

On Tue, 16 Sep 2025 19:01:11 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 16.09.25 um 18:47 schrieb Claudio Imbrenda:
> > On Tue, 16 Sep 2025 18:26:53 +0200
> > Heiko Carstens <hca@linux.ibm.com> wrote:
> >   
> >> On Wed, Sep 10, 2025 at 08:07:34PM +0200, Claudio Imbrenda wrote:  
> >>> Add page table management functions to be used for KVM guest (gmap)
> >>> page tables.
> >>>
> >>> This patch adds the boilerplate and functions for the allocation and
> >>> deallocation of DAT tables.
> >>>
> >>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>> ---
> >>>   arch/s390/kvm/Makefile     |  1 +
> >>>   arch/s390/kvm/dat.c        | 91 ++++++++++++++++++++++++++++++++++++++
> >>>   arch/s390/kvm/dat.h        |  4 ++
> >>>   arch/s390/mm/page-states.c |  1 +
> >>>   4 files changed, 97 insertions(+)
> >>>   create mode 100644 arch/s390/kvm/dat.c  
> >>
> >> ...
> >>  
> >>> +static inline struct page_table *dat_alloc_pt_noinit(void)
> >>> +{
> >>> +	struct page *page;
> >>> +	void *virt;
> >>> +
> >>> +	page = alloc_pages(GFP_ATOMIC, 0);
> >>> +	if (!page)
> >>> +		return NULL;
> >>> +
> >>> +	virt = page_to_virt(page);
> >>> +	__arch_set_page_dat(virt, 1);
> >>> +	return virt;
> >>> +}  
> >>
> >> Is GFP_ATOMIC a typo, and this should have been GFP_KERNEL?
> >>
> >> Otherwise I would guess this will cause problems in the future when
> >> under memory pressure allocating guest page tables fails easily,
> >> while before this change such allocations never failed.  
> > 
> > how so? the documentation in gfp_types.h says:
> > 
> >   * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
> >   * watermark is applied to allow access to "atomic reserves".
> >   * The current implementation doesn't support NMI and few other strict
> >   * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
> >   *
> >   * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
> >   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
> > 
> > 
> > I think GFP_ATOMIC actually gives more guarantees?  
> 
> In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> are usually the atomic ones.

interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?

