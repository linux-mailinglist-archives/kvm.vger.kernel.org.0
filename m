Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733EF5FE988
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJNH1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJNH1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645441BF84F
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 00:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665732452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HO6ItwplxcowXlIKdJH2SQbuhYvBFkPnC0M8MrxP0E=;
        b=A4WpDt4WpKng+e6qfy5Pxh9KsZ/KqVEVPPAvhLOYqMpiqYgxfa863/etV0CvLg6fzZVOAK
        g/ZZn8HoJAI/XJC6UXGIqziIoQ1YTU/UG1rRW0Bx93F9x2S7R8FFc4V8Ofg9yWmd47Y5sn
        RecIzB4EQ0CI4C9LieOowGIsbdYWCMM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-l_Q2vU7YPHS0w63Vld1mlw-1; Fri, 14 Oct 2022 03:27:30 -0400
X-MC-Unique: l_Q2vU7YPHS0w63Vld1mlw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50BD518029D2;
        Fri, 14 Oct 2022 07:27:09 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 180DEC56621;
        Fri, 14 Oct 2022 07:20:40 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
        pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
        oliver.upton@linux.dev, seanjc@google.com, peterx@redhat.com,
        maciej.szmigiero@oracle.com, ricarkol@google.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH 6/6] KVM: selftests: memslot_perf_test: Report optimal memory slots
Date:   Fri, 14 Oct 2022 15:19:14 +0800
Message-Id: <20221014071914.227134-7-gshan@redhat.com>
In-Reply-To: <20221014071914.227134-1-gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
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

The memory area in each slot should be aligned to host page size.
Otherwise, the test will failure. For example, the following command
fails with the following messages with 64KB-page-size-host and
4KB-pae-size-guest. It's not user friendly. Lets do something to report
the optimal memory slots, instead of failing the test.

  # ./memslot_perf_test -v -s 1000
  Number of memory slots: 999
  Testing map performance with 1 runs, 5 seconds each
  Adding slots 1..999, each slot with 8 pages + 216 extra pages last
  ==== Test Assertion Failure ====
    lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
    pid=19872 tid=19872 errno=0 - Success
       1  0x00000000004065b3: vm_userspace_mem_region_add at kvm_util.c:822
       2  0x0000000000401d6b: prepare_vm at memslot_perf_test.c:273
       3  (inlined by) test_execute at memslot_perf_test.c:756
       4  (inlined by) test_loop at memslot_perf_test.c:994
       5  (inlined by) main at memslot_perf_test.c:1073
       6  0x0000ffff7ebb4383: ?? ??:0
       7  0x00000000004021ff: _start at :?
    Number of guest pages is not compatible with the host. Try npages=16

Report the optimal memory slots instead of failing the test when
the memory area in each slot isn't aligned to host page size. With
this applied, the optimal memory slots is reported.

  # ./memslot_perf_test -v -s 1000
  # ./memslot_perf_test -v -s 1000
  Number of memory slots: 999
  Testing map performance with 1 runs, 5 seconds each
  Memslot count too high for this test, decrease the cap (max is 514)

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 45 +++++++++++++++++--
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e6d34744b45d..bec65803f220 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -230,16 +230,52 @@ static struct vm_data *alloc_vm(void)
 	return data;
 }
 
+static bool check_slot_pages(uint32_t host_page_size, uint32_t guest_page_size,
+			     uint64_t pages_per_slot, uint64_t rempages)
+{
+	if (!pages_per_slot)
+		return false;
+
+	if ((pages_per_slot * guest_page_size) % host_page_size)
+		return false;
+
+	if ((rempages * guest_page_size) % host_page_size)
+		return false;
+
+	return true;
+}
+
+
+static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
+{
+	uint32_t guest_page_size = data->vm->page_size;
+	uint64_t mempages, pages_per_slot, rempages;
+	uint64_t slots;
+
+	mempages = data->npages;
+	slots = data->nslots;
+	while (--slots > 1) {
+		pages_per_slot = mempages / slots;
+		rempages = mempages % pages_per_slot;
+		if (check_slot_pages(host_page_size, guest_page_size,
+				     pages_per_slot, rempages))
+			return slots + 1;	/* slot 0 is reserved */
+	}
+
+	return 0;
+}
+
 static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		       void *guest_code, uint64_t mem_size,
 		       struct timespec *slot_runtime)
 {
 	uint64_t mempages, rempages;
 	uint64_t guest_addr;
-	uint32_t slot, guest_page_size;
+	uint32_t slot, host_page_size, guest_page_size;
 	struct timespec tstart;
 	struct sync_area *sync;
 
+	host_page_size = getpagesize();
 	guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
 	mempages = mem_size / guest_page_size;
 
@@ -250,12 +286,13 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	TEST_ASSERT(data->npages > 1, "Can't test without any memory");
 	data->nslots = nslots;
 	data->pages_per_slot = data->npages / data->nslots;
-	if (!data->pages_per_slot) {
-		*maxslots = data->npages + 1;
+	rempages = data->npages % data->nslots;
+	if (!check_slot_pages(host_page_size, guest_page_size,
+			      data->pages_per_slot, rempages)) {
+		*maxslots = get_max_slots(data, host_page_size);
 		return false;
 	}
 
-	rempages = data->npages % data->nslots;
 	data->hva_slots = malloc(sizeof(*data->hva_slots) * data->nslots);
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
-- 
2.23.0

