Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FEE67E3CB
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbjA0LmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbjA0Llp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:45 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00A527AE7F;
        Fri, 27 Jan 2023 03:41:10 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B9CB1762;
        Fri, 27 Jan 2023 03:41:39 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B8BF43F8D6;
        Fri, 27 Jan 2023 03:40:54 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 24/31] arm64: Don't try to debug a realm
Date:   Fri, 27 Jan 2023 11:39:25 +0000
Message-Id: <20230127113932.166089-25-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Don't read the register values for a running realm, because they don't
reflect the actual hardware state of a realm. And don't try to read realm
memory, because that will promptly lead to kvmtool being killed.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm-cpu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 32fa7609..a29a3413 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -250,6 +250,9 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 
 	reg.addr = (u64)&data;
 
+	if (vcpu->kvm->cfg.arch.is_realm)
+		return;
+
 	dprintf(debug_fd, "\n*pc:\n");
 	reg.id = ARM64_CORE_REG(regs.pc);
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
@@ -274,6 +277,11 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 	reg.addr = (u64)&data;
 	dprintf(debug_fd, "\n Registers:\n");
 
+	if (vcpu->kvm->cfg.arch.is_realm) {
+		dprintf(debug_fd, " UNACCESSIBLE\n");
+		return;
+	}
+
 	reg.id		= ARM64_CORE_REG(regs.pc);
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
 		die("KVM_GET_ONE_REG failed (pc)");
-- 
2.34.1

