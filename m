Return-Path: <kvm+bounces-32522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAB09D9713
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 13:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2415DB2A391
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 12:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8DC1D1F4B;
	Tue, 26 Nov 2024 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JOj/lRRc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5935483A17;
	Tue, 26 Nov 2024 12:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732623115; cv=none; b=bztPd98aKfeuLadrP6i9/Nnt6B3W0c4Pvz3BGO7wMm2VybEWozF5y32atbwMOD36jrnURFagK332untuxooY1mIxlN3FKgHkCplQeoe2Tnz1NRt7Cgr9oYumaZYLLGMPQN1cM13agpAHKS75HAycms8MrjEL1d+qZoVQ67qjlVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732623115; c=relaxed/simple;
	bh=oK74cs31TwNFDwrGbGtC0jLLF04cMI4xgHDEe49zBEE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3wZdlg6OaS8AHziIiLwOA9j2lpIb4wUbPG5z6tIkhxGYKwGE+J6Y1M+3c57jeHa0tYW/nKVES1uRCIpgY/fYIONWDBHW488omv94I/Ml8GJdIZ56I2NYAAZehqN1/0o3Sbb+jJ+0flTYZDD/shuvEYlO2EAATNn3Y1X6+aUelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JOj/lRRc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQA7JTi026552;
	Tue, 26 Nov 2024 12:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=z1IU+0
	x4b4dxL2eBll1QY/bWdljyFYdCzH0R4nmZI34=; b=JOj/lRRchtBEDZwelC/v5S
	u0aWib7fqfXU2t0El3Gt4Yd/i4PuKQydHZY+OHK3mjTmbvHwHE/10vmf373IbOtA
	gNsR+MreMCOSZxOu75YwTzEn2EJWM5WGywRDWz2+W2wRjoS1Yz7o3D6fmjHg8aBV
	yE+ur/81fRvkL3N2yu5/DpWi62kZez6snXYT3maAPJ+1xr6BiMKwnvHcOAWvhz1d
	AGhFrAZfo/3doQPBXXwxLDMHCrJAbZjZk4mef3K9nfemzCRl3izU10PHX8Y1jfvM
	vKyrzInCaNQ6qoI+1CtA9tfUk/XS0ptbVv21U1Si6js3CdMyWoqZU32PwDjoFKIA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4350rhk7m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 12:11:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ3xdB7027470;
	Tue, 26 Nov 2024 12:11:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 433ukj4aw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 12:11:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQCBke955771500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 12:11:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBECF20043;
	Tue, 26 Nov 2024 12:11:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89F2820040;
	Tue, 26 Nov 2024 12:11:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 12:11:46 +0000 (GMT)
Date: Tue, 26 Nov 2024 13:11:44 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: s390: Couple of small cmpxchg()
 optimizations
Message-ID: <20241126131144.0a076101@p-imbrenda>
In-Reply-To: <20241126102515.3178914-1-hca@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
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
X-Proofpoint-GUID: IZ6z6AJwRAl1qDa--NiJF6Vnq671tAeO
X-Proofpoint-ORIG-GUID: IZ6z6AJwRAl1qDa--NiJF6Vnq671tAeO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=767 bulkscore=0
 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411260097

On Tue, 26 Nov 2024 11:25:12 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

looks good, and it's a follow-up of your cmpxchg series, so I think it
should go through the s390 kernel tree

(but please try to add the comment in patch 3)

> v2:
> - Replace broken WRITE_ONCE(..., 9) with intended WRITE_ONCE(..., 0).
> 
> v1:
> Use try_cmpxchg() instead of cmpxchg() so compilers with flag output
> operand support (gcc 14 and newer) can generate slightly better code.
> 
> Also get rid of two cmpxchg() usages on one/two byte memory areas
> which generates inefficient code.
> 
> bloat-o-meter statistics of the kvm module:
> 
> add/remove: 0/0 grow/shrink: 0/11 up/down: 0/-318 (-318)
> Function                                     old     new   delta
> kvm_s390_handle_wait                         886     880      -6
> kvm_s390_gisa_destroy                        226     220      -6
> kvm_s390_gisa_clear                           96      90      -6
> ipte_unlock                                  380     372      -8
> kvm_s390_gisc_unregister                     270     260     -10
> kvm_s390_gisc_register                       290     280     -10
> gisa_vcpu_kicker                             200     190     -10
> account_mem                                  250     232     -18
> ipte_lock                                    416     368     -48
> kvm_s390_update_topology_change_report       174     122     -52
> kvm_s390_clear_local_irqs                    420     276    -144
> Total: Before=316521, After=316203, chg -0.10%
> 
> Heiko Carstens (3):
>   KVM: s390: Use try_cmpxchg() instead of cmpxchg() loops
>   KVM: s390: Remove one byte cmpxchg() usage
>   KVM: s390: Increase size of union sca_utility to four bytes
> 
>  arch/s390/include/asm/kvm_host.h | 10 +++++-----
>  arch/s390/kvm/gaccess.c          | 16 ++++++++--------
>  arch/s390/kvm/interrupt.c        | 25 ++++++++-----------------
>  arch/s390/kvm/kvm-s390.c         |  4 ++--
>  arch/s390/kvm/pci.c              |  5 ++---
>  5 files changed, 25 insertions(+), 35 deletions(-)
> 


