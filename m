Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632882833DB
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 12:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgJEKLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 06:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbgJEKLR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 06:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601892675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R50DKcPPsbQU/Khitb+DgQc6yH+QZT9+1roxeW7CMA8=;
        b=HTDYMCrChU3Y5plUgiMlVPwzNsE5bqW4W+Uye8MQ0PYLnDK8Gbl00c/htDSwmj91EFlqI/
        kkZHbfekFDoKQQoHvNPs+4AV9co9uYALyl+Owf70E/W/Zt7VOFB9KQ+Ob0k1vMsPmWGVUc
        DDJVsIqlYKBHRVsdxUKJM8QcqeHJ6UQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-UhZxklQUOF2Wn8ZFXGYXmQ-1; Mon, 05 Oct 2020 06:11:13 -0400
X-MC-Unique: UhZxklQUOF2Wn8ZFXGYXmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5902480365A;
        Mon,  5 Oct 2020 10:11:12 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D46255C1BD;
        Mon,  5 Oct 2020 10:11:09 +0000 (UTC)
Message-ID: <a99c92d1ed04744d0829b79ff2286348fac8a420.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: allocate vcpu->arch.cpuid_entries
 dynamically
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 13:11:08 +0300
In-Reply-To: <20201001130541.1398392-3-vkuznets@redhat.com>
References: <20201001130541.1398392-1-vkuznets@redhat.com>
         <20201001130541.1398392-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-10-01 at 15:05 +0200, Vitaly Kuznetsov wrote:
> The current limit for guest CPUID leaves (KVM_MAX_CPUID_ENTRIES, 80)
> is reported to be insufficient but before we bump it let's switch to
> allocating vcpu->arch.cpuid_entries[] array dynamically. Currently,
> 'struct kvm_cpuid_entry2' is 40 bytes so vcpu->arch.cpuid_entries is
> 3200 bytes which accounts for 1/4 of the whole 'struct kvm_vcpu_arch'
> but having it pre-allocated (for all vCPUs which we also pre-allocate)
> gives us no real benefits.
> 
> Another plus of the dynamic allocation is that we now do kvm_check_cpuid()
> check before we assign anything to vcpu->arch.cpuid_nent/cpuid_entries so
> no changes are made in case the check fails.
> 
> Opportunistically remove unneeded 'out' labels from
> kvm_vcpu_ioctl_set_cpuid()/kvm_vcpu_ioctl_set_cpuid2() and return
> directly whenever possible.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/cpuid.c            | 89 +++++++++++++++++++--------------
>  arch/x86/kvm/x86.c              |  1 +
>  3 files changed, 53 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d0f77235da92..7d259e21ea04 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -637,7 +637,7 @@ struct kvm_vcpu_arch {
>  	int halt_request; /* real mode on Intel only */
>  
>  	int cpuid_nent;
> -	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
> +	struct kvm_cpuid_entry2 *cpuid_entries;
>  
>  	int maxphyaddr;
>  	int max_tdp_level;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 529348ddedc1..3fe20c4da0a6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -210,46 +210,53 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  			     struct kvm_cpuid_entry __user *entries)
>  {
>  	int r, i;
> -	struct kvm_cpuid_entry *cpuid_entries = NULL;
> +	struct kvm_cpuid_entry *e = NULL;
> +	struct kvm_cpuid_entry2 *e2 = NULL;
>  
> -	r = -E2BIG;
>  	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
> -		goto out;
> +		return -E2BIG;
> +
>  	if (cpuid->nent) {
> -		cpuid_entries = vmemdup_user(entries,
> -					     array_size(sizeof(struct kvm_cpuid_entry),
> -							cpuid->nent));
> -		if (IS_ERR(cpuid_entries)) {
> -			r = PTR_ERR(cpuid_entries);
> -			goto out;
> +		e = vmemdup_user(entries, array_size(sizeof(*e), cpuid->nent));
> +		if (IS_ERR(e))
> +			return PTR_ERR(e);
> +
> +		e2 = kvmalloc_array(cpuid->nent, sizeof(*e2), GFP_KERNEL_ACCOUNT);
> +		if (!e2) {
> +			r = -ENOMEM;
> +			goto out_free_cpuid;
>  		}
>  	}
>  	for (i = 0; i < cpuid->nent; i++) {
> -		vcpu->arch.cpuid_entries[i].function = cpuid_entries[i].function;
> -		vcpu->arch.cpuid_entries[i].eax = cpuid_entries[i].eax;
> -		vcpu->arch.cpuid_entries[i].ebx = cpuid_entries[i].ebx;
> -		vcpu->arch.cpuid_entries[i].ecx = cpuid_entries[i].ecx;
> -		vcpu->arch.cpuid_entries[i].edx = cpuid_entries[i].edx;
> -		vcpu->arch.cpuid_entries[i].index = 0;
> -		vcpu->arch.cpuid_entries[i].flags = 0;
> -		vcpu->arch.cpuid_entries[i].padding[0] = 0;
> -		vcpu->arch.cpuid_entries[i].padding[1] = 0;
> -		vcpu->arch.cpuid_entries[i].padding[2] = 0;
> +		e2[i].function = e[i].function;
> +		e2[i].eax = e[i].eax;
> +		e2[i].ebx = e[i].ebx;
> +		e2[i].ecx = e[i].ecx;
> +		e2[i].edx = e[i].edx;
> +		e2[i].index = 0;
> +		e2[i].flags = 0;
> +		e2[i].padding[0] = 0;
> +		e2[i].padding[1] = 0;
> +		e2[i].padding[2] = 0;
>  	}
> -	vcpu->arch.cpuid_nent = cpuid->nent;
> -	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
> +
> +	r = kvm_check_cpuid(e2, cpuid->nent);
>  	if (r) {
> -		vcpu->arch.cpuid_nent = 0;
> -		kvfree(cpuid_entries);
> -		goto out;
> +		kvfree(e2);
> +		goto out_free_cpuid;
>  	}
>  
> +	kvfree(vcpu->arch.cpuid_entries);
> +	vcpu->arch.cpuid_entries = e2;
> +	vcpu->arch.cpuid_nent = cpuid->nent;
> +
>  	cpuid_fix_nx_cap(vcpu);
>  	kvm_update_cpuid_runtime(vcpu);
>  	kvm_vcpu_after_set_cpuid(vcpu);
>  
> -	kvfree(cpuid_entries);
> -out:
> +out_free_cpuid:
> +	kvfree(e);
> +
>  	return r;
>  }
>  
> @@ -257,26 +264,32 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  			      struct kvm_cpuid2 *cpuid,
>  			      struct kvm_cpuid_entry2 __user *entries)
>  {
> +	struct kvm_cpuid_entry2 *e2 = NULL;
>  	int r;
>  
> -	r = -E2BIG;
>  	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
> -		goto out;
> -	r = -EFAULT;
> -	if (copy_from_user(&vcpu->arch.cpuid_entries, entries,
> -			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
> -		goto out;
> -	vcpu->arch.cpuid_nent = cpuid->nent;
> -	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
> +		return -E2BIG;
> +
> +	if (cpuid->nent) {
> +		e2 = vmemdup_user(entries, array_size(sizeof(*e2), cpuid->nent));
> +		if (IS_ERR(e2))
> +			return PTR_ERR(e2);
> +	}
> +
> +	r = kvm_check_cpuid(e2, cpuid->nent);
>  	if (r) {
> -		vcpu->arch.cpuid_nent = 0;
> -		goto out;
> +		kvfree(e2);
> +		return r;
>  	}
>  
> +	kvfree(vcpu->arch.cpuid_entries);
> +	vcpu->arch.cpuid_entries = e2;
> +	vcpu->arch.cpuid_nent = cpuid->nent;
> +
>  	kvm_update_cpuid_runtime(vcpu);
>  	kvm_vcpu_after_set_cpuid(vcpu);
> -out:
> -	return r;
> +
> +	return 0;
>  }
>  
>  int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4015a43cc8a..f8ed1bde18af 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9877,6 +9877,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	kvm_mmu_destroy(vcpu);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	free_page((unsigned long)vcpu->arch.pio_data);
> +	kvfree(vcpu->arch.cpuid_entries);
>  	if (!lapic_in_kernel(vcpu))
>  		static_key_slow_dec(&kvm_no_apic_vcpu);
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

