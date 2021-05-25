Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD738F874
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 05:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhEYDFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 23:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhEYDFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 23:05:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D430DC06138B;
        Mon, 24 May 2021 20:03:42 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q15so21576546pgg.12;
        Mon, 24 May 2021 20:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mQqRebMZTVl6ktNMXpc5Vi8p6ykYUYFibsRy0qZxtQM=;
        b=IbPL5TRgFAcAOOSWrZrLhbx6isrhB8d9Fphihhe3t7Pl05RrQlrdEA+qIKATTfcKGP
         AUT3F68tvxA2ZyAdIOgBxctbkem/Tm4iBlZuLkuzJWjQIFUxcGKjpMLdyUjDWXcpdAFw
         2ntzNskMUskjsOwD91JHdwP5elLNVCX2kVRv+h6Cm0KVrL9DTmAhsqjCUhFnheWl5Uj4
         tO5Sz4+2f6dNvPMHmIUzFU+J91KJYGA/FPNp7hStKSy/8Dk2hUH3xYTQQopHMiac2i0G
         XYM/wFC1pxnFWqc/GlqIeOOMUx1OGc8fHKJkIcxLsISXTSVwmwIKui/2/ACDk5xuSsSa
         YCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mQqRebMZTVl6ktNMXpc5Vi8p6ykYUYFibsRy0qZxtQM=;
        b=aKDCn2lgSyO9F6QFakIwe1e0x3fhX+N/8hKR7K6Uk6ntzIlD0ofayjxE7WgF1FB9GI
         nvLLANRTMi+UMeubOe4MH9dpMtzyEsOYMi3mXTlXnD1FlNIuV/WPoLI3mLI5aePkJm1u
         7I8s4BRnscGFUZwtpc3tOL6cps4X1NEAI5Sz11jxldZZTWxTr8FFvZXvSavffM/JRKXx
         rrDhPx1zF2yBTYNtFIJDWlzGLwEAyOd37C2uNGESSuXf4HEMwd7ejjbCIt5g8h34KMq0
         c4mOCdLrCzx+Vh7Qv0SuLRp2fAjkrsUbrHWAXrnbcb+Ca7ntbE0k7jWHoWJIWQGUHlIH
         cynw==
X-Gm-Message-State: AOAM5312IRGtmbv9/32b1+ehvumkK5HDF5y5uugYHzuL7zaeFROlFd42
        tIWirp48vJoaOOgvEKkhA/LTL6UmcUQ=
X-Google-Smtp-Source: ABdhPJztdsjuKHiXAOdhyFM2qyUcDH2Hm1ONxO49kQXnnHMd264+I6ZZV346JcBdExjTDwcklbBIIA==
X-Received: by 2002:a62:86ce:0:b029:2e0:2bb5:575b with SMTP id x197-20020a6286ce0000b02902e02bb5575bmr28074776pfd.60.1621911822121;
        Mon, 24 May 2021 20:03:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id a10sm12506217pfg.173.2021.05.24.20.03.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 May 2021 20:03:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/2] KVM: X86: Fix warning caused by stale emulation context
Date:   Mon, 24 May 2021 20:02:46 -0700
Message-Id: <1621911767-11703-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

  WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
  RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
  Call Trace:
   kvm_mmu_page_fault+0x126/0x8f0 [kvm]
   vmx_handle_exit+0x11e/0x680 [kvm_intel]
   vcpu_enter_guest+0xd95/0x1b40 [kvm]
   kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
   kvm_vcpu_ioctl+0x389/0x630 [kvm]
   __x64_sys_ioctl+0x8e/0xd0
   do_syscall_64+0x3c/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emulation())
adds hardware breakpoints check before emulation the instruction and parts of 
emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag 
here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86: 
set ctxt->have_exception in x86_decode_insn()) triggers the warning because it 
catches the stale emulation context has #UD, however, it is not during instruction 
decoding which should result in EMULATION_FAILED. This patch fixes it by moving 
the second part emulation context initialization into init_emulate_ctxt() and 
before hardware breakpoints check. The ctxt->ud will be dropped by a follow-up 
patch.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000

Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * move the second part emulation context initialization into init_emulate_ctxt()

 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bed7b53..3c109d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7228,6 +7228,11 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
 	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
 
+	ctxt->interruptibility = 0;
+	ctxt->have_exception = false;
+	ctxt->exception.vector = -1;
+	ctxt->perm_ok = false;
+
 	init_decode_cache(ctxt);
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
 }
@@ -7554,6 +7559,8 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 
 	init_emulate_ctxt(vcpu);
 
+	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
+
 	/*
 	 * We will reenter on the same instruction since we do not set
 	 * complete_userspace_io. This does not handle watchpoints yet,
@@ -7563,13 +7570,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	    kvm_vcpu_check_breakpoint(vcpu, &r))
 		return r;
 
-	ctxt->interruptibility = 0;
-	ctxt->have_exception = false;
-	ctxt->exception.vector = -1;
-	ctxt->perm_ok = false;
-
-	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
 	r = x86_decode_insn(ctxt, insn, insn_len);
 
 	trace_kvm_emulate_insn_start(vcpu);
-- 
2.7.4

