Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14F06761EE
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 01:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjAUAMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 19:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUAMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 19:12:17 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49218B77B
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:12:13 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id dw9so7045535pjb.5
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 16:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4SK5QkZtNn1114IW/p2QqQjxFu3MpNyGxrITiSXzRQE=;
        b=tg5hMelZw1XcCxmeBgZd0wSJ8z98D8IlS1msOxT8Rq6EDxxz4yssidqhASAoJdXRbU
         r89swOLn+DnyhpkJJY7L/hEDPZ2upsGHOGbMHww8PxY4/DschRirjTz96PkkGnwrbrl/
         b8YWtV/trPuLg3QiOu4c+dNChVCYtUxNf2GfGMe0XA3TIhcE3i0on3UWQZSdgw8uF4Mb
         lsL9kjwvGhDMbcpZg04rPvgXEhIeg1IZ/8yMKhBQOtDopsR1tylXXpngjh4Yn4fz4t22
         QpRkcFj5qrPzN470zgvQh+dHzGxwgf1fwTioLKue9uViLKmu61OeG+55oUfx0djOIvBz
         DX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SK5QkZtNn1114IW/p2QqQjxFu3MpNyGxrITiSXzRQE=;
        b=oF1rzaQo1s65CIZ6dsm6fy6OAYiCL8R/Rz/8/H6fynQsd4HG8ioF41WYMEOGt62AWL
         ayD2pSr5oRUnMdK6NN586NJrpbPlHF17Xh27LFCP/VXtNWj/5kMQjj36A1KRZRje/j/u
         ARqQk1cmOuAklk4zBqDO/cJV3TP/wwGnpLV2nEhfVPj/+q6w2bCniFjiSohoffGJBHvX
         4Lozo/j/XzDZLF2IlAGQeZo8Ebx/BIpSFMmqUbP6FPVzHy9WA+PAFDHlm6xcAUgFaie/
         NPNXgbDFv0DZOwEezn+N3wbHi28tsGsDu+EFV4VH1ReneuyyoR/O4kbWwkWgx02cEcF3
         xRVA==
X-Gm-Message-State: AFqh2kqi+frX72avQoclZ6pGPTL55C5wp+7T3eCBBDa+bg6dm5n2QIxQ
        TS65MjSTyAGokxoI5g5SJi0Nug==
X-Google-Smtp-Source: AMrXdXtw4On5+UzzEXtWtwMI26nwjAxvW3nuAa5ccm3X6juOVSET/2ddkUsJPNvQim+rpv3XnJ2czw==
X-Received: by 2002:a05:6a20:93a7:b0:b8:ca86:f3ab with SMTP id x39-20020a056a2093a700b000b8ca86f3abmr19101pzh.2.1674259933059;
        Fri, 20 Jan 2023 16:12:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 63-20020a621942000000b0056d98e359a5sm26512823pfz.165.2023.01.20.16.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 16:12:12 -0800 (PST)
Date:   Sat, 21 Jan 2023 00:12:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8st2PjGDQ+Q0LlW@google.com>
References: <20230117214414.00003229@gmail.com>
 <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
 <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
 <Y8ljwsrrBBdh1aYw@google.com>
 <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
 <Y8m34OEVBfL7Q4Ns@google.com>
 <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
 <Y8ndcGHUHQjHfbF9@google.com>
 <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
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

On Fri, Jan 20, 2023, David Matlack wrote:
> On Thu, Jan 19, 2023 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jan 19, 2023, Huang, Kai wrote:
> > > On Thu, 2023-01-19 at 21:36 +0000, Sean Christopherson wrote:
> > > > The least invasive idea I have is expand the TDP MMU's concept of "frozen" SPTEs
> > > > and freeze (a.k.a. lock) the SPTE (KVM's mirror) until the corresponding S-EPT
> > > > update completes.a

Doh, the proposed patches already do a freeze+unfreeze.  Sorry, I obviously didn't
read the most recent changelog and haven't looked at the code in a few versions.

> > > This will introduce another "having-to-wait while SPTE is frozen" problem I
> > > think, which IIUC means (one way is) you have to do some loop and retry, perhaps
> > > similar to yield_safe.
> >
> > Yes, but because the TDP MMU already freezes SPTEs (just for a shorter duration),
> > I'm 99% sure all of the affected flows already know how to yield/bail when necessary.
> >
> > The problem with the zero-step mitigation is that it could (theoretically) cause
> > a "busy" error on literally any accesses, which makes it infeasible for KVM to have
> > sane behavior.  E.g. freezing SPTEs to avoid the ordering issues isn't necessary
> > when holding mmu_lock for write, whereas the zero-step madness brings everything
> > into play.
> 
> (I'm still ramping up on TDX so apologies in advance if the following
> is totally off base.)
> 
> The complexity, and to a lesser extent the memory overhead, of
> mirroring Secure EPT tables with the TDP MMU makes me wonder if it is
> really worth it. Especially since the initial TDX support has so many
> constraints that would seem to allow a simpler implementation: all
> private memory is pinned, no live migration support, no test/clear
> young notifiers, etc.
> 
> For the initial version of KVM TDX support, what if we implemented the
> Secure EPT management entirely off to the side? i.e. Not on top of the
> TDP MMU. For example, write TDX-specific routines for:
> 
>  - Fully populating the Secure EPT tree some time during VM creation.

Fully populating S-EPT is likely not a viable option for performance reasons.  The
number of SEAMCALLS needed for a large VM would be quite enormous, and to avoid
faults entirely the backing memory would also need to be pre-allocated.

>  - Tearing down the Secure EPT tree during VM destruction.
>  - Support for unmapping/mapping specific regions of the Secure EPT
> tree for private<->shared conversions.
> 
> With that in place, KVM never would need to handle a fault on a Secure
> EPT mapping. Any fault (e.g. due to an in-progress private<->shared
> conversion) can just return back to the guest to retry the memory
> access until the operation is complete.

I don't think this will work.  Or at least, it's not that simple.  TDX and SNP
both require the host to support implicit conversions from shared => private,
i.e. KVM needs to be able to handle faults on private memory at any time.  KVM
could rely on the attributes xarray to know if KVM should resume the guest or
exit to userspace, but at some point KVM needs to know whether or an entry has
been installed.  We could work around that by adding a hooking to "set attributes"
to populate S-EPT entries, but I'm not sure that would yield a simpler implementation
without sacrificing performance.

Thinking more about this, I do believe there is a simpler approach than freezing
S-EPT entries.  If we tweak the TDP MMU rules for TDX to require mmu_lock be held
for write when overwiting a present SPTE (with a live VM), then the problematic
cases go away.  As you point out, all of the restrictions on TDX private memory
means we're most of the way there.

Explicit unmap flows already take mmu_lock for write, zapping/splitting for dirty
logging isn't a thing (yet), and the S-EPT root is fixed, i.e. kvm_tdp_mmu_put_root()
should never free S-EPT tables until the VM is dead.

In other words, the only problematic flow is kvm_tdp_mmu_map().  Specifically,
KVM will overwrite a present SPTE only to demote/promote an existing entry, i.e.
to split a hugepage or collapse into a hugepage.  And I believe it's not too
difficult to ensure KVM never does in-place promotion/demotion:

  - Private memory doesn't rely on host userspace page tables, i.e. KVM won't
    try to promote to a hugepage because a hugepage was created in the host.

  - Private memory doesn't (yet) support page migration, so again KVM won't try
    to promote because a hugepage is suddenly possible.

  - Shadow paging isn't compatible, i.e. disallow_lpage won't change dynamically
    except for when there are mixed attributes, and toggling private/shared in
    the attributes requires zapping with mmu_lock held for write.

  - The idiotic non-coherent DMA + guest MTRR interaction can be disallowed (which
    I assume is already the case for TDX).

  - Disallow toggling the NX hugepage mitigation when TDX is allowed.

Races to install leaf SPTEs will yield a "loser" either on the spurious check in
tdp_mmu_map_handle_target_level():

	if (new_spte == iter->old_spte)
		ret = RET_PF_SPURIOUS;

or on the CMPXCHG in tdp_mmu_set_spte_atomic().

So I _think_ the race I described can't actually happen in practice, and if it
does happen, then we have a bug somewhere else.  Though that raises the question
of why the proposed patches do the freeze+unfreeze.  If it's just the VM destroy
case, then that should be easy enough to special case.


Intel folks,

Do you happen to know exactly what scenario prompted adding the freeze+unfreeze
code?  Is there something I'm forgetting/missing, or is it possible we can go
with a simpler implementation?
