Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7854A178
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352400AbiFMVbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353199AbiFMV31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E1995
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:43 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so6938983pjg.7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2HZEMfRIxWFvhgNolJdHE+4fmvokBk1d/agQn4Bf6T4=;
        b=RdGzy/6cYG/hqt377t5RGc5j2qzeneOwISpagbEXNwhnJRGvEuJRIOJNxRgc1uaD9J
         z1XHzQ3qx6rtvshQtkND+/6k5zcdfEmAGAQe4MBNv37e95zUI5qlEr+ukkA7NSdUsA1z
         SRcW9mBtWtFzBGnm/P9jSA8P/+/B31FIzTXSkjfDUHBHwnMuu6nFLEgVutqEPjNF2Njr
         I6aapXMjXkcuw4mTcC+r8vW3kDTpnhz1sSNktr6TUaIlqZg7AJ94G0IPUs8ZUmEDzxES
         JsjLZl1f2MpBzRN6+L3kZ6u7UkB6aktI6zG3HWkWXJN/vQ/rnFhG9lnuDv6PFe1YDY69
         nI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2HZEMfRIxWFvhgNolJdHE+4fmvokBk1d/agQn4Bf6T4=;
        b=q13/eXUgsLzD7+1MnvxN0pziwk3sqvbVDQRfArL/uHoMETkB1dMKBsgrVTOuwrxGCm
         FtbFW9SnwGYseR1lNQ3NFlfXP+AMnBg+q2lx7UXNpiY0h44BAYGpb4wOrrxRTHDP0QPL
         0p4j7J+/e7Ldau5AwwWbbwxt1UCxMCK4I5xkWhYoNHOuQAXpJ/6rbNuViteQrTIctU72
         fc4MM7onkmvygRTZ6evXOUgEMi6kxo05bxx2W6MX6LfGKNwTvVs6zlelSty+30WpK1XZ
         dY+7BmFiHAE/2zvbOGUVk6I4A/cy7hEbuVXPJaWnl7F7MB7+OSlhCM1DEV9UtbP6Kr4T
         3qyQ==
X-Gm-Message-State: AJIora97BwvHGak9x7prd9JhvD2EAWHdXdcU90FMKaCFYtLXsDZeZ60o
        ezUTeOoH2kV5+u2oQVlMnTQRz8H/+LH0NkQaQqg716H96j6CX0Mg+9eClw+1bJpMA/JhYdOcVFw
        EaYxpVBTAodgdg17hY8ouRyrzDaY/RGZdFDoIG+Mi9UlQgbzjKd0b91GLNx/V
X-Google-Smtp-Source: AGRyM1vSLQ762BI4fr+CHdSH7bPhrBuiIxkFdEVnBv9ahJasB6kow7g6SLnoXz4WYJnTfC/qn+sEUP/QTeGX
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1192:b0:1e2:da25:4095 with SMTP id
 gk18-20020a17090b119200b001e2da254095mr737030pjb.240.1655155542892; Mon, 13
 Jun 2022 14:25:42 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:23 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 10/10] KVM: selftests: Cache binary stats metadata for
 duration of test
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to improve performance across multiple reads of VM stats, cache
the stats metadata in the VM struct.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  5 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 32 ++++++++++---------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 537b8a047d6e..daf201174d2a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -84,6 +84,11 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+
+	/* Cache of information for binary stats interface */
+	int stats_fd;
+	struct kvm_stats_header stats_header;
+	struct kvm_stats_desc *stats_desc;
 };
 
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0d97142a590e..787aeb0c61f3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -551,6 +551,12 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	if (vmp == NULL)
 		return;
 
+	/* Free cached stats metadata and close FD */
+	if (vmp->stats_fd) {
+		free(vmp->stats_desc);
+		close(vmp->stats_fd);
+	}
+
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
 		__vm_mem_region_delete(vmp, region, false);
@@ -1942,32 +1948,28 @@ void read_stat_data(int stats_fd, struct kvm_stats_header *header,
 void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		   size_t max_elements)
 {
-	struct kvm_stats_desc *stats_desc;
-	struct kvm_stats_header header;
 	struct kvm_stats_desc *desc;
 	size_t size_desc;
-	int stats_fd;
 	int i;
 
-	stats_fd = vm_get_stats_fd(vm);
-
-	read_stats_header(stats_fd, &header);
-
-	stats_desc = read_stats_descriptors(stats_fd, &header);
+	if (!vm->stats_fd) {
+		vm->stats_fd = vm_get_stats_fd(vm);
+		read_stats_header(vm->stats_fd, &vm->stats_header);
+		vm->stats_desc = read_stats_descriptors(vm->stats_fd,
+							&vm->stats_header);
+	}
 
-	size_desc = get_stats_descriptor_size(&header);
+	size_desc = get_stats_descriptor_size(&vm->stats_header);
 
-	for (i = 0; i < header.num_desc; ++i) {
-		desc = (void *)stats_desc + (i * size_desc);
+	for (i = 0; i < vm->stats_header.num_desc; ++i) {
+		desc = (void *)vm->stats_desc + (i * size_desc);
 
 		if (strcmp(desc->name, stat_name))
 			continue;
 
-		read_stat_data(stats_fd, &header, desc, data, max_elements);
+		read_stat_data(vm->stats_fd, &vm->stats_header, desc,
+			       data, max_elements);
 
 		break;
 	}
-
-	free(stats_desc);
-	close(stats_fd);
 }
-- 
2.36.1.476.g0c4daa206d-goog

