Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B045D485FD5
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiAFE3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiAFE3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:29:08 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9A3C034003
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:29:08 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id f24-20020aa782d8000000b004bc00caa4c0so949734pfn.3
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iwXsEGXlRtnuTPyM/ryhBa4F3YbG0RREAYmK8S1ALak=;
        b=DY7bN9c02WCcBIqylRNzAa/UKrlEqTdIPajSGSeXyRQpP4wggxu1ISZyO1v/ZGCngz
         0+SHEjeqZI0uX9Pn9pJNUV/x2ZrbEsfDttbMPqFG8ERSn7RGb5ii2aWKxB3U8XO75UBv
         tvRqTOb4xqxIsB3EQYD9ljD0jWpW9K06TOuMoRa8oQDAF82bHN99MvgfdsXb0QfvWOYq
         OPi9gKx+MXSGxbTsuWmqPuzZs4raKY1OXhB+1KA0SIy2U5CtMqK0JDsdDRVzU+30vBl5
         /VAuQTw0SVFGp4LMQyKyeupT1SQyNAXo0IK0uLxm6N1mtzWuttt3UQlfmknM8c67y9p3
         Ts9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iwXsEGXlRtnuTPyM/ryhBa4F3YbG0RREAYmK8S1ALak=;
        b=SB5YR4/BVxNJMI8AleZP7Nxku2XaxuoqxkJ18O4ga9s3QOX3r3Fhqw0DHGpXEoV//K
         xKOiYNyuB89Mvs7DO0CdxH7HzzmDINtUrR8QyPwMEQYXnTIS+89jbY/qFwLjQUZM7twf
         iXQGWGa8kdplyxone5wd1VKMO/q4vcWuvwBENuTs1HGS0IvJYs8LhSeq/LAUDNaj+Gut
         fSwRHktpB8Gws7E50YnPKbrtfXQ3eKKruJgzrZm+SSgldGFEkb4XZlAV0mcoo0w/+foa
         JGuMHUF3ApFI7eAn2vVzZEkac663rsH82gfJnCnhclqhTV/CAAd0A25GjBOo0I/kbpkZ
         N0fw==
X-Gm-Message-State: AOAM531Ga6TiWNAx00Vg/Ff8OydfLNmYlYzV7QXRFziSmsx1eq4wPApV
        u0G/gtx/5pbTpzr8Fn87DSaJV47J63c=
X-Google-Smtp-Source: ABdhPJz9xkqu05Zv3mJ6ciKxZhfGOKGvAVLc21cuH1LPUGn8hbmqRWcz+0GsoulJ4ERK1227XDG5qggDLy8=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2311:: with SMTP id
 mt17mr4608281pjb.203.1641443347686; Wed, 05 Jan 2022 20:29:07 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:27:06 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-25-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 24/26] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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
 arch/arm64/kvm/sys_regs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f8a5ee927ecf..e6ef76f9b563 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -283,6 +283,30 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+	bool generic, address;
+
+	if (!system_has_full_ptr_auth())
+		/* The feature is not supported. */
+		return false;
+
+	val = __read_id_reg(vcpu, SYS_ID_AA64ISAR1_EL1);
+	generic = aa64isar1_has_gpi(val) || aa64isar1_has_gpa(val);
+	address = aa64isar1_has_api(val) || aa64isar1_has_apa(val);
+	if (generic && address)
+		/* The feature is available. */
+		return false;
+
+	/* The feature is supported but hidden. */
+	return true;
+}
+
 /*
  * Feature information to program configuration register to trap or disable
  * guest's using a feature when the feature is not exposed to the guest.
@@ -370,6 +394,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
 }
 
+static void feature_ptrauth_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, 0, HCR_API | HCR_APK);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -430,6 +459,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -932,6 +967,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64mmfr0_el1_info = {
-- 
2.34.1.448.ga2b2bfdf31-goog

