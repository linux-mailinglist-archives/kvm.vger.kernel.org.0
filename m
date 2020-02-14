Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7223E15D481
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 10:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgBNJQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 04:16:39 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45022 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgBNJQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 04:16:39 -0500
Received: by mail-oi1-f193.google.com with SMTP id d62so8747075oia.11;
        Fri, 14 Feb 2020 01:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=yJIG2+5rAA/omb/XOuOyU/XY01fpqVjXiUmRI7jlVsY=;
        b=OhzdPMysleAxFIa7tsDq1Ei3imWZgu66zPkITqJATuRSJ02hM2QCWESz8Zzr2N6+Kv
         zqZQdVVuAa1ZpqS/pLAVL+Tgx6LBFzqvgP3t3ott9+2BIaR25/sW5pEpT3CWXyq8wr2o
         CWgRR/+239LizvfgZfvKDsSSS9/SRV7oytIrycLS20rD/TLNCzGB2HkjtM1/5PGhpM6G
         1H6Hu86r+oGeHLebNrDSgFJjAH7njngDfFN981JpsCl1w9A6llOhArl28ePzuKv4mFfP
         qhivzjXS/9o7xLwq0p3wlZFeUs7UPJdorISawh1e0s1cXsR1+D8Z97eeTZWswGkOmyaD
         EK4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=yJIG2+5rAA/omb/XOuOyU/XY01fpqVjXiUmRI7jlVsY=;
        b=sY0CjFqiSymf/pfc/x7RPNOi/nHr4sdKrMaRZZAjNcPAYIZ2bPQp88dAzEx91sqbCp
         zVZG9Mv8YUVZWmxaXERJvJioe32T2BQ7jlLratmYpuZ/QHLbcdRR6Ihj5Uksqg61eg1d
         QrP01tnUN8FmGru01fl09Yj0GM1N7IcoPcxJB7onwRtYEcw0ugZH4U9hAjBHG1ull8yz
         s5Y/E1Nv7L0N07mguploCi4NAGQ0GC1KnSxnqkURRSh8+PH/Aj5vlo8/JxIGa4sVU/9Y
         VsEWQIzoBwDRC8iVlBYmwsF01YItYPLtcGANAd//p1mhNyu8oH+PxJLifqqiFzfBftdR
         pnyw==
X-Gm-Message-State: APjAAAWv7kKtFDJToVe/KAHiwMYMe48l8gzQPgtHJx3+J1VIf3Jm9cZv
        GnmuzJ7S/T2j2MYkJVu5yXxWKs9S8oF2SLmoI4vW0tG0lg4=
X-Google-Smtp-Source: APXvYqy46/3PWFWzsB9YfYAq2ltYbwzagbLttlQg6ScSiwe+seEKxbquh7gEBmLKFz1xqkzDM1lIM31Q/N61CtrCeqE=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr1147247oii.141.1581671798823;
 Fri, 14 Feb 2020 01:16:38 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 14 Feb 2020 17:16:28 +0800
Message-ID: <CANRm+CznPq3LQUyiXr8nA7uP5q+d8Ud-Ki-W7vPCo_BjDJtOSw@mail.gmail.com>
Subject: [PATCH v2] KVM: X86: Grab KVM's srcu lock when accessing hv assist page
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: wanpeng li <wanpengli@tencent.com>

For the duration of mapping eVMCS, it derefences ->memslots without holding
->srcu or ->slots_lock when accessing hv assist page. This patch fixes it by
moving nested_sync_vmcs12_to_shadow to prepare_guest_switch, where the SRCU
is already taken.

It can be reproduced by running kvm's evmcs_test selftest.

  =============================
  warning: suspicious rcu usage
  5.6.0-rc1+ #53 tainted: g        w ioe
  -----------------------------
  ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

   rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by evmcs_test/8507:
   #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
kvm_vcpu_ioctl+0x85/0x680 [kvm]

  stack backtrace:
  cpu: 6 pid: 8507 comm: evmcs_test tainted: g        w ioe     5.6.0-rc1+ #53
  hardware name: dell inc. optiplex 7040/0jctf8, bios 1.4.9 09/12/2016
  call trace:
   dump_stack+0x68/0x9b
   kvm_read_guest_cached+0x11d/0x150 [kvm]
   kvm_hv_get_assist_page+0x33/0x40 [kvm]
   nested_enlightened_vmentry+0x2c/0x60 [kvm_intel]
   nested_vmx_handle_enlightened_vmptrld.part.52+0x32/0x1c0 [kvm_intel]
   nested_sync_vmcs12_to_shadow+0x439/0x680 [kvm_intel]
   vmx_vcpu_run+0x67a/0xe60 [kvm_intel]
   vcpu_enter_guest+0x35e/0x1bc0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x40b/0x670 [kvm]
   kvm_vcpu_ioctl+0x370/0x680 [kvm]
   ksys_ioctl+0x235/0x850
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x77/0x780
   entry_syscall_64_after_hwframe+0x49/0xbe

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a66648..6bd6ca4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1214,6 +1214,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)

     vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
     vmx->guest_state_loaded = true;
+
+    if (vmx->nested.need_vmcs12_to_shadow_sync)
+        nested_sync_vmcs12_to_shadow(vcpu);
 }

 static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
@@ -6480,9 +6483,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
         vmcs_write32(PLE_WINDOW, vmx->ple_window);
     }

-    if (vmx->nested.need_vmcs12_to_shadow_sync)
-        nested_sync_vmcs12_to_shadow(vcpu);
-
     if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
         vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
     if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
--
2.7.4
