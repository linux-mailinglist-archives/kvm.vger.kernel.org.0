Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6172D54F6D7
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 13:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381819AbiFQLjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 07:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380126AbiFQLjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 07:39:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDDF5A0A9;
        Fri, 17 Jun 2022 04:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KiwPkQU7A4VOjqjjcy7oDsNGb93k5UOyD9PqekH8rm0=; b=oDvQbGklpawwNO9iOP5fXHlrm3
        34uucaw/4esCO4fl21ya2Dq9mNmiC4V3UKcuoXql1MONITTIeTX+wRB2iKgFIXxpwclOMfn/pMbJY
        eCvQ6UyEpARjvl4srHQ08QJCHJpgmwJaPfVULStZ8TD/83nttAf47cJiq6vQhBQrc7yVEfEprcYl4
        TgnLldr/DvuZphqprj7rydmoqJ+olXTKW7z/Y9SYXl6OjMpVymOIksPkL/23NaF8f8jb1Cldbdj0r
        pelIpgv7Rpn2uZlNrjJP1EfXuIq9yu0W6DB1z1ZJaz8CeA7VA64cHng1mg4MlOVkx5jo2nPMPNP8k
        CVlN2ygw==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2AJG-002nYp-SK; Fri, 17 Jun 2022 11:38:43 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2F7599816B5; Fri, 17 Jun 2022 13:38:41 +0200 (CEST)
Date:   Fri, 17 Jun 2022 13:38:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/19] x86/cpufeatures: Enable CET CR4 bit for shadow
 stack
Message-ID: <YqxnwRn+/c+i1vL6@worktop.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-4-weijiang.yang@intel.com>
 <YqsEyoaxPFpZcolP@hirez.programming.kicks-ass.net>
 <ca4e04f2dcc33849ebb9bf128f6ff632b5ffe747.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca4e04f2dcc33849ebb9bf128f6ff632b5ffe747.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 05:12:47PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2022-06-16 at 12:24 +0200, Peter Zijlstra wrote:
> > On Thu, Jun 16, 2022 at 04:46:27AM -0400, Yang Weijiang wrote:
> > > --- a/arch/x86/include/asm/cpu.h
> > > +++ b/arch/x86/include/asm/cpu.h
> > > @@ -74,7 +74,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> > >   static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
> > >   #endif
> > >   
> > > -extern __noendbr void cet_disable(void);
> > > +extern __noendbr void ibt_disable(void);
> > >   
> > >   struct ucode_cpu_info;
> > >   
> > > diff --git a/arch/x86/kernel/cpu/common.c
> > > b/arch/x86/kernel/cpu/common.c
> > > index c296cb1c0113..86102a8d451e 100644
> > > --- a/arch/x86/kernel/cpu/common.c
> > > +++ b/arch/x86/kernel/cpu/common.c
> > > @@ -598,23 +598,23 @@ __noendbr void ibt_restore(u64 save)
> > >   
> > > -__noendbr void cet_disable(void)
> > > +__noendbr void ibt_disable(void)
> > >   {
> > >        if (cpu_feature_enabled(X86_FEATURE_IBT))
> > >                wrmsrl(MSR_IA32_S_CET, 0);
> > 
> > Not sure about this rename; it really disables all of (S) CET.
> > 
> > Specifically, once we do S-SHSTK (after FRED) we might also very much
> > need to kill that for kexec.
> 
> Sure, what about something like sup_cet_disable()?

Why bother? Arguably kexec should clear U_CET too.
