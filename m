Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987AC6A140B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 01:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBXAB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 19:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBXABz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 19:01:55 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE76B5D441
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 16:01:54 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id n66-20020a634045000000b004e8c27fa528so4590594pga.17
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 16:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kF9RXFfW4wy/6v+hu6QKUyjo3A7avgqXTaYUDzf4v+o=;
        b=oKzrIec+uPL9k0AWbKiPPXDC1WISvxEX89WToEHQW/LBFPOzYICzXojB75UXoEbB5h
         h0aJcsgweskMlxyZNuSez7gQ11H05Tt6gUgZjOgsxCqlWArudof57TM17L42iHYH2IWk
         wFaLc2/ekwvy1ujy1MfZU2lNvRH0G17y0ydhdhQWNg3s02GGPFuUMXbMqHTlMEW6ibCU
         IC8/2d1KLbB2ADuERRCTpF67BqOuP5OeaKPAMq/gTkiaKg3QVyFIHQOxwQtiKuM69J9T
         77E3kCL7aCtB5+rijjeBHmfpFnFrtwsvsxfVhYaNccEaLFN+wE69lw6/8LNmgZqb5gU8
         mU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kF9RXFfW4wy/6v+hu6QKUyjo3A7avgqXTaYUDzf4v+o=;
        b=pBPIbg6/JP2ZF97erh9REbcOifWcg3bJI2FpBLIoY5fwlfZR0+LfNzDpAQzANn6SMD
         aJdcTfiTLWAbN9t/Njsy+3Gqztm3bAXrvFO3fZ4vbLdN39pjFxXk2cAMjRAc4AwOs4kK
         SRPEoVgO4IowrVpFQns1iAjJF/ZgN8aBpLPub8zqYgPxEh2BObplKUoxmI39xMGb/RIP
         Ep4lOX/zM09vVSIyR6UzJJBACbfIPo+Qsp8ZiMEnXQlwzQmoZaooc3JSouhAyvM5rpae
         /ebgbXFERb0L/joD4HOv1axRTjDyK+Iv9adJHduagNBNLZu8IoYypfctVj79FeWvgmAm
         PW6A==
X-Gm-Message-State: AO0yUKVb6pCeAjYOC0JUHWLJCXYx14boo1Z357Rr9ADgIjv+h6H5fJlf
        Q0BRluqFLbqakjnl3Ror0knstEIqcis=
X-Google-Smtp-Source: AK7set9OG918m99+OEerzvOiY2szCjCR9m3/A5AQh//PXrQMBFeMkbl5ebqjSOkEmTKzy0Cg7K0mBSmR0cg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d94:b0:5a8:aaa1:6c05 with SMTP id
 fb20-20020a056a002d9400b005a8aaa16c05mr3315952pfb.2.1677196914157; Thu, 23
 Feb 2023 16:01:54 -0800 (PST)
Date:   Thu, 23 Feb 2023 16:01:52 -0800
In-Reply-To: <CAF7b7mqV4p_t4yJx6yyFFk7AQ2w6jVDCXUQfA+aza_OQya2qfA@mail.gmail.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
 <Y+6iX6a22+GEuH1b@google.com> <CAF7b7mqeXcHdFHewX3enn-vxf6y7CUWjXjB3TXithZ_PnzVLQQ@mail.gmail.com>
 <Y+/kgMxQPOswAz/2@google.com> <CAF7b7mpMiw=6o6vTsqFR6HUUCJL+1MSTDUsMaKLnS1NqyVf-9A@mail.gmail.com>
 <Y/fS0eab7GG0NVKS@google.com> <CAF7b7mqV4p_t4yJx6yyFFk7AQ2w6jVDCXUQfA+aza_OQya2qfA@mail.gmail.com>
Message-ID: <Y/f+cFe2uyaO5qCY@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Anish Moorthy wrote:
> On Thu, Feb 23, 2023 at 12:55=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > (3) switched over to a memslot flag: KVM_CAP_MEMORY_FAULT_EXIT simply
> > > indicates whether this flag is supported.
> >
> > The new memslot flag should depend on KVM_CAP_MEMORY_FAULT_EXIT, but
> > KVM_CAP_MEMORY_FAULT_EXIT should be a standalone thing, i.e. should con=
vert "all"
> > guest-memory -EFAULTS to KVM_CAP_MEMORY_FAULT_EXIT.  All in quotes beca=
use I would
> > likely be ok with a partial conversion for the initial implementation i=
f there
> > are paths that would require an absurd amount of work to convert.
>=20
> I'm actually not sure where all of the sources of guest-memory -EFAULTs a=
re
> or how I'd go about finding them.

Heh, if anyone can says they can list _all_ sources of KVM accesses to gues=
t
memory of the top of their head, they're lying.

Finding the sources is a bit tedious, but shouldn't be too hard.  The scope=
 is
is -EFAULT in the context of KVM_RUN that gets returned to userspace.  Ther=
e are
150+ references to -EFAULT to wade through, but the vast majority are obvio=
usly
not in scope, e.g. are for uaccess failures in other ioctls().

> Is the standalone behavior of KVM_CAP_MEMORY_FAULT_EXIT something you're
> suggesting because that new name is too broad for what it does right now?

No, I want a standalone thing because I want to start driving toward KVM ne=
ver
returning -EFAULT to host userspace for accesses to guest memory in the con=
text
of ioctl(KVM_RUN).  E.g. I want to replace the "return -EFAULT" in
kvm_handle_error_pfn() with something like "return kvm_handle_memory_fault_=
exit(...)".

My hope/goal is that return useful information will allow userspace to do m=
ore
interesting things with guest memory without needing invasive, one-off chan=
ges
to KVM.  At the very least, it should get us to the point where a memory fa=
ult
from KVM_RUN exits to userspace with sane, helpful information, not a gener=
ic
"-EFAULT, have fun debugging!".

> If so then I'd rather just rename it again: but if that functionality sho=
uld
> be included with this series, then I'll take a look at the required work
> given a couple of pointers :)
>=20
> I will say, a partial implementation seems worse than no
> implementation: isn't there a risk that someone ends up depending on
> the incomplete behavior?

In this case, I don't think so.  We definitely would need to document that =
KVM
may still return -EFAULT in certain scenarios, but we have at least one kno=
wn
use case (this one) where catching the common cases is sufficient.  And if/=
when
use cases come along that need 100% accuracy, we can hunt down and fix the =
KVM
remaining "bugs".
