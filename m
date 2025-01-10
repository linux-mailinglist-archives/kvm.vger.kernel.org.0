Return-Path: <kvm+bounces-35068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D10D9A098CA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 18:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE11616B095
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 17:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A56213E8A;
	Fri, 10 Jan 2025 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AVP2yzRd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377212F3E;
	Fri, 10 Jan 2025 17:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736531010; cv=none; b=pxJyFFQnMfiYRhtQmPkpnRLba7LtGCB6hXrDxNYlYSSvHpKQdDckAl1CmZQhzLQL+nbDGXYsLa14X6aTcuZ4ZXcH+UuISzZUTej1szz7nuCPMvNnCiuQqX+5nccbBdtwLtkwD5wcF/qpM8ffD5lkJKld8X2Z2/KTKAaMvGxoIsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736531010; c=relaxed/simple;
	bh=bQaNH0Z8kzRAGIlnLYROjZC2icV8aVG+zIPOAEZeBZA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q3Q6SqeJgZXTp5i/G309UNRpHSb82RsjgSWoZEq3RzHcg/LK+6yzH2Yb/dqb6SfsWJtjn6+j2F9/eiEaU1AZoLK9MoaMom0YWURMLD9QuzNTxtTA3BlB4DGnQRnPe68eYRsHciGLmBD5SrDtiZBMaJv9HZitRBKQ4HTsLk7+dfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AVP2yzRd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AG2Vta029127;
	Fri, 10 Jan 2025 17:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=D39The
	kF7dZ96yS7Ke6fVz8cJcnokqRBKWE4tS2XwIE=; b=AVP2yzRdtFEJBoP2vi6all
	iGxznlRRAhJW9TKKMawQhMqf4N86GWTKOGajHbGTHmZ1zysJafmpXNXXBlrq7Ouk
	F2gzAH/B4bjQgQG1xA23AQbiCAZGcWDbL4txOCwMpc8NwDomoYuTBESVqIfroWJE
	1rxtmLusfRvg3QQg2ACzpyf8GtmtXt+ftyDcyRFyzeuuz+9TrhmCYz4KkC2Wytfq
	SM3XVQY4UaQDQzK7besjevfjpzTlfQGLuFjHcSGHTKvSeqh9AbXDbisX+ZoTBiJy
	QMSqK4uAHmuGh+vLxawy1hZpdtKWdz7qYbuavv3WpIKqRGYhd3V14KJZCors0Lbw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442v1q3b3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 17:43:25 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50AHff6l031062;
	Fri, 10 Jan 2025 17:43:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442v1q3b31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 17:43:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50AGIRSa008875;
	Fri, 10 Jan 2025 17:43:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq0bggw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 17:43:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50AHhJ5738928840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 17:43:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 911832004B;
	Fri, 10 Jan 2025 17:43:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CFF020040;
	Fri, 10 Jan 2025 17:43:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 17:43:19 +0000 (GMT)
Date: Fri, 10 Jan 2025 18:43:17 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
Message-ID: <20250110184317.1a2a93c8@p-imbrenda>
In-Reply-To: <Z4FaOW3-hen3nIpF@google.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
	<20250108181451.74383-3-imbrenda@linux.ibm.com>
	<12a4155f-9d09-4af9-8556-ba32f7f639e6@de.ibm.com>
	<20250110124705.74db01be@p-imbrenda>
	<Z4FJNJ3UND8LSJZz@google.com>
	<20250110180225.06dfba3c@p-imbrenda>
	<Z4FaOW3-hen3nIpF@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rdfkGp7nkG1Hr35CUI3TmaZMWYOla_iM
X-Proofpoint-ORIG-GUID: faG1O3hllL5i6ZlrxaX2OpcA6halR2aH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=456
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501100136

On Fri, 10 Jan 2025 09:34:49 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Jan 10, 2025, Claudio Imbrenda wrote:
> > On Fri, 10 Jan 2025 08:22:12 -0800
> > Sean Christopherson <seanjc@google.com> wrote:  
> > > AFAIK, that limitation exists purely because of dirty bitmaps.  IIUC, these "fake"
> > > memslots are not intended to be visible to userspace, or at the very least don't
> > > *need* to be visible to userspace.
> > > 
> > > Assuming that's true, they/it can/should be KVM-internal memslots, and those
> > > should never be dirty-logged.  x86 allocates metadata based on slot size, so in
> > > practice creating a mega-slot will never succeed on x86, but the only size
> > > limitation I see in s390 is on arch.mem_limit, but for ucontrol that's set to -1ull,
> > > i.e. is a non-issue.
> > > 
> > > I have a series (that I need to refresh) to provide a dedicated API for creating
> > > internal memslots, and to also enforce that flags == 0 for internal memslots,
> > > i.e. to enforce that dirty logging is never enabled (see Link below).  With that
> > > I mind, I can't think of any reason to disallow a 0 => TASK_SIZE memslot so long
> > > as it's KVM-defined.
> > > 
> > > Using a single memslot would hopefully allow s390 to unconditionally carve out a
> > > KVM-internal memslot, i.e. not have to condition the logic on the type of VM.  E.g.  
> > 
> > yes, I would love that
> > 
> > the reason why I did not use internal memslots is that I would have
> > potentially needed *all* the memslots for ucontrol, and instead of
> > reserving, say, half of all memslots, I decided to have them
> > user-visible, which is hack I honestly don't like.
> > 
> > do you think you can refresh the series before the upcoming merge
> > window?  
> 
> Ya, I'll refresh it today, and then I can apply it early next week and provide

excellent, thanks!

> an immutable topic branch/tag.
> 
> My thought is to have you carry the below in the s390 series though, as I don't

sure

> have a way to properly test it, and I'd prefer to avoid having to do a revert on
> the off chance removing the limit doesn't work for ucontrol.

makes sense, yes

