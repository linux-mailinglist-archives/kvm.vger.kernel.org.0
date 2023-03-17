Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2801D6BF07B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCQSNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjCQSNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:13:32 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B59028D29
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:13:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t12-20020a65608c000000b005091ec4f2d4so1483734pgu.20
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679076809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXfUdJb/ax2oa9E1fPvto3PphxqiYj5GHq2CmZrZwNA=;
        b=DuKzEE78zr3hqn7qM5xsIQ1CSmhRSKAhGl5MQsBArPSMEk1ORvHNofrfiJowgT+1Ur
         zdEaEQjtqqMlXVfvtoJU5d9b+4vZp72mvuphW1qFiGlRUo1O03YdkvipBR/F4Zc/DKma
         MtQeUbhrbJqt/uxHFyTuHHvfq6fYxA4JFXdPJwxwNxSgbFCiCJiKPQXV7WXRPO8j8RwU
         eAKDHEy+btrfIw+cPoSNgJYMruUWmTYrTRdNL7RHX1T0zu+RD6aW3rQF7R4FQqjgbB7a
         U9EoAXcDpTU4dT1olYuL7HNyLafpzRIGALbJwKeQNfB5Qq2QbjuJLJnXgBCr9L7bd/C+
         ezFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679076809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXfUdJb/ax2oa9E1fPvto3PphxqiYj5GHq2CmZrZwNA=;
        b=qoTTK6iNvzVdbETQa8USkDxGiWQZjLa/3iM/OqWG0A9rJLETEfs2kEzSPaSqR2Dgm8
         BMgWIQEK603R8uQckNyh8xkp1pBcXA2wp94WdSgGL9AYKywN6DKwSBB/nHNYmsJvsJfQ
         JlFV498oOuknhXV69iNKx3WadB9pW1G1Idoiv0FdopZT/9XqfmD2X4b0myR/eBW2EPSY
         4jZAk2w4I4Z9QFHknB9zqvOrHMxQOmBuN/aQCmUgxGe8ekwuPIyswgLKQ9DznkszkWHi
         lKhAss/QV/L3bnxQWWh92MznkN6gRpuVJgfJdUBdCDZex9IXx2QoF/VYpmkWC+xppzuJ
         8lkA==
X-Gm-Message-State: AO0yUKXZbq2l7ceeIgEVVaX3fOxz3UtGaSBrQxBVYPxsIIgt3G3KNoo7
        C1EyO4ISf7Pqt4crfmoyjgf6UdVigKY=
X-Google-Smtp-Source: AK7set+JqIA4vLRl/82EyEkaaDupcoT72QY7WRwaDn/cRHwyoymT35oqdbcZtH/vLOC2wMEVOzo6VKLISJs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:108c:b0:23f:6efa:bd55 with SMTP id
 gj12-20020a17090b108c00b0023f6efabd55mr352990pjb.8.1679076809647; Fri, 17 Mar
 2023 11:13:29 -0700 (PDT)
Date:   Fri, 17 Mar 2023 11:13:28 -0700
In-Reply-To: <ZBSmz0JAgTrsF608@linux.dev>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <ZBSmz0JAgTrsF608@linux.dev>
Message-ID: <ZBStyKk6H73/0z2r@google.com>
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org, maz@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Oliver Upton wrote:
> On Wed, Mar 15, 2023 at 02:17:24AM +0000, Anish Moorthy wrote:
> > Hi Sean, here's what I'm planing to send up as v2 of the scalable
> > userfaultfd series.
> 
> I don't see a ton of value in sending a targeted posting of a series to the
> list. IOW, just CC all of the appropriate reviewers+maintainers. I promise,
> we won't bite.

+1.  And though I discourage off-list review, if something is really truly not
ready for public review, e.g. will do more harm than good by causing confusing,
then just send the patches off-list.  Half measures like this will just make folks
grumpy.

> > Don't worry, I'm not asking you to review this all :) I just have a few
> > remaining questions regarding KVM_CAP_MEMORY_FAULT_EXIT which seem important
> > enough to mention before I ask for more attention from others, and they'll be
> > clearer with the patches in hand. Anything else I'm happy to find out about when
> > I send the actual v2.
> > 
> > I want your opinion on
> > 
> > 1. The general API I've set up for KVM_CAP_MEMORY_FAULT_EXIT
> >    (described in the api.rst file)
> > 2. Whether the UNKNOWN exit reason cases (everywhere but
> >    handle_error_pfn atm) would need to be given "real" reasons
> >    before this could be merged.
> > 3. If you think I've missed sites that currently -EFAULT to userspace
> > 
> > About (3): after we agreed to only tackle cases where -EFAULT currently makes it
> > to userspace, I went though our list and tried to trace which EFAULTS actually
> > bubble up to KVM_RUN. That set ended being suspiciously small, so I wanted to
> > sanity-check my findings with you. Lmk if you see obvious errors in my list
> > below.
> > 
> > --- EFAULTs under KVM_RUN ---
> > 
> > Confident that needs conversion (already converted)
> > ---------------------------------------------------
> > * direct_map
> > * handle_error_pfn
> > * setup_vmgexit_scratch
> > * kvm_handle_page_fault
> > * FNAME(fetch)
> > 
> > EFAULT does not propagate to userspace (do not convert)
> > -------------------------------------------------------
> > * record_steal_time (arch/x86/kvm/x86.c:3463)
> > * hva_to_pfn_retry
> > * kvm_vcpu_map
> > * FNAME(update_accessed_dirty_bits)
> > * __kvm_gfn_to_hva_cache_init
> >   Might actually make it to userspace, but only through
> >   kvm_read|write_guest_offset_cached- would be covered by those conversions
> > * kvm_gfn_to_hva_cache_init
> > * __kvm_read_guest_page
> > * hva_to_pfn_remapped
> >   handle_error_pfn will handle this for the scalable uffd case. Don't think
> >   other callers -EFAULT to userspace.
> >
> > Still unsure if needs conversion
> > --------------------------------
> > * __kvm_read_guest_atomic
> >   The EFAULT might be propagated though FNAME(sync_page)?
> > * kvm_write_guest_offset_cached (virt/kvm/kvm_main.c:3226)
> > * __kvm_write_guest_page
> >   Called from kvm_write_guest_offset_cached: if that needs change, this does too
> 
> The low-level accessors are common across architectures and can be called from
> other contexts besides a vCPU. Is it possible for the caller to catch -EFAULT
> and convert that into an exit?

Ya, as things stand today, the conversions _must_ be performed at the caller, as
there are (sadly) far too many flows where KVM squashes the error.  E.g. almost
all of x86's paravirt code just suppresses user memory faults :-(

Anish, when we discussed this off-list, what I meant by limiting the intial support
to existing -EFAULT cases was limiting support to existing cases where KVM directly
returns -EFAULT to userspace, not to all existing cases where -EFAULT is ever
returned _within KVM_ while handling KVM_RUN.  My apologies if I didn't make that clear.
