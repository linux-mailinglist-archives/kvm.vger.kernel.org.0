Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8863D67E3B2
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjA0Ll0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbjA0LlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19C1C20D28;
        Fri, 27 Jan 2023 03:40:43 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62808169E;
        Fri, 27 Jan 2023 03:40:59 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D96673F64C;
        Fri, 27 Jan 2023 03:40:14 -0800 (PST)
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
Subject: [RFC kvmtool 10/31] arm64: Create a realm virtual machine
Date:   Fri, 27 Jan 2023 11:39:11 +0000
Message-Id: <20230127113932.166089-11-suzuki.poulose@arm.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Set the machine type to realm when creating a VM via the KVM_CREATE_VM
ioctl.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[ Alex E: Reworked patch, split the command line option into a different
          patch ]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 25be2f2d..5db4c572 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -131,12 +131,15 @@ int kvm__arch_get_ipa_limit(struct kvm *kvm)
 int kvm__get_vm_type(struct kvm *kvm)
 {
 	unsigned int ipa_bits, max_ipa_bits;
-	unsigned long max_ipa;
+	unsigned long max_ipa, vm_type;
 
-	/* If we're running on an old kernel, use 0 as the VM type */
+	vm_type = kvm->cfg.arch.is_realm ? \
+		  KVM_VM_TYPE_ARM_REALM : KVM_VM_TYPE_ARM_NORMAL;
+
+	/* If we're running on an old kernel, use 0 as the IPA bits */
 	max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
 	if (!max_ipa_bits)
-		return 0;
+		return vm_type;
 
 	/* Otherwise, compute the minimal required IPA size */
 	max_ipa = kvm->cfg.ram_addr + kvm->cfg.ram_size - 1;
@@ -147,7 +150,8 @@ int kvm__get_vm_type(struct kvm *kvm)
 	if (ipa_bits > max_ipa_bits)
 		die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
 
-	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
+	vm_type |= KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
+	return vm_type;
 }
 
 void kvm__arch_enable_mte(struct kvm *kvm)
-- 
2.34.1

