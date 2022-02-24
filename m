Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9968C4C3012
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiBXPmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiBXPmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:42:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2999E22B21
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645717298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xuMjKVGR/jVvgBVEBU3vzYtHjnPOr6KHeu2jai7Auf4=;
        b=HwkX2Jm6eZDmrNoyhHKa0WYoffC3Xb4t9AzyjERUZqNs3ncLdVqD2eIpgFv6GjYp6upmhE
        +d2arOB098kAsztFMO5lYTUFzG58xuXq799blmrofi+2bSoC87CFBbSuOvyxaGFNJNb/GD
        eE89YhBhQc6UV3c1LR1/Xsx0OhN9yic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-kSoJEMyBOvWz4amlMsksdw-1; Thu, 24 Feb 2022 10:41:34 -0500
X-MC-Unique: kSoJEMyBOvWz4amlMsksdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A207824FA6;
        Thu, 24 Feb 2022 15:41:33 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 323EB12E00;
        Thu, 24 Feb 2022 15:41:31 +0000 (UTC)
Message-ID: <667adbb56835c359fbdbacefe4ecdf1153b0c126.camel@redhat.com>
Subject: Re: [PATCH v2 15/18] KVM: x86/mmu: rename kvm_mmu_new_pgd,
 introduce variant that calls get_guest_pgd
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 24 Feb 2022 17:41:30 +0200
In-Reply-To: <YhAI2rq9ms+rhFy5@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-16-pbonzini@redhat.com>
         <ae3002da-e931-1e08-7a23-8cd296bf8313@redhat.com>
         <YhAI2rq9ms+rhFy5@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

On Fri, 2022-02-18 at 21:00 +0000, Sean Christopherson wrote:
> On Fri, Feb 18, 2022, Paolo Bonzini wrote:
> > On 2/17/22 22:03, Paolo Bonzini wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index adcee7c305ca..9800c8883a48 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -1189,7 +1189,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > >   		return 1;
> > >   	if (cr3 != kvm_read_cr3(vcpu))
> > > -		kvm_mmu_new_pgd(vcpu, cr3);
> > > +		kvm_mmu_update_root(vcpu);
> > >   	vcpu->arch.cr3 = cr3;
> > >   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > 
> > Uh-oh, this has to become:
> > 
> >  	vcpu->arch.cr3 = cr3;
> >  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > 	if (!is_pae_paging(vcpu))
> > 		kvm_mmu_update_root(vcpu);
> > 
> > The regression would go away after patch 16, but this is more tidy apart
> > from having to check is_pae_paging *again*.
> > 
> > Incremental patch:
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index adcee7c305ca..0085e9fba372 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1188,11 +1189,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> >  		return 1;
> > -	if (cr3 != kvm_read_cr3(vcpu))
> > -		kvm_mmu_update_root(vcpu);
> > -
> >  	vcpu->arch.cr3 = cr3;
> >  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> > +	if (!is_pae_paging(vcpu))
> > +		kvm_mmu_update_root(vcpu);
> > +
> >  	/* Do not call post_set_cr3, we do not get here for confidential guests.  */
> > 
> > An alternative is to move the vcpu->arch.cr3 update in load_pdptrs.
> > Reviewers, let me know if you prefer that, then I'll send v3.
> 
>   c) None of the above.
> 
> MOV CR3 never requires a new root if TDP is enabled, and the guest_mmu is used if
> and only if TDP is enabled.  Even when KVM intercepts CR3 when EPT=1 && URG=0, it
> does so only to snapshot vcpu->arch.cr3, there's no need to get a new PGD.
> 
> Unless I'm missing something, your original suggestion of checking tdp_enabled is
> the way to go.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6e0f7f22c6a7..2b02029c63d0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1187,7 +1187,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>         if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>                 return 1;
> 
> -       if (cr3 != kvm_read_cr3(vcpu))
> +       if (!tdp_enabled && cr3 != kvm_read_cr3(vcpu))
>                 kvm_mmu_new_pgd(vcpu, cr3);
> 
>         vcpu->arch.cr3 = cr3;
> 
> 

Is this actually related to the discussion? The original issue that Paolo found in his patch
was that kvm_mmu_update_root now reads _current_ cr3, thus it has to be set before calling it.

I do agree that kvm_set_cr3 doesn't need to do anything when TDP is enabled, this is a different
issue which doesn't cause much harm (the fast_pgd_switch with direct roots will reuse current root),
but still would raise KVM_REQ_LOAD_MMU_PGD without need for it and such.

About the patch itself, other than this mentioned issue, it looks fine to me.


Best regards,
	Maxim Levitsky


