Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C15F16B4
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiI3Xgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiI3Xgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:36:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C944F1A2A03
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:36:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y16-20020a17090322d000b0017848b6f556so4116637plg.19
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=gVfWvB2FjdnkebZmvCSy6/r0IwpJ8+tJs2TrhCyJNC8=;
        b=aCTT/w5hqX9tAxkuMUupqMBYNq0rDJPdHVxiMrBkB2mLP6fu7cYTwarmvJMijXRmx3
         zdJrEffCB8IpshfCTP+5dAQ2Yb16u75WSgwCI+bfUQo4msnOhaDHOVLucPh73MI7zoBd
         CNb7kuVJeLtf8m+2c1rZXHNrfjkWbMTJxVg/JzmTuClnASkwg8PKsOLH4VOWKsOnN+WW
         wujo38iJLeXt7NECxIjCsT4PFPBRpU6h3+jwuSwTUhMukHRkzLx0XJW3KdRX1y+V/XZc
         rbxIZPpjpoY5E+yRGtH2OWXPlpAPzugVXzpRRmQYpz/G1Vj5u045PP6PQw4014VLmHcn
         Y9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gVfWvB2FjdnkebZmvCSy6/r0IwpJ8+tJs2TrhCyJNC8=;
        b=nRSgOmGIJlHgUUX+lQpQf94qtQEOXBQ31aU0GgTXDSlMGrUeuxbHZFh5+nuRzx+H2t
         JcYp7nBX5tlqeVHVfk4eUKn+6cLeY28eLM4gYDwmgTP9uLUBnQhLcsYMO/Af67V3gZ1b
         Aqrq7/fu+5wD4/rsHWgCmy1eA8BQC2q9u1Chlx79/J2lRdFLU2BAq55ldV4OhTwxHK3p
         aeIAa088USGb7kSXNUCRYB4M222O9n2ZaaHLDCfzLqchD1G8BQai8Yfy1hzjWEXOP8Z7
         6gDqg5ihMEBpXdWTWiLyLbH7Py2PV8R2l6m47vgisq5KieQp8fz63jauY/u63YLGR0e1
         IIMQ==
X-Gm-Message-State: ACrzQf1AxFbY8yBEt/OGQf41tkvBOTtUYQhAAOTgfnS3gLrttAZf3kpk
        10EkMn72T2y4J+PM954WvYqObciCCc4=
X-Google-Smtp-Source: AMsMyM7nAOeN2Lp5+W9HbfBf7P6OMe71JDRP8C7zHvMKDcMbFBe3oMFWpkNlnZZZuvSqWPCkp9yGmuiLgVE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7b87:b0:179:ec0a:7239 with SMTP id
 w7-20020a1709027b8700b00179ec0a7239mr11684736pll.139.1664580994389; Fri, 30
 Sep 2022 16:36:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:36:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930233632.1725475-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat any exception during instruction decode for EMULTYPE_SKIP as a
"full" emulation failure, i.e. signal failure instead of queuing the
exception.  When decoding purely to skip an instruction, KVM and/or the
CPU has already done some amount of emulation that cannot be unwound,
e.g. on an EPT misconfig VM-Exit KVM has already processeed the emulated
MMIO.  KVM already does this if a #UD is encountered, but not for other
exceptions, e.g. if a #PF is encountered during fetch.

In SVM's soft-injection use case, queueing the exception is particularly
problematic as queueing exceptions while injecting events can put KVM
into an infinite loop due to bailing from VM-Enter to service the newly
pending exception.  E.g. multiple warnings to detect such behavior fire:

  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 1017 at arch/x86/kvm/x86.c:9873 kvm_arch_vcpu_ioctl_run+0x1de5/0x20a0 [kvm]
  Modules linked in: kvm_amd ccp kvm irqbypass
  CPU: 3 PID: 1017 Comm: svm_nested_soft Not tainted 6.0.0-rc1+ #220
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_arch_vcpu_ioctl_run+0x1de5/0x20a0 [kvm]
  Call Trace:
   kvm_vcpu_ioctl+0x223/0x6d0 [kvm]
   __x64_sys_ioctl+0x85/0xc0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  ---[ end trace 0000000000000000 ]---
  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 1017 at arch/x86/kvm/x86.c:9987 kvm_arch_vcpu_ioctl_run+0x12a3/0x20a0 [kvm]
  Modules linked in: kvm_amd ccp kvm irqbypass
  CPU: 3 PID: 1017 Comm: svm_nested_soft Tainted: G        W          6.0.0-rc1+ #220
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_arch_vcpu_ioctl_run+0x12a3/0x20a0 [kvm]
  Call Trace:
   kvm_vcpu_ioctl+0x223/0x6d0 [kvm]
   __x64_sys_ioctl+0x85/0xc0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  ---[ end trace 0000000000000000 ]---

Fixes: 6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb9d2c23fb04..f0c8a30d9e16 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8768,7 +8768,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 						  write_fault_to_spt,
 						  emulation_type))
 				return 1;
-			if (ctxt->have_exception) {
+
+			if (ctxt->have_exception &&
+			    !(emulation_type & EMULTYPE_SKIP)) {
 				/*
 				 * #UD should result in just EMULATION_FAILED, and trap-like
 				 * exception should not be encountered during decode.

base-commit: c59fb127583869350256656b7ed848c398bef879
-- 
2.38.0.rc1.362.ged0d419d3c-goog

