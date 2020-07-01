Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BD3210D96
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbgGAOU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 10:20:27 -0400
Received: from foss.arm.com ([217.140.110.172]:44966 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731324AbgGAOU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 10:20:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60C5E30E;
        Wed,  1 Jul 2020 07:20:26 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2242C3F73C;
        Wed,  1 Jul 2020 07:20:24 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
Date:   Wed,  1 Jul 2020 15:20:02 +0100
Message-Id: <20200701142002.51654-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the host doesn't support 32bit guests, the kvmtool fails
without a proper message on what is wrong. i.e,

 $ lkvm run -c 1 Image --aarch32
  # lkvm run -k Image -m 256 -c 1 --name guest-105618
  Fatal: Unable to initialise vcpu

Given that there is no other easy way to check if the host supports 32bit
guests, it is always good to report this by checking the capability, rather
than leaving the users to hunt this down by looking at the code!

After this patch:

 $ lkvm run -c 1 Image --aarch32
  # lkvm run -k Image -m 256 -c 1 --name guest-105695
  Fatal: 32bit guests are not supported

Cc: Will Deacon <will@kernel.org>
Reported-by: Sami Mujawar <sami.mujawar@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/kvm-cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 554414f..2acecae 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -46,6 +46,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		.features = ARM_VCPU_FEATURE_FLAGS(kvm, cpu_id)
 	};
 
+	if (kvm->cfg.arch.aarch32_guest &&
+	    !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
+		die("32bit guests are not supported\n");
+
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
 	if (!vcpu)
 		return NULL;
-- 
2.24.1

