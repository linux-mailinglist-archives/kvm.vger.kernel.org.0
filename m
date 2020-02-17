Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7953F161035
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 11:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgBQKhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 05:37:55 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43766 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgBQKhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 05:37:55 -0500
Received: by mail-oi1-f194.google.com with SMTP id p125so16209610oif.10;
        Mon, 17 Feb 2020 02:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=k8BSp0O0KfBeVprk778t84qb07TP/hfwso06rDN0yGc=;
        b=XltBufQfP7wpwCaNj3e2sGKjeJdqeCFagWjLEArZeghTwlgQn7jnZ/rCVwGXc+spcI
         GPND8ggd8u9g3YV/+UTlF28LLPC7SJXtT6k3e54xDfkWHJMcqJkzxpIAY0PeoIVvOjsD
         3F42Be7kyt/JCWZ5oF/8cJofMIJwXPgLAfv4oNCixaLgbCjwq3t2HoGyFmtoSq3Ua4vJ
         wN1BGhcyrqivi+J9AdRuHJNe3fEvUMBqLyK9u1PrgbOPH1z6ozTSZ7VJVkKNby57b8EM
         5KrPb5MaPkfT5H336GfRnPEZx+r0nXv8Bd8Jr+kbJ6ZL7uAsTIIDpKpYXAp8xHRzzTsM
         1O7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=k8BSp0O0KfBeVprk778t84qb07TP/hfwso06rDN0yGc=;
        b=SMOzQqIfub+NHS5fSuiwWrv2J9pb6/DVYDBzt/tdR6BwmyIXMT9IzGueP8/sXujdfM
         VdLDjCA9qeW6/ZEarb3SDudL+RPEdPAJF56mGfvRssNctkf03RjvoDu7xaGskc6fKx5j
         BxGsUPZMjqjScG3gPwURqtxI5YUtTVPDW235B+SvsFBn08J5fRqagTlYyoRpOhPPX/oo
         +1DxpUtCycBn58kEL8VV4VcOsXu2/Fbc7kuWLqGNBdHLri+D50VCJaedwC+MG4mQv3Bs
         eT+CHn+9yO4JnLRliCvyYtP6rTpI8Eao9u1XODyccNc1PCo3B+YC5R8c7tOz5apiEngg
         1oPQ==
X-Gm-Message-State: APjAAAXRiisXytfZ6JhSuakkTnBqFjc+/wJlLUqXpxEzz012Xog0K09c
        3BT6Cvab1Zsmx8wH4LH3JxYsGYvs912JpC5y0RRGwFj47xEbIQ==
X-Google-Smtp-Source: APXvYqxDjBYcTjQcr5nocEiOj7Htq4tDWpJtbNMIsIoV6egKz/W1ZjwiadRqjn1/jSJ5/DdLuvCwUa09BsVcra6xkbo=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr9150053oii.141.1581935873942;
 Mon, 17 Feb 2020 02:37:53 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 Feb 2020 18:37:43 +0800
Message-ID: <CANRm+Cx2ifbbQWk0yAm=W5Us69GybSdtO8uLYXx-qe9F=jNeeQ@mail.gmail.com>
Subject: [PATCH v3 2/2] KVM: nVMX: Hold KVM's srcu lock when syncing vmcs12->shadow
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
v1 -> v2:
 * update Subject
 * move the check above
 * add the WARN_ON_ONCE

 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3be25ec..9a6797f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1175,6 +1175,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
                        vmx->guest_msrs[i].mask);

     }
+
+    if (vmx->nested.need_vmcs12_to_shadow_sync)
+        nested_sync_vmcs12_to_shadow(vcpu);
+
     if (vmx->guest_state_loaded)
         return;

@@ -6482,8 +6486,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
         vmcs_write32(PLE_WINDOW, vmx->ple_window);
     }

-    if (vmx->nested.need_vmcs12_to_shadow_sync)
-        nested_sync_vmcs12_to_shadow(vcpu);
+    WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);

     if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
         vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
--
2.7.4
