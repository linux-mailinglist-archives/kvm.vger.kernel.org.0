Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EDE632025
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiKULQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 06:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiKULQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 06:16:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E040FC1F47
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 03:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669029011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HFE5ckJ+/PkEEqbEDcxeM6P1Mra4LAFsLM3EpugvmI=;
        b=EMLCOBkxKS6v25xXjAdge+Br8hPYZtath284xFs7yuod9WiH8RVTF1Ic+W7o2XkHu+7hPs
        0RXnqqN9HzSIDt34fTUsmbCNliMEjbGfyL3802sP/+kN4OkZwd7Qv60QwXMFqXQm6UN1M/
        sdpVVEH1M+yZFp/HwNmul0ksAIYwcHk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-265-RieP3r-fNYaAbe37F2Ysqw-1; Mon, 21 Nov 2022 06:10:10 -0500
X-MC-Unique: RieP3r-fNYaAbe37F2Ysqw-1
Received: by mail-wm1-f70.google.com with SMTP id v125-20020a1cac83000000b003cfa148576dso6342538wme.3
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 03:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6HFE5ckJ+/PkEEqbEDcxeM6P1Mra4LAFsLM3EpugvmI=;
        b=zUypVp52GbhI8mu/hycF7TI2GGotC7xkLKV5poZomlHPyTKQpdPkcbA37iSEGKKG3I
         nOv1JGSrFIAXxryHSPnx4zghaDk+wDiBlNj3soPZPhtudpyNAGhakzeZU4Uy/wO/dYE6
         cFGnX2Mw3oW92fkaCmeKggsvl48pQi5hBpiyfOYFOZt0w0xAq/l5Wzxhol3jtuH9mpur
         iAF00HaChLDiOC1aASS/CyovPqWWkC4BbtKKY6YYNuoH5MVMUBHkRa8flXukBiSvuO51
         f0Rg7lV8gRm5fcflOHYrpKSeLVrWP7g+q5Z27yJtle6/pRkTYy8xgWXeXbX4UPO76CwI
         Iv9w==
X-Gm-Message-State: ANoB5plU3u1RonGOPuzxS6bmRupvBlQYE/wzRkb6XlqBM9TfGg8QSnpJ
        +sVaUfoi2c/vVgUYtY8ql2y+DcPZEwNYXN8z8wQ5ELqPAnLndcTWuqZVzbJFFe0Ov7xDXc8C8R0
        gU31HdM1fVJoG
X-Received: by 2002:a05:600c:3587:b0:3cf:a9c2:2b04 with SMTP id p7-20020a05600c358700b003cfa9c22b04mr12126017wmq.152.1669029008898;
        Mon, 21 Nov 2022 03:10:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6qmkAtqZngrYlpX3LaYVMHNRMoKYxTdVMdo3Sx7bg+dmQB/Sga7GdUCdrPFwBUtw6/peox+w==
X-Received: by 2002:a05:600c:3587:b0:3cf:a9c2:2b04 with SMTP id p7-20020a05600c358700b003cfa9c22b04mr12125983wmq.152.1669029008603;
        Mon, 21 Nov 2022 03:10:08 -0800 (PST)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id z11-20020a05600c0a0b00b003c6f1732f65sm19940702wmp.38.2022.11.21.03.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:10:08 -0800 (PST)
Message-ID: <2ead7655dbb90d15b883c5d31f582ed87d4e8737.camel@redhat.com>
Subject: Re: [PATCH 04/13] KVM: nSVM: clean up copying of int_ctl fields
 back to vmcb01/vmcb12
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
Date:   Mon, 21 Nov 2022 13:10:06 +0200
In-Reply-To: <Y3aWZJo8M2li/7BB@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
         <20221117143242.102721-5-mlevitsk@redhat.com> <Y3aWZJo8M2li/7BB@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-17 at 20:15 +0000, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> > Clean up the nested_sync_int_ctl_from_vmcb02:
> > 
> > 1. The comment about preservation of V_IRQ is wrong: when the L2 doesn't
> >    use virtual interrupt masking, then the field just doesn't exist in
> >    vmcb12 thus it should not be touched at all.
> >    Since it is unused in this case, touching it doesn't matter that much,
> >    so the bug is theoretical.
> > 
> > 2. When the L2 doesn't use virtual interrupt masking, then in the *theory*
> >    if KVM uses the feature, it should copy the changes to V_IRQ* bits from
> >    vmcb02 to vmcb01.
> > 
> >    In practise, KVM only uses it for detection of the interrupt window,
> >    and it happens to re-open it on each nested VM exit because
> >    kvm_set_rflags happens to raise the KVM_REQ_EVENT.
> >    Do this explicitly.
> > 
> > 3. Add comment on why we don't need to copy V_GIF from vmcb02 to vmcb01
> >    when nested guest doesn't use nested V_GIF (and thus L1's GIF is in
> >    vmcb02 while nested), even though it can in theory affect L1's GIF.
> > 
> > 4. Add support code to also copy some bits of int_ctl from
> >    vmcb02 to vmcb01.
> >    Currently there are none.
> 
> Unless it's impossible for whatever reason, this patch should be split into
> multiple patches.  IIUC, there are at least 2 different functional changes being
> made, they just happen to not have any actual impact on things.

No objection to this.

> 
> > No (visible) functional change is intended.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 47 ++++++++++++++++++++++++++-------------
> >  1 file changed, 32 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 54eb152e2b60b6..1f2b8492c8782f 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -410,28 +410,45 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> >  static void nested_sync_int_ctl_from_vmcb02(struct vcpu_svm *svm,
> >                                             struct vmcb *vmcb12)
> >  {
> > -       u32 mask;
> > +       struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> > +       struct vmcb *vmcb01 = svm->vmcb01.ptr;
> > +
> > +       /* bitmask of bits of int_ctl that we copy from vmcb02 to vmcb12*/
> > +       u32 l2_to_l1_mask = 0;
> > +       /* bitmask of bits of int_ctl that we copy from vmcb02 to vmcb01*/
> > +       u32 l2_to_l0_mask = 0;
> >  
> > -       /* Only a few fields of int_ctl are written by the processor.  */
> 
> Can this comment be kept in some form?  I found it super useful when reading this
> code just now.

No problem.

> 
> > -       mask = V_IRQ_MASK | V_TPR_MASK;
> > -       if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> > -           svm_is_intercept(svm, INTERCEPT_VINTR)) {
> > +       if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
> > +               l2_to_l1_mask |= V_IRQ_MASK | V_TPR_MASK;
> > +       else {
> >                 /*
> > -                * In order to request an interrupt window, L0 is usurping
> > -                * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> > -                * even if it was clear in L1's VMCB.  Restoring it would be
> > -                * wrong.  However, in this case V_IRQ will remain true until
> > -                * interrupt_window_interception calls svm_clear_vintr and
> > -                * restores int_ctl.  We can just leave it aside.
> > +                * If IRQ window was opened while in L2, it must be reopened
> > +                * after the VM exit
> > +                *
> > +                * vTPR value doesn't need to be copied from vmcb02 to vmcb01
> > +                * because it is synced from/to apic registers on each VM exit
> >                  */
> > -               mask &= ~V_IRQ_MASK;
> > +               if (vmcb02->control.int_ctl & V_IRQ_MASK)
> > +                       kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> >         }
> >  
> >         if (nested_vgif_enabled(svm))
> > -               mask |= V_GIF_MASK;
> > +               l2_to_l1_mask |= V_GIF_MASK;
> > +       else
> > +               /* There is no need to sync V_GIF from vmcb02 to vmcb01
> > +                * because GIF is cleared on VMexit, thus even though
> > +                * nested guest can control host's GIF, on VM exit
> > +                * its set value is lost
> > +                */
> > +               ;
> 
> The "else ... ;" is unnecessary, just throw the block comment above the nested
> vGIF if-statment, e.g. if I'm understanding everything, this?
Yes.

> 
>         /*
>          * If nested vGIF is not enabled, L2 has access to L1's "real" GIF.  In
>          * this case, there's no need to sync V_GIF from vmcb02 to vmcb01
>          * because GIF is cleared on VM-Exit, thus any changes made by L2 are
>          * overwritten on VM-Exit to L1.
>          */
>         if (nested_vgif_enabled(svm))
>                 l2_to_l1_mask |= V_GIF_MASK;
> 
> > +
> > +       vmcb12->control.int_ctl =
> > +               (svm->nested.ctl.int_ctl & ~l2_to_l1_mask) |
> > +               (vmcb02->control.int_ctl & l2_to_l1_mask);
> >  
> > -       vmcb12->control.int_ctl        &= ~mask;
> > -       vmcb12->control.int_ctl        |= svm->vmcb->control.int_ctl & mask;
> > +       vmcb01->control.int_ctl =
> > +               (vmcb01->control.int_ctl & ~l2_to_l0_mask) |
> > +               (vmcb02->control.int_ctl & l2_to_l0_mask);
> 
> No need for wrapping immediately after the "=", these all fit under the soft limit:
> 
>         vmcb12->control.int_ctl = (svm->nested.ctl.int_ctl & ~l2_to_l1_mask) |
>                                   (vmcb02->control.int_ctl & l2_to_l1_mask);
> 
>         vmcb01->control.int_ctl = (vmcb01->control.int_ctl & ~l2_to_l0_mask) |
>                                   (vmcb02->control.int_ctl & l2_to_l0_mask);

OK.


Best regards,
	Maxim Levitsky

> 


