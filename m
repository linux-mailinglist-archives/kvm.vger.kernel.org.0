Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA8610E57
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiJ1KXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJ1KXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:23:43 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BD61CB51F
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:23:42 -0700 (PDT)
Date:   Fri, 28 Oct 2022 10:23:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666952620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L4OIthJifQ5swLs+ejUqtpsuyuxlkNQcRrSkG5lvVuU=;
        b=vxttRypFANLybcEOz+fXk4/ydf1CvcSqFUutaV/7xpJMPOb2OZ4PiEVY4zUSMWcHw26Zc5
        q/g+CCWNjfxFxRy+CYfZl/2OqGAJKnj/dmLyGDt2KiupdcXSq8PPC5suvcsqloVUhO2a+a
        wNmoPX+2gFxpD5fxvVbo4twcmTwuO0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Quentin Perret <qperret@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Redefine pKVM memory transitions in
 terms of source/target
Message-ID: <Y1utqG5f0lRrNwlI@google.com>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-3-oliver.upton@linux.dev>
 <Y1uncNq2oyc5wALG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1uncNq2oyc5wALG@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quentin,

On Fri, Oct 28, 2022 at 09:57:04AM +0000, Quentin Perret wrote:
> Hey Oliver,
> 
> On Friday 28 Oct 2022 at 08:34:48 (+0000), Oliver Upton wrote:
> > Perhaps it is just me, but the 'initiator' and 'completer' terms are
> > slightly confusing descriptors for the addresses involved in a memory
> > transition. Apply a rename to instead describe memory transitions in
> > terms of a source and target address.
> 
> Just to provide some rationale for the initiator/completer terminology,
> the very first implementation we did of this used 'sender/recipient (or
> something along those lines I think), and we ended up confusing
> ourselves massively. The main issue is that memory doesn't necessarily
> 'flow' in the same direction as the transition. It's all fine for a
> donation or a share, but reclaim and unshare become funny. 'The
> recipient of an unshare' can be easily misunderstood, I think.
> 
> So yeah, we ended up with initiator/completer, which may not be the
> prettiest terminology, but it was useful to disambiguate things at
> least.

I see, thanks for the background :) If I've managed to re-ambiguate the
language here then LMK. Frankly, I'm more strongly motivated on the
first patch anyway.

--
Thanks,
Oliver
