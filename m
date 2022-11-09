Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDDD6236CC
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKIWtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKIWtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:49:07 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048F124C
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:49:05 -0800 (PST)
Date:   Wed, 9 Nov 2022 22:48:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668034140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uy8PKmBJllUyFJnAMPXkpcKsBKhmjino2ZkcFTbS9rs=;
        b=sUu1+UXh7oEBAIs4hIdEgPV8KWK0j3gsGb9InYHeHjT0tU5n3mMiYYMOeVdXGc2M49fMAB
        9x+1Uhk+3EgMVSPzaDyJ6Tijp2FBsZDTpw8lRKQ6d0b+d0zuVcY480/UygcXT7rWNI3/Gn
        4T/XSrE44KY34fkUSjdG7+XP0ezELL0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ben Gardon <bgardon@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 01/14] KVM: arm64: Combine visitor arguments into a
 context structure
Message-ID: <Y2wuUNNAlsIlxnwM@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-2-oliver.upton@linux.dev>
 <CANgfPd9ooA5c+ZQMx4-yy+n92TsxoAXZyHRoTpatoSOb+jXi-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9ooA5c+ZQMx4-yy+n92TsxoAXZyHRoTpatoSOb+jXi-w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 02:23:08PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Passing new arguments by value to the visitor callbacks is extremely
> > inflexible for stuffing new parameters used by only some of the
> > visitors. Use a context structure instead and pass the pointer through
> > to the visitor callback.
> >
> > While at it, redefine the 'flags' parameter to the visitor to contain
> > the bit indicating the phase of the walk. Pass the entire set of flags
> > through the context structure such that the walker can communicate
> > additional state to the visitor callback.
> >
> > No functional change intended.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> This looks good to me. It's all fairly mechanical and I don't see any
> problems. I was a little confused by the walk context flags passed via
> visit, because they seem somewhat redundant if the leaf-ness can be
> determined by looking at the PTE, but perhaps that's not always
> possible.

Some explanation is probably owed here. I think you caught the detail
later on in the series, but I'm overloading flags to describe both the
requested visits and some properties about the walk (i.e. a SHARED
walk).

I tried to leave it sufficiently generic as there will be other
configuration bits we will want to stuff into a walker later on (such as
TLBI and CMO elision).

> Reviewed-by: Ben Gardon <bgardon@google.com>

Thanks!

--
Best,
Oliver
