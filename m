Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775DA6348C3
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 21:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiKVUws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 15:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiKVUwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 15:52:42 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842941AF04
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 12:52:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so9371pjk.1
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 12:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xe5lv1QsTYxiW+46jd84oLWYNOjdtqx5LsHPiQT+CbY=;
        b=jHr87EqrXczQan3cj3wKvuAcmEXgUT0owrBovzhrjOOZz83aqN2FXomVGU4sO8TKl9
         RIIVJ4g4bh3i9/d99KPEbeIjhBp+ON/N+0xqVAjlfXbk85E4NhQstANHw2EQxSeiWTEI
         k9vHnM9uP0PHr3VJB8THPKjYsb9whCcCn6WMRpulIMvZIgPHS7vd6oIMxwlWwrEJWBdM
         C0RP4zEifu27siBCoe9LLdLbGe8aVnoTEMTkyNdISSQX7lapnos11FatL5D5jnzVS65B
         1PmU5qm3JVPdVjAsE9w6kH/IvzZ8UKnx5TOC8wnUP28CR3xP4bG94DpfMVof93F8dZCi
         Q1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xe5lv1QsTYxiW+46jd84oLWYNOjdtqx5LsHPiQT+CbY=;
        b=dImUmrwURghuXQR0CrazxlbXv203VQ/wM7UGhRI/6OsX0NN12XPhcKdBO/C1zb9EAl
         4IcWjRYFmvDIvfEPajtzVe+qomQrZNJB6oD9AEmnlq80VPC5bUtkFXRsTwPgH9EGI8lL
         rlRgKze3WegPYNtGYxcWAF4S+K/IYOIo0aTDX7RhMwy3giJ+SoT7vsqGR7hh/sTQw5ku
         0XqoSknl4zfX4QqKX/TAvoMqjyqo2nItA3lrQep0VI5sbVe0tTxzYmOBbTiEBeQTzhaW
         XpgB6W0wrQ7wbyeuiFfZgMiV9PmUA007EGFPOVdgA14brlTYTJbnQ0ph/V+j0wU0nPuX
         sCvg==
X-Gm-Message-State: ANoB5pnM8BRBtdOfcIiUq5/Mcr6CI2ozyflGHKqaLr4L9PXcMQ0XMxU+
        k9RidQNdt8/9eZvPmENy6QeVylg06FIKWg==
X-Google-Smtp-Source: AA0mqf4pAi46wp7LU6CBDjGxihAVeR6mOkIyT4rbAVPEqXby41bwTlpEfGplJ03ZvrSKZArwx/0Frw==
X-Received: by 2002:a17:902:d349:b0:189:324:27cc with SMTP id l9-20020a170902d34900b00189032427ccmr5653079plk.70.1669150358926;
        Tue, 22 Nov 2022 12:52:38 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f19-20020a17090a9b1300b0020d9306e735sm9950352pjp.20.2022.11.22.12.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 12:52:38 -0800 (PST)
Date:   Tue, 22 Nov 2022 20:52:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y302kxLEhcp20d65@google.com>
References: <BN6PR1101MB216141A21353AB84CEA541DFA8009@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y26jkHfK9INwU7Yy@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161E8217F50D18C56E5864EA8059@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3IFo9NrAcYalBzM@hirez.programming.kicks-ass.net>
 <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
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

On Tue, Nov 22, 2022, Li, Xin3 wrote:
> > > > > > > And yes, the current code appears to suffer the same defect.
> > >
> > > That defect isn't going to be fixed simply by changing how KVM
> > > forwards NMIs though.  IIUC, _everything_ between VM-Exit and the
> > > invocation of the NMI handler needs to be noinstr.  On VM-Exit due to
> > > NMI, NMIs are blocked.  If a #BP/#DB/#PF occurs before KVM gets to
> > > kvm_x86_handle_exit_irqoff(), the subsequent IRET will unblock NMIs
> > > before the original NMI is serviced, i.e. a second NMI could come in
> > > at anytime regardless of how KVM forwards the NMI to the kernel.
> > >
> > > Is there any way to solve this without tagging everything noinstr?
> > > There is a metric shit ton of code between VM-Exit and the handling of
> > > NMIs, and much of that code is common helpers.  It might be possible
> > > to hoist NMI handler much earlier, though we'd need to do a super
> > > thorough audit to ensure all necessary host state is restored.
> > 
> > As NMI is the only vector with this potential issue, it sounds a good idea to only
> > promote its handling.
> > 
> 
> Hi Peter/Sean,
> 
> I prefer to move _everything_ between VM-Exit and the invocation of the NMI
> handler into the noinstr section in the next patch set, how do you think?

That's likely going to be beyond painful and will have a _lot_ of collateral
damage in the sense that other paths will end up calling noinstr function just
because of VMX.  E.g. hw_breakpoint_restore(), fpu_sync_guest_vmexit_xfd_state(),
kvm_get_apic_mode(), multiple static calls in KVM... the list goes on and on and on.

The ongoing maintenance for that would also be quite painful.

Actually, SVM already enables NMIs far earlier, which means the probability of
breaking something by moving NMI handling earlier is lower.  Not zero, as I don't
trust that SVM gets all the corner right, but definitely low.

E.g. this should be doable

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cea8c07f5229..2fec93f38960 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7249,6 +7249,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
        if (unlikely(vmx->exit_reason.failed_vmentry))
                return EXIT_FASTPATH_NONE;
 
+       <handle NMIs here>
+
        vmx->loaded_vmcs->launched = 1;
 
        vmx_recover_nmi_blocking(vmx);


thouh we'd like want a fair bit of refactoring so that all of vmx_vcpu_run() and
svm_vcpu_run() don't need to be noinstr.

Another wart that needs to be addressed is trace_kvm_exit().  IIRC, tracepoints
must be outside of noinstr, though maybe I'm misremembering that.  And conversely,
SVM doesn't trace exits that are handled in the fastpath.  Best option is probably
to move VMX's trace_kvm_exit() call to vmx_handle_exit(), and then figure out a
common way to trace exits that are handled in the fastpath (which can reside outside
of the noinstr section).
