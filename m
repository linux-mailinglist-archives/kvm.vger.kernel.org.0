Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9912D4593E2
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbhKVRWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 12:22:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231978AbhKVRWk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 12:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637601573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V4iwsaydFrh4nped27vlnuuJKMnx2AzDGMjAJR52oKY=;
        b=KDkQz7R2oN6TvJrPVxQk819nVWbjsw3tZOAw5367v++JnaPkRNd6kNowawLocIVhVf9xPt
        zYsojlDqXJevZkbznsxpB8pS+fHbh0ipSWgtKxWBWgWKCNig4GIEnnYAPSNIKPFxTiV4S6
        4WK1NyjLUElNrTe0w4RDk59AT0CCKy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-owN5nKugMvu4RQ8BTr8_Xg-1; Mon, 22 Nov 2021 12:19:25 -0500
X-MC-Unique: owN5nKugMvu4RQ8BTr8_Xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69B4B87D54E;
        Mon, 22 Nov 2021 17:19:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83B8C19729;
        Mon, 22 Nov 2021 17:19:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
Date:   Mon, 22 Nov 2021 18:19:20 +0100
Message-Id: <20211122171920.603760-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the elevated 'KVM_CAP_MAX_VCPUS' value kvm_create_max_vcpus test
may hit RLIMIT_NOFILE limits:

 # ./kvm_create_max_vcpus
 KVM_CAP_MAX_VCPU_ID: 4096
 KVM_CAP_MAX_VCPUS: 1024
 Testing creating 1024 vCPUs, with IDs 0...1023.
 /dev/kvm not available (errno: 24), skipping test

Adjust RLIMIT_NOFILE limits to make sure KVM_CAP_MAX_VCPUS fds can be
opened. Note, raising hard limit ('rlim_max') requires CAP_SYS_RESOURCE
capability which is generally not needed to run kvm selftests (but without
raising the limit the test is doomed to fail anyway).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/kvm_create_max_vcpus.c      | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index f968dfd4ee88..19198477a10e 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/resource.h>
 
 #include "test_util.h"
 
@@ -19,6 +20,9 @@
 #include "asm/kvm.h"
 #include "linux/kvm.h"
 
+/* 'Safe' number of open file descriptors in addition to vCPU fds needed */
+#define NOFD 16
+
 void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 {
 	struct kvm_vm *vm;
@@ -40,10 +44,28 @@ int main(int argc, char *argv[])
 {
 	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
 	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	struct rlimit rl;
 
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
 
+	/*
+	 * Creating KVM_CAP_MAX_VCPUS vCPUs require KVM_CAP_MAX_VCPUS open
+	 * file decriptors.
+	 */
+	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl),
+		    "getrlimit() failed (errno: %d)", errno);
+
+	if (kvm_max_vcpus > rl.rlim_cur - NOFD) {
+		rl.rlim_cur = kvm_max_vcpus + NOFD;
+
+		if (kvm_max_vcpus > rl.rlim_max - NOFD)
+			rl.rlim_max = kvm_max_vcpus + NOFD;
+
+		TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl),
+			    "setrlimit() failed (errno: %d)", errno);
+	}
+
 	/*
 	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
 	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
-- 
2.33.1

