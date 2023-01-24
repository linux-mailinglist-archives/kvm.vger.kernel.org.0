Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389B167A36B
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 20:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjAXTzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 14:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjAXTzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 14:55:05 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A211460B3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 11:55:04 -0800 (PST)
Date:   Tue, 24 Jan 2023 11:54:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674590102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D+yEQH6sj071aO2Zx3DWMsqz1a4FetQGlSsUZ/oJsDU=;
        b=vslrF3k70pdkRmokxxNE2d+rmDYOq2G9bLozIOD6RckcwcWBFrOCBus6dU58pipVIs2wf0
        CmPAn0UHnOElD63xG2CvFMx3wk/vxumodhkmqs1JXmg/J0IAtmOTn6ZqUwPSCxH07HZ99U
        zDV/rYPAqsGVyjlibpTpucuQHWdq21E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 4/4] KVM: selftests: aarch64: Test read-only PT memory
 regions
Message-ID: <Y9A3kVCnVgl+x5UJ@thinky-boi>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-5-ricarkol@google.com>
 <Y88aFBBcsx7v/2qh@google.com>
 <Y9AGmn0CM/lNX6w/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9AGmn0CM/lNX6w/@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 08:26:02AM -0800, Ricardo Koller wrote:
> On Mon, Jan 23, 2023 at 11:36:52PM +0000, Oliver Upton wrote:
> > On Tue, Jan 10, 2023 at 02:24:32AM +0000, Ricardo Koller wrote:
> > > Extend the read-only memslot tests in page_fault_test to test read-only PT
> > > (Page table) memslots. Note that this was not allowed before commit "KVM:
> > > arm64: Fix handling of S1PTW S2 fault on RO memslots" as all S1PTW faults
> > > were treated as writes which resulted in an (unrecoverable) exception
> > > inside the guest.
> > 
> > Do we need an additional test that the guest gets nuked if TCR_EL1.HA =
> > 0b1 and AF is clear in one of the stage-1 PTEs?
> > 
> 
> That should be easy to add. The only issue is whether that's also a case
> of checking for very specific KVM behavior that could change in the
> future.

From the perspective of the guest I believe this to match the
architecture. An external abort is appropriate if the hardware update to
a descriptor failed.

I believe that the current implementation of this in KVM is slightly
wrong, though. AFAICT, we encode the abort with an FSC of 0x10, which
indicates an SEA occurred outside of a table walk. The other nuance of
reporting SEAs due to a TTW is that the FSC encodes the level at which
the external abort occurred. Nonetheless, I think we can hide behind
R_BGPQR of DDI0487I.a and always encode a level of 0:

"""
  If a synchronous External abort is generated due to a TLB or
  intermediate TLB caching structure, including parity or ECC errors,
  then all of the following are permitted:
   - If the PE cannot precisely determine the translation stage at which
     the error occurred, then it is reported and prioritized as a stage 1
     fault.
   - If the PE cannot precisely determine the lookup level at which the
     error occurred, then the lookup level is reported and prioritized
     as one of the following:
     - The lowest-numbered lookup level that could have caused the error.
     - If the PE cannot determine any information about the lookup level,
     then level 0.
"""

Thoughts?

--
Thanks,
Oliver
