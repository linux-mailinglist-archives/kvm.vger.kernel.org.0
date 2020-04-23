Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D954F1B5F9D
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgDWPkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgDWPke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:40:34 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE45D2098B;
        Thu, 23 Apr 2020 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587656433;
        bh=CIXHIahjDbc587eXthk0nO1gMmcVN64S03rXwMxNHH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDD0613fVGtdApwkST1M9cLjbjl/aoz9db2wLuf+GQYIHQMrLNTHPlc6xJsPG0pEh
         NVf0O8V60MfOY1/gc1McHsEyag46DKQo6hoEa99quAJjc5bEoTNqIwrG6SQ4GsePNQ
         5pr6g38ePVWopRaosVX9Rv4rZfAspPzMVitIshxs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRdxo-005oPM-5k; Thu, 23 Apr 2020 16:40:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Grall <julien@xen.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/8] KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
Date:   Thu, 23 Apr 2020 16:40:04 +0100
Message-Id: <20200423154009.4113562-4-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200423154009.4113562-1-maz@kernel.org>
References: <20200423154009.4113562-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implementing (and even advertising) 64bit PSCI functions to 32bit
guests is at least a bit odd, if not altogether violating the
spec which says ("5.2.1 Register usage in arguments and return values"):

"Adherence to the SMC Calling Conventions implies that any AArch32
caller of an SMC64 function will get a return code of 0xFFFFFFFF(int32).
This matches the NOT_SUPPORTED error code used in PSCI"

Tighten the implementation by pretending these functions are not
there for 32bit guests.

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/psci.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 3772717efe3e5..ae364716ee40c 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -198,6 +198,21 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
 }
 
+static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
+{
+	switch(fn) {
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_ON:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+		/* Disallow these functions for 32bit guests */
+		if (vcpu_mode_is_32bit(vcpu))
+			return PSCI_RET_NOT_SUPPORTED;
+		break;
+	}
+
+	return 0;
+}
+
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -205,6 +220,10 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int ret = 1;
 
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val)
+		goto out;
+
 	switch (psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		/*
@@ -272,6 +291,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
+out:
 	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
@@ -289,6 +309,10 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		break;
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		feature = smccc_get_arg1(vcpu);
+		val = kvm_psci_check_allowed_function(vcpu, feature);
+		if (val)
+			break;
+
 		switch(feature) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
-- 
2.26.2

