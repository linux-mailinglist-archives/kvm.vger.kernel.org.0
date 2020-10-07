Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75391286977
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgJGUyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:54:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728658AbgJGUyH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602104045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVF5RFO9TPcnd1hmSsZzSNQ/sV8XWPAAmLyQ5cmt6Ek=;
        b=PkCqPNqvlywZ39jGP2tblV0iW38aRSPoTtGfN82W+maqwELJc8NJnK+VY4Ezes6Qk3OMxz
        I3C1s2lnWSotcyMHbE4JDAjgW9DLztTNQnK/pGYB2PP/CnUMDCwr7QZogNTXR/S2cKN1yO
        vzmSZXp3X6j+CsO1focPApX+vGBI+V0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-phTRF1Z3N5G55bclFO2vfw-1; Wed, 07 Oct 2020 16:54:04 -0400
X-MC-Unique: phTRF1Z3N5G55bclFO2vfw-1
Received: by mail-qk1-f199.google.com with SMTP id q15so2208603qkq.23
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 13:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVF5RFO9TPcnd1hmSsZzSNQ/sV8XWPAAmLyQ5cmt6Ek=;
        b=OrTEKzMj5AnLQPZcxzm9Q8HnzY9NplZ8bq6TBwKBuJJy80j9RI+QB7xOpxQKywno7+
         4NaHByqJVE1A4DHAKB2uIsgAf8q8wOr1RPiOOGWlVk0cmzZrTJbyODToQfL7d+37R1l1
         paTGJ6ChYgijySdzv6wMCIphv0B3YcQWutTb/iak7hpLvuYfEwhKeTVma8Z++91RV7fQ
         ZsU0aFSDPPcKMZpHCkBeAerYI8d2IQirMtIOFZXv3AXoZ9go1mz3YLnhzYQnqGs1J8Pr
         Iq9An8rurdrln5RJwbH1tFLfMldtb3xEM8mY3VOfqFCIHIMGF3Fe/NgpCpQLewtXvmoy
         Jiag==
X-Gm-Message-State: AOAM530WJQ0kdzAvEuk3pefStwWLM8sv+/9rUZK3riZrta/PZ0x3E1yh
        ekRvQJnwU+2mivYmD3p0a6HRcCKZNIfYvH8bErbhCmwfbI5GyRy+AS0IBCBLrhM48Aey80iFqmP
        mw75g4UuwUZio
X-Received: by 2002:a0c:c446:: with SMTP id t6mr5014301qvi.55.1602104043166;
        Wed, 07 Oct 2020 13:54:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYqoIA45gnItx9e1uDGjoGYWvWkKhYrg5PlGOwuR7EEvMm7OAkh0Tv/IMEQdFOWHF+WYPVDQ==
X-Received: by 2002:a0c:c446:: with SMTP id t6mr5014283qvi.55.1602104042948;
        Wed, 07 Oct 2020 13:54:02 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j24sm2390695qkg.107.2020.10.07.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 13:54:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v14 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Wed,  7 Oct 2020 16:53:42 -0400
Message-Id: <20201007205342.295402-15-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007205342.295402-1-peterx@redhat.com>
References: <20201007205342.295402-1-peterx@redhat.com>
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

