Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D43F45FD
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 09:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhHWHup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 03:50:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234940AbhHWHun (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 03:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629705000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YI9mODFE7ZG2/TugySsD+PtrWlm3HVDvp/PwN79nkNM=;
        b=LaMMM+8cwjxM7XXDFZRsAtSoWYZAUBe6InD3/dUCfDr8bvIK8BNAu2JftzbmIhp9KUkRIF
        I8wel4/Arhplcdq2b1JwzZQUN/CuXO20bxF5MqWbsfbI0AAzJtwjhv3uSoG0ZRmRsvRQRI
        7hR0pIDVjq4YqLSmdPdtsojQgXw/Cdc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-k7U9e8XEODqwMo9t9ckC_w-1; Mon, 23 Aug 2021 03:49:59 -0400
X-MC-Unique: k7U9e8XEODqwMo9t9ckC_w-1
Received: by mail-wr1-f72.google.com with SMTP id h6-20020a5d4fc6000000b00157503046afso793659wrw.3
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 00:49:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YI9mODFE7ZG2/TugySsD+PtrWlm3HVDvp/PwN79nkNM=;
        b=hzifzf65mgLegLIpQyokbZRCROx51/WJo6zL9SZEaYvzoZjU7hlkOKi85x1BMymSQf
         61pjBi7zobe1+ru+5SkIapjOgcUW5ahZ2KfobGAzFIhKBDQ0s7CFU+9L0kk85kgzgFy3
         lF3WI3EjvONYqlOD/RuGSGwANq7xdoPne7mxZ+EIzcZfo8zs7eK51BBWfVnluy4VmrWU
         Fxmr9JtfJAHhX85/PrGkJnnpwvJeSqyKKr3+CMHHOnE7TXzKJMaG5svGOU/g/2qSMZAg
         MeYCf6dsKpX8Fa8Y4KBeuQx+vLUpxAs9wUvNZKnuosZ3+B9Vfk74V0kvHN5szDnGVGJY
         Ejfw==
X-Gm-Message-State: AOAM531D2q9B/FnoGf2Fivf9RI9IzsZFZm7aFdtaA/i5fmygJ6e7BdoE
        dLFM4C/NvobQZVzR4eTyexbGI+blFLSYpUedWMiXWS/Nt3rHqf66pIZhYDkI0Jif7x0Iw7Pj2gO
        /dn9MFsM1LocZ
X-Received: by 2002:a7b:c102:: with SMTP id w2mr15076386wmi.133.1629704997894;
        Mon, 23 Aug 2021 00:49:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQl0clINVMqkN1OBYJDnUSH/WrFTTXbg/dGDhhRJA8kPs0zHjnzvVIVk0xrbXpI9DT5n+2Vw==
X-Received: by 2002:a7b:c102:: with SMTP id w2mr15076367wmi.133.1629704997609;
        Mon, 23 Aug 2021 00:49:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s13sm17575612wmc.47.2021.08.23.00.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 00:49:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] KVM: Clean up benign vcpu->cpu data races when
 kicking vCPUs
In-Reply-To: <20210821000501.375978-2-seanjc@google.com>
References: <20210821000501.375978-1-seanjc@google.com>
 <20210821000501.375978-2-seanjc@google.com>
Date:   Mon, 23 Aug 2021 09:49:56 +0200
Message-ID: <874kbglhwb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Fix a benign data race reported by syzbot+KCSAN[*] by ensuring vcpu->cpu
> is read exactly once, and by ensuring the vCPU is booted from guest mode
> if kvm_arch_vcpu_should_kick() returns true.  Fix a similar race in
> kvm_make_vcpus_request_mask() by ensuring the vCPU is interrupted if
> kvm_request_needs_ipi() returns true.
>
> Reading vcpu->cpu before vcpu->mode (via kvm_arch_vcpu_should_kick() or
> kvm_request_needs_ipi()) means the target vCPU could get migrated (change
> vcpu->cpu) and enter !OUTSIDE_GUEST_MODE between reading vcpu->cpud and
> reading vcpu->mode.  If that happens, the kick/IPI will be sent to the
> old pCPU, not the new pCPU that is now running the vCPU or reading SPTEs.
>
> Although failing to kick the vCPU is not exactly ideal, practically
> speaking it cannot cause a functional issue unless there is also a bug in
> the caller, and any such bug would exist regardless of kvm_vcpu_kick()'s
> behavior.
>
> The purpose of sending an IPI is purely to get a vCPU into the host (or
> out of reading SPTEs) so that the vCPU can recognize a change in state,
> e.g. a KVM_REQ_* request.  If vCPU's handling of the state change is
> required for correctness, KVM must ensure either the vCPU sees the change
> before entering the guest, or that the sender sees the vCPU as running in
> guest mode.  All architectures handle this by (a) sending the request
> before calling kvm_vcpu_kick() and (b) checking for requests _after_
> setting vcpu->mode.
>
> x86's READING_SHADOW_PAGE_TABLES has similar requirements; KVM needs to
> ensure it kicks and waits for vCPUs that started reading SPTEs _before_
> MMU changes were finalized, but any vCPU that starts reading after MMU
> changes were finalized will see the new state and can continue on
> uninterrupted.
>
> For uses of kvm_vcpu_kick() that are not paired with a KVM_REQ_*, e.g.
> x86's kvm_arch_sync_dirty_log(), the order of the kick must not be relied
> upon for functional correctness, e.g. in the dirty log case, userspace
> cannot assume it has a 100% complete log if vCPUs are still running.
>
> All that said, eliminate the benign race since the cost of doing so is an
> "extra" atomic cmpxchg() in the case where the target vCPU is loaded by
> the current pCPU or is not loaded at all.  I.e. the kick will be skipped
> due to kvm_vcpu_exiting_guest_mode() seeing a compatible vcpu->mode as
> opposed to the kick being skipped because of the cpu checks.
>
> Keep the "cpu != me" checks even though they appear useless/impossible at
> first glance.  x86 processes guest IPI writes in a fast path that runs in
> IN_GUEST_MODE, i.e. can call kvm_vcpu_kick() from IN_GUEST_MODE.  And
> calling kvm_vm_bugged()->kvm_make_vcpus_request_mask() from IN_GUEST or
> READING_SHADOW_PAGE_TABLES is perfectly reasonable.
>
> Note, a race with the cpu_online() check in kvm_vcpu_kick() likely
> persists, e.g. the vCPU could exit guest mode and get offlined between
> the cpu_online() check and the sending of smp_send_reschedule().  But,
> the online check appears to exist only to avoid a WARN in x86's
> native_smp_send_reschedule() that fires if the target CPU is not online.
> The reschedule WARN exists because CPU offlining takes the CPU out of the
> scheduling pool, i.e. the WARN is intended to detect the case where the
> kernel attempts to schedule a task on an offline CPU.  The actual sending
> of the IPI is a non-issue as at worst it will simpy be dropped on the
> floor.  In other words, KVM's usurping of the reschedule IPI could
> theoretically trigger a WARN if the stars align, but there will be no
> loss of functionality.
>
> [*] https://syzkaller.appspot.com/bug?extid=cd4154e502f43f10808a
>
> Cc: Venkatesh Srinivas <venkateshs@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3e67c93ca403..786b914db98f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -273,14 +273,26 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  			continue;
>  
>  		kvm_make_request(req, vcpu);
> -		cpu = vcpu->cpu;
>  
>  		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>  			continue;
>  
> -		if (tmp != NULL && cpu != -1 && cpu != me &&
> -		    kvm_request_needs_ipi(vcpu, req))
> -			__cpumask_set_cpu(cpu, tmp);
> +		/*
> +		 * Note, the vCPU could get migrated to a different pCPU at any
> +		 * point after kvm_request_needs_ipi(), which could result in
> +		 * sending an IPI to the previous pCPU.  But, that's ok because

"OK" (unless there's risk someone will think of Oklahoma and take it as
an offense) :-)

> +		 * the purpose of the IPI is to ensure the vCPU returns to
> +		 * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
> +		 * Entering READING_SHADOW_PAGE_TABLES after this point is also
> +		 * ok, as the requirement is only that KVM wait for vCPUs that

"OK"

> +		 * were reading SPTEs _before_ any changes were finalized.  See
> +		 * kvm_vcpu_kick() for more details on handling requests.
> +		 */
> +		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
> +			cpu = READ_ONCE(vcpu->cpu);
> +			if (cpu != -1 && cpu != me)
> +				__cpumask_set_cpu(cpu, tmp);
> +		}
>  	}
>  
>  	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
> @@ -3309,16 +3321,24 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
>   */
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  {
> -	int me;
> -	int cpu = vcpu->cpu;
> +	int me, cpu;
>  
>  	if (kvm_vcpu_wake_up(vcpu))
>  		return;
>  
> +	/*
> +	 * Note, the vCPU could get migrated to a different pCPU at any point
> +	 * after kvm_arch_vcpu_should_kick(), which could result in sending an
> +	 * IPI to the previous pCPU.  But, that's ok because the purpose of the

"OK"

> +	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
> +	 * vCPU also requires it to leave IN_GUEST_MODE.
> +	 */
>  	me = get_cpu();
> -	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> -		if (kvm_arch_vcpu_should_kick(vcpu))
> +	if (kvm_arch_vcpu_should_kick(vcpu)) {
> +		cpu = READ_ONCE(vcpu->cpu);
> +		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))

It seems it was Marcelo who wrote "(unsigned)cpu < nr_cpu_ids" back in
2009 but isn't it the same as "cpu != -1" or are there any other
possible negative values? I don't think vcpu->cpu can go above
nr_cpu_ids somehow but maybe it can?

>  			smp_send_reschedule(cpu);
> +	}
>  	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

