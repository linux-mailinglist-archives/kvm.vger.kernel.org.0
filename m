Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EED847FCBE
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhL0MtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 07:49:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhL0Ms7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 07:48:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 244E360FFE
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEDFC36AEC;
        Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640609338;
        bh=cHscWp4G/jl7OECVB+Mfa/3Bnvj2ZaQdD9wuk1X3jGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLyBnrljutIW1XfGOL3uI7ocst4+hxWtTw47ipwPYvc5sdPwkuqIYNBqlPsFi6+wN
         DO1DrUMmzh4/NXOfHV2Vinx9tzbR8uCkUzKbp8M+ofFR/IbchEsJlrG6m7GwjgLkvG
         EpgmaSHZ4NMTYTFHKcgrkNeuz6W95R8mxe8vf007Qt31i4JM8ZiZ0XZA06NurEQf2g
         SGnw5bUxtgrXlHpOrRYM6sVOxmc2f6zS7MEjTKYPVT/X19XdaReUhfJDXKRLHmRu8i
         ExhKdNBEoseuXuoLhy7963cIh2SuuwfnHDgT3HQ4TKt8t+cVMvvlEOGNxtaX7q8qsx
         4vh1m3Nf9P31w==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1pQu-00EYBY-O3; Mon, 27 Dec 2021 12:48:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH v2 4/6] KVM: selftests: arm64: Rework TCR_EL1 configuration
Date:   Mon, 27 Dec 2021 12:48:07 +0000
Message-Id: <20211227124809.1335409-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current way we initialise TCR_EL1 is a bit cumbersome, as
we mix setting TG0 and IPS in the same swtch statement.

Split it into two statements (one for the base granule size, and
another for the IPA size), allowing new modes to be added in a
more elegant way.

No functional change intended.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 49fcfe9768e0..d005543aa3e2 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -238,6 +238,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &sctlr_el1);
 	get_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), &tcr_el1);
 
+	/* Configure base granule size */
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
 		TEST_FAIL("AArch64 does not support 4K sized pages "
@@ -246,23 +247,29 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 		TEST_FAIL("AArch64 does not support 4K sized pages "
 			  "with ANY-bit physical address ranges");
 	case VM_MODE_P52V48_64K:
+	case VM_MODE_P48V48_64K:
+	case VM_MODE_P40V48_64K:
 		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
-		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
 		break;
 	case VM_MODE_P48V48_4K:
+	case VM_MODE_P40V48_4K:
 		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
-		tcr_el1 |= 5ul << 32; /* IPS = 48 bits */
 		break;
+	default:
+		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
+	}
+
+	/* Configure output size */
+	switch (vm->mode) {
+	case VM_MODE_P52V48_64K:
+		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
+		break;
+	case VM_MODE_P48V48_4K:
 	case VM_MODE_P48V48_64K:
-		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		tcr_el1 |= 5ul << 32; /* IPS = 48 bits */
 		break;
 	case VM_MODE_P40V48_4K:
-		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
-		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
-		break;
 	case VM_MODE_P40V48_64K:
-		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
 		break;
 	default:
-- 
2.30.2

