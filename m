Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6529261A607
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 00:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKDXmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 19:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiKDXmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 19:42:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8FB2791A
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 16:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667605304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AKNjwXr1+6lA46ix04voPDpp+Bnwo29abQuhxfN937w=;
        b=PemPMc1+fBNe1L2P2rM8yO3eAG9NQBEI7G6jgeGpPl5iT+5209rIh7glEcENjA32iEO+mi
        ZEamUAzXbdtE1kLHAEYQNG37UT4WZVXbCMWaFEuQzNdgRqe77oZofpV+6iXjkiq/txbGTY
        KZ8jiqIhTLyCEhpW4uO85EeDQWccNWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-cHPFydpAN6OWZXeh8Hsgiw-1; Fri, 04 Nov 2022 19:41:40 -0400
X-MC-Unique: cHPFydpAN6OWZXeh8Hsgiw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A15F85A583;
        Fri,  4 Nov 2022 23:41:39 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 209E24A9254;
        Fri,  4 Nov 2022 23:41:32 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        seanjc@google.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v8 5/7] KVM: selftests: Use host page size to map ring buffer in dirty_log_test
Date:   Sat,  5 Nov 2022 07:40:47 +0800
Message-Id: <20221104234049.25103-6-gshan@redhat.com>
In-Reply-To: <20221104234049.25103-1-gshan@redhat.com>
References: <20221104234049.25103-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vcpu_map_dirty_ring(), the guest's page size is used to figure out
the offset in the virtual area. It works fine when we have same page
sizes on host and guest. However, it fails when the page sizes on host
and guest are different on arm64, like below error messages indicates.

  # ./dirty_log_test -M dirty-ring -m 7
  Setting log mode to: 'dirty-ring'
  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
  guest physical test memory offset: 0xffbffc0000
  vcpu stops because vcpu is kicked out...
  Notifying vcpu to continue
  vcpu continues now.
  ==== Test Assertion Failure ====
  lib/kvm_util.c:1477: addr == MAP_FAILED
  pid=9000 tid=9000 errno=0 - Success
  1  0x0000000000405f5b: vcpu_map_dirty_ring at kvm_util.c:1477
  2  0x0000000000402ebb: dirty_ring_collect_dirty_pages at dirty_log_test.c:349
  3  0x00000000004029b3: log_mode_collect_dirty_pages at dirty_log_test.c:478
  4  (inlined by) run_test at dirty_log_test.c:778
  5  (inlined by) run_test at dirty_log_test.c:691
  6  0x0000000000403a57: for_each_guest_mode at guest_modes.c:105
  7  0x0000000000401ccf: main at dirty_log_test.c:921
  8  0x0000ffffb06ec79b: ?? ??:0
  9  0x0000ffffb06ec86b: ?? ??:0
  10 0x0000000000401def: _start at ??:?
  Dirty ring mapped private

Fix the issue by using host's page size to map the ring buffer.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..89a1a420ebd5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1506,7 +1506,7 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
 
 void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 {
-	uint32_t page_size = vcpu->vm->page_size;
+	uint32_t page_size = getpagesize();
 	uint32_t size = vcpu->vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
-- 
2.23.0

