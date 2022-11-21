Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077EF632411
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 14:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKUNmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 08:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiKUNmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 08:42:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B67DE8D
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 05:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669038064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mstaiqrhDRaNCkxszggzoCeLFwAnlZ3Qbi9NAf/xX+o=;
        b=P8vwTBb5OI4F7nxgQthYjBRY+l901779Ck2rewtWbxRf9wbHBvp5gdrOS8dzgaC7LazD2D
        LYhZfjkU4Khtnheu+z7DcgGTXZtlW8Q9rAzHsqjFsJm6RjIAh+xp+IDmSptn62dKbAhwqc
        ro0gOJQnFPRw8QR7+nyxd36W+Pb5Rqo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-142-LT874KQRNnyeF1YDQSGf0g-1; Mon, 21 Nov 2022 08:41:03 -0500
X-MC-Unique: LT874KQRNnyeF1YDQSGf0g-1
Received: by mail-wm1-f70.google.com with SMTP id f1-20020a1cc901000000b003cf703a4f08so3113046wmb.2
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 05:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mstaiqrhDRaNCkxszggzoCeLFwAnlZ3Qbi9NAf/xX+o=;
        b=JO+oS79FmEasCJ90Lb4azjnP3L7nlXhQ/RPabi74nynrOtbp40dUYi7aOnKXevu/IZ
         ZZoNxuLbCOLw8rVdQLDiIfy3D0zptOnyXB3113OMbpU+rg6TbsU8KSxpnQXvEKcZmknp
         7HFhosl4b1vBR8yTxP7ELU0Bh77KXyG/ZusTdiT7/lp/P0ZIMWutRLCId+iJtTKlin7I
         YVq3cC9jJ8nh1lniuH32/UuNil/gmq4JibhDrYTAo8ww0lzN9P5xycXbhjfh1CB63FsI
         bRDX5EX0g2nKcl0WeyJiNF+8Fv6yIw9G+er4E+8+xL82T/0quvgKknTnOV/YihyY+mDY
         BdQA==
X-Gm-Message-State: ANoB5pkvrrDgJX/VrCQsUu4UojHktnITHIFUyLXwnlCXQ4tn+xBjvViA
        Xzcz8Rw/UHrFPVG8HWVI/0d9sYWTRrNzMZVPk4xNMjTx2VkpCwJyvoJWdX2stRyUSRxa9PnRCj0
        pP3wuQ6u8BKBL
X-Received: by 2002:a1c:29c5:0:b0:3cf:6263:bfc5 with SMTP id p188-20020a1c29c5000000b003cf6263bfc5mr16840740wmp.137.1669038061867;
        Mon, 21 Nov 2022 05:41:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4WV7JN+rssL98oRF8ZCxgUq/vOaL5AFdYaeeGmoGE+5KsLLOZKuzdeHPXfX7wytIhDCmYRdg==
X-Received: by 2002:a1c:29c5:0:b0:3cf:6263:bfc5 with SMTP id p188-20020a1c29c5000000b003cf6263bfc5mr16840705wmp.137.1669038061537;
        Mon, 21 Nov 2022 05:41:01 -0800 (PST)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id c20-20020adfa314000000b00241d21d4652sm4469994wrb.21.2022.11.21.05.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 05:41:01 -0800 (PST)
Message-ID: <5b6f1df705804c78c518371a73b2f9db340a9546.camel@redhat.com>
Subject: Re: [PATCH 09/13] KVM: SVM: allow NMI window with vNMI
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Date:   Mon, 21 Nov 2022 15:40:59 +0200
In-Reply-To: <Y3Z7sq42Ao/qRn0u@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
         <20221117143242.102721-10-mlevitsk@redhat.com>
         <Y3Z7sq42Ao/qRn0u@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-17 at 18:21 +0000, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> > When the vNMI is enabled, the only case when the KVM will use an NMI
> > window is when the vNMI injection is pending.
> > 
> > In this case on next IRET/RSM/STGI, the injection has to be complete
> > and a new NMI can be injected.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index cfec4c98bb589b..eaa30f8ace518d 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2477,7 +2477,10 @@ static int iret_interception(struct kvm_vcpu *vcpu)
> >         struct vcpu_svm *svm = to_svm(vcpu);
> >  
> >         ++vcpu->stat.nmi_window_exits;
> > -       vcpu->arch.hflags |= HF_IRET_MASK;
> > +
> > +       if (!is_vnmi_enabled(svm))
> > +               vcpu->arch.hflags |= HF_IRET_MASK;
> 
> Ugh, HF_IRET_MASK is such a terrible name/flag.  Given that it lives with GIF
> and NMI, one would naturally think that it means "IRET is intercepted", but it
> really means "KVM just intercepted an IRET and is waiting for NMIs to become
> unblocked".
> 
> And on a related topic, why on earth are GIF, NMI, and IRET tracked in hflags?
> They are 100% SVM concepts.  IMO, this code would be much easier to follow if
> by making them bools in vcpu_svm with more descriptive names.
> 
> > +
> >         if (!sev_es_guest(vcpu->kvm)) {
> >                 svm_clr_intercept(svm, INTERCEPT_IRET);
> >                 svm->nmi_iret_rip = kvm_rip_read(vcpu);
> 
> The vNMI interaction with this logic is confusing, as nmi_iret_rip doesn't need
> to be captured for the vNMI case.  SEV-ES actually has unrelated reasons for not
> reading RIP vs. not intercepting IRET, they just got bundled together here for
> convenience.
Yes, this can be cleaned up, again I didn't want to change too much of the code.


> 
> This is also an opportunity to clean up the SEV-ES interaction with IRET interception,
> which is splattered all over the place and isn't documented anywhere.
> 
> E.g. (with an HF_IRET_MASK => awaiting_iret_completion change)
> 
> /*
>  * For SEV-ES guests, KVM must not rely on IRET to detect NMI unblocking as
>  * #VC->IRET in the guest will result in KVM thinking NMIs are unblocked before
>  * the guest is ready for a new NMI.  Architecturally, KVM is 100% correct to
>  * treat NMIs as unblocked on IRET, but the guest-host ABI for SEV-ES guests is
>  * that KVM must wait for an explicit "NMI Complete" from the guest.
>  */
> static void svm_disable_iret_interception(struct vcpu_svm *svm)
> {
>         if (!sev_es_guest(svm->vcpu.kvm))
>                 svm_clr_intercept(svm, INTERCEPT_IRET);
> }
> 
> static void svm_enable_iret_interception(struct vcpu_svm *svm)
> {
>         if (!sev_es_guest(svm->vcpu.kvm))
>                 svm_set_intercept(svm, INTERCEPT_IRET);
> }

This makes sense, but doesn't have to be done in this patch series IMHO.
> 
> static int iret_interception(struct kvm_vcpu *vcpu)
> {
>         struct vcpu_svm *svm = to_svm(vcpu);
> 
>         ++vcpu->stat.nmi_window_exits;
> 
>         /*
>          * No need to wait for the IRET to complete if vNMIs are enabled as
>          * hardware will automatically process the pending NMI when NMIs are
>          * unblocked from the guest's perspective.
>          */
>         if (!is_vnmi_enabled(svm)) {
>                 svm->awaiting_iret_completion = true;
> 
>                 /*
>                  * The guest's RIP is inaccessible for SEV-ES guests, just
>                  * assume forward progress was made on the next VM-Exit.
>                  */
>                 if (!sev_es_guest(vcpu->kvm))
>                         svm->nmi_iret_rip = kvm_rip_read(vcpu);
>         }
> 
>         svm_disable_iret_interception(svm);
> 
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
>         return 1;
> }

> > @@ -3735,9 +3738,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> >  {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > -       if (is_vnmi_enabled(svm))
> > -               return;
> > -
> >         if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
> >                 return; /* IRET will cause a vm exit */
> 
> As much as I like incremental patches, in this case I'm having a hell of a time
> reviewing the code as the vNMI logic ends up being split across four patches.
> E.g. in this particular case, the above requires knowing that svm_inject_nmi()
> never sets HF_NMI_MASK when vNMI is enabled.
> 
> In the next version, any objection to squashing patches 7-10 into a single "Add
> non-nested vNMI support" patch?

No objection at all - again since this is not my patch series, I didn't want
to make too many invasive changes to it.


> 
> As for this code, IMO some pre-work to change the flow would help with the vNMI
> case.  The GIF=0 logic overrides legacy NMI blocking, and so can be handled first.
> And I vote to explicitly set INTERCEPT_IRET in the above case instead of relying
> on INTERCEPT_IRET to already be set by svm_inject_nmi().
> 
> That would yield this as a final result:
> 
> static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> {
>         struct vcpu_svm *svm = to_svm(vcpu);
> 
>         /*
>          * GIF=0 blocks NMIs irrespective of legacy NMI blocking.  No need to
>          * intercept or single-step IRET if GIF=0, just intercept STGI.
>          */
>         if (!gif_set(svm)) {
>                 if (vgif)
>                         svm_set_intercept(svm, INTERCEPT_STGI);
>                 return;
>         }
> 
>         /*
>          * NMI is blocked, either because an NMI is in service or because KVM
>          * just injected an NMI.  If KVM is waiting for an intercepted IRET to
>          * complete, single-step the IRET to wait for NMIs to become unblocked.
>          * Otherwise, intercept the guest's next IRET.
>          */
>         if (svm->awaiting_iret_completion) {
>                 svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
>                 svm->nmi_singlestep = true;
>                 svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>         } else {
>                 svm_set_intercept(svm, INTERCEPT_IRET);
>         }
> }
> 
> >  
> > @@ -3751,9 +3751,14 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> >          * Something prevents NMI from been injected. Single step over possible
> >          * problem (IRET or exception injection or interrupt shadow)
> >          */
> > -       svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> > -       svm->nmi_singlestep = true;
> > -       svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> > +
> > +       if (is_vnmi_enabled(svm)) {
> > +               svm_set_intercept(svm, INTERCEPT_IRET);
> 
> This will break SEV-ES.  Per commit 4444dfe4050b ("KVM: SVM: Add NMI support for
> an SEV-ES guest"), the hypervisor must not rely on IRET interception to detect
> NMI unblocking for SEV-ES guests.  As above, I think we should provide helpers to
> toggle NMI interception to reduce the probability of breaking SEV-ES.
Yes, one more reason for the helpers, I didn't notice that I missed that 'if'.


> 
> > +       } else {
> > +               svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> > +               svm->nmi_singlestep = true;
> > +               svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> > +       }
> >  }
> >  
> >  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> > -- 
> > 2.34.3
> > 
> 
Best regards,
	Maxim Levitsky

