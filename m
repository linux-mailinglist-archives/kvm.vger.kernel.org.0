Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6540B622
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 19:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhINRp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 13:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhINRp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 13:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B0816058D;
        Tue, 14 Sep 2021 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631641480;
        bh=7zOoRROj4qQXQjkpq+dxBC1mAeQSGkD2A+Ff6IkKOes=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pdpK/iN0awS7M9vGY7xVyEZECCZ8A0aHvdvkagSxyFV8sqmmRREshby7GRc0P3nEf
         gYoaT7Oig98XXdhrUkziKzP215zE4FizO4K0Gu3CojXEAb6d0JErefvF5KmUzIMLZw
         Oc5jAcs/JW0tBLDLXQ/vplbFVnoyI156kntQoDClatuJFdr4edXtU301j51+U15oe/
         CuJsFR4+435+rUQYAyJluVdKoQJdei1Uq4b8ZrQKbOwNx6PaIwmwUgUQMOhqFVZCaq
         5glssfuvALjoSQtjvyAoswXiEzoOxIxh4pehACIzEzIorwMbf7iBeC2XSjxGOhMkQL
         eP7Acc1V3dk0Q==
Message-ID: <ec1425c0d46e60feabb31aac58c7dce70d18ae54.camel@kernel.org>
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE
 all pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com
Date:   Tue, 14 Sep 2021 20:44:37 +0300
In-Reply-To: <b87fbe2fe213976fa43fb82d5d483da8e6b1bc63.camel@kernel.org>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210914071030.GA28797@yangzhon-Virtual>
         <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
         <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
         <1afa3ed3-d77b-163d-e35e-30bf4f5d3a9e@redhat.com>
         <b87fbe2fe213976fa43fb82d5d483da8e6b1bc63.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 20:40 +0300, Jarkko Sakkinen wrote:
> On Tue, 2021-09-14 at 19:07 +0200, Paolo Bonzini wrote:
> > On 14/09/21 18:42, Jarkko Sakkinen wrote:
> > > > Let's wait for this patch to be accepted first.  I'll wait a little=
 more
> > > > for Jarkko and Dave to comment on this, and include your "Tested-by=
".
> > > >=20
> > > > I will also add cond_resched() on the final submission.
> > > Why these would be conflicting tasks? I.e. why could not QEMU use
> > > what is available now and move forward using better mechanism, when
> > > they are available?
> >=20
> > The implementation using close/open is quite ugly (destroying and=20
> > recreating the memory block breaks a few levels of abstractions), so=
=20
> > it's not really something I'd like to commit.
>=20
> OK, so the driving reason for SGX_IOC_VEPC_RESET is the complex dance
> with opening, closing and mmapping() stuff, especially when dealing
> with multiple sections for one VM? OK, I think I can understand this,
> given how notorious it might be to get stable in the user space.
>=20
> Please just document this use case some way (if I got it right) to
> the commit message of the next version, and I think this starts to
> make much more sense.

I would call it bottleneck rather than race though. I would keep
race for the things that can cause real race condition inside the
kernel corrupting data structures or whatever.

But for sure it is bottleneck that can easily cause user space to
be racy without extra-ordinary carefulness.

/Jarkko
