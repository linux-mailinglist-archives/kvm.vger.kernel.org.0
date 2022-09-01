Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED45A99BC
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 16:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiIAOIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 10:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiIAOIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 10:08:49 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED9925D
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 07:08:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 202so16483782pgc.8
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 07:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8OIlXCHvB4xFMaL/mDUpyfIfwwt9XTn35CLPOt6No9g=;
        b=Mirx+GpK5brNlklKegbj57qMFDT0WS3jhLqeAJ6CABTHIjyltYjsE4LVhiihcZqAlz
         grOTlXQxy0O9y9Ix8MfWUzBetsq6EuEvUFFzErJuwGMRgNVeObjJMDZC7V21h1I4nyhX
         wnZGkOmJwLHCgMxZEDaHqwSzn5T55ext3J2VSdcxB/aSdVZqvk/b0htPdLzXbmjQhkVZ
         XQj37YCqwppEojKZJ12H8q9gWUwOFHjBaYzzZRmRLMo2AEUaUkfhG4YhNzBjFcF40XPW
         grSsTh8Ith4w/+OQSIIQ5K/ioY4cIEm8rwBS61GA/mBrFHTjNuAD/qKkkQ5wpdPhTtyl
         d31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8OIlXCHvB4xFMaL/mDUpyfIfwwt9XTn35CLPOt6No9g=;
        b=UrD79r/9PXqcsa4CsdhCfyYdmeXslxIuSKhn2rTZtNXbEAV5sPPYdYcrFgW7stZn5e
         rBgXw6qvHPaPh5u+OnhQ4wAmoeumvTG6d3azdcB9RJ4wv9Qoylz16cb66+aQif08QZgM
         vEk7MKlrcnCaT0osYoiLUE7H4Mmxk0dew0TaeY1G7D/k7ityxvfBPur9F/d0tTr0z9T+
         TVhQPONwUZjAIA72zkViL+Jlo4mt2SrRUmAodolTLAgHWJ1nXZIYtzHKEoJXaInmmcEj
         YBHJ6CA3L0ztqmkz+wldTnjxPvYOrFQiifiDmvLZm15+vgtTjYkSDwG8KiMbkgfgJOTE
         zEGQ==
X-Gm-Message-State: ACgBeo09VwIViEtncaHD+ZHDXf5dGABHkfYdfsqlS5uxyqiV3oGtAmcY
        6N4elvlUKmjfjZfsTr5+duvVuA==
X-Google-Smtp-Source: AA6agR5uOjmgTy4O1qhe9HGGTufAnBFjacBMwS5xEm17ssf+rVSPK2WbbPewBD0dEEFGlQHAco9eaw==
X-Received: by 2002:a63:d16:0:b0:41d:fe52:1d2f with SMTP id c22-20020a630d16000000b0041dfe521d2fmr26882977pgl.416.1662041327419;
        Thu, 01 Sep 2022 07:08:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 80-20020a621453000000b00535c4b7f1eesm13346694pfu.87.2022.09.01.07.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 07:08:46 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:08:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
Message-ID: <YxC865e8sfEvp7Iw@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
 <d36802ee3d96d0fdac00d2c11be341f94a362ef9.camel@intel.com>
 <YvU+6fdkHaqQiKxp@google.com>
 <87y1v3v54b.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1v3v54b.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022, Marc Zyngier wrote:
> Sean,
> 
> On Thu, 11 Aug 2022 18:39:53 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > +Will (for arm crud)
> 
> When it comes to KVM/arm64, I'd appreciate if you could Cc me.

Sorry, will do.

> > arm64 is also quite evil and circumvents KVM's hardware enabling
> > logic to some extent.  kvm_arch_init() => init_subsystems()
> > unconditionally enables hardware, and for pKVM _leaves_ hardware
> > enabled.  And then hyp_init_cpu_pm_notifier() disables/enables
> > hardware across lower power enter+exit, except if pKVM is enabled.
> > The icing on the cake is "disabling" hardware doesn't even do
> > anything (AFAICT) if the kernel is running at EL2 (which I think is
> > nVHE + not-pKVM?).
> 
> In the cases where disabling doesn't do anything (which are the exact
> opposite of the cases you describe), that's because there is
> absolutely *nothing* to do:

Yes, I know.

> - If VHE, the kernel is the bloody hypervisor: disable virtualisation,
>   kill the kernel.
> 
> - if pKVM, the kernel is basically a guest, and has no business
>   touching anything at all.
> 
> So much the 'evil' behaviour.

The colorful language is tongue-in-cheek.

I get the impression that you feel I am attacking ARM.  That is very much not what
I intended.  If anything, I'm attacking x86 for forcing its quirks on everyone else.

What am trying to point out here is that ARM and other architectures are not
well-served by KVM's current hardware enabling/disabling infrastructure.  I am not
saying that ARM is broken and needs to be fixed, I am saying that KVM is broken and
needs to be fixed, and that ARM is a victim of KVM's x86-centric origins.
