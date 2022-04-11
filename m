Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231164FBDFE
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346829AbiDKOCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 10:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346827AbiDKOCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 10:02:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9053F3056C;
        Mon, 11 Apr 2022 07:00:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58F061570;
        Mon, 11 Apr 2022 07:00:07 -0700 (PDT)
Received: from e121798.cambridge.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2D483F73B;
        Mon, 11 Apr 2022 07:00:05 -0700 (PDT)
Date:   Mon, 11 Apr 2022 15:00:04 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>, maz@kernel.org
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YlQ0LZyAgjGr7qX7@e121798.cambridge.arm.com>
References: <20220407210233.782250-1-pgonda@google.com>
 <Yk+kNqJjzoJ9TWVH@google.com>
 <CAMkAt6oc=SOYryXu+_w+WZR+VkMZfLR3_nd=hDvMU_cmOjJ0Xg@mail.gmail.com>
 <YlBqYcXFiwur3zmo@google.com>
 <20220411091213.GA2120@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411091213.GA2120@willie-the-truck>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Apr 11, 2022 at 10:12:13AM +0100, Will Deacon wrote:
> Hi Sean,
> 
> Cheers for the heads-up.
> 
> [+Marc and Alex as this looks similar to [1]]
> 
> On Fri, Apr 08, 2022 at 05:01:21PM +0000, Sean Christopherson wrote:
> > On Fri, Apr 08, 2022, Peter Gonda wrote:
> > > On Thu, Apr 7, 2022 at 8:55 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > On Thu, Apr 07, 2022, Peter Gonda wrote:
> > > > > If an SEV-ES guest requests termination, exit to userspace with
> > > > > KVM_EXIT_SYSTEM_EVENT and a dedicated SEV_TERM type instead of -EINVAL
> > > > > so that userspace can take appropriate action.
> > > > >
> > > > > See AMD's GHCB spec section '4.1.13 Termination Request' for more details.
> > > >
> > > > Maybe it'll be obvious by the lack of compilation errors, but the changelog should
> > > > call out the flags => ndata+data shenanigans, otherwise this looks like ABI breakage.
> > > 
> > > Hmm I am not sure we can do this change anymore given that we have two
> > > call sites using 'flags'
> > > 
> > > arch/arm64/kvm/psci.c:184
> > > arch/riscv/kvm/vcpu_sbi.c:97
> > > 
> > > I am not at all familiar with ARM and RISC-V but some quick reading
> > > tells me these archs also require 64-bit alignment on their 64-bit
> > > accesses. If thats correct, should I fix this call sites up by
> > > proceeding with this ndata + data[] change and move whatever they are
> > > assigning to flags into data[0] like I am doing here? It looks like
> > > both of these changes are not in a kernel release so IIUC we can still
> > > fix the ABI here?
> > 
> > Yeah, both came in for v5.18.  Given that there will be multiple paths that need
> > to set data, it's worth adding a common helper to the dirty work.
> > 
> > Anup and Will,
> > 
> > system_event.flags is broken (at least on x86) due to the prior 'type' field not
> > being propery padded, e.g. userspace will read/write garbage if the userspace
> > and kernel compilers pad structs differently.
> > 
> > 		struct {
> > 			__u32 type;
> > 			__u64 flags;
> > 		} system_event;
> 
> On arm64, I think the compiler is required to put the padding between type
> and flags so that both the struct and 'flags' are 64-bit aligned [2]. Does
> x86 not offer any guarantees on the overall structure alignment?

This is also my understanding. The "Procedure Call Standard for the Arm
64-bit Architecture" [1] has these rules for structs (called "aggregates"):

"An aggregate, where the members are laid out sequentially in memory
(possibly with inter-member padding)" => the field "type" is at offset 0 in
the struct.

"The member alignment of an element of a composite type is the alignment of
that member after the application of any language alignment modifiers to
that member" => "flags" is 8-byte aligned and "type" is 4-byte aligned.

"The alignment of an aggregate shall be the alignment of its most-aligned
member." => struct system_event is 8-byte aligned.

and finally:

"The size of an aggregate shall be the smallest multiple of its alignment
that is sufficient to hold all of its members."

I think this is the only possible layout that satisfies all the above
conditions:

offset 0-3: type (at an 8-byte aligned address in memory)
offset 4-7: padding
offset 8-15: flags

so under all compilers that correctly implement the architecture the struct
will have the same layout.

[1] https://github.com/ARM-software/abi-aa/releases/download/2021Q3/aapcs64.pdf

> 
> > Our plan to unhose this is to change the struct as follows and use bit 31 in the
> > 'type' to indicate that ndata+data are valid.
> > 
> > 		struct {
> >                         __u32 type;
> > 			__u32 ndata;
> > 			__u64 data[16];
> >                 } system_event;
> > 
> > Any objection to updating your architectures to use a helper to set the bit and
> > populate ndata+data accordingly?  It'll require a userspace update, but v5.18
> > hasn't officially released yet so it's not kinda sort not ABI breakage.
> 
> It's a bit annoying, as we're using the current structure in Android 13 :/
> Obviously, if there's no choice then upstream shouldn't worry, but it means
> we'll have to carry a delta in crosvm. Specifically, the new 'ndata' field
> is going to be unusable for us because it coincides with the padding.

Just a thought, but wouldn't such a drastical change be better implemented
as a new exit_reason and a new associated struct?

Thanks,
Alex

> 
> Will
> 
> [1] https://lore.kernel.org/r/20220407162327.396183-6-alexandru.elisei@arm.com
> [2] https://github.com/ARM-software/abi-aa/blob/60a8eb8c55e999d74dac5e368fc9d7e36e38dda4/aapcs64/aapcs64.rst#composite-types
