Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D250264AE8F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 05:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiLMEMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 23:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiLMEMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 23:12:31 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EFC17058
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 20:12:29 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id t17so2063920pjo.3
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 20:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0phE3o9mO3P/oDVOwXOrXlOT+3nv35crWDJ9EleFA8k=;
        b=sHBTPQS7PuFFom9l/xeN0gQMYHSKFT3zGrmxWMVKhuPySFVYag+kJAbhHFpnxYQtTj
         ACtt9S5s6ZRr2LPCKm+77ySWReIfb0ZwtiZxzHzIox4AnAWoHb1bhleYODAlIX4bjmqz
         OIuti1iFmb+ldG8BTUpx52Q2V8c2gk9bYDiQ7UTYVng/JrXqnTwoGjqFUvwvG/1xp8jz
         I06WTCgq0XP+tGVKVr4aX/lpZjqc7fPOgr8B5Nhv7xuneieXDxgndnOZeITArpHBjfrt
         cMIcd9zZHQPc1tmek2hMUJdKdp4oRB2lD5JrDDlqPEBKoMSuLnSNZRwkyEFD04gH4dVk
         pRyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0phE3o9mO3P/oDVOwXOrXlOT+3nv35crWDJ9EleFA8k=;
        b=1bCq+BB565ARfYqpP8ZcsSoguSd4iXJFJXUaJ7XsthGtz3Jd30JEfFxL1c1vJAUWM5
         B9UaONf/UX+S7GvVXB9gFhNNlvK9hW9DDsxcJmgi34ch++WIwDM7T6v0iByYJZpqxF3n
         HLrLAubLMMvPrOEGZ/9TQbDK6LUnj8QP4zKc7UsFDLdQJvLSSsHsdJo5DsYY0iC3C6Kx
         1tkMSCDM1IhN87M0POA0xVhHT5F9FicS9jeIz/g+BZQKjC18fvB/knbAZMtQ435QJHFA
         Dy2TNwHLaAVLptGXBZsek5MXgAuYewh++MhppplKkF6d3nclw+ywkxSvo24Ka6F54ogl
         G2ng==
X-Gm-Message-State: ANoB5pmadBHms0N4KOMM4BT7cY/2cVfiV1ErrLVGnZcT41BH0nKKPsM4
        dpALpxhz0FddW4h0SfGYQ7QVpA==
X-Google-Smtp-Source: AA0mqf6Q/0eTmnGfJNcE+7MMOSleUzEAQxVrRiuBTqrUwYwc1ZEVGXINl0fsk0ZvLHVGoeS5yx/HHw==
X-Received: by 2002:a05:6a21:1583:b0:a3:d7b0:aeef with SMTP id nr3-20020a056a21158300b000a3d7b0aeefmr111868pzb.0.1670904748417;
        Mon, 12 Dec 2022 20:12:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id hk3-20020a17090b224300b002194319662asm6263318pjb.42.2022.12.12.20.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 20:12:27 -0800 (PST)
Date:   Tue, 13 Dec 2022 04:12:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH v4 0/2] Deprecate BUG() in pte_list_remove() in
 shadow mmu
Message-ID: <Y5f7qBp4zXAiENNh@google.com>
References: <20221129191237.31447-1-mizhang@google.com>
 <Y5Oob6mSJKGoDBnt@google.com>
 <Y5avm5VXpRt263wQ@google.com>
 <Y5dax8XJV0F5adUw@google.com>
 <CALzav=f2k9dPYkeW2D0ZvkDuDhA8Wmu+zV8W4isMFfd-HAQjrA@mail.gmail.com>
 <Y5fXxsPtDeMZn2nV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5fXxsPtDeMZn2nV@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022, Mingwei Zhang wrote:
> On Mon, Dec 12, 2022, David Matlack wrote:
> > > What about explicitly treating both get_mmio_spte() and this as potential data
> > > corruption?  E.g. something like this, and then use the DATA_CORRUPTION variant
> > > in pte_list_remove()?
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 2055e04b8f89..1cb69c6d186b 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4075,6 +4075,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
> > >                         pr_err("------ spte = 0x%llx level = %d, rsvd bits = 0x%llx",
> > >                                sptes[level], level,
> > >                                get_rsvd_bits(rsvd_check, sptes[level], level));
> > > +               KVM_BUG_ON_DATA_CORRUPTION(reserved, vcpu->kvm);

Random aside, this would be better:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 99c40617d325..d9c46f2a6748 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4090,7 +4090,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
                return RET_PF_EMULATE;
 
        reserved = get_mmio_spte(vcpu, addr, &spte);
-       if (WARN_ON(reserved))
+       if (KVM_BUG_ON_DATA_CORRUPTION(reserved, vcpu->kvm))
                return -EINVAL;
 
        if (is_mmio_spte(spte)) {

> > >         }
> > >
> > >         return reserved;
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index f16c4689322b..5c4a06f66f46 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -863,6 +863,17 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
> > >         unlikely(__ret);                                        \
> > >  })
> > >
> > > +#define KVM_BUG_ON_DATA_CORRUPTION(cond, kvm)                  \
> > > +({                                                             \
> > > +       int __ret = (cond);                                     \
> > > +                                                               \
> > > +       if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION))          \
> > > +               BUG_ON(__ret);                                  \
> > > +       else if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))      \
> > > +               kvm_vm_bugged(kvm);                             \
> > > +       unlikely(__ret);                                        \
> > > +})
> > > +
> > >  static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
> > >  {
> > >  #ifdef CONFIG_PROVE_RCU
> > 
> > That sounds reasonable to me.
> 
> Actually, I disagree after thinking about it for a while. Since
> Google turns on CONFIG_BUG_ON_DATA_CORRUPTION on default, this
> KVM_BUG_ON_DATA_CORRUPTION() is literally BUG_ON(). Then there is no
> point. The purpose of the series is to save the host from crash.

Sure, but Google is not the only consumer of KVM.  E.g. I'm guessing many distros
use CONFIG_BUG_ON_DATA_CORRUPTION=n.  Any user that doesn't have the infrastructure
to capture crash dumps is likely better served overall by the WARN-and-continue
behavior.

> If we follow the upper changes on get_mmio_spte() as well, we are
> introducing more BUG()!, ie., more chances to crash the host machine. So
> I cannot stay with this idea.

For get_mmio_spte() specifically, I am quite confident that in production kernels,
the benefits of a BUG() far outweigh the risk of unnecessarily panicking the host.
There have been recent-ish bugs that escaped into kernel releases, but the first
one (wrong root level) escaped only because it affected an esoteric, rarely used
configuration (shadow paging with a 32-bit host kernel), and the second one was
a purely theoretical bug fix that was also limited to 32-bit kernels.

  39b4d43e6003 ("KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE")
  2aa078932ff6 ("KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()")

> In fact, there could many reasons why RMAPs and SPTEs are messed. In
> many times, as illustrated by my example, they are not data corruptions.
> They are just errors due to code refactoring or some miscalculations under
> certain tricky corner situations, e.g., offset by 1.  So, treating them
> blindly as data corruptions is an overkill.

For SPTEs in prod, not really.  Something has gone really wrong if KVM messes up a
SPTE to the point where _hardware_ unexpectedly observes a reserved bit in a
production build.  We've had bugs where we've botched the software sanity checks,
e.g. see commit

  6c6ab524cfae ("KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT")

but except for rarely used setups (see above), unexpected reserved SPTE faults
in production pretty much won't happen unless there's memory corruption or a CPU
error.

For RMAPs, I agree it's less clear cut, but at the same time the status quo is to
always BUG(), so from an upstream perspective allowing the admin to avoid the
BUG() is an unqualified improvement.

> This is a comparison to the list traversal bug, which clearly shows data corruptions.

That depends on what is considered "data corruption".  In this case,
CONFIG_BUG_ON_DATA_CORRUPTION is about the kernel memory structures being corrupted,
it's not referring to generic data corruption user data.

  Select this option if the kernel should BUG when it encounters
  data corruption in kernel memory structures when they get checked
  for validity.

And IMO that definition fits KVM's behavior perfectly.  get_mmio_spte() detects
corrupted SPTEs, pte_list_remove() detects corrupted RMAP lists.

If "data corruption" is interpeted to be corruption of user data than the list
behavior is wildly overstepping.  E.g. if a subsystem has a bug where an object
is added to two different lists, list_add() will yell about the issue but because
all writes to the list_head are aborted with CONFIG_DEBUG_LIST=y, it's entirely
possible for the bug to be benign or limited to the subsystem.

A somewhat contrived example would be if a (complex) allocator and its caller both
add the object to the same list; the second list_add() is problematic and would
trigger BUG() with CONFIG_BUG_ON_DATA_CORRUPTION=y, but with CONFIG_DEBUG_LIST=y
the bug would be completely benign.

> So, alternatively, I think it should be reasonable to shutdown the KVM
> instance if we see things messed up in MMIO SPTEs as well, but please
> don not the host for that.

Again, this doesn't unconditionally bring down the host.  Google is _choosing_
to BUG() on _potential_ data corruption.  I'm open to not tieing KVM's behavior to
CONFIG_BUG_ON_DATA_CORRUPTION if there's a good argument for doing so, but if we
(Google) plan on turning on the BUG() behavior for KVM then I don't see the point.

In other words, we should discuss internally whether or not we want/need to push
for a separate control, but from an upstream perspective I think the proposed
behavior is entirely reasonable.
