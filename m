Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2804C3137
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiBXQ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiBXQ0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:26:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDB021CA5CF
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645719929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5E/ty6BCjTp32j5DqNHCW0OWV15E9lmdxXYdDfIJxso=;
        b=VkLdEQrZ5WgkIAaCLP4fltpSaL3Md1dU4lQ8EA75WbMRKZsJ1vKMmI+BPq6lNwu0cfrWsG
        D1eHQ8qCMPBHYHiSUzIapprvy8vNAmLcQ4kkqV9dzKoC8U7v5OkIECOyVFKGLq9zOgi2oq
        qOwcBuVMwqlyZ/q81ikFyzeq67jeKNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-M0wSZYPFMLKkPaTcXsCFlQ-1; Thu, 24 Feb 2022 11:25:26 -0500
X-MC-Unique: M0wSZYPFMLKkPaTcXsCFlQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 821761091DA3;
        Thu, 24 Feb 2022 16:25:25 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22086106F96A;
        Thu, 24 Feb 2022 16:25:23 +0000 (UTC)
Message-ID: <e007cbce513605056fd8ef973c63a9230dd77834.camel@redhat.com>
Subject: Re: [PATCH v2 18/18] KVM: x86: do not unload MMU roots on all role
 changes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Thu, 24 Feb 2022 18:25:22 +0200
In-Reply-To: <20220217210340.312449-19-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-19-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> kvm_mmu_reset_context is called on all role changes and right now it
> calls kvm_mmu_unload.  With the legacy MMU this is a relatively cheap
> operation; the previous PGDs remains in the hash table and is picked
> up immediately on the next page fault.  With the TDP MMU, however, the
> roots are thrown away for good and a full rebuild of the page tables is
> necessary, which is many times more expensive.
> 
> Fortunately, throwing away the roots is not necessary except when
> the manual says a TLB flush is required:
Actually does TLB flush throw away the roots? I think we only sync
them and keep on using them? (kvm_vcpu_flush_tlb_guest)

I can't be 100% sure but this patch 

> 
> - changing CR0.PG from 1 to 0 (because it flushes the TLB according to
>   the x86 architecture specification)
> 
> - changing CPUID (which changes the interpretation of page tables in
>   ways not reflected by the role).
> 
> - changing CR4.SMEP from 0 to 1 (not doing so actually breaks access.c)
> 
> Except for these cases, once the MMU has updated the CPU/MMU roles
> and metadata it is enough to force-reload the current value of CR3.
> KVM will look up the cached roots for an entry with the right role and
> PGD, and only if the cache misses a new root will be created.
> 
> Measuring with vmexit.flat from kvm-unit-tests shows the following
> improvement:
> 
>              TDP         legacy       shadow
>    before    46754       5096         5150
>    after     4879        4875         5006
> 
> which is for very small page tables.  The impact is however much larger
> when running as an L1 hypervisor, because the new page tables cause
> extra work for L0 to shadow them.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c44b5114f947..913cc7229bf4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5043,8 +5043,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
>  void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	/*
> -	 * Invalidate all MMU roles to force them to reinitialize as CPUID
> -	 * information is factored into reserved bit calculations.
> +	 * Invalidate all MMU roles and roots to force them to reinitialize,
> +	 * as CPUID information is factored into reserved bit calculations.
>  	 *
>  	 * Correctly handling multiple vCPU models with respect to paging and
>  	 * physical address properties) in a single VM would require tracking
> @@ -5057,6 +5057,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
>  	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
>  	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
> +	kvm_mmu_unload(vcpu);
>  	kvm_mmu_reset_context(vcpu);
>  
>  	/*
> @@ -5068,8 +5069,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
>  {
> -	kvm_mmu_unload(vcpu);
>  	kvm_init_mmu(vcpu);
> +	kvm_make_request(KVM_REQ_MMU_UPDATE_ROOT, vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
>  


How about call to kvm_mmu_reset_context in nested_vmx_restore_host_state
This is a failback path though.


Best regards,
	Maxim Levitsky

