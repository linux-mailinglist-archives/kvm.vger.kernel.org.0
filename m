Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C17203169
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgFVIHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgFVIGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:06:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4472083E;
        Mon, 22 Jun 2020 08:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813214;
        bh=ImUQBlLW57suQ3KIKHAaNJSiF8oTValBlw7IMxbIgqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWJW+sluR2X5pfiMN+1jKheEHMkDwH/kjkz5t4ychMdOXJf/a3DrL0/74NRq7LN4L
         CPQ+o9rnwUcNwjquDQbGNM9Ic8rb480uKcv8NJ2hxsNZ5GdY0lqosDj+f4YR3yUYbr
         53LR2+IrH/DCaVSawhrUwi3LcE32A9Jw+cfriVhE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnHTh-005FG8-5t; Mon, 22 Jun 2020 09:06:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: [PATCH v2 3/5] KVM: arm64: Allow PtrAuth to be enabled from userspace on non-VHE systems
Date:   Mon, 22 Jun 2020 09:06:41 +0100
Message-Id: <20200622080643.171651-4-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622080643.171651-1-maz@kernel.org>
References: <20200622080643.171651-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the scene is set for enabling PtrAuth on non-VHE, drop
the restrictions preventing userspace from enabling it.

Acked-by: Andrew Scull <ascull@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d3b209023727..2a929789fe2e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -42,6 +42,11 @@ static u32 kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
+static bool system_has_full_ptr_auth(void)
+{
+	return system_supports_address_auth() && system_supports_generic_auth();
+}
+
 /**
  * kvm_arch_vm_ioctl_check_extension
  *
@@ -80,8 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
-		r = has_vhe() && system_supports_address_auth() &&
-				 system_supports_generic_auth();
+		r = system_has_full_ptr_auth();
 		break;
 	default:
 		r = 0;
@@ -205,19 +209,14 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 {
-	/* Support ptrauth only if the system supports these capabilities. */
-	if (!has_vhe())
-		return -EINVAL;
-
-	if (!system_supports_address_auth() ||
-	    !system_supports_generic_auth())
-		return -EINVAL;
 	/*
 	 * For now make sure that both address/generic pointer authentication
-	 * features are requested by the userspace together.
+	 * features are requested by the userspace together and the system
+	 * supports these capabilities.
 	 */
 	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
+	    !system_has_full_ptr_auth())
 		return -EINVAL;
 
 	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
-- 
2.27.0

