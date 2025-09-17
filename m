Return-Path: <kvm+bounces-57841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B5EB7C702
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40263325A69
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 11:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66255323F68;
	Wed, 17 Sep 2025 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kUh9hWe5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8A929BD91;
	Wed, 17 Sep 2025 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758108374; cv=none; b=eltqSJeyHJRVJ4gSTV8gLFd96q14RNtwfT/dvKscarvLA6HBq/awi/WShlhWx7GOSSA4m1kgIn9+BKvNRzCZ1jfKRPqmEF/mKXnjasw0HDsNoDRtXVYfHeEo12D82SGtQ2iBr/+NDuMrAgn0jtAHyD1goRmQNRB79uNw4SQBToU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758108374; c=relaxed/simple;
	bh=x02QU9lvhSASYDW0bLRH+ICU86+8pHmFzOX6JCElmD4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zeveku1CBCGToUoI9M54eUsr3XvAww2CHO1kVqRau9MLJxDPg+aHcuupY2zNJ5+oGJx+Wqnq4MEOWJfH8HFe92rb2UT70IfwPiTTslUQszRoW/AvVrvxh6woLky4F9P2b4Nhx1wLLnAKBzi8ghvNkivC59AHps8jFTN7IDPiI+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kUh9hWe5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H91W24010975;
	Wed, 17 Sep 2025 11:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Car/5l
	IIPcqjsVkyPxygl3Z5uJcpO3FbjoTj6jJcOMI=; b=kUh9hWe5rngZWwHHdbkRI6
	s8usGtjc0kqVY+ojKVTDueVky08HomgxIejDk0OSc1MsQ1FqUjOtOjKY5Onm/6fC
	d87mDrPhX04EkDRq9wtJp1Qoomi1hUlBzhlmvXYv2jekzsRT5rl5y2HgohytUiGp
	RmlsjxAAy3dgKkvxtaK8ll+F5mYGJzROXxITOWEppqJ9LKNU8TLOJam6IgHqldxd
	gm8+NVTgCLaRRA+7m3n26VmwjNMxZBA4/O0IfNnv4hxfhmNcMrgga5NhHWrmjnWy
	GGSp8x5p8O2D6//oFHMA4dwXRXIvB5K6VM9l04rvIcF+dXiDnl3cFPKOfrzBldFA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nb4d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 11:26:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58H7Z5kw018649;
	Wed, 17 Sep 2025 11:26:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mgr2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 11:26:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HBQ4dW47907196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 11:26:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EF9020043;
	Wed, 17 Sep 2025 11:26:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 073CD20040;
	Wed, 17 Sep 2025 11:26:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 11:26:03 +0000 (GMT)
Date: Wed, 17 Sep 2025 13:14:56 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management
 functions: walks
Message-ID: <20250917131456.35a54435@p-imbrenda>
In-Reply-To: <20250916172433.27229I76-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-11-imbrenda@linux.ibm.com>
	<20250916162203.27229F62-hca@linux.ibm.com>
	<20250916184852.50ab6a67@p-imbrenda>
	<20250916172433.27229I76-hca@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68ca9ad0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=5iT_p6bwntt-X9io5a8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: CN_7v2pEpqYJTmXlkkacktS_sAF-XJLH
X-Proofpoint-ORIG-GUID: CN_7v2pEpqYJTmXlkkacktS_sAF-XJLH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXzq3jfOF9sg3Q
 3xVNrbxWI5XPWECo3v/YoEauHD+dvhlC/xOtnch6RhhtgUCiQ482hbjQjz69du4+GthgsdehSPE
 9EA5Y1Jb7Zi8/4yDBETa+lzfwrr7GO9bee9K05DT5nFI90XA9TqPYmM91LpnzKx+3OQ1MMStzqs
 l0HZk1DprfOju9Ns4Lq6I4uAQzdBzjOPzsU3FqtRRX8KlGXiLQnDR4shjlGYql5Y1GkonMd3HFi
 8v0Xv/f1i9uocIvkzNk+yD0fbsreZNWHL7LZrFdm55dlp7Sal9LSQ71MLB2Cem4sst3IGIMtkC4
 lMmmf+3fJeSEDYWTk4JN6HkjUNoCrPzAsupFDMuOjSB03EbwiiwFSVJsmpWh+TdsVNxchOAB12t
 umE9I1i4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Tue, 16 Sep 2025 19:24:33 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Sep 16, 2025 at 06:48:52PM +0200, Claudio Imbrenda wrote:
> > On Tue, 16 Sep 2025 18:22:03 +0200
> > Heiko Carstens <hca@linux.ibm.com> wrote:  
> > > > +	table = dereference_asce(asce);
> > > > +	if (asce.dt >= ASCE_TYPE_REGION1) {
> > > > +		*last = table->crstes + pgd_index(gfn_to_gpa(gfn));
> > > > +		entry = READ_ONCE(**last);
> > > > +		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))
> > > > +			return -EINVAL;    
> > > 
> > > Since I've seen this all over the place: this looks just wrong to me.
> > > 
> > > This is mixing some random software definition "LEVEL_PGD" with hardware
> > > bits. A "correct" table type compare would compare with TABLE_TYPE_REGION1  
> > 
> > they are defined to be the same for this reason, but I understand what
> > you mean, and I can use the TABLE_TYPE_* macros instead  
> 
> Yes, please.
> 
> >   
> > > instead. Also using pgd_index() & friends here is semantically wrong.  
> > 
> > how so? in the end all the various p?d_index() macros are just a
> > shift-and-mask. I think it's more readable than open coding
> > ((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1)) each time?  
> 
> I'm not saying that this code is incorrect. What I'm complaining about
> is that this is mixing hardware and software definitions all over the
> place, which at least to me is very confusing. But ok, maybe I'm the
> only one.
> 
> So e.g. for the above, which operates with a region 1 table entry, I
> would expect to see similar code like in gaccess.c. E.g. _something_
> like (and most likely incorrect):
> 
> 	table = dereference_asce(asce);
> 	if (asce.dt >= ASCE_TYPE_REGION1) {
> 		union vaddress vaddr = {.addr = gfn_to_gpa(gfn)};

hmm, that doesn't look ugly

maybe I can even add one more anonymous struct in vaddr, so that the
gfn can be assigned directly: union vaddress vaddr = { .gfn = gfn };

> 
> 		*last = table->crstes + vaddr.rfx;
> 		entry = READ_ONCE(**last);
> 		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION1))
> 			return -EINVAL;  
> 
> Or in other words, this doesn't mix hw vs sw functions. Anyway, just
> my 0.02 cents. If you disagree feel free to keep it.
> You have to maintain this :)
> 
> Btw.: WARN_ON_ONCE() has a builtin unlikely(), please don't add
> unlikely again like above:
> 
> 		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))

oh, right, I'll fix that

