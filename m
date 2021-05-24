Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802B338E060
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 06:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhEXEiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 00:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhEXEiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 00:38:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7184C061574;
        Sun, 23 May 2021 21:36:47 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v13so13978728ple.9;
        Sun, 23 May 2021 21:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CFKj4h8D3vKVsrArxInuoUkH3K47MAPJEo/4ElSezfw=;
        b=suelYebOlkPxLUkUTCooa0nu2Vbc9auUsC0ZpGyRD7QqJCvRFdyVW/w4mVNVNPt5nh
         INTH9AivNniMLt/7OeOVaz39skE253KoNrvaNG76w0EYBVCjpkU4b3boQdlKbiyIjjyc
         4smb0q25DNDaEEnnkVCIa0YpeqNJdWaDsCAtj7LzS4OcffH5eeCvRddqgld/RcTUCUX0
         nBbnO2919hAuvhh+fA295dm8AlTInxsN61FjykuQ04Oi92fGD6gQJMWXYvdZ/tKD+YRn
         jpf18KTH6azSK+z3L52gIricwlxHYAqFIBTDWUByKkBs82Fqf4UCeg3Ftw4YR/sw2OnU
         AwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CFKj4h8D3vKVsrArxInuoUkH3K47MAPJEo/4ElSezfw=;
        b=Pk7vPBusOas1OOvrP9+LPx8HL2l+9l25fxDFUGsP615rNdfyZL4Rm5PopwVIiP2VAG
         zN9tG2eT9zALg1aWSJxjqY1GyJ3RVE/FkVxxWptcxsWNHbyGvxq6B1HQQFycpm6n4lLg
         mA8JYVdxdqjuMr6voZfXZQKiK9ZRZ+5xOIK7clLdjGT4VOTtqKYYHwY8QaNyfc75kKg5
         oPGlGUIuk7ToW/+OrOyTgnFuULgrsWgMM9tG8z0oih6E3TzlaQtV/TV5MwrAxnf+dPoP
         MHwOr4XhRh76BfmLy5nq82WZnsAiQ4EHElapXlctMKVwkixoftfSzaotCnqZ59YHPcsr
         eKOw==
X-Gm-Message-State: AOAM531XsG9Ivd/Q1ZhE6+IeWsl5LviN/SRn+10iWuHSskrBcQ63fh78
        FAZYb1BypcynX2IoA7MS/hGosBTf9FA=
X-Google-Smtp-Source: ABdhPJx78sbuuA0VTuQzKqWGNB/d5u4f4KcVr41uLsV7Gks8DRu+CWNOCDsLH9QN+BAsYtAqwTDJHA==
X-Received: by 2002:a17:90a:9517:: with SMTP id t23mr22396886pjo.130.1621831007083;
        Sun, 23 May 2021 21:36:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id cc2sm8884703pjb.39.2021.05.23.21.36.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 May 2021 21:36:46 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Fix warning caused by stale emulation context
Date:   Sun, 23 May 2021 21:35:54 -0700
Message-Id: <1621830954-31963-1-git-send-email-wanpengli@tencent.com>
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
emulation context initialization, actually we don't have EMULTYPE_NO_DECODE flag 
here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86: 
set ctxt->have_exception in x86_decode_insn()) triggers the warning because it 
catches the stale emulation context has #UD, however, it is not during instruction 
decoding which should result in EMULATION_FAILED. This patch fixes it by moving 
the second part emulation context initialization before hardware breakpoints check.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000

Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04..eca69f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7552,6 +7552,13 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 
 	init_emulate_ctxt(vcpu);
 
+	ctxt->interruptibility = 0;
+	ctxt->have_exception = false;
+	ctxt->exception.vector = -1;
+	ctxt->perm_ok = false;
+
+	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
+
 	/*
 	 * We will reenter on the same instruction since we do not set
 	 * complete_userspace_io. This does not handle watchpoints yet,
@@ -7561,13 +7568,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
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

