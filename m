Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7A8199E94
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgCaTBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:01:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30237 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731173AbgCaTBS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/6pv55/PbmGOHXU3lAv5xTE6lvOy1tPaO+Eq7xV6aI=;
        b=XMxJaWudTs3P3/MD4eZdmSvrgTSIpkVyf77PbUcT/UtTbfO8ryBs3O9IjVlrxR7Un56KEb
        EeMcBgnUlzn/D4LDQouuaNdGrXNF76oTlL7GsW2nQenBWV96XQXXiWUoJuXls7xoHBUrPK
        5LkiX/1y9ZGmzbzA/Xm6GHmIzAP2eLc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-i99LK3mUM_auGEr3LJc5eQ-1; Tue, 31 Mar 2020 15:01:15 -0400
X-MC-Unique: i99LK3mUM_auGEr3LJc5eQ-1
Received: by mail-wr1-f71.google.com with SMTP id y1so12250394wrp.5
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/6pv55/PbmGOHXU3lAv5xTE6lvOy1tPaO+Eq7xV6aI=;
        b=q1Y+j/aghqkqWe4qKomMGhPd8jhR0v7pLLyjSrHggT6pDVb1hR0TBm/n5XnMe33uo6
         rE76K8FhAEMAFdW6lBbjjqmf5Je37Zup8RfIop0ApY1kyhcY4hQbGbptNxoU4nQSl6K6
         kUdwNBRULRYg2rH/sHV72pqcJ8uPqJ22LWvlE5F9UmUIHq8TwagRC58DIOM3SSAQW8TD
         MDkFBEmowb0Z2uif0Uz02QBcGDj98CGY61oIcFEJCOkyrUq1Z076PQ1AhrICKx7Fn25P
         r1I4ODmhYce1RBKqSURXnEtUXpmSOE9CWSWblw7XhNahN0qJVkj1IQ3CWoAgcBOLdpjy
         2R1A==
X-Gm-Message-State: AGi0PuYtUlT5dJRpvkvy2GJanbAHSfibMTkDnDBJuDfvrvHfGIf13g18
        Y3ua5FnYnGYCdtilQfOH1kzewkWo7im96PDM/C1a6GHMV2gbGNLJnYwm2zOVf27lYBXNzxfvz2y
        nuXPfcWLUDkN1
X-Received: by 2002:a1c:1942:: with SMTP id 63mr297425wmz.133.1585681272696;
        Tue, 31 Mar 2020 12:01:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ9h8+F7rIf5huhCtVoYCjzH6pX54pEwFayM8bEg2v2YVSWrUFxZ/smyWk6d5DC7WLNSj4eTg==
X-Received: by 2002:a1c:1942:: with SMTP id 63mr297409wmz.133.1585681272450;
        Tue, 31 Mar 2020 12:01:12 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id f14sm5039226wmb.3.2020.03.31.12.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:01:11 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v8 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Tue, 31 Mar 2020 14:59:57 -0400
Message-Id: <20200331190000.659614-12-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a hook for the checks after vcpu_run() completes.  Preparation
for the dirty ring test because we'll need to take care of another
exit reason.

Since at it, drop the pages_count because after all we have a better
summary right now with statistics, and clean it up a bit.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 36 +++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 139ccb550618..a2160946bcf5 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -178,6 +178,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
 
+static void default_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+		    "Invalid guest sync status: exit_reason=%s\n",
+		    exit_reason_str(run->exit_reason));
+}
+
 struct log_mode {
 	const char *name;
 	/* Return true if this mode is supported, otherwise false */
@@ -187,16 +196,20 @@ struct log_mode {
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
+	/* Hook to call when after each vcpu run */
+	void (*after_vcpu_run)(struct kvm_vm *vm);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
 		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 	{
 		.name = "clear-log",
 		.supported = clear_log_supported,
 		.create_vm_done = clear_log_create_vm_done,
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 };
 
@@ -247,6 +260,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
 }
 
+static void log_mode_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->after_vcpu_run)
+		mode->after_vcpu_run(vm);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -261,25 +282,16 @@ static void *vcpu_worker(void *data)
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
-	struct kvm_run *run;
-
-	run = vcpu_state(vm, VCPU_ID);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
-	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 
 	while (!READ_ONCE(host_quit)) {
+		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
+		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
-			pages_count += TEST_PAGES_PER_LOOP;
-			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
-		} else {
-			TEST_FAIL("Invalid guest sync status: "
-				  "exit_reason=%s\n",
-				  exit_reason_str(run->exit_reason));
-		}
+		log_mode_after_vcpu_run(vm);
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
-- 
2.24.1

