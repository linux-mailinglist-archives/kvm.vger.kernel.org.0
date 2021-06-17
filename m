Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FB73AB63F
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFQOoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 10:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhFQOoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 10:44:21 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2480C061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 07:42:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k5so3916182pjj.1
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 07:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CwEef3A5uzfK+vbXwM1YGYM7y2atWh5LmG1LdqlD9Dg=;
        b=Bwd+ibDb06qJbWwx0HCP8axXRmqmGDZSKyUAlHLlLGFU0S4uBSg4Tv/s0fXjs3+z1w
         anezO/AT6LFMIWC0QrDb0Ez40DOk/SX5BEwptFobmgjS4DLoO1g2NEUyrMgZtPk8CJ0T
         NT2zLg3wpInOamcMHxv15OqgChhpQ7Z1lzIhYIz3+vys+sGIjYMySt+U2iKfxpQChEuj
         xX46Q9ItjVhD9zN9s3aVuw72RuawTGHceMd0fOZ/14zAdgdE/SAI9GL6bSKefBDJyVkx
         NrzqsHZNiMOMbHRm0W0Xi35nJ4lg4fTrwcnALa7gg9alnsc4tSU24N3h/hNLwBKewBHa
         ExyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CwEef3A5uzfK+vbXwM1YGYM7y2atWh5LmG1LdqlD9Dg=;
        b=tfnnc4vmmyUS49QmFaewHLoHvb2aQW1W8QBYp/xHXcYR9VIb0qiWz6GYIYF+ykNV+i
         cqZlpY06iromTQewrbqVCE2lG47kBrxuq2HeEa9jXM7Epo+HyvIKAra4/Vj4cGjYjTOX
         E/NuO05xetIz0OwdosQT3YYcfv8gUHkmXt0tIJ9JoitSMU0ELwO0l0tCf3ri2Eg5EV+X
         G09rBb5Ytwfz3LZsDPTL7q1zlIpmXFI32YQsgVqmickb3bv1cspMZbyYgmrNkGa6mypt
         S5LLeb9E5SEX/XeSvmUU9g2seUmJXxItcjwBXWLrSfhGNuOSXvCsg785MAWYvd864mu8
         fH5Q==
X-Gm-Message-State: AOAM531EmMRq6rflLtpQyZeIDPyA+oRi6FQCi/FYWCZzKdzk9Hx29cUn
        t32QvVXJAA22MduVDtXogE3puw==
X-Google-Smtp-Source: ABdhPJyrd7kPZ0H6h/LRDHtexp4Ic0KXqgfn7DV5qM/wNMYJ1esayzE3SLkBavNH9Hs8UFzjA4y6Ww==
X-Received: by 2002:a17:90a:1a:: with SMTP id 26mr16760248pja.187.1623940933069;
        Thu, 17 Jun 2021 07:42:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q21sm5893571pfn.81.2021.06.17.07.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 07:42:12 -0700 (PDT)
Date:   Thu, 17 Jun 2021 14:42:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     stsp <stsp2@yandex.ru>
Cc:     kvm@vger.kernel.org
Subject: Re: guest/host mem out of sync on core2duo?
Message-ID: <YMtfQHGJL7XP/0Rq@google.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dropped my old @intel email to stop getting bounces.

On Mon, Jun 14, 2021, stsp wrote:
> 14.06.2021 20:06, Sean Christopherson пишет:
> > On Sun, Jun 13, 2021, stsp wrote:
> > > Hi kvm developers.
> > > 
> > > I am having the strange problem that can only be reproduced on a core2duo CPU
> > > but not AMD FX or Intel Core I7.
> > > 
> > > My code has 2 ways of setting the guest registers: one is the guest's ring0
> > > stub that just pops all regs from stack and does iret to ring3.  That works
> > > fine.  But sometimes I use KVM_SET_SREGS and resume the VM directly to ring3.
> > > That randomly results in either a good run or invalid guest state return, or
> > > a page fault in guest.
> > Hmm, a core2duo failure is more than likely due to lack of unrestricted guest.
> > You verify this by loading kvm_intel on the Core i7 with unrestricted_guest=0.
> 
> Wow, excellent shot!  Indeed, the problem then starts reproducing also there!
> So at least I now have a problematic setup myself, rather than needing to ask
> for ssh from everyone involved. :)
> 
> What does this mean to us, though?  That its completely unrelated to any
> memory synchronization?

Yes, more than likely this has nothing to do with memory synchronization.

> > > I tried to analyze when either of the above happens exactly, and I have a
> > > very strong suspection that the problem is in a way I update LDT. LDT is
> > > shared between guest and host with KVM_SET_USER_MEMORY_REGION, and I modify
> > > it on host.  So it seems like if I just allocated the new LDT entry, there is
> > > a risk of invalid guest state, as if the guest's LDT still doesn't have it.
> > > If I modified some LDT entry, there can be a page fault in guest, as if the
> > > entry is still old.
> > IIUC, you are updating the LDT itself, e.g. an FS/GS descriptor in the LDT, as
> > opposed to updating the LDT descriptor in the GDT?
> 
> I am updating the LDT itself, not modifying its descriptor in gdt. And with
> the same KVM_SET_SREGS call I also update the segregs to the new values, if
> needed.

Hmm, unconditionally calling KVM_SET_SREGS if you modify anything in the LDT
would be worth trying.  Or did I misunderstand the "if needed" part?

> > Either way, do you also update all relevant segments via KVM_SET_SREGS after
> > modifying memory?
> 
> Yes, if this is needed.  Sometimes its not needed, and when not - it seems
> page fault is more likely. If I also update segregs - then invalid guest
> state.  But these are just the statistical guesses so far.

Ah.  Hrm.  It would still be worth doing KVM_SET_SREGS unconditionally, e.g. it
would narrow the search if the page faults go away and the failures are always
invalid guest state.

> >     Best guess is that KVM doesn't detect that the VM has state
> > that needs to be emulated, or that KVM's internal register state and what's in
> > memory are not consistent.
> 
> Hope you know what parts are emulated w/o unrestricted guest, in which case
> we can advance. :)

It's not parts per se.  KVM needs to emulate "everything", one instruction at a
time, until guest state is no longer invalid with respec to the !unrestricted
rules.

> > Anyways, I highly doubt this is a memory synchronization issue, a corner case
> > related to lack of unrestricted guest is much more likely.
> 
> Just to be sure I tried the CD bit in CR0 to rule out the caching issues, and
> that changes nothing.  So...
>
> What to do next?

In addition to the above experiment, can you get a state dump for the invalid
guest state failure?  I.e. load kvm_intel with dump_invalid_vmcs=1.  And on that
failure, also provide the input to KVM_SET_SREGS.  The LDT in memory might also
be interesting, but it's hopefully unnecessary, especially if unconditionally
doing kVM_SET_SREGS makes the page faults go away.

Best case scenario is that KVM_SET_SREGS stuffs invalid guest state that KVM
doesn't correct detect.  That would be easy to debug and fix, and would give us
a regression test as well.
