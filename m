Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924792190C1
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgGHTel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:34:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56053 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726872AbgGHTeg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 15:34:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwkOICvOQaXOWcko8kpLlTGev7mN/mGmU8J6lWaTsxY=;
        b=ip3T8f6tccdkxoFoWGtI/tpKytfsNaprv1faEEgTjJoNVQzzCM17UxlC4D/YTyyYB80iWB
        qvdgF1oX0wm3fYzSJwcpYaqS0pXtp4bOS64UdOX1t1Vtinf/TlbPzlAPlvLNdc9YVqbAuh
        BPY6EBFLFXp8XahvMcvW4pil+NM7B7I=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-p1pXpONHOfiSxeq2LF7Ifw-1; Wed, 08 Jul 2020 15:34:33 -0400
X-MC-Unique: p1pXpONHOfiSxeq2LF7Ifw-1
Received: by mail-qk1-f198.google.com with SMTP id k16so18438443qkh.12
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwkOICvOQaXOWcko8kpLlTGev7mN/mGmU8J6lWaTsxY=;
        b=bAr9fMeukonBSRabhO3ehSsTQdWkKprw+JHfCVVrpxvffnGQBaazlv7j5u7UWLNme1
         7+nyFD3gno4WFb8qVp7Illso+PdcXktxTLmRwGPaJX9MpIdNoS4Bp5wg8GT66UARQwbS
         GfUx/G3aI8JQdhbOX5itIW8cY1dDp/EElYkWnsaRQb1lsqlRWoYNT//A6lT/k/GHYlyT
         /RcLzWujTWYeiSDF/dRkVlG3F152cAmPAgcHACkETXmHbV9tPFN8GuYarK2MQjMZTrKF
         zQf2QxpEUlWgALRRxYK9Dfp5l+auG6FGN0W7Q/zKL1AYJO8h/1nQmg5fdv2JQecbTkTk
         Z4Sw==
X-Gm-Message-State: AOAM533CxLF/5yYp205EnyF1nHV6BQzRMEkKjRzA/ZybgHkt3H6ej1t2
        Tie7aXinBF+elLxVsKnjuvXtRaEB1quw+yqAVRf/cWp5Ql+x1sayzSNaR4FNcqWl0pr57XQ395Q
        0cO0lVMqt88bQ
X-Received: by 2002:ac8:47ce:: with SMTP id d14mr61485542qtr.285.1594236873031;
        Wed, 08 Jul 2020 12:34:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzr9Hn7DgKOB0eSRHWqePldCPb4gTgHpgitkXaRkiQjSqZ7uVPKSjC183UXZv6LE8NZNKN3dg==
X-Received: by 2002:ac8:47ce:: with SMTP id d14mr61485520qtr.285.1594236872793;
        Wed, 08 Jul 2020 12:34:32 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id f18sm664884qtc.28.2020.07.08.12.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 12:34:32 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v11 13/13] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Wed,  8 Jul 2020 15:34:08 -0400
Message-Id: <20200708193408.242909-14-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708193408.242909-1-peterx@redhat.com>
References: <20200708193408.242909-1-peterx@redhat.com>
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

