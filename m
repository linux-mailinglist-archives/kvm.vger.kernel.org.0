Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5827A4B9CCA
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 11:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiBQKNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 05:13:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbiBQKND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 05:13:03 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F90143469
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 02:12:48 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso1782175ioo.13
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 02:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5T4ROjtiSYSmILGtelNbeXe0t7OVZ2zJkKj18jqpZkM=;
        b=lUzq+PCpYalHly9R3Q1U06bzq2o75xRuFbqYlkDMnnn5KOiSDkcPRkLnJpxR5Y8s6B
         9tmLnKvXcEOsWLwD/z+2dF9XLULMO0qynB+qbLVFy26bDbAUp0tP0SzxNUTphTAMM+Sx
         0GMYh6axYOoWjIqXTFUhW1VVWvlzFSQ9o4jfRjm9ckT8YcZxiclp3BVxF201cY1Zrvhc
         6/2A6C99zU5v+t3j9xPzLnTUPRsc1NO6sjAYA+ULe5x8D3BdddGJ+Aa8Wtago4gpPimI
         /tAFA1zexbYa1S0w3fX2xlxIKnGK8w01qy0lx0n4/6DuJa2N4ru7jTu16TfwzuDrSQWh
         cWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5T4ROjtiSYSmILGtelNbeXe0t7OVZ2zJkKj18jqpZkM=;
        b=OAJvON2H8mSm15vae4otijCAd/97BPjmM9pJ/sT1jeT0lOYzRhVmtGLz0SA/Kzq6Qk
         ZssRpQ443LR7Iju8WCl0KG/w1RmDSOzdeqQrXXtCEawNIgUjhLpFJgcaP6uG0jo0azac
         iUmjx7/yFCt3a+PzEytNquH93dIe1EuhmaorIv+5rrBlS4LlN2BPlwp4xENOPJvV6L5g
         XCIe1BozLJzkguqZxZFNSMk/QxT11wofiH4N5nATLjtqIpE3TPqs3wTOisigFXU4VDII
         LwWZmCNaoG/bgtwk2tiH5CfhjXV5aPk+7S3BuBQWUegTut7q5NpSQV0uxQt+9ioEdsHV
         gKiA==
X-Gm-Message-State: AOAM532IlPCkly6oAQPLK6xRwcwWOqgNjXzjgTMIOSoN0RTKQdgIqG0H
        JYAhdU9x069AVf3W7q/QB6s2xatm3jQ=
X-Google-Smtp-Source: ABdhPJyOEPz9mt5BJMOOnZ7Z5Hae+tzeYPXrDeNDmxnly8CXUchWb06soiTAXuk5BdL+NZ9baVeN5BMO0QM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2f01:b0:5ec:f99a:93a1 with SMTP id
 q1-20020a0566022f0100b005ecf99a93a1mr1452284iow.109.1645092767893; Thu, 17
 Feb 2022 02:12:47 -0800 (PST)
Date:   Thu, 17 Feb 2022 10:12:42 +0000
Message-Id: <20220217101242.3013716-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] KVM: arm64: Don't miss pending interrupts for suspended vCPU
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
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

In order to properly emulate the WFI instruction, KVM reads back
ICH_VMCR_EL2 and enables doorbells for GICv4. These preparations are
necessary in order to recognize pending interrupts in
kvm_arch_vcpu_runnable() and return to the guest. Until recently, this
work was done by kvm_arch_vcpu_{blocking,unblocking}(). Since commit
6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch
callback hook"), these callbacks were gutted and superseded by
kvm_vcpu_wfi().

It is important to note that KVM implements PSCI CPU_SUSPEND calls as
a WFI within the guest. However, the implementation calls directly into
kvm_vcpu_halt(), which skips the needed work done in kvm_vcpu_wfi()
to detect pending interrupts. Fix the issue by calling the WFI helper.

Fixes: 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3eae32876897..2ce60fecd861 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -46,8 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * specification (ARM DEN 0022A). This means all suspend states
 	 * for KVM will preserve the register state.
 	 */
-	kvm_vcpu_halt(vcpu);
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+	kvm_vcpu_wfi(vcpu);
 
 	return PSCI_RET_SUCCESS;
 }
-- 
2.35.1.265.g69c8d7142f-goog

