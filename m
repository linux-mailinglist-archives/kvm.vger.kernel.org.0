Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD24B6C80C9
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjCXPLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCXPLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109B212CE0
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2516F62B54
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 15:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89414C433EF;
        Fri, 24 Mar 2023 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679670659;
        bh=KfLu5goCJangGvLq7IT4uJ4Y7D299IzrAIPjai80bEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuAaxPPlukkJ5G2/E420JiGjcozN9C7HsIq7Q01D3d8WgkztgIUDPzlTkaBt75Qe7
         GOKBQy9b0DGbI6gJcTp+X4dMUwOg43cjcwDa+s4qSdPp3+wBBLKExhgOI4e5dAqST3
         cpjnDrvj2U6v5Ovv4DKB08yv+M7a3P6CPZ+Mhy8d2HhrqH7GwUv0Hpc/H8yQxpQ9B8
         fTtZDU6k8S6P+OwQaz/lIOE9MK7gtmO4UeWmYNc04DeuPDwzYyoXkFxNKq/BfE61Do
         Bhtf7aYm4B0E8mt84jco1LCjP/y4U51jlBNSQA1ZQCaDrXf741Jkj7AemB04D+fnLv
         enyg3YQRaHjwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihM-002qBP-2I;
        Fri, 24 Mar 2023 14:47:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v3 13/18] KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
Date:   Fri, 24 Mar 2023 14:46:59 +0000
Message-Id: <20230324144704.4193635-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic documentation on the effects of KVM_ARM_SET_CNT_OFFSETS.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa..192adcb61add 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6029,6 +6029,44 @@ delivery must be provided via the "reg_aen" struct.
 The "pad" and "reserved" fields may be used for future extensions and should be
 set to 0s by userspace.
 
+4.138 KVM_ARM_SET_COUNTER_OFFSET
+--------------------------------
+
+:Capability: KVM_CAP_COUNTER_OFFSET
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_counter_offset (in)
+:Returns: 0 on success, < 0 on error
+
+This capability indicates that userspace is able to apply a single VM-wide
+offset to both the virtual and physical counters as viewed by the guest
+using the KVM_ARM_SET_CNT_OFFSET ioctl and the following data structure:
+
+::
+
+	struct kvm_arm_counter_offset {
+		__u64 counter_offset;
+		__u64 reserved;
+	};
+
+The offset describes a number of counter cycles that are subtracted from
+both virtual and physical counter views (similar to the effects of the
+CNTVOFF_EL2 and CNTPOFF_EL2 system registers, but only global). The offset
+always applies to all vcpus (already created or created after this ioctl)
+for this VM.
+
+It is userspace's responsibility to compute the offset based, for example,
+on previous values of the guest counters.
+
+Any value other than 0 for the "reserved" field may result in an error
+(-EINVAL) being returned. This ioctl can also return -EBUSY if any vcpu
+ioctl is issued concurrently.
+
+Note that using this ioctl results in KVM ignoring subsequent userspace
+writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
+interface. No error will be returned, but the resulting offset will not be
+applied.
+
 5. The kvm_run structure
 ========================
 
-- 
2.34.1

