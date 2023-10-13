Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D927C8749
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 16:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjJMOBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 10:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJMOB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 10:01:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6310F95;
        Fri, 13 Oct 2023 07:01:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8872E11FB;
        Fri, 13 Oct 2023 07:02:07 -0700 (PDT)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.34.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2A553F762;
        Fri, 13 Oct 2023 07:01:24 -0700 (PDT)
Date:   Fri, 13 Oct 2023 15:01:22 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Tianyi Liu <i.pear@outlook.com>
Cc:     maz@kernel.org, acme@kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@linux.intel.com, irogers@google.com,
        jolsa@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mingo@redhat.com,
        namhyung@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        seanjc@google.com, x86@kernel.org
Subject: Re: [PATCH v2 0/5] perf: KVM: Enable callchains for guests
Message-ID: <ZSlNsn-f1j2bB8pW@FVFF77S0Q05N.cambridge.arm.com>
References: <8734yhm7km.wl-maz@kernel.org>
 <SY4P282MB108434CA47F2C55E490A1C6B9DD3A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY4P282MB108434CA47F2C55E490A1C6B9DD3A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 02:35:42PM +0800, Tianyi Liu wrote:
> Hi Marc,
> 
> On Sun, 11 Oct 2023 16:45:17 +0000, Marc Zyngier wrote:
> > > The event processing flow is as follows (shown as backtrace):
> > >   #0 kvm_arch_vcpu_get_frame_pointer / kvm_arch_vcpu_read_virt (per arch)
> > >   #1 kvm_guest_get_frame_pointer / kvm_guest_read_virt
> > >      <callback function pointers in `struct perf_guest_info_callbacks`>
> > >   #2 perf_guest_get_frame_pointer / perf_guest_read_virt
> > >   #3 perf_callchain_guest
> > >   #4 get_perf_callchain
> > >   #5 perf_callchain
> > >
> > > Between #0 and #1 is the interface between KVM and the arch-specific
> > > impl, while between #1 and #2 is the interface between Perf and KVM.
> > > The 1st patch implements #0. The 2nd patch extends interfaces between #1
> > > and #2, while the 3rd patch implements #1. The 4th patch implements #3
> > > and modifies #4 #5. The last patch is for userspace utils.
> > >
> > > Since arm64 hasn't provided some foundational infrastructure (interface
> > > for reading from a virtual address of guest), the arm64 implementation
> > > is stubbed for now because it's a bit complex, and will be implemented
> > > later.
> > 
> > I hope you realise that such an "interface" would be, by definition,
> > fragile and very likely to break in a subtle way. The only existing
> > case where we walk the guest's page tables is for NV, and even that is
> > extremely fragile.
> 
> For walking the guest's page tables, yes, there're only very few
> use cases. Most of them are used in nested virtualization and XEN.

The key point isn't the lack of use cases; the key point is that *this is
fragile*.

Consider that walking guest page tables is only safe because:

(a) The walks happen in the guest-physical / intermiediate-physical address
    space of the guest, and so are not themselves subject to translation via
    the guest's page tables.

(b) Special traps were added to the architecture (e.g. for TLB invalidation)
    which allow the host to avoid race conditions when the guest modifies page
    tables.

For unwind we'd have to walk structures in the guest's virtual address space,
which can change under our feet at any time the guest is running, and handling
that requires much more care.

I think this needs a stronger justification, and an explanation of how you
handle such races.

Mark.

> > Given that, I really wonder why this needs to happen in the kernel.
> > Userspace has all the required information to interrupt a vcpu and
> > walk its current context, without any additional kernel support. What
> > are the bits here that cannot be implemented anywhere else?
> 
> Thanks for pointing this out, I agree with your opinion.
> Whether it's walking guest's contexts or performing an unwind,
> user space can indeed accomplish these tasks.
> The only reasons I see for implementing them in the kernel are performance
> and the access to a broader range of PMU events.
> 
> Consider if I were to implement these functionalities in userspace:
> I could have `perf kvm` periodically access the guest through the KVM API
> to retrieve the necessary information. However, interrupting a VCPU
> through the KVM API from user space might introduce higher latency
> (not tested specifically), and the overhead of syscalls could also
> limit the sampling frequency.
> 
> Additionally, it seems that user space can only interrupt the VCPU
> at a certain frequency, without harnessing the richness of the PMU's
> performance events. And if we incorporate the logic into the kernel,
> `perf kvm` can bind to various PMU events and sample with a faster
> performance in PMU interrupts.
> 
> So, it appears to be a tradeoff -- whether it's necessary to introduce
> more complexity in the kernel to gain access to a broader range and more
> precise performance data with less overhead. In my current use case,
> I just require simple periodic sampling, which is sufficient for me,
> so I'm open to both approaches.
> 
> > > Tianyi Liu (5):
> > >   KVM: Add arch specific interfaces for sampling guest callchains
> > >   perf kvm: Introduce guest interfaces for sampling callchains
> > >   KVM: implement new perf interfaces
> > >   perf kvm: Support sampling guest callchains
> > >   perf tools: Support PERF_CONTEXT_GUEST_* flags
> > >
> > >  arch/arm64/kvm/arm.c                | 17 +++++++++
> > 
> > Given that there is more to KVM than just arm64 and x86, I suggest
> > that you move the lack of support for this feature into the main KVM
> > code.
> 
> Currently, sampling for KVM guests is only available for the guest's
> instruction pointer, and even the support is limited, it is available
> on only two architectures (x86 and arm64). This functionality relies on
> a kernel configuration option called `CONFIG_GUEST_PERF_EVENTS`,
> which will only be enabled on x86 and arm64.
> Within the main KVM code, these interfaces are enclosed within
> `#ifdef CONFIG_GUEST_PERF_EVENTS`. Do you think these are enough?
> 
> Best regards,
> Tianyi Liu
