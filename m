Return-Path: <kvm+bounces-21697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A817932425
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDED11F22960
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 10:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772EB198E88;
	Tue, 16 Jul 2024 10:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NISWl0X5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FCB196438;
	Tue, 16 Jul 2024 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721126000; cv=none; b=ok7LnLwCivvi2J/JUgkiOiptdeVi5TS1MfsGJUlYcKHcaWGFZN+URKr5d2Yc9h0YkmwzDroRyiWXepFm+1GAMYov2D37R38JTHtnpWwKsVCT48Atkt8VBy7App9xjZrsX4jwof0FafCyoCLKs7/JlPHVrHALIyyaKJO2GDjyITY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721126000; c=relaxed/simple;
	bh=vTflwazVaPGM5ZCdDCKRyUNgR5nEg0hgVF6yqKN58mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNrzFSsvN2NU4PeKvPtKpPUDIhZozaGzc1JC6+QlT/Eo4NIftkPF6ebB4XMgUDixGK7k6bDvgn/lCl5Wr1de1cnzmfCAEJae4x40rfJRvEdqTvV37x/KrPlal6aENu8VZyDgcn2Rkg0VApyRQdL8ARkWrkfuKTw5SMwc3cx+PR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NISWl0X5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46GASX0v007229;
	Tue, 16 Jul 2024 10:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=+UQQJ/4g4npGy4OKFE1cPqYM0BR
	ctKyIGBatWAVAOjY=; b=NISWl0X5jLa695N4joATffKR609BFQHOi30SBi+J5Fd
	V+Yt8cU/KBDK9jaZpMr2dXCj3+qS/KW6Rd1YiO8qZOqWwnRTl93CXl6LpXrOY3+t
	0p+gnX9dj39Zm1NXpbC6wxmJFPaxZevKkgigVWPwGcFy8bS5pAlNkogNWO1TE0rI
	gqN6OXhnLK1KhCQXmqkbgwfYtnn05WqJpCeJ8/q/q1opUQqO5rELJ6ttJ5Tj3TyC
	ck/zA9sy7HeZaR3+e/uLdeq/lq+eyXKAgJO3OANsujueSDf0NdPjYHIuCgdYCoaU
	tqS420W8Il2Id8gDTKUsl2FrUl7EQ8um5ZZU0GYO0dA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40dppur27a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:33:04 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46GAX3M3014379;
	Tue, 16 Jul 2024 10:33:03 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40dppur278-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:33:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46G8VSLa030795;
	Tue, 16 Jul 2024 10:33:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40c4a0krx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:33:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46GAWwEh50200924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 10:33:00 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 937EA20040;
	Tue, 16 Jul 2024 10:32:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D9FC20043;
	Tue, 16 Jul 2024 10:32:57 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Jul 2024 10:32:57 +0000 (GMT)
Date: Tue, 16 Jul 2024 16:02:54 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen.n.rao@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm: Avoid extra checks when emulating
 HFSCR bits
Message-ID: <jwujothqmnnno5el6ehucdw6xiasoa6dkyksa7zxev4goligmy@u3wpdu3ilnya>
References: <20240626123447.66104-1-gautam@linux.ibm.com>
 <87v816w2xy.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v816w2xy.fsf@mail.lhotse>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9FuTioXVKY14k7mK67ujftAWd0VT3nqH
X-Proofpoint-ORIG-GUID: DycL2rxeg4CuuqSbBOpGbbfKzFj99hZP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 mlxlogscore=677 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407160075

On Tue, Jul 16, 2024 at 11:17:13AM GMT, Michael Ellerman wrote:
> Gautam Menghani <gautam@linux.ibm.com> writes:
> > When a KVM guest tries to use a feature disabled by HFSCR, it exits to
> > the host for emulation support, and the code checks for all bits which
> > are emulated. Avoid checking all the bits by using a switch case.
> 
> The patch looks fine, but I don't know what you mean by "avoid checking
> all the bits".
> 
> The existing code checks 4 cases, the case statement checks the same 4
> cases (plus the default case).
> 
> There are other cause values (not bits), but the new and old code don't
> check them all anyway. (Which is OK because the default return value is
> EMULATE_FAIL)
> 
> AFAICS it generates almost identical code.
> 
> So I think the change log should just say something like "all the FSCR
> cause values are exclusive so use a case statement which better
> expresses that" ?

Yes agreed, will send a v2 with suggested changes.

> 
> Also please try to copy the existing subject style for the KVM code, for
> this file it would be "KVM: PPC: Book3S HV: ...". I agree it's verbose,
> and wouldn't be my choice, but thats what's always been used so let's
> stick to it.
> 

Ack. 

Thanks,
Gautam

> cheers
> 
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index 99c7ce825..a72fd2543 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -1922,14 +1922,22 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
> >  
> >  		r = EMULATE_FAIL;
> >  		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
> > -			if (cause == FSCR_MSGP_LG)
> > +			switch (cause) {
> > +			case FSCR_MSGP_LG:
> >  				r = kvmppc_emulate_doorbell_instr(vcpu);
> > -			if (cause == FSCR_PM_LG)
> > +				break;
> > +			case FSCR_PM_LG:
> >  				r = kvmppc_pmu_unavailable(vcpu);
> > -			if (cause == FSCR_EBB_LG)
> > +				break;
> > +			case FSCR_EBB_LG:
> >  				r = kvmppc_ebb_unavailable(vcpu);
> > -			if (cause == FSCR_TM_LG)
> > +				break;
> > +			case FSCR_TM_LG:
> >  				r = kvmppc_tm_unavailable(vcpu);
> > +				break;
> > +			default:
> > +				break;
> > +			}
> >  		}
> >  		if (r == EMULATE_FAIL) {
> >  			kvmppc_core_queue_program(vcpu, SRR1_PROGILL |
> > -- 
> > 2.45.2

