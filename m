Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E014428160
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 14:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhJJMvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 08:51:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232394AbhJJMvR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 Oct 2021 08:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633870158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Y/TIz/D1FsczMFThsSjVSnZBgVqamwGlHoXoCLNHrg=;
        b=iqTi+/nsiGi30qe7ijBTRqpOkCK6AMfnwbXgT360i+Hk5ChvvOHaPruka5CgW2eKXXmlay
        tmIgGOlG75kV49HEdURcX3X+SwKTVx7tub61YRpff/sBs6gSMMGe4YuQQKmGrveg8ImO44
        YLksbBhJ4uE2WRZUuOyp9UnSpNtqPp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-szayFxYCP_STVqW4nNq72g-1; Sun, 10 Oct 2021 08:49:15 -0400
X-MC-Unique: szayFxYCP_STVqW4nNq72g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7D1481426E;
        Sun, 10 Oct 2021 12:49:13 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F14F26E40;
        Sun, 10 Oct 2021 12:49:11 +0000 (UTC)
Message-ID: <c446956c622d5f6561f5248c7f686033ffc2ee69.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Simplify APICv update request logic
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Oct 2021 15:49:10 +0300
In-Reply-To: <20211009010135.4031460-3-seanjc@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
         <20211009010135.4031460-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> Drop confusing and flawed code that intentionally sets that per-VM APICv
> inhibit mask after sending KVM_REQ_APICV_UPDATE to all vCPUs.  The code
> is confusing because it's not obvious that there's no race between a CPU
> seeing the request and consuming the new mask.  The code works only
> because the request handling path takes the same lock, i.e. responding
> vCPUs will be blocked until the full update completes.

Actually this code is here on purpose:

While it is true that the main reader of apicv_inhibit_reasons (KVM_REQ_APICV_UPDATE handler)
does take the kvm->arch.apicv_update_lock lock, so it will see the correct value
regardless of this patch, the reason why this code first raises the KVM_REQ_APICV_UPDATE
and only then updates the arch.apicv_inhibit_reasons is that I put a warning into svm_vcpu_run
which checks that per cpu AVIC inhibit state matches the global AVIC inhibit state.

That warning proved to be very useful to ensure that AVIC inhibit works correctly.

If this patch is applied, the warning can no longer work reliably unless
it takes the apicv_update_lock which will have a performance hit.

The reason is that if we just update apicv_inhibit_reasons, we can race
with vCPU which is about to re-enter the guest mode and trigger this warning.

Best regards,
	Maxim Levitsky

> 
> The concept is flawed because ordering the mask update after the request
> can't be relied upon for correct behavior.  The only guarantee provided
> by kvm_make_all_cpus_request() is that all vCPUs exited the guest.  It
> does not guarantee all vCPUs are waiting on the lock.  E.g. a VCPU could
> be in the process of handling an emulated MMIO APIC access page fault
> that occurred before the APICv update was initiated, and thus toggling
> and reading the per-VM field would be racy.  If correctness matters, KVM
> either needs to use the per-vCPU status (if appropriate), take the lock,
> or have some other mechanism that guarantees the per-VM status is correct.
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4a52a08707de..960c2d196843 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9431,29 +9431,27 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
>  
>  void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  {
> -	unsigned long old, new;
> +	unsigned long old;
>  
>  	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
>  	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
>  		return;
>  
> -	old = new = kvm->arch.apicv_inhibit_reasons;
> +	old = kvm->arch.apicv_inhibit_reasons;
>  
>  	if (activate)
> -		__clear_bit(bit, &new);
> +		__clear_bit(bit, &kvm->arch.apicv_inhibit_reasons);
>  	else
> -		__set_bit(bit, &new);
> +		__set_bit(bit, &kvm->arch.apicv_inhibit_reasons);
>  
> -	if (!!old != !!new) {
> +	if (!!old != !!kvm->arch.apicv_inhibit_reasons) {
>  		trace_kvm_apicv_update_request(activate, bit);
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
> -		kvm->arch.apicv_inhibit_reasons = new;
> -		if (new) {
> +		if (kvm->arch.apicv_inhibit_reasons) {
>  			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
>  			kvm_zap_gfn_range(kvm, gfn, gfn+1);
>  		}
> -	} else
> -		kvm->arch.apicv_inhibit_reasons = new;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(__kvm_request_apicv_update);
>  


