Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB265FD4D7
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 08:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJMGal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 02:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJMGaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 02:30:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5473B8C0E
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 23:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665642637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=I39cZ3LRJVOkJAwJsydduYsdnQpl71cDmGrmMmwlFkQ=;
        b=BtBLk7RXgiIfwmxI60xqpKrt7Wr2GwE1/35RzqyDxZzV+qScv7Xf8a29toShLt5qJ6JOjm
        gZQvdNiVKjdUb7ymIKVDefNzkyh0i9D++cPsc41Yxl31uD2ba2rOaT7ks8/M3EyMYl2hey
        WXKaU62ULOQgdXdD9Os8ZnsWBy/FnrA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-hwQ87wOKN_eioJhbGOgOBw-1; Thu, 13 Oct 2022 02:30:34 -0400
X-MC-Unique: hwQ87wOKN_eioJhbGOgOBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EDD83C0D84A;
        Thu, 13 Oct 2022 06:30:34 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FF87C15BB5;
        Thu, 13 Oct 2022 06:30:29 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org,
        oliver.upton@linux.dev, pbonzini@redhat.com, shuah@kernel.org,
        dmatlack@google.com, peterx@redhat.com, venkateshs@chromium.org,
        seanjc@google.com, shan.gavin@gmail.com, ajones@ventanamicro.com
Subject: [PATCH] KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test
Date:   Thu, 13 Oct 2022 14:30:20 +0800
Message-Id: <20221013063020.201856-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's required by vm_userspace_mem_region_add() that memory size
should be aligned to host page size. However, one guest page is
provided by memslot_modification_stress_test. It triggers failure
in the scenario of 64KB-page-size-host and 4KB-page-size-guest,
as the following messages indicate.

 # ./memslot_modification_stress_test
 Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
 guest physical test memory: [0xffbfff0000, 0xffffff0000)
 Finished creating vCPUs
 Started all vCPUs
 ==== Test Assertion Failure ====
   lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
   pid=5712 tid=5712 errno=0 - Success
      1	0x0000000000404eeb: vm_userspace_mem_region_add at kvm_util.c:822
      2	0x0000000000401a5b: add_remove_memslot at memslot_modification_stress_test.c:82
      3	 (inlined by) run_test at memslot_modification_stress_test.c:110
      4	0x0000000000402417: for_each_guest_mode at guest_modes.c:100
      5	0x00000000004016a7: main at memslot_modification_stress_test.c:187
      6	0x0000ffffb8cd4383: ?? ??:0
      7	0x0000000000401827: _start at :?
   Number of guest pages is not compatible with the host. Try npages=16

Fix the issue by providing 16 guest pages to the memory slot for this
particular combination of 64KB-page-size-host and 4KB-page-size-guest
on aarch64.

Fixes: ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6ee7e1dde404..bb1d17a1171b 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -67,7 +67,7 @@ struct memslot_antagonist_args {
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       uint64_t nr_modifications)
 {
-	const uint64_t pages = 1;
+	uint64_t pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
 	uint64_t gpa;
 	int i;
 
-- 
2.23.0

