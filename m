Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B949F447F99
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbhKHMqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbhKHMqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:46:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF92C061570;
        Mon,  8 Nov 2021 04:44:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gt5so8023033pjb.1;
        Mon, 08 Nov 2021 04:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6M0RkOk/82BO9knFnvt8gtDKm672HeWzn+RN+e8CRc=;
        b=pfQlS2lOpkBzJN5Hxe5dHPQlKfwVMeG829fBdHbNNuQ5A97Rn/H8PifWWg4yRcqKrz
         6hMpZeXuWboeVFCxdT/YmFzv/QN7WtBBU0ufPQXjik9i3DiLpvOhK4wDdhm0vxF/F4FX
         WcWs9oxntHjhPYfVmPoEB1VUu2FJEty7oDQWw+0YcjN5We6AHfPQomEMPqIrhPrBkU/+
         i+mLhXygJcdgW+DGYGNOQ78lsARim9Ld78poboJjIJkWLz/w19gRObBloXqoKpoEu9DK
         FB0CDm3JQ7mVf1SSz8j/ysO72BKryx8yRmNcwMKNwlXpbKB2BfshuzfSBx7raSOHcK++
         RF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6M0RkOk/82BO9knFnvt8gtDKm672HeWzn+RN+e8CRc=;
        b=mB8DCJoflgfsomWZylWdLE6wD2k1Czxa/G4hD0fSykYMoi7723c5hAXATlChfvMnMU
         mC4MQVWfgv75rcf4wu9bM10xSyH92TBADxoy2l4ltlQFdfHZZJf3eUDQvyGjRlqghHNW
         7HCBarFwlDfgRx5vtouL9gKJAldxCl4Wuya0o1kVGTN9UgOyQ2bZo/oA14elFlz3GxPP
         RE6ATg3aXwDMvMDKxuUKzHvOMdy70SxdV04evlRMwvvNeA9MmPwOx/QWHkRznoNDYObl
         LtsF7pRbVhXj3U96iSGY2/48igGviCY8vVAw9z6EJVl0uDiiabs76meFQuMTww3alfHL
         bjnQ==
X-Gm-Message-State: AOAM530AYLJHdp6eLmJsJdIxT4TfnbJjT2jSdLarH9tyAj6nD39uy7wX
        kanNvveuAIruL0P3U76NFpEhXZMMSpc=
X-Google-Smtp-Source: ABdhPJzRP+/SeN3JU+VkpqYz6XKQmqCYFI7YUXhpJCaQtUadNqoZI7/y96UBIzlX74c3i+Z6WrYyzw==
X-Received: by 2002:a17:90b:4a47:: with SMTP id lb7mr46523300pjb.243.1636375446099;
        Mon, 08 Nov 2021 04:44:06 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id x20sm13134364pjp.48.2021.11.08.04.44.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:05 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 00/15] KVM: X86: Fix and clean up for register caches
Date:   Mon,  8 Nov 2021 20:43:52 +0800
Message-Id: <20211108124407.12187-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The patchset was started when I read the code of nested_svm_load_cr3()
and found that it marks CR3 available other than dirty when changing
vcpu->arch.cr3.  I thought its caller has ensured that vmcs.GUEST_CR3
will be or already be set to @cr3 so that it doesn't need to be marked
dirty.  And later I found that it is not true and it must be a bug in
a rare case before I realized that all the code just (ab)uses
vcpu->arch.regs_avail for VCPU_EXREG_CR3 and there is not such bug
of using regs_avail here.
(The above finding becomes a low meaning patch_15 rather than a fix)

The unhappyness of the reading code made me do some cleanup for
regs_avail and regs_dirty and kvm_register_xxx() functions in the hope
that the code become clearer with less misunderstanding.

Major focus was on VCPU_EXREG_CR3 and VCPU_EXREG_PDPTR.  They are
ensured to be marked the correct tags (available or dirty), and the
value is ensured to be synced to architecture before run if it is marked
dirty.

When cleaning VCPU_EXREG_PDPTR, I also checked if the corresponding
cr0/cr4 pdptr bits are all intercepted when !tdp_enabled, and I think
it is not clear enough, so X86_CR4_PDPTR_BITS is added as self-comments
in the code.

Lai Jiangshan (15):
  KVM: X86: Ensure the dirty PDPTEs to be loaded
  KVM: VMX: Mark VCPU_EXREG_PDPTR available in ept_save_pdptrs()
  KVM: SVM: Always clear available of VCPU_EXREG_PDPTR in svm_vcpu_run()
  KVM: VMX: Add and use X86_CR4_TLB_BITS when !enable_ept
  KVM: VMX: Add and use X86_CR4_PDPTR_BITS when !enable_ept
  KVM: X86: Move CR0 pdptr_bits into header file as X86_CR0_PDPTR_BITS
  KVM: SVM: Remove outdate comment in svm_load_mmu_pgd()
  KVM: SVM: Remove useless check in svm_load_mmu_pgd()
  KVM: SVM: Remove the unneeded code to mark available for CR3
  KVM: X86: Mark CR3 dirty when vcpu->arch.cr3 is changed
  KVM: VMX: Update vmcs.GUEST_CR3 only when the guest CR3 is dirty
  KVM: VMX: Reset the bits that are meaningful to be reset in
    vmx_register_cache_reset()
  KVM: SVM: Add and use svm_register_cache_reset()
  KVM: X86: Remove kvm_register_clear_available()
  KVM: nVMX: Always write vmcs.GUEST_CR3 during nested VM-Exit

 arch/x86/kvm/kvm_cache_regs.h | 13 ++++++------
 arch/x86/kvm/svm/nested.c     |  1 -
 arch/x86/kvm/svm/svm.c        | 17 ++++++++--------
 arch/x86/kvm/svm/svm.h        | 26 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c     | 30 ++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.c        | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.h        | 37 +++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c            | 13 ++++++------
 8 files changed, 101 insertions(+), 48 deletions(-)

-- 
2.19.1.6.gb485710b

