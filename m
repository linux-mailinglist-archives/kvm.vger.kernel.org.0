Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFED158915B
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbiHCR0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238199AbiHCR0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:26:32 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EBA5466C;
        Wed,  3 Aug 2022 10:26:31 -0700 (PDT)
Date:   Wed, 3 Aug 2022 19:26:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659547588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8NMuAukSe+1ZysY/i41tuUcdy8SvruIfHl+Sl/siV2I=;
        b=Z3/Zvlb12ML3SvK7r4emgW2rDeOpkLqAI/R2u089c21HLyhGeB4csl3io4K9D/coa6xh/3
        tHJt6l9aKkoI9p/WmOwzbWxt+BtEEYCxUhgk8Fxb3cut4MEpd8gG6N/JEJ+jpZQxBD4Ck4
        bNtYM+l9Qnk0ulasgj1rnH2HGpnfBXs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jinrong Liang <ljr.kernel@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in
 selftests/kvm/rseq_test.c
Message-ID: <20220803172627.kccwzda6eshx3vol@kamzik>
References: <20220802071240.84626-1-cloudliang@tencent.com>
 <20220802150830.rgzeg47enbpsucbr@kamzik>
 <CAFg_LQWB5hV9CLnavsCmsLbQCMdj1wqe-gVP7vp_mRGt+Eh+nQ@mail.gmail.com>
 <20220803142637.3y5fj2cwyvbrwect@kamzik>
 <YuqeDetNukKp9lyF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuqeDetNukKp9lyF@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 04:10:53PM +0000, Sean Christopherson wrote:
> On Wed, Aug 03, 2022, Andrew Jones wrote:
> > On Wed, Aug 03, 2022 at 09:58:51PM +0800, Jinrong Liang wrote:
> > > My ldd version is (GNU libc) 2.28, and I get a compilation error in this case.
> > > But I use another ldd (Ubuntu GLIBC 2.31-0ubuntu9.2) 2.31 is compiling fine.
> > > This shows that compilation errors may occur in different GNU libc environments.
> > > Would it be more appropriate to use syscall for better compatibility?
> > 
> > OK, it's a pity, but no big deal to use syscall().
> 
> Ya, https://man7.org/linux/man-pages/man2/gettid.2.html says:
> 
>   The gettid() system call first appeared on Linux in kernel 2.4.11.  Library
>   support was added in glibc 2.30.
> 
> But there are already two other instances of syscall(SYS_gettid) in KVM selftests,
> tools/testing/selftests/kvm/lib/assert.c even adds a _gettid() wrapper.

Ha! And I found four more in selftests...

testing/selftests/powerpc/include/utils.h
testing/selftests/proc/proc.h
testing/selftests/rseq/param_test.c
testing/selftests/sched/cs_prctl_test.c

and even more in tools...

> 
> So rather than having to remember (or discover) to use syscall(SYS_gettid), I wonder
> if it's possible to conditionally define gettid()?  E.g. check for GLIBC version?
> Or do
> 
>   #define gettid() syscall(SYS_gettid)
> 
> so that it's always available and simply overrides the library's gettid() if it's
> provided?

Sounds good to me. Now the question is where to put it? kvm_util.h,
test_util.h, or maybe we should create a new header just for stuff
like this?

It doesn't really "fit" in kvm_util.h, but if we put it there, then we
greatly reduce the chance that we'll have to revisit this issue again.
We could also create a new header just for stuff like this and then
include that from kvm_util.h...

Thanks,
drew
