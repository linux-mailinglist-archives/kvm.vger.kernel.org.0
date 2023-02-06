Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B4968C79E
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 21:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjBFUZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 15:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjBFUZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 15:25:18 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C431EBCB
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 12:25:13 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pP834-00BKK5-Ol; Mon, 06 Feb 2023 21:25:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=w5MgnQd8paS3yYSE3LZCg+Uh//BRFwLhcnZl+ae7r+4=; b=avRJY/nxn7+BN
        6bJgt0OwHUr7m+brJB9HSYzM2y2H+b5aP736FO8lZzYYU3z3Q3G8VrCS4koXh0H/T8kK5uIQCBY2G
        yva+/aNEOhV1fyIWrGi4cOa4UDhvs1NHb9isiopoLEP0JkhIpvlPVbdUry8F99AXKfSdHf+j0DMht
        1Ebo+tpUhzAJW1lKAbcdswSEJiQaQJzdzDHeiPVMxDSsxX2AS+WAoCEaQq6uAusquJWzHLBqGyV9h
        1qoQVsI8wafNtSQzvXi4p6S4gF1OPYUVu259TjMwK8/MXHd/lq9BEJIoF8WzEKbCo/7oSyQPwLGDD
        vb8uFlaI9s3bctlzCWaSw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pP833-0005RB-UR; Mon, 06 Feb 2023 21:25:10 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pP82z-0005bK-Kn; Mon, 06 Feb 2023 21:25:05 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com,
        dwmw@amazon.co.uk, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: selftests: Clean up misnomers in xen_shinfo_test
Date:   Mon,  6 Feb 2023 21:24:30 +0100
Message-Id: <20230206202430.1898057-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As discussed[*], relabel the poorly named structs to align with the
current KVM nomenclature.

Old names are a leftover from before commit 52491a38b2c2 ("KVM:
Initialize gfn_to_pfn_cache locks in dedicated helper"), which i.a.
introduced kvm_gpc_init() and renamed kvm_gfn_to_pfn_cache_init()/
_destroy() to kvm_gpc_activate()/_deactivate(). Partly in an effort
to avoid implying that the cache really is destroyed/freed.

While at it, get rid of #define GPA_INVALID, which being used as a GFN,
is not only misnamed, but also unnecessarily reinvents a UAPI constant.

No functional change intended.

[*] https://lore.kernel.org/r/Y5yZ6CFkEMBqyJ6v@google.com

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c  | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 6a838df69174..fd39a15d6970 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -19,9 +19,6 @@
 
 #include <sys/eventfd.h>
 
-/* Defined in include/linux/kvm_types.h */
-#define GPA_INVALID		(~(ulong)0)
-
 #define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
@@ -412,19 +409,19 @@ static void *juggle_shinfo_state(void *arg)
 {
 	struct kvm_vm *vm = (struct kvm_vm *)arg;
 
-	struct kvm_xen_hvm_attr cache_init = {
+	struct kvm_xen_hvm_attr cache_activate = {
 		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
 		.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE
 	};
 
-	struct kvm_xen_hvm_attr cache_destroy = {
+	struct kvm_xen_hvm_attr cache_deactivate = {
 		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
-		.u.shared_info.gfn = GPA_INVALID
+		.u.shared_info.gfn = KVM_XEN_INVALID_GFN
 	};
 
 	for (;;) {
-		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_init);
-		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_destroy);
+		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_activate);
+		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_deactivate);
 		pthread_testcancel();
 	}
 
-- 
2.39.0

