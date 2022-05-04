Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9EF51B2BA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379699AbiEDW5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379352AbiEDW4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:56:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC3B54FB1
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:39 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t14-20020a1709028c8e00b0015cf7e541feso1375761plo.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DA/fDPR7FY+ZNY50Im1yQgf+ht5FfAkOTNmE+ScZpZM=;
        b=ZeeKreHJWVQz2m2UB7s7FHMq/p8SocWocBELKqSTgZxWUdVZH9FiVQC6OEUi4YzDsE
         o7tBI44bdbRq2Syko+zPNST2pAXBZyhPKJUiMw1+7LMddY1EtWlstB7Ed+Ya22VFQllv
         12kpynBaSIJVhJE58RFo2jeuFMLsRaXxKx2sKIBF9qByUxSF5X7Sv+jVN82lIMDzVZ2A
         MVb+i2MAIf78Xc68hUkpheLlgxcYjWgKLLw7c7zlHIUvdPBuCbwkYOf+Nj0sm2g1FWEW
         2OG9VQ1m2Oo38e3tamfFz+aCFUD0wOuRjR7HdSHYhp6n94vuU0d6DrvryyLEPCWntLn3
         WJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DA/fDPR7FY+ZNY50Im1yQgf+ht5FfAkOTNmE+ScZpZM=;
        b=RRAgIoqwO0NERsqGqG/HTsRNrykIRPCiQAP6vT3+I1JZZg0NVaMeS3sVaweyjU3nhH
         WYOQe/85fChEGw9fArRU255KKv/a7BQ3RQ3JHg2FBVhQ45WrbHa6xZdPgs3OUXpGpAQj
         jF0jCDthSJV2dVPFZIcVxiaCuSB8pp5ATfAic8EvPII9rJT1E2Fv9Qo1zrjcE3grgph2
         zul+kme042/QVfsHIxdba0lEVCQK5aBQG2U90poxhyCfevUISZxcJ+3+ZwWT2xib8bBm
         HIACx1cslNH/mf7z+gCppImIJ/T1blc7w4Fb9WUCbmzW/SgpKIygS40QqB9GbR23cDwz
         274w==
X-Gm-Message-State: AOAM533Xwl0Z6Da7FDO/0r6QD5J9g2qbUlGn14igsqXO89ftw+jRj6iO
        TuVCb20Mhu/yIfj3TvmHsdWbMULOxtM=
X-Google-Smtp-Source: ABdhPJwsV64fqomnb3OF++XujEXwHIhvLv6CB3KXiPLjrWBUdu4SQX7+zwuxGApPxUwaO81GXGIRJY5BHHc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:cf0a:b0:156:39c9:4c44 with SMTP id
 i10-20020a170902cf0a00b0015639c94c44mr23849018plg.124.1651704698816; Wed, 04
 May 2022 15:51:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:20 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-75-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 074/128] KVM: selftests: Add proper helper for advancing RIP
 in debug_regs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Replace MOVE_RIP+SET_RIP with a proper helper, vcpu_skip_insn(), that is
more descriptive, doesn't subtly access local variables, and provides
type safety.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/debug_regs.c | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index b999c9753fc3..487d0ae3e75f 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -65,19 +65,21 @@ static void guest_code(void)
 }
 
 #define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
-#define  SET_RIP(v)  do {				\
-		vcpu_regs_get(vm, vcpu->id, &regs);	\
-		regs.rip = (v);				\
-		vcpu_regs_set(vm, vcpu->id, &regs);	\
-	} while (0)
-#define  MOVE_RIP(v)  SET_RIP(regs.rip + (v));
+
+static void vcpu_skip_insn(struct kvm_vcpu *vcpu, int insn_len)
+{
+	struct kvm_regs regs;
+
+	vcpu_regs_get(vcpu->vm, vcpu->id, &regs);
+	regs.rip += insn_len;
+	vcpu_regs_set(vcpu->vm, vcpu->id, &regs);
+}
 
 int main(void)
 {
 	struct kvm_guest_debug debug;
 	unsigned long long target_dr6, target_rip;
 	struct kvm_vcpu *vcpu;
-	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -112,7 +114,7 @@ int main(void)
 		    "INT3: exit %d exception %d rip 0x%llx (should be 0x%llx)",
 		    run->exit_reason, run->debug.arch.exception,
 		    run->debug.arch.pc, CAST_TO_RIP(sw_bp));
-	MOVE_RIP(1);
+	vcpu_skip_insn(vcpu, 1);
 
 	/* Test instruction HW BP over DR[0-3] */
 	for (i = 0; i < 4; i++) {
@@ -134,7 +136,7 @@ int main(void)
 			    run->debug.arch.dr6, target_dr6);
 	}
 	/* Skip "nop" */
-	MOVE_RIP(1);
+	vcpu_skip_insn(vcpu, 1);
 
 	/* Test data access HW BP over DR[0-3] */
 	for (i = 0; i < 4; i++) {
@@ -156,15 +158,14 @@ int main(void)
 			    run->debug.arch.pc, CAST_TO_RIP(write_data),
 			    run->debug.arch.dr6, target_dr6);
 		/* Rollback the 4-bytes "mov" */
-		MOVE_RIP(-7);
+		vcpu_skip_insn(vcpu, -7);
 	}
 	/* Skip the 4-bytes "mov" */
-	MOVE_RIP(7);
+	vcpu_skip_insn(vcpu, 7);
 
 	/* Test single step */
 	target_rip = CAST_TO_RIP(ss_start);
 	target_dr6 = 0xffff4ff0ULL;
-	vcpu_regs_get(vm, vcpu->id, &regs);
 	for (i = 0; i < (sizeof(ss_size) / sizeof(ss_size[0])); i++) {
 		target_rip += ss_size[i];
 		memset(&debug, 0, sizeof(debug));
-- 
2.36.0.464.gb9c8b46e94-goog

