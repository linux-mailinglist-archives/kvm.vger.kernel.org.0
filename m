Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD5E4FB71C
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344267AbiDKJOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344275AbiDKJOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056933FBD2;
        Mon, 11 Apr 2022 02:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97DAFB8112D;
        Mon, 11 Apr 2022 09:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB315C385A4;
        Mon, 11 Apr 2022 09:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649668339;
        bh=gHtJO44c4D/gohjY60yF1myOEq2+2TFmuEq1mIQdKs8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jlO1rJC0L2Sco80vrOPrUtn/qGvFa4maFijqjeQQySAugORVnJGPbD4SUipWEuDzz
         FzYJAniBKI8qbDZVrcxfNYhmvz7iywYzVSsLm29HmogQZvz/OAbRKL1NohJC6JueLd
         MJDB9mDGYrZL9sdarC0O1F6aYDF8XzD5Fu1PJLAy1BwgPMCqyM9X4T/6CaPAmR9eo2
         cDAA0EGwdicvF0/dJaUxLEdPYy4Wv1PQBL2x9YWypf5G3BbgNPP9fYXDQ2IKoArwbb
         ANkBarNOm00mMet0/3WzKUgsAv27RY1WvqipI1XEmXBOHBIe0XUO+UVlGij21AvaEG
         3BRhTAzh/ZB1g==
Date:   Mon, 11 Apr 2022 10:12:13 +0100
From:   Will Deacon <will@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>, maz@kernel.org,
        alexandru.elisei@arm.com
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <20220411091213.GA2120@willie-the-truck>
References: <20220407210233.782250-1-pgonda@google.com>
 <Yk+kNqJjzoJ9TWVH@google.com>
 <CAMkAt6oc=SOYryXu+_w+WZR+VkMZfLR3_nd=hDvMU_cmOjJ0Xg@mail.gmail.com>
 <YlBqYcXFiwur3zmo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlBqYcXFiwur3zmo@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Cheers for the heads-up.

[+Marc and Alex as this looks similar to [1]]

On Fri, Apr 08, 2022 at 05:01:21PM +0000, Sean Christopherson wrote:
> On Fri, Apr 08, 2022, Peter Gonda wrote:
> > On Thu, Apr 7, 2022 at 8:55 PM Sean Christopherson <seanjc@google.com> wrote:
> > > On Thu, Apr 07, 2022, Peter Gonda wrote:
> > > > If an SEV-ES guest requests termination, exit to userspace with
> > > > KVM_EXIT_SYSTEM_EVENT and a dedicated SEV_TERM type instead of -EINVAL
> > > > so that userspace can take appropriate action.
> > > >
> > > > See AMD's GHCB spec section '4.1.13 Termination Request' for more details.
> > >
> > > Maybe it'll be obvious by the lack of compilation errors, but the changelog should
> > > call out the flags => ndata+data shenanigans, otherwise this looks like ABI breakage.
> > 
> > Hmm I am not sure we can do this change anymore given that we have two
> > call sites using 'flags'
> > 
> > arch/arm64/kvm/psci.c:184
> > arch/riscv/kvm/vcpu_sbi.c:97
> > 
> > I am not at all familiar with ARM and RISC-V but some quick reading
> > tells me these archs also require 64-bit alignment on their 64-bit
> > accesses. If thats correct, should I fix this call sites up by
> > proceeding with this ndata + data[] change and move whatever they are
> > assigning to flags into data[0] like I am doing here? It looks like
> > both of these changes are not in a kernel release so IIUC we can still
> > fix the ABI here?
> 
> Yeah, both came in for v5.18.  Given that there will be multiple paths that need
> to set data, it's worth adding a common helper to the dirty work.
> 
> Anup and Will,
> 
> system_event.flags is broken (at least on x86) due to the prior 'type' field not
> being propery padded, e.g. userspace will read/write garbage if the userspace
> and kernel compilers pad structs differently.
> 
> 		struct {
> 			__u32 type;
> 			__u64 flags;
> 		} system_event;

On arm64, I think the compiler is required to put the padding between type
and flags so that both the struct and 'flags' are 64-bit aligned [2]. Does
x86 not offer any guarantees on the overall structure alignment?

> Our plan to unhose this is to change the struct as follows and use bit 31 in the
> 'type' to indicate that ndata+data are valid.
> 
> 		struct {
>                         __u32 type;
> 			__u32 ndata;
> 			__u64 data[16];
>                 } system_event;
> 
> Any objection to updating your architectures to use a helper to set the bit and
> populate ndata+data accordingly?  It'll require a userspace update, but v5.18
> hasn't officially released yet so it's not kinda sort not ABI breakage.

It's a bit annoying, as we're using the current structure in Android 13 :/
Obviously, if there's no choice then upstream shouldn't worry, but it means
we'll have to carry a delta in crosvm. Specifically, the new 'ndata' field
is going to be unusable for us because it coincides with the padding.

Will

[1] https://lore.kernel.org/r/20220407162327.396183-6-alexandru.elisei@arm.com
[2] https://github.com/ARM-software/abi-aa/blob/60a8eb8c55e999d74dac5e368fc9d7e36e38dda4/aapcs64/aapcs64.rst#composite-types
