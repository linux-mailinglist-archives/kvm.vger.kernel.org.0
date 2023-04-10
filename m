Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF5F6DCDFB
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 01:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjDJXZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 19:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJXZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 19:25:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F119B1BC7
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:25:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54ee12aa4b5so67533427b3.4
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681169142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XDQcwM0Ljq47Kk+Cx8Zo9PwBtwHuWqUYBxNgZio/RfY=;
        b=bkyyOP2BDUJ+Th0lHoGO7vJXGV+88YNyum6G/YIxmMfueZJtcBv9odQCjB+mTj5U6u
         iuqMnEWS/RBWfoENX3U6XkNTInEgC5Zeujj2Y7olklOMNDLxmIvsOrXs3kYbI3SEVHk2
         bQ9nZzL2dL+oYUBfs3cqncHkNY+uly0GeA8kIaxIisGXszxC5bzNUapXOTnvwgIXND9e
         dZvDamirs/JT+T5ouQYIR79vZd4yRA4vqAFVoW/Ref+lT+oenzXYdJ1IVboJzX/DEp8h
         oNmH3sxCZydRo6YIUzUvqqsF1XswzjT8qYth3Yz+sUCWNqOymLDjrRQNiYrYCgzjRZ6k
         MYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681169142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XDQcwM0Ljq47Kk+Cx8Zo9PwBtwHuWqUYBxNgZio/RfY=;
        b=YHJ/UXSdbV7O2m0sQz4LnqBGiavqncB5p6X3QHHBnf5V0ARHPLmxCfhzb7wJ7OcZSB
         FPRuMfadYoRWENAgYy1KAyk9824u01bTYR0CMOpOmE1UTb+ICKxDQm/yG6e/bji0TjWI
         vtV4FEvb/Ltg3daQlya7i4TNlwiqBzE4UvsuvatsehjUzOAAIa3HOB/3fUOfdOVJgFWj
         yg1qJtT64udstZYtMH1xUENZot8LI3JNUYKY3Uk6s+0/nYDEh1wvLUWU7z+PtYRKh4xN
         0LaF/eywLp+72lSLF7fXV/66kxhF1PaXDCUP1oTq2IhikDBt3AMPuAor6yeOJ6jb9XgM
         i1Iw==
X-Gm-Message-State: AAQBX9dIuXJq59/93vLJLVg/CNv41AmZ7cHJtFSNGPNP+auyB8HSO+RK
        tYL7GSF7TIpGXDKLWY/y6lbm8GghTaM=
X-Google-Smtp-Source: AKy350aIRErR0b3vVYuuWy3U6TpySuEN2x9ml7g4wtHK7DVqIf4n9ArmsN/Mf78+hLS6k78ixc6bd3s0LjM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3157:0:b0:b8e:db4a:a366 with SMTP id
 x84-20020a253157000000b00b8edb4aa366mr4567666ybx.11.1681169142239; Mon, 10
 Apr 2023 16:25:42 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:25:40 -0700
In-Reply-To: <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
Message-ID: <ZDSa9Bbqvh0btgQo@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Jeremi Piotrowski wrote:
> On 3/7/2023 6:36 PM, Sean Christopherson wrote:
> > Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
> > hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
> > doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
> > happens to get lucky and not run afoul of the underlying bugs.  The revert appears
> > to be reasonably straightforward (see bottom).
> 
> Hi Sean,
> 
> I'm back, and I don't have good news. The fix for the missing hyperv TLB flushes has
> landed in Linus' tree and I now had the chance to test things outside Azure, in WSL on my
> AMD laptop.
> 
> There is some seriously weird interaction going on between TDP MMU and Hyper-V, with
> or without enlightened TLB. My laptop has 16 vCPUs, so the WSL VM also has 16 vCPUs.
> I have hardcoded the kernel to disable enlightened TLB (so we know that is not interfering).
> I'm running a Flatcar Linux VM inside the WSL VM using legacy BIOS, a single CPU
> and 4GB of RAM.
> 
> If I run with `kvm.tdp_mmu=0`, I can boot and shutdown my VM consistently in 20 seconds.
> 
> If I run with TDP MMU, the VM boot stalls for seconds at a time in various spots
> (loading grub, decompressing kernel, during kernel boot), the boot output feels like
> it's happening in slow motion. The fastest I see it finish the same cycle is 2 minutes,
> I have also seen it take 4 minutes, sometimes even not finish at all. Same everything,
> the only difference is the value of `kvm.tdp_mmu`.

When a stall occurs, can you tell where the time is lost?  E.g. is the CPU stuck
in L0, L1, or L2?  L2 being a single vCPU rules out quite a few scenarios, e.g.
lock contention and whatnot.

If you can run perf in WSL, that might be the easiest way to suss out what's going
on.

> So I would like to revisit disabling tdp_mmu on hyperv altogether for the time being but it
> should probably be with the following condition:
> 
>   tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && !hypervisor_is_type(X86_HYPER_MS_HYPERV)
> 
> Do you have an environment where you would be able to reproduce this? A Windows server perhaps
> or an AMD laptop?

Hrm, not easily, no.  Can you try two things?

  1. Linus' tree on Intel hardware
  2. kvm-x86/next[*] on Intel hardware

Don't bother with #2 if #1 (Linus' tree) does NOT suffer the same stalls as AMD.
#2 is interesting iff Intel is also affected as kvm-x86/next has an optimization
for CR0.WP toggling, which was the achilles heel of the TDP MMU.  If Intel isn't
affected, then something other than CR0.WP is to blame.

I fully expect both experiments to show the same behavior as AMD, but if for some
reason they don't, the results should help narrow the search.

[*] https://github.com/kvm-x86/linux/tree/next
