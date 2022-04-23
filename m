Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2609450C56D
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 02:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiDWAHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 20:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiDWAHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 20:07:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9FD210199
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m11-20020a170902f64b00b0015820f8038fso5579730plg.23
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s8j9kj4vlgoBbVsMqTWGwW74KTbhvSIyPcu9kjmk3mg=;
        b=Kf/obMymV4dKTLaHQ9vU4iXvPrE4oPgT1V7IU2nfscX8IQV7XePv3hocOPRD9WGWS5
         qbqdVHGKg+NzqNIxosRgBK0ZoTUP+V1zuEf6JCVhnsdtSIorKYV1lMswst4f7/aOwsXN
         TeEL29nm1GDndxDwEEU3sPxLD9aehBKPDUQZpO0M6iqu8+C67ydwXnTP6ypLb2nzUYNl
         3bAkmcX7/05uXq7IYcs+GDKCo15Jr0qbLoY55JX2cug1q4nIlf+sfHk3sMv2J68Dro9K
         XIimltu0kNIfB1I9N9SHiI9/77weHhz3n+dpmKV1HpVytDTq+/WIiA8uWayp2iVwGfBz
         D/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s8j9kj4vlgoBbVsMqTWGwW74KTbhvSIyPcu9kjmk3mg=;
        b=lDzs2KpuTm9+JuPfa7kxKIPugnS8JYrEQBg5JAy2MYr6A6cqHP26KvP69J3m4dIlKi
         ZRUE3eWprXDDUFTnWJHvHd+rdreP3UE1BbWwwEf7bR2tV1zU361wgIiP2z+muGlWFUtd
         auTp9jyvKn2nquyMgkuLQ4avg4eeXOC9vje5oK+oaf5TkO1q4JY5xD+M/EPGtaNMn0ML
         RfwC/gOsdJthUzvA/oSZ5n6M1wPeBaNbvxshnaEX1PHs6GDvK/i7weqvt5bNx0PUsglY
         2ZwtRMwhtzToDwafB038PS5cJ5uTD8/BvzUARrucWaodebp7omQgpbrDhScBlOy9dJqM
         9h9w==
X-Gm-Message-State: AOAM530lM50eexTpdEqqgC6pV4rm+ecBrVOHPFZb/+mLU6mmG9tJanP2
        mjz/RfWnOjHf4A8JGU/8TZz8blKl5dLT
X-Google-Smtp-Source: ABdhPJxLdnqeaExMLlAnDRAdqhlgHYhal0Uv3YiRM0Qpe3ApegAEaDu5LxZo18Qe+X+tJK/Krg4ftUZZ1Hoe
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9522:0:b0:4e1:d277:ce8 with SMTP id
 c2-20020aa79522000000b004e1d2770ce8mr7486812pfp.16.1650672230928; Fri, 22 Apr
 2022 17:03:50 -0700 (PDT)
Date:   Sat, 23 Apr 2022 00:03:28 +0000
In-Reply-To: <20220423000328.2103733-1-rananta@google.com>
Message-Id: <20220423000328.2103733-10-rananta@google.com>
Mime-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v6 9/9] selftests: KVM: aarch64: Add the bitmap firmware
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
2.36.0.rc2.479.g8af0fa9b8e-goog

