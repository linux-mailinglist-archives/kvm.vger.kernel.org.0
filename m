Return-Path: <kvm+bounces-20144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E664910E73
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAB2B1F22EA4
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11C31B3F27;
	Thu, 20 Jun 2024 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nUVi1/kI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252521AD3E9;
	Thu, 20 Jun 2024 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904388; cv=none; b=QzbSTUGebxHv7wf2PpqxjQMw64E3rzpW+wGiBM9eM6b4WWGETGcPSMvzHJmiII5trRvEgInljtvAZTMSQQwWitaA8rtb0GSaI02Brt5R8sNbABdTKEYWn4YIwVhryf5oBt5m4+XaPU0WZTymcozq2PWIcD16jj5J9KaZfv3HxD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904388; c=relaxed/simple;
	bh=m28aa9YC/O+unu54a9xBp/7LjExBqVA0mY45dMFhR24=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ho0+ke2DC04pjX2hJqNzUi0r9kuPWOglJeTK+cdSwzciJnlzLNI2Ya2KyR6cCcP5hMGZSX2xFWPvlZDQ86gwu5MnFnLrO8JTFSPJfT9ymEvDvv8U1Nd6VDiDOFu1GwJAmHokNyVykpK9JiCgXRKnXBh+xPyPMNC/9n+xjaUCEVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nUVi1/kI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHOkin029880;
	Thu, 20 Jun 2024 17:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	TWjqmNlQaJFKmNzSqD5rCrlHu6ewIsHQFG3F+jO6g4U=; b=nUVi1/kIKXDlW4h9
	UO3A05R0Ta0Vdj+nuX77n8IxTWWWbOsjX9V4ROY7Ns46qB+on6BwWxS8SIsJhOUs
	cCY41QJzkeJTgXGmq64vjDub51han1Hj2TGS2EybWpeDU6koutRvxnRbbrcBAFhw
	CVtvauOh57GEtgTYziLWxioNvHKwlAsR3aVZAgYNpd8yojD99uZ27lXfvXqCbvhU
	b4+Rxk9+FCoUlj4GPz+LsV1fLYK4TE6OBvHjVfzG6tv6TeW46PcDChsO0tJhXr4P
	WczI+T5Y1IBU4cN8gZslTB6xmUnodAS+x+TTgnJqX5I96wAE6p/dM0p8X5i2lBgu
	qGD74Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrt4003e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:26:23 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KHQMsW031053;
	Thu, 20 Jun 2024 17:26:23 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrt4003c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:26:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHJl69025658;
	Thu, 20 Jun 2024 17:26:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yvrqv01fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:26:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KHQGWg51511650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:26:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E66F20043;
	Thu, 20 Jun 2024 17:26:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5CB620040;
	Thu, 20 Jun 2024 17:26:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.47.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 20 Jun 2024 17:26:15 +0000 (GMT)
Date: Thu, 20 Jun 2024 19:26:14 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>,
        Nico =?UTF-8?B?QsO2aHI=?=
 <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        David
 Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
Message-ID: <20240620192614.08ff9c65@p-imbrenda>
In-Reply-To: <c5e1cccdd7619f280d58b2ef00c076d5426e764b.camel@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-6-nsg@linux.ibm.com>
	<20240620185544.4f587685@p-imbrenda>
	<c5e1cccdd7619f280d58b2ef00c076d5426e764b.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iY_G5KuM0dylQDS_VE7u2YpGYcLmK8rx
X-Proofpoint-ORIG-GUID: ZXFlTlqzdjBv7cRix1HtoInOzIRR-oe4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=857 bulkscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406200126

On Thu, 20 Jun 2024 19:16:05 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Thu, 2024-06-20 at 18:55 +0200, Claudio Imbrenda wrote:
> > On Thu, 20 Jun 2024 16:16:58 +0200
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >   
> > > It is useful to be able to force an exit to the host from the snippet,
> > > as well as do so while returning a value.
> > > Add this functionality, also add helper functions for the host to check
> > > for an exit and get or check the value.
> > > Use diag 0x44 and 0x9c for this.
> > > Add a guest specific snippet header file and rename snippet.h to reflect
> > > that it is host specific.
> > > 
> > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>  
> > 
> > 
> > [...]
> > 
> >   
> > > +static inline void diag44(void)
> > > +{
> > > +	asm volatile("diag	0,0,0x44\n");
> > > +}
> > > +
> > > +static inline void diag9c(uint64_t val)
> > > +{
> > > +	asm volatile("diag	%[val],0,0x9c\n"
> > > +		:
> > > +		: [val] "d"(val)
> > > +	);
> > > +}
> > > +
> > >  #endif  
> > 
> > [...]
> >   
> > > +static inline void force_exit(void)
> > > +{
> > > +	diag44();
> > > +	mb(); /* allow host to modify guest memory */
> > > +}
> > > +
> > > +static inline void force_exit_value(uint64_t val)
> > > +{
> > > +	diag9c(val);
> > > +	mb(); /* allow host to modify guest memory */
> > > +}  
> > 
> > why not adding "memory" to the clobbers of the inline asm? (not a big
> > deal, I'm just curious if there is a specific reason for an explicit
> > mb())  
> 
> Mostly a matter of taste I guess.
> The diag functions are just convenience wrappers, doing nothing but
> executing the diag.
> force_exit is a protocol between the host and guest that uses the diags
> and adds additional semantics on top.
> In theory you could have other use cases where the diags are just a timeslice yield.

fair enough

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> > 
> > 
> > [...]  
> 


