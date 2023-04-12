Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC636E00F6
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDLVfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDLVfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399987A85
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j6-20020a255506000000b00b8ef3da4acfso10961149ybb.8
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335318; x=1683927318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qcXR+cj62Nmz/QQQB2g9N2pbdYpcmmyV5nmt0T5Wjo=;
        b=jKd+t0UtWM9xdOiqGRYNFX92os/otTxaJl4Aq9bIi0v9GANiTqkZBL/I45CujgAQS6
         MzK4MDvKOetboWsJ3AHeOfQd/NePDJlf65y7kIDGm3MVGQnsV8BAB2K34AdrUiC0Dhn3
         ETjJ1PEuxflgPxc8u+TwmpiZ1VExPHDqjNtsatLtld6xdOsm/BMr4fHWr2dAljkvCJ9j
         t4SUTI6Jq4R2QOZv+CxYoQeTRoneT7k0B1dC9jqxfcJA9b5ur1FurjeI473lS5euST9Z
         FDKBAA7J0WRtJLH7ZUmGAUuavMkA+9wKoI/V/FPWkmO6R2om6cXKIV2IivywVuTD+ZpM
         j57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335318; x=1683927318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qcXR+cj62Nmz/QQQB2g9N2pbdYpcmmyV5nmt0T5Wjo=;
        b=E1rKLsGj03TeFcJFLZmws0yQVpXx7PGyrlrT++2P4xRNADX5/18U2l+1WENUqfCIEr
         oT3XX3uZOE69hOXPGX4eZO0ikx7mVRmch6FwugliW+U0x1cTbLxTZIC8/rHfhjsUSXJm
         ey0jDy8LNIfDy/s5PG4z/6muaYWqbo1zeoy8nDYIKxNdf1BwME21CiDn7Y8ETox0giMN
         /btsCjWKGj/1sZgLhO4kW1PSUHWEZ+ncpzXSYg+aGt9KAZQ1u2P7P8Jqq6Q9VT0VWxbT
         Z7nb4vq2OwB2q0rPB4NDqMTwGZPbFda74euVLkF0tRkgyrtajac2jS55j2np/EaaQTgl
         zSKw==
X-Gm-Message-State: AAQBX9cwR0w2dvtgSCJdRhT2tbYj8rDJ0+OXiqFggDhqoEBtRUdUrw6X
        wMAs1UFtdjBS7rfZ0urTszMHD9TjVngspg==
X-Google-Smtp-Source: AKy350Zu8+mZvFG+GBSeyU7SYAPl8PpXVNqqRPXN8kTxiuOldRi6f9+m5WF52N2/PJJYK1MSzUO1lNI0nmUPUw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:cb97:0:b0:b8f:52e6:69a8 with SMTP id
 b145-20020a25cb97000000b00b8f52e669a8mr753519ybg.13.1681335318559; Wed, 12
 Apr 2023 14:35:18 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:34:52 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-5-amoorthy@google.com>
Subject: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN
  at the start of KVM_RUN
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Give kvm_run.exit_reason a defined initial value on entry into KVM_RUN:
other architectures (riscv, arm64) already use KVM_EXIT_UNKNOWN for this
purpose, so copy that convention.

This gives vCPUs trying to fill the run struct a mechanism to avoid
overwriting already-populated data, albeit an imperfect one. Being able
to detect an already-populated KVM run struct will prevent at least some
bugs in the upcoming implementation of KVM_CAP_MEMORY_FAULT_INFO, which
will attempt to fill the run struct whenever a vCPU fails a guest memory
access.

Without the already-populated check, KVM_CAP_MEMORY_FAULT_INFO could
change kvm_run in any code paths which

1. Populate kvm_run for some exit and prepare to return to userspace
2. Access guest memory for some reason (but without returning -EFAULTs
    to userspace)
3. Finish the return to userspace set up in (1), now with the contents
    of kvm_run changed to contain efault info.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b12301..ca73eb066af81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10965,6 +10965,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
 
+	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		if (kvm_run->immediate_exit) {
-- 
2.40.0.577.gac1e443424-goog

