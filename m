Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A134AAF52
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 14:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbiBFNIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 08:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiBFNIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 08:08:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29FC06173B;
        Sun,  6 Feb 2022 05:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r+gFF/vh5cSrP7KvoK/nIgqjizm6gE7sf4GkpA389wU=; b=BxgIxsrU2QJcX39YxBcIRdWY9m
        1InCvuuhaZSBAHPDyxkW4kpQEW0PNI5OxHuRe2VyAKR+rsthjZyBtDoLV9v7P5gRABQlP+rDck/2T
        0Eum8llSq5MxbwmLQpdYtcwBE5lCjmmPWl/g3fZasID1Jm2FK8DaxmlkyVaAq7eksYG4vwOFtylsF
        ByER5B38SETjK5k2BRG8SlZO3f49/oYQqWjBa94ODbHh0LFJZkMFeF/tx37n3wBcNQiV2YbfXfJZ7
        empLcdFZ4dEfuW7xG5uJjCMhH1bF6ec2hmMvDRlW5hjO4ndYT9fBGOZQcYkdr18YfQKWXiF6erKkV
        wpLVj/lA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nGhHM-007QNp-1l; Sun, 06 Feb 2022 13:08:32 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9E68198622D; Sun,  6 Feb 2022 14:08:30 +0100 (CET)
Date:   Sun, 6 Feb 2022 14:08:30 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <20220206130830.GC23216@worktop.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 09:35:49AM -0800, Sami Tolvanen wrote:
> On Wed, Feb 2, 2022 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
> >
> > Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
> > function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
> > for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.
> >
> > We could fudge around the issue by using stubs, massaging prototypes, etc..., but
> > that means doing that for every arch-agnostic user of __static_call_return0().
> >
> > Any clever ideas?  Can we do something like generate a unique function for every
> > DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
> > get the prototype?
> 
> I'm not sure there's a clever fix for this. On architectures without
> HAVE_STATIC_CALL, this is an indirect call to a function with a
> mismatching type, which CFI is intended to catch.
> 
> The obvious way to solve the problem would be to use a stub function
> with the correct type, which I agree, isn't going to scale. You can
> alternatively check if .func points to __static_call_return0 and not
> make the indirect call if it does. If neither of these options are
> feasible, you can disable CFI checking in the functions that have
> these static calls using the __nocfi attribute.

There's also the tp_stub_func() thing that does basically the same
thing.
