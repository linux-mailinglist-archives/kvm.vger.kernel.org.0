Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93F85BDECD
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiITHvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiITHue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:50:34 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364ED1D0F7
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 00:50:25 -0700 (PDT)
Date:   Tue, 20 Sep 2022 09:50:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663660223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eyekJFWfNIBvBg+mrV6tG+YS/YFf06nK3qzW8KeFdXI=;
        b=lOr0A2/i2dYj8lPydFJEwzKN4fPQpYAywx/Az35MPE7I3Tl0LwAdIdn/clZvjgqtFTr2qZ
        QI4Gbb7R+wMladb51rJDBp5Sf4hQoafJnaMl+K7j8USDO16cfyF1yJaO55yuy30xOSELAL
        PeQofwnivPkm+hg1c/DMX26apTWcdyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <20220920075021.rbzo2wkypbj2gjie@kamzik>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920042551.3154283-8-ricarkol@google.com>
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

On Tue, Sep 20, 2022 at 04:25:45AM +0000, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out. Start by changing ____vm_create() to not create memslot #0; a future
> commit will add test that specifies all memslots used by the VM.  Then, add the
> vm->memslots[] array to specify the right memslot for different memory
> allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.  This
> will be used as a way to specify the page-tables memslots (to be backed by huge
> pages for example).
> 
> There is no functional change intended. The current commit lays out memory
> exactly as before. The next commit will change the allocators to get the region
> they should be using, e.g.,: like the page table allocators using the pt
> memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++------
>  2 files changed, 33 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
