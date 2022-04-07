Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5258A4F6F23
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiDGAZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiDGAZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:25:18 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ED8118679
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:23:20 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 138-20020a621690000000b004fa807ac59aso2363731pfw.19
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KLXxiS3jUmzRDYts7zBQ1pjG5ZFNGAqc8iH0ZBirGDU=;
        b=H4RhiY9KevU3UaHgPTWQrmPT1dZQqYLKPwPGFQsNDO212Ly6rqd2HCHwr1fg3VcFV0
         ii5Z7arvm0sBsT4coOhQa6Jy1RZghAINgPOP0GKjuWW1t3rKPWXNZV6mKWw7UH5CzOGJ
         Qv3RvJp9O4PJhclF8/DHCGbmYRYj7A27of8h3UUDzoKZP52wE4OI7ThnF2Au1Ls2HDVw
         8V2qegNQy2Mgtrxk5Nild225JxHxCVtzkQJNfVMqqgKgMsT9CwKzOmQRlgbxmW0A0Ssv
         8wFqWMfjfJE4A7B5eKRz1ulOUMITnx3k8RebyzweYQq15pdMCVoDsPmE8Am7s7jXMnhm
         QhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KLXxiS3jUmzRDYts7zBQ1pjG5ZFNGAqc8iH0ZBirGDU=;
        b=FTPOKzzNaFDbselHxdzspAXH+amh6eLWtjDPQ5ty+1BA2EAhCmG6lpesUhePgSF5rH
         XFfCu9buC3asz1BZqrdFCUcfaYvxoySfccwMzLgRHFAnLXwwmot+XRcQAjwDrv7ViXX/
         9uqZkvlGVIxuH20K9JHJBMG1nvA0RaMY8mEpd5Zmgq0JR3r2A/40DwF9n/2cru62E+Ws
         3lZY0xk8IeKgVF3HAN1pY/ePahaLTzJb9kax+8ONRh7HlOTlhrWWYesVzdiP2CEvRBG0
         K+sI1SCSpVmYlwiC5Sw8EoUnAsa2RBzXLlroGYwb0SpPn2Pcel83MSXAPh8gePcEpcDr
         NqeQ==
X-Gm-Message-State: AOAM533Y55oM4bV+O3nfzU2gLGuLsQVV2jV6qa2DcuD4BRPgMjp4JS/h
        rVuag6lNSQs2l/0G9CsLDawzn4gvERg=
X-Google-Smtp-Source: ABdhPJyznrHZEljUhyEuiYDWyUIT6VTTLKoQ7H26S/hUrglXoGhhhjwKZE/SlS6Tehm7/A6hdO/hMnLvtFg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1946:b0:4fe:309f:d612 with SMTP id
 s6-20020a056a00194600b004fe309fd612mr11782065pfk.10.1649291000074; Wed, 06
 Apr 2022 17:23:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  7 Apr 2022 00:23:13 +0000
In-Reply-To: <20220407002315.78092-1-seanjc@google.com>
Message-Id: <20220407002315.78092-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220407002315.78092-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 1/3] KVM: x86: Drop WARNs that assert a triple fault never
 "escapes" from L2
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove WARNs that sanity check that KVM never lets a triple fault for L2
escape and incorrectly end up in L1.  In normal operation, the sanity
check is perfectly valid, but it incorrectly assumes that it's impossible
for userspace to induce KVM_REQ_TRIPLE_FAULT without bouncing through
KVM_RUN (which guarantees kvm_check_nested_state() will see and handle
the triple fault).

The WARN can currently be triggered if userspace injects a machine check
while L2 is active and CR4.MCE=0.  And a future fix to allow save/restore
of KVM_REQ_TRIPLE_FAULT, e.g. so that a synthesized triple fault isn't
lost on migration, will make it trivially easy for userspace to trigger
the WARN.

Clearing KVM_REQ_TRIPLE_FAULT when forcibly leaving guest mode is
tempting, but wrong, especially if/when the request is saved/restored,
e.g. if userspace restores events (including a triple fault) and then
restores nested state (which may forcibly leave guest mode).  Ignoring
the fact that KVM doesn't currently provide the necessary APIs, it's
userspace's responsibility to manage pending events during save/restore.

  ------------[ cut here ]------------
  WARNING: CPU: 7 PID: 1399 at arch/x86/kvm/vmx/nested.c:4522 nested_vmx_vmexit+0x7fe/0xd90 [kvm_intel]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 7 PID: 1399 Comm: state_test Not tainted 5.17.0-rc3+ #808
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:nested_vmx_vmexit+0x7fe/0xd90 [kvm_intel]
  Call Trace:
   <TASK>
   vmx_leave_nested+0x30/0x40 [kvm_intel]
   vmx_set_nested_state+0xca/0x3e0 [kvm_intel]
   kvm_arch_vcpu_ioctl+0xf49/0x13e0 [kvm]
   kvm_vcpu_ioctl+0x4b9/0x660 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: cb6a32c2b877 ("KVM: x86: Handle triple fault in L2 without killing L1")
Cc: stable@vger.kernel.org
Cc: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 ---
 arch/x86/kvm/vmx/nested.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c1ef7867797a..bed5e1692cef 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -894,9 +894,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct kvm_host_map map;
 	int rc;
 
-	/* Triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 50d83b9f8067..ec4cbf583921 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4514,9 +4514,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-	/* Similarly, triple faults in L2 should never escape. */
-	WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu));
-
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 		/*
 		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
-- 
2.35.1.1094.g7c7d902a7c-goog

