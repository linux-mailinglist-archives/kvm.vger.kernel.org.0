Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4132345ED5
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhCWNA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:00:29 -0400
Received: from foss.arm.com ([217.140.110.172]:46010 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhCWNAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 09:00:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1487DD6E;
        Tue, 23 Mar 2021 06:00:08 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05AAD3F719;
        Tue, 23 Mar 2021 06:00:06 -0700 (PDT)
Date:   Tue, 23 Mar 2021 13:00:01 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210323130001.7f160eaa@slackpad.fritz.box>
In-Reply-To: <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
        <20210318180727.116004-2-nikos.nikoleris@arm.com>
        <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
        <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 13:14:15 +0100
Andrew Jones <drjones@redhat.com> wrote:

Hi,

> On Mon, Mar 22, 2021 at 09:35:23AM +0100, Andrew Jones wrote:
> > @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
> >              c = *s - 'A' + 10;
> >          else
> >              break;
> > -        acc = acc * base + c;
> > +
> > +        if (is_signed) {
> > +            long __acc = (long)acc;
> > +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> > +            assert(!overflow);
> > +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
> > +            assert(!overflow);
> > +            acc = (unsigned long)__acc;
> > +        } else {
> > +            overflow = __builtin_umull_overflow(acc, base, &acc);
> > +            assert(!overflow);
> > +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
> > +            assert(!overflow);
> > +        }
> > +  
> 
> Unfortunately my use of these builtins isn't loved by older compilers,
> like the one used by the build-centos7 pipeline in our gitlab CI. I
> could wrap them in an #if GCC_VERSION >= 50100 and just have the old
> 'acc = acc * base + c' as the fallback, but that's not pretty and
> would also mean that clang would use the fallback too. Maybe we can
> try and make our compiler.h more fancy in order to provide a
> COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW define like linux does for
> both gcc and clang. Or, we could just forgot the overflow checking.

In line with my email from yesterday:
Before we go down the path of all evil (premature optimisation!), can't
we just copy
https://git.kernel.org/pub/scm/libs/klibc/klibc.git/tree/usr/klibc/strntoumax.c
and have a tested version that works everywhere? This is BSD/GPL dual
licensed, IIUC.
I don't really see the reason to performance optimise strtol in the
context of kvm-unit-tests.

Cheers,
Andre
