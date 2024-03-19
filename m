Return-Path: <kvm+bounces-12135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E171B87FE61
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAD50B22399
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7578F82886;
	Tue, 19 Mar 2024 13:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qe59vEfy"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB9081727;
	Tue, 19 Mar 2024 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853815; cv=none; b=hq277N6pHN+Cjwa88p3p53vMNXgQ6AXdh2Cb9g0u20KMQTQh3XYLGTL5BgRPe4KeMOIrwkh2qeNF817uaUYO0NJqhjtntwScIA8BQDG5wGalG6QcEDkJYvoeKF5R9cFYWjWh6cg0wFj8XC1Ogmafvsizyw+4DnwTxGwbVdbxczo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853815; c=relaxed/simple;
	bh=2UaxaJdxQ3fwEDx6b3vxPqEwTgxUhZqVXdbgubPR4Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i61/ozyYDQp9snz9yTcSQKVQ/C8x+LNFZ1GrfHNzBy4Aq6raIai3sSisKNVBdnb6lScoBF7JwSvf/m74gnD+61vQ4yCBbC6/2+7owk4/xSmS6OBFVuz+kaAKv5h7RdvtSmpgoXOHHEIh/qyo1V+UwugpLYBUdb+z/A37IHJScKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qe59vEfy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gextfsg6+axAOOI5Q/vPLc1swsmolk11VUfz1aNL728=; b=qe59vEfyF2X2pAJ/UxqyBl2VB0
	rLoKiMCsI2Wi3RGvpHvWx1CtZ+KsnvjNyDMizDRQBvfhFbs6akWxts76Di8g12dWr7tplS/ZhpMuh
	wGTrBXpoSiB9dkSQ1FuMjf8lKoTt9/lQlKCGezETSGfp3lIzbGhoFbdNlq4K2XND2SbNnc8YqZtR1
	4Uea2VfGbQ8RTsZQTBLk/qBUyUWwI0m8k9Mnb4/Crxlo/H7QLLGg2X6Oa6hLB4oibJZv/z0suEUBy
	EhL0k/9wQVyNqZyxz4GfgOtc74eDlwAE53P31fMYITrY/Y/EWnysfWxWy+99Xt114+x8daWYrg+PW
	XT9n9AOA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE9-00000001zLT-1ZF8;
	Tue, 19 Mar 2024 13:10:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE8-00000004PMu-43k6;
	Tue, 19 Mar 2024 13:10:00 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH v3 2/5] KVM: arm64: Add support for PSCI v1.2 and v1.3
Date: Tue, 19 Mar 2024 12:59:03 +0000
Message-ID: <20240319130957.1050637-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240319130957.1050637-1-dwmw2@infradead.org>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Since the v1.3 specification is still in Alpha, only default to v1.2
unless userspace explicitly requests v1.3 for now.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/arm64/kvm/hypercalls.c | 2 ++
 arch/arm64/kvm/psci.c       | 6 +++++-
 include/kvm/arm_psci.h      | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5763d979d8ca..9c6267ca2b82 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -575,6 +575,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		case KVM_ARM_PSCI_0_2:
 		case KVM_ARM_PSCI_1_0:
 		case KVM_ARM_PSCI_1_1:
+		case KVM_ARM_PSCI_1_2:
+		case KVM_ARM_PSCI_1_3:
 			if (!wants_02)
 				return -EINVAL;
 			vcpu->kvm->arch.psci_version = val;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..f689ef3f2f10 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -322,7 +322,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
-		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
+		val = PSCI_VERSION(1, minor);
 		break;
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		arg = smccc_get_arg1(vcpu);
@@ -449,6 +449,10 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 	}
 
 	switch (version) {
+	case KVM_ARM_PSCI_1_3:
+		return kvm_psci_1_x_call(vcpu, 3);
+	case KVM_ARM_PSCI_1_2:
+		return kvm_psci_1_x_call(vcpu, 2);
 	case KVM_ARM_PSCI_1_1:
 		return kvm_psci_1_x_call(vcpu, 1);
 	case KVM_ARM_PSCI_1_0:
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index e8fb624013d1..ebd7d9a12790 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -14,8 +14,10 @@
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
 #define KVM_ARM_PSCI_1_1	PSCI_VERSION(1, 1)
+#define KVM_ARM_PSCI_1_2	PSCI_VERSION(1, 2)
+#define KVM_ARM_PSCI_1_3	PSCI_VERSION(1, 3)
 
-#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_1
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_2 /* v1.3 is still Alpha */
 
 static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
-- 
2.44.0


