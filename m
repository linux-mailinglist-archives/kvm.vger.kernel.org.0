Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B0046C3A5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhLGTdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbhLGTdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:33:43 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C158C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 11:30:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x3-20020a17090a1f8300b001a285b9f2cbso164859pja.6
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oyI2WSVLHDViqlimDKRfedAw+de5rzSnB6vl6S3SU3I=;
        b=ed8iTJZulTHBErT0br6eyhGKhqdUr/VE6unIZM70pJgfm0EKKW4cCHK4kyRBY4+23i
         5RAj/KJzo7p7xB7YmrbBmhVP+hwKrycz0Lfug6vJZdjXSbMtxr7FxdCXgRL0lNDxsQ8x
         Gzj1Mwb4MA2JXF0T2QvBZf1rKQZY1YhSZWjLifN67egDiGakmwXZV4nEJUeAI3nfhILL
         vUQmS9Y+Yr1cB4Y37rJX3SYRNljjmk14nnocUmpZ0PVTTXGusSeAJtHLlJN46giEfDHY
         Msxf4WRNflE4FxJP++xS++5X2BGtSZ4IgnnBE0MCN1kcnEKlsOHQB1wey1lTMIU23clB
         DwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oyI2WSVLHDViqlimDKRfedAw+de5rzSnB6vl6S3SU3I=;
        b=tHtRK6RhsMwXtdIIacm6x313SwfNnsktNko1LTKrBQs3DvDcvifk1x18gYhngCue8t
         C5vp4ld8Md3qsV/jeRqYme1HmmbfuJZfXQtw9nZoMsBllkiS+LU68aA5AuluVOKKuOWj
         pPdYqqsEIe/rpjf1tRw1TiSZ0z0Z7wpZL9eJs+kxcuouFdfyL+6VGkIn49GD3vJnUfFY
         Hu63T2dKwJ4lN+3ifauYIUwrMMHrA/BXP8whdgFxNuE0LktJv9uoMrHAwNFjWwHZ5SeD
         mdb4AWImNRpFGdLyMqNnl/G1PMRjVqAdUuwNMvlxTbxaVvuUR9Xop3Es5aVQ/S/Vw7TW
         Q6yw==
X-Gm-Message-State: AOAM530ID1vprthjDW+VSACKN6oDgchc8yEmvIAOqBhtitVso3YkMr2r
        NrVRsmwDNtwCyPHZe1ZEaeH1dMlVuaU=
X-Google-Smtp-Source: ABdhPJwRXMY9yY70Aq6t6qrXTwa9RIAU9GVsLEcRLXmI6FlCjLqYM4qMaH3hEK+FarrsOE14+UEsAnptM5g=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8cd:b0:4a2:82d7:1703 with SMTP id
 s13-20020a056a0008cd00b004a282d71703mr1027480pfu.43.1638905412110; Tue, 07
 Dec 2021 11:30:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 19:30:03 +0000
In-Reply-To: <20211207193006.120997-1-seanjc@google.com>
Message-Id: <20211207193006.120997-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211207193006.120997-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 1/4] KVM: VMX: Always clear vmx->fail on emulation_required
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert a relatively recent change that set vmx->fail if the vCPU is in L2
and emulation_required is true, as that behavior is completely bogus.
Setting vmx->fail and synthesizing a VM-Exit is contradictory and wrong:

  (a) it's impossible to have both a VM-Fail and VM-Exit
  (b) vmcs.EXIT_REASON is not modified on VM-Fail
  (c) emulation_required refers to guest state and guest state checks are
      always VM-Exits, not VM-Fails.

For KVM specifically, emulation_required is handled before nested exits
in __vmx_handle_exit(), thus setting vmx->fail has no immediate effect,
i.e. KVM calls into handle_invalid_guest_state() and vmx->fail is ignored.
Setting vmx->fail can ultimately result in a WARN in nested_vmx_vmexit()
firing when tearing down the VM as KVM never expects vmx->fail to be set
when L2 is active, KVM always reflects those errors into L1.

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 21158 at arch/x86/kvm/vmx/nested.c:4548
                                nested_vmx_vmexit+0x16bd/0x17e0
                                arch/x86/kvm/vmx/nested.c:4547
  Modules linked in:
  CPU: 0 PID: 21158 Comm: syz-executor.1 Not tainted 5.16.0-rc3-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
  Code: <0f> 0b e9 2e f8 ff ff e8 57 b3 5d 00 0f 0b e9 00 f1 ff ff 89 e9 80
  Call Trace:
   vmx_leave_nested arch/x86/kvm/vmx/nested.c:6220 [inline]
   nested_vmx_free_vcpu+0x83/0xc0 arch/x86/kvm/vmx/nested.c:330
   vmx_free_vcpu+0x11f/0x2a0 arch/x86/kvm/vmx/vmx.c:6799
   kvm_arch_vcpu_destroy+0x6b/0x240 arch/x86/kvm/x86.c:10989
   kvm_vcpu_destroy+0x29/0x90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:441
   kvm_free_vcpus arch/x86/kvm/x86.c:11426 [inline]
   kvm_arch_destroy_vm+0x3ef/0x6b0 arch/x86/kvm/x86.c:11545
   kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1189 [inline]
   kvm_put_kvm+0x751/0xe40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220
   kvm_vcpu_release+0x53/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3489
   __fput+0x3fc/0x870 fs/file_table.c:280
   task_work_run+0x146/0x1c0 kernel/task_work.c:164
   exit_task_work include/linux/task_work.h:32 [inline]
   do_exit+0x705/0x24f0 kernel/exit.c:832
   do_group_exit+0x168/0x2d0 kernel/exit.c:929
   get_signal+0x1740/0x2120 kernel/signal.c:2852
   arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
   handle_signal_work kernel/entry/common.c:148 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
   exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
   syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
   do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c8607e4a086f ("KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry")
Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index efcc5a58abbc..9e415e5a91ab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6631,9 +6631,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * consistency check VM-Exit due to invalid guest state and bail.
 	 */
 	if (unlikely(vmx->emulation_required)) {
-
-		/* We don't emulate invalid state of a nested guest */
-		vmx->fail = is_guest_mode(vcpu);
+		vmx->fail = 0;
 
 		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
 		vmx->exit_reason.failed_vmentry = 1;
-- 
2.34.1.400.ga245620fadb-goog

