Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F14E75D574
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjGUUTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjGUUTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFEB359C
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d05e334f436so989590276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970743; x=1690575543;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLZ3+zgUAeppnqgY3n6NxTe9LV814vORREjktc5U/Sw=;
        b=hCkJqAtatAST2xTcK9UF+vly76nRQ59L6L1wCKwbjhtj7w4tNGhHjPBovelEM2+gK5
         lxg4bB9LV+ax71npRTttA7ak1EpyyL8oqv8ER274jfu5H+tSGhzdtdAMP/jUzTun9FhX
         xqmozPodAe2V1GPggNtO9OU4tel859UGjBVFVOXeBKO7viKomIxtFIkMGEMzRVhN9bx8
         fmGiP67UFWdVuLym+YVIi+CRQEiL+xOfzhtec91jVP/W7oszjr+kqOCgnkNwD4rOm8Ar
         6BIkm9IWEaQ+i9nqsAGhRwAurvTHhIw3HgXS2QWQC0S8On8G1FlGlOoIHD1+S7zHoMUE
         Oumg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970743; x=1690575543;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rLZ3+zgUAeppnqgY3n6NxTe9LV814vORREjktc5U/Sw=;
        b=gPRiBJBlderJg3/ShIbpN8lCGb9nOgR6URO5v5Sv1BsZDp8TxyXAEbkbWwc30IqkOj
         M7+0JjbWnqR30SW0H8Fms/3/pZ01lc8gq0wxu3sspnkdBoDrkRXmQkidrVRzFWgM/AfH
         GQBI/GKIGaRHOXU01sBgIiNgOQr6i5NrMHyPej0d67jnFZDJRVMXVNEv21xkNAlAY/Of
         bXVpJNyC/pRRKKZAycHEv5zwFASpE0SRbfktdS5UKSaYBiP4dpxEQlVyOOfGNUekecuG
         8UwOrP6/O9hRRg0Qqc4AXCFObtSOjB9AV2Y3nh8i5ZnoqN/iRR7NssCcUyVQXdtdwh9O
         qUdw==
X-Gm-Message-State: ABy/qLYJ83oiZiG9/euJfX6ypiPGTpSrC6R7fedVpEL2WsxtAiv+ecE5
        hGvGNyu+JWrWWnqB7hqtinw99XoeMVc=
X-Google-Smtp-Source: APBJJlEMevAHotcBOZHYg9Sd6IaWSXrnx1OUggrP2dlEo2/7poLQt+F7AoxS9ZkZBN8T5H6DPt0gBycHwUE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:cf2:ad45:2084 with SMTP id
 w15-20020a056902100f00b00cf2ad452084mr17704ybt.12.1689970743354; Fri, 21 Jul
 2023 13:19:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:40 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-1-seanjc@google.com>
Subject: [PATCH v4 00/19] x86/reboot: KVM: Clean up "emergency" virt code
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If there are no objections, my plan is to take this through the KVM tree
for 6.6.

Instead of having the reboot code blindly try to disable virtualization
during an emergency, use the existing callback into KVM to disable virt
as "needed".  In quotes because KVM still somewhat blindly attempts to
disable virt, e.g. if KVM is loaded but doesn't have active VMs and thus
hasn't enabled hardware.  That could theoretically be "fixed", but due to
the callback being invoked from NMI context, I'm not convinced it would
be worth the complexity.  E.g. false positives would still be possible,
and KVM would have to play games with the per-CPU hardware_enabled flag
to ensure there are no false negatives.

The callback is currently used only to VMCLEAR the per-CPU list of VMCSes,
but not using the callback to disable virt isn't intentional.  Arguably, a
callback should have been used in the initial "disable virt" code added by
commit d176720d34c7 ("x86: disable VMX on all CPUs on reboot").  And the
kexec logic added (much later) by commit f23d1f4a1160 ("x86/kexec: VMCLEAR
VMCSs loaded on all cpus if necessary") simply missed the opportunity to
use the callback for all virtualization needs.

Once KVM handles disabling virt, move all of the helpers provided by
virtext.h into KVM proper.

There's one outlier patch, "Make KVM_AMD depend on CPU_SUP_AMD or
CPU_SUP_HYGON", that I included here because it felt weird to pull in the
"must be AMD or Hygon" check without KVM demanding that at build time.

v4: 
 - Collect reviews. [Kai]
 - Skip VMCLEAR during reboot if CR4.VMXE=0. [Kai]
 - Call out that disabling virtualization iff there's a callback also
   avoids an unnecessary NMI shootdown. [Kai]
 - Move "Disable virtualization during reboot iff callback is
   registered" patch after "Hoist "disable virt" helpers above \"emergency
   reboot\"" patch to fix an intermediate build error.

v3:
 - https://lore.kernel.org/all/20230512235026.808058-1-seanjc@google.com
 - Massage changelogs to avoid talking about out-of-tree hypervisors. [Kai]
 - Move #ifdef "KVM" addition later. [Kai]

v2:
 - https://lore.kernel.org/all/20230310214232.806108-1-seanjc@google.com
 - Disable task migration when probing basic SVM and VMX support to avoid
   logging misleading info (wrong CPU) if probing fails.

v1: https://lore.kernel.org/all/20221201232655.290720-1-seanjc@google.com

Sean Christopherson (19):
  x86/reboot: VMCLEAR active VMCSes before emergency reboot
  x86/reboot: Harden virtualization hooks for emergency reboot
  x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
  x86/reboot: KVM: Disable SVM during reboot via virt/KVM reboot
    callback
  x86/reboot: Assert that IRQs are disabled when turning off
    virtualization
  x86/reboot: Hoist "disable virt" helpers above "emergency reboot" path
  x86/reboot: Disable virtualization during reboot iff callback is
    registered
  x86/reboot: Expose VMCS crash hooks if and only if KVM_{INTEL,AMD} is
    enabled
  x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
  x86/virt: KVM: Move VMXOFF helpers into KVM VMX
  KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
  x86/virt: Drop unnecessary check on extended CPUID level in
    cpu_has_svm()
  x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
  KVM: SVM: Check that the current CPU supports SVM in
    kvm_is_svm_supported()
  KVM: VMX: Ensure CPU is stable when probing basic VMX support
  x86/virt: KVM: Move "disable SVM" helper into KVM SVM
  KVM: x86: Force kvm_rebooting=true during emergency reboot/crash
  KVM: SVM: Use "standard" stgi() helper when disabling SVM
  KVM: VMX: Skip VMCLEAR logic during emergency reboots if CR4.VMXE=0

 arch/x86/include/asm/kexec.h   |   2 -
 arch/x86/include/asm/reboot.h  |   7 ++
 arch/x86/include/asm/virtext.h | 154 ---------------------------------
 arch/x86/kernel/crash.c        |  31 -------
 arch/x86/kernel/reboot.c       |  66 ++++++++++----
 arch/x86/kvm/Kconfig           |   2 +-
 arch/x86/kvm/svm/svm.c         |  71 ++++++++++++---
 arch/x86/kvm/vmx/vmx.c         |  76 ++++++++++++----
 8 files changed, 176 insertions(+), 233 deletions(-)
 delete mode 100644 arch/x86/include/asm/virtext.h


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

