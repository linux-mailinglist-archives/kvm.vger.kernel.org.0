Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286791DFB9A
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 01:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388189AbgEWXHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 19:07:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388163AbgEWXHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 19:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590275221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwkOICvOQaXOWcko8kpLlTGev7mN/mGmU8J6lWaTsxY=;
        b=XeBnjUg7TyfJ4HkWwBcvjSvuaXqJeXsoN305i0DsDl08afpNfEk0TVnaBrqWPRenx3Kt22
        qvYkgAqi1yEqZDHoOm8McXsefspeDGMo1K3qi57VlUf/Yxy/Ge81bNq3j3YT8L4fmCvlnk
        sh+CKbSpZlZzXOnPy9r+wskXvNdEgBw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-2Ylko_k3PgS_ZWe-Y_RvmA-1; Sat, 23 May 2020 19:06:59 -0400
X-MC-Unique: 2Ylko_k3PgS_ZWe-Y_RvmA-1
Received: by mail-qk1-f198.google.com with SMTP id u128so1601487qkf.21
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 16:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwkOICvOQaXOWcko8kpLlTGev7mN/mGmU8J6lWaTsxY=;
        b=fkYRwSpNUGDugusioNbwAV6+FIqj/qFjNtALjddi0hMqJTU+xb0CtytW3lrqu0Hv6j
         cvyS2WJEN4M8Jmc6K/x6DhS434wgE/RoJvpD25Ieez1EKg3soUBQWE+mzxSrYSicQ6Sy
         ZhXXruBf6Zif/yaLi84jkd6mSTe+WcZjdATB4AhRPtJ09nhDHmtpH+MROyEwDo6HMGVs
         KLl9qT3Wk6uxyz201fj8Zc7M6pp6I56gH8teHtwQhjEXcuj8x3h+m7bwWSm/ywpafOO0
         PaK45O93xj3Zn+WDXhnD96iaVesXBT1mdvkTh4IXr8daufF77B4rnqnVHB1Kku6rrWX4
         DhBQ==
X-Gm-Message-State: AOAM533o/C/y5kxDqM9WEPxmE5IU3+PHjYdnQu2zo9IHd6xCXEsMD3G/
        w4ZUEK++7POijUvOmPzYaMKFIIGz/V9qUQVuuqbWX3nZktpJQZhjlNVwU8MQ89qIJrEAiT5Oc0F
        DoJQMMvPAYdne
X-Received: by 2002:ae9:e712:: with SMTP id m18mr22284736qka.11.1590275218414;
        Sat, 23 May 2020 16:06:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3+7M+BOYMIiRez3HPTu3ttrMiTKzHgpFweKE3yDe+kC5BAlNphOrLXyvBosx0xXK6Njm+dw==
X-Received: by 2002:ae9:e712:: with SMTP id m18mr22284726qka.11.1590275218157;
        Sat, 23 May 2020 16:06:58 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id d207sm10494590qkc.49.2020.05.23.16.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 16:06:57 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v9 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Sat, 23 May 2020 19:06:54 -0400
Message-Id: <20200523230654.1027882-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only used to override the existing dirty ring size/count.  If
with a bigger ring count, we test async of dirty ring.  If with a
smaller ring count, we test ring full code path.  Async is default.

It has no use for non-dirty-ring tests.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 4b404dfdc2f9..80c42c87265e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -168,6 +168,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 /* Only way to pass this to the signal handler */
 static struct kvm_vm *current_vm;
@@ -250,7 +251,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
 	 */
-	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+	vm_enable_dirty_ring(vm, test_dirty_ring_count *
 			     sizeof(struct kvm_dirty_gfn));
 }
 
@@ -272,7 +273,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	uint32_t count = 0;
 
 	while (true) {
-		cur = &dirty_gfns[*fetch_index % TEST_DIRTY_RING_COUNT];
+		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
 			break;
 		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
@@ -778,6 +779,9 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
+	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -833,8 +837,11 @@ int main(int argc, char *argv[])
 	guest_mode_init(VM_MODE_P40V48_4K, true, true);
 #endif
 
-	while ((opt = getopt(argc, argv, "hi:I:p:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
 		switch (opt) {
+		case 'c':
+			test_dirty_ring_count = strtol(optarg, NULL, 10);
+			break;
 		case 'i':
 			iterations = strtol(optarg, NULL, 10);
 			break;
-- 
2.26.2

