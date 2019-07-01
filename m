Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DFA4CCC9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFTLXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:23:14 -0400
Received: from foss.arm.com ([217.140.110.172]:60542 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfFTLXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:23:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7EA8C0A;
        Thu, 20 Jun 2019 04:23:12 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57FE23F718;
        Thu, 20 Jun 2019 04:23:11 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] KVM: arm64: Implement vq_present() as a macro
Date:   Thu, 20 Jun 2019 12:22:58 +0100
Message-Id: <20190620112301.138137-2-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190620112301.138137-1-marc.zyngier@arm.com>
References: <20190620112301.138137-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

This routine is a one-liner and doesn't really need to be function and
can be implemented as a macro.

Suggested-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3ae2f82fca46..ae734fcfd4ea 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -207,13 +207,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
 #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
-
-static bool vq_present(
-	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
-	unsigned int vq)
-{
-	return (*vqs)[vq_word(vq)] & vq_mask(vq);
-}
+#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
 
 static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
@@ -258,7 +252,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	max_vq = 0;
 	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
-		if (vq_present(&vqs, vq))
+		if (vq_present(vqs, vq))
 			max_vq = vq;
 
 	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
@@ -272,7 +266,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	 * maximum:
 	 */
 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
-		if (vq_present(&vqs, vq) != sve_vq_available(vq))
+		if (vq_present(vqs, vq) != sve_vq_available(vq))
 			return -EINVAL;
 
 	/* Can't run with no vector lengths at all: */
-- 
2.20.1

