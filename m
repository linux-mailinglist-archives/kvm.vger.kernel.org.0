Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C594A5F4D28
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 02:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJEAoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 20:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJEAoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 20:44:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E6D5F11F
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 17:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664930651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RENIIYZhSGj1a4EAxYDKm33u7EmX7qunZRIlnI8Brts=;
        b=Z/d5FrqvDGnhMJnTSHxeqNCsTgmFl572vv85MSfzaMn1nqhG0hldNp0TFgZ25rFAb+Y8An
        FpNhy33P+eIAnz3X7zlysytcmv9rnk7LEv28xTO5HBNxFPHzZLmSP4h9+KLONYNn3AmI2y
        12GEwd63lLNB/TZ6BMGMIfEd5fTx+j0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-WnnvRP3kNRG7R2KeFViDUg-1; Tue, 04 Oct 2022 20:44:06 -0400
X-MC-Unique: WnnvRP3kNRG7R2KeFViDUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90F611C05AE9;
        Wed,  5 Oct 2022 00:44:05 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-56.bne.redhat.com [10.64.54.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE33F17583;
        Wed,  5 Oct 2022 00:43:59 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH v5 5/7] KVM: selftests: Use host page size to map ring buffer in dirty_log_test
Date:   Wed,  5 Oct 2022 08:41:52 +0800
Message-Id: <20221005004154.83502-6-gshan@redhat.com>
In-Reply-To: <20221005004154.83502-1-gshan@redhat.com>
References: <20221005004154.83502-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 411a4c0bc81c..c339c8b694e0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1467,7 +1467,7 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
 
 void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 {
-	uint32_t page_size = vcpu->vm->page_size;
+	uint32_t page_size = getpagesize();
 	uint32_t size = vcpu->vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
-- 
2.23.0

