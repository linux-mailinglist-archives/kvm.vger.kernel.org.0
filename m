Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF4429C7F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhJLEiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhJLEiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:24 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D472BC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q3-20020aa79823000000b0044d24283b63so2378066pfl.5
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ydcMqLw7I27y2BCq9xNW2IjPYrEmatmYQFDkuaqb6Ys=;
        b=fIhPep5xebOqDQxahAlQRhWaep55nEzLGFccYceuEdkPcptnR+qdgdjVxdKBQOKL7j
         /tnOstI0GSmvqfOb4XGBwZzcrcDFLol9FioWZfD7GNS2DPRDWI68dqEvItZb0sgHLuHa
         jV/G1BuwMRyZxX+4fA7gQ2YkeeOZr/dW/JbplrSneEEVF63KHueJ5KvilT1j3lzTVa8n
         lxSSq5tcFDBVmjBEyq8gwcDpMGWwIx5GMmTvxL7XQEwRyejlBwuingxhY6gK7+Gg9hcU
         aewGN/fbd3gWPBIyL5NAMYGuvQv+7XyE1JGWJ84mqCibVWmSZuzlIUE3lNn0ErvlDlTN
         qeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ydcMqLw7I27y2BCq9xNW2IjPYrEmatmYQFDkuaqb6Ys=;
        b=im8y5uqCxvm/zxbBFIMsogamYYZStxLt4U9xlVI53pXPb2l8ckJCwXHfO89r84866Z
         n7zpFMlQodhPNKbf15MOI8ToUag8KzMi8cLCMbG3Cz3Jy+EDuS0KzAGdOfD1eC7R6nH2
         o4nOtLdsI/cmJX5KnNK6Rb2eTASexUgYP9CAjoRQS+hqPaXrmCmwcyIz3B0QdMSIrXpE
         Ir1xZ6e9Rhp3JG3BuSFc46tVfstRCrCLRLYqdTpLzGSs5pQDUYFM3CttAkWSipZkWHkf
         +u8vWw9pybcmt2Tccwo7wrT1+ke4+Sta1QG86d/QHYEfec4/8huqrqL0t0R/HdsgD7Tt
         QcLQ==
X-Gm-Message-State: AOAM531aaaCmv+JCPJS0knSscxloiINQGEJg0SfrabAzW+AqlcWtJHYe
        rAs80vxz8riapvLLNb411V7pycg9PAw=
X-Google-Smtp-Source: ABdhPJxJkSl8XzKYhkBIAFMBll8PIXQOz4AtNn7iEoWt6JG9RA/u+2uTfezIu6/nxTTDqGUsD6OE9/ryTQ0=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr25307458pfu.61.1634013383274; Mon, 11
 Oct 2021 21:36:23 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:13 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-4-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 03/25] KVM: arm64: Introduce a validation function for an
 ID register
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce arm64_check_features(), which does a basic validity checking
of an ID register value against the register's limit value that KVM
can support.
This function will be used by the following patches to check if an ID
register value that userspace tries to set can be supported by KVM on
the host.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..eda7ddbed8cf 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
+int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ec7036ef7e1..d146ef759435 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3114,3 +3114,29 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "Vulnerable\n");
 	}
 }
+
+/*
+ * Check if all features that are indicated in the given ID register value
+ * ('val') are also indicated in the 'limit'.
+ */
+int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
+{
+	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
+	const struct arm64_ftr_bits *ftrp;
+	u64 exposed_mask = 0;
+
+	if (!reg)
+		return -ENOENT;
+
+	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
+		if (arm64_ftr_value(ftrp, val) > arm64_ftr_value(ftrp, limit))
+			return -E2BIG;
+
+		exposed_mask |= arm64_ftr_mask(ftrp);
+	}
+
+	if (val & ~exposed_mask)
+		return -E2BIG;
+
+	return 0;
+}
-- 
2.33.0.882.g93a45727a2-goog

