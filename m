Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9BC15D410
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 09:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgBNItx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 03:49:53 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41736 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgBNItw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 03:49:52 -0500
Received: by mail-oi1-f194.google.com with SMTP id i1so8700910oie.8;
        Fri, 14 Feb 2020 00:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=63V0t6Y+v/yU31L4w6jaW53E7T9mH+a6FE6ph40izng=;
        b=R0uUESk3MsiC5YP1WOZfAT8n+/ojmsNrrE5g7LzkcOPSJYaEUCugsokO96Hx/q6B6o
         MwOAZEg7NYg7lJk8R4UwCGC1F0jkKzSKHsDrTNn8OG7PvbXzH55heh5tugj+ynlrAHI9
         xF19P9vrVUGcS3oyXST+dOzahIUYJSRGLJ53YRaxn0/9rsX3RNgGcr6169KP78Zrmr0h
         XZB83bFxDx9gVlIp9HENGVLscimNvUi4xgVJaE5QCB2cvVnd8pGPlwq3F7D5yFpHkrFU
         XHCXuUXN5FzGRWvOOKmd13ZbhHM7dKx3zfnU3zBQQXIVQMMEJDNz8HCx/QtN2G/qh1Yv
         LRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=63V0t6Y+v/yU31L4w6jaW53E7T9mH+a6FE6ph40izng=;
        b=mudyMEcnqomqREq5yb65hLNAkV9fNDUoCMgdhDVXKRh18njPYm//gSLJpmoqFQhg+1
         +kDETo24vmKmr/Il60koo3X2NZyq5q3EIuISZsxXb5YMrvWeVrQd0/Rdaia+FxxXKUEy
         sPuDv1Xa77Lpg2ni/WIygR3Fot+JCFgGdXtXQxD70aPb+cTr/X0VoPmEZAeQOp/qxKLS
         TX5Vs/aRF7U0JWZyLKlml3rvrlQd/LR2Avl7E4Zw4i+ZVV8sxLPJslALp4ZKHUjMLLJ0
         thFYHmDTICBrMVFyzA8/TzZE7GpOq3l+Oc5yv/F72y9IlHYwRiX2Udv30NjlFZ8H8KpJ
         k4vg==
X-Gm-Message-State: APjAAAWYm3PkEFr8AKV2wLIPMiWbRbhPELHeuk6yhGtLDoNLhR6WRnRF
        ebuEBL++fK0Y0tJKapmUGGgWlrzD0neken0jTHznDCRaPjU=
X-Google-Smtp-Source: APXvYqxSR7hdkvVWpfTtP8bXIo9KPG+2Up1I5vbFN/ZlGRPnCSxrUUcnNtc2e57PBd7YJZI52LQJ6Ykx01+ilb/Fx9A=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr1088854oii.141.1581670191637;
 Fri, 14 Feb 2020 00:49:51 -0800 (PST)
MIME-Version: 1.0
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 14 Feb 2020 16:49:40 +0800
Message-ID: <CANRm+Cy5ChjkMf4k9BCnzApxvgNUFcbMSLPmvTkOkCougXF1jA@mail.gmail.com>
Subject: KVM: X86: Grab KVM's srcu lock when accessing hv assist page
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

From: Wanpeng Li <wanpengli@tencent.com>

Acquire kvm->srcu for the duration of mapping eVMCS to fix a bug where accessing
hv assist page derefences ->memslots without holding ->srcu or ->slots_lock.

It can be reproduced by running KVM's evmcs_test selftest.

  =============================
  WARNING: suspicious RCU usage
  5.6.0-rc1+ #53 Tainted: G        W IOE
  -----------------------------
  ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

   rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by evmcs_test/8507:
   #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
kvm_vcpu_ioctl+0x85/0x680 [kvm]

  stack backtrace:
  CPU: 6 PID: 8507 Comm: evmcs_test Tainted: G        W IOE     5.6.0-rc1+ #53
  Hardware name: Dell Inc. OptiPlex 7040/0JCTF8, BIOS 1.4.9 09/12/2016
  Call Trace:
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
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2ed..a68a69d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1994,14 +1994,18 @@ static int
nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
     struct vcpu_vmx *vmx = to_vmx(vcpu);
+    int idx;

     /*
      * hv_evmcs may end up being not mapped after migration (when
      * L2 was running), map it here to make sure vmcs12 changes are
      * properly reflected.
      */
-    if (vmx->nested.enlightened_vmcs_enabled && !vmx->nested.hv_evmcs)
+    if (vmx->nested.enlightened_vmcs_enabled && !vmx->nested.hv_evmcs) {
+        idx = srcu_read_lock(&vcpu->kvm->srcu);
         nested_vmx_handle_enlightened_vmptrld(vcpu, false);
+        srcu_read_unlock(&vcpu->kvm->srcu, idx);
+    }

     if (vmx->nested.hv_evmcs) {
         copy_vmcs12_to_enlightened(vmx);
--
2.7.4
