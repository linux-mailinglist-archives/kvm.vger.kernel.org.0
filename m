Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A215D175A28
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 13:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgCBMPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 07:15:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:40759 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgCBMPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 07:15:16 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 022CEvNK020865;
        Mon, 2 Mar 2020 06:14:58 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 022CEtSw020859;
        Mon, 2 Mar 2020 06:14:55 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 2 Mar 2020 06:14:55 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.6-rc4 (or rc5)
Message-ID: <20200302121455.GH22482@gate.crashing.org>
References: <1583089390-36084-1-git-send-email-pbonzini@redhat.com> <CAHk-=wiin_LkqP2Cm5iPc5snUXYqZVoMFawZ-rjhZnawven8SA@mail.gmail.com> <87pndvrpvj.fsf@mpe.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pndvrpvj.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 02, 2020 at 09:51:44PM +1100, Michael Ellerman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > Michael, what tends to be the triggers for people using
> > PPC_DISABLE_WERROR? Do you have reports for it?
> 
> My memory is that we have had very few reports of it actually causing
> problems. But I don't have hard data to back that up.

I build all archs with GCC trunk.

It always breaks for me, with thousands of errors, which is why since
many years I carry 21 lines of patch to thoroughly disable -Werror for
the powerpc arch.  It takes over a year from when a warning is added to
the kernel taking care of it -- and of course, I build with the current
development version of the compiler, so I get to see many misfiring
warnings and other fallout as well.  (Currently there are more than 100
warnings, this is way too many to consider attacking that as well).

> It has tripped up the Clang folks, but that's partly because they're
> building clang HEAD, and also because ~zero powerpc kernel developers
> are building regularly with clang. I'm trying to fix the latter ...

Is anyone building regularly with GCC HEAD?  Power or any other arch?

> And then building with GCC head sometimes requires disabling -Werror
> because of some new warning, sometimes valid sometimes not.

Yes.  And never worth breaking the build for.

-Werror is something you use if you do not trust your developers.

Warnings are not errors.  The compiler warns for things that
heuristically look suspicious.  And it errors for things that are wrong.

Some warnings have many false positives, but are so useful (find many
nasty problems, for example) that it is worth enabling them often.
-Werror sabotages that, giving people an extra incentive to disable
useful warnings.

> I think we could mostly avoid those problems by having the option only
> on by default for known compiler versions.

Well, the kernel disables most useful warnings anyway, so that might
even work, sure.

> It'd also be nice if we could do:
> 
>  $ make WERROR=0
> 
> Or something similarly obvious to turn off the WERROR option. That way
> users don't even have to edit their .config manually, they just rerun
> make with WERROR=0 and it works.

That would be nice, yes, that would help my situation as well.


Segher
