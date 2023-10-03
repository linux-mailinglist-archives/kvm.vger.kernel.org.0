Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73A7B7470
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjJCXE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjJCXE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:04:28 -0400
Received: from out-191.mta0.migadu.com (out-191.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB76AF
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:04:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696374261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UrZnLuF+ZbxfpRS+fSnVui/k86GriMGDer7kkeJmIs=;
        b=TQLUxO+RzzcAwaXhMQ067a1wfoP8qX/6Vkn+9MUssqQtXE81PQL19Z4BY0r69kqO2XAV2M
        o+vZSarHkiZ9RPFmz42JQSucmphuGgBWrLcxpB2Vv10vwfUSuCC8jsoxDX2LknReUWabL/
        hvV23PAGCvTgQKpA8WgOVczYuKlxpTY=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 02/12] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
Date:   Tue,  3 Oct 2023 23:03:58 +0000
Message-ID: <20231003230408.3405722-3-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst | 48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a1..d55c2b68c0a9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6070,6 +6070,54 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define KVM_ARM_FEATURE_ID_RANGE	0
+        #define KVM_ARM_FEATURE_ID_RANGE_SIZE	(3 * 8 * 8)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u32 range;            /* Requested range */
+                __u32 reserved[13];
+        };
+
+This ioctl copies the writable masks for a selected range of registers to
+userspace.
+
+The ``addr`` field is a pointer to the destination array where KVM copies
+the writable masks.
+
+The ``range`` field indicates the requested range of registers.
+``KVM_CHECK_EXTENSION`` for the ``KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES``
+capability returns the supported ranges, expressed as a set of flags. Each
+flag's bit index represents a possible value for the ``range`` field.
+All other values are reserved for future use and KVM may return an error.
+
+The ``reserved[13]`` array is reserved for future use and should be 0, or
+KVM may return an error.
+
+KVM_ARM_FEATURE_ID_RANGE (0)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The Feature ID range is defined as the AArch64 System register space with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+
+The mask returned array pointed to by ``addr`` is indexed by the macro
+``ARM64_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
+to know what fields can be changed for the system register described by
+``op0, op1, crn, crm, op2``. KVM rejects ID register values that describe a
+superset of the features supported by the system.
+
 5. The kvm_run structure
 ========================
 
-- 
2.42.0.609.gbb76f46606-goog

