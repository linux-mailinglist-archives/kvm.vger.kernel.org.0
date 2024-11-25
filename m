Return-Path: <kvm+bounces-32462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1239D8A28
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 17:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B8B228308C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7E41B415C;
	Mon, 25 Nov 2024 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U0dFFbIN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03F839FD9;
	Mon, 25 Nov 2024 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551667; cv=none; b=swgHI/nynY3tSw/X6FoL4pS4cOA4oR3XBa8pWekmRTn9mrmQaSJJaAIX1q0LZBy0ifCXDQDp4KIjJbCx0Rhhmi1SMLBQVoHoejZ4s1fMlKe+2IMkIP5c9f/znj3ZzOtm4CNCVAPrdaCnU3wnQZ+NS3wzUBmm/uOjI0WJUI8ZjQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551667; c=relaxed/simple;
	bh=Y6cPH0FxEJIt2pLccw1ui7BV8R9OG1nXIM6V6oXHVks=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIUJBNZETf5LnUeOE0l7qnDBBemmFSPimHc5RZ+NWjZ/+SXnkpQXj3q4XKbEjcpxacjC901uccBQ47QiiTKL6jADbXs2+/mBZzRIkX8zUWJNRl+ObKZ7vDPppj0fD6zR6OTKolwIvjkIRFblgFfMA8IP4uM2GR+mJRmpZGQC4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U0dFFbIN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4APGC4Dt025893;
	Mon, 25 Nov 2024 16:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XD4azp
	RSiEhRk9eYI8mYqqGg9cLSzJVEFZjAQi8hw44=; b=U0dFFbINifmPXmgBnwiKDK
	8hk7BGAUG6gr36/oecdH5Q9/HUidR0BBreezQc0+oqRU2MDiocK1ZZvB3QmXGhsS
	CEW21C7PyfNjR2lHQVij8Yvl4oQqkCkCajNFrYBLFHaHW43qNw27TAehr0vQk+VU
	ncpYwmmO0VSn3iHK2DBfIPS0IjSWkR2+yJd3R+wP9kq2IP44KtUoxk8gbUAZlj+p
	xG5SZMr9xTNfMITHmFrXkreMT+uq9jiKDqZ0eZpf8uh7LnoHqei4B6P+6v5Rfnp9
	uqoTABayTQo0OntnOQJRBg960YCB58wcFozmSPc63vS173R2p3r59MRtBpiwEiyw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386js5cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 16:21:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4APGFi9s027210;
	Mon, 25 Nov 2024 16:21:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 433ukj2r7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 16:21:02 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APGKwGj39715260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 16:20:58 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CB1B20040;
	Mon, 25 Nov 2024 16:20:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDF0020043;
	Mon, 25 Nov 2024 16:20:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 16:20:57 +0000 (GMT)
Date: Mon, 25 Nov 2024 17:20:55 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: s390: Remove one byte cmpxchg() usage
Message-ID: <20241125172055.08b9ba5b@p-imbrenda>
In-Reply-To: <20241125133755.14417-D-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
	<20241125115039.1809353-3-hca@linux.ibm.com>
	<20241125131617.13be742d@p-imbrenda>
	<20241125133755.14417-D-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 8OrPnBHbdxDD-lz1-R5CCpI2wPXty_6N
X-Proofpoint-GUID: 8OrPnBHbdxDD-lz1-R5CCpI2wPXty_6N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250134

On Mon, 25 Nov 2024 14:37:55 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Mon, Nov 25, 2024 at 01:16:17PM +0100, Claudio Imbrenda wrote:
> > On Mon, 25 Nov 2024 12:50:38 +0100
> > Heiko Carstens <hca@linux.ibm.com> wrote:  
> > > @@ -128,23 +126,16 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
> > >  		struct esca_block *sca = vcpu->kvm->arch.sca;
> > >  		union esca_sigp_ctrl *sigp_ctrl =
> > >  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> > > -		union esca_sigp_ctrl old;
> > >  
> > > -		old = READ_ONCE(*sigp_ctrl);
> > > -		expect = old.value;
> > > -		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
> > > +		WRITE_ONCE(sigp_ctrl->value, 9);  
> > 
> > that's supposed to be a 0, right?  
> 
> Duh... yes, of course. I added the "9" to better find the corresponding
> code in assembly, and obviously forgot to replace it with 0 again.
> Thanks for pointing this out!
> 
> Strange enough this still worked. Hmm.

with that fixed:

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

