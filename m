Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0693158950D
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 01:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbiHCXzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 19:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbiHCXzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 19:55:20 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD2E2BEC;
        Wed,  3 Aug 2022 16:55:18 -0700 (PDT)
Date:   Wed, 3 Aug 2022 23:55:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659570916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=98PRq4SkrK7pgM8AJJbKi555UVx2fTN1zuKd8ZkZr8o=;
        b=LuDxXNgkFLwuZAsuXzjaW1flY6luVi9hajglXg70O+VR9zJq+6sYQMAEJQ7aJaEYScQRyx
        nouLawOHZmc2YDjSHGXLVzAY2kGGgGEyaUtLhbBFcXNJ+U7pkFrTTitCdxe48YSusDR2Me
        6C0E/XZI41dSpOdkI+IygA91slLhCIQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] selftests: KVM/x86: Fix vcpu_{save,load}_state() by
 adding APIC state into kvm_x86_state
Message-ID: <YusK4OxpNQ6cQavN@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-3-mizhang@google.com>
 <YurCI5PQu44UJ0a7@google.com>
 <YurKx+gFAWPvj35L@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YurKx+gFAWPvj35L@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 07:21:43PM +0000, Sean Christopherson wrote:
> KVM: selftests: for the shortlog.
> 
> On Wed, Aug 03, 2022, Oliver Upton wrote:
> > Hi Mingwei,
> > 
> > On Tue, Aug 02, 2022 at 11:07:15PM +0000, Mingwei Zhang wrote:
> > > Fix vcpu_{save,load}_state() by adding APIC state into kvm_x86_state and
> > > properly save/restore it in vcpu_{save,load}_state(). When vcpu resets,
> > > APIC state become software disabled in kernel and thus the corresponding
> > > vCPU is not able to receive posted interrupts [1].  So, add APIC
> > > save/restore in userspace in selftest library code.
> > 
> > Of course, there are no hard rules around it but IMO a changelog is
> > easier to grok if it first describes the what/why of the problem, then
> > afterwards how it is fixed by the commit.
> 
> I strongly disagree.  :-)  To some extent, it's a personal preference, e.g. I
> find it easier to understand the details (why something is a problem) if I have
> the extra context of how a problem is fixed (or: what code was broken).
> 

Sorry, what I wrote definitely was asking for strict ordering. Thank you
for rightly calling that out.

My actual issue if I had been bothered to articulate it well was that $WHAT
was effectively restated in different terms which can be confusing.
Where possible, atomically addressing what, why and how can lead to a
crisper changelog.

[...]

>   KVM: selftests: Save/restore vAPIC state in "migration" tests
>   
>   Save/restore vAPIC state as part of vCPU save/load so that it's preserved
>   across VM "migration".  This will allow testing that posted interrupts
>   are properly handled across VM migration.
> 
> With that, the first sentence covers both the "what's changing" and provides a
> high-level description of the "bug" it's fixing.  And the second sentence covers
> (a) "why do we want this patch", (b) "why wasn't this a problem before", and (c)
> "what's the urgency of this patch".

LGTM.

--
Thanks,
Oliver
