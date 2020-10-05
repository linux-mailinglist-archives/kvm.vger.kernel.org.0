Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984F72833D9
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 12:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJEKK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 06:10:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgJEKK4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 06:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601892654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M9MWyjlVMpMDAjVPqBgv2clVXPb7AXKCtvAeLSamMYI=;
        b=G/VS1aPhUGnLEBXwsX9/yxs2iCJHsX7Hr+8wG1FkKge7vx+IciG7a3xFOWnuJjsJ/V9iWR
        f9ZFVLDqS+m7OwUJaZnIXqnBVEU7jQ0JW9BLEvxGdHGjFAZTQ/Ki6eqLAOkuhfB87OYRXA
        ubnvPhstml2AfyeFgSBp5cp69Nd2/hE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-tTjLPcNfOvm0m7T6sRMGCQ-1; Mon, 05 Oct 2020 06:10:53 -0400
X-MC-Unique: tTjLPcNfOvm0m7T6sRMGCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1DF61084D64;
        Mon,  5 Oct 2020 10:10:51 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 800E510013BD;
        Mon,  5 Oct 2020 10:10:48 +0000 (UTC)
Message-ID: <85c31c92e6775b9d8ccd088e3f61659cac1c8cae.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: disconnect kvm_check_cpuid() from
 vcpu->arch.cpuid_entries
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 13:10:47 +0300
In-Reply-To: <20201001130541.1398392-2-vkuznets@redhat.com>
References: <20201001130541.1398392-1-vkuznets@redhat.com>
         <20201001130541.1398392-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-10-01 at 15:05 +0200, Vitaly Kuznetsov wrote:
> As a preparatory step to allocating vcpu->arch.cpuid_entries dynamically
> make kvm_check_cpuid() check work with an arbitrary 'struct kvm_cpuid_entry2'
> array.
> 
> Currently, when kvm_check_cpuid() fails we reset vcpu->arch.cpuid_nent to
> 0 and this is kind of weird, i.e. one would expect CPUIDs to remain
> unchanged when KVM_SET_CPUID[2] call fails.
Since this specific patch doesn't fix this, maybe move this chunk to following patches,
or to the cover letter?

> 
> No functional change intended. It would've been possible to move the updated
> kvm_check_cpuid() in kvm_vcpu_ioctl_set_cpuid2() and check the supplied
> input before we start updating vcpu->arch.cpuid_entries/nent but we
> can't do the same in kvm_vcpu_ioctl_set_cpuid() as we'll have to copy
> 'struct kvm_cpuid_entry' entries first. The change will be made when
> vcpu->arch.cpuid_entries[] array becomes allocated dynamically.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 37c3668a774f..529348ddedc1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -54,7 +54,24 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  
>  #define F feature_bit
>  
> -static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
> +static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
> +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
> +{
> +	struct kvm_cpuid_entry2 *e;
> +	int i;
> +
> +	for (i = 0; i < nent; i++) {
> +		e = &entries[i];
> +
> +		if (e->function == function && (e->index == index ||
> +		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> +			return e;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
> @@ -62,7 +79,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
>  	 * canonical address checks; exit if it is ever changed.
>  	 */
> -	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
> +	best = cpuid_entry2_find(entries, nent, 0x80000008, 0);
>  	if (best) {
>  		int vaddr_bits = (best->eax & 0xff00) >> 8;
>  
> @@ -220,7 +237,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  		vcpu->arch.cpuid_entries[i].padding[2] = 0;
>  	}
>  	vcpu->arch.cpuid_nent = cpuid->nent;
> -	r = kvm_check_cpuid(vcpu);
> +	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
>  	if (r) {
>  		vcpu->arch.cpuid_nent = 0;
>  		kvfree(cpuid_entries);
> @@ -250,7 +267,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
>  		goto out;
>  	vcpu->arch.cpuid_nent = cpuid->nent;
> -	r = kvm_check_cpuid(vcpu);
> +	r = kvm_check_cpuid(vcpu->arch.cpuid_entries, cpuid->nent);
>  	if (r) {
>  		vcpu->arch.cpuid_nent = 0;
>  		goto out;
> @@ -940,17 +957,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  					      u32 function, u32 index)
>  {
> -	struct kvm_cpuid_entry2 *e;
> -	int i;
> -
> -	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
> -		e = &vcpu->arch.cpuid_entries[i];
> -
> -		if (e->function == function && (e->index == index ||
> -		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> -			return e;
> -	}
> -	return NULL;
> +	return cpuid_entry2_find(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent,
> +				 function, index);
>  }
>  EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
>  

Other than minor note to the commit message, this looks fine, so
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

