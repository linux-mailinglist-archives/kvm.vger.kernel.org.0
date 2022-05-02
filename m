Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA11C517AF5
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiEBXoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiEBXmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:42:44 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA49F20BFD
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:39:13 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id t15-20020a17090ae50f00b001d925488489so250304pjy.3
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QkUuCyfxz0yjq0ch3OSwAfGOrfLGsj9nivNwXJkBK5g=;
        b=Tz4B+eH5HuR8q9n50g2/acZQ1++xVDSFvRimXeQDdZpwwV6NnFK5XDO0sFqEWVjyBN
         bc+Oht/ftGLWzoJ4M5oryTr8Xu7CvNGxEKik36VmIsd3h671BNKOGBFuexD8q0RUYnZI
         XKoyGdtg/FqUw6tTq7GEWV4EPY7Ci5CJ1MPNWYw+cwrGq4cnvsHswlPZJKhT9hmGGPPU
         ePgInDo8PXPQzXvRb5poWc4C5ubPcjNe/lQkDyN6uQ6fABWwwOUxeHQGLbp0cmb6yuSG
         sP/ySXKvvzS1aKN5b0npOOLzWp8ORKF6p8dUY9q5p++ixxfMUyueouQSFUzyB/KOscx/
         olyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QkUuCyfxz0yjq0ch3OSwAfGOrfLGsj9nivNwXJkBK5g=;
        b=xdx66CwuFZSYCs95Zdi58GZEBAX2anksW1RGODddFQn36ZpFB2mCe0YkDJio/1TPEl
         GIDcqTW+uPBpBmK036Sqdx+W3L6JnU09DoqRCkgDrfxgdaQTzZQkERyyPIsVhudUoI6K
         yhh5DDStyJzzY2rxRpi3l0afyIqqiHbeKhW1av0u68WoLVDWL6LXHj0QjEYKs8j+vAp5
         KU+oO+n259yl3F2AfEpKCpxN5mska1zBvcJTGx/bNbtLsV6KO+ulrg8Xw7lH6kzwNYmL
         8nhoImgV0EeKWUBsHESlnfq+q2GvvLG2taipXOIk3FOc7BpI4+fgwTvjbce8ZBEIfqCi
         Jp9w==
X-Gm-Message-State: AOAM533DTrl9y+LToS8WwEKwSRDx2FW6ZUPUnh3OYH/qzh616ZEPqwl7
        7+4aC4XGA8gEsXBvhN69nDGU4i7NdE+O
X-Google-Smtp-Source: ABdhPJzf0JCsw7wdZ8d5r0A8d1ZjwtpbuoUxsZk5ewrDKwzveAk79a48gDNabIdMRY+bMtBINrfyzwNPw8xq
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:816:b0:50d:6b3d:c86f with SMTP id
 m22-20020a056a00081600b0050d6b3dc86fmr13482457pfk.76.1651534753259; Mon, 02
 May 2022 16:39:13 -0700 (PDT)
Date:   Mon,  2 May 2022 23:38:53 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-10-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 9/9] selftests: KVM: aarch64: Add the bitmap firmware
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
index 0b571f3fe64c..d3a7dbfcbb3d 100644
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
@@ -692,6 +697,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(1),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1 */
 	KVM_REG_ARM_FW_REG(2),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2 */
 	KVM_REG_ARM_FW_REG(3),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3 */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_FEAT_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.36.0.464.gb9c8b46e94-goog

