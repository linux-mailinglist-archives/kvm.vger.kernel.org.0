Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988531E82D1
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgE2QBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbgE2QBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:01:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38A1207F9;
        Fri, 29 May 2020 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768110;
        bh=KUg14+CaJZ9AWk7EfYjAKCvGH6MwQ8/GM6yO+OJnz2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU0ZVT5bQTXNPcH/tNLx+E/sIBFGAHakUFGO27I9qF638KtmUb+kEQHH5rZJGDbnL
         ZB2959WiGax5gp4wQEnlrIC4oUjBwVCZPpw7FgrDBuZdb3Yn+mtk114WBD9S5TxuiG
         cRv+1Gyb4qs2RHxmFGuSjy5Ml5m5c6+0z4RdTxAo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehS8-00GJKc-CJ; Fri, 29 May 2020 17:01:48 +0100
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
Subject: [PATCH 09/24] KVM: arm64: Sidestep stage2_unmap_vm() on vcpu reset when S2FWB is supported
Date:   Fri, 29 May 2020 17:01:06 +0100
Message-Id: <20200529160121.899083-10-maz@kernel.org>
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

From: Zenghui Yu <yuzenghui@huawei.com>

stage2_unmap_vm() was introduced to unmap user RAM region in the stage2
page table to make the caches coherent. E.g., a guest reboot with stage1
MMU disabled will access memory using non-cacheable attributes. If the
RAM and caches are not coherent at this stage, some evicted dirty cache
line may go and corrupt guest data in RAM.

Since ARMv8.4, S2FWB feature is mandatory and KVM will take advantage
of it to configure the stage2 page table and the attributes of memory
access. So we ensure that guests always access memory using cacheable
attributes and thus, the caches always be coherent.

So on CPUs that support S2FWB, we can safely reset the vcpu without a
heavy stage2 unmapping.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200415072835.1164-1-yuzenghui@huawei.com
---
 arch/arm64/kvm/arm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ee1b5bba1d08..0ea9a0266d9a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -983,8 +983,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	/*
 	 * Ensure a rebooted VM will fault in RAM pages and detect if the
 	 * guest MMU is turned off and flush the caches as needed.
+	 *
+	 * S2FWB enforces all memory accesses to RAM being cacheable, we
+	 * ensure that the cache is always coherent.
 	 */
-	if (vcpu->arch.has_run_once)
+	if (vcpu->arch.has_run_once && !cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
 		stage2_unmap_vm(vcpu->kvm);
 
 	vcpu_reset_hcr(vcpu);
-- 
2.26.2

