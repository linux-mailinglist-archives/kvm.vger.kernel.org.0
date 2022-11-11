Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DA8626242
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 20:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiKKTmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 14:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiKKTmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 14:42:54 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2267F555
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 11:42:53 -0800 (PST)
Date:   Fri, 11 Nov 2022 19:42:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668195771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=489V1xO2Jk4quKvIvlMb+9p2vWfkmCHH5cQqMf67ius=;
        b=ctsL1hsC7qEw5KiW28UAtXJRlnFS4iPL22CHt0GFvCmPRUlo8Rsweb1Y6WREvqho0r9sXc
        N657AWKzK8lHkXEclZcbTk1apEVn4VSgW4n9PysclSm15DxsXi37Yd1oYbNU8SA3MqXrE4
        7J/tg6Q6syps7GjxLcmOHG3ltCVunSU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 00/26] KVM: arm64: Introduce pKVM hyp VM and vCPU
 state at EL2
Message-ID: <Y26ltgCIObKpRTWx@google.com>
References: <20221110190259.26861-1-will@kernel.org>
 <86edu9ph3d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86edu9ph3d.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 04:54:14PM +0000, Marc Zyngier wrote:
> On Thu, 10 Nov 2022 19:02:33 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > Hi all,
> > 
> > This is version six of the pKVM EL2 state series, extending the pKVM
> > hypervisor code so that it can dynamically instantiate and manage VM
> > data structures without the host being able to access them directly.
> > These structures consist of a hyp VM, a set of hyp vCPUs and the stage-2
> > page-table for the MMU. The pages used to hold the hypervisor structures
> > are returned to the host when the VM is destroyed.
> > 
> > Previous versions are archived at:
> > 
> >   Mega-patch: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
> >   v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/
> >   v3: https://lore.kernel.org/kvmarm/20220914083500.5118-1-will@kernel.org/
> >   v4: https://lore.kernel.org/kvm/20221017115209.2099-1-will@kernel.org/
> >   v5: https://lore.kernel.org/r/20221020133827.5541-1-will@kernel.org
> > 
> > The changes since v5 include:
> > 
> >   * Fix teardown ordering so that the host 'kvm' structure remains pins
> >     while the memcache is being filled.
> > 
> >   * Fixed a kerneldoc typo.
> > 
> >   * Included a patch from Oliver to rework the 'pkvm_mem_transition'
> >     structure and it's handling of the completer address.
> > 
> >   * Tweaked some commit messages and added new R-b tags.
> > 
> > As before, the final patch is RFC since it illustrates a very naive use
> > of the new hypervisor structures and subsequent changes will improve on
> > this once we have the guest private memory story sorted out.
> > 
> > Oliver: I'm pretty sure we're going to need to revert your completer
> > address cleanup as soon as we have guest-host sharing. We want to keep
> > the 'pkvm_mem_transition' structure 'const', but we will only know the
> > host address (PA) after walking the guest stage-2 and so we're going to
> > want to track that separately. Anyway, I've included it here at the end
> > so Marc can decide what he wants to do!
> 
> Thanks, I guess... :-/
> 
> If this patch is going to be reverted, I'd rather not take it (without
> guest/host sharing, we don't have much of a hypervisor).

+1, I'm more than happy being told my patch doesn't work :)

Having said that, if there are parts of the design that I've whined
about that are intentional then please educate me. Some things haven't
been quite as obvious, but I know you folks have been working on this
feature for a while.

I probably need to give the full patch-bomb another read to get all the
context too.

--
Thanks,
Oliver
