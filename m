Return-Path: <kvm+bounces-38310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C1E5A36FDD
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 503E6170762
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22651FDA9D;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlJ8LWvq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7081FC109;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641104; cv=none; b=ke8d75J9P39PS1N92uHW4MysZHp6Hz7qUjgnWM8pVLcsBHIuqlLg9dNEUHdmQAJKJijR6/vx0dI15cfBCo3g3tYomeItpQP6tP7c4P1rIxgdnQuZ4+6vD34baarNw08dVA1x3i5mwLoECXuAjd14/kvi0ByS3oMvPa1tlLF4jRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641104; c=relaxed/simple;
	bh=CL/9quSdT/4WkdKxdC8OB8oLAC8r+jS/LhcwV8O3nUI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=daEwodrTSaWRyUq90O5PALsUy/IRlGMgz4xcGjEoXQVBRE8t89jf1l5UJ+5/2FguFS9+134V1V2FnaSkwrhuTg+YIAtun4zWuW3WWdidbqCqYmjwQgTt8vGXXZq5x071zac9wPcofsJ0X/wOk0PPNX6najs9tQHL4iAyqjatPI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlJ8LWvq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892FFC4CEEA;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641104;
	bh=CL/9quSdT/4WkdKxdC8OB8oLAC8r+jS/LhcwV8O3nUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlJ8LWvqArerfAe90+kHAHuKR6bt2MdYr7xQ/Gdc/JZ3fT5Ij2ed5s0lc3GiTqIWV
	 0PGwBCEvfzr2ciN4y1097VWGswxGwvnyO5jKNZRHL7KOf7WleH0DbgGRZIBknBQBmm
	 CLMqvzsTaOcyc+Owkde7sXUmFLqTsBjCTuZOtjjRm71OmMHyl/jtPk8VMtCZB+rqy7
	 lg0FQMeV0cOon680vQ3YRCtcTO8V9zfYwF09MlBrgXISBSfHoYEvX/C7lpVQPneByt
	 Cthq96XVcagSESNDsXhgk5KcRoluw/vJvvm9FyNbOmWwxSy/OT9w3j0z1wjnK5QxMJ
	 d9UfoW759E2lg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7S-004Pqp-QH;
	Sat, 15 Feb 2025 17:38:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 13/14] KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
Date: Sat, 15 Feb 2025 17:38:15 +0000
Message-Id: <20250215173816.3767330-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we're (almost) feature complete, let's allow userspace to
request KVM_ARM_VCPU_EL2* by bumping KVM_VCPU_MAX_FEATURES up.

We also now advertise the features to userspace with a new capabilities.

It's going to be great...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 6 ++++++
 include/uapi/linux/kvm.h          | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e34..2a9ab9abf0f81 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 9
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4746c6cace2a8..6554379cdcada 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -359,6 +359,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
 		break;
+	case KVM_CAP_ARM_EL2:
+		r = cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
+		break;
+	case KVM_CAP_ARM_EL2_E2H0:
+		r = cpus_have_final_cap(ARM64_HAS_HCR_NV1);
+		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = get_num_brps();
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b99..9a6674f51b8be 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_EL2 239
+#define KVM_CAP_ARM_EL2_E2H0 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.39.2


