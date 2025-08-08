Return-Path: <kvm+bounces-54312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06990B1E286
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 08:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A10C37A9DC2
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 06:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46E35218ACC;
	Fri,  8 Aug 2025 06:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ppHz0ecz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002C638DD8
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 06:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754635976; cv=none; b=Xnfh1HRmfyQaedI5UNpMiT2TREeKmyVcJWEHngDnJMhPvVeTrZZF17epP68grg9YD82WYiRMJlotpXcMe8OsJMxk38f/9pyF5Pq+5u4v8JKMj35j5f9mnsLdRTgE8gdJONcC7FVkYOYFhiIre7k6NYqzyFuYY4xuc0ypEgTtw30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754635976; c=relaxed/simple;
	bh=FCyZ1qr9VlR1wWcWMkbp1PbVNxRSYB1Emce/MD6E+/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssgakCxvW4UvFHlzBW9hWLZXOBrBnPLFcinOOIEOmf9ZPNSE4hVxGCpJtont27vutQVLD+wkHAVEbjbLRN2nrFZ+JfsuF0XlVr0ZC9JzN77wbOMgfb9gK63l4NPYFG47eozVWC14Oa60i9RFWSpvIvQ7jO/LguAVkSpn83XK6PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ppHz0ecz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5783OJPJ019470;
	Fri, 8 Aug 2025 06:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=e/fjeSaQRZNP3JdWMoihbTZAw78OQe
	Ddx+AtxvK9958=; b=ppHz0ecz2z5mDVkRDUFnY3yNQf6zFWoCjmQEwm+8p+D8bN
	0z1yCcpgHIBlAk/ByOK/0O+kUAW0kho9O4/ZZBjZph5JB2h7PR1Kjz6Nlha3NqN2
	rD0ixGED+SNOb+xHkfDKeED0BWmnATwneHS94d5FttfuMmizQFQmrf1UCcwnFooD
	DjWmuzgrRhjTHVZVibM940KhtxZsOqelrJxDucTHn3CG6jV89K7XD3oTWZpilQl4
	Pz91KZRyj4XTwxEJUD+Ki+LvDzoXYMeTnlM+TrwQRlb00Z098jXLGQhfnlLPZf0K
	zn5EekMGVmsLMV4xaEX90r5v+Z2GwoKYC6BLzYSA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26u481f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 06:52:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5786FGm3020603;
	Fri, 8 Aug 2025 06:52:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwn4f99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 06:52:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5786qiMY41288106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Aug 2025 06:52:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E286420043;
	Fri,  8 Aug 2025 06:52:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E376420040;
	Fri,  8 Aug 2025 06:52:43 +0000 (GMT)
Received: from li-e7e2bd4c-2dae-11b2-a85c-bfd29497117c.ibm.com (unknown [9.124.217.7])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  8 Aug 2025 06:52:43 +0000 (GMT)
Date: Fri, 8 Aug 2025 12:22:41 +0530
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Fix misleading interrupts comment in
 kvmppc_prepare_to_enter()
Message-ID: <20250808122131.834df8e0-6c-amachhiw@linux.ibm.com>
Mail-Followup-To: Andrew Donnellan <ajd@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20250806055607.17081-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806055607.17081-1-ajd@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ctVdYfXKz-a7nubi8SMjZ2vAE0M499Gz
X-Authority-Analysis: v=2.4 cv=F/xXdrhN c=1 sm=1 tr=0 ts=68959ec2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=T-Jo5Y6SYTEF9Fg7UwAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: ctVdYfXKz-a7nubi8SMjZ2vAE0M499Gz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDA1NSBTYWx0ZWRfX11YstKMHW7sA
 oSO3nir8LawsVvN8u035WmVjCXR2mrc2KkPYo8Y2RazWlnq+JH1+1rt7qEoC3fITE6iQVe+plup
 ekAlQSkYW+z9E5uIepJilW0S/dsaWpFwG0Yv7vCeRHgS89HNORoh0NHZL/wRALsEGL5FDcFW7cU
 5ET/IdzWAxglrpOMsoB9LmJo5SYzYFiLCAEV6ULJwbOdaa29PQq47EeGDfjM/G3uYZrZHCpBH2c
 G/5CoU7OXrIjnvTHlcYkbX6s7DmxFuTpKTifirYYucP6jbS8BlVoGr36JRZutRntP0t9APVmm6J
 fVlxPK4efUBNr1YOl4/XtWTfqVVZwwDEk7xprFJo07SFBSB6WPYVSK/vagUVn7lrm8FIRVAoa3g
 xL7/+Feul5k2t5l7OY/S/lYo78K3bGZ8odKNezAtIsW1Zo/u3RGUShn0uHPwvh6lS/x1xyF6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound
 score=100 mlxscore=100 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 spamscore=100 bulkscore=0 adultscore=0 mlxlogscore=-999
 malwarescore=0 phishscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508080055

On 2025/08/06 03:56 PM, Andrew Donnellan wrote:
> Until commit 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup"),
> kvmppc_prepare_to_enter() was called with interrupts already disabled by
> the caller, which was documented in the comment above the function.
> 
> Post-cleanup, the function is now called with interrupts enabled, and
> disables interrupts itself.
> 
> Fix the comment to reflect the current behaviour.
> 
> Fixes: 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup")
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

Thanks for catching and fixing this. Please feel free to add:

Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>

> ---
>  arch/powerpc/kvm/powerpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 153587741864..2ba057171ebe 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -69,7 +69,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  
>  /*
>   * Common checks before entering the guest world.  Call with interrupts
> - * disabled.
> + * enabled.
>   *
>   * returns:
>   *
> -- 
> 2.50.1
> 

