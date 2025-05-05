Return-Path: <kvm+bounces-45410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B1CAA8E9B
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 10:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A51187A483A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 08:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1681C8619;
	Mon,  5 May 2025 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Og7HfvaJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6031D54EE;
	Mon,  5 May 2025 08:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746435248; cv=none; b=JXuJOIrIT1Jl/pJdYLv3iGb1Fx7UxNF6DDTgzJmOfq4xzwik7njw4g6acwpP4FlYX0Auho7W3t7e65gPYL8D85V9NlCVqv0/AJZoGG4W+BmUScR8d/NtmVqiQ9wwV5pwAb6u+lWDsEYBP8yYpye+z1tM3AwJEa/b0uRghgN2CD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746435248; c=relaxed/simple;
	bh=QcsrZAR95YO6cZAiSXzX7H3lSG8AtKP9MYpFqaang00=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SzU3ajKhPun4NfZZkrjajd03ebKi+8D+F8nEo0jpcUlYwW4HNu24+f+QJ78tPVvUXMe/cZDzh6knujeGqk8qycg3og+zbTTWl84Q+yyXcK8XbszzSUdtA2g1XaABzTCC7RkRAWRn6o+TchH4AEajsvQolpo3wi799b+jGPm89a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Og7HfvaJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 544Lht5S009410;
	Mon, 5 May 2025 08:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=mDsh/cex7pLJmBz95gSl/5MULX/Unu
	Z+IBYUPdNHRM4=; b=Og7HfvaJwSQJPC2Wi1UeoFsa929JQoRb3NHp4pybH3SlyU
	i17sJ65KcJAvhezqg2pln65han2YfYMGOftZlwRFR0mpGhULWLYwQ86YORYbheSm
	Att01SuDOtu/cvNW2eT/iI/BH6cmzS2Hu3N8vVd/Br7k5ZNDhdYrBxLGQ7+drLsm
	NRZFAfam0G5pj+XEFTL8Xj0vDoFuS9u6H4CNCxDQYdeplHDoGYHdRIdh5/UUOoDv
	VdfoMeuiE8TKaBhUKl6XDUntLSWbl5KGjird10BsSqHYxMADJfTGQO6+l2qr0Kev
	kf8b67Avpyy89RPMok0t6XtuxEipCtELQLTzxiJA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46egcv1wyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 08:53:52 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 5458jGF2019896;
	Mon, 5 May 2025 08:53:51 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46egcv1wyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 08:53:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 545723iC001313;
	Mon, 5 May 2025 08:53:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dwft5meu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 May 2025 08:53:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5458rlMH7995660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 May 2025 08:53:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14B302004E;
	Mon,  5 May 2025 08:53:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D34820049;
	Mon,  5 May 2025 08:53:43 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.19.242])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  5 May 2025 08:53:42 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 05 May 2025 14:23:42 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Amit Machhiwal <amachhiw@linux.ibm.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Amit Machhiwal <amachhiw@linux.ibm.com>,
        Shivaprasad G Bhat
 <sbhat@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix IRQ map warnings with XICS on
 pSeries KVM Guest
In-Reply-To: <20250425185641.1611857-1-amachhiw@linux.ibm.com>
References: <20250425185641.1611857-1-amachhiw@linux.ibm.com>
Date: Mon, 05 May 2025 14:23:41 +0530
Message-ID: <87y0vba162.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uAx5RckqQtaDYrVHZoGmn2qNiC74thq3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA1MDA4MSBTYWx0ZWRfXzp9OqCY1Qkj+ NW4h2de4llaxXZ4QbT3u+/5QB5hqP4eguy7U42T14A8r7Nubx7L7wMXYPm1OKuhLZp1yhsMDT5u 4lCnlMo1N+tHJnaeCyQUXDCc234OgjBAm73LjwMCpOGCuCVKxV6Oax01HIIOBy2NYSsklevuPIa
 MYDy1BQWT2F7C6jiKZ9ymuebgUxhLUSLMncRb+t2YE14RvvdaP/wqw8VggoX+yfDWkpms8G0+yU F4X+/5JmJFzm5jLjxKoO6kv+mXBoI2Kg8Qjt+tZkqqQCAAUbHAVZgB04vze0wHm/AUYydH1M8cS gMhAW7mcowy9lz8ghcbaO1eb33wwbatmpExQ5zH27mBiVE/u2cmjmpaaG1/BSLZGkFIUZOB34bv
 3IQN7+ZJAGuZJsFs1oZShnK0WvYYfLfZfXxHnWg0He0aeC4Rdj1gp/e21cf0UPcmx5OcOVKt
X-Authority-Analysis: v=2.4 cv=O7k5vA9W c=1 sm=1 tr=0 ts=68187ca0 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=jj4iG2UgOQh9pn3OyKEA:9
X-Proofpoint-GUID: dmm0OWzrlfnJ_nARZtUwVJLvgm2Gy17A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-05_04,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505050081


Thanks Amit for the patch.

Amit Machhiwal <amachhiw@linux.ibm.com> writes:
> The commit 9576730d0e6e ("KVM: PPC: select IRQ_BYPASS_MANAGER") enabled
> IRQ_BYPASS_MANAGER when CONFIG_KVM was set. Subsequently, commit
> c57875f5f9be ("KVM: PPC: Book3S HV: Enable IRQ bypass") enabled IRQ
> bypass and added the necessary callbacks to create/remove the mappings
> between host real IRQ and the guest GSI.
>
> The availability of IRQ bypass is determined by the arch-specific
> function kvm_arch_has_irq_bypass(), which invokes
> kvmppc_irq_bypass_add_producer_hv(). This function, in turn, calls
> kvmppc_set_passthru_irq_hv() to create a mapping in the passthrough IRQ
> map, associating a host IRQ to a guest GSI.
>
> However, when a pSeries KVM guest (L2) is booted within an LPAR (L1)
> with the kernel boot parameter `xive=off`, it defaults to using emulated
> XICS controller. As an attempt to establish host IRQ to guest GSI
> mappings via kvmppc_set_passthru_irq() on a PCI device hotplug
> (passhthrough) operation fail, returning -ENOENT. This failure occurs
> because only interrupts with EOI operations handled through OPAL calls
> (verified via is_pnv_opal_msi()) are currently supported.
>
> These mapping failures lead to below repeated warnings in the L1 host:
>
>  [  509.220349] kvmppc_set_passthru_irq_hv: Could not assign IRQ map for (58,4970)
>  [  509.220368] kvmppc_set_passthru_irq (irq 58, gsi 4970) fails: -2
>  [  509.220376] vfio-pci 0015:01:00.0: irq bypass producer (token 0000000090bc635b) registration fails: -2
>  ...
>  [  509.291781] vfio-pci 0015:01:00.0: irq bypass producer (token 000000003822eed8) registration fails: -2
>
> Fix this by restricting IRQ bypass enablement on pSeries systems by
> making the IRQ bypass callbacks unavailable when running on pSeries
> platform.
>
> Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>

Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 19f4d298dd17..7667563fb9ff 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -6541,10 +6541,6 @@ static struct kvmppc_ops kvm_ops_hv = {
>  	.fast_vcpu_kick = kvmppc_fast_vcpu_kick_hv,
>  	.arch_vm_ioctl  = kvm_arch_vm_ioctl_hv,
>  	.hcall_implemented = kvmppc_hcall_impl_hv,
> -#ifdef CONFIG_KVM_XICS
> -	.irq_bypass_add_producer = kvmppc_irq_bypass_add_producer_hv,
> -	.irq_bypass_del_producer = kvmppc_irq_bypass_del_producer_hv,
> -#endif
>  	.configure_mmu = kvmhv_configure_mmu,
>  	.get_rmmu_info = kvmhv_get_rmmu_info,
>  	.set_smt_mode = kvmhv_set_smt_mode,
> @@ -6662,6 +6658,22 @@ static int kvmppc_book3s_init_hv(void)
>  		return r;
>  	}
>  
> +#if defined(CONFIG_KVM_XICS)
> +	/*
> +	 * IRQ bypass is supported only for interrupts whose EOI operations are
> +	 * handled via OPAL calls. Therefore, register IRQ bypass handlers
> +	 * exclusively for PowerNV KVM when booted with 'xive=off', indicating
> +	 * the use of the emulated XICS interrupt controller.
> +	 */
> +	if (!kvmhv_on_pseries()) {
> +		pr_info("KVM-HV: Enabling IRQ bypass\n");
> +		kvm_ops_hv.irq_bypass_add_producer =
> +			kvmppc_irq_bypass_add_producer_hv;
> +		kvm_ops_hv.irq_bypass_del_producer =
> +			kvmppc_irq_bypass_del_producer_hv;
> +	}
> +#endif
> +
>  	kvm_ops_hv.owner = THIS_MODULE;
>  	kvmppc_hv_ops = &kvm_ops_hv;
>  
>
> base-commit: 6e3597f12dce7d5041e604fec3602493e38c330a
> -- 
> 2.49.0
>

-- 
Cheers
~ Vaibhav

