Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4510D345FB5
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhCWNcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:32:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230250AbhCWNbm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 09:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616506301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8l7g23i0w5a8B0qb0dS1u6UnMLYyrn13O6xOpACWm9g=;
        b=YzRnt11pwaOt7RxBwDHqKtTpYM+uhYg8Zn+qu7g3GbFsrwSBtyju5E37iVtcCfpQEaZmlg
        hv0e6v03GxzKU0HovvXjlwHJIZxYd+GtCunAQNMdyOfzzEN0jl/m0bFyV8NL1aK97p33VP
        8/mw2/dgWa2YOq+3XWz5J/92QnT7EZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-CtOCObdcNFCiTyoQwuyf0w-1; Tue, 23 Mar 2021 09:31:36 -0400
X-MC-Unique: CtOCObdcNFCiTyoQwuyf0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04D1C180FCA6;
        Tue, 23 Mar 2021 13:31:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F10D9CA0;
        Tue, 23 Mar 2021 13:31:33 +0000 (UTC)
Date:   Tue, 23 Mar 2021 14:31:30 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210323133130.aujlhqvdqy6zusvj@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
 <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
 <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
 <f60f2012-b007-b9db-e680-1ecf110e343d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f60f2012-b007-b9db-e680-1ecf110e343d@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 02:01:47PM +0100, Thomas Huth wrote:
> On 23/03/2021 13.14, Andrew Jones wrote:
> > On Mon, Mar 22, 2021 at 09:35:23AM +0100, Andrew Jones wrote:
> > > @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
> > >               c = *s - 'A' + 10;
> > >           else
> > >               break;
> > > -        acc = acc * base + c;
> > > +
> > > +        if (is_signed) {
> > > +            long __acc = (long)acc;
> > > +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> > > +            assert(!overflow);
> > > +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
> > > +            assert(!overflow);
> > > +            acc = (unsigned long)__acc;
> > > +        } else {
> > > +            overflow = __builtin_umull_overflow(acc, base, &acc);
> > > +            assert(!overflow);
> > > +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
> > > +            assert(!overflow);
> > > +        }
> > > +
> > 
> > Unfortunately my use of these builtins isn't loved by older compilers,
> > like the one used by the build-centos7 pipeline in our gitlab CI. I
> > could wrap them in an #if GCC_VERSION >= 50100 and just have the old
> > 'acc = acc * base + c' as the fallback, but that's not pretty and
> > would also mean that clang would use the fallback too. Maybe we can
> > try and make our compiler.h more fancy in order to provide a
> > COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW define like linux does for
> > both gcc and clang. Or, we could just forgot the overflow checking.
> > 
> > Anybody else have suggestions? Paolo? Thomas?
> 
> What does a "normal" libc implementation do (e.g. glibc)? If it is also not
> doing overflow checking, I think we also don't need it in the
> kvm-unit-tests.
>

You'll get LONG_MAX for strtol and ULONG_MAX for strtoul and errno will be
set to ERANGE.

Thanks,
drew

