Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2445610676
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiJ0XjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbiJ0XjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:39:19 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0F34F1A9
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:39:17 -0700 (PDT)
Date:   Thu, 27 Oct 2022 23:39:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666913955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4OySq2lPcnWk1ygNMJS74tXjIlAzlxm25q99ZcmBZWU=;
        b=W3q6w/rApxamTznGicrMweNO9AfF9b5YCfMEQ8dW9ZKNbgTLdS6e5WLmzyJ0xNMkFGK6dq
        zXuAmu3YIUEGo/sQjDh04PD+4MuFq1FHB+ywX+0cWOGRBI15m3mbOfYy2Tc2QrFxSIaUDE
        iFeo2388RPrwJarIpvJq5DFkVZ+4Zyg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/15] KVM: arm64: Parallel stage-2 fault handling
Message-ID: <Y1sWnyHvMWP/DhHm@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 10:17:37PM +0000, Oliver Upton wrote:
> Presently KVM only takes a read lock for stage 2 faults if it believes
> the fault can be fixed by relaxing permissions on a PTE (write unprotect
> for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> predictably can pile up all the vCPUs in a sufficiently large VM.
> 
> Like the TDP MMU for x86, this series loosens the locking around
> manipulations of the stage 2 page tables to allow parallel faults. RCU
> and atomics are exploited to safely build/destroy the stage 2 page
> tables in light of multiple software observers.
> 
> Patches 1-4 clean up the context associated with a page table walk / PTE
> visit. This is helpful for:
>  - Extending the context passed through for a visit
>  - Building page table walkers that operate outside of a kvm_pgtable
>    context (e.g. RCU callback)

As is always the case, I failed to update the changelogs when twiddling
things around a bit more.

Specifically, 8/15 and 14/15 don't directly match the diffs anymore. I
wont respin (yet) to avoid bombarding mailboxes.

--
Thanks,
Oliver
