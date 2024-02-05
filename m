Return-Path: <kvm+bounces-8036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BEFA84A1D2
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 19:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ED2E1C22FA8
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D16A847F72;
	Mon,  5 Feb 2024 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f4OPkUSb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AD847F47;
	Mon,  5 Feb 2024 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707156570; cv=none; b=DcwPyNhnw8vESiOy509sd09obtDnvEvl+fZLh/MNnc4Ei5fXFoKvi5pq3gNZChgXdjwRDSPz5O+XEwnhwgoQq4RDRM1eJPiycvvSCjtIMQJdx85iZZ/aZBtVMQAfzOoJm3Xopo3xR1g08JQY3/HR26tmIE1oDRRpQevOjPzyzLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707156570; c=relaxed/simple;
	bh=War4Ygw73Zkn9dPQAXSGKAIcWAUoaEPf0WyGsPEMqvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlihHx79hpsi1F3T1jiDjrAkHNMaj2KAPRJ81cfconcpPYhujPjN4ZGlO/di+cvaPC7hJ+cqY5VwV+H2qfrC3LtKxtJLZ0oyPcmfVId5xyITOmuzFvHZb28CHAMO305Z18QQniR27jBqQkJW+CT1dkFA8BS+bpLLKIJ2i2AfP7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f4OPkUSb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415I29Io001118;
	Mon, 5 Feb 2024 18:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=H4aL8bR7hMDj/h6uHjjh77Iz3T+5OxbzDFyXjwQXs6Q=;
 b=f4OPkUSbkkt2A1Umox0P3qnBuoFdRKf2KXSmvQnRDx27BXxTSSK5+8n5ONqk35E8aHer
 GODIFs7ls1sdXgQUly3L7bGQl6uZhPf2XGla55ClvfTmVmcku2LNRho4HbrTwJDB4Wqc
 Wbuy5dNsihgvDD3uggL/89cSvDs1xyr50v92ZHiigu/XyZJ1fvoSGt9t04rcJ1ofkvF2
 VejiqwYl0OJlFr2r84S8Q5ZFfWHHNpbe4kbZsFjyaQh0js7U9LZ5vjqcgmQsAlIGTPVI
 ZWl9LBsBgSQCYwvfbNHQRxBA2TBJEGLgHvAAihNXrS1+dkL3OpxciT0ypAcDKVZqYqRZ BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w34kk067u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 18:09:22 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 415I3FBR005114;
	Mon, 5 Feb 2024 18:09:22 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w34kk067j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 18:09:22 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 415I7bdV008539;
	Mon, 5 Feb 2024 18:09:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w221jsrbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 18:09:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 415I9Ib420841006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Feb 2024 18:09:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36BE52004B;
	Mon,  5 Feb 2024 18:09:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A118B20040;
	Mon,  5 Feb 2024 18:09:15 +0000 (GMT)
Received: from li-a83676cc-350e-11b2-a85c-e11f86bb8d73.ibm.com (unknown [9.43.55.162])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  5 Feb 2024 18:09:15 +0000 (GMT)
Date: Mon, 5 Feb 2024 23:39:12 +0530
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: Re: [PATCH v2] KVM: PPC: Book3S HV: Fix L2 guest reboot failure
 due to empty 'arch_compat'
Message-ID: <z47adbiweldcumlq4uejggkfcvfaw5nrd7v3tbh2e3pcvzjot2@gourfue5ytbl>
Mail-Followup-To: Vaibhav Jain <vaibhav@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Vaidyanathan Srinivasan <svaidy@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Jordan Niethe <jniethe5@gmail.com>, "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
References: <20240205132607.2776637-1-amachhiw@linux.ibm.com>
 <87h6img6g4.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6img6g4.fsf@vajain21.in.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8E9EiS8ihTxe6mGulR4STRg4YndCvuK-
X-Proofpoint-GUID: T-e15VsqzERE4oLBM_2e0CIBfPF2YuaK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_12,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=799 impostorscore=0
 bulkscore=0 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050136

Hi Vaibhav,

Thanks for looking into the patch.

On 2024/02/05 11:05 PM, Vaibhav Jain wrote:
> Hi Amit,
> 
> Thanks for the patch. Minor comment on the patch below:
> 
> Amit Machhiwal <amachhiw@linux.ibm.com> writes:
> 
> <snip>
> 
> >  
> > +static inline unsigned long map_pcr_to_cap(unsigned long pcr)
> > +{
> > +	unsigned long cap = 0;
> > +
> > +	switch (pcr) {
> > +	case PCR_ARCH_300:
> > +		cap = H_GUEST_CAP_POWER9;
> > +		break;
> > +	case PCR_ARCH_31:
> > +		cap = H_GUEST_CAP_POWER10;
> Though CONFIG_CC_IMPLICIT_FALLTHROUGH and '-Wimplicit-fallthrough'
> doesnt explicitly flag this usage, please consider using the
> 'fallthrough;' keyword here.
> 
> However you probably dont want this switch-case to fallthrough so please
> use a 'break' instead.

Sure, v3 on the way.

> 
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return cap;
> > +}
> > +
> >
> <snip>
> 
> With the suggested change above
> 
> Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>

Thanks!

> 
> -- 
> Cheers
> ~ Vaibhav

~Amit

