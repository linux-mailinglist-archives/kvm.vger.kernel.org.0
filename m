Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FE71524FC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 03:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBEC7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 21:59:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55456 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728034AbgBEC7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 21:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580871542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aF1BdxIc7NPI7Dsk+3ZH17n/EhvhXEPJcTNSoSkH9Wk=;
        b=VCSKlQGU/4TyP64fsw8XjG/I5oU5tDss7/z/BCb4xH1GZO3x0vWVMH7fb+e50/4bg7QlxL
        PujOXpwFBkT0AgdzCmWNDnG6mx/9TU4dBNPAtJNQjwbH/QP0UDpwphLMp55V2FSKsoWsnm
        oPrVJ1FljygnJiupBL8/ohUXrIOlmH4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-HSXl-euVNVOwxzkqwy6amw-1; Tue, 04 Feb 2020 21:59:01 -0500
X-MC-Unique: HSXl-euVNVOwxzkqwy6amw-1
Received: by mail-qv1-f70.google.com with SMTP id dw11so612646qvb.16
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 18:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aF1BdxIc7NPI7Dsk+3ZH17n/EhvhXEPJcTNSoSkH9Wk=;
        b=lPcp/LmT3ZylnCA4HdPDPuQe0AjzXkV7OlaSjR83FM6AwkVIo9g7pgIqW6AbMOVTv0
         cf1+sljK5Z6V3Bx2UVcqKtKHWjTX+VNmYdcujaiCrToe2CFxAvZevy1G6CIkf1s/qkbv
         YQbazuZK3FjSCVbPm3PnpiKiXa7PP3NWx1Ms9jRUzHspo3PtZYsY80KNqimVhYi64LcK
         JY43gFwqWryk8K2FYIoR+XnIIaRNUMG9Y+WFKiIIjP+S5Hd9rWsZJ8RxjoNwbGDRn7dS
         G6PjFlYevE7UecXtpU9rrGOIq4NaT5mLkEiBmL6JIns9VfS7a4pQNYd4uzdugI40MhPx
         bcPQ==
X-Gm-Message-State: APjAAAXeshQpMx3U6hmi2/bJCi4JeOc5W0MbYDPszV9iuLKDwwfq14Bl
        iNeB7uxGT+qA5DrlGXJqOkMvz5dhLMpnDM/gtvZ85KOSkJ2G9KgKys0HsMAGwklt+kUMaIMzfnr
        qqRDBPPno5ZZZ
X-Received: by 2002:a37:a8f:: with SMTP id 137mr12400368qkk.435.1580871540613;
        Tue, 04 Feb 2020 18:59:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6iuymQEWo4p6WSsu4I/VZfKMlmOnkU8i8JNdOSs5IKO4yUnCfo2RtVlAYGtyecP4HujqyjQ==
X-Received: by 2002:a37:a8f:: with SMTP id 137mr12400354qkk.435.1580871540357;
        Tue, 04 Feb 2020 18:59:00 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id e64sm12961649qtd.45.2020.02.04.18.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 18:58:59 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, peterx@redhat.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: [PATCH 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Tue,  4 Feb 2020 21:58:39 -0500
Message-Id: <20200205025842.367575-8-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205025842.367575-1-peterx@redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
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
 tools/testing/selftests/kvm/dirty_log_test.c | 39 ++++++++++++--------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index a8ae8c0042a8..3542311f56ff 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -168,6 +168,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
 	/* Hook when the vm creation is done (before vcpu creation) */
@@ -175,16 +184,20 @@ struct log_mode {
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
+	/* Hook to call when after each vcpu run */
+	void (*after_vcpu_run)(struct kvm_vm *vm);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
 		.create_vm_done = NULL,
 		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 	{
 		.name = "clear-log",
 		.create_vm_done = clear_log_create_vm_done,
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 };
 
@@ -224,6 +237,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -237,31 +258,17 @@ static void *vcpu_worker(void *data)
 	int ret;
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
-	uint64_t pages_count = 0;
-	struct kvm_run *run;
-
-	run = vcpu_state(vm, VCPU_ID);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
-	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 
 	while (!READ_ONCE(host_quit)) {
+		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
-			pages_count += TEST_PAGES_PER_LOOP;
-			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
-		} else {
-			TEST_ASSERT(false,
-				    "Invalid guest sync status: "
-				    "exit_reason=%s\n",
-				    exit_reason_str(run->exit_reason));
-		}
+		log_mode_after_vcpu_run(vm);
 	}
 
-	DEBUG("Dirtied %"PRIu64" pages\n", pages_count);
-
 	return NULL;
 }
 
-- 
2.24.1

