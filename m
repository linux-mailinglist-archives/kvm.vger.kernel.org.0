Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAABC429C81
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhJLEi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhJLEi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893A8C06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s6-20020a254506000000b005b6b6434cd6so25796217yba.9
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yO1PAz+jT8UeVSC81HcgY5AK6Wp3sOfwLOCbdKGHTBw=;
        b=BNMh2xxk+NtYYpDrk/F6E2XihCZLns3ZajqJY9EWMKkEcI1BQYLEMvy1PTCRgIY3oK
         WGGj1bhWXocOkgj3HLp2GsnRL41t5Rb9bsolj9QGpfKQ27poteViLTX0mbXXaIH77PWQ
         WtsXuG/mciEBgqSyGF6MIR3h59oj02cOW2YYFL+LGTNxlOP47DdEpb1KWzMSO423eo5Q
         YTxBOw/oKjUS+lMstg8DVrUBxkmUHnmMSntWxhL07jYhaJwPn6OXc7G6KLJJphJub6Pr
         WAHY2oZdrrr27gEWVh3JWA9v3wJFm7ako3ckNcQP3XNa9Bh3rAv+JX+cgjPeBxQ9uM2s
         0DyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yO1PAz+jT8UeVSC81HcgY5AK6Wp3sOfwLOCbdKGHTBw=;
        b=hVdqX9bl/uBw8z8I9UaqGHZqPYlVj7I6t9VNXkR+wMAbpQced9zd5ONry1QBOg7kqv
         O/T1FaSCoDLD1rA7WTDFe+drHUvwcSE8sCDbQ17V9O2lTjTGoX8jGLLtz8H82M8bY9sf
         ZZFuj8ZROhYCHosVl5//3xwOgrO+98VV/funL8XgJ4fKAd02us3KcgOH2gxwQbZK5t1X
         eNkDGxmoljOswdvkYEI9Iyvcyq5Vxj1fzKoDqcnkg2AQVniy5RQSka4Aaz8H+JoNN1Q5
         qrSNjb9sH8Yp3bQQsLGSnbfUs7ltazBMLlLh5x3fiZM5nqyn+ruJaFroogILkNDd6h+p
         Sw6w==
X-Gm-Message-State: AOAM533jm2CSozMkoIQBqIUSmYwBwKJIF2P5u3EWAwxN35RZ1AfVLvCq
        oQD80qkZ+c9Kg3z6C/F5DStOSU8uQ0U=
X-Google-Smtp-Source: ABdhPJxyJgraJ5AwHDPgzY9D+WbTlXuTeuy8jGj0LsPS3K2cu1koz8V6Ofx9NP2uOkX2rIeFqYI8ykM2HaI=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:517:: with SMTP id 23mr26194996ybf.496.1634013384822;
 Mon, 11 Oct 2021 21:36:24 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:14 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-5-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 04/25] KVM: arm64: Introduce struct id_reg_info
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

This patch lays the groundwork to make ID registers writable.

Introduce struct id_reg_info for an ID register to manage the
register specific control of its value for the guest.
It is used to do register specific initialization, validation
of the ID register and etc.  Not all ID registers must have
the id_reg_info. ID registers that don't have the id_reg_info
are handled in a common way that is applied to all other
ID registers.

At present, changing an ID register from userspace is allowed only
if the ID register has the id_reg_info, but that will be changed
by the following patches.

No ID register has the structure yet and the following patches
will add the id_reg_info for some ID registers.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 120 +++++++++++++++++++++++++++++++++++---
 1 file changed, 111 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 72ca518e7944..8a0b88f9a975 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -263,6 +263,76 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+struct id_reg_info {
+	u32	sys_reg;	/* Register ID */
+	u64	sys_val;	/* Sanitized system value */
+
+	/*
+	 * Limit value of the register for a vcpu. The value is sys_val
+	 * with bits cleared for unsupported features for the guest.
+	 */
+	u64	vcpu_limit_val;
+
+	/* Bits that are not validated when userspace sets the register. */
+	u64	ignore_mask;
+
+	/* Initialization function of the id_reg_info */
+	void (*init)(struct id_reg_info *id_reg);
+
+	/* Register specific validation function */
+	int (*validate)(struct kvm_vcpu *vcpu, u64 val);
+
+	/* Return the reset value of the register for the vCPU */
+	u64 (*get_reset_val)(struct kvm_vcpu *vcpu, struct id_reg_info *id_reg);
+};
+
+static void id_reg_info_init(struct id_reg_info *id_reg)
+{
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->vcpu_limit_val = id_reg->sys_val;
+}
+
+/*
+ * An ID register that needs special handling to control the value for the
+ * guest must have its own id_reg_info in id_reg_info_table.
+ * (i.e. the reset value is different from the host's sanitized value,
+ * the value is affected by opt-in features, some fields needs specific
+ * validation, etc.)
+ */
+#define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
+static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
+
+static int validate_id_reg(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_desc *rd, u64 val)
+{
+	u32 id = reg_to_encoding(rd);
+	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
+	u64 limit;
+	u64 check_val = val;
+	int err;
+
+	if (id_reg) {
+		/*
+		 * Clear bits with ignore_mask, which we don't want
+		 * arm64_check_features to check.
+		 */
+		check_val &= ~id_reg->ignore_mask;
+		limit = id_reg->vcpu_limit_val;
+	} else
+		limit = read_sanitised_ftr_reg(id);
+
+	/* Check if the value indicates any feature that is not in the limit. */
+	err = arm64_check_features(id, check_val, limit);
+	if (err)
+		return err;
+
+	if (id_reg && id_reg->validate)
+		/* Run the ID register specific validity check. */
+		err = id_reg->validate(vcpu, val);
+
+	return err;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1176,11 +1246,19 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 {
 	u32 id = reg_to_encoding(rd);
+	struct id_reg_info *id_reg;
+	u64 val;
 
 	if (vcpu_has_reset_once(vcpu))
 		return;
 
-	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
+	id_reg = GET_ID_REG_INFO(id);
+	if (id_reg && id_reg->get_reset_val)
+		val = id_reg->get_reset_val(vcpu, id_reg);
+	else
+		val = read_sanitised_ftr_reg(id);
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
 }
 
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
@@ -1225,11 +1303,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/*
- * cpufeature ID register user accessors
- *
- * We don't allow the effective value to be changed.
- */
+/* cpufeature ID register user accessors */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
@@ -1240,11 +1314,12 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
+	u32 encoding = reg_to_encoding(rd);
 	int err;
 	u64 val;
 
@@ -1252,10 +1327,18 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
+	/* Don't allow to change the reg unless the reg has id_reg_info */
+	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
 		return -EINVAL;
 
+	if (raz)
+		return (val == 0) ? 0 : -EINVAL;
+
+	err = validate_id_reg(vcpu, rd, val);
+	if (err)
+		return err;
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(encoding)) = val;
 	return 0;
 }
 
@@ -2818,6 +2901,23 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+static void id_reg_info_init_all(void)
+{
+	int i;
+	struct id_reg_info *id_reg;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
+		id_reg = (struct id_reg_info *)id_reg_info_table[i];
+		if (!id_reg)
+			continue;
+
+		if (id_reg->init)
+			id_reg->init(id_reg);
+		else
+			id_reg_info_init(id_reg);
+	}
+}
+
 void kvm_sys_reg_table_init(void)
 {
 	unsigned int i;
@@ -2852,4 +2952,6 @@ void kvm_sys_reg_table_init(void)
 			break;
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
+
+	id_reg_info_init_all();
 }
-- 
2.33.0.882.g93a45727a2-goog

