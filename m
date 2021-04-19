Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7FC36487D
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbhDSQsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhDSQsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:48:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D42C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:47:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e7so41463540edu.10
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULkhNyBkJhOzd2MtmJFa/N3rtzrsuHnW3mv/d14HWLM=;
        b=VhD8JcHZqBlTxK0XiSAT5abkUGtYvRrHraP88rp2g6d4qMhjN8AND+EUCqq3ybh02J
         isTHDXjYPTnOPp7ahTnaAu3susndWiDiTaNMNnTT2LI8ZZ6lnWG4g+ogCbvuRFN6cCaX
         rWgU4SOkaJsBpZV+Tzcb7B3gEPlCUcan+L/Ejttdbp90P+tUIfDsEwLxoYFKNVcYZ0kc
         IcEcx2hApvd/93kBuK8KtD8Q8FZ3iNvHK/FoBU1i+LRiq8QEytRm46Ej7a0mD424D6eJ
         Xrj+gYTQPPu+TqGYnhmfcJdtTrfvjeDcSDHkY/FbrsUQbTgDTLBwofYPV2vtiy5iOWup
         xuOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULkhNyBkJhOzd2MtmJFa/N3rtzrsuHnW3mv/d14HWLM=;
        b=CFWectAaBfEWIyDx+iXnXD6Rxbxp2wEv0fgU6Pzil2Z2C0BVGGawJQ6I7/rqsMwFPk
         lg7MRPfLWXsdcBPbOxBiyzH8eHuWqOz5TnZ+VprgbPGXbQv9KcorIAKtQuA+wm9DYWsp
         pMAgCf8DUtVetZ/xcNppH25h4fugLvVaEiVNMyquKRDa1s5CSRXbE/tFA9qxGKYurERs
         mNQzeJcjIq2Dp5Myc7Gle2NE82U7BcZjnGsD5MFpeKjJoN8rngyZYrtMaLUwZmUrFB4q
         QFtWtrlyOegXUQ3OC6HXxMu37kzJuBmy9yO0mNa84oRKEVKfwbdpF3ZaMe/KHzPhJdbP
         dVOQ==
X-Gm-Message-State: AOAM530gWwdyqxmtIiaKa8x/touj86Hpy5wPfMXSr7GpvT1KrvGGlHSw
        aQ5Mlgd1r17oKBV4sjiS6s8JtmfYbQl/ZqqYHpNtIQ==
X-Google-Smtp-Source: ABdhPJxNiWi2JhW9wjSbgaz+5jZJ4+e/AuWvZuRuM1kzspnXfEdKUNV2b790X2dS9VFF4IUusotQcntY9d5emh7qRW8=
X-Received: by 2002:aa7:c492:: with SMTP id m18mr3594976edq.30.1618850850281;
 Mon, 19 Apr 2021 09:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210416131820.2566571-1-aaronlewis@google.com> <cunblaaqwe0.fsf@dme.org>
In-Reply-To: <cunblaaqwe0.fsf@dme.org>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 19 Apr 2021 09:47:19 -0700
Message-ID: <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Add a fallback mechanism to the in-kernel instruction emulator that
> > allows userspace the opportunity to process an instruction the emulator
> > was unable to.  When the in-kernel instruction emulator fails to process
> > an instruction it will either inject a #UD into the guest or exit to
> > userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> > not know how to proceed in an appropriate manner.  This feature lets
> > userspace get involved to see if it can figure out a better path
> > forward.
>
> Given that you are intending to try and handle the instruction in
> user-space, it seems a little odd to overload the
> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION exit reason/sub
> error.
>
> Why not add a new exit reason, particularly given that the caller has to
> enable the capability to get the relevant data? (It would also remove
> the need for the flag field and any mechanism for packing multiple bits
> of detail into the structure.)

I considered that, but I opted for the extensibility of the exiting
KVM_EXIT_INTERNAL_ERROR instead.  To me it was six of one or half a
dozen of the other.  With either strategy I still wanted to provide
for future extensibility, and had a flags field in place.  That way we
can add to this in the future if we find something that is missing
(ie: potentially wanting a way to mark dirty pages, possibly passing a
fault address, etc...)

> > +/*
> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> > + * to describe what is contained in the exit struct.  The flags are used to
> > + * describe it's contents, and the contents should be in ascending numerical
> > + * order of the flag values.  For example, if the flag
> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> > + * length and instruction bytes would be expected to show up first because this
> > + * flag has the lowest numerical value (1) of all the other flags.
> > + */
> > +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> > +
> >  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
> >  struct kvm_run {
> >       /* in */
> > @@ -382,6 +393,14 @@ struct kvm_run {
> >                       __u32 ndata;
> >                       __u64 data[16];
> >               } internal;
> > +             /* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
> > +             struct {
> > +                     __u32 suberror;
> > +                     __u32 ndata;
> > +                     __u64 flags;
> > +                     __u8  insn_size;
> > +                     __u8  insn_bytes[15];
> > +             } emulation_failure;
> > +/*
> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> > + * to describe what is contained in the exit struct.  The flags are used to
> > + * describe it's contents, and the contents should be in ascending numerical
> > + * order of the flag values.  For example, if the flag
> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> > + * length and instruction bytes would be expected to show up first because this
> > + * flag has the lowest numerical value (1) of all the other flags.
>
> When adding a new flag, do I steal bytes from insn_bytes[] for my
> associated payload? If so, how many do I have to leave?
>

The emulation_failure struct mirrors the internal struct, so if you
are just adding to what I have, you can safely add up to 16 __u64's.
I'm currently using the size equivalent to 3 of them (flags,
insn_size, insn_bytes), so there should be plenty of space left for
you to add what you need to the end.  Just add the fields you need to
the end of emulation_failure struct, increase 'ndata' to the new
count, add a new flag to 'flags' so we know its contents.
