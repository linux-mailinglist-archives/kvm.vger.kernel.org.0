Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E1012E38
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfECMq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:57 -0400
Received: from foss.arm.com ([217.140.101.70]:60810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbfECMq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E7411682;
        Fri,  3 May 2019 05:46:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9E5C3F220;
        Fri,  3 May 2019 05:46:52 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 38/56] KVM: arm64/sve: Explain validity checks in set_sve_vls()
Date:   Fri,  3 May 2019 13:44:09 +0100
Message-Id: <20190503124427.190206-39-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Correct virtualization of SVE relies for correctness on code in
set_sve_vls() that verifies consistency between the set of vector
lengths requested by userspace and the set of vector lengths
available on the host.

However, the purpose of this code is not obvious, and not likely to
be apparent at all to people who do not have detailed knowledge of
the SVE system-level architecture.

This patch adds a suitable comment to explain what these checks are
for.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5bb909c3ff7c..3ae2f82fca46 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -264,6 +264,13 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
 		return -EINVAL;
 
+	/*
+	 * Vector lengths supported by the host can't currently be
+	 * hidden from the guest individually: instead we can only set a
+	 * maxmium via ZCR_EL2.LEN.  So, make sure the available vector
+	 * lengths match the set requested exactly up to the requested
+	 * maximum:
+	 */
 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
 		if (vq_present(&vqs, vq) != sve_vq_available(vq))
 			return -EINVAL;
-- 
2.20.1

