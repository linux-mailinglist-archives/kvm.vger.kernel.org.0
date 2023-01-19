Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD1673DAA
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjASPhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjASPhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:37:43 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED948016F
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:37:42 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c6so2655846pls.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 07:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=St2kBtgvxum7SrYgXTkZ6Xbz6xO368GgeLmznULzIQ4=;
        b=T9t1KZW6rZnUrXATe3hJpWVtiuLPXSBmSAiN3bmtyHq9LRPj86td2VCStQA6YJ3fxt
         iOxwOzMAevAVckpom+ueVAtT7EfzSGbozlWo2c9TbVOubp1qP0KOdFkcdYBvZ/JPnbul
         4nhiJmgoAoGAKFQwVOzEV3i5evm4L9BwwW/+ZPND5qg5+MVl79as+4gz7spkkv/SwWBV
         qA63HJ0eJ0KcZoWLkKpKbOGS/THY5LdZIcHl/beZcfDq9THBUcmXvzzrC1Zh3ZTXRXf1
         IE2b0S8w282IlybL2x1CChX51dz8pz40tXO5nZOCNcNDqZzx3dI9X8NeSKvJyB/n6K/c
         KDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=St2kBtgvxum7SrYgXTkZ6Xbz6xO368GgeLmznULzIQ4=;
        b=LwEECQ1moNxceLWq7ArspvQGaU6pmGU45Zlh/f8kDIXGGv9OGpfNAycqfw+l76Tg7q
         4/gv3R4Z7nvaYwyq1VjLcJ+uyGyXF2WsV+8wJVfU5Tgo2C79rkHpd73shPjo/6IV8/JI
         VujIADnSNO/FA8hz/Tm+wybOqFLj5hQnyoEpmT/ETrtgm1p8sKkcAFCfKYohop6TtSca
         NQ2/snjf3OxG1GwpN5thgrlRbOnyF9FSfeee6GI9uIdJNRccB2caayPvlUgmJwlSL88U
         DbGPI2+NiPd/slbu4UCdL7Y3MwgofcqOAGnXSLbRd/TCadK6lUAPk7qBg/1Yzy3FV6E2
         cFFA==
X-Gm-Message-State: AFqh2kqUE+/FBBJW3Kckb9DHFRiB3DMQW0HFIEUrOHLP3JNeCvu5WniX
        VAy/kpR8xFUo7Nhe/K1Wa1Wa5Q==
X-Google-Smtp-Source: AMrXdXsXOnJzuoeE4rQxKeVlHVnhqCH2JoKYoXCGYXPq1kiMno6iPux7AfXgOO3mfcMbesSukaPNug==
X-Received: by 2002:a17:90b:274b:b0:219:f970:5119 with SMTP id qi11-20020a17090b274b00b00219f9705119mr3193015pjb.1.1674142662190;
        Thu, 19 Jan 2023 07:37:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a474100b002262dd8a39bsm3199885pjg.49.2023.01.19.07.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 07:37:41 -0800 (PST)
Date:   Thu, 19 Jan 2023 15:37:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8ljwsrrBBdh1aYw@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
 <20230113151258.00006a6d@gmail.com>
 <Y8F1uPsW56fVdhmC@google.com>
 <20230114111621.00001840@gmail.com>
 <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>
 <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
 <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
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

On Thu, Jan 19, 2023, Huang, Kai wrote:
> On Tue, 2023-01-17 at 21:01 +0000, Sean Christopherson wrote:
> > On Tue, Jan 17, 2023, Sean Christopherson wrote:
> > > On Tue, Jan 17, 2023, Zhi Wang wrote:
> > > > 2) As TDX module doesn't provide contention-and-wait, I guess the following
> > > > approach might have been discussed when designing this "retry".
> > > > 
> > > > KERNEL                          TDX MODULE
> > > > 
> > > > SEAMCALL A   ->                 PATH A: Taking locks
> > > > 
> > > > SEAMCALL B   ->                 PATH B: Contention on a lock
> > > > 
> > > >              <-                 Return "operand busy"
> > > > 
> > > > SEAMCALL B   -|
> > > >               |  <- Wait on a kernel waitqueue
> > > > SEAMCALL B  <-|
> > > > 
> > > > SEAMCALL A   <-                 PATH A: Return
> > > > 
> > > > SEAMCALL A   -|
> > > >               |  <- Wake up the waitqueue
> > > > SEMACALL A  <-| 
> > > > 
> > > > SEAMCALL B  ->                  PATH B: Taking the locks
> > > > ...
> > > > 
> > > > Why not this scheme wasn't chosen?
> > > 
> > > AFAIK, I don't think a waitqueue approach as ever been discussed publicly.  Intel
> > > may have considered the idea internally, but I don't recall anything being proposed
> > > publically (though it's entirely possible I just missed the discussion).
> > > 
> > > Anways, I don't think a waitqueue would be a good fit, at least not for S-EPT
> > > management, which AFAICT is the only scenario where KVM does the arbitrary "retry
> > > X times and hope things work".  If the contention occurs due to the TDX Module
> > > taking an S-EPT lock in VM-Enter, then KVM won't get a chance to do the "Wake up
> > > the waitqueue" action until the next VM-Exit, which IIUC is well after the TDX
> > > Module drops the S-EPT lock.  In other words, immediately retrying and then punting
> > > the problem further up the stack in KVM does seem to be the least awful "solution"
> > > if there's contention.
> > 
> > Oh, the other important piece I forgot to mention is that dropping mmu_lock deep
> > in KVM's MMU in order to wait isn't always an option.  Most flows would play nice
> > with dropping mmu_lock and sleeping, but some paths, e.g. from the mmu_notifier,
> > (conditionally) disallow sleeping.
> 
> Could we do something similar to tdp_mmu_iter_cond_resched() but not simple busy
> retrying "X times",  at least at those paths that can release mmu_lock()?

That's effectively what happens by unwinding up the stak with an error code.
Eventually the page fault handler will get the error and retry the guest.

> Basically we treat TDX_OPERAND_BUSY as seamcall_needbreak(), similar to
> rwlock_needbreak().  I haven't thought about details though.

I am strongly opposed to that approach.  I do not want to pollute KVM's MMU code
with a bunch of retry logic and error handling just because the TDX module is
ultra paranoid and hostile to hypervisors.

The problematic scenario of faulting indefinitely on a single instruction should
never happen under normal circumstances, and so KVM should treat such scenarios
as attacks/breakage and pass the buck to userspace.
