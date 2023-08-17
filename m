Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D668B77EE41
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347368AbjHQAbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347335AbjHQAai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:30:38 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352F42736
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:37 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589a45c1b0fso93463767b3.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232236; x=1692837036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WzKCvhVWsExbbkBqgjmP8R+v45VGDegN/7kG0ihAn0=;
        b=PZ3/GOZm9t8lBFHwWnUgx9kDAevNHEkCtnYgv/9aISsrBR+FRfc421K8zfhWwG0F1Z
         TaGHoAmhLwm37px7PqR6/QUXrSlnysmRhDFyoJXelmbm1ZuCxsX4u0AwXYpvgqYXS4Vu
         cdNWRqgad7TFa3PAVlF7iOrS4SaortFe85ZGJbB7LsGgTXxyJi9pgyhnPjMk55M6DeoW
         NGg+AgnCapkq61mr3/dDWy1ypTs2TsaCLGXvJzA602iNQm+eiHp3JJsNVvbSArDQXrpV
         +SsKkRT9m04KBNQklL6XrwrzipM4GxjonNKX+XriHBI5VBI3yIAX/UziCk2KLzYwcYdL
         7RiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232236; x=1692837036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WzKCvhVWsExbbkBqgjmP8R+v45VGDegN/7kG0ihAn0=;
        b=f3lT24EoG2jCT9WXv4orH7ZvpYiNebFpA+VNmNzlik3BY31+R9rlXvBhz2vKIY5bDZ
         VcIfCX7yjzDYhXr9Kv6NQOxQkXgzFFihG3Z0Vm6EwPgtZyHOJsjbDQNXRG7zApDYzVpC
         RwpUbdfuE8IqypVuGUR1toJynSc4cGZn3qa60WLnXYpCvSVlKD8KnKXE6JDG4AHidcQ9
         hGUViD891txXIHJ7jafwHKntw0gJO9HWWUz4bhUzeBeToMNSYCmScK2t6UYxy2tvma7O
         ImkfiTTFdeUQggUHziCkJ/M7GU27xI7IfvfdrbwkWGJSB2ykl5fvV7dkpjl3sSUiGlpZ
         b5IQ==
X-Gm-Message-State: AOJu0YxQ7UVYPCBF1KMymP0CiCMKxEy8Ur5ui4nyY8YKVvLzs/7BsWNI
        Nglf84AZz7W0vkuds0gUvbS/gKDFP11d
X-Google-Smtp-Source: AGHT+IHJmx2o/AjOqVUmGFuIH8g39Ni5Dd+TGMGoVeRs4jVJISVQQKSSwMp3clB56CLgHpeAZOan4BoJAgSv
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:4411:0:b0:583:a3c1:6b5a with SMTP id
 r17-20020a814411000000b00583a3c16b5amr40767ywa.4.1692232236456; Wed, 16 Aug
 2023 17:30:36 -0700 (PDT)
Date:   Thu, 17 Aug 2023 00:30:21 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-5-rananta@google.com>
Subject: [PATCH v5 04/12] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d3d44d165eed..39e9248c935e7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2178,7 +2178,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0, },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -2336,7 +2336,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0, },
 
 	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
 	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
-- 
2.41.0.694.ge786442a9b-goog

