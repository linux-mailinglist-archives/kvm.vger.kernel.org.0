Return-Path: <kvm+bounces-48428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CDCACE269
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F3E1722E2
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1171E5714;
	Wed,  4 Jun 2025 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nNoswRFS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0087C1487F6;
	Wed,  4 Jun 2025 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749055747; cv=none; b=PaKPpL+dF8Ul4GWFClyuvoT5uE50KMctcbslEXuXobWJtoZmJjJKPtVjTKlL1HYO/iEVFajmb3AquQsOgFX1YC5tHWy85JdJnWf+Gm4B/T3wE+K0mJW1eOS10nJfJTT/NBviS1b63jSQQGGbtN+X2XmA4+TwAnnZ+azNbMykJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749055747; c=relaxed/simple;
	bh=n11zh9YiiUxBI/UWsmUihybLUSm6s7qq0XhQ8nMz0RY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XbAAuzjB2oTelcLy/PlfYOD8Z5z1chrWU90YRvKFAqHmwVTF3lD+dZXIJAN3hZyNsSrr9U7DgFuWovUver1iHlv4cYJNXHJgFjkAqSmnkIRzwVQXuhtoB3+T76j9A9toCq2SJ1lR/C7dENMAGR76OPeA4Z+CBTFGMzKbcj6Uwhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nNoswRFS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554Cd8Ev029660;
	Wed, 4 Jun 2025 16:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oUOEtN
	vQ8pY/J5z+Im9aP1U/jEGj+Nn/6nZ08QyR1gg=; b=nNoswRFSofGj6jiH1f+Wp2
	vpU6dQkl75KAOnoD25ItFzb3xLveZU5sXvlvwpeox6IbPqqn1a4+LWv+wu8TehmL
	AbR4xbYWUMIGucF/A2v56j83WkcDcUx6tLQwyBpLKg6CkInm9KJqrf/3AxFzky+d
	oLhTFxdHbsoYVY7a/zn9Lsby+yM9IrEHAgiXOlW6IfzP2BuJymMumlgmEjvMxOFu
	YTGJHjWyxxIs35sq1T9b4yFhqJv2omSg+XAr9SI+BC6oY4UCLcypnQvz+FfzGAMa
	ABXYtZrrOh/IbWU98nOzmpsVO0Owo+cCpKCb5EWocnE7ZazUJY87v8xpBZvmmseg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geyv1jh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 16:49:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 554FX1W2019937;
	Wed, 4 Jun 2025 16:49:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3p0r88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 16:49:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 554GmvoO59310456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Jun 2025 16:48:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C395A20043;
	Wed,  4 Jun 2025 16:48:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71DCE20040;
	Wed,  4 Jun 2025 16:48:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Jun 2025 16:48:57 +0000 (GMT)
Date: Wed, 4 Jun 2025 18:48:55 +0200
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
Message-ID: <20250604184855.44793208@p-imbrenda>
In-Reply-To: <aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20250603134936.1314139-1-hca@linux.ibm.com>
	<aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
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
X-Proofpoint-ORIG-GUID: G2iT3uC2J9R6Zm1NoMnzWw990neAQgQs
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=684078ff cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=oF2f3jwwvDOvwd7SqYoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: G2iT3uC2J9R6Zm1NoMnzWw990neAQgQs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEyNiBTYWx0ZWRfXwt/clli9/hF6 +v/8tZHdYnY4AUwQ0xxWArvChe+H33lBTUjgU/+/ePA50Jq3gK6CmRJ5vM4gR7k7NSCN1ME88dt YMbLabE9fQOCzwOwaWToSSWCdBzBSHeWgLl2VRz+beSYYHVibAcEOSXDtM1uKCkdDNUZm7wYJlM
 2Tt037ogMksfnTn1DGlBCh/r0i44a3XB2nJ0VzHR1DVlICtsiwctZEq8WmBm+85nn4+NVpOmtcX ngC/qC0vi9ZNthAADC801UT/jzvwJPaDZiTQclcIcKrsafF00HhUTBGeOy/JtRbjnE+9dianOl6 4on0HEUe1o+8xVxxagc2j0393l+1lXchYp8eRPahHrl90Q6AF3FDlvc00YP10JslOt62vNOcdf4
 u1Mp0EV+IZm/bKw4hbi8AhOV/If59xn74KMm08Q9bnb//KFDLQnWBqBTJEfQJbmAZPMXw2b8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=596 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506040126

On Wed, 4 Jun 2025 18:27:49 +0200
Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> On Tue, Jun 03, 2025 at 03:49:36PM +0200, Heiko Carstens wrote:
> > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > index 3829521450dd..e1ad05bfd28a 100644
> > --- a/arch/s390/mm/fault.c
> > +++ b/arch/s390/mm/fault.c
> > @@ -441,6 +441,8 @@ void do_secure_storage_access(struct pt_regs *regs)
> >  		if (rc)
> >  			BUG();
> >  	} else {
> > +		if (faulthandler_disabled())
> > +			return handle_fault_error_nolock(regs, 0);
> >  
> 
> This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():
> 
> 		if (WARN_ON_ONCE(!si_code))
> 			si_code = SEGV_MAPERR;
> 
> Would this warning be justified in this case (aka user_mode(regs) ==
> true)?

I think so, because if we are in usermode, we should never trigger
faulthandler_disabled()

> 
> >  		mm = current->mm;
> >  		mmap_read_lock(mm);
> >  		vma = find_vma(mm, addr);  


