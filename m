Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06526E68F6
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 18:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjDRQHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 12:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjDRQHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 12:07:10 -0400
Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [IPv6:2001:41d0:203:375::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C80013855
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 09:06:45 -0700 (PDT)
Date:   Tue, 18 Apr 2023 18:06:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681834002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jmiAqw9jRQesPOsNfje0YT7wvXlTEA5G6lmy0pKz3+k=;
        b=G72y7iAkW1Py+ukjPD5x6Ck+jW++xKV4EW2ObO0SEX2KovUlb1gbj8f3XckjlXXaLMvY51
        J7103geMUhntBvxkvxnb5BKG/ekbzQr3WCeX9QhUpHuGKWTM8ljjxoS908lmWi4PX4MMTh
        WaDkE1l0yTXQsq1sj7yP4m6I6u1TXUM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
Message-ID: <mtdi6smhur5rqffvpu7qux7mptonw223y2653x2nwzvgm72nlo@zyc4w3kwl3rg>
References: <20230301053425.3880773-1-aaronlewis@google.com>
 <20230301053425.3880773-5-aaronlewis@google.com>
 <ZBzM6M/Bm69KIGQQ@google.com>
 <ZD1sx+G2oWchaleW@google.com>
 <ZD6xWYI7Uin01fA7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD6xWYI7Uin01fA7@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023 at 08:03:53AM -0700, Sean Christopherson wrote:
> On Mon, Apr 17, 2023, Aaron Lewis wrote:
> > On Thu, Mar 23, 2023, Sean Christopherson wrote:
> > > > +static char *number(char *str, long num, int base, int size, int precision,
> > > > +		    int type)
> > > 
> > > Do we actually need a custom number()?  I.e. can we sub in a libc equivalent?
> > > That would reduce the craziness of this file by more than a few degrees.
> > 
> > Yeah, I think we need it.  One of the biggest problems I'm trying to avoid
> > here is the use of LIBC in a guest.  Using it always seems to end poorly
> > because guests generally don't set up AVX-512 or a TLS segmet, nor should
> > they have to.  Calling into LIBC seems to require both of them too often,
> > so it seems like it's better to just avoid it.
> 
> True, we'd probably end up in a world of hurt.
> 
> I was going to suggest copy+pasting from a different source, e.g. musl, in the
> hopes of reducing the crazy by a degree, but after looking at the musl source,
> that's a terrible idea :-)
> 
> And copying from the kernel has the advantage of keeping any bugs/quirks that
> users may be expecting and/or relying on.

What about trying to use tools/include/nolibc/? Maybe we could provide our
own tools/include/nolibc/arch-*.h files where the my_syscall* macros get
implemented with ucalls, and then the ucalls would implement the syscalls,
possibly just forwarding the parameters to real syscalls. We can implement
copy_from/to_guest() functions to deal with pointer parameters.

Thanks,
drew
