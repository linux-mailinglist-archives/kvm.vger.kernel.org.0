Return-Path: <kvm+bounces-8108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 229F884BA10
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 16:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8062822F5
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 15:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847E7133292;
	Tue,  6 Feb 2024 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MHstFWs8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0962A130E30;
	Tue,  6 Feb 2024 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707234439; cv=none; b=PZ+fwimRX8KdsZyHyYnDtTte/5xXO1j7U1i5/wEjPNyGczYaJ3JvsdkEsQszqyCTjo459OZnEpLK6F97nywk+9AXYbl9PbKF1nYlQ+fgIUaIrtJ2jgOMHNNPAyWcLRETZk8e9xDUDBWO+RGMwjc1FK5ciSGa3YmIfd+2KgB9dwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707234439; c=relaxed/simple;
	bh=xlaardXoEYtXfIJmKD9QhxH03dtYtepzftADQbUsLi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdtMAqc2Fy0LFY1e4lz8uSBYxlHHOfHyT7WGx1Wlh+Z+yi0YYz174v/fiiT6bQEcgktS+rMyB7Hy8S5Ev3wsJv8s/xs9hNYo7vwAwDaZTI5HeWrCwYkD6FfKeE+opTm7VyHS81EC3+GCsZgRzd4amKoYxjXDpbBWwiaJ8O+1J78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MHstFWs8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 416FNUxa023990;
	Tue, 6 Feb 2024 15:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=qX/Q6nw24xH8PDfJvhmSeO9c7jZVKKF2pG7sh+4Eb9A=;
 b=MHstFWs8ShO3k2U0b5hUR+pt9jCQeJ7DlFu2lIu8QtwsN3CLDFTcA7JfhAT3eY6zkPHy
 e0bH+69MWa1/O4OdNh0Nrem250bfG6Jn57B0mgCEn1FBXtNC1IoUZ02r/JeO33kPkg1A
 a+t3JK+nxbIBW0BGGldABsT727Ix4Zs8QGT48FAZP+h9Wq9F9hq6xnUF96+rjueFKA+e
 GfeUuXMoVnbX5biocRGHL1JocfvsPqzPlKNcWr2z4QY+H0cIoibHCq+srd8shWBuqlAM
 LNsDGJjDgSGA93211nckWSCXzh2j6VpsSgalp3Wfws2VTEngihYASQNk9Lc+DRxGC21j IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3pk5jmb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 15:47:15 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 416Eb5dx028982;
	Tue, 6 Feb 2024 15:47:14 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3pk5jm9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 15:47:14 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 416FAQN0008971;
	Tue, 6 Feb 2024 15:47:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w206yg489-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 15:47:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 416FlAxU31916600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Feb 2024 15:47:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03BF420043;
	Tue,  6 Feb 2024 15:47:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99AFE20040;
	Tue,  6 Feb 2024 15:47:09 +0000 (GMT)
Received: from osiris (unknown [9.171.32.22])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  6 Feb 2024 15:47:09 +0000 (GMT)
Date: Tue, 6 Feb 2024 16:47:08 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers
 into KVM_RUN
Message-ID: <20240206154708.26070-C-hca@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
 <20240201151432.6306-C-hca@linux.ibm.com>
 <f82ab76e5f389a92afe2fa8834812feeec4df4b5.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f82ab76e5f389a92afe2fa8834812feeec4df4b5.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: odVlAARcMUk0Q2rJnpzpfy_TM12VNYj9
X-Proofpoint-GUID: d99U0MnL9msNPfNqoZRJW1XC_n5p9eaH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=4 adultscore=0 mlxscore=4
 bulkscore=0 clxscore=1015 mlxlogscore=138 priorityscore=1501 phishscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=4
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060111

On Thu, Feb 01, 2024 at 11:56:26AM -0500, Eric Farman wrote:
> On Thu, 2024-02-01 at 16:14 +0100, Heiko Carstens wrote:
> > On Wed, Jan 31, 2024 at 09:58:32PM +0100, Eric Farman wrote:
> > What's the code path that can lead to this scenario?
> 
> When processing a KVM_RUN ioctl, the kernel is going to swap the
> host/guest access registers in sync_regs, enter SIE, and then swap them
> back in store_regs when it has to exit to userspace. So then on the
> QEMU side it might look something like this:
> 
> kvm_arch_handle_exit
>   handle_intercept
>     handle_instruction
>       handle_b2
>         ioinst_handle_stsch
>           s390_cpu_virt_mem_rw(ar=0xe, is_write=true)
>             kvm_s390_mem_op
> 
> Where the interesting registers at that point are:
> 
> acr0           0x3ff               1023
> acr1           0x33bff8c0          868219072
> ...
> acr14          0x0                 0
> 
> Note ACR0/1 are already buggered up from an earlier pass.
> 
> The above carries us through the kernel this way:
> 
> kvm_arch_vcpu_ioctl(KVM_S390_MEM_OP)
>   kvm_s390_vcpu_memsida_op
>     kvm_s390_vcpu_mem_op
>       write_guest_with_key
>         access_guest_with_key
>           get_vcpu_asce
>             ar_translate
>               save_access_regs(kvm_run)

...

> Well regardless of this patch, I think it's using the contents of the
> host registers today, isn't it? save_access_regs() does a STAM to put
> the current registers into some bit of memory, so ar_translation() can
> do regular logic against it. The above just changes WHERE that bit of
> memory lives from something shared with another ioctl to something
> local to ar_translation(). 

This seems to be true; but there are also other code paths which can
reach ar_translation() where the access register contents actually do
belong to the guest (e.g. intercept handling).

> My original change just removed the save_access_regs() call entirely
> and read the contents of the kvm_run struct since they were last saved
> (see below). This "feels" better to me, and works for the scenario I
> bumped into too. Maybe this is more appropriate?
> 
> ---8<---
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 5bfcc50c1a68..c5ed3b0b665a 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -391,7 +391,6 @@ static int ar_translation(struct kvm_vcpu *vcpu,
> union asce *asce, u8 ar,
>         if (ar >= NUM_ACRS)
>                 return -EINVAL;
>  
> -       save_access_regs(vcpu->run->s.regs.acrs);

I guess this and your previous patch are both not correct. There is
different handling required depending on if current access register
contents belong to the host or guest (both seems to be possible), when
the function is entered.

But anyway, I'll leave that up to Janosch and Claudio, just had a quick
look at your patch :)

