Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1F23926B5
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 07:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbhE0FDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 01:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhE0FDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 01:03:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43BC061574;
        Wed, 26 May 2021 22:02:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q67so2732282pfb.4;
        Wed, 26 May 2021 22:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JyLaYThv3NNpHzg8SQfk89DGWSaPbCfxZj9NwLUkGkc=;
        b=JniPRzLBCo1/vCFwMMamhh/yUPPMCJEiF+NF9ut+dLAonrFX/PPFbMeJFE6IvbLRai
         uiAHhTOAgIie7aKlt1G/vobcCBeEXisOn619t0xajxw+5qddHvj8+znCaSgZnqZ7VjFr
         dJ8o7DZe0XR2av6Ska+8BgQr89es+5V6Sg2rELxZY4y5r0RLX75LYs13TE5QCGiZ7vyw
         pmrLEkwVzfPxCoY/KpCOi0TWAO33VdvbvHXSj2CH0y8skLN727htkEQt8pZMkK62viO8
         p0iu7MCe7h0RlQMdzLOVQmrv4mx++G0aEz5a3UDoXpOBEkzROyJWauqv1R5/2LBh0AIw
         HPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JyLaYThv3NNpHzg8SQfk89DGWSaPbCfxZj9NwLUkGkc=;
        b=uAbZkMl4D8P7I9tYP5zqVgcj2sQoUwaaWtEJ9iA0I0B+czcWWbfNPvOXDCSB+EB22U
         90FCUYfXJeGGk7hE92TvpsDONhgneXfrWC78QWiYUoqKiEu4sjYynHBG7WumqnFtJLW0
         kMM0UmQObXxe+wkvqHDwSn5Fk9bJqmmlXDffhEoyOv6AW/eUtEawj93LbmNMeTqAmaAG
         qqT7cjWOe+EQYdMg+3lR62jjywmrCz/vjvVm+PqAO6GDxILkfe0uXD7fGymIfZweRqnV
         lRSOtFnDrQWO/8SDUJc8ddlTbzXiZLPbpqHhPtwEpPI9IhOPLGzTWeB3EN22JSmOAbq3
         CpWA==
X-Gm-Message-State: AOAM532+eK+4LBiNJw5EONNJpUW5lPpLe69vujM5Nb61XhQmb8tJ2DHG
        9S5FUbl1eoLW1EDh5yQAp4v0b+ExlxM=
X-Google-Smtp-Source: ABdhPJykSfoIMilDriJP/wgdluGR2twpNZG+C1IxxNAuGD3mkXExMbtBxK7kA2l5j9dPVbtPVyo3OA==
X-Received: by 2002:a05:6a00:2126:b029:2e2:89d8:5c89 with SMTP id n6-20020a056a002126b02902e289d85c89mr1951538pfj.37.1622091730652;
        Wed, 26 May 2021 22:02:10 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.40])
        by smtp.googlemail.com with ESMTPSA id z7sm668384pgr.28.2021.05.26.22.02.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 May 2021 22:02:10 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 1/2] KVM: X86: Fix warning caused by stale emulation context
Date:   Wed, 26 May 2021 22:01:18 -0700
Message-Id: <1622091679-31683-1-git-send-email-wanpengli@tencent.com>
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
before hardware breakpoints check.  

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000

Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * squash ctxt->ud
v1 -> v2:
 * move the second part emulation context initialization into init_emulate_ctxt()

 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04..ae47b19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7226,6 +7226,13 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
 	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
 
+	ctxt->interruptibility = 0;
+	ctxt->have_exception = false;
+	ctxt->exception.vector = -1;
+	ctxt->perm_ok = false;
+
+	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
+
 	init_decode_cache(ctxt);
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
 }
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

