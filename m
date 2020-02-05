Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C515250D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 04:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBEDAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 22:00:49 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29860 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727855AbgBEDAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 22:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580871648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MkSZ85QIBalZvWs6VFapLnhibOydb3IjnBZ+FKrtyNU=;
        b=ea+7hciIlEEPE0RCfflLfaiP6VtTTQq+ch8qEEoZitEi+rRwCDsUR+pRSs65nArJqG7nih
        1SyNnS6O0GtuAIt1oRokDbaGv0Sjj0Eulhb4HZ99MRcKwCK6oxbZ1+pz2O3t2Ba1An557G
        RIuGmhwW0AkRpdBwPqJ105+NGKBCykc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-VMrgWnQgPS6nVSqvxZMbGQ-1; Tue, 04 Feb 2020 22:00:46 -0500
X-MC-Unique: VMrgWnQgPS6nVSqvxZMbGQ-1
Received: by mail-qv1-f71.google.com with SMTP id g15so623732qvk.11
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 19:00:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MkSZ85QIBalZvWs6VFapLnhibOydb3IjnBZ+FKrtyNU=;
        b=gM5V0EAZNBW1VLAwS6QpJnsAwhtb5R5nJhFUlcKwvRae0odhvQG05haMAcfAnobaPs
         6UgYeAeUBJZ+Ey1dVSJmDEiOICwIAHNPDTwq+DpQhf0TeZa+/v1qi2kc9sQQrFH+rtrp
         eFxx9r0CrG0WJ7VYggb7OkASdm42XqNd/UUHfPTKiD1CZIe+0gyLJiGmsybrzR3fEv7G
         Ot9LBWCOQANUVWMNXT3x21e/Nzc8XmaieszBMcHmu2Y19XhjJl1bkVqoEmqAKaM+G4Iy
         XGr3BQJgMBOKkLBYUvz7pZGp7DhQyLCP53sepQzhZLO2+YzZxGqHv/aT2DONrBzMP5g5
         2eMg==
X-Gm-Message-State: APjAAAXuV3zuyqM4xdJoDWPaXlIntL1S3uqn6Fn9uoIVx+i4SQ39D3GG
        q07QmhunpKYt2YnKRGqfRRdqv7vnZC+AoWSF0lp3KXQuUnRPmJIuaLPQue493+dTPL3zWwPpzSh
        OWR9Ix0WNY5m3
X-Received: by 2002:ae9:f30e:: with SMTP id p14mr31895403qkg.186.1580871646039;
        Tue, 04 Feb 2020 19:00:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3lyYvbqkVDgZHul6XJFSDUjVusufeLIOwhSUi2JAXcDok/5lHyajvbFw+VyTI/6GvK5X8ow==
X-Received: by 2002:ae9:f30e:: with SMTP id p14mr31895381qkg.186.1580871645788;
        Tue, 04 Feb 2020 19:00:45 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 2sm12111776qkv.98.2020.02.04.19.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 19:00:45 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, peterx@redhat.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: [PATCH 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Tue,  4 Feb 2020 22:00:42 -0500
Message-Id: <20200205030042.367713-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205025105.367213-1-peterx@redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
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

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 6c754e91fc50..40312fdbe0d2 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -163,6 +163,7 @@ enum log_mode_t {
 /* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
 static enum log_mode_t host_log_mode;
 pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 /* Only way to pass this to the signal handler */
 struct kvm_vm *current_vm;
@@ -235,7 +236,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
 	 */
-	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+	vm_enable_dirty_ring(vm, test_dirty_ring_count *
 			     sizeof(struct kvm_dirty_gfn));
 }
 
@@ -257,7 +258,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	uint32_t count = 0;
 
 	while (true) {
-		cur = &dirty_gfns[*fetch_index % TEST_DIRTY_RING_COUNT];
+		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
 			break;
 		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
@@ -744,6 +745,9 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
+	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -799,8 +803,11 @@ int main(int argc, char *argv[])
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
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
2.24.1

