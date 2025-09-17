Return-Path: <kvm+bounces-57899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96284B7FADF
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EB84520E42
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDC12236F3;
	Wed, 17 Sep 2025 14:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XjFCmkcw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396C31E3DF2;
	Wed, 17 Sep 2025 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758117662; cv=none; b=sZHSF1vNDqikgcaAA+Q1hMsZJqH/eRH11yZfsAi1uo9aik5QZVnjXGXmf2lV1aXWt3C2pmURDTSKbRKStkZTaeygrebno9+GwOpF/SbkwGpvvxerE6QrqTjJzeBZFCB7SU8sqYqbmOqQ6iIYcQQWwdkqvVgBrVcoB1U3mZWW1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758117662; c=relaxed/simple;
	bh=azzLCuqcdnLI2hAXtjixF/ePNoHHZIQuA0HYlCSDjZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbkA8dt7Mcw05wZkVQa8fewf9khxc3hQKc3doR0u1bSKOJrtKlUxsYUANRyP7/3a2aa0Z9TMwu7L/oelAkwkcTpxz6zwJD8JBi8wcKW0lnt/9tH5NgSHUoo8Mqk8ghZQ8ZxS9U0XsjtEYDgrt9YZfnLvfljOFoq0lDwoM4DrPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XjFCmkcw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAG7aR023772;
	Wed, 17 Sep 2025 14:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2vOkKa
	7Igaka8ox18ViXsgLjdbj/N9zXAcfYdRrA1jY=; b=XjFCmkcwiAXGVN3me4N7t7
	ka98za7Z5K2Iyq3V1k6/v+i5Uhaejr8pxBp86gSxWiFZfw5eJvdFeLlQYa5z9KOx
	EixpRBZbnd2zmZC7mprPqJ97tYRtRAKDt6FZRS5ySDtdXTSsIiK8A6JrEl+nf4nP
	xvGc86bwpjR9lykMlym9gOvCwMqflxlQLtsvtu2NR2rYL2f7VujRLihhIqdevYbK
	PXyIV4KJmfOiUZmJZms5Rvh1GwrUejDT+4TysRccnncrGWZybtxsy8apZiFJSesX
	TFir+V8UeGppJXPlqNyRCkzh+svAbX9LlcV1B4Mgi6LJEbkaZ5BU8yIJpWc67NHw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qkwhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:00:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDbAS1005940;
	Wed, 17 Sep 2025 14:00:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu9sje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:00:57 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HE0rVw26739452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:00:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9E7620040;
	Wed, 17 Sep 2025 14:00:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71F3E20043;
	Wed, 17 Sep 2025 14:00:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:00:53 +0000 (GMT)
Date: Wed, 17 Sep 2025 16:00:51 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250917160051.660132d2@p-imbrenda>
In-Reply-To: <20250917133142.29680A26-hca@linux.ibm.com>
References: <20250916162653.27229G04-hca@linux.ibm.com>
	<20250916184737.47224f56@p-imbrenda>
	<63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
	<20250916190514.1a3082bd@p-imbrenda>
	<15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
	<20250916173644.27229Kcc-hca@linux.ibm.com>
	<20250917072733.7515Af5-hca@linux.ibm.com>
	<20250917132556.4814fe98@p-imbrenda>
	<20250917123006.7515C59-hca@linux.ibm.com>
	<20250917151124.1a53b0a6@p-imbrenda>
	<20250917133142.29680A26-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: PpeZMaTWWbU7rwvTqgyvmKFhxmEBjwEJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX955plsq4Ekgo
 cA0ywNqsnR7KbXkjo/yQCGvyt3CkkFHn86Q0UK7Hs6ldFa3NIfqIQ7x/KUJsKn05YeGumae/sgB
 o30Fxfe+njQDKl4mDbJ3ExMz7WPdGgcQYII8emhQRdPTp7x3FoRz5FkbojfCtLdDVdvM32ebUsE
 LPzawvcq1o3YqwVSEUafK8KCNAmz+0xqM79VPuqy/aoQuJXKPFdAGCIZe7tj7efq10kgqv4tFGq
 5QaSUr50tOtBmxe5W7dzhGdN9bj+gme5nJQe9KbKWKoVS8+I8AgsmdFyJ2wI8j+5zBqAkPMrv0H
 joDfdxggfofml2+SJtPIugdRkhGr6rdTjA1Clmr/1IrTzOw8a+A51hG5slP4WRHwfsnnkZTa0Y6
 vT8z24pD
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cabf1a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=kyO4UC6tb7BDS9PUmFAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: PpeZMaTWWbU7rwvTqgyvmKFhxmEBjwEJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, 17 Sep 2025 15:31:42 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Sep 17, 2025 at 03:11:24PM +0200, Claudio Imbrenda wrote:
> > On Wed, 17 Sep 2025 14:30:06 +0200
> > Heiko Carstens <hca@linux.ibm.com> wrote:  
> > > > > > > No. ATOMIC always means: can fail.     
> > > > 
> > > > my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
> > > > called from atomic contexts (e.g. while holding spinlocks)
> > > > 
> > > > the right way to do this would be with mempools, to allocate memory
> > > > (and potentially sleep) when we are not in atomic context, and use it
> > > > whenever needed. this is on my to-do list for the future, but right now
> > > > I'd like to avoid having to refactor a ton of code.    
> > > 
> > > I doubt this is accetable even for an intermediate solution. As soon
> > > as the host is under memory pressure and starts doing I/O to free up
> > > memory, you will end up in -ENOMEM situations for simple guest page
> > > allocations.
> > > 
> > > What happens with a guest in such a situation? Is this gracefully
> > > handled without that the guest is terminated?  
> > 
> > well, we return -ENOMEM to userspace (and qemu will probably kill the
> > guest)
> > 
> > but if we can't even allocate 16kB, probably we're already in a pretty
> > bad situation  
> 
> Not necessarily...
> 
> > if you think this is not acceptable, I guess I'll have to implement
> > mempools  
> 
> ...since the kernel _might_ be easily capable of freeing memory, e.g. by
> writing to swap or writing file contents to disk. But this wouldn't happen
> with GFP_ATOMIC allocations.
> 
> I'm just stating that with GFP_ATOMIC for guest page table allocations it is
> much more likely that guests might be killed compared to what we have now.
> 
> Also I'm wondering why such code paths where page tables in atomic context
> need to be allocated even exist. Is that s390 specific (aka the new code), or
> is this due to common code requirements?

this is in the gmap rewrite, so new code in this series

mempools it is, then

