Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AF87460C5
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjGCQf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 12:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGCQf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 12:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61BFD
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 09:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 136CE60FC5
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 16:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78523C433C7;
        Mon,  3 Jul 2023 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688402155;
        bh=N6vR/isJS7QDUT4Iu2eb1E931YafySKJREGUVnDreiM=;
        h=From:To:Cc:Subject:Date:From;
        b=p5rDwHcfqw0tUgUUaFctvRj3+Oc5tUab8U+pxrOWeWXV603vijyNqMPRmQY1NJZpk
         gqRFTpus2hXFu8/3WI6AH5iqqI/yVXw7ol3VQ01QIDiMh5KHWlRjLF+Ospxa5gwmey
         w2bHtDdXyyg1YprUfnXOl49VJsAVYIcmbCEYvtRXUKAUEeZXW26Ty6EzfKf1pVm8PY
         MeK3b1vIGMYUn11rkzvj2pqD4vv2tWmINhZVWmfFrWp2s1iCtUuWj/xjBrEBtkhJLI
         fiTuO/KloLZiGn4i5781HZ8gQ7ChQHwN6jCIJp93UckXxcBut/bdpSDIVOQU7HI6xj
         SMUDSzYZ+QTxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qGMWm-00ADGW-SY;
        Mon, 03 Jul 2023 17:35:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com,
        seanjc@google.com, pbonzini@redhat.com,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        stable@vger.kernek.org
Subject: [PATCH] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
Date:   Mon,  3 Jul 2023 17:35:48 +0100
Message-Id: <20230703163548.1498943-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, isaku.yamahata@intel.com, seanjc@google.com, pbonzini@redhat.com, kristina.martsenko@arm.com, stable@vger.kernek.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
a guest is running results in a number of ugly splats as most
of this code expects to run with preemption disabled, which isn't
the case anymore.

While the context is preemptable, it isn't migratable, which should
be enough. But we have plenty of preemptible() checks all over
the place, and our per-CPU accessors also disable preemption.

Since this affects released versions, let's do the easy fix first,
disabling preemption in kvm_arch_hardware_enable(). We can always
revisit this with a more invasive fix in the future.

Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
Cc: stable@vger.kernek.org # v6.3, v6.4
---
 arch/arm64/kvm/arm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index aaeae1145359..a28c4ffe4932 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
 
 int kvm_arch_hardware_enable(void)
 {
-	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
+	int was_enabled;
 
+	/*
+	 * Most calls to this function are made with migration
+	 * disabled, but not with preemption disabled. The former is
+	 * enough to ensure correctness, but most of the helpers
+	 * expect the later and will throw a tantrum otherwise.
+	 */
+	preempt_disable();
+
+	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
 	_kvm_arch_hardware_enable(NULL);
 
 	if (!was_enabled) {
@@ -1903,6 +1912,8 @@ int kvm_arch_hardware_enable(void)
 		kvm_timer_cpu_up();
 	}
 
+	preempt_enable();
+
 	return 0;
 }
 
-- 
2.34.1

