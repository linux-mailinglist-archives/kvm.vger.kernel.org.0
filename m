Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB8712FCF
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbjEZWRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244350AbjEZWRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:30 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74524D8
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bWifmxddLT3nvUDIRRuiZb+7qrGg/n9duhLsnxIE7XE=;
        b=aLKBQOv+Oysm0N7VH4KYBc+CT5w++pBdOqrQ/Pjcpfd1B20vzxA/Bn/kExpzNZ04UjDlpe
        NUr2Cyya5kmAQGJUqwMzevHBddTZq9a8XLpBSemxuE5RAKWMf1v3KAhpQ91Mg3Urkcsh/q
        J0MepHhjrgi0Jc/JtQ5gFnU6PN0nqZI=
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
Subject: [PATCH kvmtool 03/21] Copy 64-bit alignment attrtibutes from Linux 6.4-rc1
Date:   Fri, 26 May 2023 22:16:54 +0000
Message-ID: <20230526221712.317287-4-oliver.upton@linux.dev>
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

An update to vfio.h requires these macros.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/linux/types.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/types.h b/include/linux/types.h
index 5e20f10f8830..652c33bf5c87 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -36,6 +36,19 @@ typedef __u32 __bitwise __be32;
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
 
+/*
+ * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
+ * common 32/64-bit compat problems.
+ * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
+ * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
+ * aligned_64 type enforces 8-byte alignment so that structs containing
+ * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
+ * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
+ */
+#define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_be64 __be64 __attribute__((aligned(8)))
+#define __aligned_le64 __le64 __attribute__((aligned(8)))
+
 struct list_head {
 	struct list_head *next, *prev;
 };
-- 
2.41.0.rc0.172.g3f132b7071-goog

