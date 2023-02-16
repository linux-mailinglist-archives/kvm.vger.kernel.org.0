Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B14699B55
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjBPRcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjBPRcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:32:06 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82A84FA92
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:32:04 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x15-20020a25accf000000b008efe9505b2eso2615638ybd.22
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=078dAYknkaVmw+v9O1iAn3FpgkDRX+vzrYeFy/1f0S8=;
        b=KYe9HbGvkuRqbhKaxJmkV59iEAvv0np9yfXUVePtjr8JbGsZ6XuoBzalYWeoRdmuFZ
         rpAj9PEav3DNxLV9CtI7vozQjdj1d481HqPGqgDx0vQXL8DghdrrOU210Xitck+/Pyg0
         HfdHMqWLZV0NO70d+uo9oos96xA5FDF87nM/sUD16c6bwpRGCLjcF5RLDpjDoMxiv5eo
         Sn+WgL/yCHP4999NtYVisLNqHQbfuUzMczpuQk52rWc6gz1w5zRYfpMmtr75No2fkl9L
         9aBNa/WfKRInF04I2vzcfPrAL9GS72wrPvxlWHKRKWFS71kXWw4pfWNNvSq3F1L79dqo
         Aonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=078dAYknkaVmw+v9O1iAn3FpgkDRX+vzrYeFy/1f0S8=;
        b=WWqAaQRMtT6HzaxW1N1DhpTYGkjG5D65soLQSkuloBUjB8ADjnHP74z00S7GwBMIxA
         omiYhld7iJZDAMOeBMnWXXarzGmTy17aYk7ciDt2w/PBvBGmOWUa0EFRT068PheEPaF2
         hv0osVgyBaz2o1EIB3uKPQFzUeIyBGh0U2CqLoVkWn9PSXd31yI1c4zLAjEJzD2ArC/4
         8Kf6kZyG1OJs+et4JsYSsmCNFIvmI4ULUVYcj44FvLYzEtwAFBeYvtCgB+Io/7wHQ/63
         gmrlPLQ2Ni3qHeMDKiEbyLubq7F2S+a4hUaPuk505nJUhA3+UD45dvrwRjJ7RSggElg6
         Neag==
X-Gm-Message-State: AO0yUKWfEqMrhk8UFripEv4ne1yFdBNYoK50tZazd4rsrTOrYpbxESJ2
        DH5e4BE7T8W97MWFg/xmmPmOrgb8vWI=
X-Google-Smtp-Source: AK7set/W0D1TvTBIkkmYXWvUOVaevtpR0wIKchdY2le7yRWap8R51ow6W+G4iLYWU6PQixce3mJzFt9Y5v4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d547:0:b0:52f:65c:9334 with SMTP id
 l7-20020a81d547000000b0052f065c9334mr847481ywj.165.1676568723995; Thu, 16 Feb
 2023 09:32:03 -0800 (PST)
Date:   Thu, 16 Feb 2023 09:32:02 -0800
In-Reply-To: <13deaeb6-dfb2-224c-0aa3-5546ad426f63@grsecurity.net>
Mime-Version: 1.0
References: <20230213163351.30704-1-minipli@grsecurity.net>
 <Y+pt5MGR+EjLH4qQ@google.com> <13deaeb6-dfb2-224c-0aa3-5546ad426f63@grsecurity.net>
Message-ID: <Y+5okhlB4rkXjKWS@google.com>
Subject: Re: [PATCH 0/5] KVM: Put struct kvm_vcpu on a diet
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
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

On Tue, Feb 14, 2023, Mathias Krause wrote:
> On 13.02.23 18:05, Sean Christopherson wrote:
> However, I still remain confident that this makes sense from a uarch point of
> view. Touching less cache lines should be a win -- even if I'm unable to
> measure it. By preserving more cachelines during a VMEXIT, guests should be
> able to resume their work faster (assuming they still need these cachelines).

Yes, but I'm skeptical that compacting struct kvm_vcpu will actually result in
fewer cache lines being touched, at least not in a persistent, maintainable way.
While every VM-Exit accesses a lot of state, it's most definitely still a small
percentage of kvm_vcpu.  And for the VM-Exits that really benefit from optimized
handling, a.k.a. the fastpath exits, that percentage is even lower.

On x86, kvm_vcpu is actually comprised of three "major" structs: kvm_vcpu,
kvm_vcpu_arch, and vcpu_{vmx,svm}.  The majority of fields accessed on every VM-Exit
are in the vendor part, vcpu_{vmx,svm}, but there are still high-touch fields in
the common structures, e.g. registers in kvm_vcpu_arch and things like requests
in kvm_vcpu.

Naively compating any of the three (well, four) structures might result in fewer
cache lines being touched, but mostly by coincidence.  E.g. because compacting
part of kvm_vcpu_arch happened to better align vcpu_vmx, not because of the
compaction itself.

If we really wanted to optimize cache line usage, our best bet would be to identify
the fields that are accessed in the fastpath run loop and then pack those fields
into as few cache lines as possible.  And to do that in a maintainable way, we'd
probably need something like ASI[*] to allow us to detect changes that result in
the fastpath handling accessing fields that aren't in the cache-optimized region.

I'm not necessarily opposed to such aggressive optimization, but the ROI is likely
very, very low.  For optimized workloads, there simply aren't very many VM-Exits,
e.g. the majority of exits on a modern CPU are due to timer ticks.  And even those
will hopefully be eliminiated in the not-too-distant future, e.g. by having hardware
virtualize the TSC deadline timer, and by moving to a vCPU scheduling scheme that
allows for a tickless host.
 
https://lore.kernel.org/all/20220223052223.1202152-1-junaids@google.com

> > And as you observed, imperfect struct layouts are highly unlikely to have a
> > measurable impact on performance.  The types of operations that are involved in
> > a world switch are just too costly for the layout to matter much.  I do like to
> > shave cycles in the VM-Enter/VM-Exit paths, but only when a change is inarguably
> > more performant, doesn't require ongoing mainteance, and/or also improves the code
> > quality.
> 
> Any pointers to measure the "more performant" aspect?

TL;DR: not really.

What I've done in the past is run a very tight loop in the guest, and then measure
latency from the host by hacking KVM.  Measuring from the guest works, e.g. we have
a variety of selftests that do exactly that, but when trying to shave cycles in
the VM-Exit path, it doesn't take many host IRQs arriving at the "wrong" time to
skew the measurement.  My quick-and-dirty solution has always been to just hack
KVM to measure latency with IRQs disabled, but a more maintainable approach would
be to add smarts somewhere to sanitize the results, e.g. to throw away outliers
where the guest likely got interrupted.

I believe we've talked about adding a selftest to measure fastpath latency, e.g.
by writing MSR_IA32_TSC_DEADLINE in a tight loop.

However, that's not going to be useful in this case since you are interested in
measuring the impact of reducing the host's L1D footprint.  If the guest isn't
cache-constrainted, reducing the host's cache footprint isn't going to impact
performance since there's no contention.

Running a micro benchmark in the guest that aims to measure cache performance might
work, but presumably those are all userspace tests, i.e. you'd end up measuring
the impact of the guest kernel too.  And they wouldn't consistently trigger VM-Exits,
so it would be difficult to prove the validity of the results.

I suppose you could write a dedicated selftest or port a micro benchmark to run
as a selftest (or KVM-unit-test)?

>  I tried to make use of the vmx_vmcs_shadow_test in kvm-unit-tests, as it's
>  already counting cycles, but the numbers are too unstable, even if I pin the
>  test to a given CPU, disable turbo mode, SMT, use the performance cpu
>  governor, etc.

Heh, you might have picked quite possibly the worst way to measure VM-Exit
performance :-)

The guest code in that test that's measuring latency runs at L2.  For VMREADs
and VMWRITEs that are "passed-through" all the way to L2, no VM-Exit will occur
(the access will be handled purely in ucode).  And for accesses that do cause a
VM-Exit, I'm pretty sure they all result in a nested VM-Exit, which is a _very_
heavy path (~10k cycles).  Even if the exit is handled by KVM (in L0), it's still
a relatively slow, heavy path.

> > I am in favor in cleaning up kvm_mmu_memory_cache as there's no reason to carry
> > a sub-optimal layouy and the change is arguably warranted even without the change
> > in size.  Ditto for kvm_pmu, logically I think it makes sense to have the version
> > at the very top.
> 
> Yeah, was exactly thinking the same when modifying kvm_pmu.
> 
> > But I dislike using bitfields instead of bools in kvm_queued_exception, and shuffling
> > fields in kvm_vcpu, kvm_vcpu_arch, vcpu_vmx, vcpu_svm, etc. unless there's a truly
> > egregious field(s) just isn't worth the cost in the long term.
> 
> Heh, just found this gem in vcpu_vmx:
> 
> struct vcpu_vmx {
>   [...]
>   union vmx_exit_reason      exit_reason;
> 
>   /* XXX 44 bytes hole, try to pack */
> 
>   /* --- cacheline 123 boundary (7872 bytes) --- */
>   struct pi_desc             pi_desc __attribute__((__aligned__(64)));
>   [...]
> 
> So there are, in fact, some bigger holes left.

Ya.  Again, I'm definitely ok cleaning up the truly heinous warts and/or doing
a targeted, deliberate refactor of structures.  What I don't want to do is
shuffle fields around purely to save a few bytes here and there.
