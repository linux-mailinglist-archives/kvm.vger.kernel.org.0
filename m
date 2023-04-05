Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BCC6D822B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbjDEPlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238910AbjDEPlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5340F6A7B
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91B9D63ED0
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0504CC433EF;
        Wed,  5 Apr 2023 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709248;
        bh=Qp6MCbgjyeYLqXhzPsD/TLmpoZonoNw49Oh0VFywzgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Og1BlC6r7OnttGkUFyEf3L+9qSEDXVHlH2SUhGdme0H/H24l8TAvHPMVolnLH8PN3
         CdhW9C4TDAYFAPeBYBoH43CBu6y0baneJFPHYBAcNJSFOQS1hy1GXCi3diwcDHkSDW
         7V6FT6oOk5jwCdNoLQj/0aCaGU6OvjDS6Je/J5GHNH/ylZJig9xkcLHjJaJKlU5c+R
         4DNfgPNMSFrogxMJeZoGUFNgmQTemFiQLVxe6KrMTauJ2Dpag8oiRfiTxTQyUi8S72
         HHCBDt2PezWKVCgY85Pn1wIpStV4afikdJzFN2O5BPALspmRrsp7STJqB5jdUVujcp
         yuWkWeuy4zFWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5FX-0062PV-UG;
        Wed, 05 Apr 2023 16:40:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 34/50] KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
Date:   Wed,  5 Apr 2023 16:39:52 +0100
Message-Id: <20230405154008.3552854-35-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we're (almost) feature complete, let's allow userspace to
request KVM_ARM_VCPU_NESTED_VIRT by bumping the KVM_VCPU_MAX_FEATURES
up. We also now advertise the feature to userspace with a new capability.

It's going to be great...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 3 +++
 include/uapi/linux/kvm.h          | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1b3902d2470f..03268d444801 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -37,7 +37,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 8
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e4a77fe1cfa4..6af9fdf9b44d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -272,6 +272,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_const_cap(ARM64_HAS_32BIT_EL1);
 		break;
+	case KVM_CAP_ARM_EL2:
+		r = cpus_have_const_cap(ARM64_HAS_NESTED_VIRT);
+		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = get_num_brps();
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6a7e1a0ecf04..70ac878cf99f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1185,6 +1185,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
+#define KVM_CAP_ARM_EL2 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1

