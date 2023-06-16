Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9106733D0D
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 01:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjFPXxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 19:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjFPXxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 19:53:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775942D4C
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:53:03 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5538f216c7aso46290a12.0
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686959583; x=1689551583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KYn705vLM0PBhvVboNovQE84VHNHuRkYQxnWcqYC7BM=;
        b=JT0hL8IV1RWYcke5k+OLDRZsOU3MK3ztXDWpxuRfFpucJ/BvxvBbjVr8x4jXHd8WNV
         /vv0fDNpDpUZC8hsKcZxjAeAFp5LFmsz2lKLzQTFL0K3p4BCU+IKT8FunHGSwSbw9gr1
         NmIwEkDUPCeXTszFMmgucdt1XmtFnUB7OgQmCznRLhhVr2T2Xvhl4XRy7l6qvtFbRWFT
         CZAGs9lW2PB5eIrteTtGSr2pX0BTyJw88ZGAd0E2ecF3GLEct20VCyw8zKUOJPvaJLvR
         27o3wHBZBlTtUKeZbdpMYPxB5X40Kq3k1560p7s7xifceAZXParOHWD+ahQ+YfRD0pGd
         Yt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686959583; x=1689551583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYn705vLM0PBhvVboNovQE84VHNHuRkYQxnWcqYC7BM=;
        b=KTzfvbxB4qPRCe3GhaQNzx1c3IxFExQQYdlQ+myKQ3TVs/XOBGof6LV/cxiUqceLQQ
         lJhlcuxCbjvJHmErD+fmpyB8LkLSlQBWkAWqBn48ObjoXfFcA0tBDF+nC9pHhbsDYbyt
         zKfbqIKgb3qyP984FpV5q8S2PPQf8BiXWbzheszsz4Kz36mA9pffZxsxKOCbzkFRGZzo
         UGP9opqJi8V2se2ArhgNq7kUh5VzX5guYwW+CNCE0U5Tcn12XzFDuBUuT8nyNWkteouQ
         3w1o4pQliHOrZJESK/JjPdmdH5E4Mwn+ag96ZiNAfN9rY5i8xU6Vn1OXqX6Gxetnv8Kx
         lXGA==
X-Gm-Message-State: AC+VfDzSoZtJMJHAdpnWNpQRy5B7rqfLs76RyLyNGfTxsguu0If7mWtE
        NKd8YnuA508ypOkpdJu8wUfmm23XDpM=
X-Google-Smtp-Source: ACHHUZ4xFAZaglVKNekje71PfbSb63d+V8SHKptqomWE/8hSgSx/d8rUNnurooyAxH4pbJ1zqYiNNYRiCWQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:584e:0:b0:542:d1eb:90e3 with SMTP id
 s14-20020a65584e000000b00542d1eb90e3mr114254pgr.1.1686959582954; Fri, 16 Jun
 2023 16:53:02 -0700 (PDT)
Date:   Fri, 16 Jun 2023 16:53:01 -0700
In-Reply-To: <bug-217562-28872@https.bugzilla.kernel.org/>
Mime-Version: 1.0
References: <bug-217562-28872@https.bugzilla.kernel.org/>
Message-ID: <ZIz13WrkSYPOE6gQ@google.com>
Subject: Re: [Bug 217562] New: kernel NULL pointer dereference on deletion of
 guest physical memory slot
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TL;DR: I'm 99% certain you're hitting a race that results in KVM doing a list_del()
before a list_add().  I am planning on sending a patch for v5.15 to disable the
TDP MMU by default, which will "fix" this bug, but I have an extra long weekend
and won't get to that before next Thursday or so.

In the meantime, you can effect the same fix by disabling the TDP MMU via module
param, i.e. add kvm.tdp_mmu=false to your kernel/KVM command line.

On Fri, Jun 16, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217562
> 
>             Bug ID: 217562
>            Summary: kernel NULL pointer dereference on deletion of guest
>                     physical memory slot
>            Product: Virtualization
>            Version: unspecified
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: arnaud.lefebvre@clever-cloud.com
>         Regression: No
> 
> Created attachment 304438
>   --> https://bugzilla.kernel.org/attachment.cgi?id=304438&action=edit
> dmesg logs with decoded backtrace
> 
> Hello,
> 
> We've been having this BUG for the last 6 months on both Intel and AMD hosts
> without being able to reproduce it on demand.

Heh, I'm not surprised.  If my analysis is correct, you're hitting a teeny tiny
window.

> The issue also occurs randomly:
> 
> [Mon Jun 12 10:50:08 UTC 2023] BUG: kernel NULL pointer dereference, address:
> 0000000000000008
> [Mon Jun 12 10:50:08 UTC 2023] #PF: supervisor write access in kernel mode
> [Mon Jun 12 10:50:08 UTC 2023] #PF: error_code(0x0002) - not-present page
> [Mon Jun 12 10:50:08 UTC 2023] PGD 0 P4D 0
> [Mon Jun 12 10:50:08 UTC 2023] Oops: 0002 [#1] SMP NOPTI
> [Mon Jun 12 10:50:08 UTC 2023] CPU: 88 PID: 856806 Comm: qemu Kdump: loaded Not
> tainted 5.15.115 #1
> [Mon Jun 12 10:50:08 UTC 2023] Hardware name: MCT         Capri                
>          /Capri           , BIOS V2010 04/19/2022
> [Mon Jun 12 10:50:08 UTC 2023] RIP: 0010:__handle_changed_spte+0x5f3/0x670
> [Mon Jun 12 10:50:08 UTC 2023] Code: b8 a8 00 00 00 e9 4d be 0f 00 4d 8d be 60
> 6a 01 00 4c 89 44 24 08 4c 89 ff e8 69 30 43 01 4c 8b 44 24 08 49 8b 40 08 49
> 8b 10 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 00 48 83

Hooray for code dumps!  This caught *just* enough to be super helper.  The stream
is 

  mov    r8, QWORD PTR [rsp+0x8]
  mov    r15, rdi
  call   0x1433087
  mov    QWORD PTR [rsp+0x8], r8
  mov    QWORD PTR [r8+0x8], rax
  mov    QWORD PTR [r8], rdx
  mov    rax, QWORD PTR [rdx+0x8] <= faulting instruction
  mov    rdx, QWORD PTR [rax]
  movabs 0xdead000000000100, rax

The last instruction is loading RAX with LIST_POISON1, which coupled with the
stack trace means the explosion happens during this list_del():

  static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
				bool shared)
  {
	if (shared)
		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
	else
		lockdep_assert_held_write(&kvm->mmu_lock);

	list_del(&sp->link);  <= here
	if (sp->lpage_disallowed)
		unaccount_huge_nx_page(kvm, sp);

	if (shared)
		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  }

  static inline void list_del(struct list_head *entry)
  {
	__list_del_entry(entry);
	entry->next = LIST_POISON1;  <= last instruction in the code stream
	entry->prev = LIST_POISON2;
  }

The +0x8 means the write to next->prev is failing, i.e. RDX == sp->list.next and
RAX == sp.list->prev, which provides a big smoking gun because both RAX and RDX
are 0, i.e. both next and prev are NULL.

  static inline void __list_del_entry(struct list_head *entry)
  {
	if (!__list_del_entry_valid(entry))
		return;

	__list_del(entry->prev, entry->next);
  }

  static inline void __list_del(struct list_head * prev, struct list_head * next)
  {
	next->prev = prev;  <= effectively the faulting instruction
	WRITE_ONCE(prev->next, next);
  }

That means the issue is that KVM is observing a present SPTE whose sp->list is
uninitialized (well, zero-initialized), i.e. a shadow page that has been installed
in KVM's page tables but not added to the list of a shadow pages.

Lo and behold, in v5.15 kvm_tdp_mmu_map() sets the SPTE before linking the shadow
page:

			if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
				tdp_mmu_link_page(vcpu->kvm, sp,
						  huge_page_disallowed &&
						  req_level >= iter.level);

				trace_kvm_mmu_get_page(sp, true);
			}


  static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
			      bool account_nx)
  {
	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);  <= this needs to happen before the SPTE is visible
	if (account_nx)
		account_huge_nx_page(kvm, sp);
	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  }

The bug is extremely difficult to hit because zapping all SPTEs doesn't happen
often, especially not when vCPUs are running.  And the problematic window is
really, really small; the zapping CPU needs to read the SPTE after its set by
the faulting vCPU, but then win the race to acquire kvm->arch.tdp_mmu_pages_lock,
e.g. I wouldn't be surprised if the failures happen when the CPU that's handling
the vCPU page fault to take an interrupt between setting the SPTE and acquiring
tdp_mmu_pages_lock.

Ah, and this specific scenario is only possible due to a second bug that was fixed
by commit a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by
memslot update").  Unfortunately, that commit doesn't seem to have made its way to
v5.15 despite being tagged for stable (more than likely due to a missed dependency).

The memslot update is supposed to make the entire paging tree unavailable/invalid
while holding mmu_lock for write, i.e. prevent page faults from operating on the
invalid tree, but the TDP MMU page fault handler neglected to check that the paging
tree was fresh/valid after acquiring mmu_lock.

And as if that wasn't enough, another reason why no one has reported this beyond
v5.15 is that commit d25ceb926436 ("KVM: x86/mmu: Track the number of TDP MMU pages,
but not the actual pages") stopped tracking the list of pages, i.e. even if this
bug can be hit in current upstream, it will manifest as a temporarily, almost
imperceptibly bad tdp_mmu_pages count, not a NULL pointer deref.

This is very similar to the bug that was fixed by commit 21a36ac6b6c7 ("KVM: x86/mmu:
Re-check under lock that TDP MMU SP hugepage is disallowed"), just with a bit of
role reversal.

If you're feeling particularly masochistic, I bet you could reproduce this more
easily by introducing a delay between setting the SPTE and linking the page, e.g.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c2bb60ccd88..1fb10d4156aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1071,6 +1071,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
                                                     !shadow_accessed_mask);
 
                        if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
+                               udelay(100);
                                tdp_mmu_link_page(vcpu->kvm, sp,
                                                  huge_page_disallowed &&
                                                  req_level >= iter.level);

As for a fix, for v5.15 I think the right approach is to simply disable the TDP
MMU.  I was already planning on doing that to address another hard-to-backport
flaw[*], and this is pretty much the final nail in the coffin.

For upstream and 6.1 (the LTS kernels with the TDP MMU enabled), I don't think
there's anything worth fixing, though at the very least I'll add a big fat comment
warning about the dangers of doing anything with a shadow page after it's linked.
Strictly speaking, it's probably more correct to account the shadow page before its
SPTE is set, and then unaccount the page in the rare scenario where setting the
SPTE fails, but so long as its *just* stats accounting, nothing should break, i.e.
the minor complexity of adding the unaccounting probably isn't worth it.

[*] https://lore.kernel.org/all/ZDmEGM+CgYpvDLh6@google.com

> [Mon Jun 12 10:50:09 UTC 2023] RSP: 0018:ffffc90029477840 EFLAGS: 00010246
> [Mon Jun 12 10:50:09 UTC 2023] RAX: 0000000000000000 RBX: ffff89581a1f6000 RCX:
> 0000000000000000
> [Mon Jun 12 10:50:09 UTC 2023] RDX: 0000000000000000 RSI: 0000000000000002 RDI:
> ffffc9002d858a60
> [Mon Jun 12 10:50:09 UTC 2023] RBP: 0000000000002200 R08: ffff893450426450 R09:
> 0000000000000002
> [Mon Jun 12 10:50:09 UTC 2023] R10: 0000000000000001 R11: 0000000000000001 R12:
> 0000000000000001
> [Mon Jun 12 10:50:09 UTC 2023] R13: 00000000000005a0 R14: ffffc9002d842000 R15:
> ffffc9002d858a60
> [Mon Jun 12 10:50:09 UTC 2023] FS:  00007fdb6c1ff6c0(0000)
> GS:ffff89804d800000(0000) knlGS:0000000000000000
> [Mon Jun 12 10:50:09 UTC 2023] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> [Mon Jun 12 10:50:09 UTC 2023] CR2: 0000000000000008 CR3: 0000005380534005 CR4:
> 0000000000770ee0
> [Mon Jun 12 10:50:09 UTC 2023] PKRU: 55555554
> [Mon Jun 12 10:50:09 UTC 2023] Call Trace:
> [Mon Jun 12 10:50:09 UTC 2023]  <TASK>
> [Mon Jun 12 10:50:09 UTC 2023]  ? __die+0x50/0x8d
> [Mon Jun 12 10:50:09 UTC 2023]  ? page_fault_oops+0x184/0x2f0
> [Mon Jun 12 10:50:09 UTC 2023]  ? exc_page_fault+0x535/0x7d0
> [Mon Jun 12 10:50:09 UTC 2023]  ? asm_exc_page_fault+0x22/0x30
> [Mon Jun 12 10:50:09 UTC 2023]  ? __handle_changed_spte+0x5f3/0x670
> [Mon Jun 12 10:50:09 UTC 2023]  ? update_load_avg+0x73/0x560
> [Mon Jun 12 10:50:09 UTC 2023]  __handle_changed_spte+0x3ae/0x670
> [Mon Jun 12 10:50:09 UTC 2023]  __handle_changed_spte+0x3ae/0x670

I don't think it matters much, but the recursion on __handle_changed_spte() means
that KVM is zapping a lower level, non-leaf SPTE.

> [Mon Jun 12 10:50:09 UTC 2023]  zap_gfn_range+0x21a/0x320
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_tdp_mmu_zap_invalidated_roots+0x50/0xa0
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_mmu_zap_all_fast+0x178/0x1b0
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_page_track_flush_slot+0x4f/0x90
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_set_memslot+0x32b/0x8e0
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_delete_memslot+0x58/0x80
> [Mon Jun 12 10:50:09 UTC 2023]  __kvm_set_memory_region+0x3c4/0x4a0
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_vm_ioctl+0x3d1/0xea0
> [Mon Jun 12 10:50:09 UTC 2023]  __x64_sys_ioctl+0x8b/0xc0
> [Mon Jun 12 10:50:09 UTC 2023]  do_syscall_64+0x3f/0x90
> [Mon Jun 12 10:50:09 UTC 2023]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> [Mon Jun 12 10:50:09 UTC 2023] RIP: 0033:0x7fdc71e3a5ef
> [Mon Jun 12 10:50:09 UTC 2023] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7

...

> We've seen this issue with kernel 5.15.115, 5.15.79, some versions between the
> two, and probably a 5.15.4x (not sure here). At the beginning, only a few
> "identical" hosts (same hardware model) had this issue but since then we've
> also had crashes on hosts running different hardware. Unfortunately, it
> sometimes takes a  few weeks to trigger (last occurrence before this one was 2
> months ago) and we can't really think of a way to reproduce this.
> 
> As you can see in the dmesg.log.gz file, this bug then creates soft lockups for
> other processes, I guess because they wait for some kind of lock that never
> gets released. The host then becomes more and more unresponsive as time goes
> by.

Yeah, mmu_lock is held at this time.  Any BUG() or NULL pointer deref while holding
a spinlock is pretty much game over.  mmu_lock in particular all but guarantees a
quick death since it's so heavily used in KVM.
