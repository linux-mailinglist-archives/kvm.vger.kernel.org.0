Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51A51DFB80
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbgEWW5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388209AbgEWW5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 18:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Frsr00VTIsYjdqDeTzSRco7BaTYBstaIvbV6rdyHlg=;
        b=hPeq8y5Yr0Wco57otQWyfO5Uhx+9H/0FhBNNoi/apcWUTbxrRS1pUz1XX82WuZ8lBNKZN6
        Z30wYDovv0isUZ0pcQWy5YIIq1Z6GF4Bqn2FmUSBNVlWDB/fvVjht0/Co8hC/cL46ugUTo
        LcJTOcYYmRvQeAqcE+JJ+M/NT3B7+9k=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-Re5h6FwtNuC7LcMAJOHNVg-1; Sat, 23 May 2020 18:57:33 -0400
X-MC-Unique: Re5h6FwtNuC7LcMAJOHNVg-1
Received: by mail-qt1-f199.google.com with SMTP id l11so15889408qti.19
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Frsr00VTIsYjdqDeTzSRco7BaTYBstaIvbV6rdyHlg=;
        b=uIHRJNsiPloDEK+5MCYLpmmSbF5FrP+lONk96Y+IAL9se+7UTAZm3dZgp3vSYSb/l4
         DtNhbxCFXVeAkat4DSZy18JUI8siWEmDNk7NW9Lgn3DCU2fnZr4k/37iUhEV2UsfeKSH
         ZvBZFiB5oDjY6/GVWWcvxwo25ZsDK6XhGzC9jvbwa46aRLTDtPmVQQtZI32wUIeJpI3e
         bxUR5Vk0dMdPrtUHWfOY2BvLcBFMZfeaUcIz2nSW32GFwkXGviriUN5LC7iP1hcTG0oL
         0nuMG8SZwmSTSqpjV5FOiq7J4OazYiw/cQUs7tYTzN0vBeMSF/hIOsnP+OrtJwgCYeLW
         u23g==
X-Gm-Message-State: AOAM5315BVwYfrw4Jh8/yoHR0HUHt6OrZwj8f7HtaT7M0nbnG3IlGnU1
        KUOZT9qzsOm/UXkLzYAPF89sYGxsAoKW8XjieXkMwpfza5yWAThclHlwVmprbW6L0e5TUg1Z419
        FMQeXTeD7G5QS
X-Received: by 2002:ad4:4e6a:: with SMTP id ec10mr9525122qvb.225.1590274653086;
        Sat, 23 May 2020 15:57:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw53SD976P2nmnNqsbQ9nHJg54QLoxaSfdQgpWRaiMYWG6t1XJ2AQctXYTuUqNhOv+LKv8Ing==
X-Received: by 2002:ad4:4e6a:: with SMTP id ec10mr9525109qvb.225.1590274652868;
        Sat, 23 May 2020 15:57:32 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:32 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v9 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Sat, 23 May 2020 18:56:56 -0400
Message-Id: <20200523225659.1027044-12-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a hook for the checks after vcpu_run() completes.  Preparation
for the dirty ring test because we'll need to take care of another
exit reason.

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.26.2

