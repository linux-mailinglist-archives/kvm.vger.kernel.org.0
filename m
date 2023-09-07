Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E770C7976B9
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbjIGQPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238593AbjIGQOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:14:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26F646B0
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:11:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13783C43142;
        Thu,  7 Sep 2023 10:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694081396;
        bh=TzyJtdWsmYBUToQcQ3+2crtixqGb2HnF6L3+Xtxg3ZE=;
        h=From:To:Cc:Subject:Date:From;
        b=Ruaez+JQVMgoAwlHuyAZOyhbC/bbmuwwu/IAD9ATO62Y4fFnt6VuXNmKqjVjVJMPR
         Dx3i9j2zUX1QEUyQd9Q/YzX5C3At86wNS9/QEhFLZJSylUWqTIfw8dMGvnM+Om+d6c
         6Uf33tiFmj1uMfgpwQkg9LwYI5w1CQH7JyVJGGVJJYzAtjuO/2ARn7uBtF6Tn+g5TN
         FAkxNavqwKJia5Dxzgd/68aAglOf3q5id86jNsHm6dObWah/RFAoYwPCkdyU9sjDmL
         HdksoKTGJB2iLUku3KnLRICyoGKJxJg9rqx0OOv8WNZjwXBXSUPKhsLR0WhJSTrfF4
         HP37rj7XWSthQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qeBxR-00B37Y-BN;
        Thu, 07 Sep 2023 11:09:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR values
Date:   Thu,  7 Sep 2023 11:09:26 +0100
Message-Id: <20230907100931.1186690-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, zhaoxu.35@bytedance.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xu Zhao recently reported[1] that sending SGIs on large VMs was slower
than expected, specially if targeting vcpus that have a high vcpu
index. They root-caused it to the way we walk the vcpu xarray in the
search of the correct MPIDR, one vcpu at a time, which is of course
grossly inefficient.

The solution they proposed was, unfortunately, less than ideal, but I
was "nerd snipped" into doing something about it.

The main idea is to build a small hash table of MPIDR to vcpu
mappings, using the fact that most of the time, the MPIDR values only
use a small number of significant bits and that we can easily compute
a compact index from it. Once we have that, accelerating vcpu lookup
becomes pretty cheap, and we can in turn make SGIs great again.

It must be noted that since the MPIDR values are controlled by
userspace, it isn't always possible to allocate the hash table
(userspace could build a 32 vcpu VM and allocate one bit of affinity
to each of them, making all the bits significant). We thus always have
an iterative fallback -- if it hurts, don't do that.

Performance wise, this is very significant: using the KUT micro-bench
test with the following patch (always IPI-ing the last vcpu of the VM)
and running it with large number of vcpus shows a large improvement
(from 3832ns to 2593ns for a 64 vcpu VM, a 32% reduction, measured on
an Ampere Altra). I expect that IPI-happy workloads could benefit from
this.

Thanks,

	M.

[1] https://lore.kernel.org/r/20230825015811.5292-1-zhaoxu.35@bytedance.com

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index bfd181dc..f3ac3270 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -88,7 +88,7 @@ static bool test_init(void)
 
 	irq_ready = false;
 	gic_enable_defaults();
-	on_cpu_async(1, gic_secondary_entry, NULL);
+	on_cpu_async(nr_cpus - 1, gic_secondary_entry, NULL);
 
 	cntfrq = get_cntfrq();
 	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
@@ -157,7 +157,7 @@ static void ipi_exec(void)
 
 	irq_received = false;
 
-	gic_ipi_send_single(1, 1);
+	gic_ipi_send_single(1, nr_cpus - 1);
 
 	while (!irq_received && tries--)
 		cpu_relax();


Marc Zyngier (5):
  KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
  KVM: arm64: Build MPIDR to vcpu index cache at runtime
  KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is
    available
  KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
  KVM: arm64: vgic-v3: Optimize affinity-based SGI injection

 arch/arm64/include/asm/kvm_emulate.h |   2 +-
 arch/arm64/include/asm/kvm_host.h    |  28 ++++++
 arch/arm64/kvm/arm.c                 |  66 +++++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c   | 142 ++++++++++-----------------
 4 files changed, 148 insertions(+), 90 deletions(-)

-- 
2.34.1

