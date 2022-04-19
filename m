Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF7F50653A
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349214AbiDSHB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349170AbiDSHBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:01:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E74233355
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso1040923pjb.6
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mjj9/ZURjjtGQaz2LLl2krlBnNho3fyEfvR2R+fnkyk=;
        b=Cx/niwv6W7Y06XURKByUCxiOI2JS42u8ZRsB4Jd/xNk9tuJcTxkf6DGO2ozYf4I2US
         ZU5gnlaHf3BOrOeCv/etuwgapIvL2bqk3oDXaueadh0neyRo+SRUNGL8votl7vplAKIM
         sHEcbNzdEG1JDsorZDIsYKh0benCQF67aJbA83qbMyT0rAqvaaie74ccZbn2UKz7aKPj
         rdih6zJ2hBj5+wcu/NsMPytHpAWF1ZDLiIr+vMhcou+4/o0JwtMNZ0uLdoKh4FJr+/Aw
         2l9wU0ZAeDtDkWgA6X6SW5F7yr+BUmvcruGK7QcRMj4E99qkjqwTBZGm703z1PFKPYWV
         fU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mjj9/ZURjjtGQaz2LLl2krlBnNho3fyEfvR2R+fnkyk=;
        b=Q7ZrsYsSv8nFNGO+FkoJJmveYzJvxSYw0M8n9bOZEGo+XMRPkdhq2KVfTe+ta0rayk
         Cz+YkHnC6JtDd+UVV98CVFdUu5/Bh7Nngr1gKY5vGQ2xvy5H70sCMbIacCBALvWmFPUh
         8XOZTMj7OlQy7zUT0SKwWgCNqFicxU1908RO13iuoU8v9sGTH1jL0vW7kMLyu9DZquHl
         Vfm6PZkgzLIhp5P8FUiIo/DJi1RzKh6M/awXCrHDYWlQdYVCMcNt2osgkak9JSf452ky
         7xSQUxHE4Mrk6w+vB+tYGHVd01XfBKokjX+uiw5DGtC1V8d+mw26ZlVoH0nRp16tlm/k
         7oJw==
X-Gm-Message-State: AOAM532+3Z5BiS25xQNfRCq5cyFpdzXwK8SY41fcsVb1l9Sp1uwLyocF
        Jxyto60r5OEvMdS5ow6GfbIYXp1QZC8=
X-Google-Smtp-Source: ABdhPJxetHGB4V+UPVW7WLQKsn2PTcz1+SOcEmT+cqxyd2F8wg7N+PKJyvCJRL8FQa0pqjwk4Zbwsa8b0eQ=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr276931pjb.1.1650351487187; Mon, 18 Apr
 2022 23:58:07 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:44 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-39-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 38/38] KVM: arm64: selftests: Test breakpoint/watchpoint
 changing ID_AA64DFR0_EL1
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

Add test cases that uses every breakpoint/watchpoint with various
combination of ID_AA64DFR0_EL1.BRPs, WRPs, and CTX_CMPs
configuration to the debug-exceptions test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 52 ++++++++++++++++---
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 829fad6c7d58..d8ebbb7985da 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -701,18 +701,19 @@ static void check_debug_regs(struct kvm_vm *vm, uint32_t vcpu,
 	}
 }
 
-void run_test(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
+void run_test(uint64_t aa64dfr0, uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
-	uint64_t aa64dfr0;
 	uint8_t nbps, nwps;
 	bool debug_reg_test = false;
 
-	pr_debug("%s bpn:%d, wpn:%d, ctx_bpn:%d\n", __func__, bpn, wpn, ctx_bpn);
-
+	pr_debug("%s aa64dfr0:0x%lx, bpn:%d, wpn:%d, ctx_bpn:%d\n", __func__,
+		 aa64dfr0, bpn, wpn, ctx_bpn);
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	set_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), aa64dfr0);
+
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
@@ -810,15 +811,33 @@ void test_debug(uint64_t aa64dfr0)
 	for (c = ctx_brp_base; c < ctx_brp_base + ctx_brp_num; c++) {
 		for (b = 0; b < normal_brp_num; b++) {
 			for (w = 0; w < wrp_num; w++)
-				run_test(b, w, c);
+				run_test(aa64dfr0, b, w, c);
 		}
 	}
 }
 
+uint64_t update_aa64dfr0_bwrp(uint64_t dfr0, uint8_t brps, uint8_t wrps,
+			      uint8_t ctx_brps)
+{
+	/* Clear brps/wrps/ctx_cmps fields */
+	dfr0 &= ~(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS) |
+		  ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS) |
+		  ARM64_FEATURE_MASK(ID_AA64DFR0_CTX_CMPS));
+
+	/* Set new brps/wrps/ctx_cmps fields */
+	dfr0 |= ((uint64_t)brps << ID_AA64DFR0_BRPS_SHIFT) |
+		((uint64_t)wrps << ID_AA64DFR0_WRPS_SHIFT) |
+		((uint64_t)ctx_brps << ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	return dfr0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	uint64_t aa64dfr0;
+	uint64_t aa64dfr0, test_aa64dfr0;
+	uint8_t max_brps, max_wrps, max_ctx_brps;
+	int bs, ws, cs;
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
@@ -831,5 +850,26 @@ int main(int argc, char *argv[])
 
 	/* Run debug tests with the default configuration */
 	test_debug(aa64dfr0);
+
+	if (!kvm_check_cap(KVM_CAP_ARM_ID_REG_CONFIGURABLE))
+		return 0;
+
+	/*
+	 * Run debug tests with various number of breakpoints/watchpoints
+	 * configuration.
+	 */
+	max_brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	max_wrps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	max_ctx_brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_CTX_CMPS_SHIFT);
+	for (cs = 0; cs <= max_ctx_brps; cs++) {
+		for (bs = cs + 1; bs <= max_brps; bs++) {
+			for (ws = 1; ws <= max_wrps; ws++) {
+				test_aa64dfr0 = update_aa64dfr0_bwrp(aa64dfr0,
+								    bs, ws, cs);
+				test_debug(test_aa64dfr0);
+			}
+		}
+	}
+
 	return 0;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

