Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906661E82EB
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgE2QDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgE2QDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:03:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA2520814;
        Fri, 29 May 2020 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768215;
        bh=R6r5GkOAL3ZO4KyBEEK8jowTrzETCOs0VNAKSknUigQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcnFoBNwGYCJ+0cE90hlmpyIwlOlpZaPDciH/QNLFsc1+flwoV/cQk/HDFiJFGepP
         WqXA+2j9c57PBLjwtboHBVxaCOh1+BEbDsdNpaIY5AhiSMJ4HnP3ykzcRHWnM0qFg1
         OX1N/2u4YrzwnVbKzPSL5qKb6ujntP0wwHZW8+W4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehSD-00GJKc-Nk; Fri, 29 May 2020 17:01:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jiang Yi <giangyi@amazon.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 14/24] KVM: arm64: Make KVM_CAP_MAX_VCPUS compatible with the selected GIC version
Date:   Fri, 29 May 2020 17:01:11 +0100
Message-Id: <20200529160121.899083-15-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com, dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com, zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20200427141507.284985-1-maz@kernel.org
---
 arch/arm64/kvm/arm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0ea9a0266d9a..e01d44df98df 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
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

