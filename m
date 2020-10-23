Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F8929770F
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754951AbgJWSfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:35:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754928AbgJWSec (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVF5RFO9TPcnd1hmSsZzSNQ/sV8XWPAAmLyQ5cmt6Ek=;
        b=fijiQJYZg/FDfS7kS3aSBBML/0ra2bszQJfyLbOt1gukydcrW0r9wjdm/yYY05lke/a2QA
        5j7yKvKMoHxBiDLpnFBBlg9Ebn9jtUAvkZeZifyO1DDK4d1f2t8Bug9IEIei8B/DmoNxpl
        8Gumv+H66zO+Ai0U8Ci03cMoHYT4SIo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-iOlfcw8YOZ228o4LKYt93Q-1; Fri, 23 Oct 2020 14:34:28 -0400
X-MC-Unique: iOlfcw8YOZ228o4LKYt93Q-1
Received: by mail-qk1-f200.google.com with SMTP id b7so1616852qkh.20
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVF5RFO9TPcnd1hmSsZzSNQ/sV8XWPAAmLyQ5cmt6Ek=;
        b=Q4xTGKUj00FXCgrpBoC7rSwchHLwT09aqZPET2XKuXmNblOXskEFVeFvhcr3Hw04wO
         wdE/0IMvMxCTDtkSFKxRw1elQRDE1tYwLaCTJp9IC/FxVqwYrqNDqFjq/w9V2dut8vcO
         oLgFFc2mDlOt4eJ/rCpUX0v9BdK4StDjPxJ+kmZiwjcHFKKH/y8GczZIV91BeMMMUAum
         U0s3p++yplTmjzk57az96wL009/zrjMeo/X9JrN2Nggkrk2tP0/4GkUX+NxTvRupEzYz
         YG6bgKKWJ9QJW+lni+WgNVElGZRkRnpNQed4KpEGDAmdGb5GHqb+x0HjHuqrcp7yQ1c/
         r9bw==
X-Gm-Message-State: AOAM5313IiE++qBgSXh4JRFB/xUVVALNilYlE94oGv4Qex6sPsQoFc5x
        gMx6xCBSA9LhJcVlfeq55P1/Jb563YD25/fCwV+6CTIRm7Pbai/HarUWwjEhW6E6ueyUS5AE5Jd
        oqTmxMkao5Cul
X-Received: by 2002:ad4:55ea:: with SMTP id bu10mr3897135qvb.28.1603478067511;
        Fri, 23 Oct 2020 11:34:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXRAVp/Qedn6rtznTnWgwn3EMEI5OC2DvzGQZ3CsgeuShgCK9OZB9T7BHXFVd52vlydhY75w==
X-Received: by 2002:ad4:55ea:: with SMTP id bu10mr3897118qvb.28.1603478067247;
        Fri, 23 Oct 2020 11:34:27 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:26 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Fri, 23 Oct 2020 14:33:58 -0400
Message-Id: <20201023183358.50607-15-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 913583cb22b8..c2cf11e24e0a 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -182,6 +182,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 /* Only way to pass this to the signal handler */
 static struct kvm_vm *current_vm;
@@ -264,7 +265,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
 	 */
-	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+	vm_enable_dirty_ring(vm, test_dirty_ring_count *
 			     sizeof(struct kvm_dirty_gfn));
 }
 
@@ -286,7 +287,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	uint32_t count = 0;
 
 	while (true) {
-		cur = &dirty_gfns[*fetch_index % TEST_DIRTY_RING_COUNT];
+		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
 			break;
 		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
@@ -789,6 +790,9 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
+	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -844,8 +848,11 @@ int main(int argc, char *argv[])
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

