Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53824670CEF
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjAQXNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjAQXMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:12:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C74446D65
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:56:22 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k13so2217354plg.0
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWUEuVg2yLbTHhqGOKyu9+dynRi4bd1JoGcQcp8LkiE=;
        b=CDR7oKCSBCtZ7Uc6Kccsr0D1zllHnPIaN6GhkhQWPOiXtmAlruy0P841YnVvkQEdxb
         nJubvqqOeKZCIc88MmU8d1wSeuQ3VRxjgt2EHZPftdgGm1Oxhn/ty/MkPPRdK8w/39eb
         46cXmu/CQDDOI/F0rJpCaxo6lTMZXAI88izYbeSxGFmUdG84scp0kLvq+kZP8u6G3Auu
         nSn7AI65adzRexcXErxJOOnUNqmc1fOtO5eTgSwJG8AJbuQVVdA9ZD0DfwGbpEg9g3bB
         MKbzalcJIvTWZMnRM1MTjKQETtypbhC4/C4pU/IJ+PHvth1t9tinEXj6S0oFWorXahkb
         G4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWUEuVg2yLbTHhqGOKyu9+dynRi4bd1JoGcQcp8LkiE=;
        b=HPncEDxCpnjT+bm0c8thE22vl7LUa0luivqHd7RmAEUwtyr+EzqxVMaq3bbyjwkHvH
         t4OuuN/BFgZPPN6o/PrrVLlrzNJMgnBf11VMJsuRhKJxdxjsOzkn6r3qr8Mf7it6X62d
         4IUJtf5TuQ8BQq1zKf7XDN6BrJg8ATbr8UOGbv4Le4rKrVYczstQncdeJ4OgtPWCk7ur
         2lZc0vRJ/6Viosd8ZQlrUGT++AjxklyuYqST+9/auEhoWGZJbkfWHZkTdSaURChk9ycO
         Q6qKbsYBffosH8CVs32JkBg14+dYKPPY6aM0NlvzqOHAXxG2sMSqJSpzD6WRWw+md6n6
         NcAQ==
X-Gm-Message-State: AFqh2kpkOIpidUvegFBp0OrmwWnmgxq/LGWijZkR0d9YPRlMubAYDEvA
        MalBuX4c/2LTEcm6yXaN7kkaSw==
X-Google-Smtp-Source: AMrXdXvMnv6DNWNWJNTeOXhjc6KqDbYltMUPd/NjKUObtCSPm5o9Rt930RYPL0nc90qlXIH89q5ioA==
X-Received: by 2002:a17:903:2614:b0:193:256d:8afe with SMTP id jd20-20020a170903261400b00193256d8afemr2327220plb.2.1673988981743;
        Tue, 17 Jan 2023 12:56:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709028d8700b00186bc66d2cbsm21698818plo.73.2023.01.17.12.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 12:56:21 -0800 (PST)
Date:   Tue, 17 Jan 2023 20:56:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8cLcY12zDWqO8nd@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
 <20230113151258.00006a6d@gmail.com>
 <Y8F1uPsW56fVdhmC@google.com>
 <20230114111621.00001840@gmail.com>
 <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117214414.00003229@gmail.com>
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

On Tue, Jan 17, 2023, Zhi Wang wrote:
> On Tue, 17 Jan 2023 15:55:53 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Sat, Jan 14, 2023, Zhi Wang wrote:
> > > On Fri, 13 Jan 2023 15:16:08 +0000 > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > > On Fri, Jan 13, 2023, Zhi Wang wrote:
> > > > > Better add a FIXME: here as this has to be fixed later.
> > > > 
> > > > No, leaking the page is all KVM can reasonably do here.  An improved
> > > > comment would be helpful, but no code change is required.
> > > > tdx_reclaim_page() returns an error if and only if there's an
> > > > unexpected, fatal error, e.g. a SEAMCALL with bad params, incorrect
> > > > concurrency in KVM, a TDX Module bug, etc.  Retrying at a later point is
> > > > highly unlikely to be successful.
> > > 
> > > Hi:
> > > 
> > > The word "leaking" sounds like a situation left unhandled temporarily.
> > > 
> > > I checked the source code of the TDX module[1] for the possible reason to
> > > fail when reviewing this patch:
> > > 
> > > tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_reclaim.c
> > > tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_wbinvd.c
> > > 
> > > a. Invalid parameters. For example, page is not aligned, PA HKID is not zero...
> > > 
> > > For invalid parameters, a WARN_ON_ONCE() + return value is good enough as
> > > that is how kernel handles similar situations. The caller takes the
> > > responsibility.
> > >  
> > > b. Locks has been taken in TDX module. TDR page has been locked due to another
> > > SEAMCALL, another SEAMCALL is doing PAMT walk and holding PAMT lock... 
> > > 
> > > This needs to be improved later either by retry or taking tdx_lock to avoid
> > > TDX module fails on this.
> > 
> > No, tdx_reclaim_page() already retries TDH.PHYMEM.PAGE.RECLAIM if the target page
> > is contended (though I'd question the validity of even that), and TDH.PHYMEM.PAGE.WBINVD
> > is performed only when reclaiming the TDR.  If there's contention when reclaiming
> > the TDR, then KVM effectively has a use-after-free bug, i.e. leaking the page is
> > the least of our worries.
> > 
> 
> Hi:
> 
> Thanks for the reply. "Leaking" is the consquence of even failing in retry. I
> agree with this. But I was questioning if "retry" is really a correct and only
> solution when encountering lock contention in the TDX module as I saw that there
> are quite some magic numbers are going to be introduced because of "retry" and
> there were discussions about times of retry should be 3 or 1000 in TDX guest
> on hyper-V patches. It doesn't sound right.

Ah, yeah, I'm speaking only with respect to leaking pages on failure in this
specific scenario.

> Compare to an typical *kernel lock* case, an execution path can wait on a
> waitqueue and later will be woken up. We usually do contention-wait-and-retry
> and we rarely just do contention and retry X times. In TDX case, I understand
> that it is hard for the TDX module to provide similar solutions as an execution
> path can't stay long in the TDX module.

Let me preface the below comments by saying that this is the first time that I've
seen the "Single-Step and Zero-Step Attacks Mitigation Mechanisms" behavior, i.e.
the first time I've been made aware that the TDX Module can apparently decide
to take S-EPT locks in the VM-Enter path.

> 
> 1) We can always take tdx_lock (linux kernel lock) when calling a SEAMCALL
> that touch the TDX internal locks. But the downside is we might lose some
> concurrency.

This isn't really feasible in practice.  Even if tdx_lock were made a spinlock
(it's currently a mutex) so that it could it could be taken inside kvm->mmu_lock,
acquiring a per-VM lock, let alone a global lock, in KVM's page fault handling
path is not an option.  KVM has a hard requirement these days of being able to
handle multiple page faults in parallel.

> 2) As TDX module doesn't provide contention-and-wait, I guess the following
> approach might have been discussed when designing this "retry".
> 
> KERNEL                          TDX MODULE
> 
> SEAMCALL A   ->                 PATH A: Taking locks
> 
> SEAMCALL B   ->                 PATH B: Contention on a lock
> 
>              <-                 Return "operand busy"
> 
> SEAMCALL B   -|
>               |  <- Wait on a kernel waitqueue
> SEAMCALL B  <-|
> 
> SEAMCALL A   <-                 PATH A: Return
> 
> SEAMCALL A   -|
>               |  <- Wake up the waitqueue
> SEMACALL A  <-| 
> 
> SEAMCALL B  ->                  PATH B: Taking the locks
> ...
> 
> Why not this scheme wasn't chosen?

AFAIK, I don't think a waitqueue approach as ever been discussed publicly.  Intel
may have considered the idea internally, but I don't recall anything being proposed
publically (though it's entirely possible I just missed the discussion).

Anways, I don't think a waitqueue would be a good fit, at least not for S-EPT
management, which AFAICT is the only scenario where KVM does the arbitrary "retry
X times and hope things work".  If the contention occurs due to the TDX Module
taking an S-EPT lock in VM-Enter, then KVM won't get a chance to do the "Wake up
the waitqueue" action until the next VM-Exit, which IIUC is well after the TDX
Module drops the S-EPT lock.  In other words, immediately retrying and then punting
the problem further up the stack in KVM does seem to be the least awful "solution"
if there's contention.

That said, I 100% agree that the arbitrary retry stuff is awful.  The zero-step
interaction in particular isn't acceptable.

Intel folks, encountering "TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT" on VM-Enter
needs to be treated as a KVM bug, even if it means teaching KVM to kill the VM
if a vCPU is on the cusp of triggerring the "pre-determined number" of EPT faults
mentioned in this snippet:

  After a pre-determined number of such EPT violations occur on the same instruction,
  the TDX module starts tracking the GPAs that caused Secure EPT faults and fails
  further host VMM attempts to enter the TD VCPU unless previously faulting private
  GPAs are properly mapped in the Secure EPT.

If the "pre-determined number" is too low to avoid false positives, e.g. if it can
be tripped by a vCPU spinning while a different vCPU finishes handling a fault,
then either the behavior of the TDX Module needs to be revisited, or KVM needs to
stall vCPUs that are approaching the threshold until all outstanding S-EPT faults
have been serviced.

KVM shouldn't be spuriously zapping private S-EPT entries since the backing memory
is pinned, which means the only way for a vCPU to truly get stuck faulting on a
single instruction is if userspace is broken/malicious, in which case userspace
gets to keep the pieces.
