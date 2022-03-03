Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A324CB454
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 02:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiCCB3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 20:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiCCB3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 20:29:54 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E862A17A96
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 17:29:08 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c9so3188833pll.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 17:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IHtgTQWbmpZhgWCM2ezmPd/4tPnFP5dSbCtxp8XIhJo=;
        b=VAgZ0E0Cz7yxTWi/pbe1ZivAjJYJQB0vKMsomp3YWBPFFbmagLU2xrT/dG/5NORoeX
         OQH2Viks8RqaKKXAJERRGXDmKTlUyL/OztuRnY6znLZ9dy80yykDyJz5IBzwDcpvjru/
         WMHfGbG6RLRv1AUOJitBHb9l+Vyo5M920U7vWmIYEM0KoSIJ4JhTDp4abuvxMZiiXAiY
         r5Ism8/66jyhAvNNA3NnO2IJjnFruJnF7hOh7bD6H2i/VoLFo2qiFN6y9lBCqMImLmbp
         IZvPp/7QcKER/XYlBfgJesjKwoXujAyLTKqcAi6BPY1ObFwuVE3hBIjMAp4SOVV9EBUD
         ATlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IHtgTQWbmpZhgWCM2ezmPd/4tPnFP5dSbCtxp8XIhJo=;
        b=m/NqFB5YW/pgf22/X+nZ/0ELjs1tmD+FapeIfdj9arl6LQpkIMZulN5z81P4zRn1i5
         viE/7EfXX+hWoAFxoc3UGAIJL9WFSg2vaiQH90FPLFe8JsEEhIM3jCH92d7JgttRJZqd
         +xabblKaH91DpFryFkLe5okXHiD5VQuVoat5FYruywaOI7FTmZrxoOSlGV4G2CqxW7Mf
         QGrG7QQ8yw8lABx4KP8+e6s+oQTW6e7pZI4YnQoW5UGYx/zLWyz34KuvMBZs6bwprFAJ
         egyigjNwH4kIrlNAj3BxLqt5VocqM+DEuwJEIBZxjYa3PyVnrh0WcuX5G8dbndM66IRM
         WQBA==
X-Gm-Message-State: AOAM5320HZJP3rH3dJ2/yf4+gChdgHNBIZGE466i6leiX1c2vmreMwDR
        UcW2/P0x/TXtnttfFp7DdtAMOA==
X-Google-Smtp-Source: ABdhPJxEKYhBCehfNGhvWf6aK5m2uV6wOLvhEU6RIVBObsS3z1U6twthNQRueQ+fTJG2WxbZl5Amyg==
X-Received: by 2002:a17:902:f682:b0:151:9769:351c with SMTP id l2-20020a170902f68200b001519769351cmr5457487plg.157.1646270948006;
        Wed, 02 Mar 2022 17:29:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t190-20020a632dc7000000b003759f87f38csm341775pgt.17.2022.03.02.17.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:29:07 -0800 (PST)
Date:   Thu, 3 Mar 2022 01:29:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: Improve virtual machine startup performance
Message-ID: <YiAZ3wTICeLTVnJz@google.com>
References: <20220301063756.16817-1-flyingpeng@tencent.com>
 <Yh5d7XBD9D4FhEe3@google.com>
 <CAPm50a+p2pSjExDwPmGpZ_aTuxs=x6RZ4-AAD19RDQx2o-=NCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPm50a+p2pSjExDwPmGpZ_aTuxs=x6RZ4-AAD19RDQx2o-=NCw@mail.gmail.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Hao Peng wrote:
> On Wed, Mar 2, 2022 at 1:54 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Mar 01, 2022, Peng Hao wrote:
> > >  From: Peng Hao <flyingpeng@tencent.com>
> > >
> > > vcpu 0 will repeatedly enter/exit the smm state during the startup
> > > phase, and kvm_init_mmu will be called repeatedly during this process.
> > > There are parts of the mmu initialization code that do not need to be
> > > modified after the first initialization.
> > >
> > > Statistics on my server, vcpu0 when starting the virtual machine
> > > Calling kvm_init_mmu more than 600 times (due to smm state switching).
> > > The patch can save about 36 microseconds in total.
> > >
> > > Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> > > ---
> > > @@ -5054,7 +5059,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> > >  {
> > >       kvm_mmu_unload(vcpu);
> > > -     kvm_init_mmu(vcpu);
> > > +     kvm_init_mmu(vcpu, false);
> >
> > This is wrong, kvm_mmu_reset_context() is the "big hammer" and is expected to
> > unconditionally get the MMU to a known good state.  E.g. failure to initialize
> > means this code:
> >
> >         context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
> >
> > will not update the shadow_root_level as expected in response to userspace changing
> > guest.MAXPHYADDR in such a way that KVM enables/disables 5-level paging.
> >
> Thanks for pointing this out. However, other than shadow_root_level,
> other fields of context will not
> change during the entire operation, such as
> page_fault/sync_page/direct_map and so on under
> the condition of tdp_mmu.
> Is this patch still viable after careful confirmation of the fields
> that won't be modified?

No, passing around the "init" flag is a hack.

But, we can achieve what you want simply by initializing the constant data once
per vCPU.  There's a _lot_ of state that is constant for a given MMU now that KVM
uses separate MMUs for L1 vs. L2 when TDP is enabled.  I should get patches posted
tomorrow, just need to test (famous last words).

Also, based on the number of SMM transitions, I'm guessing you're using SeaBIOS.
Have you tried disabling CONFIG_CALL32_SMM, or CONFIG_USE_SMM altogether?  That
might be an even better way to improve performance in your environment.

Last question, do you happen to know why eliminating this code shaves 36us?  The
raw writes don't seem like they'd take that long.  Maybe the writes to function
pointers trigger stalls or mispredicts or something?  If you don't have an easy
answer, don't bother investigating, I'm just curious.
