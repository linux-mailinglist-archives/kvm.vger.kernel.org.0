Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1EA179726
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgCDRvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:51:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730108AbgCDRuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NW1AcDQfFoZ1CPYH/WHL25mucE4+tV4MUo1O0BQYlPA=;
        b=XEmynl+JQAPc7SK+DG8HQi6PpyKg1YUwKHK/7lN9U1Zg4Wza3mGrsCPt25b+WQSR7u6b8a
        LLAMFbuvFn2Nk3snLjFZ7yj+Se+fO3PaNowZZ5JZqJVwbQzDNpvMKRVh+y8/e2++eegGDj
        c9rq4SmGJAYixrb8WNxsDBo/JFtLT/o=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-kUbSpZdJNFCwREceNsgppA-1; Wed, 04 Mar 2020 12:50:29 -0500
X-MC-Unique: kUbSpZdJNFCwREceNsgppA-1
Received: by mail-qt1-f200.google.com with SMTP id y3so1968852qti.15
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:50:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NW1AcDQfFoZ1CPYH/WHL25mucE4+tV4MUo1O0BQYlPA=;
        b=OmaMtJECcOpa5ZEVnVWhqKOFmjF3x96SNc+3Zhx9WlHgE7DNI0L0svw2SecPMGcakj
         vj0yLYP8twKEnKPAX5BiZd5HXAFuvSIuLuhsnQVBEWPENGnIB0IHLi6fIf9cOfU5OpDu
         Ktc2LdnRp0lP4z/RMDxLoULGmpNEy83O6FdO/JWxCiuRoRt3KOJXEwnR0SnstGTMDt/6
         FbNIMNGs31I74S0fcYe23SEv2KGcqh0aHyJTraX2mz9mbEAsFtAuLXtF9SJ2iRXIqZZw
         TGMAxQlDQTCTFAib8ZKJrkOYwlu5nI/Yhi16QBLDk7mQ9G1xWMNqyokLjE3UbWn+FFD6
         Grfw==
X-Gm-Message-State: ANhLgQ136WzPnBKPNPgao23nrFgbC2lSIpAHXI/b9ivhBxNLuKB/RqAL
        AlDo79ivDQN4KsuOuo2EjwlwMaUJbqVqO7ERsLxbMUIIPkj9YkjemoLW8Axdy8sXR6AtzSL3H4h
        wjvH+/sIrgs2z
X-Received: by 2002:ac8:7302:: with SMTP id x2mr3622991qto.62.1583344229038;
        Wed, 04 Mar 2020 09:50:29 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv4UsKzSsFiMNr3qwjtSUDN0+s9VsHoUhtbC4/r5iPOuRtYdDABU6Uaw5t1VrZZ3UJ+989j2Q==
X-Received: by 2002:ac8:7302:: with SMTP id x2mr3622907qto.62.1583344227777;
        Wed, 04 Mar 2020 09:50:27 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n4sm1116771qkk.88.2020.03.04.09.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:50:27 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Wed,  4 Mar 2020 12:49:44 -0500
Message-Id: <20200304174947.69595-12-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
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
index 2d53c89bf0bd..798f7bad00bc 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -173,6 +173,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -182,16 +191,20 @@ struct log_mode {
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
 
@@ -241,6 +254,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -254,31 +275,17 @@ static void *vcpu_worker(void *data)
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

