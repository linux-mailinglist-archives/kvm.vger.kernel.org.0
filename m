Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59964F8494
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345951AbiDGQKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 12:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345803AbiDGQKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 12:10:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1179EA94D9
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 09:08:30 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 32so3202821pgl.4
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 09:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hZYvN1HtpiMWFnNuQjMBXb03gZgQM/PZsPG90Kr0xZ4=;
        b=G5m5k4vQXUwL1k+L0eJSqU5MDgQfzgDVie8hMWVBvOwKPK0MPeq3Uw7smawUjYYmXZ
         C5VyAER0920ta43X8fpVnjeRGq5sHWMfWXgZrtQJKGED38+6CAnXw8jBo/5p2G/76qoO
         GD7j1kN3/HbBq9/VBZufLoXfI7gHFNN0iGxQeSERHEtWYsmiWdQOQfqrx79jV3ByWVId
         58glwc+Myxl4sngQ6KXGcu9rMDrS3QDFmeK+zT3/xZakxZvFc0RT8prt99hyN0nCp5LT
         FJjYJ9uFnCbHmlOkhbIGkbXmLl6pAKGxpCV2+L6ECJ8cx/v9i2iWZR+XMworgwKI9dCG
         r7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hZYvN1HtpiMWFnNuQjMBXb03gZgQM/PZsPG90Kr0xZ4=;
        b=qQXRflGGeN6jUeLM1gS2D/6PH4Zy5qpwD/41GxFJqXA6Tk5kGrfJwVG3POHO0iPAuv
         WTWJ4obp/lpLRb4+QeOp6KZwhY3l1yQ4xjTNxeOU4vctnSSDFXvXT5omWE1Wjo7lFmZA
         lCgIHABM/eM3npbFlAwbwAAhk5nSrA8abMnrjTmVTB/abCr/feBtjHgrFBV/jMAyYD4F
         XysT8BGND1+mMZ4j9NHrxSQbk6DuoxOK+K/N94fVRRe5JqFchF8cNXXiZ0GCBcHDkOWe
         2F2PPEC5CNLBWOviPjZbHSNLudMAGP5xT6Oh3FEf8Gv+me4P1pCmj0scstPesKiYKTZ0
         /AMQ==
X-Gm-Message-State: AOAM533d6U6rAH2+JPI/4GRwC4Wfoe3x1c/LCCD+Diw2+Uc5gonFYRhx
        4/Ln5SZjGSAwkTHBgnGVW0Czjw==
X-Google-Smtp-Source: ABdhPJzDMgA0eAdeiuBlSIjIz5dT4QwAPRd0qqCxgTtRtMrnGJI9OhKCqbXfxGtGb/pO3q7COLjQTw==
X-Received: by 2002:a05:6a00:2d0:b0:4f4:1f34:e39d with SMTP id b16-20020a056a0002d000b004f41f34e39dmr14947659pft.14.1649347709341;
        Thu, 07 Apr 2022 09:08:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 83-20020a621556000000b004fe5d8c5cf3sm5054446pfv.156.2022.04.07.09.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 09:08:28 -0700 (PDT)
Date:   Thu, 7 Apr 2022 16:08:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <Yk8MeSuKuiNJHTgI@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
 <Yk79A4EdiZoVQMsV@google.com>
 <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> On 4/7/22 17:02, Sean Christopherson wrote:
> > On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> > > On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> > > > +	bool interrupt_disabled = tdvmcall_p1_read(vcpu);
> > > 
> > > Where is R12 documented for TDG.VP.VMCALL<Instruction.HLT>?
> > > 
> > > > +		 * Virtual interrupt can arrive after TDG.VM.VMCALL<HLT> during
> > > > +		 * the TDX module executing.  On the other hand, KVM doesn't
> > > > +		 * know if vcpu was executing in the guest TD or the TDX module.
> > > 
> > > I don't understand this; why isn't it enough to check PI.ON or something
> > > like that as part of HLT emulation?
> > 
> > Ooh, I think I remember what this is.  This is for the case where the virtual
> > interrupt is recognized, i.e. set in vmcs.RVI, between the STI and "HLT".  KVM
> > doesn't have access to RVI and the interrupt is no longer in the PID (because it
> > was "recognized".  It doesn't get delivered in the guest because the TDCALL
> > completes before interrupts are enabled.
> > 
> > I lobbied to get this fixed in the TDX module by immediately resuming the guest
> > in this case, but obviously that was unsuccessful.
> 
> So the TDX module sets RVI while in an STI interrupt shadow.  So far so
> good.  Then:
> 
> - it receives the HLT TDCALL from the guest.  The interrupt shadow at this
> point is gone.
> 
> - it knows that there is an interrupt that can be delivered (RVI > PPR &&
> EFLAGS.IF=1, the other conditions of 29.2.2 don't matter)
> 
> - it forwards the HLT TDCALL nevertheless, to a clueless hypervisor that has
> no way to glean either RVI or PPR?
> 
> It's absurd that this be treated as anything but a bug.

That's what I said!  :-)
