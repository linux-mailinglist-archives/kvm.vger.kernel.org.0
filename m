Return-Path: <kvm+bounces-37480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E722A2A80A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 13:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A47F83A7308
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 12:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2044222A7EC;
	Thu,  6 Feb 2025 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="co4huC0u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F9018B477;
	Thu,  6 Feb 2025 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843426; cv=none; b=hvsiTH/NCrU6PAUQmVEoSfigKLPNLAJ2hor+ebGnUBK1oV7S/tPe08SNg1ji9CWvnOeFOj0ArchwEa/80/FVm6CiV1AUc4R1H96cQPb24ty2KPFagGope8p7yHPCsK8BUqwIwSWkMukViPx6a44K/rYu6ZorOp7oq9G0MjVdlOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843426; c=relaxed/simple;
	bh=DkL/J8OelMq3ysHswe2cZ8xwp7wXkkrh1lW04WJW0jI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3Ni33i+2nqMLACQagE2D/YkiRJB/Pt+SZqW93Vu04wPv62H9CuCJnk2HR3imgHR1JVlQCTQ95eOhi9swNjosYO30fItKanvVq6BZEx3+y56+yYmgLqEPTqa5R/ubDWyoLz3cWmvlKDPv+JySQ427RWIYUPUTRCx5qH87BY6T00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=co4huC0u; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5162TirJ024293;
	Thu, 6 Feb 2025 12:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RRA60P
	YnwrknuTL5j2jm0OMQ6zaXGkKfbQtfGN3XfDE=; b=co4huC0uwSdkkDjuDxjet7
	Q1iLu5oh/gcLzpQY7fAJsKn8Gi6irp5BeCtNpHwVZSG/Xu6XWVzq2SPRXBql5Hyh
	6o79wl6zGMu2Ht8q5ODuvDSrs8dslmc2mlCCBkzB7LudFdMsddkdrWAzfAfLzkuU
	JgVDg5mHo8kv03wpYIhS2iIIkamLuY6K28KwpNGIcZloUhlh2EXt7O7gHt1ejTh1
	37u/pTJNw12kU3BVyXp0OSUbLC/u+2Pm14uotI69ph/h2Exy1CdEJqtszbnCH+oH
	WDCQ7KEOsCRYzQtTDLUKRtAL5/Y+e/R6ahQZIfczbYaBfc2FrAPebZrqgDL4hGug
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mattdauu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 12:03:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516Au6XZ024635;
	Thu, 6 Feb 2025 12:03:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxne7yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 12:03:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516C3b0920447642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 12:03:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C183320192;
	Thu,  6 Feb 2025 12:03:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70A2920193;
	Thu,  6 Feb 2025 12:03:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.19.151])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  6 Feb 2025 12:03:37 +0000 (GMT)
Date: Thu, 6 Feb 2025 13:03:35 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        hca@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] lib: s390x: css: Name inline assembly
 arguments and clean them up
Message-ID: <20250206130335.6b0a4809@p-imbrenda>
In-Reply-To: <97262c67-b04e-4015-a081-f1024e8a31a2@linux.ibm.com>
References: <20250204100339.28158-1-frankja@linux.ibm.com>
	<20250205112550.45a6b2cd@p-imbrenda>
	<97262c67-b04e-4015-a081-f1024e8a31a2@linux.ibm.com>
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
X-Proofpoint-GUID: GbaE4BcpBzB9f7HrK7IaseiHjc4DU66r
X-Proofpoint-ORIG-GUID: GbaE4BcpBzB9f7HrK7IaseiHjc4DU66r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060100

On Thu, 6 Feb 2025 11:36:11 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/5/25 11:25 AM, Claudio Imbrenda wrote:
> > On Tue,  4 Feb 2025 09:51:33 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> Less need to count the operands makes the code easier to read.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>
> >> This one has been gathering dust for a while.
> >> rfc->v1: Moved to Q constraint (thanks Heiko)
> >>
> >> ---  
> > 
> > [...]
> >   
> >>   	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
> >> -		     " ipm     %0\n"
> >> -		     " srl     %0,28\n"
> >> -		     : "=d" (cc), "=m" (p)
> >> +		     " ipm     %[cc]\n"
> >> +		     " srl     %[cc],28\n"
> >> +		     : [cc] "=d" (cc), "=m" (p)
> >>   		     : "d" (p), "m" (p)  
> > 
> > this bit (which you did not touch) is actually the most confusing to me.
> > what's the point of separately specifying both "d" and "m" constraints
> > for (p) ? (and it also has a "=m" in the output clobberlist)  
> 
> I consulted the kernel code as well as Heiko and the architecture.
> 
> CHSC is one of those request/response do everything instructions and is 
> similar to sclp. A header is read from memory and a response is written 
> below the header. The addressed memory needs to be page aligned and can 
> be up to a page in size.
> 
> Which means:
>   - We need the address in R1
>   - CPU reads from the memory area designated by R1
>   - CPU writes to the memory area designated by R1
> 
> My guess is that nobody bothered defining all of the structs and that's 
> how we ended up here. If you look at the kernel assembly you'll notice a 
> page size typedef for the +m clobber of the memory area pointer.
> 
> Heiko suggested to drop the two "m" clobbers and just add a generic 
> memory clobber. If we even want to touch this at all...

tbh, yes, I would like to have it as simple as possible.
this is not super performance-sensitive, IMHO it's more important that
the code is readable and understandable.



