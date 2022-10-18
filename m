Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7791060231D
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 06:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiJREFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 00:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJREFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 00:05:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B465241
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 21:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666065928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PqVmt5YoyTpdybpQLaBWLMwp2J8t1L+xxmd4ToLLOLQ=;
        b=FAPVtxESH5wuxO/0/HDfgxexh4yhFS3XK+jKb2tWyfVlaJqu8Qyseg9y1F1BIvHTLWXdNN
        16fyAvbfxWQ5xQtIhyvJez6Ust2grw8jnZqI8nfYN3b+15hdCTsZU0k6a4uYvi4j8iADFt
        tTxidmorEY87MLNiX29egCl+PgpRshI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-Qa1Yv4GQM22PAcvLiooxIQ-1; Tue, 18 Oct 2022 00:05:23 -0400
X-MC-Unique: Qa1Yv4GQM22PAcvLiooxIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21DBB38041D0;
        Tue, 18 Oct 2022 04:05:23 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 461312166B41;
        Tue, 18 Oct 2022 04:05:16 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
        pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
        oliver.upton@linux.dev, mail@maciej.szmigiero.name,
        maciej.szmigiero@oracle.com, seanjc@google.com, peterx@redhat.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v2 3/6] KVM: selftests: memslot_perf_test: Probe memory slots for once
Date:   Tue, 18 Oct 2022 12:04:51 +0800
Message-Id: <20221018040454.405719-4-gshan@redhat.com>
In-Reply-To: <20221018040454.405719-1-gshan@redhat.com>
References: <20221018040454.405719-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

prepare_vm() is called in every iteration and run. The allowed memory
slots (KVM_CAP_NR_MEMSLOTS) are probed for multiple times. It's not
free and unnecessary.

Move the probing logic for the allowed memory slots to parse_args()
for once, which is upper layer of prepare_vm().

No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 32 +++++++++++--------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index dcb492b3f27b..f0ea3f75b6e1 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -245,27 +245,17 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 		       void *guest_code, uint64_t mempages,
 		       struct timespec *slot_runtime)
 {
-	uint32_t max_mem_slots;
 	uint64_t rempages;
 	uint64_t guest_addr;
 	uint32_t slot;
 	struct timespec tstart;
 	struct sync_area *sync;
 
-	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
-	TEST_ASSERT(max_mem_slots > 1,
-		    "KVM_CAP_NR_MEMSLOTS should be greater than 1");
-	TEST_ASSERT(nslots > 1 || nslots == -1,
-		    "Slot count cap should be greater than 1");
-	if (nslots != -1)
-		max_mem_slots = min(max_mem_slots, (uint32_t)nslots);
-	pr_info_v("Allowed number of memory slots: %"PRIu32"\n", max_mem_slots);
-
 	TEST_ASSERT(mempages > 1,
 		    "Can't test without any memory");
 
 	data->npages = mempages;
-	data->nslots = max_mem_slots - 1;
+	data->nslots = nslots;
 	data->pages_per_slot = mempages / data->nslots;
 	if (!data->pages_per_slot) {
 		*maxslots = mempages + 1;
@@ -869,6 +859,7 @@ static void help(char *name, struct test_args *targs)
 static bool parse_args(int argc, char *argv[],
 		       struct test_args *targs)
 {
+	uint32_t max_mem_slots;
 	int opt;
 
 	while ((opt = getopt(argc, argv, "hvds:f:e:l:r:")) != -1) {
@@ -885,8 +876,8 @@ static bool parse_args(int argc, char *argv[],
 			break;
 		case 's':
 			targs->nslots = atoi(optarg);
-			if (targs->nslots <= 0 && targs->nslots != -1) {
-				pr_info("Slot count cap has to be positive or -1 for no cap\n");
+			if (targs->nslots <= 1 && targs->nslots != -1) {
+				pr_info("Slot count cap must be larger than 1 or -1 for no cap\n");
 				return false;
 			}
 			break;
@@ -932,6 +923,21 @@ static bool parse_args(int argc, char *argv[],
 		return false;
 	}
 
+	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
+	if (max_mem_slots <= 1) {
+		pr_info("KVM_CAP_NR_MEMSLOTS should be greater than 1\n");
+		return false;
+	}
+
+	/* Memory slot 0 is reserved */
+	if (targs->nslots == -1)
+		targs->nslots = max_mem_slots - 1;
+	else
+		targs->nslots = min_t(int, targs->nslots, max_mem_slots) - 1;
+
+	pr_info_v("Allowed Number of memory slots: %"PRIu32"\n",
+		  targs->nslots + 1);
+
 	return true;
 }
 
-- 
2.23.0

