Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98151574CB8
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 14:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbiGNMDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 08:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiGNMDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 08:03:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7F493BC
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 05:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657800217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D/d1mCDWNQqfCCpqWiuOma0ECIssiX3Tqek3ZeYD45M=;
        b=NmHCNYIsb3QRXRFLIBnYAvAERQ4xn3Wfxn6mN+1udGYk5zYf3KPrc0YT0nnA84KkqJ4BJY
        F2KG7/u/cE5FCxnJgXepZpzgEKrdSLkw5RmeAntG8Zj2cqXxRsEn3GQsOTsX1XuECgWGwu
        qLuiDCSGB+IVTWXM6+PkT/sg1lHvtaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-TFV0jGtvOwa92n44Hy5kWw-1; Thu, 14 Jul 2022 08:03:30 -0400
X-MC-Unique: TFV0jGtvOwa92n44Hy5kWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6186A185A7B2;
        Thu, 14 Jul 2022 12:03:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F5542166B26;
        Thu, 14 Jul 2022 12:03:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Amneesh Singh <natto@weirdnatto.in>
Subject: [PATCH] kvm: stats: tell userspace which values are boolean
Date:   Thu, 14 Jul 2022 08:03:29 -0400
Message-Id: <20220714120330.1410308-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the statistics values exported by KVM are always only 0 or 1.
It can be useful to export this fact to userspace so that it can track
them specially (for example by polling the value every now and then to
compute a % of time spent in a specific state).

Therefore, add "boolean value" as a new "unit".  While it is not exactly
a unit, it walks and quacks like one.  In particular, using the type
would be wrong because boolean values could be instantaneous or peak
values (e.g. "is the rmap allocated?") or even two-bucket histograms
(e.g. "number of posted vs. non-posted interrupt injections").

Suggested-by: Amneesh Singh <natto@weirdnatto.in>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/x86/kvm/x86.c             |  2 +-
 include/linux/kvm_host.h       | 11 ++++++++++-
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..48bf6e49a7de 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5657,6 +5657,7 @@ by a string of size ``name_size``.
 	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
 
 	#define KVM_STATS_BASE_SHIFT		8
@@ -5724,6 +5725,11 @@ Bits 4-7 of ``flags`` encode the unit:
     It indicates that the statistics data is used to measure time or latency.
   * ``KVM_STATS_UNIT_CYCLES``
     It indicates that the statistics data is used to measure CPU clock cycles.
+  * ``KVM_STATS_UNIT_BOOLEAN``
+    It indicates that the statistic will always be either 0 or 1.  Boolean
+    statistics of "peak" type will never go back from 1 to 0.  Boolean
+    statistics can be linear histograms (with two buckets) but not logarithmic
+    histograms.
 
 Bits 8-11 of ``flags``, together with ``exponent``, encode the scale of the
 unit:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26d0cac32f73..0c3e85e8fce9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -298,7 +298,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
 	STATS_DESC_COUNTER(VCPU, preemption_reported),
 	STATS_DESC_COUNTER(VCPU, preemption_other),
-	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+	STATS_DESC_IBOOLEAN(VCPU, guest_mode)
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 83cf7fd842e0..90a45ef7203b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1822,6 +1822,15 @@ struct _kvm_stats_desc {
 	STATS_DESC_PEAK(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
 
+/* Instantaneous boolean value, read only */
+#define STATS_DESC_IBOOLEAN(SCOPE, name)				       \
+	STATS_DESC_INSTANT(SCOPE, name, KVM_STATS_UNIT_BOOLEAN,		       \
+		KVM_STATS_BASE_POW10, 0)
+/* Peak (sticky) boolean value, read/write */
+#define STATS_DESC_PBOOLEAN(SCOPE, name)				       \
+	STATS_DESC_PEAK(SCOPE, name, KVM_STATS_UNIT_BOOLEAN,		       \
+		KVM_STATS_BASE_POW10, 0)
+
 /* Cumulative time in nanosecond */
 #define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
 	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
@@ -1853,7 +1862,7 @@ struct _kvm_stats_desc {
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
 			HALT_POLL_HIST_COUNT),				       \
-	STATS_DESC_ICOUNTER(VCPU_GENERIC, blocking)
+	STATS_DESC_IBOOLEAN(VCPU_GENERIC, blocking)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..811897dadcae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2083,6 +2083,7 @@ struct kvm_stats_header {
 #define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
 
 #define KVM_STATS_BASE_SHIFT		8
-- 
2.31.1

