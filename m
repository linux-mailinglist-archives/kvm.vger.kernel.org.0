Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E93508CFB
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380436AbiDTQSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 12:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380431AbiDTQSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 12:18:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD58B27CC8
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 09:15:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j8so2197506pll.11
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 09:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tnEdHKpPyZkZmrpdyV+90S+5wmdBROjGyPq57BetpoU=;
        b=D4JPc+7j0ulu+47aOpYDf++g8UTividvLRWK2iqrM38t4CWHmEoGr8rz8OOYNdiNyO
         GOKHSHQAFxq2lF8cjaOFbwh9GTn4d87loazZMySaAMuNgdtiP2QB+IUHC10aAWMzK/oo
         eg0fgki2O3/oP+Yo2CywVQsBFo3U5SFVtqkdF6K5/S07SwcB7IeNC+Kn+UJqfIKtT+X9
         +6L3PYP6IJcAY6zyffxblxGRhjXelIWutWa9WDwxZGnTh1Hklfpu4LcTLesYtkMFKUFR
         C+m8eoQGlpdQcP/Esz+2sogoUlGc9mGlMIFOy7nCbQbU+jmYwW/UhJk4yblgmZltuBz0
         T6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tnEdHKpPyZkZmrpdyV+90S+5wmdBROjGyPq57BetpoU=;
        b=558QMm4EQeW+eagqCoAAfZ2vdpOIyrfp/1zciOdnkorDPJOJHTwqOp4IuCfNSCdILF
         zp76OiEbArmKBpQ8ArpGsQltY3pOU6O3mGBQXbb5GbCDqpgdxdF3xK74OxqWFqpAeMdQ
         HEaIdHS+cdw06c8sLLHBh5aHsgNckEtNGGFrx7vPqOrNyOh+juFNhxZl/z14zLRvolbJ
         FtLovOHKZLBd9zlRsDulqyRJM0lQQ2PtfBuN+Tw/1YY4ki9WBMvBHbyeEecYjwY3uP8e
         0MWb5Vd07cG1FLJxEcaMCD4OG+0CQQ19ed0rhp4yn6RTBoP+1wTugHCrX/DXpKxpTbXn
         PSRw==
X-Gm-Message-State: AOAM531l+v05oqgNypExpE1vDkdg32Le+qLsYKIt8h+L4V0POJKvbj3N
        kqbazPzqno7S7lNwrs3QiERl4g==
X-Google-Smtp-Source: ABdhPJwiECiSV47yGzjO1OSK5czfQAfEaTNuFinGeQPK7mUTXZmde2s/5XsQi8Zbio0IBM1grb9y/A==
X-Received: by 2002:a17:902:bc8c:b0:156:bc64:fa47 with SMTP id bb12-20020a170902bc8c00b00156bc64fa47mr21385934plb.135.1650471343113;
        Wed, 20 Apr 2022 09:15:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm20575560pfo.175.2022.04.20.09.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:15:42 -0700 (PDT)
Date:   Wed, 20 Apr 2022 16:15:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
Message-ID: <YmAxqrbMRx76Ye5a@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
 <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
 <YkspIjFMwpMYWV05@google.com>
 <4505b43d-5c33-4199-1259-6d4e8ebac1ec@redhat.com>
 <98fca5c8-ca8e-be1f-857d-3d04041b66d7@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98fca5c8-ca8e-be1f-857d-3d04041b66d7@maciej.szmigiero.name>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022, Maciej S. Szmigiero wrote:
> On 20.04.2022 17:00, Paolo Bonzini wrote:
> > On 4/4/22 19:21, Sean Christopherson wrote:
> > > On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
> > > > > @@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> > > > >        nested_copy_vmcb_control_to_cache(svm, ctl);
> > > > >        svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > > > > -    nested_vmcb02_prepare_control(svm);
> > > > > +    nested_vmcb02_prepare_control(svm, save->rip);
> > > > 
> > > >                        ^
> > > > I guess this should be "svm->vmcb->save.rip", since
> > > > KVM_{GET,SET}_NESTED_STATE "save" field contains vmcb01 data,
> > > > not vmcb{0,1}2 (in contrast to the "control" field).
> > > 
> > > Argh, yes.  Is userspace required to set L2 guest state prior to KVM_SET_NESTED_STATE?
> > > If not, this will result in garbage being loaded into vmcb02.
> > > 
> > 
> > Let's just require X86_FEATURE_NRIPS, either in general or just to
> > enable nested virtualiazation
> 
> 👍

Hmm, so requiring NRIPS for nested doesn't actually buy us anything.  KVM still
has to deal with userspace hiding NRIPS from L1, so unless I'm overlooking something,
the only change would be:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bdf8375a718b..7bed4e05aaea 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -686,7 +686,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
         */
        if (svm->nrips_enabled)
                vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-       else if (boot_cpu_has(X86_FEATURE_NRIPS))
+       else
                vmcb02->control.next_rip    = vmcb12_rip;

        if (is_evtinj_soft(vmcb02->control.event_inj)) {

And sadly, because SVM doesn't provide the instruction length if an exit occurs
while vectoring a software interrupt/exception, making NRIPS mandatory doesn't buy
us much either.

I believe the below diff is the total savings (plus the above nested thing) against
this series if NRIPS is mandatory (ignoring the setup code, which is a wash).  It
does eliminate the rewind in svm_complete_soft_interrupt() and the funky logic in
svm_update_soft_interrupt_rip(), but that's it AFAICT.  The most obnoxious code of
having to unwind EMULTYPE_SKIP when retrieving the next RIP for software int/except
injection doesn't go away :-(

I'm not totally opposed to requiring NRIPS, but I'm not in favor of it either.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 66cfd533aaf8..6b48af423246 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -354,7 +354,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
        if (sev_es_guest(vcpu->kvm))
                goto done;

-       if (nrips && svm->vmcb->control.next_rip != 0) {
+       if (svm->vmcb->control.next_rip != 0) {
                WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
                svm->next_rip = svm->vmcb->control.next_rip;
        }
@@ -401,7 +401,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
         * in use, the skip must not commit any side effects such as clearing
         * the interrupt shadow or RFLAGS.RF.
         */
-       if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+       if (!__svm_skip_emulated_instruction(vcpu, false))
                return -EIO;

        rip = kvm_rip_read(vcpu);
@@ -420,11 +420,8 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
        svm->soft_int_old_rip = old_rip;
        svm->soft_int_next_rip = rip;

-       if (nrips)
-               kvm_rip_write(vcpu, old_rip);
-
-       if (static_cpu_has(X86_FEATURE_NRIPS))
-               svm->vmcb->control.next_rip = rip;
+       kvm_rip_write(vcpu, old_rip);
+       svm->vmcb->control.next_rip = rip;

        return 0;
 }
@@ -3738,20 +3735,9 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
         * the same event, i.e. if the event is a soft exception/interrupt,
         * otherwise next_rip is unused on VMRUN.
         */
-       if (nrips && (is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
+       if ((is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
            kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
                svm->vmcb->control.next_rip = svm->soft_int_next_rip;
-       /*
-        * If NextRIP isn't enabled, KVM must manually advance RIP prior to
-        * injecting the soft exception/interrupt.  That advancement needs to
-        * be unwound if vectoring didn't complete.  Note, the new event may
-        * not be the injected event, e.g. if KVM injected an INTn, the INTn
-        * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
-        * be the reported vectored event, but RIP still needs to be unwound.
-        */
-       else if (!nrips && (is_soft || is_exception) &&
-                kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
-               kvm_rip_write(vcpu, svm->soft_int_old_rip);
 }

 static void svm_complete_interrupts(struct kvm_vcpu *vcpu)

