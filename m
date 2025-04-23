Return-Path: <kvm+bounces-43965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E8CA99159
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EFE11B86727
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4717829B238;
	Wed, 23 Apr 2025 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXq58Bia"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA1129B202;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421319; cv=none; b=lM2MPTau9YLdwWEiBkKH0+aaTA1wmPGZMU9qdbnpTTYoHQGeuwQkI5XEyp6p+zwdFVmRaIXpJmONMLVadX5FKkqESTVBsNesix68YD1chaSYkqt4jGJCqNv1maIDr/E0yTe/tEta7Yo7ut00L/1wnD7YTluxnsIuhzSupg3yJ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421319; c=relaxed/simple;
	bh=vh1PnLqh01yaQsVDCDR6nY6QiSEdl+vmMW6IVytRf4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=edOSLnE7TGjFqx1KtLYN29r8+0rBXikYNVsZ/yzxdxKFkh8zmHuzTdpCmnV7pOD88XFI+TiLDiH+4orHlAdrwU/rIePNSMwpt0LThLoK+DByhpCeuqu+gPKEjoLgp0Erf/xThPby44fi/QqQItzlcwGujUR0EAAfZIXYMk6lxSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXq58Bia; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C45C4CEE8;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421319;
	bh=vh1PnLqh01yaQsVDCDR6nY6QiSEdl+vmMW6IVytRf4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXq58BiaeHuHcYkXy2TrN3uZJx828j7ij85yauKViWvJtYw4CM0Ib/HkOml0OTgI2
	 hO/glg8Bkn0FBe+TpQk5IWb/Uw8biu126H1vEqObcAPqxDjaT7DqW47gbNoPev8Mrc
	 YTqlRL+C9PIAO+/BhONdyeSbPkK0sjZy8eyv1dh+EXD7l/HVXzVl3ahkAiTz92v/ty
	 Wk+O3VM4GPmNn8W8KJeI8d8p6YoFtIt0ua4ksC4z/WVun+dt93HL+XXIK8JofV0VKH
	 /s9QBk3xqbWOwPklo1xdwljlptOCP//4lSmeiiaFMqD8teV3wMLVaZd9JMzT7VQ/B3
	 zXtRXj+lg3dxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7boj-0082xr-9u;
	Wed, 23 Apr 2025 16:15:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 16/17] KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
Date: Wed, 23 Apr 2025 16:15:07 +0100
Message-Id: <20250423151508.2961768-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we're (almost) feature complete, let's allow userspace to
request KVM_ARM_VCPU_EL2* by bumping KVM_VCPU_MAX_FEATURES up.

We also now advertise the features to userspace with new capabilities.

It's going to be great...

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 6 ++++++
 include/uapi/linux/kvm.h          | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b2c535036a06b..79e175a16d356 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 9
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5287435873609..b021ce1e42c5c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -368,6 +368,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
index b6ae8ad8934b5..c9d4a908976e8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -930,6 +930,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_ARM_EL2 240
+#define KVM_CAP_ARM_EL2_E2H0 241
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.39.2


