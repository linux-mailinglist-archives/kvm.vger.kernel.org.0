Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11604C9174
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiCARZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiCARZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:25:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BB5B56C25
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646155514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lAGFwZP7c6Ssd0556FX8EgEfFtnLFUHmrgYIYwA5APo=;
        b=QVDLmpwpDX9ulTcXT/qjnRLojHT/ATcSB8bEl1UgAL+OpvCLHBiMAAzuEJB5SPs9dWcnsO
        mosgGpoIzhzbc0AqV/s8cM/B1eh/NmtKf1GI0U5gjMEWd/Vp71el/EaN2DJ484vcaoYciX
        P+zQoW2PF/4IPCAOqxbPa2hls595xoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-kdgfzQowOyez9JiGPNW3KA-1; Tue, 01 Mar 2022 12:25:10 -0500
X-MC-Unique: kdgfzQowOyez9JiGPNW3KA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D6DB51E0;
        Tue,  1 Mar 2022 17:25:09 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 483C87A55C;
        Tue,  1 Mar 2022 17:25:05 +0000 (UTC)
Message-ID: <603d78c516d10119c833ff54367b63b7a66f32b3.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: SVM: use vmcb01 in avic_init_vmcb
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Tue, 01 Mar 2022 19:25:04 +0200
In-Reply-To: <Yh5H8qRhbefuD9YF@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-4-mlevitsk@redhat.com> <Yh5H8qRhbefuD9YF@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-01 at 16:21 +0000, Sean Christopherson wrote:
> Just "KVM: SVM:" for the shortlog, please.
> 
> On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > Out of precation use vmcb01 when enabling host AVIC.
> > No functional change intended.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index e23159f3a62ba..9656e192c646b 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -167,7 +167,7 @@ int avic_vm_init(struct kvm *kvm)
> >  
> >  void avic_init_vmcb(struct vcpu_svm *svm)
> >  {
> > -	struct vmcb *vmcb = svm->vmcb;
> > +	struct vmcb *vmcb = svm->vmcb01.ptr;
> 
> I don't like this change.  It's not bad code, but it'll be confusing because it
> implies that it's legal for svm->vmcb to be something other than svm->vmcb01.ptr
> when this is called.

Honestly I don't see how you had reached this conclusion.
 
I just think that code that always works on vmcb01
should use it, even if it happens that vmcb == vmcb01.
 
If you insist I can drop this patch or add WARN_ON instead,
I just think that this way is cleaner.
 
Best regards,
	Maxim Levitsky

> 
> If we want to guard AVIC, I'd much rather we do something like:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7038c76fa841..dcc856bd628d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -992,8 +992,12 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>  static void init_vmcb(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> -       struct vmcb_control_area *control = &svm->vmcb->control;
> -       struct vmcb_save_area *save = &svm->vmcb->save;
> +       struct vmcb *vmcb = svm->vmcb01.ptr;
> +       struct vmcb_control_area *control = &vmcb->control;
> +       struct vmcb_save_area *save = &vmcb->save;
> +
> +       if (WARN_ON_ONCE(vmcb != svm->vmcb))
> +               svm_leave_nested(vcpu);
> 
>         svm_set_intercept(svm, INTERCEPT_CR0_READ);
>         svm_set_intercept(svm, INTERCEPT_CR3_READ);
> 
> 
> On a related topic, init_vmcb_after_set_cpuid() is broken for nested, it needs to
> play nice with being called when svm->vmcb == &svm->nested.vmcb02, e.g. update
> vmcb01 and re-merge (or just recalc?) vmcb02's intercepts.
> 
> >  	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
> >  	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
> >  	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
> > -- 
> > 2.26.3
> > 


