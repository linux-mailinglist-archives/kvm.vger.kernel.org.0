Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2973A1D48
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhFIS73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:59:29 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:35778 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhFIS72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:28 -0400
Received: by mail-qk1-f201.google.com with SMTP id y5-20020a37af050000b02903a9c3f8b89fso17579649qke.2
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rQ5QXuNkqyOb24PESLtpS9Q1lHik0mMAFrhtFbd/4EI=;
        b=GJdCw4u45mqHEYf1omOhAERu4Utd9+Bb3FRKHQ9Xkp7T7uGPEBiqdFWc1oQA0Ki2Uu
         VL7hN0+ThJ2b6ABn77qSNdpUL8gig6xUmcYgLO7+75rsZkJDXotot27t8Re4zM1Beqg4
         M+d1EFZ6UDipyz0V4cAbNYdxje4dlmqm8m/Coio5LjXqrERfNvfCkj2P4r2MBkd8+SMX
         PgXIIhIEj6PtL+1JVYS0xrZwa/p5BVPJtjUzT/UiyVBuFDyeOeSW3LUVQ9+2bgD1PYdC
         V4S/hgcCBfQtkiKltV3q3VYl/0IFzVDR/cc/ox9/Ww+fx0UMu2J9ta6cXQeHK99bj+77
         tNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rQ5QXuNkqyOb24PESLtpS9Q1lHik0mMAFrhtFbd/4EI=;
        b=MvPaml/3fw357zBXR1SXAinoQa+v9nqfcnt/hNgT68qg66Ven8d5VxkQSo//498+IK
         Eho74Lppl2jtKRBP0zKYgAq72s0BNRidRc2xOdjVVcJoXemv0ula1Su2FseV6+9E1hHR
         IW6LZq4dRn3ghDOgARrr/dUFqtApc8vfmTIgazt8Myw+7ZcVY07SGUzT/ziLvdcpjljG
         ZGfi1qGMAjKyjDLqWV/kcZ6igLMvjaRV9PZIvgeHoMQPl54THglSAS/+oU+xdXTHr6+C
         oDfkPlNiAoVf75KDY0Muws2qFP2V1gBwtJKJ1gxhx51IimMygTOf0cn/GOxyBkfBPXPm
         neLQ==
X-Gm-Message-State: AOAM533OW+LtyTB8aZKMvgyzrbg4fteEmqGFfmnAYXJft+Cgi8y23elh
        5AG9Tm3Ss0IARL4gNSavWOZ+HKQdMtI=
X-Google-Smtp-Source: ABdhPJzcGB5CqmRJoALcEAf/0vpr4XTL5dfme2lD3KQnk+Al5NEwikoLClTIgVmu/XaxLx/fXK2Vsgwr5UQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:a0c:c68d:: with SMTP id d13mr1513817qvj.60.1623264993311;
 Wed, 09 Jun 2021 11:56:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:11 -0700
In-Reply-To: <20210609185619.992058-1-seanjc@google.com>
Message-Id: <20210609185619.992058-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210609185619.992058-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 1/9] KVM: x86: Immediately reset the MMU context when the SMM
 flag is cleared
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Immediately reset the MMU context when the vCPU's SMM flag is cleared so
that the SMM flag in the MMU role is always synchronized with the vCPU's
flag.  If RSM fails (which isn't correctly emulated), KVM will bail
without calling post_leave_smm() and leave the MMU in a bad state.

The bad MMU role can lead to a NULL pointer dereference when grabbing a
shadow page's rmap for a page fault as the initial lookups for the gfn
will happen with the vCPU's SMM flag (=0), whereas the rmap lookup will
use the shadow page's SMM flag, which comes from the MMU (=1).  SMM has
an entirely different set of memslots, and so the initial lookup can find
a memslot (SMM=0) and then explode on the rmap memslot lookup (SMM=1).

  general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  CPU: 1 PID: 8410 Comm: syz-executor382 Not tainted 5.13.0-rc5-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:__gfn_to_rmap arch/x86/kvm/mmu/mmu.c:935 [inline]
  RIP: 0010:gfn_to_rmap+0x2b0/0x4d0 arch/x86/kvm/mmu/mmu.c:947
  Code: <42> 80 3c 20 00 74 08 4c 89 ff e8 f1 79 a9 00 4c 89 fb 4d 8b 37 44
  RSP: 0018:ffffc90000ffef98 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff888015b9f414 RCX: ffff888019669c40
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
  RBP: 0000000000000001 R08: ffffffff811d9cdb R09: ffffed10065a6002
  R10: ffffed10065a6002 R11: 0000000000000000 R12: dffffc0000000000
  R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
  FS:  000000000124b300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000028e31000 CR4: 00000000001526e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   rmap_add arch/x86/kvm/mmu/mmu.c:965 [inline]
   mmu_set_spte+0x862/0xe60 arch/x86/kvm/mmu/mmu.c:2604
   __direct_map arch/x86/kvm/mmu/mmu.c:2862 [inline]
   direct_page_fault+0x1f74/0x2b70 arch/x86/kvm/mmu/mmu.c:3769
   kvm_mmu_do_page_fault arch/x86/kvm/mmu.h:124 [inline]
   kvm_mmu_page_fault+0x199/0x1440 arch/x86/kvm/mmu/mmu.c:5065
   vmx_handle_exit+0x26/0x160 arch/x86/kvm/vmx/vmx.c:6122
   vcpu_enter_guest+0x3bdd/0x9630 arch/x86/kvm/x86.c:9428
   vcpu_run+0x416/0xc20 arch/x86/kvm/x86.c:9494
   kvm_arch_vcpu_ioctl_run+0x4e8/0xa40 arch/x86/kvm/x86.c:9722
   kvm_vcpu_ioctl+0x70f/0xbb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3460
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:1069 [inline]
   __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:1055
   do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x440ce9

Reported-by: syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Fixes: 9ec19493fb86 ("KVM: x86: clear SMM flags before loading state while leaving SMM")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9dd23bdfc6cc..54d212fe9b15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7106,7 +7106,10 @@ static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
 
 static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_flags)
 {
-	emul_to_vcpu(ctxt)->arch.hflags = emul_flags;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	vcpu->arch.hflags = emul_flags;
+	kvm_mmu_reset_context(vcpu);
 }
 
 static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
-- 
2.32.0.rc1.229.g3e70b5a671-goog

