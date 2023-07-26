Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2960B763D9B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjGZRYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjGZRYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:24:13 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F97319BE
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:24:12 -0700 (PDT)
Date:   Wed, 26 Jul 2023 10:24:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690392250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DigPotkusHKdDC5GOWfYwMjN1u+1mEU4Mjxveaa/3Ac=;
        b=NUhEjdglmOcIFXTyEMvE7e4uyhdKEhThMDece/htE+ar+2gMIivKBd6kBTpGsKNI5ZO4XP
        kH3MdJRqC0AFdZHa3IaZB536jcnV5Lt3vjKkXBuczWp1sD/v4dQ+jntudkdZo74Yb9rxsO
        GoeJaFD9McHX1wBq49zcaFJw1IlUEkc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jing Zhang <jingzhangos@google.com>, Marc Zyngier <maz@kernel.org>,
        KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
Message-ID: <ZMFWsvWzfkkz2VNB@thinky-boi>
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com>
 <86r0p1txun.wl-maz@kernel.org>
 <CAAdAUtjNW6Q+phGbc6jXWTERRhYo7E3H4Ws0iDSngc17Sac0uA@mail.gmail.com>
 <ZLr0LcQENZmIGMAt@linux.dev>
 <87edkxg0jr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edkxg0jr.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cornelia,

On Mon, Jul 24, 2023 at 10:45:44AM +0200, Cornelia Huck wrote:
> On Fri, Jul 21 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> > What I had in mind was something similar to the KVM_GET_ONE_REG ioctl,
> > but instead of returning the register value it'd return the mask of the
> > register. This would keep the kernel implementation dead simple (I'm
> > lazy) and more easily allow for future expansion in case we want to
> > start describing more registers this way. Userspace would iterate the ID
> > register space and ask the kernel for the mask of registers it wants to
> > change.
> 
> Hm... for userspace it might be easier to get one big list and then
> parse it afterwards? Similar to what GET_REG_LIST does today.

Possibly, but I felt like it was a bit different from GET_REG_LIST since
this would actually be a list of key-value pairs (reg_id, mask) instead
of a pure enumeration of IDs. My worry is that if/when we wind up describing
more registers in this list-based ioctl then userspace is going to wind
up traversing that structure a lot to find the register masks it actually
cares about.

> Are you thinking more of a KVM_GET_REG_INFO or so ioctl, that could
> support different kinds of extra info (and might also make sense for
> other architectures?) If we end up with something more versatile, it
> might make sense going that route.

TBH, I hadn't considered the extensibililty of a per-register ioctl, but
that does seem like a good point.

--
Thanks,
Oliver
