Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6506D6CA5
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 20:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbjDDSvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 14:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbjDDSvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 14:51:07 -0400
Received: from out-12.mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EF749E1
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 11:51:05 -0700 (PDT)
Date:   Tue, 4 Apr 2023 18:50:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680634264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zjskJ/+K4RYnRGaiw8Qyw6yBk5pv87S2MCPATkCEId8=;
        b=RU0QINMpSErQ04BD1mGX/o9p8yR/QvrVf5TAqJ+B0pLUCxlNxu1B7R7LkVkoP7JGYL7LUz
        jEfaLi/d/MEkINFRhOVJnkIsMAYSrvpbp62YYwIAXojJutdmnhHH5FrTjB/EC2SDr4zovx
        evYXQ5F9H+NtK4KK+RTsFefQZk43INQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/7] KVM: arm64: Add FEAT_TLBIRANGE support
Message-ID: <ZCxxklWzAz9K+aOP@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-3-rananta@google.com>
 <ZCTjirkCgBkT65eP@linux.dev>
 <CAJHc60y1BLQC4c0qXCuqF7JfewBC_fG2xuH0Wj0AHJh9x3CK5g@mail.gmail.com>
 <ZCxvXq0dftq/Szra@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZCxvXq0dftq/Szra@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 06:41:34PM +0000, Oliver Upton wrote:
> On Mon, Apr 03, 2023 at 10:26:01AM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Mar 29, 2023 at 6:19 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > +     start = round_down(start, stride);                                      \
> > > > +     end = round_up(end, stride);                                            \
> > > > +     pages = (end - start) >> PAGE_SHIFT;                                    \
> > > > +                                                                             \
> > > > +     if ((!system_supports_tlb_range() &&                                    \
> > > > +          (end - start) >= (MAX_TLBI_OPS * stride)) ||                       \
> > >
> > > Doesn't checking for TLBIRANGE above eliminate the need to test against
> > > MAX_TLBI_OPS?
> > >
> > Derived from __flush_tlb_range(), I think the condition is used to
> > just flush everything if the range is too large to iterate and flush
> > when the system doesn't support TLBIRANGE. Probably to prevent
> > soft-lockups?
> 
> Right, but you test above for system_supports_tlb_range(), meaning that
> you'd unconditionally call __kvm_tlb_flush_vmid() below.

Gah, I misread the parenthesis and managed to miss your statement in the
changelog about !TLBIRANGE systems. Apologies.

-- 
Thanks,
Oliver
