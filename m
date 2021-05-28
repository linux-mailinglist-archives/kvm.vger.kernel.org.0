Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E6F3939F3
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 02:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhE1AEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 20:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbhE1AEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 20:04:05 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC675C061574;
        Thu, 27 May 2021 17:02:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f8so1539776pjh.0;
        Thu, 27 May 2021 17:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NrZavczs0MF8tqdeaU/rr2uBfm1FCnanDV4vtlGL8eQ=;
        b=BGP08nCqsa2o3kZ9ZJeK95PtCPZwmjIlwuRj/1GAbtQ9m4JMjbAFHpv1b+nw1LZYfg
         7lDBGS9RdNenHYktTGzz+cJsGKrcReYpj+dGcXgmXoDfq/WVXt/A1jlAFC0rZO1nZf8a
         zfio6Q18LToGNbzBAc1tt8gpmTgQAmkHLJV9l5L+lMHDKejr1HvqZmcEnyz/QAbt8ovc
         5EP4cWIUUa1xPnsM4Q+sejEdr0ec1Ar6YtQoY9kalwzdt1QuDJXafnv8U+yWFAzyG/P1
         +mu0wTMYxxr9erWga4Efd/AxH3MPUnSGIxtrwKhOoMfiiJaszekCKoBxIrrh+q3DesM0
         cPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NrZavczs0MF8tqdeaU/rr2uBfm1FCnanDV4vtlGL8eQ=;
        b=ZOCT935RchZNzEVfGcbbrDfA5ETogpQQug7ifQp5egdeFGRDJISlZ+u1wnJu1/2WxM
         vk9rNLbtFNWn6w+p6/Nv/rdkWPmzaaCqzYmxJxzXqEOlxME7uzb2ssCHBhmhJRT9z6yr
         jwNzneiHajuih1eX1J2iXpmyorLoFYuJRc5XNW/PgZnE3AC7UH6TcxPyMq39IzsGXNOa
         78OTfagVBhWPVMGE4pZ1qDUd2KReZSWfRHcVnr70BzIzFyYq6UPz4nbzfXKhIAvdAwfe
         UjwuDNbScRPs4D5EWP0TAi7bb0Tb/+2RJKhbDkswxfJFfFpSZ/+1VwnSJnDifAM63ebA
         BX6A==
X-Gm-Message-State: AOAM530FlZGU++IT0YGo6xar10HWKjIdDVwXbhqRJxDYhouxFeLbYsJ9
        pjWz0em4B95NlOO0PPzBG0A5SUdCjCw=
X-Google-Smtp-Source: ABdhPJylwVntfhyEImkOcMhIXJJySVS5uZe3jihEgU3SrdOXEH8ipfurtx5JzV+a8xDLMsGEUd/PSQ==
X-Received: by 2002:a17:902:265:b029:fa:9420:d2fd with SMTP id 92-20020a1709020265b02900fa9420d2fdmr5462176plc.39.1622160148947;
        Thu, 27 May 2021 17:02:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.googlemail.com with ESMTPSA id l126sm2726245pga.41.2021.05.27.17.02.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 May 2021 17:02:28 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4 1/2] KVM: X86: Fix warning caused by stale emulation context
Date:   Thu, 27 May 2021 17:01:36 -0700
Message-Id: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

  WARNING: CPU: 7 PID: 10526 at linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
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

Commit 4a1e10d5b5d8 ("KVM: x86: handle hardware breakpoints during emulation())
adds hardware breakpoints check before emulation the instruction and parts of 
emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag 
here and the emulation context will not be reused. Commit c8848cee74ff ("KVM: x86:
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
v3 -> v4:
 * warning relative path
 * not move ctxt->ud
v2 -> v3:
 * squash ctxt->ud
v1 -> v2:
 * move the second part emulation context initialization into init_emulate_ctxt()

 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04..dba8077 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7226,6 +7226,11 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
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
@@ -7561,11 +7566,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	    kvm_vcpu_check_breakpoint(vcpu, &r))
 		return r;
 
-	ctxt->interruptibility = 0;
-	ctxt->have_exception = false;
-	ctxt->exception.vector = -1;
-	ctxt->perm_ok = false;
-
 	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
 
 	r = x86_decode_insn(ctxt, insn, insn_len);
-- 
2.7.4

