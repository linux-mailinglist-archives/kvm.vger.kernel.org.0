Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53CA7161E75
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRBTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 20:19:38 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35678 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgBRBTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:19:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id y73so9791415pfg.2;
        Mon, 17 Feb 2020 17:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uAFuTDTSBh5DgAHzrivMQNHJeAZwyWRUw0tzZPnJB70=;
        b=kxHMSvgYBck1aHGVwUoliWOhkqU+F3fuoDRzPCkuO6pYEx1nTJuOnFuo3PA6okf3ex
         VwEYP9tTVXJS4aa5sF4XJYMuZGgNAzoOQIaUPKPHLLZiVBVrd92peGzywkEZfA4r/6k3
         s4/2tJJLPUb4D4CuEzavW/e2l++Ayc5cQxxU8lSJjGcsLkv7GXlRP4BJppmeRKrTeFwv
         xgGXb/G00EERo43Evw/CftFLtVmmNmOGlW20rNSUUsF/On3SXJFzOb1dwgBQJGZgYMNA
         G2tnRnH3FCjaTCMcS15zEV8s0JEvXj5x313Yitovx03QW4Lpx0HZO4zJVLngdDMjVVXQ
         uuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uAFuTDTSBh5DgAHzrivMQNHJeAZwyWRUw0tzZPnJB70=;
        b=bW2KYEYLk14JsaJBFa6Kbm2qW5nf01fSEvwP1sqJykIxk2VKAr8bsYiSxLqCyn7HWF
         CRQ+8Uh6MMV7WMlqSHAitloD/hJsWTlgyI3GUGA7LV8GonJFQqqe55lMAK6bRkjHZ8vD
         g/At/Mt5ww/aOZklD0sR46bo0VcNO8gLFbbfRl257gtexdOrjI/Bp3SmLBX63rd3zXWW
         apRkwKjbrW91E1x6jXaimRRKpUks+iV+Zjusbi4jns+7D55LeTrFNNexqmCpIVNyld4u
         Z4vv3IlRYsUF2m5e3PrZ72TiiZ57DKiRLUca8jG6/7d4oPrs1tunp+UWqDOP34xcZ1yf
         EOGA==
X-Gm-Message-State: APjAAAWT0znlVOaJKXI1Vk+CBvZ6EiH6C5S7vuo6V/zoNLizHaOGRyeE
        Sxr7qz44saG3j3st82JVxlP7S+55H/LFGw==
X-Google-Smtp-Source: APXvYqww4cNatnKwY4zaD9Vx/A6THgqmaEck9Z0vbx3g47ErbE9U+rQiWgGNZ3iwQsf5Q5X4Q+aK7Q==
X-Received: by 2002:a63:7c16:: with SMTP id x22mr20473660pgc.335.1581988777811;
        Mon, 17 Feb 2020 17:19:37 -0800 (PST)
Received: from kernel.DHCP ([120.244.140.205])
        by smtp.googlemail.com with ESMTPSA id g13sm1519511pfo.169.2020.02.17.17.19.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Feb 2020 17:19:37 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND v4 2/2] KVM: nVMX: Hold KVM's srcu lock when syncing vmcs12->shadow
Date:   Tue, 18 Feb 2020 09:17:10 +0800
Message-Id: <1581988630-19182-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
References: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
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
   #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x85/0x680 [kvm]
 
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
v2 -> v3:
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
+	if (vmx->nested.need_vmcs12_to_shadow_sync)
+		nested_sync_vmcs12_to_shadow(vcpu);
+
 	if (vmx->guest_state_loaded)
 		return;
 
@@ -6482,8 +6486,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
 	}
 
-	if (vmx->nested.need_vmcs12_to_shadow_sync)
-		nested_sync_vmcs12_to_shadow(vcpu);
+	WARN_ON_ONCE(vmx->nested.need_vmcs12_to_shadow_sync);
 
 	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
-- 
2.7.4

