Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA396DE079
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 18:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDKQH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 12:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDKQHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 12:07:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8423AC5
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:07:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 67-20020a250146000000b00b714602d43fso9297794ybb.10
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 09:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681229243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hxFAtEsJbdvLtNfJ/+L53LQFojPN24OozaH8YhStbXs=;
        b=4/US+zI8k77bTfBehwqJE2pi/YmTOYnxZsoRgQqxe+hSfJGPZwAd/yQPRtpgTZHCvo
         tgsiu/b+eB8R1WBAXVsD1uCFrw5o53FVx/RkGqX4eTJuDt4BLzPglF/yTL/Dem36WjZR
         dxWa8B1Zq7WplWoXGJKtqthQN5xXVtAoP6RqUnXKSp/Ba99G4qMjK98p6H7bKVnBI8S2
         uWQfarLgDMYS5Aki9gK9IGswJSPbw4/7XF3p84WPc2QVqSMx8T/Bj76ppWlPpv3n0hEm
         jpzXBMSM3n6uufwEMYiVymKnFkE02YfSRxnj+7HyfswyFsY1u+JMNYitY1xHLfYe4pAg
         4m+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681229243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hxFAtEsJbdvLtNfJ/+L53LQFojPN24OozaH8YhStbXs=;
        b=fH4VhAByNjGFS2DvhOlNRT0276KLcMZS5CjemY4HIDRly2Gf0+nVLbNFZDu2rV5lDt
         WNYtgRdXSJ1Uf78/m6gqnf/xj1AfwmxnlKRLzdd5Z++ERf0mDisD3mMXQYWaIkOAXMM8
         MV62+qmCWdgJlZLkKh4Ow+O8zAOi2aupW0Amrc3BZsPDAe4jDdV7EvCKtlGq5zZp14AX
         qI7+sydXY25QnjxKknEbP1JM3Gr4xlDRTuiFTkFOZQtl9q9HEtzqkQSByL4lwmam84Ys
         MeWWBwTxtGXHOGm9d/QjquzoYat1ALdCKqmjRY80XyBL9B5bhlvAx8WzVmlSvzV4/n73
         5mhw==
X-Gm-Message-State: AAQBX9fNiqW+RqzgOV696NiTcEL5j9LNlOCMOM8Ho7xMJI+IvaTST6PH
        IJ2rAA2gexoxLHAMCnrdJLy0B/AAxuE=
X-Google-Smtp-Source: AKy350bdH1VghV1oY5g6iFH9b4l1GJ2QrDTTqV4W4Ri6MK+N7qKBqaPP3co6412qPLXfdmFdj0AuOrqkJCQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c609:0:b0:53c:6fda:835f with SMTP id
 l9-20020a81c609000000b0053c6fda835fmr5295332ywi.0.1681229243803; Tue, 11 Apr
 2023 09:07:23 -0700 (PDT)
Date:   Tue, 11 Apr 2023 09:07:22 -0700
In-Reply-To: <431136bf-2e49-fbef-457d-1145c1a59fac@redhat.com>
Mime-Version: 1.0
References: <20230405002359.418138-1-seanjc@google.com> <431136bf-2e49-fbef-457d-1145c1a59fac@redhat.com>
Message-ID: <ZDWFup/igRUtfNTa@google.com>
Subject: Re: [PATCH] KVM: nVMX: Emulate NOPs in L2, and PAUSE if it's not intercepted
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023, Paolo Bonzini wrote:
> On 4/5/23 02:23, Sean Christopherson wrote:
> > Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> > Cc: Mathias Krause <minipli@grsecurity.net>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/vmx.c | 15 +++++++++++++++
> >   1 file changed, 15 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9ae4044f076f..1e560457bf9a 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7898,6 +7898,21 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> >   		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> >   		break;
> > +	case x86_intercept_pause:
> > +		/*
> > +		 * PAUSE is a single-byte NOP with a REPE prefix, i.e. collides
> > +		 * with vanilla NOPs in the emulator.  Apply the interception
> > +		 * check only to actual PAUSE instructions.  Don't check
> > +		 * PAUSE-loop-exiting, software can't expect a given PAUSE to
> > +		 * exit, i.e. KVM is within its rights to allow L2 to execute
> > +		 * the PAUSE.
> > +		 */
> > +		if ((info->rep_prefix != REPE_PREFIX) ||
> > +		    !nested_cpu_has2(vmcs12, CPU_BASED_PAUSE_EXITING))
> > +			return X86EMUL_CONTINUE;
> > +
> > +		break;
> > +
> >   	/* TODO: check more intercepts... */
> >   	default:
> >   		break;
> > 
> > base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Would you like me to apply this for 6.3?

Nah, I don't think there's a good risk vs. reward ratio.  KVM doesn't enable PLE
for L2, never enables PAUSE-exiting, and won't emulate NOP without forced emulation
or TLB shenanigans from L2.  So other than tests, this really shouldn't matter.

Actually, typing that out is making me rethink the stable tag...
