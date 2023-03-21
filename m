Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A4F6C3BB8
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 21:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCUUYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 16:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCUUYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 16:24:12 -0400
Received: from out-60.mta0.migadu.com (out-60.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F040910DB
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:23:14 -0700 (PDT)
Date:   Tue, 21 Mar 2023 20:23:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679430189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vf5A8n+E6tSZs3e6XPiSZIkMxTL6i506Q5l+b6Bie58=;
        b=YuTLDdeADY3W2diU+/tOk5cJM7Io0LBPpWbMJqQ5JQQutxfl5ltsWDrIVE1RopI3JT01xm
        9Jxi7eyTXufb+4LCyEvCEuEoE07TVDGw+C7mJnP8rDwaIz23OPX2P0tj9sZFXenz8WIs/+
        Ny4c7xIvxmZEN5JhhUwZ1C4RVGKgO/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
Message-ID: <ZBoSKm3CUoBC0l5X@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev>
 <ZBTK0vzAoWqY1hDh@google.com>
 <ZBjckKb6eWx2vSin@linux.dev>
 <ZBnEO5l7hZMlhi/1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBnEO5l7hZMlhi/1@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 07:50:35AM -0700, Sean Christopherson wrote:
> On Mon, Mar 20, 2023, Oliver Upton wrote:
> > On Fri, Mar 17, 2023 at 01:17:22PM -0700, Sean Christopherson wrote:
> > > On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > > I'm not a fan of this architecture-specific dependency. Userspace is already
> > > > explicitly opting in to this behavior by way of the memslot flag. These sort
> > > > of exits are entirely orthogonal to the -EFAULT conversion earlier in the
> > > > series.
> > > 
> > > Ya, yet another reason not to speculate on why KVM wasn't able to resolve a fault.
> > 
> > Regardless of what we name this memslot flag, we're already getting explicit
> > opt-in from userspace for new behavior. There seems to be zero value in
> > supporting memslot_flag && !MEMORY_FAULT_EXIT (i.e. returning EFAULT),
> > so why even bother?
> 
> Because there are use cases for MEMORY_FAULT_EXIT beyond fast-only gup.

To be abundantly clear -- I have no issue with (nor care about) the other
MEMORY_FAULT_EXIT changes. If we go the route of explicit user opt-in then
that deserves its own distinct bit of UAPI. None of my objection pertains
to the conversion of existing -EFAULT exits.

> We could have the memslot feature depend on the MEMORY_FAULT_EXIT capability,
> but I don't see how that adds value for either KVM or userspace.

That is exactly what I want to avoid! My issue was the language here:

  +(*) NOTE: On x86, KVM_CAP_X86_MEMORY_FAULT_EXIT must be enabled for the
  +KVM_MEMFAULT_REASON_ABSENT_MAPPING_reason: otherwise userspace will only receive
  +a -EFAULT from KVM_RUN without any useful information.

Which sounds to me as though there are *two* UAPI bits for the whole fast-gup
failed interaction (flip a bit in the CAP and set a bit on the memslot, but
only for x86).

What I'm asking for is this:

 1) A capability advertising MEMORY_FAULT_EXIT to userspace. Either usurp
   EFAULT or require userspace to enable this capability to convert
   _existing_ EFAULT exits to the new way of the world.

 2) A capability and a single memslot flag to enable the fast-gup-only
   behavior (naming TBD). This does not depend on (1) in any way, i.e.
   only setting (2) should still result in MEMORY_FAULT_EXITs when fast
   gup fails. IOW, enabling (2) should always yield precise fault
   information to userspace.

-- 
Thanks,
Oliver
