Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B542577FD4E
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 19:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354130AbjHQRx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354110AbjHQRx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 13:53:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C04AFD
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 10:53:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-565aba2e397so155180a12.3
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 10:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692294806; x=1692899606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QfHz94PEI777+7Lpp3S/ts6ZJ/OexKtidSfc/v6di4=;
        b=5VDrrPqxILFeG85qXIOlipeB/fbXU9Z70kmuxlB1LKWWFWR1eJN1Aat8hUG4zNmtYQ
         Jk8bSAcpoF2xPTk0K5gwQozRc9MT5/5puLlHXxvViNFgE1q3+8mMnDXbo3hFAUNWYtgL
         2/sDWwAx8TMccYtm62YVgyPGPEly2cWzFPJQ26KyZcnIO5gmoQFxIhuNPNthzVJwbcp6
         XgOJwX4iCDQ6AMhkK8vDWko0IcNb3SEF95v+6VchC4UidTKYatwqzHpNA96zGDqM9213
         GhVhONmVY0Fg4IcJ44Xkwvce3WxFbctcltNnkLqZXAEOebigTQ1uZg8f8BwKHt2kmv/D
         bW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692294806; x=1692899606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QfHz94PEI777+7Lpp3S/ts6ZJ/OexKtidSfc/v6di4=;
        b=UmhmEsYlJZzg8TkWf/XwIp6cefQNWs5ABYeY0eXrO5pSJ9DePlNaEwpXOwdldRmXzs
         G9vMhGBIFgxUeGx4/dhTjO0XU4Pep+8sJGKfsm4OsV1RWXJu/etYw5ItGdevh8FVTMbV
         ljmSljd7OChRHYAu3bUa/kvaf3+n5h9OpYPOVfoJZsz8dVe2g8EXESG9lrff909TjenK
         TxN2iLouyhhI8syeGKscM8tah2oSa8t2jZ/kXHC240U37MG4M8LZi+LhQDy0YKqHO2IL
         nTdpZwSizpKOBCI0dnsZ932BtjEfQli703Zb9vJDYq3x6KQLC6brwhnOX1vAcuPZeo/F
         YPWw==
X-Gm-Message-State: AOJu0YyqRg3EHmIfJAWOweS4zgrY1ZhWrMqvU+gYr10eVFioUg4+cA/9
        y/8H7vRyoTK8OpdgwvMrax9BSfd+vRc=
X-Google-Smtp-Source: AGHT+IF/RicpJSK/jOu2VSTjgEjRuNtgLEUAFiSN3DLAk/LZArf/NVih5B66NrtRt0HGs060Y532Ir/C0yQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:715b:0:b0:567:c791:ce64 with SMTP id
 b27-20020a63715b000000b00567c791ce64mr726537pgn.8.1692294806566; Thu, 17 Aug
 2023 10:53:26 -0700 (PDT)
Date:   Thu, 17 Aug 2023 10:53:25 -0700
In-Reply-To: <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230808085056.14644-1-yan.y.zhao@intel.com> <ZN0S28lkbo6+D7aF@google.com>
 <ZN1jBFBH4C2bFjzZ@yzhao56-desk.sh.intel.com>
Message-ID: <ZN5elYQ5szQndN8n@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
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

On Thu, Aug 17, 2023, Yan Zhao wrote:
> On Wed, Aug 16, 2023 at 11:18:03AM -0700, Sean Christopherson wrote:
> > On Tue, Aug 08, 2023, Yan Zhao wrote:
> > > This series optmizes KVM mmu notifier.change_pte() handler in x86 TDP MMU
> > > (i.e. kvm_tdp_mmu_set_spte_gfn()) by removing old dead code and prefetching
> > > notified new PFN into SPTEs directly in the handler.
> > > 
> > > As in [1], .change_pte() has been dead code on x86 for 10+ years.
> > > Patch 1 drops the dead code in x86 TDP MMU to save cpu cycles and prepare
> > > for optimization in TDP MMU in patch 2.
> > 
> > If we're going to officially kill the long-dead attempt at optimizing KSM, I'd
> > strongly prefer to rip out .change_pte() entirely, i.e. kill it off in all
> > architectures and remove it from mmu_notifiers.  The only reason I haven't proposed
> > such patches is because I didn't want to it to backfire and lead to someone trying
> > to resurrect the optimizations for KSM.
> > 
> > > Patch 2 optimizes TDP MMU's .change_pte() handler to prefetch SPTEs in the
> > > handler directly with PFN info contained in .change_pte() to avoid that
> > > each vCPU write that triggers .change_pte() must undergo twice VMExits and
> > > TDP page faults.
> > 
> > IMO, prefaulting guest memory as writable is better handled by userspace, e.g. by
> > using QEMU's prealloc option.  It's more coarse grained, but at a minimum it's
> > sufficient for improving guest boot time, e.g. by preallocating memory below 4GiB.
> > 
> > And we can do even better, e.g. by providing a KVM ioctl() to allow userspace to
> > prefault memory not just into the primary MMU, but also into KVM's MMU.  Such an
> > ioctl() is basically manadatory for TDX, we just need to morph the support being
> > added by TDX into a generic ioctl()[*]
> > 
> > Prefaulting guest memory as writable into the primary MMU should be able to achieve
> > far better performance than hooking .change_pte(), as it will avoid the mmu_notifier
> > invalidation, e.g. won't trigger taking mmu_lock for write and the resulting remote
> > TLB flush(es).  And a KVM ioctl() to prefault into KVM's MMU should eliminate page
> > fault VM-Exits entirely.
> > 
> > Explicit prefaulting isn't perfect, but IMO the value added by prefetching in
> > .change_pte() isn't enough to justify carrying the hook and the code in KVM.
> > 
> > [*] https://lore.kernel.org/all/ZMFYhkSPE6Zbp8Ea@google.com
> Hi Sean,
> As I didn't write the full picture of patch 2 in the cover letter well,
> may I request you to take a look of patch 2 to see if you like it? (in
> case if you just read the cover letter).

I read patch two, I replied to the cover letter as I wanted to discuss the two
patches together since implementing the CoW optimization effectively means
dropping the long-dead KSM optimization.

> What I observed is that each vCPU write to a COW page in primary MMU
> will lead to twice TDP page faults.
> Then, I just update the secondary MMU during the first TDP page fault
> to avoid the second one.
> It's not a blind prefetch (I checked the vCPU to ensure it's triggered
> by a vCPU operation as much as possible)

Yes, that's part of the complexity I don't like.

> and it can benefit guests who doesn't explicitly request a prefault memory as
> write.

Yes, I'm arguing that the benefit isn't significant, and that the use cases it
might benefit aren't things people care about optimizing.

I'm very skeptical that shaving those 8000 VM-Exits will translate to a meaningful
reduction in guest boot time, let alone scale beyond very specific scenarios and
configurations, which again, are likely suboptimal in nature.  Actually, they most
definitely are suboptimal, because the fact that this provides any benefit
whatsoever means that either your VM isn't being backed with hugepages, or it's
being backed with THP and transparent_hugepage/use_zero_page is enabled (and thus
is generating CoW behavior).

Enabling THP or using HugeTLB (which again can be done on a subset of guest memory)
will have a far, far bigger impact on guest performance.  Ditto for disabling
using the huge zero_page when backing VMs with THP (any page touched by the guest
is all but guaranteed to be written sooner than later, so using the zero_page
doesn't make a whole lot of sense).

E.g. a single CoW operation will take mmu_lock for write three times:
invalidate_range_start(), change_pte(), and invalidate_range_end(), not to mention
the THP zero_page CoW will first fault-in a read-only mapping, then split that
mapping, and then do CoW on the 4KiB PTEs, which is *really* suboptimal.

Actually, I don't even completely understand how you're seeing CoW behavior in
the first place.  No sane guest should blindly read (or execute) uninitialized
memory.  IIUC, you're not running a Windows guest, and even if you are, AFAIK
QEMU doesn't support Hyper-V's enlightment that lets the guest assume memory has
been zeroed by the hypervisor.  If KSM is to blame, then my answer it to turn off
KSM, because turning on KSM is antithetical to guest performance (not to mention
that KSM is wildly insecure for the guest, especially given the number of speculative
execution attacks these days).

If there's something else going on, i.e. if your VM really is somehow generating
reads before writes, and if we really want to optimize use cases that can't use
hugepages for whatever reason, I would much prefer to do something like add a
memslot flag to state that the memslot should *always* be mapped writable.  Because
outside of setups that use KSM, the only reason I can think of to not map memory
writable straightaway is if userspace somehow knows the guest isn't going to write
that memory.

If it weren't for KSM, and if it wouldn't potentially be a breaking change, I
would even go so far as to say that KVM should always map writable memslots as
writable in the guest.

E.g. minus the uAPI, this is a lot simpler to implement and maintain.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfbaafbe3a00..6c4640483881 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2727,10 +2727,14 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
                return KVM_PFN_NOSLOT;
        }
 
-       /* Do not map writable pfn in the readonly memslot. */
-       if (writable && memslot_is_readonly(slot)) {
-               *writable = false;
-               writable = NULL;
+       if (writable) {
+               if (memslot_is_readonly(slot)) {
+                       *writable = false;
+                       writable = NULL;
+               } else if (memslot_is_always_writable(slot)) {
+                       *writable = true;
+                       write_fault = true;
+               }
        }
 
        return hva_to_pfn(addr, atomic, interruptible, async, write_fault,


And FWIW, removing .change_pte() entirely, even without any other optimizations,
will also benefit those guests, as it will remove a source of mmu_lock contention
along with all of the overhead of invoking callbacks, walking memslots, etc.  And
removing .change_pte() will benefit *all* guests by eliminating unrelated callbacks,
i.e. callbacks when memory for the VMM takes a CoW fault.

So yeah, unless I'm misunderstanding the bigger picture, the more I look at this,
the more I'm against it.
