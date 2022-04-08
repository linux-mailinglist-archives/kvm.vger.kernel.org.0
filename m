Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B724F98A5
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiDHOxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 10:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiDHOxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 10:53:47 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D0010F6D7
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 07:51:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so9882260pjy.5
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 07:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oKpHuTCTVX/9mlJ3fOMLkg+SOJ3B85mD/CGTLhqUYcY=;
        b=IRlMOocycUdo2ggd59+k/x0mi14OomgysGOMJMR0BXqq9t+rkqur9z6Fm3wtr/nQ1h
         UJGYtVaU5HtC6Hnr/bQvw8KCOJYNkLEb9wuZ+F9dURfGH7nTatt44rzV3sz2ydGDQboY
         7csWkDkyZ1RHkYa1vSy1WrAOdBYgArlPOfSFIWy3EItX6vCGFcQckni5n8yqA/lDrvJj
         QZfsH19T9beBeIjf250Iry5yuLygxD80YH6Qmg8w8Zp2LuPKe4qFxvNUGCNAUEEhYAE/
         sHuPXER3Jn+RbPRFan5nnWHce+ZcgbBbTjCZYW96a1YIKzML+y2dfBbNCyUhlcuvxVsY
         plXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oKpHuTCTVX/9mlJ3fOMLkg+SOJ3B85mD/CGTLhqUYcY=;
        b=fMBOp9OsZk2OU2m2W9WY2zAIOK22bJbaQF8HpvdbE5NqY9ImrCqUyFBlRarljTkS8P
         BWQcxUO7wbB0Ut5OzjLReMqZhxCpoh1sjzcmESnRPpcCveNefAhahxm5UTxv0mreY/6w
         NGdWClQ7kquLh9LedEtz0mGg7Mgj6SjUskQ0RpJeLoHH+CaTErmLxp+r9/vB6z/ewfYB
         NJPVQZMHsudPgXfOC7eu72B7s3b7u/TzbtOzhvdQ3H2LsRe6D28Xgm1LDDRkuW2OnOZP
         DPclHtGCng7g813WRBIOvD8UY6gsiXt4AU3zECZC2gaD4riDGDUAsdf+qA6wpAAarsTf
         F9Dw==
X-Gm-Message-State: AOAM531eMUTmfsw3ZWrVroTn7++xFsEdz/giyHjVGhi8cCxBeuJV2yum
        6gk9/3PcU56lPhG2OnDshfaRAA==
X-Google-Smtp-Source: ABdhPJwK5E91BkazzZhqdilh1wfA2ctl2VJDZBvxKXgErNvw3ypqz09c901AZEW9sa1HYrXRoCPYbg==
X-Received: by 2002:a17:902:d507:b0:157:1e3b:ee76 with SMTP id b7-20020a170902d50700b001571e3bee76mr5302286plg.67.1649429503155;
        Fri, 08 Apr 2022 07:51:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h20-20020a056a001a5400b004fb1b4b010asm26840043pfv.162.2022.04.08.07.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 07:51:42 -0700 (PDT)
Date:   Fri, 8 Apr 2022 14:51:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <YlBL+0mDzuTMYGV9@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
 <Yk79A4EdiZoVQMsV@google.com>
 <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
 <20220408045842.GI2864606@ls.amr.corp.intel.com>
 <27a59f1a-ea74-2d75-0739-5521e7638c68@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a59f1a-ea74-2d75-0739-5521e7638c68@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022, Paolo Bonzini wrote:
> On 4/8/22 06:58, Isaku Yamahata wrote:
> > On Thu, Apr 07, 2022 at 05:56:05PM +0200,
> > Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > > You didn't answer the other question, which is "Where is R12 documented for
> > > TDG.VP.VMCALL<Instruction.HLT>?" though...  Should I be worried? :)
> > 
> > It's publicly documented.
> > 
> > Guest-Host-Communication Interface(GHCI) spec, 344426-003US Feburary 2022.
> > 3.8 TDG.VP.VMCALL<Instruction.HLT>
> > R12 Interrupt Blocked Flag.
> >      The TD is expected to clear this flag iff RFLAGS.IF == 1 or the TDCALL instruction
> >      (that invoked TDG.VP.TDVMCALL(Instruction.HLT)) immediately follows an STI
> >      instruction, otherwise this flag should be set.
> 
> Oh, Google doesn't know about this version of the spec...  It can be
> downloaded from https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
> though.
> 
> I also found VCPU_STATE_DETAILS in https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf:
> 
>   Bit 0: VMXIP, indicates that a virtual interrupt is pending
>   delivery, i.e. VMCS.RVI[7:4] > TDVPS.VAPIC.VPPR[7:4]
> 
> It also documents how it has to be used.  So this looks more or less okay,
> just rename "vmxip" to "interrupt_pending_delivery".

If we're keeping the call back into SEAM, then this belongs in the path of
apic_has_interrupt_for_ppr(), not in the HLT-exit path.  To avoid multiple SEAMCALLS
in a single exit, VCPU_EXREG_RVI can be added.
