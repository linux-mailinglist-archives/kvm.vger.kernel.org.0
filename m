Return-Path: <kvm+bounces-3903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF836809DF6
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 09:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37FAAB20BCE
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 08:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F2C11193;
	Fri,  8 Dec 2023 08:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlJzfGFD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA10910799;
	Fri,  8 Dec 2023 08:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB4EC433C7;
	Fri,  8 Dec 2023 08:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702023333;
	bh=b2dKwJ5VRwAtWWbaaYxqyisFEjNne1OCfokDs9oJo3Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dlJzfGFDB//CEldkopVVGPtuAJR4HTTAZwmi4ZFUaFQoybRoQyvI9sdT1wxpHzK9i
	 Ljh5a/omN/96xCFqzxtOJ6BgB62yFO7JBos6z5YVszB2TLzLB/k7B2bjyBjTbrhVGy
	 nmnDzHb7ycaHHo0eYjZTxctG7O6T1wbRrwY+Xbijtx9MtQUHFL8qWj506WzkSM6AW2
	 ZM0bFbjD+3mDuKkFrTEwYJyyurgNaIjNSuWnEjv6NmWyzQH4Zh1NTTFASR+Etjx1c2
	 p4RI1Ilh63YjhJCaBAuGj06uRR4pZyTbgWPf0S3cKnEnZI8hMPLmO75E2tkiJRmSI5
	 f3Xrw+ZTpRo7Q==
X-Mailer: emacs 29.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jordan Niethe <jniethe5@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	mikey@neuling.org, paulus@ozlabs.org, sbhat@linux.ibm.com,
	gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
	amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM
Subject: Re: [PATCH 09/12] KVM: PPC: Book3S HV nestedv2: Do not call
 H_COPY_TOFROM_GUEST
In-Reply-To: <20231201132618.555031-10-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
 <20231201132618.555031-10-vaibhav@linux.ibm.com>
Date: Fri, 08 Dec 2023 13:45:24 +0530
Message-ID: <87sf4dun37.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> From: Jordan Niethe <jniethe5@gmail.com>
>
> H_COPY_TOFROM_GUEST is part of the nestedv1 API and so should not be
> called by a nestedv2 host. Do not attempt to call it.
>

May be we should use
firmware_has_feature(FW_FEATURE_H_COPY_TOFROM_GUEST))?

the nestedv2 can end up using the above hcall if it is supported by the
hypervisor right? In its absence we will have to translate the guest ea
using xlate and then use kvm_guest_read to read location using the guest
real address right? That xlate will also involves multiple kvm_guest_read.


> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index 916af6c153a5..4a1abb9f7c05 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -40,6 +40,9 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
>  	unsigned long quadrant, ret = n;
>  	bool is_load = !!to;
>  
> +	if (kvmhv_is_nestedv2())
> +		return H_UNSUPPORTED;
> +
>  	/* Can't access quadrants 1 or 2 in non-HV mode, call the HV to do it */
>  	if (kvmhv_on_pseries())
>  		return plpar_hcall_norets(H_COPY_TOFROM_GUEST, lpid, pid, eaddr,
> -- 
> 2.42.0

