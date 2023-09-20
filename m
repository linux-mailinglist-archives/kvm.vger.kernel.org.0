Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BDC7A8BDB
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjITSdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjITSdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:33:36 -0400
Received: from out-212.mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E58C9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:33:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695234808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pbkEDCaVdQ3A7WI4VZjJ3ROIXdzg8sEIqydxrIwZieo=;
        b=G8lErBuxmmRs87ZyCDTtTaXI/V3dEXQLHN6GNYiWHXefvwpk7v0S/FZEvxHxsIqlvQ2iQB
        +dRTdTIbaFE+yUnT4uKOlSztX/LXMv3Gv54+CF8aq9jAz/ARTwYozqE3oaBqgskm/KJQ1Q
        NSoi1VaI5d4ey2IAQpBllS2qEHmVFjM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: [PATCH v10 02/12] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
Date:   Wed, 20 Sep 2023 18:32:59 +0000
Message-ID: <20230920183310.1163034-3-oliver.upton@linux.dev>
In-Reply-To: <20230920183310.1163034-1-oliver.upton@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Zhang <jingzhangos@google.com>

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..8cd91bc550bc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6070,6 +6070,49 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+        #define ARM64_FEATURE_ID_RANGE_IDREGS	BIT(0)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u32 range;            /* Requested range */
+                __u32 reserved[13];
+        };
+
+This ioctl copies the writable masks for Feature ID registers to userspace.
+The Feature ID space is defined as the AArch64 System register space with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+
+The mask array pointed to by ``addr`` is indexed by the macro
+``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
+to know what fields can be changed for the system register described by
+``op0, op1, crn, crm, op2``. KVM rejects ID register values that describe a
+superset of the features supported by the system.
+
+The ``range`` field describes the requested range of registers. The valid
+ranges can be retrieved by checking the return value of
+KVM_CAP_CHECK_EXTENSION_VM for the KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES
+capability, which will return a bitmask of the supported ranges. Each bit
+set in the return value represents a possible value for the ``range``
+field.  At the time of writing, only bit 0 is returned set by the
+capability, meaning that only the value ``ARM64_FEATURE_ID_RANGE_IDREGS``
+is valid for ``range``.
+
+The ``reserved[13]`` array is reserved for future use and should be 0, or
+KVM may return an error.
+
 5. The kvm_run structure
 ========================
 
-- 
2.42.0.515.g380fc7ccd1-goog

