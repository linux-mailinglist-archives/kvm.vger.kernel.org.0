Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5729667E65
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbjALStb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbjALStD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:49:03 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C501C63B0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:21:44 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r18so13330334pgr.12
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sbyK7tZVHMGmbhYaOSeaN596Z8uQ1b9mnDSGMDdyKRU=;
        b=lFKerAhzSCtljEMEVN0QkjptzlePNY7AtRMlGsqE3oVq7ODekfgOnlNxPlNASo3qM2
         hXr4gpWpsDRz+/Cj/MAsTmDa5WFDsvBexAutRZLUN6N2sgQAKHQEUPkXjMU1w7uzc2C5
         E7+BpNe0UiUHMfeCmbe8RHexH/XRDKkK9YSVbaRk3YCq+S8Ruhr/md99iDl0ykpzyiq2
         UJHKwuEA8zm3Q8OMZWVY36keXypSeQeWn17uUKSDOoSZ72jNwkVIyjfmm3m+9kknSAEb
         YdPPvAbYHlSK0/8y7BoeQSOLhDnwf/uSuvmewKfquybGyWQlyXSlgngrPM8vggWcwX6Q
         XEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbyK7tZVHMGmbhYaOSeaN596Z8uQ1b9mnDSGMDdyKRU=;
        b=1CYnr6nUb0yGHa+bdfh63ynZ8cJcipD6dyoY2kN2UQOBBqYszzCNCo+osBZe1mDZIN
         8cQFy+YEiLfLxpPapaueX4SRZ4U0nzLBMaa21TKK4BqwFQDQ7eNQ3m6L4DduzQG1P1/S
         OZUcMslrnTO5rB/wkUXYk/nAfo64vkoFipcaPS9JyHP19QpGVrna4bWr+7Wqtl1Pm9hN
         AKZnLlLMkhSSTGBg5Y2/gRMWsF/YDX7r5brVajET8512QQ6m9kslRyVcYceSzxYM0oSU
         hRuw9zBPz26hde1fGu6yfbiYV294f2IljZv78JrDhaWLCBoHRjOm97DmY78DzuA/32gC
         sb8w==
X-Gm-Message-State: AFqh2kpeUQCizoQrjJZQEDBbvJMe4wmIh2KmZ9RQyVmis+XsoRnXe4Xm
        diPIc93tkBOlyriX0wf5/03rhA==
X-Google-Smtp-Source: AMrXdXtb2fPKAH9CAqjoC5q18pjjuckxEdT5g8d1o6d8o3PTJl5nze4drNNQT/6leObcHtgXBVnlHg==
X-Received: by 2002:a05:6a00:d75:b0:58a:fddd:9b1d with SMTP id n53-20020a056a000d7500b0058afddd9b1dmr9036491pfv.10.1673547704141;
        Thu, 12 Jan 2023 10:21:44 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id i11-20020aa796eb000000b0056d7cc80ea4sm12239775pfq.110.2023.01.12.10.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 10:21:43 -0800 (PST)
Date:   Thu, 12 Jan 2023 18:21:39 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Message-ID: <Y8BPs2269itL+WQe@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
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

On Tue, Jan 10, 2023, Chang S. Bae wrote:
> On 1/10/2023 6:49 AM, Aaron Lewis wrote:
> > 
> > When I run xcr0_cpuid_test it fails because
> > xstate_get_guest_group_perm() reports partial support on SPR.  It's
> > reporting 0x206e7 rather than the 0x6e7 I was hoping for.  That's why
> > I went down the road of sanitizing xcr0.  Though, if it's expected for
> > that to report something valid then sanitizing seems like the wrong
> > approach.  If xcr0 is invalid it should stay invalid, and it should
> > cause a test to fail.
> 
> FWIW, we have this [1]:
> 
> /* Features which are dynamically enabled for a process on request */
> #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
> 
> IOW, TILE_CFG is not part of the dynamic state. Because this state is not
> XFD-supported, we can't enforce the state use. SDM has relevant text here
> [2]:
> 
> "LDTILECFG and TILERELEASE initialize the TILEDATA state component. An
> execution of either of these instructions does not generate #NM when
> XCR0[18] = IA32_XFD[18] = 1; instead, it initializes TILEDATA normally.
> (Note that STTILECFG does not use the TILEDATA state component. Thus, an
> execution of this instruction does
> not generate #NM when XCR0[18] = IA32_XFD[18] = 1.)"
> 
> > Looking at how xstate_get_guest_group_perm() comes through with
> > invalid bits I came across this commit:
> > 
> > 2308ee57d93d ("x86/fpu/amx: Enable the AMX feature in 64-bit mode")
> > 
> > -       /* [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE, */
> > +       [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE_DATA,
> > 
> > Seems like it should really be:
> > 
> > +       [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE,
> 
> Thus, the change was intentional as far as I can remember.
> 
> Thank,
> Chang
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/include/asm/fpu/xstate.h#n50
> [2] SDM Vol 1. 13.14 Extended Feature Disable (XFD), https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
> 

Hmm. Given that XFEATURE_XTILE_DATA is a dynamic feature, that means
XFEATURE_XTILE_CFG could be set without XFEATURE_XTILE_DATA. Shall we
also consider loose the constraints at __kvm_set_xcr() as well?

https://elixir.bootlin.com/linux/v6.1.4/source/arch/x86/kvm/x86.c#L1079
