Return-Path: <kvm+bounces-48434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3431ACE3CB
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 19:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7EC8174347
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F308A1FBC8C;
	Wed,  4 Jun 2025 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dk8xZkiJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA921C6FF9;
	Wed,  4 Jun 2025 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749058859; cv=none; b=g5fE2LgCSt/qUvsx0temb/AlunQH0viJMZ8nbDxi/WUWkCIIdj8tjPGCwCKxcNbFcPEobxDaS04vIH5ORPq7BR/SWtqUReKyCfI+oHtQ6udAvxfC4eb994Ngsb586wZ4pJK4q7kbR7B9ixwBjRj30vDBNPNlBm6WWQnjyZqvp4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749058859; c=relaxed/simple;
	bh=Nra+dhh/un1enXJEwkzf8yVfu9/3bzI8NXWu4QqUfK4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kptpKEVPfCZ6rsN9Fdm4azGhCOqeEoOacovKvniffvRbicDSz87HloVveovBelXmIwIVvwhAdUyCXWAqG0W4T6YR5taUx6mziPYwcrBmjqBQ2FJ5DiqQJSMuWJ9A3IO1750XhyxvWaJitVh0Uj4zGBRQLb24xtCqogFqB14uKWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dk8xZkiJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554CwnTp030628;
	Wed, 4 Jun 2025 17:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=D9zGtM
	OPnxfjJ4yT2VnaaZ7E7CBv4whP5dz2XV+hYzU=; b=dk8xZkiJSbKp+LtXEjRsn3
	FVrjTcdayz/b9pWby3W4TKSPCyu0z/ZFLtjZkjQ71sUc/li8ZL1HVrCYyXbPzdNQ
	urhWjv+Og1aGXCv+91QO81+0vRMUSuUMbJPznJqje5oz+CsF9fOw2IKnzQy40PXx
	N6ZTVff4YhefMXKXHpfIyWgMGpPx3F1cxdi6+dGF6n396fFTaeyi232YlA724Vxc
	JGn3piEGStSUicHft8+gTgL+HTYHOoN5qEVCwOyPAw/FOXHkDqfvIqNOL2sjDs52
	IBDP4H5Sg3W2eGflrx5cFPEwad9xbI0hZ1yqzOb0pEVn01elLBWEkAlUln3GB7Qw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyv92x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 17:40:54 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 554FcGnP019873;
	Wed, 4 Jun 2025 17:40:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3p0xms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 17:40:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 554HenXC52822356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Jun 2025 17:40:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDE5220049;
	Wed,  4 Jun 2025 17:40:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D61920040;
	Wed,  4 Jun 2025 17:40:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Jun 2025 17:40:49 +0000 (GMT)
Date: Wed, 4 Jun 2025 19:40:43 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
Message-ID: <20250604194043.0ab9535e@p-imbrenda>
In-Reply-To: <aECCe9bIZORv+yef@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250603134936.1314139-1-hca@linux.ibm.com>
	<aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
	<20250604184855.44793208@p-imbrenda>
	<aECCe9bIZORv+yef@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
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
X-Proofpoint-ORIG-GUID: E8Ar--Ui4USO9h2xLhi8XWWMb6GPSt8g
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=68408527 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=fv93bDPwWRkgOFLX7wEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: E8Ar--Ui4USO9h2xLhi8XWWMb6GPSt8g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEzNiBTYWx0ZWRfXxGsxVqSlpPK8 5rbqT+A3sNsv1EtGSqkvdaaGQt0CKbjQx8HWrGDDlQ5TCHeYig2aQyfJ5F+uPsJl1xqYLViFYiI R0Y6WRTq4t4nh+9tI0B7hWlhQSWnbP7ARl+l6iR7yVIQtEQVf8T+JKC2KKVsqWYWnc3SXdZWX0i
 bFOJarIYX8RCm4bhm00GdBPUZ3/F+OMmOB/R1Ieotq0XxpZKJN4hSvO5BSk7mXuL1bBnNzP079R 6CAQqEU9AftXcDKLgWLcvrFFm4jpCp1ESMR3/9fpQyhdaLl9gvmHIB2dbTei4E6N8/5ykadYcwg xpawsqmoa/VWX3gKFq1ZahuEcqcrk+oEwrgYLaU/S1L12Sh4LyUpW1ZTOfiULgsmm6ChoeAXk+c
 vV2tGi960Ilt3rZWPVNswt51Yry9DHTX/4UBbhQRWi30rKE3cxCaz0Q1ABTugctIpD1+pZEI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_04,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=696 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506040136

On Wed, 4 Jun 2025 19:29:31 +0200
Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> On Wed, Jun 04, 2025 at 06:48:55PM +0200, Claudio Imbrenda wrote:
> > > > @@ -441,6 +441,8 @@ void do_secure_storage_access(struct pt_regs *regs)
> > > >  		if (rc)
> > > >  			BUG();
> > > >  	} else {
> > > > +		if (faulthandler_disabled())
> > > > +			return handle_fault_error_nolock(regs, 0);
> > > >    
> > > 
> > > This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():
> > > 
> > > 		if (WARN_ON_ONCE(!si_code))
> > > 			si_code = SEGV_MAPERR;
> > > 
> > > Would this warning be justified in this case (aka user_mode(regs) ==
> > > true)?  
> > 
> > I think so, because if we are in usermode, we should never trigger
> > faulthandler_disabled()  
> 
> I think I do not get you. We are in a system call and also in_atomic(),
> so faulthandler_disabled() is true and handle_fault_error_nolock(regs, 0)
> is called (above).

what is the psw in regs?
is it not the one that was being used when the exception was triggered?

> 
> >   
> > >   
> > > >  		mm = current->mm;
> > > >  		mmap_read_lock(mm);
> > > >  		vma = find_vma(mm, addr);    


