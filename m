Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFDE1BA60C
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgD0OP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgD0OP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 10:15:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C80206B6;
        Mon, 27 Apr 2020 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587996925;
        bh=f3vNbHktBCG4AIFM+J82uH7K2+5LPw+EtC296Bu7NO0=;
        h=From:To:Cc:Subject:Date:From;
        b=Z/9qBzOa7bnNJb/C7CIh3o/YKWthaFBmAhRQGNXDUjhmjzuX8ZNXzLGvEXi/+VJHr
         ofw+c6RwQa0n1TGST9hROO4SS6UMkI/ZszR8RcTaZIpHuY8FO8MdYnoy+4To4WZLi7
         jQ+Lk+a609ihrGU1sX04c/rNqhwAMT/xOiBE6eAU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jT4Xb-006kbg-O7; Mon, 27 Apr 2020 15:15:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] KVM: arm64: Make KVM_CAP_MAX_VCPUS compatible with the selected GIC version
Date:   Mon, 27 Apr 2020 15:15:07 +0100
Message-Id: <20200427141507.284985-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_MAX_VCPUS always return the maximum possible number of
VCPUs, irrespective of the selected interrupt controller. This
is pretty misleading for userspace that selects a GICv2 on a GICv3
system that supports v2 compat: It always gets a maximum of 512
VCPUs, even if the effective limit is 8. The 9th VCPU will fail
to be created, which is unexpected as far as userspace is concerned.

Fortunately, we already have the right information stashed in the
kvm structure, and we can return it as requested.

Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/arm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77..f9b0528f7305 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -95,6 +95,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_arm_default_max_vcpus(void)
+{
+	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -128,8 +133,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.vmid.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = vgic_present ?
-				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
+	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	return ret;
 out_free_stage2_pgd:
@@ -204,10 +208,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = num_online_cpus();
 		break;
 	case KVM_CAP_MAX_VCPUS:
-		r = KVM_MAX_VCPUS;
-		break;
 	case KVM_CAP_MAX_VCPU_ID:
-		r = KVM_MAX_VCPU_ID;
+		if (kvm)
+			r = kvm->arch.max_vcpus;
+		else
+			r = kvm_arm_default_max_vcpus();
 		break;
 	case KVM_CAP_MSI_DEVID:
 		if (!kvm)
-- 
2.26.2

