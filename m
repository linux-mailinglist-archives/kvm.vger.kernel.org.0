Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008C74710FE
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 03:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241301AbhLKCn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 21:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhLKCn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 21:43:27 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D62C061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 18:39:51 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r5so9570661pgi.6
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 18:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oiYth8rOuvwLFLMoj5Cs2ZklhXoCle8fSSgCZEwK4y0=;
        b=OQMlOADnP0S0Q92Nh/Clz7bKlSc378tUDRfHpDfV9EG9Q4wNSPHl7bFvo6hkFdRnUj
         FdsaClbBEbPrQIqxYmwGzCpSZmoqoYqG51xd/WaqkcLp03U1HDxv7rF0Q9xFq7BUKTNl
         s1yR0aLtODOqzpx0QhesZekC0++fAPHG92I5lTYAhdTE+ibjriOIVUK7+3cPdPmegCtX
         LBfbBZRzOKWa/BodlTNlAz8xndRWJRcr5UCtHBO2njm+ZJnlTTLnt6FF3QzmiAcRQxu2
         3+mDGJF7rgvCIGxIZAaNf2y4HYiB5NQNxSv+1oo95IxSATvM5KDXZhD5WRBca90up/Ye
         RZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oiYth8rOuvwLFLMoj5Cs2ZklhXoCle8fSSgCZEwK4y0=;
        b=fDXw5rXuaUz925lgoqEcPtBToyqRAVmGfgx5u8jTR4XZ6ewEgajBHOcVhX/7+QHWkm
         C2AH58xGouBwjHaXJMXyOQ2zosDO7CfXfateeupW+KBkjQmCa5gkatX3yfU44RCWTaNn
         rwJrcyrvEUcfaKDU8Cw5iSbIhzFOmXNjLTnbpGboMRPBUfGXnevxMhk2Uv2+t6Fuu3ia
         EhaWqVDHNvg0MnBf0Yh3kAXRzr5D2k1iDoaph43WxFET1DexFgE0tgzIAXn2oEzRbh+X
         Cn8I3FRxtJavQTjoi4GIn7L0HUlYzdarhwhwnC4dKa7vCpxeDa0gRFq14KW7Yugy+Vo5
         nhoQ==
X-Gm-Message-State: AOAM533zpU0X/aKpFLLl7aESgPYJ2v6notqi76AMF2kJxkNr1aMq3zPQ
        wZ9men8AkqRIU+Eyvf0HDp9Ozg==
X-Google-Smtp-Source: ABdhPJz62PDr+a/P2xWRzW5s0ZjHW13uYausA5vqR+NJLcW4BKjGh1zI23sQd6/gmdvE/AEmAO8x7w==
X-Received: by 2002:a65:40c3:: with SMTP id u3mr41732649pgp.160.1639190390891;
        Fri, 10 Dec 2021 18:39:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mp12sm300773pjb.39.2021.12.10.18.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:39:50 -0800 (PST)
Date:   Sat, 11 Dec 2021 02:39:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Subject: Re: Potential bug in TDP MMU
Message-ID: <YbQPcsnpowmCP7G8@google.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com>
 <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Ignat Korchagin wrote:
> I've been trying to figure out the difference between "good" runs and
> "bad" runs of gvisor. So, if I've been running the following bpftrace
> onliner:

...

> That is, I never get a stack with
> kvm_tdp_mmu_put_root->..->kvm_set_pfn_dirty with a "good" run.
> Perhaps, this may shed some light onto what is going on.

Hmm, a little?

Based on the WARN backtrace, KVM encounters an entire chain of valid, present TDP
MMU paging structures _after_ exit_mm() in the do_exit() path, as the call to
task_work_run() in do_exit() occurs after exit_mm().

That means that kvm_mmu_zap_all() is guaranteed to have been called before the
fatal kvm_arch_destroy_vm(), as either:

  a) exit_mm() put the last reference to mm_users and thus called __mmput ->
     exit_mmap() -> mmu_notifier_release() -> ... -> kvm_mmu_zap_all().

  b) Something else had a reference to mm_users, and so KVM's ->release hook was
     invoked by kvm_destroy_vm() -> mmu_notifier_unregister().

It's probably fairly safe to assume this is a TDP MMU bug, which rules out races
or bad refcounts in other areas.

That means that KVM (a) is somehow losing track of a root, (b) isn't zapping all
SPTEs in kvm_mmu_zap_all(), or (c) is installing a SPTE after the mm has been released.

(a) is unlikely because kvm_tdp_mmu_get_vcpu_root_hpa() is the only way for a
vCPU to get a reference, and it holds mmu_lock for write, doesn't yield, and
either gets a root from the list or adds a root to the list.

(b) is unlikely because I would expect the fallout to be much larger and not
unique to your setup.

That leaves (c), which isn't all that likely either.  I can think of a variety of
ways KVM might write a defunct SPTE, but I can't concoct a scenario where an
entire tree of a present paging structures is written.

Can you run with the below debug patch and see if you get a hit in the failure
scenario?  Or possibly even a non-failure scenario?  This should either confirm
or rule out (c).


---
 arch/x86/kvm/mmu/mmu.c     | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c | 5 +++++
 include/linux/kvm_host.h   | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ccee4d17481..e4e283a38570 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5939,6 +5939,8 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	LIST_HEAD(invalid_list);
 	int ign;

+	atomic_set(&kvm->mm_released, 1);
+
 	write_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b69e47e68307..432ccf05f446 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -504,6 +504,9 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 {
 	lockdep_assert_held_read(&kvm->mmu_lock);

+	WARN_ON(atomic_read(&kvm->mm_released) &&
+		new_spte && !is_removed_spte(new_spte));
+
 	/*
 	 * Do not change removed SPTEs. Only the thread that froze the SPTE
 	 * may modify it.
@@ -577,6 +580,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);

+	WARN_ON(atomic_read(&kvm->mm_released) && new_spte);
+
 	/*
 	 * No thread should be using this function to set SPTEs to the
 	 * temporary removed SPTE value.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7bfcc3b6b0b..8e76e2f6c3be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -569,6 +569,8 @@ struct kvm {

 	struct mutex slots_lock;

+	atomic_t mm_released;
+
 	/*
 	 * Protects the arch-specific fields of struct kvm_memory_slots in
 	 * use by the VM. To be used under the slots_lock (above) or in a

base-commit: 1c10f4b4877ffaed602d12ff8cbbd5009e82c970
--
