Return-Path: <kvm+bounces-61779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB24C2A0DC
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 06:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18AFB3B16AE
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 05:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F24A2405FD;
	Mon,  3 Nov 2025 05:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ly1wlrTy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE1328DB3;
	Mon,  3 Nov 2025 05:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762147265; cv=none; b=sMNpv2p1tv8AMnrZNR81w1poalR6F1WRLUoMR9A4HWgCbXzoJ/r64LaAZ8qG+oyWxU+GvYv6sROvFwHmnct+uzKMuCqbGrgp3xVTA2KsUzWxChX3QfnjtblyeGGI3ownMfOOWq0FnR0nUd7YCb7xNFbXoPnndlSO8OpDsgKnmpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762147265; c=relaxed/simple;
	bh=KiTakMNYhpyqAGwMX4/KFpUS4ukxEBVyGXTR+SlrTZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8G3Yrspd2n/zt3D6sOF6rZHftC+f5k71C7jzm6ek/kR9BNRYmNSUpbKDbvvLEBJTMBafi++r8akLD2f/+K+IZjBGY6q5GIqsRtsEfNg6FXyP27pW0R3nqm7ypt4KBjyeIJK9s5V+zIo8v5ABox4htwLDWrXRxqaPZS81yCnCHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ly1wlrTy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2KCFaa016813;
	Mon, 3 Nov 2025 05:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jMSYAu
	sxYlf1VVxhQe8v5fMuC5LP0UC5SXkvrut2NoI=; b=Ly1wlrTy7yuurWKEqwCftm
	BHEdTAFc4o0aYdJQ1lPXFflwDjA8ujjHnCF92O8IcPOHIxKB6Lh9lF+Ys09DdiUA
	ophyPJMZYVYhxLWnExSwyhQe3ZC+dVgIMx5no3G5606zur30BueDI12jvk8f/FAE
	cvBzG3ivNuzCSj9HGqwShDadILR4HjFaobNTWR79+2rd0YjQGYnlI88DTDsWsPbC
	E4AKRKqfGVu2uo9l+DzsD6GdQJvFOsSFr9xJjzmZBoseJxIFQ/2VXjmhlDHoZ4zv
	clUUtTbcL2OHkOS9ufRQmLfuw0vuYFiRZSjJKD/j0sgeXqk794wudEEnpqQNuNFQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v1myd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 05:20:39 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A35KdRO006672;
	Mon, 3 Nov 2025 05:20:39 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v1mycx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 05:20:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A344fri021483;
	Mon, 3 Nov 2025 05:20:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrjbs1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 05:20:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A35Ka9N31981836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Nov 2025 05:20:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52E4D2004B;
	Mon,  3 Nov 2025 05:20:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 157CC20040;
	Mon,  3 Nov 2025 05:20:34 +0000 (GMT)
Received: from Gautams-MacBook-Pro.local (unknown [9.43.116.143])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Nov 2025 05:20:33 +0000 (GMT)
Date: Mon, 3 Nov 2025 10:50:26 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Alexander Graf <agraf@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Miaoqian Lin <linmq006@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Use pointer from memcpy() call for assignment
 in kvmppc_kvm_pv()
Message-ID: <aQg7msPQvAZbXs_u@Gautams-MacBook-Pro.local>
References: <ad42871b-22a6-4819-b5db-835e7044b3f1@web.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad42871b-22a6-4819-b5db-835e7044b3f1@web.de>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s1oEhR6BIpCrsug6jsfVGX8pgU_LzU-4
X-Proofpoint-ORIG-GUID: _pMypZ0RUqX5RFeWRSx1Kt-pJHcoctpY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX2zSSroT9Kfsr
 uMXS51u8zrNm1Lx+V5gbzWX8OcPkIdi4f2cTjfViqY0xPbk+/WTWPCNV4U+13OkpT7JFd4/Hg9L
 vf7UKx+e+Wp0lx40J5XD3EXP0XIDsWLF8Zgbr+k0xhjGC5Uq0QEBBIo0kT9Issb4znXTe8bMrcn
 b74iPOtldM9tNREFr39+x8SbcKMNRPO5iGFOhqPkwBpVXdBTGDF7hVwCFMry49bMzBDG6jssRXY
 yXOPTDV6emxigeiBqKuuskHNOJsQ33rETCkEyTQjcVnEqWE+wrkQ0wBeXexZIzHsbKOu9wjOkiK
 H/MUU8dnoD7+YCWJjalMQcAmptHrw2m2cs3Ii79SV7d1ZegbIhEQfPMfcQm29waujgYJVI1ulX7
 m5ed6qt5cX0siX1Y2CrRVnY8WI97sw==
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=69083ba7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=8nJEP1OIZ-IA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FP58Ms26AAAA:8 a=8Wr6nJrWg-yotHxcTvEA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1011 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

On Thu, Oct 30, 2025 at 09:51:00PM +0100, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 30 Oct 2025 21:43:20 +0100
> Subject: [PATCH] KVM: PPC: Use pointer from memcpy() call for assignment in kvmppc_kvm_pv()
> 
> A pointer was assigned to a variable. The same pointer was used for
> the destination parameter of a memcpy() call.
> This function is documented in the way that the same value is returned.
> Thus convert two separate statements into a direct variable assignment for
> the return value from a memory copy action.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  arch/powerpc/kvm/powerpc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2ba057171ebe..ae28447b3e04 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -216,8 +216,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
>  
>  			shared &= PAGE_MASK;
>  			shared |= vcpu->arch.magic_page_pa & 0xf000;
> -			new_shared = (void*)shared;
> -			memcpy(new_shared, old_shared, 0x1000);
> +			new_shared = memcpy(shared, old_shared, 0x1000);
>  			vcpu->arch.shared = new_shared;
>  		}
>  #endif

This patch does not compile

In file included from ./include/linux/string.h:382,
                 from ./arch/powerpc/include/asm/paca.h:16,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/sched.h:12,
                 from ./include/linux/resume_user_mode.h:6,
                 from ./include/linux/entry-virt.h:6,
                 from ./include/linux/kvm_host.h:5,
                 from arch/powerpc/kvm/powerpc.c:12:
arch/powerpc/kvm/powerpc.c: In function `kvmppc_kvm_pv´:
arch/powerpc/kvm/powerpc.c:219:45: error: passing argument 1 of `__builtin_dynamic_object_size´ makes pointer from integer without a cast [-Wint-conversion]
  219 |                         new_shared = memcpy(shared, old_shared, 0x1000);
      |                                             ^~~~~~
      |                                             |
      |                                             ulong {aka long unsigned int}


Thanks,
Gautam

