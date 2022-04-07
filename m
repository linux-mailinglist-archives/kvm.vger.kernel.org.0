Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2B4F707D
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiDGBVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbiDGBUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:20:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DCF1877E7
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 18:16:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v7-20020a05690204c700b0063dc849f9f8so3091718ybs.18
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 18:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=801d9Et6vVPhDQnC0iYG+wLGLuQ795kMLNdzkGD2gNg=;
        b=h5szE2fzWy8unckrJRjuzttjaMFlCcU+82BRrO8olCmurNzU8jZvoJFOn1xDWBrXmK
         NwnWbROflIEd0ETxmbJkDrnEIb2AcZmo6IHmvnH8nMi9WyvKNXBoPq+EoD1iZcw0xgLn
         0uO5C/9xBMWbMKuie7m6Y5TUyEZbXDSONoteBhLYRtbBJZYUQ05gVsAUB+Q+ESOK7KB4
         v7bpw+vehDTDo8JhEINYrVM4TwLupBEQYVM7VTc3IPOhevr+Sg+PbzNc62T0GylEh1om
         gaT29p/EN5kZc6LTyZf0WNTOT58HpPj/iK/nVyIzooYy2LW0J9jXMOGsGZmFP2JpGdSV
         WMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=801d9Et6vVPhDQnC0iYG+wLGLuQ795kMLNdzkGD2gNg=;
        b=EmMFLIaV4oIg7xd0jq5qDy0vkhqRiCktU8x+RL/fx4XY389VM1RzId29eUyxfKoFcV
         t6aw/54b1ld2pCVkG17zVwD85Pskuf88D1kQ1TJsOmtDLnzRpVjdvm18hWbI5KyNsHdg
         TvzfPsh/HhIKPQ1DMhMZtFd5Y+D2RBnp8wZSFzMQkXZ+vcMcjhcBZ2vEQRdzMCylApWn
         qhHNHFvOcvutbfpY1O7O5ZqTI2471uZj+JNYJ0fc580uCLoQskbz7F+cLn43kFabznuZ
         09xwzkkbgJtn6QAoXyKEWLLeQdVKSXf2bSIvoXJg3D6/HUrSc6fUXngVQue2Dq3wBD1k
         oY6w==
X-Gm-Message-State: AOAM533ipYKCOA5OHqyVUUPR+GLJWjPx3Kfx34B5J4iNY58sbp0urj08
        Y+5ZO7rToqxaczCxPKl9XMrRBgVqiure
X-Google-Smtp-Source: ABdhPJzjmMSJmWuJc1STPElHufTrLVqugzxrngDHZOmiyGe1kL+j1BHxiYF7RjNUv3CxhEBEV/1e3qncU928
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0d:d404:0:b0:2e6:be16:e0ae with SMTP id
 w4-20020a0dd404000000b002e6be16e0aemr9753775ywd.517.1649294188279; Wed, 06
 Apr 2022 18:16:28 -0700 (PDT)
Date:   Thu,  7 Apr 2022 01:16:04 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-10-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 09/10] selftests: KVM: aarch64: Add the bitmap firmware
 registers to get-reg-list
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

Add the psuedo-firmware registers KVM_REG_ARM_STD_BMAP,
KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP to
the base_regs[] list.

Also, add the COPROC support for KVM_REG_ARM_FW_FEAT_BMAP.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index f12147c43464..281c08b3fdd2 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -294,6 +294,11 @@ static void print_reg(struct vcpu_config *c, __u64 id)
 			    "%s: Unexpected bits set in FW reg id: 0x%llx", config_name(c), id);
 		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
 		break;
+	case KVM_REG_ARM_FW_FEAT_BMAP:
+		TEST_ASSERT(id == KVM_REG_ARM_FW_FEAT_BMAP_REG(id & 0xffff),
+			    "%s: Unexpected bits set in the bitmap feature FW reg id: 0x%llx", config_name(c), id);
+		printf("\tKVM_REG_ARM_FW_FEAT_BMAP_REG(%lld),\n", id & 0xffff);
+		break;
 	case KVM_REG_ARM64_SVE:
 		if (has_cap(c, KVM_CAP_ARM_SVE))
 			printf("\t%s,\n", sve_id_to_str(c, id));
@@ -686,6 +691,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.35.1.1094.g7c7d902a7c-goog

