Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E846B787F
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 14:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjCMNK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 09:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCMNKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 09:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A825BCA5
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 06:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80B2B61239
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 13:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8152C433EF;
        Mon, 13 Mar 2023 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678713052;
        bh=581RHvHYFGptkT5QjAJFIfWOWxi8Gn2cCqeF96loHUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZrjbcMJOi+sbzB4i+hTgcXL14bun3jM/VobxbCBuQItAsif2jnhNbdTayX8j4kfI
         +6EPHzRbPxmXkVxkk/ZcaChvm0jvxx46QbvRnSEhq9zz94SuiSa2QIpnUNmmpNj8mV
         rQADgRtZUIv/p+exao8LhongslhQjrUS7oZkhKPgVNWBblsouHn2QjadUGGaXIbFLm
         BHDgvvDEf2VizkuIFUwo5bgTrYNdqKZX0BMhimDybDa2BV3vaIRpMzGiRKRHz4JWHc
         XmNApf97Pp7xtAjiHHo7Aq+tAo6gdHIa27fsmRvklzc6C9JXFc6dYKdGbHhx41qBGI
         ErDSg1qu7wQyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbi-00HEdE-U6;
        Mon, 13 Mar 2023 12:48:55 +0000
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
Subject: [PATCH v2 14/19] KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
Date:   Mon, 13 Mar 2023 12:48:32 +0000
Message-Id: <20230313124837.2264882-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic documentation on the effects of KVM_ARM_SET_CNT_OFFSETS.

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

