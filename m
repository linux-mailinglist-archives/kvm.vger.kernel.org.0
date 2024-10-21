Return-Path: <kvm+bounces-29268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C26099A609F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F172D1C21E43
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2831E32C2;
	Mon, 21 Oct 2024 09:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GNG6ZYxw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CF11799F;
	Mon, 21 Oct 2024 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729504215; cv=none; b=oqSDEAryHfvXoVILlVqVz4JuNlLVn02sV2qArEEgltrwlZBHo+d8H/cA+A05nQElrwMb+UchYg9rT9/SEOM3IgJ2GlVQdwi3YGsq+FLhbhEtgr7BfpYQ4OqqenVByTudLO8ly3LZffecmcqXS6L9cOUhvOZ8/XcBVL0k/UrfM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729504215; c=relaxed/simple;
	bh=U0oqEStiYZJ98uv4UxNz4a8ia9sskVGUaw9gfGhLCmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEAhjl+4ohjEmFAUlMyzKNiY09wpt5G5cNjLN+tHX6Pty/CuUM9ewTi8VLqVCJo1Dh0oO+ta45SZBQLnhjp75fb8JWVttw7nmwCbezh6E/T5lU555bDPFUTHsX7yIHxcNh8wr4T4KRccv52hoUfUHTN/AIakhbcQeggma2vcx+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GNG6ZYxw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2LNZc002383;
	Mon, 21 Oct 2024 09:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=aqMGkICfk0oBk84AN6gBXNwwsoQple
	6ymUOJwx62Jx0=; b=GNG6ZYxwB+3EzS5oBPLoJtHsamH2Gx7BQjbS6pG/ECLT87
	EzEUohJLkGJUwZv/Zh5gXcXf2o8FwPiqtEJiGkIYK0HMQ+25BimNUlgzGVkGpmdd
	POX7CrG+EBjZVOmz3g/b1F+f0gUUJJqLrx3q/5la+KftcuB+zDLZ7akkLsoZQaJF
	AByl2Vs1SNXiQhimDuXEkVcYUG3Ry5eBmc8q5WPeM9NLHvhqLTZJuQFj9Jl4HGvG
	xfd7bIZP1tM32DVBAo/vya4sMFEbbWPniHxFXp/vftg7zUO3hi5bSwo5Q2nOM8s8
	ZJ/1h17W7nRFZiDWFOfFrilIEH6XTU//BthM4K0A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5hm8d82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:50:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L7WAwb026443;
	Mon, 21 Oct 2024 09:50:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cq3s5ts1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:50:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49L9o7nm29557160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 09:50:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1D8C2004E;
	Mon, 21 Oct 2024 09:50:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66A4E20040;
	Mon, 21 Oct 2024 09:50:07 +0000 (GMT)
Received: from osiris (unknown [9.171.37.192])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Oct 2024 09:50:07 +0000 (GMT)
Date: Mon, 21 Oct 2024 11:50:06 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 06/11] s390/kvm: Stop using gmap_{en,dis}able()
Message-ID: <20241021095006.6950-B-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
 <20241015164326.124987-7-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015164326.124987-7-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5e6sV7_4IxI48fu2PqjW3yDXMFtPJ6ro
X-Proofpoint-GUID: 5e6sV7_4IxI48fu2PqjW3yDXMFtPJ6ro
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=546 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210068

On Tue, Oct 15, 2024 at 06:43:21PM +0200, Claudio Imbrenda wrote:
> Stop using gmap_enable(), gmap_disable(), gmap_get_enabled().
> 
> The correct guest ASCE is passed as a parameter of sie64a(), there is
> no need to save the current gmap in lowcore.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 7 +------
>  arch/s390/kvm/vsie.c     | 4 +---
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index cfe3f8182aa5..df778a4a011d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3719,7 +3719,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  
> -	gmap_enable(vcpu->arch.enabled_gmap);
>  	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
>  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>  		__start_cpu_timer_accounting(vcpu);
> @@ -3732,8 +3731,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
>  		__stop_cpu_timer_accounting(vcpu);
>  	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_RUNNING);
> -	vcpu->arch.enabled_gmap = gmap_get_enabled();
> -	gmap_disable(vcpu->arch.enabled_gmap);

I guess you want to get rid of enabled_gmap as well, since it becomes
unused with this patch:

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 603b56bfccd3..51201b4ac93a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -750,8 +750,6 @@ struct kvm_vcpu_arch {
 	struct hrtimer    ckc_timer;
 	struct kvm_s390_pgm_info pgm;
 	struct gmap *gmap;
-	/* backup location for the currently enabled gmap when scheduled out */
-	struct gmap *enabled_gmap;
 	struct kvm_guestdbg_info_arch guestdbg;
 	unsigned long pfault_token;
 	unsigned long pfault_select;

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

