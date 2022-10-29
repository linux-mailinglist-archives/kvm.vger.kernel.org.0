Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567DB611EBB
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 02:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJ2AfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 20:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJ2AfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 20:35:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11BF58171
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 17:35:07 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k8so8580677wrh.1
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 17:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H/ZnB5F+DVfXKr1M4rAR7gUNY4tm1xTurWMjuzZRaCQ=;
        b=H4nRHTRLfB74dloa6Q0Xz7xeHgFWi39fFyKMH8tG5ZxGqRWBgSpPiDEe6sPUyP7Lug
         aQMz5X1Pab4i4yrwoBwUMKzGLc/uhLFJIIPSpsIqDQZHB3wK23L/tKi7bE22OKLTosem
         QnImR9uHZ9zmOjljOpDJfXELoykgAnOG0mrK+WbHkEC4Sf0XRoPCpOgF8u9wv1iTyKtJ
         zaod5mbil+4WZ5LS/qlcf4+EdGzbwAxWKE6rPJEOo5BUE4VZCVGCimokBQr3Ect4ORf8
         LLryy4CgaddvxB8htq1xldyVxpfODuaTM+yuIuY7mHYUWSzy6CAqaVxTYhDZOPUvs3BC
         IrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H/ZnB5F+DVfXKr1M4rAR7gUNY4tm1xTurWMjuzZRaCQ=;
        b=aTyKoQ2H4gIY0zVjeQxgTUSQARnT1Fx/HPoiVsKtM8L6PHwrgVCsEtqC5TmUauwVhQ
         fZbSeBFBgufLQIn57tCAmjSe7ge22sSj74byp4wfxKtqgLWMS0vuhW6U3KevxDfaO8lM
         jlqw1ofRvblhOl+W9A1xJUVhaiiNW2Sndb+cZZoXVwcX0o5OOAAneYnjDWFwfGCJTECz
         yDRimeH1unIpxnFPPJTcXeqsg1LcDLaS2eKXNPq/8qS1fdVWDKUsXzx2PniuQJJDLZJ+
         B22HInMEqHRCb0VYSG/NSKM+GtcZy5fIgB6GRJU3Gf/K9CMDOZmrvm46pzKOSn+az2u4
         q21g==
X-Gm-Message-State: ACrzQf1KEC2rQTiYx0TUqdIM2LocYeOlvwNgU2R7WnFpxMuW9XPYOLn0
        hIWKq3kumeLqjfCmKbY0x9p3uCxreiyI2dqIcx0Y7i9Xx8M=
X-Google-Smtp-Source: AMsMyM4rrgrlBwrwHRN831CK+5d4jBrOUFXKJ4+EqQhpAvdvr3kdbAT8HEmkC9QNLOgXI0FjLlo4wD2dbtfK0xwvbrc=
X-Received: by 2002:a5d:604c:0:b0:236:6deb:6d31 with SMTP id
 j12-20020a5d604c000000b002366deb6d31mr984873wrt.282.1667003706292; Fri, 28
 Oct 2022 17:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221028130035.1550068-1-aaronlewis@google.com>
 <Y1wCqAzJwvz4s8OR@google.com> <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
 <Y1xOvenzUxFIS0iz@google.com>
In-Reply-To: <Y1xOvenzUxFIS0iz@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 28 Oct 2022 17:34:54 -0700
Message-ID: <CAAAPnDFRoStx7CeLSLAWvd65hZzeLwwKX678mUjO11ytnkZZ4w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Oct 28, 2022 at 2:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > On Fri, Oct 28, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > > @@ -3778,16 +3775,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >
> > >     case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> > >     case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> > > -        pr = true;
> > > -        fallthrough;
> > >     case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
> > >     case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> > >         if (kvm_pmu_is_valid_msr(vcpu, msr))
> > >             return kvm_pmu_set_msr(vcpu, msr_info);
> > >
> > > -        if (pr || data != 0)
> > > -            vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
> > > -                  "0x%x data 0x%llx\n", msr, data);
> > > +        if (data)
> > > +            kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> >
> > Any reason to keep the check for 'data' around?  Now that it's
> > checking for 'report_ignored_msrs' maybe we don't need that check as
> > well.  I'm not sure what the harm is in removing it, and with this
> > change we are additionally restricting pmu counter == 0 from printing.
>
> Checking 'dat' doesn't restrict counter 0, it skips printing if the guest (or host)
> is writing '0', e.g. it would also skip the case you encountered where the host is
> blindly "restoring" unused MSRs.
>
> Or did I misunderstand your comment?

That makes sense.

Reviewed-by: Aaron Lewis <aaronlewis@google.com>
