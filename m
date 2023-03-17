Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD136BF009
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCQRoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 13:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCQRoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 13:44:16 -0400
Received: from out-4.mta1.migadu.com (out-4.mta1.migadu.com [IPv6:2001:41d0:203:375::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F41199C2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 10:43:49 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:43:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679075026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Robaj2ZTM1WFpzapt8qkLkXiY1X3pTTI92l7DQRpslM=;
        b=xB1I2gscQTzTGyAmpLnWY8nlVtzWTJ/Gh9sjFk3vxrMxjuhBQRQSOUpjkiLQNyvBjxHOs/
        1JQJCvCgOnWRyRmRWdgD907ba1vyMNbVQcLdyoMTy4qcUs3C50rTfCAVlMrgObOMC/Se52
        u4rkc0Yr/hJ+mcROjy4+NQe7dXDXZXg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     seanjc@google.com, jthoughton@google.com, kvm@vger.kernel.org,
        maz@kernel.org
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
Message-ID: <ZBSmz0JAgTrsF608@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anish,

Generally the 'RFC PATCH' prefix is used for patches that are for feedback
only (i.e. not to be considered for inclusion).

On Wed, Mar 15, 2023 at 02:17:24AM +0000, Anish Moorthy wrote:
> Hi Sean, here's what I'm planing to send up as v2 of the scalable
> userfaultfd series.

I don't see a ton of value in sending a targeted posting of a series to the
list. IOW, just CC all of the appropriate reviewers+maintainers. I promise,
we won't bite.

> Don't worry, I'm not asking you to review this all :) I just have a few
> remaining questions regarding KVM_CAP_MEMORY_FAULT_EXIT which seem important
> enough to mention before I ask for more attention from others, and they'll be
> clearer with the patches in hand. Anything else I'm happy to find out about when
> I send the actual v2.
> 
> I want your opinion on
> 
> 1. The general API I've set up for KVM_CAP_MEMORY_FAULT_EXIT
>    (described in the api.rst file)
> 2. Whether the UNKNOWN exit reason cases (everywhere but
>    handle_error_pfn atm) would need to be given "real" reasons
>    before this could be merged.
> 3. If you think I've missed sites that currently -EFAULT to userspace
> 
> About (3): after we agreed to only tackle cases where -EFAULT currently makes it
> to userspace, I went though our list and tried to trace which EFAULTS actually
> bubble up to KVM_RUN. That set ended being suspiciously small, so I wanted to
> sanity-check my findings with you. Lmk if you see obvious errors in my list
> below.
> 
> --- EFAULTs under KVM_RUN ---
> 
> Confident that needs conversion (already converted)
> ---------------------------------------------------
> * direct_map
> * handle_error_pfn
> * setup_vmgexit_scratch
> * kvm_handle_page_fault
> * FNAME(fetch)
> 
> EFAULT does not propagate to userspace (do not convert)
> -------------------------------------------------------
> * record_steal_time (arch/x86/kvm/x86.c:3463)
> * hva_to_pfn_retry
> * kvm_vcpu_map
> * FNAME(update_accessed_dirty_bits)
> * __kvm_gfn_to_hva_cache_init
>   Might actually make it to userspace, but only through
>   kvm_read|write_guest_offset_cached- would be covered by those conversions
> * kvm_gfn_to_hva_cache_init
> * __kvm_read_guest_page
> * hva_to_pfn_remapped
>   handle_error_pfn will handle this for the scalable uffd case. Don't think
>   other callers -EFAULT to userspace.
> 
> Still unsure if needs conversion
> --------------------------------
> * __kvm_read_guest_atomic
>   The EFAULT might be propagated though FNAME(sync_page)?
> * kvm_write_guest_offset_cached (virt/kvm/kvm_main.c:3226)
> * __kvm_write_guest_page
>   Called from kvm_write_guest_offset_cached: if that needs change, this does too

The low-level accessors are common across architectures and can be called from
other contexts besides a vCPU. Is it possible for the caller to catch -EFAULT
and convert that into an exit?

> * kvm_write_guest_page
>   Two interesting paths:
>       - kvm_pv_clock_pairing returns a custom KVM_EFAULT error here
>         (arch/x86/kvm/x86.c:9578)

This is a hypercall handler, so the return code is ABI with the guest. So it
shouldn't be converted to an exit to userspace.

-- 
Thanks,
Oliver
