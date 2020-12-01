Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3779D2CA5E5
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 15:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391600AbgLAOjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 09:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391592AbgLAOjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 09:39:23 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F96C0613CF
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 06:38:43 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id d18so3557995edt.7
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 06:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gsC6GsVJiLqPrUOX64utpZZU09t0XnUAVIJF2SWD/30=;
        b=kQtQbycmM6skcs5hwocRzk67vRxHCFlrEIUIU7j9gDs1wbckGjRGYVQHYl0TSMfxbg
         dwFHns3fmFa/cinCLTY9K2n/ABouMEQLBi+U4tO6wodXvQrEoLnQETJ3nWCrf2Dm7be4
         zwcp/k1icSGeEUPUhxqrEjRQKgxCmQVLkNDopSH7QbdzbOtWGMRwNPtoX68bh7sKOfrx
         lXD8/WSQFX8fXCRiyuDy5sUQ0ujCO4bxALbA7u46aphmlsXZvxdCSmiw1Wj/tbkhWplF
         KzmvsPCulcO+OtxsjXKfWdCnIKktdXC4TaLR0VXijxwBYmjnQGHuhWdcJ+JNGpxBKXfT
         a2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gsC6GsVJiLqPrUOX64utpZZU09t0XnUAVIJF2SWD/30=;
        b=E8qE6FbSbeL5F/iA4/EIFrIHsmUrLABptc+l2ocKUvzrnFhuIOvMvb8r8Nf20niUAJ
         razqpu64jm2rWRSkW55sAbeE1L7HfE9kFP3YeX75nFvVD1UtMWos+LNWnTpCLT7UdJRD
         USdGi6b5AbSf6BHGYqJUr0CBNftW6DGoE0DRYhGF4jqjgu2PR3HK0KK1qegEW0P1IWAb
         ZZDtUw/eQ2g4XooB2tp2Wrufb0THOMBEUDv5Fds2JbQyMY9Zgigl/GJJBCKCmJYIXRdZ
         HDdERxhOyJwsRfOGUVvXlphgWKVly2DmYwk4oLI5FeWW9WdPi+K9gvjYw6teV11sGilC
         TrqQ==
X-Gm-Message-State: AOAM533L8PeeAc8PpjyPQOeGytWpGOjzR4eWbTEs0fqm6BFYHiXYBNcN
        oS2D511hbEcQ+zMByghaXkm32ffKLveC6hqrJxShqQ==
X-Google-Smtp-Source: ABdhPJxMPQW7LJJS5pyVRbNSjcgs0+GsYDaPb/F2cn4/AJTkdE74agN/ofoQh/dGFF7x4uym2StOA7vl7Zijl+TAdow=
X-Received: by 2002:a05:6402:3089:: with SMTP id de9mr3356535edb.100.1606833521805;
 Tue, 01 Dec 2020 06:38:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
 <CAFEAcA8=3ngeErUEaR-=qGQymKv5JSd-ZXz+hg7L46J_nWDUnQ@mail.gmail.com> <20201201142756.GA27617@ashkalra_ubuntu_server>
In-Reply-To: <20201201142756.GA27617@ashkalra_ubuntu_server>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 14:38:30 +0000
Message-ID: <CAFEAcA8tJ7NZ1xVeZUhxYYTpjiZ7GJzDtcUPBWVO5C8cgLURVw@mail.gmail.com>
Subject: Re: [PATCH 02/11] exec: Add new MemoryDebugOps.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Dec 2020 at 14:28, Ashish Kalra <ashish.kalra@amd.com> wrote:
> On Tue, Dec 01, 2020 at 11:48:23AM +0000, Peter Maydell wrote:
> > This seems like a weird place to insert these hooks. Not
> > all debug related accesses are going to go via
> > cpu_memory_rw_debug(). For instance when the gdb stub is in
> > "PhyMemMode" and all addresses from the debugger are treated as
> > physical rather than virtual, gdbstub.c will call
> > cpu_physical_memory_write()/_read().
> >
> > I would have expected the "oh, this is a debug access, do
> > something special" to be at a lower level, so that any
> > address_space_* access to the guest memory with the debug
> > attribute gets the magic treatment, whether that was done
> > as a direct "read this physaddr" or via cpu_memory_rw_debug()
> > doing the virt-to-phys conversion first.
> >
>
> Actually, the earlier patch-set used to do this at a lower level,
> i.e., at the address_space level, but then Paolo's feedback on that
> was that we don't want to add debug specific hooks into generic code
> such as address_space_* interfaces, hence, these hooks are introduced at
> a higher level so that we can do this "debug" abstraction at
> cpu_memory_rw_debug() and adding new interfaces for physical memory
> read/write debugging such as cpu_physical_memory_rw_debug().

This seems to be mixing two separate designs, then. Either
you want to try to provide separate "debug" functions like this,
or you want to have a MemTxAttrs "debug" attribute, but you don't
need both. Personally I prefer the MemTxAttrs approach (and disagree
with Paolo :-)), because otherwise you're going to end up duplicating
a lot of functions, and the handling of "this memory is encrypted
and needs special handling" ends up being dealt with in various
layers of the code rather than being only in one place where the
lowest layer says "oh, debug access to encrypted memory, this is
how to do that".

> This seems logical too as cpu_memory_rw_debug() is invoked via the
> debugger, i.e., either gdbstub or qemu monitor, so this interface seems
> to be the right place to add these hooks.

Except that as noted, although all uses of cpu_memory_rw_debug()
are debug related, not all debug related accesses are to
cpu_memory_rw_debug()... The interesting characteristics of
cpu_memory_rw_debug() are (1) it takes a virtual address rather
than physical (2) it writes to ROMs (3) it refuses to write to
devices.

thanks
-- PMM
