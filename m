Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEFC286969
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgJGUxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgJGUxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 16:53:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB39C061755;
        Wed,  7 Oct 2020 13:53:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602103997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vtcDCCITF2nkZPQBpg36c9Atf4ukHGwLOFXCwRKCklg=;
        b=AVOpOeOwTC7C9yDmwrVPcB9C1aPMvhP/5PdP/qru4UkSe/Tg4pCe1Ov9uEYmh05Pn0Q0O1
        njUkv+k7Hbf3l2DqWYdLQP4gb2+2Hpo0MffsYbxrvGzTW1kryRFPNq7DuLRZs4RnfEUJAL
        Ce5FKKgPccq9WUrVPutCxus8e4M2PRseZsfw/COTCVvsKrngI7uYglaFkoxmV8aaFczyhx
        4fZzfBjBSiF/RTkCxSVFeXV9U9TAXodE1e+4d/p7A8eD8EmICmC+2FDDJBTaJwix0w0xga
        u8+31OmCuh8cj5+eKe28oQ6NiW5YG4AvVQ35FRelSHvkwColN93pjwFEjzbJRA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602103997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vtcDCCITF2nkZPQBpg36c9Atf4ukHGwLOFXCwRKCklg=;
        b=uUXdWeB5iUUDQ1glmjUlfVx7FfzR42lEIjygybtN2704wXPeHGr8n5iedwh+Gwwo5mRYe/
        FbUVKijLxJK86VBA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
In-Reply-To: <7FA24FCF-E197-4502-BC89-0902E4053554@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-7-dwmw2@infradead.org> <87lfgj59mp.fsf@nanos.tec.linutronix.de> <75d79c50d586c18f0b1509423ed673670fc76431.camel@infradead.org> <87tuv640nw.fsf@nanos.tec.linutronix.de> <336029ca32524147a61b6fa1eb734debc9d51a00.camel@infradead.org> <87a6wy3u6n.fsf@nanos.tec.linutronix.de> <7FA24FCF-E197-4502-BC89-0902E4053554@infradead.org>
Date:   Wed, 07 Oct 2020 22:53:17 +0200
Message-ID: <87tuv53ghu.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 17:11, David Woodhouse wrote:
> On 7 October 2020 16:57:36 BST, Thomas Gleixner <tglx@linutronix.de> wrote:
>>There is not lot's of nastiness.
>
> OK, but I think we do have to cope with the fact that the limit is
> dynamic, and a CPU might be added which widens the mask. I think
> that's fundamental and not x86-specific.

Yes, but it needs some thoughts vs. serialization against CPU hotplug.

The stability of that cpumask is architecture specific if the calling
context cannot serialize against CPU hotplug. The hot-unplug case is
less interesting because the mask does not shrink, it only get's wider.

That's why I want a callback instead of a pointer assignment and that
callback cannot return a pointer to something which can be modified
concurrently, it needs to update a caller provided mask so that the
result is at least consistent in itself.

It just occured to me that there is something which needs some more
thought vs. CPU hotunplug as well:

  Right now we just check whether there are enough vectors available on
  the remaining online CPUs so that the interrupts which have an
  effective affinity directed to the outgoing CPU can be migrated away
  (modulo the managed ones).

  That check obviously needs to take the target CPU restrictions into
  account to prevent that devices end up with no target at the end.

I bet there are some other interesting bits and pieces which need
some care...

Thanks,

        tglx


