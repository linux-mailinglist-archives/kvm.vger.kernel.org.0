Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EFC733D0E
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 01:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbjFPXxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 19:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjFPXxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 19:53:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FB32D4C
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 16:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCA5D612CF
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 23:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B9EFC433C8
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 23:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686959587;
        bh=1k/7zJGE/zQFWz4qAMXFVi1Y9NX/AlnTFPx/5BoN6HQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KlQo6h7Jd8dLHcoEBKoR4Vp1E3zna5Je1RvE2CwozA3MW2+XUujxmrPLxKCHB3WnM
         kUdKKviz1b0HJG9r8HNmUwWhmBV93vxxP5GvL/2cudTBtjwc0w7HGnJYEyVWmrd+bq
         kJ1neIHLou42HshrsQ15Zhequp/TNmaetCC3HLwjgc/LmaUbRJqhgb3TE91F01OwUo
         l1zaFWypV0tkD+qRjoHKIj5YyTSZ/HlhcLji9zypN2LadOSiUDXUnOt5B5EnWpNoN8
         83LDck6WN/zKRVGCtgLVGuEWJVeM3Gnfzjy0HiPqfV4l6QPa+7VOjemHVKmB4WvCEX
         WCiY6sBku3Ugw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 07BB4C53BD0; Fri, 16 Jun 2023 23:53:07 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217562] kernel NULL pointer dereference on deletion of guest
 physical memory slot
Date:   Fri, 16 Jun 2023 23:53:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217562-28872-NzZJGX9g9D@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217562-28872@https.bugzilla.kernel.org/>
References: <bug-217562-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217562

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
TL;DR: I'm 99% certain you're hitting a race that results in KVM doing a
list_del()
before a list_add().  I am planning on sending a patch for v5.15 to disable=
 the
TDP MMU by default, which will "fix" this bug, but I have an extra long wee=
kend
and won't get to that before next Thursday or so.

In the meantime, you can effect the same fix by disabling the TDP MMU via
module
param, i.e. add kvm.tdp_mmu=3Dfalse to your kernel/KVM command line.

On Fri, Jun 16, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217562
>=20
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
>=20
> Created attachment 304438
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D304438&action=3Dedit
> dmesg logs with decoded backtrace
>=20
> Hello,
>=20
> We've been having this BUG for the last 6 months on both Intel and AMD ho=
sts
> without being able to reproduce it on demand.

Heh, I'm not surprised.  If my analysis is correct, you're hitting a teeny =
tiny
window.

> The issue also occurs randomly:
>=20
> [Mon Jun 12 10:50:08 UTC 2023] BUG: kernel NULL pointer dereference, addr=
ess:
> 0000000000000008
> [Mon Jun 12 10:50:08 UTC 2023] #PF: supervisor write access in kernel mode
> [Mon Jun 12 10:50:08 UTC 2023] #PF: error_code(0x0002) - not-present page
> [Mon Jun 12 10:50:08 UTC 2023] PGD 0 P4D 0
> [Mon Jun 12 10:50:08 UTC 2023] Oops: 0002 [#1] SMP NOPTI
> [Mon Jun 12 10:50:08 UTC 2023] CPU: 88 PID: 856806 Comm: qemu Kdump: load=
ed
> Not
> tainted 5.15.115 #1
> [Mon Jun 12 10:50:08 UTC 2023] Hardware name: MCT         Capri=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
>          /Capri           , BIOS V2010 04/19/2022
> [Mon Jun 12 10:50:08 UTC 2023] RIP: 0010:__handle_changed_spte+0x5f3/0x670
> [Mon Jun 12 10:50:08 UTC 2023] Code: b8 a8 00 00 00 e9 4d be 0f 00 4d 8d =
be
> 60
> 6a 01 00 4c 89 44 24 08 4c 89 ff e8 69 30 43 01 4c 8b 44 24 08 49 8b 40 0=
8 49
> 8b 10 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 00 48 83

Hooray for code dumps!  This caught *just* enough to be super helper.  The
stream
is=20

  mov    r8, QWORD PTR [rsp+0x8]
  mov    r15, rdi
  call   0x1433087
  mov    QWORD PTR [rsp+0x8], r8
  mov    QWORD PTR [r8+0x8], rax
  mov    QWORD PTR [r8], rdx
  mov    rax, QWORD PTR [rdx+0x8] <=3D faulting instruction
  mov    rdx, QWORD PTR [rax]
  movabs 0xdead000000000100, rax

The last instruction is loading RAX with LIST_POISON1, which coupled with t=
he
stack trace means the explosion happens during this list_del():

  static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
                                bool shared)
  {
        if (shared)
                spin_lock(&kvm->arch.tdp_mmu_pages_lock);
        else
                lockdep_assert_held_write(&kvm->mmu_lock);

        list_del(&sp->link);  <=3D here
        if (sp->lpage_disallowed)
                unaccount_huge_nx_page(kvm, sp);

        if (shared)
                spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  }

  static inline void list_del(struct list_head *entry)
  {
        __list_del_entry(entry);
        entry->next =3D LIST_POISON1;  <=3D last instruction in the code st=
ream
        entry->prev =3D LIST_POISON2;
  }

The +0x8 means the write to next->prev is failing, i.e. RDX =3D=3D sp->list=
.next
and
RAX =3D=3D sp.list->prev, which provides a big smoking gun because both RAX=
 and RDX
are 0, i.e. both next and prev are NULL.

  static inline void __list_del_entry(struct list_head *entry)
  {
        if (!__list_del_entry_valid(entry))
                return;

        __list_del(entry->prev, entry->next);
  }

  static inline void __list_del(struct list_head * prev, struct list_head *
next)
  {
        next->prev =3D prev;  <=3D effectively the faulting instruction
        WRITE_ONCE(prev->next, next);
  }

That means the issue is that KVM is observing a present SPTE whose sp->list=
 is
uninitialized (well, zero-initialized), i.e. a shadow page that has been
installed
in KVM's page tables but not added to the list of a shadow pages.

Lo and behold, in v5.15 kvm_tdp_mmu_map() sets the SPTE before linking the
shadow
page:

                        if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm,
&iter, new_spte)) {
                                tdp_mmu_link_page(vcpu->kvm, sp,
                                                  huge_page_disallowed &&
                                                  req_level >=3D iter.level=
);

                                trace_kvm_mmu_get_page(sp, true);
                        }


  static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
                              bool account_nx)
  {
        spin_lock(&kvm->arch.tdp_mmu_pages_lock);
        list_add(&sp->link, &kvm->arch.tdp_mmu_pages);  <=3D this needs to =
happen
before the SPTE is visible
        if (account_nx)
                account_huge_nx_page(kvm, sp);
        spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  }

The bug is extremely difficult to hit because zapping all SPTEs doesn't hap=
pen
often, especially not when vCPUs are running.  And the problematic window is
really, really small; the zapping CPU needs to read the SPTE after its set =
by
the faulting vCPU, but then win the race to acquire
kvm->arch.tdp_mmu_pages_lock,
e.g. I wouldn't be surprised if the failures happen when the CPU that's
handling
the vCPU page fault to take an interrupt between setting the SPTE and acqui=
ring
tdp_mmu_pages_lock.

Ah, and this specific scenario is only possible due to a second bug that was
fixed
by commit a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalida=
ted
by
memslot update").  Unfortunately, that commit doesn't seem to have made its=
 way
to
v5.15 despite being tagged for stable (more than likely due to a missed
dependency).

The memslot update is supposed to make the entire paging tree
unavailable/invalid
while holding mmu_lock for write, i.e. prevent page faults from operating on
the
invalid tree, but the TDP MMU page fault handler neglected to check that the
paging
tree was fresh/valid after acquiring mmu_lock.

And as if that wasn't enough, another reason why no one has reported this
beyond
v5.15 is that commit d25ceb926436 ("KVM: x86/mmu: Track the number of TDP M=
MU
pages,
but not the actual pages") stopped tracking the list of pages, i.e. even if
this
bug can be hit in current upstream, it will manifest as a temporarily, almo=
st
imperceptibly bad tdp_mmu_pages count, not a NULL pointer deref.

This is very similar to the bug that was fixed by commit 21a36ac6b6c7 ("KVM:
x86/mmu:
Re-check under lock that TDP MMU SP hugepage is disallowed"), just with a b=
it
of
role reversal.

If you're feeling particularly masochistic, I bet you could reproduce this =
more
easily by introducing a delay between setting the SPTE and linking the page,
e.g.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c2bb60ccd88..1fb10d4156aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1071,6 +1071,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa,=
 u32
error_code,
                                                     !shadow_accessed_mask);

                        if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm,
&iter, new_spte)) {
+                               udelay(100);
                                tdp_mmu_link_page(vcpu->kvm, sp,
                                                  huge_page_disallowed &&
                                                  req_level >=3D iter.level=
);

As for a fix, for v5.15 I think the right approach is to simply disable the=
 TDP
MMU.  I was already planning on doing that to address another hard-to-backp=
ort
flaw[*], and this is pretty much the final nail in the coffin.

For upstream and 6.1 (the LTS kernels with the TDP MMU enabled), I don't th=
ink
there's anything worth fixing, though at the very least I'll add a big fat
comment
warning about the dangers of doing anything with a shadow page after it's
linked.
Strictly speaking, it's probably more correct to account the shadow page be=
fore
its
SPTE is set, and then unaccount the page in the rare scenario where setting=
 the
SPTE fails, but so long as its *just* stats accounting, nothing should brea=
k,
i.e.
the minor complexity of adding the unaccounting probably isn't worth it.

[*] https://lore.kernel.org/all/ZDmEGM+CgYpvDLh6@google.com

> [Mon Jun 12 10:50:09 UTC 2023] RSP: 0018:ffffc90029477840 EFLAGS: 00010246
> [Mon Jun 12 10:50:09 UTC 2023] RAX: 0000000000000000 RBX: ffff89581a1f6000
> RCX:
> 0000000000000000
> [Mon Jun 12 10:50:09 UTC 2023] RDX: 0000000000000000 RSI: 0000000000000002
> RDI:
> ffffc9002d858a60
> [Mon Jun 12 10:50:09 UTC 2023] RBP: 0000000000002200 R08: ffff893450426450
> R09:
> 0000000000000002
> [Mon Jun 12 10:50:09 UTC 2023] R10: 0000000000000001 R11: 0000000000000001
> R12:
> 0000000000000001
> [Mon Jun 12 10:50:09 UTC 2023] R13: 00000000000005a0 R14: ffffc9002d842000
> R15:
> ffffc9002d858a60
> [Mon Jun 12 10:50:09 UTC 2023] FS:  00007fdb6c1ff6c0(0000)
> GS:ffff89804d800000(0000) knlGS:0000000000000000
> [Mon Jun 12 10:50:09 UTC 2023] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> [Mon Jun 12 10:50:09 UTC 2023] CR2: 0000000000000008 CR3: 0000005380534005
> CR4:
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

I don't think it matters much, but the recursion on __handle_changed_spte()
means
that KVM is zapping a lower level, non-leaf SPTE.

> [Mon Jun 12 10:50:09 UTC 2023]  zap_gfn_range+0x21a/0x320
> [Mon Jun 12 10:50:09 UTC 2023]  kvm_tdp_mmu_zap_invalidated_roots+0x50/0x=
a0
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
> [Mon Jun 12 10:50:09 UTC 2023] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 =
60
> c7

...

> We've seen this issue with kernel 5.15.115, 5.15.79, some versions between
> the
> two, and probably a 5.15.4x (not sure here). At the beginning, only a few
> "identical" hosts (same hardware model) had this issue but since then we'=
ve
> also had crashes on hosts running different hardware. Unfortunately, it
> sometimes takes a  few weeks to trigger (last occurrence before this one =
was
> 2
> months ago) and we can't really think of a way to reproduce this.
>=20
> As you can see in the dmesg.log.gz file, this bug then creates soft locku=
ps
> for
> other processes, I guess because they wait for some kind of lock that nev=
er
> gets released. The host then becomes more and more unresponsive as time g=
oes
> by.

Yeah, mmu_lock is held at this time.  Any BUG() or NULL pointer deref while
holding
a spinlock is pretty much game over.  mmu_lock in particular all but guaran=
tees
a
quick death since it's so heavily used in KVM.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
