Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3CE602317
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 06:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiJREF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 00:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiJREFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 00:05:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0A14C2F7
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 21:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666065918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vvc9nSeTOx+R9O1KRdNsOErR2cLTeHQp0FKXCgftjxs=;
        b=eHDKl2ZMYdDadgvz5XxT5QPitm42hueEelaRBGmPz33O7Hmv3ESqMQySN0wvkuo7f0sG2S
        GHCytefLvy7rzaJHugYgEyRGt3UcBCbZ9j/lsRPN92V26mXSoNchUvnbKPaqwqpN1zxxZg
        /OY2U3jhgaZLUM3SGCT2xmXsqDZfn0s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-zSOD3oF5P3itk5-d8L2GxA-1; Tue, 18 Oct 2022 00:05:10 -0400
X-MC-Unique: zSOD3oF5P3itk5-d8L2GxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5273229AB3E9;
        Tue, 18 Oct 2022 04:05:10 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F55E2166B41;
        Tue, 18 Oct 2022 04:05:04 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
        pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
        oliver.upton@linux.dev, mail@maciej.szmigiero.name,
        maciej.szmigiero@oracle.com, seanjc@google.com, peterx@redhat.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v2 1/6] KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
Date:   Tue, 18 Oct 2022 12:04:49 +0800
Message-Id: <20221018040454.405719-2-gshan@redhat.com>
In-Reply-To: <20221018040454.405719-1-gshan@redhat.com>
References: <20221018040454.405719-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In prepare_vm(), 'data->nslots' is assigned with 'max_mem_slots - 1'
at the beginning, meaning they are interchangeable.

Use 'data->nslots' isntead of 'max_mem_slots - 1'. With this, it
becomes easier to move the logic of probing number of slots into
upper layer in subsequent patches.

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 44995446d942..231cc8449c2e 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -280,14 +280,14 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
-		max_mem_slots - 1, data->pages_per_slot, rempages);
+		data->nslots, data->pages_per_slot, rempages);
 
 	clock_gettime(CLOCK_MONOTONIC, &tstart);
-	for (slot = 1, guest_addr = MEM_GPA; slot < max_mem_slots; slot++) {
+	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
 		uint64_t npages;
 
 		npages = data->pages_per_slot;
-		if (slot == max_mem_slots - 1)
+		if (slot == data->nslots)
 			npages += rempages;
 
 		vm_userspace_mem_region_add(data->vm, VM_MEM_SRC_ANONYMOUS,
@@ -297,12 +297,12 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	}
 	*slot_runtime = timespec_elapsed(tstart);
 
-	for (slot = 0, guest_addr = MEM_GPA; slot < max_mem_slots - 1; slot++) {
+	for (slot = 0, guest_addr = MEM_GPA; slot < data->nslots; slot++) {
 		uint64_t npages;
 		uint64_t gpa;
 
 		npages = data->pages_per_slot;
-		if (slot == max_mem_slots - 2)
+		if (slot == data->nslots - 1)
 			npages += rempages;
 
 		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
-- 
2.23.0

