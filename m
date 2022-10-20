Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64E4605802
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiJTHNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiJTHNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B6D15ECCC
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 00:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666249979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FjkKJ4RB0wBhJUFjtqAZ3VQdnrJF4akYRPmacZ3lG8=;
        b=iSXtiOmC9cAbBMxcfNza3b9SOSV1MzCt3/LKSneqeR8oMagT0JKBAE/cHH/NYypKfpPZfY
        nxSKlM4DR+L7Tx5KcdB6JmIITpQFHBs8AZmuNDhvWqrX6gJO02Z9lj7KKkphOgBxniXW0l
        IAGrZNgtqiyVxNfgOISjLfz2IrVcjQw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-n3h-O6ciMHaqmna_rDKDRg-1; Thu, 20 Oct 2022 03:12:55 -0400
X-MC-Unique: n3h-O6ciMHaqmna_rDKDRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E665E800186;
        Thu, 20 Oct 2022 07:12:54 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D17E540C6EC2;
        Thu, 20 Oct 2022 07:12:49 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        maz@kernel.org, pbonzini@redhat.com, ajones@ventanamicro.com,
        shuah@kernel.org, peterx@redhat.com, oliver.upton@linux.dev,
        seanjc@google.com, ricarkol@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v3 2/6] KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
Date:   Thu, 20 Oct 2022 15:12:05 +0800
Message-Id: <20221020071209.559062-3-gshan@redhat.com>
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two loops in prepare_vm(), which have different conditions.
'slot' is treated as meory slot index in the first loop, but index of
the host virtual address array in the second loop. It makes it a bit
hard to understand the code.

Change the usage of 'slot' in the second loop, to treat it as the
memory slot index either.

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 231cc8449c2e..dcb492b3f27b 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -297,21 +297,20 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	}
 	*slot_runtime = timespec_elapsed(tstart);
 
-	for (slot = 0, guest_addr = MEM_GPA; slot < data->nslots; slot++) {
+	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
 		uint64_t npages;
 		uint64_t gpa;
 
 		npages = data->pages_per_slot;
-		if (slot == data->nslots - 1)
+		if (slot == data->nslots)
 			npages += rempages;
 
-		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr,
-					 slot + 1);
+		gpa = vm_phy_pages_alloc(data->vm, npages, guest_addr, slot);
 		TEST_ASSERT(gpa == guest_addr,
 			    "vm_phy_pages_alloc() failed\n");
 
-		data->hva_slots[slot] = addr_gpa2hva(data->vm, guest_addr);
-		memset(data->hva_slots[slot], 0, npages * 4096);
+		data->hva_slots[slot - 1] = addr_gpa2hva(data->vm, guest_addr);
+		memset(data->hva_slots[slot - 1], 0, npages * 4096);
 
 		guest_addr += npages * 4096;
 	}
-- 
2.23.0

