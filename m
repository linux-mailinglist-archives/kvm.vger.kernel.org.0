Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365544E5B71
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345326AbiCWWtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiCWWth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:49:37 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF00BF60;
        Wed, 23 Mar 2022 15:48:05 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b13so669936pfv.0;
        Wed, 23 Mar 2022 15:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Esw6C6yt45apyLHALqu5qIDakKO1rV7h7Ry+mvo3u2o=;
        b=A778ZUvX2skq0M28t9gXLFc3NtYOoip4s6Wc63WdMFmA0UmhWL6xXs74oRzGf8FsLL
         1bt27MzYxyiKyuwP7SfzSnjwtlfB8wJzBUdCFC+x3X/jA/2rDr3KjPcND7bBluJFs9E/
         1S3AtnZOkzwCX4CT4QXQ7VOE/rVudY45F/rYaeo6M4yqURsaxxueezcxkL67rqtnAqs0
         +JE+lRft367UPvsSuvjGdVHnOu6wSAciJU1BDMHe00ibn/dUCkeUIHYzKQ/+uPaz0wkk
         Kmcx482CHwwDjKHNBy/xkEso4wDmnmJf3aUEVZFcQsypwOu/xaojypyG5iBBYIKVRZfg
         w5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Esw6C6yt45apyLHALqu5qIDakKO1rV7h7Ry+mvo3u2o=;
        b=B5fKY+R1QDQFzDlTi4buATQHWTSuH1pmvQf0tPptUPI/TYpNvhuzZ1f8thE9ERwXyT
         QELDPj2PPJbwgup8AAEnFCOZ6jKcAMgqAiVabL/1Yw3glqL9KPTKeF9NH8jxvnRp3DAM
         rAUWdnQi+pXzvpgdOg+QV+jbKRjfKqrkBVH+GsxhVyBEy4YUwCOfiAso1TV4vaWhuj6t
         glPY/cJTPo/OoOfJfcirqeODKJOUMGpxZ5s9FYrhE1+TXn2u+O8i6qOKaEMMGaxvUPn3
         VvfaBV3YCQA4FK98wBzV9974kcfARM67D0zfNfxysS85KaOkpygyN75Gx0DGNPrbwPqL
         QQnw==
X-Gm-Message-State: AOAM531N0YDDOLkJ681eyoHmnWx6T+whHq6Pwz7Xmtcncz8MXXFXiX5I
        /GNPN98sjFsjTFOsyEVl2F8=
X-Google-Smtp-Source: ABdhPJwVEp2dAMq6o96Oj+IkouScYXnEXoMsYUZ/U+QZJMDsY0qy/tOyCyTjcIgwXbx0h2OQNRci8w==
X-Received: by 2002:a63:1258:0:b0:381:640e:9be5 with SMTP id 24-20020a631258000000b00381640e9be5mr1682329pgs.184.1648075684528;
        Wed, 23 Mar 2022 15:48:04 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id a22-20020a056a000c9600b004f7ba8b445asm879627pfv.65.2022.03.23.15.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:48:04 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:48:02 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 064/104] KVM: TDX: Implement TDX vcpu enter/exit
 path
Message-ID: <20220323224802.GA181823@private.email.ne.jp>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <cedda3dbe8597356374ef64de26ecef0d8cd7a62.1646422845.git.isaku.yamahata@intel.com>
 <CAAYXXYy3QLWyq9QrEnrsOLB3r44QTgKaOW4=HhOozDuw1073Gg@mail.gmail.com>
 <20220323175552.GG1964605@ls.amr.corp.intel.com>
 <CAAYXXYygcwW-Ai5qAAMpp_GprywV2=x02JYXfJxY2ac_EMKLvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYygcwW-Ai5qAAMpp_GprywV2=x02JYXfJxY2ac_EMKLvw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 01:05:27PM -0700,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Wed, Mar 23, 2022 at 10:55 AM Isaku Yamahata
> <isaku.yamahata@gmail.com> wrote:
> >
> > On Tue, Mar 22, 2022 at 10:28:42AM -0700,
> > Erdem Aktas <erdemaktas@google.com> wrote:
> >
> > > On Fri, Mar 4, 2022 at 11:50 AM <isaku.yamahata@intel.com> wrote:
> > > > @@ -509,6 +512,37 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > >         vcpu->kvm->vm_bugged = true;
> > > >  }
> > > >
> > > > +u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
> > > > +
> > > > +static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > > > +                                       struct vcpu_tdx *tdx)
> > > > +{
> > > > +       guest_enter_irqoff();
> > > > +       tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
> > > > +       guest_exit_irqoff();
> > > > +}
> > > > +
> > > > +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > +
> > > > +       if (unlikely(vcpu->kvm->vm_bugged)) {
> > > > +               tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> > > > +               return EXIT_FASTPATH_NONE;
> > > > +       }
> > > > +
> > > > +       trace_kvm_entry(vcpu);
> > > > +
> > > > +       tdx_vcpu_enter_exit(vcpu, tdx);
> > > > +
> > > > +       vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> > > > +       trace_kvm_exit(vcpu, KVM_ISA_VMX);
> > > > +
> > > > +       if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
> > > > +               return EXIT_FASTPATH_NONE;
> > >
> > > Looks like the above if statement has no effect. Just checking if this
> > > is intentional.
> >
> > I'm not sure if I get your point.  tdx->exit_reason is updated by the above
> > tdx_cpu_enter_exit().  So it makes sense to check .error or .non_recoverable.
> > --
> > Isaku Yamahata <isaku.yamahata@gmail.com>
> 
> What I mean is, if there is an error, it returns EXIT_FASTPATH_NONE
> but if there is no error, it still returns EXIT_FASTPATH_NONE.
> 
> The code is like below, the if-statement might be there as a
> placeholder to check errors but it has no impact on what is returned
> from this function.
> 
>        if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
>                return EXIT_FASTPATH_NONE;
>        return EXIT_FASTPATH_NONE;

Got it. It doesn't make sense. I'll fix it with the next respin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
