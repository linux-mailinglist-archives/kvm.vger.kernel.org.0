Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19C712FD4
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbjEZWRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244379AbjEZWRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:41 -0400
Received: from out-39.mta0.migadu.com (out-39.mta0.migadu.com [IPv6:2001:41d0:1004:224b::27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C241BD
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:37 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yl7AlAoXPf4ogaPws4+d6wv4PIMGGuKWDBSXk06gWVU=;
        b=MJsAa+U1EJB7/zfjGw0AjUO0gC6tk0IWuCL+RVTtZDCE2aQZAFVdFU0ho0IuNUWc81umLV
        XbPpzT8J4lKpNliZuJo+iG2Y6EkbCawIQ/4KIbtyV3amQuFRf0wTybH0jh2og8YlKoiFFV
        UxIrLa1MVOVfcojMTO/7YmX0tIrExDI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 07/21] arm: Stash kvm_vcpu_init for later use
Date:   Fri, 26 May 2023 22:16:58 +0000
Message-ID: <20230526221712.317287-8-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent change will add support for resetting a vCPU, which
requires reissuing the KVM_ARM_VCPU_INIT ioctl. Save the kvm_vcpu_init
worked out for later use.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/include/arm-common/kvm-cpu-arch.h | 2 +-
 arm/kvm-cpu.c                         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 923d2c4c7ad3..bf5223eaa851 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -11,7 +11,7 @@ struct kvm_cpu {
 	pthread_t	thread;
 
 	unsigned long	cpu_id;
-	unsigned long	cpu_type;
+	struct kvm_vcpu_init	init;
 	const char	*cpu_compatible;
 
 	struct kvm	*kvm;
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 98bc5fdf0418..0ac488a93eef 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -115,7 +115,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

