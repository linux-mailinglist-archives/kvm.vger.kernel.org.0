Return-Path: <kvm+bounces-4577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E38C814CAB
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFEF4289275
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 16:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B3C3BB24;
	Fri, 15 Dec 2023 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzb0vRMv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77F53DB80;
	Fri, 15 Dec 2023 16:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7966C433C7;
	Fri, 15 Dec 2023 16:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702656787;
	bh=J5U0YPNa7AB26BKYS1W5zmJBF+duoWLKvJ0dL3e/X7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rzb0vRMvSulaJmQCd1WxGCX+vJoa+mxO3N+P3GvoG39ZwEN7JjohfqYCg5Ecy+BXS
	 +nwpi8PXsAyVjbgxjHz64OD09dRbSH2GXFQYUhIP9a3z3cr21ptpUwZpbqky6aKalt
	 zNLsGYL4OIza0+xnfGjj5+YA+0j1iGFG4V7H7URQk2rYsCJlUSr4SeGXRy8gauPLxl
	 aCByVKWNB84vUZwAL17bLSZpBQM7sGzft7WxCTvM6FJ7XyuCPHxF64Zie75hSS9C3Q
	 dAGP+S7uevpQQ5V4k35JQD7UQxrrrz/tzb5Z4bbvgK4TtJ2RThDjNmkA+X/6fZjcGW
	 VafUSsfRVrmMg==
X-Mailer: emacs 29.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: mikey@neuling.org, sbhat@linux.ibm.com, amachhiw@linux.vnet.ibm.com,
	Jordan Niethe <jniethe5@gmail.com>, gautam@linux.ibm.com,
	Nicholas Piggin <npiggin@gmail.com>, David.Laight@ACULAB.COM,
	kconsul@linux.vnet.ibm.com,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/12] KVM: PPC: Book3S HV nestedv2: Invalidate RPT
 before deleting a guest
In-Reply-To: <87jzpolsen.fsf@vajain21.in.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
 <20231201132618.555031-2-vaibhav@linux.ibm.com>
 <878r66xtjt.fsf@kernel.org> <87jzpolsen.fsf@vajain21.in.ibm.com>
Date: Fri, 15 Dec 2023 21:42:59 +0530
Message-ID: <87r0jntpf8.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Hi Aneesh,
>
> Thanks for looking into this patch. My responses inline below:
>
> "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org> writes:
>
>> Vaibhav Jain <vaibhav@linux.ibm.com> writes:
>>
>>> From: Jordan Niethe <jniethe5@gmail.com>
>>>
>>> An L0 must invalidate the L2's RPT during H_GUEST_DELETE if this has not
>>> already been done. This is a slow operation that means H_GUEST_DELETE
>>> must return H_BUSY multiple times before completing. Invalidating the
>>> tables before deleting the guest so there is less work for the L0 to do.
>>>
>>> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
>>> ---
>>>  arch/powerpc/include/asm/kvm_book3s.h | 1 +
>>>  arch/powerpc/kvm/book3s_hv.c          | 6 ++++--
>>>  arch/powerpc/kvm/book3s_hv_nested.c   | 2 +-
>>>  3 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
>>> index 4f527d09c92b..a37736ed3728 100644
>>> --- a/arch/powerpc/include/asm/kvm_book3s.h
>>> +++ b/arch/powerpc/include/asm/kvm_book3s.h
>>> @@ -302,6 +302,7 @@ void kvmhv_nested_exit(void);
>>>  void kvmhv_vm_nested_init(struct kvm *kvm);
>>>  long kvmhv_set_partition_table(struct kvm_vcpu *vcpu);
>>>  long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu);
>>> +void kvmhv_flush_lpid(u64 lpid);
>>>  void kvmhv_set_ptbl_entry(u64 lpid, u64 dw0, u64 dw1);
>>>  void kvmhv_release_all_nested(struct kvm *kvm);
>>>  long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu);
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>>> index 1ed6ec140701..5543e8490cd9 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -5691,10 +5691,12 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
>>>  			kvmhv_set_ptbl_entry(kvm->arch.lpid, 0, 0);
>>>  	}
>>>  
>>> -	if (kvmhv_is_nestedv2())
>>> +	if (kvmhv_is_nestedv2()) {
>>> +		kvmhv_flush_lpid(kvm->arch.lpid);
>>>  		plpar_guest_delete(0, kvm->arch.lpid);
>>>
>>
>> I am not sure I follow the optimization here. I would expect the
>> hypervisor to kill all the translation caches as part of guest_delete.
>> What is the benefit of doing a lpid flush outside the guest delete?
>>
> Thats right. However without this optimization the H_GUEST_DELETE hcall
> in plpar_guest_delete() returns H_BUSY multiple times resulting in
> multiple hcalls to the hypervisor until it finishes. Flushing the guest
> translation cache upfront reduces the number of HCALLs L1 guests has to
> make to delete a L2 guest via H_GUEST_DELETE.
>

can we add that as a comment above that kvmhv_flush_lpid()?

-aneesh

