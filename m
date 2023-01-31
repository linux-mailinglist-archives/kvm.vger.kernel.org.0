Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9147968217E
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 02:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjAaBoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 20:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjAaBoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 20:44:18 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0335D1632A
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:44:17 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 36so8992225pgp.10
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 17:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pL/hSEFt7W/dmd5X1D5aub2I4IDaaPmHoX3KevKN9IM=;
        b=QmkAGmmCeAy7guXmW7+vaJUorpyn/bXcs0qCkfPA/IgFDfmwigiBHUA7kEznpiAFVJ
         v/HgCKUQTjcxffH/84OTpOyy7+z22PZevI9hzjmsG+zquTkhhTbmfBa11luzyoFI412V
         YvyXH80AzQucz9N+67CY/fli7v3URG5soQQFKJ6q1BL4sedWQNxPAVZ4hov0nsa+mZd+
         WMdFaXOPEE9YKKRnCbHwTjXZjKLm/WzyHXO0HdETmsxJs3UmInX5YLwoEc6VXWNIC1LO
         oiKdyelW1S88v2aH68LiT6nBCtQol+YacyxO338LR/k9elTN8n25X2U374ZZxVPVY20M
         e+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pL/hSEFt7W/dmd5X1D5aub2I4IDaaPmHoX3KevKN9IM=;
        b=VdOk0BEOZRe5fiENbEf7NwTqc7jE/4BgY99rdWOmj5NntMsCxBC46GBMamo+YomV2g
         QJlKYZEZ2ab9B8Jwl5l8xLB516HW/t9XUbuLXNOcIci3YkFo6E5l2NaThNM0elkgCH6f
         w1sbnO8jMQBZ24zMe4jJXUmTWr1Y6L0WqMevHRoYsM7B6YFDHQ+3RnCRyYdrwIlRNz2d
         MJUx0FtcCAF0uQzw9Z85nOQR+p4pmemqsgMo/yqaW1FRqoILun/3OmZlcaWBgVsB4KAP
         Jc8Qw4XgWzKRb6/IdkGe0Uqwogokbf4ji3Cm6coNDTcVRmkmFd5ld/ukHbvjP1Q1vYxb
         peHw==
X-Gm-Message-State: AO0yUKVZZfpZq0Xv1MDpbK3IntFiZ1ltOC54cswY0DS5O7Lvrj2mMR32
        BpCT88ELpk3XbrsOdoFRTopIpyFMOwBQ5PG1Y+w=
X-Google-Smtp-Source: AK7set/LdTxIHvUU7egyEysNxW+soRaGI1tUU8LRhXfJvhW+FxxEJPURWr8yJxj9V9/is7yJC94qTA==
X-Received: by 2002:aa7:858a:0:b0:590:7627:91b with SMTP id w10-20020aa7858a000000b005907627091bmr1065457pfn.0.1675129456206;
        Mon, 30 Jan 2023 17:44:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 74-20020a62164d000000b0058b59c81a29sm7940953pfw.220.2023.01.30.17.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 17:44:15 -0800 (PST)
Date:   Tue, 31 Jan 2023 01:44:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 02/11] KVM: nSVM: clean up the copying of V_INTR bits
 from vmcb02 to vmcb12
Message-ID: <Y9hybI65So5X2LFg@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-3-mlevitsk@redhat.com>
 <Y9RuQz8dAT7DZGYk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9RuQz8dAT7DZGYk@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > the V_IRQ and v_TPR bits don't exist when virtual interrupt
> > masking is not enabled, therefore the KVM should not copy these
> > bits regardless of V_IRQ intercept.
> 
> Hmm, the APM disagrees:
> 
>  The APIC's TPR always controls the task priority for physical interrupts, and the
>  V_TPR always controls virtual interrupts.
> 
>    While running a guest with V_INTR_MASKING cleared to 0:
>      • Writes to CR8 affect both the APIC's TPR and the V_TPR register.
> 
> 
>  ...
> 
>  The three VMCB fields V_IRQ, V_INTR_PRIO, and V_INTR_VECTOR indicate whether there
>  is a virtual interrupt pending, and, if so, what its vector number and priority are.
> 
> IIUC, V_INTR_MASKING_MASK is mostly about EFLAGS.IF, with a small side effect on
> TPR.  E.g. a VMM could pend a V_IRQ but clear V_INTR_MASKING and expect the guest
> to take the V_IRQ.  At least, that's my reading of things.
>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 23 ++++++++---------------
> >  1 file changed, 8 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 37af0338da7c32..aad3145b2f62fe 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -412,24 +412,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> >   */
> >  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
> >  {
> > -	u32 mask;
> > +	u32 mask = 0;
> >  	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> >  	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> >  
> > -	/* Only a few fields of int_ctl are written by the processor.  */
> > -	mask = V_IRQ_MASK | V_TPR_MASK;
> > -	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> > -	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
> > -		/*
> > -		 * In order to request an interrupt window, L0 is usurping
> > -		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> > -		 * even if it was clear in L1's VMCB.  Restoring it would be
> > -		 * wrong.  However, in this case V_IRQ will remain true until
> > -		 * interrupt_window_interception calls svm_clear_vintr and
> > -		 * restores int_ctl.  We can just leave it aside.
> > -		 */
> > -		mask &= ~V_IRQ_MASK;

Argh! *shakes fist at KVM and SVM*

This is ridiculously convoluted, and I'm pretty sure there are existing bugs.  If
L1 runs L2 with V_IRQ=1 and V_INTR_MASKING=1, and KVM requests an interrupt window,
then KVM will overwrite vmcb02's int_vector and int_ctl, i.e. clobber L1's V_IRQ,
but then silently clear INTERCEPT_VINTR in recalc_intercepts() and thus prevent
svm_clear_vintr() from being reached, i.e. prevent restoring L1's V_IRQ.

Bug #1 is that KVM shouldn't clobber the V_IRQ fields if KVM ultimately decides
not to open an interrupt window.  Bug #2 is that KVM needs to open an interrupt
window if save.RFLAGS.IF=1, as interrupts may become unblocked in that case,
e.g. if L2 is in an interrupt shadow.

So I think this over two patches?

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 05d38944a6c0..ad1e70ac8669 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -139,13 +139,18 @@ void recalc_intercepts(struct vcpu_svm *svm)
 
        if (g->int_ctl & V_INTR_MASKING_MASK) {
                /*
-                * Once running L2 with HF_VINTR_MASK, EFLAGS.IF and CR8
-                * does not affect any interrupt we may want to inject;
-                * therefore, writes to CR8 are irrelevant to L0, as are
-                * interrupt window vmexits.
+                * If L2 is active and V_INTR_MASKING is enabled in vmcb12,
+                * disable intercept of CR8 writes as L2's CR8 does not affect
+                * any interrupt KVM may want to inject.
+                *
+                * Similarly, disable intercept of virtual interrupts (used to
+                * detect interrupt windows) if the saved RFLAGS.IF is '0', as
+                * the effective RFLAGS.IF for L1 interrupts will never be set
+                * while L2 is running (L2's RFLAGS.IF doesn't affect L1 IRQs).
                 */
                vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
-               vmcb_clr_intercept(c, INTERCEPT_VINTR);
+               if (!(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF))
+                       vmcb_clr_intercept(c, INTERCEPT_VINTR);
        }
 
        /*
@@ -416,18 +421,18 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 
        /* Only a few fields of int_ctl are written by the processor.  */
        mask = V_IRQ_MASK | V_TPR_MASK;
-       if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
-           svm_is_intercept(svm, INTERCEPT_VINTR)) {
-               /*
-                * In order to request an interrupt window, L0 is usurping
-                * svm->vmcb->control.int_ctl and possibly setting V_IRQ
-                * even if it was clear in L1's VMCB.  Restoring it would be
-                * wrong.  However, in this case V_IRQ will remain true until
-                * interrupt_window_interception calls svm_clear_vintr and
-                * restores int_ctl.  We can just leave it aside.
-                */
+
+       /*
+        * Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting
+        * virtual interrupts in order to request an interrupt window, as KVM
+        * has usurped vmcb02's int_ctl.  If an interrupt window opens before
+        * the next VM-Exit, svm_clear_vintr() will restore vmcb12's int_ctl.
+        * If no window opens, V_IRQ will be correctly preserved in vmcb12's
+        * int_ctl (because it was never recognized while L2 was running).
+        */
+       if (svm_is_intercept(svm, INTERCEPT_VINTR) &&
+           !test_bit(INTERCEPT_VINTR, (unsigned long *)svm->nested.ctl.intercepts))
                mask &= ~V_IRQ_MASK;
-       }
 
        if (nested_vgif_enabled(svm))
                mask |= V_GIF_MASK;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b103fe7cbc82..59d2891662ef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1580,6 +1580,16 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
        svm_set_intercept(svm, INTERCEPT_VINTR);
 
+       /*
+        * Recalculating intercepts may have clear the VINTR intercept.  If
+        * V_INTR_MASKING is enabled in vmcb12, then the effective RFLAGS.IF
+        * for L1 physical interrupts is L1's RFLAGS.IF at the time of VMRUN.
+        * Requesting an interrupt window if save.RFLAGS.IF=0 is pointless as
+        * interrupts will never be unblocked while L2 is running.
+        */
+       if (!svm_is_intercept(svm, INTERCEPT_VINTR))
+               return;
+
        /*
         * This is just a dummy VINTR to actually cause a vmexit to happen.
         * Actual injection of virtual interrupts happens through EVENTINJ.
