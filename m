Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F5862A02F
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiKORYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiKORX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:23:59 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418E1AE57;
        Tue, 15 Nov 2022 09:23:57 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:23:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668533035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=epDwsDiYoNZ6uhKBqwMbJzXJpjRcm2DVB2PP1BGcjP8=;
        b=LMKySPNF2K08tEU8/pacucf93qxXUOua+1KWhnakFetm4VAYbi1ofKjDaiEZ/IDYEaYhj6
        E7ssklZu9Y1+ZIf9KUl4UgiMCAQQp1LHUO0YfCVLJh7TB2gsxpFsg3cKGGkiXQTlKgdwTV
        BR8S7QBQCXemVNgYdPzwfxfjQlgLYOE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] KVM: arm64: Use a separate function for hyp stage-1
 walks
Message-ID: <Y3PLJxnvmZp35MpF@google.com>
References: <20221114201127.1814794-1-oliver.upton@linux.dev>
 <20221114201127.1814794-2-oliver.upton@linux.dev>
 <20221115132532.GA524@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115132532.GA524@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Will,

On Tue, Nov 15, 2022 at 01:25:34PM +0000, Will Deacon wrote:

[...]

> On Mon, Nov 14, 2022 at 08:11:27PM +0000, Oliver Upton wrote:
> > +int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +			 struct kvm_pgtable_walker *walker);
> 
> Hmm, this feels like slightly the wrong abstraction to me -- there's nothing
> hyp-specific about the problem being solved, it's just that the only user
> is for hyp walks.
> 
> Could we instead rework 'struct kvm_pgtable' slightly so that the existing
> 'flags' field is no-longer stage-2 specific and includes a KVM_PGTABLE_LOCKED
> flag which could be set by kvm_pgtable_hyp_init()?
> 
> That way the top-level API remains unchanged and the existing callers will
> continue to work.

Thanks for the suggestion! Yeah, this should be described by the flags
instead.

We already have KVM_PGTABLE_WALK_SHARED, I could actually condition the
RCU lock/unlock on that one. That would make it an explicit opt-in
instead of requiring an opt out with callers passing KVM_PGTABLE_LOCKED.

Thoughts?

--
Thanks,
Oliver
