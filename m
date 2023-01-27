Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71BB67E3D9
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjA0Lmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbjA0LmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:42:02 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22E837B418;
        Fri, 27 Jan 2023 03:41:30 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC9DC1688;
        Fri, 27 Jan 2023 03:41:53 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 14CAB3F64C;
        Fri, 27 Jan 2023 03:41:08 -0800 (PST)
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
        linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>
Subject: [RFC kvmtool 29/31] mmio: add arch hook for an unhandled MMIO access
Date:   Fri, 27 Jan 2023 11:39:30 +0000
Message-Id: <20230127113932.166089-30-suzuki.poulose@arm.com>
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

From: Joey Gouly <joey.gouly@arm.com>

Add a hook that allows an architecture to run some code on an
unhandled MMIO access.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/kvm-cpu.c         | 4 ++++
 include/kvm/kvm-cpu.h | 2 ++
 mips/kvm-cpu.c        | 4 ++++
 mmio.c                | 3 +++
 powerpc/kvm-cpu.c     | 4 ++++
 riscv/kvm-cpu.c       | 4 ++++
 x86/kvm-cpu.c         | 4 ++++
 7 files changed, 25 insertions(+)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 98bc5fdf..90a15ae9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -152,3 +152,7 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
+
+void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *vcpu)
+{
+}
diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d6..d0c40598 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -29,4 +29,6 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
 void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
 
+void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *cpu);
+
 #endif /* KVM__KVM_CPU_H */
diff --git a/mips/kvm-cpu.c b/mips/kvm-cpu.c
index 30a3de18..0ce88ac3 100644
--- a/mips/kvm-cpu.c
+++ b/mips/kvm-cpu.c
@@ -217,3 +217,7 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
+
+void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *cpu)
+{
+}
diff --git a/mmio.c b/mmio.c
index 5a114e99..7e31079b 100644
--- a/mmio.c
+++ b/mmio.c
@@ -206,6 +206,9 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
 			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
 				to_direction(is_write),
 				(unsigned long long)phys_addr, len);
+
+		kvm_cpu__arch_unhandled_mmio(vcpu);
+
 		goto out;
 	}
 
diff --git a/powerpc/kvm-cpu.c b/powerpc/kvm-cpu.c
index 461e0a90..e0c20f9d 100644
--- a/powerpc/kvm-cpu.c
+++ b/powerpc/kvm-cpu.c
@@ -288,3 +288,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 	/* Does nothing yet */
 }
+
+void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *cpu)
+{
+}
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index f98bd7ae..8417e361 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -461,3 +461,7 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 
 	kvm_cpu__show_csrs(vcpu);
 }
+
+void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *cpu)
+{
+}
diff --git a/x86/kvm-cpu.c b/x86/kvm-cpu.c
index b02ff65e..ac075ee4 100644
--- a/x86/kvm-cpu.c
+++ b/x86/kvm-cpu.c
@@ -444,3 +444,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
 
 	ioctl(cpu->vcpu_fd, KVM_NMI);
 }
+
+void kvm_cpu__arch_unhandled_mmio(struct kvm_cpu *cpu)
+{
+}
-- 
2.34.1

