Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7395BC303
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 08:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiISGmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 02:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiISGmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 02:42:45 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9006112AB2
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 23:42:44 -0700 (PDT)
Date:   Mon, 19 Sep 2022 08:42:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663569762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lF1pvNO15/LIryP56kUXyj5P8zfxBSIOSQeY6bCx/8A=;
        b=cDbTE0mG4zNxp9IENdmw1ylz9PDZOfeBPeJ+RGUu08nYhCWUyzcTq66pJextb8LHbiU9Dr
        9+cUPZ5wWn8FEMa1N+SQvVdVHEViCxuac9++JwgG1t2+AEB2p+ql2G47W5JfgwnqPsQCiW
        ujdcUGKnfBytBkY9yOkjJHLEXOYIwlI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <20220919064241.bflow5zvcsz5xaf6@kamzik>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-8-ricarkol@google.com>
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

On Tue, Sep 06, 2022 at 06:09:24PM +0000, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out: define the memory regions to use for code, pt (page-tables), and
> data. Introduce a new structure, struct kvm_vm_mem_params, that defines: guest
> mode, a list of memory region descriptions, and some fields specifying what
> regions to use for code, pt, and data.
> 
> There is no functional change intended. The current commit adds a default
> struct kvm_vm_mem_params that lays out memory exactly as before. The next
> commit will change the allocators to get the region they should be using,
> e.g.,: like the page table allocators using the pt memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 51 +++++++++++++++-
>  .../selftests/kvm/lib/aarch64/processor.c     |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 58 ++++++++++++++++---
>  3 files changed, 102 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
