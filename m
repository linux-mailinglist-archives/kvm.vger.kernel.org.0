Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D86E5064EB
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349021AbiDSG7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 02:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239018AbiDSG7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:59:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71B727B1B
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r12-20020a17090a690c00b001cb9bce2284so10126881pjj.8
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LynBrBVbmgX2+WvKy3gn9dzDYlX9Xj/PYcz4rcGsVrE=;
        b=pb47lvhf8Z//JVtjhi2MTUEc5TyUZmQkHhhcQiIH1B+gOsCUIuYhHDxjaeh/NBGruD
         IFmEFY99G7yvkW9vtGaRltiz96b+66iq4Rh7sr0f96aTkCVLuJkcOBCS1PEEciP7ykHd
         hlc5fldT3vIKA/dNwCChdCoF2CS7MWMzq1LM52cdaoTTb5Y3IHRjI3hiKBSNeKpTBv5m
         H+TZe3zZK2DqK+dch7uYj+Fxh0hnB/KMIcxzXboPM+2VoxuTshugY0WZKEO4aC+SK9tY
         xCmxr0oUqVp9JU/RAwQTGYsuLLsXAM3OaFoHv019JtwirkqTeevXBu8XaOfxbb3rJLMb
         3v6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LynBrBVbmgX2+WvKy3gn9dzDYlX9Xj/PYcz4rcGsVrE=;
        b=pUeoCkczkMgrzu48mUgLReqqrKipyhpGQF9MqnQBLyX9gn4wN/gkSF8wu7h2FXAM4T
         gLMZwVD1j49Oiv2RXBXaYOYjDtjAGUdStuRFUD8yCOWX85nz6v5GJeyhG9UBUskscKOA
         b3O+o5S/MWvXPHBY7JPN9gpIasTFn+rDzpCOIg8CIFleR+fy785PPgzL0aSOwctHnqZd
         zADh/0khK6/z3UjQ6bBtrGuB7o1EmaV8MnGqOHDe3e43bRsUY2I1XVEjf1HzrYK14TB7
         sMiC0STo0EFI+Y+Aj//Aaia6lZvGvh+q+xfO8RbBgVI9O+vfW3b9KHU4gYDDeNu3JQZU
         /CVA==
X-Gm-Message-State: AOAM531qJKuoqF7Td+qMQcL5IpNL1VAzedOZ/aCJdR5tjPFvPeZL7g/T
        NinLg+/RKZ1VmbrSz6H3ZEBQjn9K4bo=
X-Google-Smtp-Source: ABdhPJxvVqjBxl7SRv/CdH2AWZNC4bLBk9YbOJJ9z+CxzjQ12jRtsxSU318j3YETRdXG3BXKMjWxCiZkbks=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr277559pjo.0.1650351426949; Mon, 18 Apr
 2022 23:57:06 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:07 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 01/38] KVM: arm64: Introduce a validation function for an
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
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Introduce arm64_check_features(), which does a basic validity checking
of an ID register value against the register's limit value, which is
generally the host's sanitized value.

This function will be used by the following patches to check if an ID
register value that userspace tries to set for a guest can be supported
on the host.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 52 +++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c62e7e5e2f0c..7a009d4e18a6 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -634,6 +634,7 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
+int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d72c4b4d389c..dbbc69745f22 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3239,3 +3239,55 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "Vulnerable\n");
 	}
 }
+
+/**
+ * arm64_check_features() - Check if a feature register value constitutes
+ * a subset of features indicated by @limit.
+ *
+ * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
+ * an item whose width field is zero.
+ * @val: The feature register value to check
+ * @limit: The limit value of the feature register
+ *
+ * This function will check if each feature field of @val is the "safe" value
+ * against @limit based on @ftrp[], each of which specifies the target field
+ * (shift, width), whether or not the field is for a signed value (sign),
+ * how the field is determined to be "safe" (type), and the safe value
+ * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
+ * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
+ * won't be used by this function. If a field value in @val is the same
+ * as the one in @limit, it is always considered the safe value regardless
+ * of the type. For register fields that are not in @ftrp[], only the value
+ * in @limit is considered the safe value.
+ *
+ * Return: 0 if all the fields are safe. Otherwise, return negative errno.
+ */
+int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
+{
+	u64 mask = 0;
+
+	for (; ftrp->width; ftrp++) {
+		s64 f_val, f_lim, safe_val;
+
+		f_val = arm64_ftr_value(ftrp, val);
+		f_lim = arm64_ftr_value(ftrp, limit);
+		mask |= arm64_ftr_mask(ftrp);
+
+		if (f_val == f_lim)
+			safe_val = f_val;
+		else
+			safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
+
+		if (safe_val != f_val)
+			return -E2BIG;
+	}
+
+	/*
+	 * For fields that are not indicated in ftrp, values in limit are the
+	 * safe values.
+	 */
+	if ((val & ~mask) != (limit & ~mask))
+		return -E2BIG;
+
+	return 0;
+}
-- 
2.36.0.rc0.470.gd361397f0d-goog

