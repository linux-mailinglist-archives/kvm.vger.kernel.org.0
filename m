Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F67767E3A9
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjA0LlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjA0LlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94271F77F;
        Fri, 27 Jan 2023 03:40:41 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2471D1684;
        Fri, 27 Jan 2023 03:40:45 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 911713F64C;
        Fri, 27 Jan 2023 03:40:00 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 05/31] arm64: Check pvtime support against the KVM instance
Date:   Fri, 27 Jan 2023 11:39:06 +0000
Message-Id: <20230127113932.166089-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_STEAL_TIME can be checked against a VM instance.
To allow controlling the feature depending on the VM type,
use the cap against the VM.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/pvtime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index 2933ac7c..839aa8a7 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -58,8 +58,8 @@ int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu)
 	if (kvm_cfg->no_pvtime)
 		return 0;
 
-	has_stolen_time = kvm__supports_extension(vcpu->kvm,
-						  KVM_CAP_STEAL_TIME);
+	has_stolen_time = kvm__supports_vm_extension(vcpu->kvm,
+						     KVM_CAP_STEAL_TIME);
 	if (!has_stolen_time) {
 		kvm_cfg->no_pvtime = true;
 		return 0;
-- 
2.34.1

