Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF60679FD0
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 18:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjAXRLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 12:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjAXRLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 12:11:30 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13B13AAB
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 09:11:26 -0800 (PST)
Date:   Tue, 24 Jan 2023 17:11:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674580285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TyJQjATPh0tKJCEQcnqCvNrxjQJk0MT7om7mPRXWyqo=;
        b=K6k1kVS1Du6EUufjWRtLZ6pyq5z7L5toFFB0wjYBKLsHWX/X2G1T8qoTnjx+3zY86JYpXJ
        t+B/69mWrcXtYfGJDFh1VEo8gjU/xD6IbastSk0602xBrvKfJMuTNMZIhDKU2GktgEjuMl
        AZE0kp/oaUgMm9lUZ3cmHlXn25YIwuw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y9ARN5hWlAYVFBoK@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
 <Y9ALgtnd+h9ivn90@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ALgtnd+h9ivn90@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 08:46:58AM -0800, Ricardo Koller wrote:
> On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:

[...]

> > Would it be accurate to say:
> > /* No huge pages can exist at the root level, so there's nothing to
> > split here. */
> > 
> > I think of "last level" as the lowest/leaf/4k level but
> > KVM_PGTABLE_MAX_LEVELS - 1 is 3? 
> 
> Right, this is the 4k level.
> 
> > Does ARM do the level numbering in
> > reverse order to x86?
> 
> Yes, it does. Interesting, x86 does
> 
> 	iter->level--;
> 
> while arm does:
> 
> 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> 
> I don't think this numbering scheme is encoded anywhere in the PTEs, so
> either architecture could use the other.

The numbering we use in the page table walkers is deliberate, as it
directly matches the Arm ARM. While we can certainly use either scheme
I'd prefer we keep aligned with the architecture.

--
Thanks,
Oliver
