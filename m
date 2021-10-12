Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B31429CAD
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhJLEjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbhJLEjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:39:04 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466CFC0613E3
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:55 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d5-20020a63ed05000000b002688d3aff8aso8041376pgi.2
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7vo9Jye3iy34d7wxk7g8XLP+SJucgQI7Y2FBb4PVMnw=;
        b=XCT8s0xZr8hIUrdDmvqfnOnxYqMGJEiaoh+nFQ5WhVn0ZRTLWHNTAn+HFJmbjCOnY6
         x5CrPKVbLKHn40TQUW6a7Q7MVzdtVa4bBdMtIBG8yxn4VHVcVH8spAAakxPJeKOiObxk
         7xAxslDtmuqWhePLlKBtuFovwM6E11QC69B+fMBVFwNCeVZTacs5Lyd0WdW3GE3W7S2I
         Xk+6327uHlA8k24iPB2Rs4HTIpXl7swnhKavBqrVmt7TV46GZ+okhJnmWDSjvxezpDyE
         StUmedw/6Ehw533z4QaBgSx9/KKX3YCeVLKGVZzAXzgfoBIc9HpvhWvm8/2pXkJttqTB
         giJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7vo9Jye3iy34d7wxk7g8XLP+SJucgQI7Y2FBb4PVMnw=;
        b=VD5aC6VIol02z924Ilsw1jsnEydJ42+CmyH+BXBYgLxx6cRMldxFew+377cW5IjRaT
         w30P/BoWx95T7ep0dg7ylpW0dqGmmL9oojvJ6aeSeQowAFSLxuvvPhWFxqITPQDHPPuJ
         mWzFkjtiiDpQyGqzlvAX98dEcaBTj3f35BwL/UgxKeTjbUqw4Cb7WwkmOotBFqKufan4
         4L/3csakPbkq6tAZsUP+mhlGk0J8ee3rztTpHSOJygGVls3U00XUkLAQxDlLPhTTfxfo
         S/0xK9495xLO7xM2Q4/ced1BjTVw30ezsnJ62Ua+3hzZm9DWFvcjErN5DKJwmw3Wq31U
         XdFw==
X-Gm-Message-State: AOAM532R+5zgsy4UBl3G8IHpPQ2k0h1v2muJ8T3EeH21oroVaAm+/XJH
        TO6keGTwFt7XZ7JyJP0fX9fbSz/gJeE=
X-Google-Smtp-Source: ABdhPJx0SaVYdmsGOHnnA4GhbM5OqxPa33tsX7LZFC6lKXCPshs+pcbFLj6wvFn9yiyMZ22Y3bGPzseV7Jk=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:902:8b8b:b0:13d:e91c:a1b9 with SMTP id
 ay11-20020a1709028b8b00b0013de91ca1b9mr28229688plb.60.1634013414788; Mon, 11
 Oct 2021 21:36:54 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:33 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-24-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 23/25] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 68df4e4eba05..e74b33741dc4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -281,6 +281,35 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+	unsigned int gpi, gpa, api, apa;
+	unsigned int generic, address;
+
+	if (!system_has_full_ptr_auth())
+		/* The feature is not supported. */
+		return false;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64ISAR1_EL1));
+	gpi = aa64isar1_has_gpi(val);
+	gpa = aa64isar1_has_gpa(val);
+	api = aa64isar1_has_api(val);
+	apa = aa64isar1_has_apa(val);
+	generic = gpi || gpa;
+	address = api || apa;
+	if (generic && address)
+		/* The feature is available. */
+		return false;
+
+	/* The feature is supported but hidden. */
+	return true;
+}
+
 enum vcpu_config_reg {
 	VCPU_HCR_EL2 = 1,
 	VCPU_MDCR_EL2,
@@ -385,6 +414,14 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.cfg_val = HCR_TLOR,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_API | HCR_APK),
+	.cfg_val = 0,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -763,6 +800,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.get_reset_val = get_reset_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64dfr0_el1_info = {
-- 
2.33.0.882.g93a45727a2-goog

