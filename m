Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EEC54AB78
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352419AbiFNILN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbiFNIKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71982396B1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 01:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655194247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pRqaGJZ7EPgL5vblNHClzjq/AmbAOFI914T+3oHOOlM=;
        b=c9+54KFcQJEL+ld8sSVbFV10fNES4pdTwxy3MAdw/zLf7oOOt9ZXz2awH8J0/gexSC8XhI
        Dxo1rcR2EVkgK8oW/KFvfE6TGThT7Cwx4OMFlfVmSPq2A8pgJmsluDOu4LB+XVUoPljKal
        00SRb/cBLSYs1Su3CBN0Zw5cltYGJcA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-duhPEOGCM9msO8oSp3_6Ng-1; Tue, 14 Jun 2022 04:10:44 -0400
X-MC-Unique: duhPEOGCM9msO8oSp3_6Ng-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC50180159B;
        Tue, 14 Jun 2022 08:10:43 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B280E492C3B;
        Tue, 14 Jun 2022 08:10:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com
Subject: [PATCH] KVM: selftests: kvm_binary_stats_test: Fix index expressions
Date:   Tue, 14 Jun 2022 10:10:41 +0200
Message-Id: <20220614081041.2571511-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_binary_stats_test accepts two arguments, the number of vms
and number of vcpus. If these inputs are not equal then the
test would likely crash for one reason or another due to using
miscalculated indices for the vcpus array. Fix the index
expressions by swapping the use of i and j.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---

Applies to kvm/queue

 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 1baabf955d63..3c2d06b61442 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -225,14 +225,14 @@ int main(int argc, char *argv[])
 	for (i = 0; i < max_vm; ++i) {
 		vms[i] = vm_create_barebones();
 		for (j = 0; j < max_vcpu; ++j)
-			vcpus[j * max_vcpu + i] = __vm_vcpu_add(vms[i], j);
+			vcpus[i * max_vcpu + j] = __vm_vcpu_add(vms[i], j);
 	}
 
 	/* Check stats read for every VM and VCPU */
 	for (i = 0; i < max_vm; ++i) {
 		vm_stats_test(vms[i]);
 		for (j = 0; j < max_vcpu; ++j)
-			vcpu_stats_test(vcpus[j * max_vcpu + i]);
+			vcpu_stats_test(vcpus[i * max_vcpu + j]);
 	}
 
 	for (i = 0; i < max_vm; ++i)
-- 
2.34.3

