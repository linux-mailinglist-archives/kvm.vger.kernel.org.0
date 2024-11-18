Return-Path: <kvm+bounces-32025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E416B9D177C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 18:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B7D0B23E49
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 17:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A1C1C1F08;
	Mon, 18 Nov 2024 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNSzmdiG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17AB13D279
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731952709; cv=none; b=hzqAxGmflmHt5+8N7bjP/MDAk5yw/6ITjvrghvpK1u6kblHW21o44omMSSGni7cbHSGvX4dnjov0tyrQLVJE6kG/vYswncr7DOFlVZWKYnKfyfehmBr1iEcOE/9O++lG3WyHBYk6eGX20PfjqF/127MUt2OLdHzBxgpo0qaobus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731952709; c=relaxed/simple;
	bh=JqTmRdYi1wuGDDC5+p/6Fc1NAZon9XviF0QyolxElwc=;
	h=From:To:Cc:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Zh5vL+3hSMYt4Rh3/K/e6zDlfyQqN6nM5rUGSO4D0axuiIH4IRpiksNFyOBaIjy3GWVperm/TvAJAGsuALijMqq2ntMyLLz32XY+rVaFeUDIJZOZCKx8If/+t4eD+aqrPvSIGQVigOcF3pf/Tsrq8ELAfxNX9xaBmDVDmofOyo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bNSzmdiG reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731952705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5t7mHGoD0ziOQwsQdSn42HldEeq3FwqUBLOYEJnZ86c=;
	b=bNSzmdiGwdybCchgjqO3CIZVwmC6m8yVok0nhVAdv50rP8qHAQOK1ngdJhzARZvWiIQsiX
	e8vapFXCWBPZEyZuiWtMCRZLV95g3l7QoOEkpjSLkL5KBaySy37De6MdYcxHfUZ7fgXj5F
	sVa36LW2jMtSRD8CHVPsTntGf14vtfQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-FkRnHC85PmyYAagNnZr2dg-1; Mon,
 18 Nov 2024 12:58:22 -0500
X-MC-Unique: FkRnHC85PmyYAagNnZr2dg-1
X-Mimecast-MFC-AGG-ID: FkRnHC85PmyYAagNnZr2dg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 855F41955F41;
	Mon, 18 Nov 2024 17:58:20 +0000 (UTC)
Received: from fedora (unknown [10.39.192.15])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82CF91956086;
	Mon, 18 Nov 2024 17:58:13 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: david@redhat.com, peterx@redhat.com, oleg@redhat.com, gshan@redhat.com,
 graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk,
 derekmn@amazon.com, nsaenz@amazon.es, xmarcalx@amazon.com,
 kalyazin@amazon.com
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
In-Reply-To: <20241118130403.23184-1-kalyazin@amazon.com>
References: <20241118130403.23184-1-kalyazin@amazon.com>
Date: Mon, 18 Nov 2024 18:58:03 +0100
Message-ID: <87h684ctlg.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On x86, async pagefault events can only be delivered if the page fault
> was triggered by guest userspace, not kernel.  This is because
> the guest may be in non-sleepable context and will not be able
> to reschedule.

We used to set KVM_ASYNC_PF_SEND_ALWAYS for Linux guests before

commit 3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Apr 24 09:57:56 2020 +0200

    x86/kvm: Restrict ASYNC_PF to user space

but KVM side of the feature is kind of still there, namely

kvm_pv_enable_async_pf() sets

    vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);

and then we check it in 

kvm_can_deliver_async_pf():

     if (vcpu->arch.apf.send_user_only &&
         kvm_x86_call(get_cpl)(vcpu) == 0)
             return false;

and this can still be used by some legacy guests I suppose. How about
we start with removing this completely? It does not matter if some
legacy guest wants to get an APF for CPL0, we are never obliged to
actually use the mechanism.

>
> However existing implementation pays the following overhead even for the
> kernel-originated faults, even though it is known in advance that they
> cannot be processed asynchronously:
>  - allocate async PF token
>  - create and schedule an async work
>
> This patch avoids the overhead above in case of kernel-originated faults
> by moving the `kvm_can_deliver_async_pf` check from
> `kvm_arch_async_page_not_present` to `__kvm_faultin_pfn`.
>
> Note that the existing check `kvm_can_do_async_pf` already calls
> `kvm_can_deliver_async_pf` internally, however it only does that if the
> `kvm_hlt_in_guest` check is true, ie userspace requested KVM not to exit
> on guest halts via `KVM_CAP_X86_DISABLE_EXITS`.  In that case the code
> proceeds with the async fault processing with the following
> justification in 1dfdb45ec510ba27e366878f97484e9c9e728902 ("KVM: x86:
> clean up conditions for asynchronous page fault handling"):
>
> "Even when asynchronous page fault is disabled, KVM does not want to pause
> the host if a guest triggers a page fault; instead it will put it into
> an artificial HLT state that allows running other host processes while
> allowing interrupt delivery into the guest."
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  arch/x86/kvm/x86.c     | 5 ++---
>  arch/x86/kvm/x86.h     | 2 ++
>  3 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 22e7ad235123..11d29d15b6cd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4369,7 +4369,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>  			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
>  			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
>  			return RET_PF_RETRY;
> -		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
> +		} else if (kvm_can_deliver_async_pf(vcpu) &&
> +			kvm_arch_setup_async_pf(vcpu, fault)) {
>  			return RET_PF_RETRY;
>  		}
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e713480933a..8edae75b39f7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13355,7 +13355,7 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
>  	return !val;
>  }
>  
> -static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  {
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu))
> @@ -13406,8 +13406,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
>  	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
>  
> -	if (kvm_can_deliver_async_pf(vcpu) &&
> -	    !apf_put_user_notpresent(vcpu)) {
> +	if (!apf_put_user_notpresent(vcpu)) {
>  		fault.vector = PF_VECTOR;
>  		fault.error_code_valid = true;
>  		fault.error_code = 0;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index ec623d23d13d..9647f41e5c49 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -387,6 +387,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
>  fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
>  
> +bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu);
> +
>  extern struct kvm_caps kvm_caps;
>  extern struct kvm_host_values kvm_host;
>  
>
> base-commit: d96c77bd4eeba469bddbbb14323d2191684da82a

-- 
Vitaly


