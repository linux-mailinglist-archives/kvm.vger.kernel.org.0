Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68834C1908
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbiBWQtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiBWQtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:49:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3B0310E7
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645634947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wNS7v8DyjXrywMbSXEXz4BcYOAb2F62ZEYVuLUNKYhE=;
        b=gKMl+aXn4kwEvbmiq13qXIoFuyVhzYlcN9vDhR0gG9SmB7HwdE82zquE4pyntUGXxWOEKe
        7vgIGeE7qq2lwzKmMVmfDztJY8DltMnZo4N9e2jVDWwXT4Po0jURYyt27qPk2mMWM7+gbV
        gcGV8lYxb3ufsBp5iP9mTborKZfrNxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-_9p6_WnoNaaswf3fZYCOvQ-1; Wed, 23 Feb 2022 11:48:37 -0500
X-MC-Unique: _9p6_WnoNaaswf3fZYCOvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57F20501E3;
        Wed, 23 Feb 2022 16:48:36 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2DCA804FD;
        Wed, 23 Feb 2022 16:48:34 +0000 (UTC)
Message-ID: <7ab6bb89c3413cbed9991587a4f6486f8616463b.camel@redhat.com>
Subject: Re: [PATCH v2 13/18] KVM: x86: reset and reinitialize the MMU in
 __set_sregs_common
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 18:48:33 +0200
In-Reply-To: <20220217210340.312449-14-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-14-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> Do a full unload of the MMU in KVM_SET_SREGS and KVM_SEST_REGS2, in
Typo
> preparation for not doing so in kvm_mmu_reset_context.  There is no
> need to delay the reset until after the return, so do it directly in
> the __set_sregs_common function and remove the mmu_reset_needed output
> parameter.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6aefd7ac7039..f10878aa5b20 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10730,7 +10730,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  }
>  
>  static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
> -		int *mmu_reset_needed, bool update_pdptrs)
> +			      int update_pdptrs)
>  {
>  	struct msr_data apic_base_msr;
>  	int idx;
> @@ -10755,29 +10755,31 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
>  	static_call(kvm_x86_set_gdt)(vcpu, &dt);
>  
>  	vcpu->arch.cr2 = sregs->cr2;
> -	*mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
> +
> +	if (vcpu->arch.efer != sregs->efer ||
> +	    kvm_read_cr0(vcpu) != sregs->cr0 ||
> +	    vcpu->arch.cr3 != sregs->cr3 || !update_pdptrs ||
> +	    kvm_read_cr4(vcpu) != sregs->cr4)
> +		kvm_mmu_unload(vcpu);

Should it be (update_pdptrs && is_pae_paging(vcpu)) instead?

> +
>  	vcpu->arch.cr3 = sregs->cr3;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>  	static_call_cond(kvm_x86_post_set_cr3)(vcpu, sregs->cr3);
>  
>  	kvm_set_cr8(vcpu, sregs->cr8);
>  
> -	*mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
>  	static_call(kvm_x86_set_efer)(vcpu, sregs->efer);
>  
> -	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
>  	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
>  	vcpu->arch.cr0 = sregs->cr0;
>  
> -	*mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
>  	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
>  
> +	kvm_init_mmu(vcpu);
>  	if (update_pdptrs) {
>  		idx = srcu_read_lock(&vcpu->kvm->srcu);
> -		if (is_pae_paging(vcpu)) {
> +		if (is_pae_paging(vcpu))
>  			load_pdptrs(vcpu, kvm_read_cr3(vcpu));
> -			*mmu_reset_needed = 1;
> -		}
>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	}
>  
> @@ -10805,15 +10807,11 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
>  static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  {
>  	int pending_vec, max_bits;
> -	int mmu_reset_needed = 0;
> -	int ret = __set_sregs_common(vcpu, sregs, &mmu_reset_needed, true);
> +	int ret = __set_sregs_common(vcpu, sregs, true);
>  
>  	if (ret)
>  		return ret;
>  
> -	if (mmu_reset_needed)
> -		kvm_mmu_reset_context(vcpu);
> -
>  	max_bits = KVM_NR_INTERRUPTS;
>  	pending_vec = find_first_bit(
>  		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
> @@ -10828,7 +10826,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  
>  static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
>  {
> -	int mmu_reset_needed = 0;
>  	bool valid_pdptrs = sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>  	bool pae = (sregs2->cr0 & X86_CR0_PG) && (sregs2->cr4 & X86_CR4_PAE) &&
>  		!(sregs2->efer & EFER_LMA);
> @@ -10840,8 +10837,7 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
>  	if (valid_pdptrs && (!pae || vcpu->arch.guest_state_protected))
>  		return -EINVAL;
>  
> -	ret = __set_sregs_common(vcpu, (struct kvm_sregs *)sregs2,
> -				 &mmu_reset_needed, !valid_pdptrs);
> +	ret = __set_sregs_common(vcpu, (struct kvm_sregs *)sregs2, !valid_pdptrs);
>  	if (ret)
>  		return ret;
>  
> @@ -10850,11 +10846,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
>  			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
>  
>  		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> -		mmu_reset_needed = 1;
>  		vcpu->arch.pdptrs_from_userspace = true;
> +		/* kvm_mmu_reload will be called on the next entry.  */
Could you elaborate on this? 

In theory if set_sregs2 only changed the pdptrs, without changing anything else
which won't really happen in practice but can in theory, then there will
be no mmu reset with new code IMHO.

Best regards,
	Maxim Levitsky


>  	}
> -	if (mmu_reset_needed)
> -		kvm_mmu_reset_context(vcpu);
>  	return 0;
>  }
>  


