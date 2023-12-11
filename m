Return-Path: <kvm+bounces-4015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0DB80C032
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 05:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBF67B209C7
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 04:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E6918051;
	Mon, 11 Dec 2023 04:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kr8Kvwnz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ECE168B5;
	Mon, 11 Dec 2023 04:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142F1C433C7;
	Mon, 11 Dec 2023 04:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702267285;
	bh=5f+pnIiwqhlNQ1ca5+25Zh7b1thsDYAT5RqL0yc+DLw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Kr8KvwnzfaXk+DpQ5+JrMYbrF0txJNWuHCTDeo08vTW3cgZlYGPxVpjASqXmbX2mN
	 3MwBjg3n3yhzzBzMLP4hK3TqRYhjfeE+FeiWXO5sSdYB8Jvo/pQBxEoVOp9PjgnFiW
	 g5hdEaoiLv2yavK4NUi11c5fPLzQUh9DNJVLeM3e8rQdxcYJc9dGoYi6bNHDs1VREf
	 XAAn5cPxNzPCOMAMyucSoHQoSImGNduKYlhulcdLHV4hJq8zE1fSV/IKnoIlzSiDNG
	 ObhM+VTrq55UZIQ7LPCnhn2TfJ64pWYclUhWuzlza5GCLNd24xB0IFzUG4KF5rgrrA
	 MnDrs421pFdmQ==
Message-ID: <086fb48f-ea7c-4b4e-b3b5-c930aa74bbb2@kernel.org>
Date: Mon, 11 Dec 2023 09:31:17 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] KVM: PPC: Book3S HV nestedv2: Do not call
 H_COPY_TOFROM_GUEST
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Jordan Niethe <jniethe5@gmail.com>,
 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
 paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
 kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
 David.Laight@ACULAB.COM
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
 <20231201132618.555031-10-vaibhav@linux.ibm.com> <87sf4dun37.fsf@kernel.org>
 <87jzplmlx5.fsf@vajain21.in.ibm.com>
Content-Language: en-US
From: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
In-Reply-To: <87jzplmlx5.fsf@vajain21.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/23 9:26 AM, Vaibhav Jain wrote:
> Hi Aneesh,
> 
> Thanks for looking into this patch. My responses inline:
> 
> "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org> writes:
> 
> <snip>
>> May be we should use 
>> firmware_has_feature(FW_FEATURE_H_COPY_TOFROM_GUEST))?
>> 
>> the nestedv2 can end up using the above hcall if it is supported by
>> the hypervisor right? In its absence we will have to translate the
>> guest ea using xlate and then use kvm_guest_read to read location
>> using the guest real address right? That xlate will also involves
>> multiple kvm_guest_read.
>> 
>> 
> Yes, Agreed and thats a nice suggestion. However ATM the hypervisor 
> supporting Nestedv2 doesnt have support for this hcall. In future
> once we have support for this hcall for nestedv2 from the hypervisor
> we can replace this branch with a firmware_has_feature() test.
> 

What I am suggesting is we convert that conditional to firmware_has_feature so that
later when hypervisor supports this hcall all older kernel can make
use of the copy_tofrom_guest without any code change.

>>> Signed-off-by: Jordan Niethe <jniethe5@gmail.com> --- 
>>> arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 +++ 1 file changed, 3
>>> insertions(+)
>>> 
>>> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c
>>> b/arch/powerpc/kvm/book3s_64_mmu_radix.c index
>>> 916af6c153a5..4a1abb9f7c05 100644 ---
>>> a/arch/powerpc/kvm/book3s_64_mmu_radix.c +++
>>> b/arch/powerpc/kvm/book3s_64_mmu_radix.c @@ -40,6 +40,9 @@
>>> unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid, 
>>> unsigned long quadrant, ret = n; bool is_load = !!to;
>>> 
>>> +	if (kvmhv_is_nestedv2()) +		return H_UNSUPPORTED; + /* Can't
>>> access quadrants 1 or 2 in non-HV mode, call the HV to do it */ 
>>> if (kvmhv_on_pseries()) return
>>> plpar_hcall_norets(H_COPY_TOFROM_GUEST, lpid, pid, eaddr, -- 
>>> 2.42.0
> 


