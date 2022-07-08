Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5956BF1C
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 20:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbiGHQZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiGHQZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 12:25:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564F8959C
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 09:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E606202B
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 16:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C8CC385A2;
        Fri,  8 Jul 2022 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657297447;
        bh=amLEKWplBld1RKnOzt1Q0jpmUba0aieihHZDRVH47bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lW9TUZxgCHA7J6OHhFURsnpCzRLqfvK1wTTK2GH3eZxPSOMjcgFeh/rm0ypbqLUws
         8mvM8DDiZcMPvk7HrTc85HsM03TnAigRyNAKoXoHW8xGGJ3pHWSQy7kyYgLukBchR2
         KGj5xJDIaVdp+wUccgbPxsWl3XTCe7rpVgzNZRpKdamQhtDHkhQn/0bAhpL3AjXlCE
         aidovcx30pTEjhOYoVpBT2McZCVIezV3OHyAiwgXgisghinPCRI6nJegDtUnzooUXD
         hKoLFVJAft5mknaZBHZLKBiUJxAmmcW/vu6VaMksi/oY2N7kiz6U3naeNhY/y3Hmg6
         htPzsF8uzO0Jw==
Date:   Fri, 8 Jul 2022 17:23:59 +0100
From:   Will Deacon <will@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Message-ID: <20220708162359.GA6286@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <YsXfyVp6sg5XRVAp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsXfyVp6sg5XRVAp@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for having a look.

On Wed, Jul 06, 2022 at 07:17:29PM +0000, Sean Christopherson wrote:
> On Thu, Jun 30, 2022, Will Deacon wrote:
> > This series has been extracted from the pKVM base support series (aka
> > "pKVM mega-patch") previously posted here:
> > 
> >   https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
> > 
> > Unlike that more comprehensive series, this one is fairly fundamental
> > and does not introduce any new ABI commitments, leaving questions
> > involving the management of guest private memory and the creation of
> > protected VMs for future work. Instead, this series extends the pKVM EL2
> > code so that it can dynamically instantiate and manage VM shadow
> > structures without the host being able to access them directly. These
> > shadow structures consist of a shadow VM, a set of shadow vCPUs and the
> > stage-2 page-table and the pages used to hold them are returned to the
> > host when the VM is destroyed.
> > 
> > The last patch is marked as RFC because, although it plumbs in the
> > shadow state, it is woefully inefficient and copies to/from the host
> > state on every vCPU run. Without the last patch, the new structures are
> > unused but we move considerably closer to isolating guests from the
> > host.
> 
> ...
> 
> >  arch/arm64/include/asm/kvm_asm.h              |   6 +-
> >  arch/arm64/include/asm/kvm_host.h             |  65 +++
> >  arch/arm64/include/asm/kvm_hyp.h              |   3 +
> >  arch/arm64/include/asm/kvm_pgtable.h          |   8 +
> >  arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
> >  arch/arm64/kernel/image-vars.h                |  15 -
> >  arch/arm64/kvm/arm.c                          |  40 +-
> >  arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
> >  arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  19 +-
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h      |  26 +-
> >  arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  70 +++
> >  arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
> >  arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 105 +++-
> >  arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 456 +++++++++++++++++-
> >  arch/arm64/kvm/hyp/nvhe/mm.c                  | 136 +++++-
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  42 +-
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 438 +++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++--
> >  arch/arm64/kvm/hyp/pgtable.c                  |   9 +
> >  arch/arm64/kvm/mmu.c                          |  26 +
> >  arch/arm64/kvm/pkvm.c                         | 121 ++++-
> >  25 files changed, 1625 insertions(+), 144 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> 
> The lack of documentation and the rather terse changelogs make this really hard
> to review for folks that aren't intimately familiar with pKVM.  I have a decent
> idea of the end goal of "shadowing", but that's mostly because of my involvement in
> similar x86 projects.  Nothing in the changelogs ever explains _why_ pKVM uses
> shadows.

That's understandable, but thanks for persevering; this series is pretty
down in the murky depths of the arm64 architecture and EL2 code so it
doesn't really map to the KVM code most folks are familiar with. It's fair
to say we're assuming a lot of niche prior knowledge (which is quite common
for arch code in my experience), but I wanted to inherit the broader cc list
so you were aware of this break-away series. Sadly, I don't think beefing up
the commit messages would get us to a point where somebody unfamiliar with
the EL2 code already could give a constructive review, but we can try to
expand them a bit if you genuinely think it would help.

On the more positive side, we'll be speaking at KVM forum about what we've
done here, so that will be a great place to discuss it further and then we
can also link back to the recordings in later postings of the mega-series.

> I put "shadowing" in quotes because if the unstrusted host is aware that the VM
> and vCPU it is manipulating aren't the "real" VMs/vCPUs, and there is an explicit API
> between the untrusted host and pKVM for creating/destroying VMs/vCPUs, then I would
> argue that it's not truly shadowing, especially if pKVM uses data/values verbatim
> and only verifies correctness/safety.  It's definitely a nit, but for future readers
> I think overloading "shadowing" could be confusing.

Ah, this is really interesting and nicely puts the ball back in my court as
I'm not well versed with x86's use of "shadowing". We should probably use
another name (ideas?), but our "shadow" is very much explicit -- rather than
the host using its 'struct kvm's and 'struct kvm_vcpu's directly, it instead
passes those data structures to the hypervisor which allocates its own
structures (in some cases reusing the host definitions directly, e.g.
'struct kvm_vcpu') and returning a handle to the host as a reference. The
host can then issue hypercalls with this handle to load/put vCPUs of that
VM, run them once they are loaded and synchronise aspects of the vCPU state
between the host and the hypervisor copies for things like emulation traps
or interrupt injection. The main thing is that the pages containing the
hypervisor structures are not accessible by the host until the corresponding
VM is destroyed.

The advantage of doing it this way is that we don't need to change very
much of the host KVM code at all, and we can even reuse some of it directly
in the hypervisor (e.g. inline functions and macros).

Perhaps we should s/shadow/hyp/ to make this a little clearer?

> And beyond the basics, IMO pKVM needs a more formal definition of exactly what
> guest state is protected/hidden from the untrusted host.  Peeking at the mega series,
> there are a huge pile of patches that result in "gradual reduction of EL2 trust in
> host data", but I couldn't any documentation that defines what that end result is.

That's fair; I'll work to extend the documentation in the next iteration of
the mega series to cover this in more detail. Roughly speaking, the end
result is that the vCPU register and memory state is inaccessible to the
host except in cases where the guest has done something to expose it such as
MMIO or a memory sharing hypercall. Given the complexity of the register
state (GPRs, floating point, SIMD, debug, etc) the mega-series elavates
portions of the state from the host to the hypervisor as separate patches
to structure things a bit better (that's where the gradual reduction comes
in).

Does that help at all?

Cheers,

Will
