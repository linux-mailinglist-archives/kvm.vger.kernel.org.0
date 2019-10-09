Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610E1D0961
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfJIIQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:16:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIIQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qXbwHkBIFZYF51iyX+HVbhmA7krzX3BgMfbry1nriAw=; b=SMrVR8peDVRyLLTU1bVJQy9k8
        a1el6p2XG6UcVTPgcvGUV2LUhhympq1Cb81XxlU8eZ93sfCvz4ScUaPZksod+0T64ikHsSwSwR5Fa
        LsFxm4Zdthq9NcYBuNhgLM5zxzdByTdA55F26Qhg+73j6E9U42j7YU10Fx2xTGMt4k4kMidx97IXt
        NgAmxUfpZ8pKKBshqb7qnc35AVMxcRbkCM+0Bt6dfYBhDZSUCKRbB58a4V3Wtm+JgP7fx/Dupp5yi
        MdkZRba29pd7caT0z4FxX7doQT3IAcm1ONgbbDLqZAW0FlMep4glLH72g37DsK2rCosoNwosQNDO7
        1NrnYqKzg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI78e-0006I4-On; Wed, 09 Oct 2019 08:16:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9B65F3008C1;
        Wed,  9 Oct 2019 10:15:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 16F6920299B7A; Wed,  9 Oct 2019 10:16:02 +0200 (CEST)
Date:   Wed, 9 Oct 2019 10:16:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
Message-ID: <20191009081602.GI2328@hirez.programming.kicks-ass.net>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
 <20191008121140.GN2294@hirez.programming.kicks-ass.net>
 <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
 <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 09:15:03AM +0200, Paolo Bonzini wrote:
> For stuff like hardware registers, bitfields are probably a bad idea
> anyway, so let's only consider the case of space optimization.

Except for hardware registers? I actually like bitfields to describe
hardware registers.

> bool:2 would definitely cause an eyebrow raise, but I don't see why
> bool:1 bitfields are a problem.  An integer type large enough to store
> the values 0 and 1 can be of any size bigger than one bit.

Consider:

	bool	foo:1;
	bool	bar:1;

Will bar use the second bit of _Bool? Does it have one? (yes it does,
but it's still weird).

But worse, as used in the parent thread:

	u8	count:7;
	bool	flag:1;

Who says the @flag thing will even be the msb of the initial u8 and not
a whole new variable due to change in base type?

> bool bitfields preserve the magic behavior where something like this:
> 
>   foo->x = y;
> 
> (x is a bool bitfield) would be compiled as
> 
>   foo->x = (y != 0);

This is confusion; if y is a single bit bitfield, then there is
absolutely _NO_ difference between these two expressions.

The _only_ thing about _Bool is that it magically casts values to 0,1.
Single bit bitfield variables have no choice but to already be in that
range.

So expressions where it matters are:

	x = (7&2)	// x == 2
vs
	x = !!(7&2)	// x == 1

But it is impossible for int:1 and _Bool to behave differently.

> However, in this patch bitfields are unnecessary and they result in
> worse code from the compiler.

Fully agreed :-)
