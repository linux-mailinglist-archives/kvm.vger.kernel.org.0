Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7811B6EA375
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 08:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjDUGDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 02:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDUGDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 02:03:49 -0400
Received: from out-39.mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65995FEB
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 23:03:44 -0700 (PDT)
Date:   Fri, 21 Apr 2023 08:03:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682056994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GLUmC9H+9RxFtugacEvdATX+CChqgi4H1gkmw8BEN6w=;
        b=YOO5aKUMU9RQ+lrbigjRLLeZGTPltl41apKIWxpfSPk4TNQvP6+klJo33r8y7sx3lzD5wX
        0vZ3f4MJBvdq3m6zhxm6juOYuMmGZ6q5xnQkFLPiI5EvAVaF0z0u5enIq30cFedK5UPCQ8
        B1yYwhoWy4Asxt778T8JksFnu8AdMFM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
Message-ID: <jh7en6xd3lipjkalz673uvxccjf5cuxyk2h4yowfe25utlsr3r@l4iqzqgpbxtk>
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-5-aaronlewis@google.com>
 <ZBzM6M/Bm69KIGQQ@google.com>
 <ZD1sx+G2oWchaleW@google.com>
 <ZD6xWYI7Uin01fA7@google.com>
 <mtdi6smhur5rqffvpu7qux7mptonw223y2653x2nwzvgm72nlo@zyc4w3kwl3rg>
 <ZEF7T/FG1hUWRRWR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEF7T/FG1hUWRRWR@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 10:50:07AM -0700, Sean Christopherson wrote:
> On Tue, Apr 18, 2023, Andrew Jones wrote:
> > On Tue, Apr 18, 2023 at 08:03:53AM -0700, Sean Christopherson wrote:
> > > On Mon, Apr 17, 2023, Aaron Lewis wrote:
> > > > On Thu, Mar 23, 2023, Sean Christopherson wrote:
> > > > > > +static char *number(char *str, long num, int base, int size, int precision,
> > > > > > +		    int type)
> > > > > 
> > > > > Do we actually need a custom number()?  I.e. can we sub in a libc equivalent?
> > > > > That would reduce the craziness of this file by more than a few degrees.
> > > > 
> > > > Yeah, I think we need it.  One of the biggest problems I'm trying to avoid
> > > > here is the use of LIBC in a guest.  Using it always seems to end poorly
> > > > because guests generally don't set up AVX-512 or a TLS segmet, nor should
> > > > they have to.  Calling into LIBC seems to require both of them too often,
> > > > so it seems like it's better to just avoid it.
> > > 
> > > True, we'd probably end up in a world of hurt.
> > > 
> > > I was going to suggest copy+pasting from a different source, e.g. musl, in the
> > > hopes of reducing the crazy by a degree, but after looking at the musl source,
> > > that's a terrible idea :-)
> > > 
> > > And copying from the kernel has the advantage of keeping any bugs/quirks that
> > > users may be expecting and/or relying on.
> > 
> > What about trying to use tools/include/nolibc/? Maybe we could provide our
> > own tools/include/nolibc/arch-*.h files where the my_syscall* macros get
> > implemented with ucalls, and then the ucalls would implement the syscalls,
> > possibly just forwarding the parameters to real syscalls. We can implement
> > copy_from/to_guest() functions to deal with pointer parameters.
> 
> Hmm, I was going to say that pulling in nolibc would conflict with the host side's
> need for an actual libc, but I think we could solve that conundrum by putting
> ucall_fmt() in a dedicated file and compiling it separately, a la string_override.c.
> 
> However, I don't think we'd want to override my_syscall to do a ucall.  If I'm
> reading the code correctly, that would trigger a ucall after every escape sequence,
> which isn't what we want, expecially for a GUEST_ASSERT.
> 
> That's solvable by having my_syscall3() be a memcpy() to the buffer provided by
> KVM's guest-side vsprintf(), but that still leaves the question of whether or not
> taking a dependency on nolibc.h would be a net positive.
> 
> E.g. pulling in nolibc.h as-is would well and truly put ucall_fmt.c (or whatever
> it's called) into its own world, e.g. it would end up with different typedefs for
> all basic types.  Those shouldn't cause problems, but it'd be a weird setup.  And
> I don't think we can rule out the possibility of the nolibc dependency causing
> subtle problems, e.g. what will happen when linking due to both nolibc and
> string_override.c defining globally visible mem{cmp,cpy,set}() functions.
> 
> Another minor issue is that nolibc's vfprintf() handles a subset of escapes compared
> to the kernel's vsprintf().  That probably won't be a big deal in practice, but it's
> again a potential maintenance concern for us in the future.
> 
> I'm definitely torn.  As much as I dislike the idea of copy+pasting mode code into
> KVM selftests, I think pulling in nolibc would bring its own set of problems.
> 
> My vote is probably to copy+paste, at least for the initial implementation.  Being
> able to do the equivalent of printf() in the guest would be a huge improvement for
> debugging and triaging selftests, i.e. is something I would like to see landed
> fairly quickly.

Fully agree.

> Copy+pasting seems like it gives us the fastest path forward,
> e.g. doesn't risk getting bogged down with weird linker errors and whatnot.

Works for me.

Thanks,
drew
