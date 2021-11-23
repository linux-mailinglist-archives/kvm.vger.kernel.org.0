Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E04F45A44B
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhKWODM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 09:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhKWODL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 09:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637676002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J+U2ly5t8pjpukreZ+mwG58hWGw3qavINk7r30wyotQ=;
        b=FzhYY34mUX6e1M1C0IJaf+Z70sX685fliY1MvuPLjm2RDRVSbr376ZTj6b8UbXx/czEHCT
        W/AJ3ehuNq1q0NU5xZ7LqXbCi60fuEVDWOjUPbw/IXC4P9OEG77BGSYYUq1z90CFNLpAFI
        2H11BdM1A5n3s23hzbz386D9a4+JBfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-406-mp2Gm_tkMRyg_0jsb2KKiw-1; Tue, 23 Nov 2021 08:59:57 -0500
X-MC-Unique: mp2Gm_tkMRyg_0jsb2KKiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87D5FEC1A2;
        Tue, 23 Nov 2021 13:59:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E69C5C1D5;
        Tue, 23 Nov 2021 13:59:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
Date:   Tue, 23 Nov 2021 14:59:53 +0100
Message-Id: <20211123135953.667434-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
Changes since v1:
- Drop 'NOFD' define replacing it with 'int nr_fds_wanted' [Sean]
- Drop 'errno' printout as TEST_ASSERT() already does that.
---
 .../selftests/kvm/kvm_create_max_vcpus.c      | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index f968dfd4ee88..ca957fe3f903 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/resource.h>
 
 #include "test_util.h"
 
@@ -40,10 +41,31 @@ int main(int argc, char *argv[])
 {
 	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
 	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	/*
+	 * Number of file descriptors reqired, KVM_CAP_MAX_VCPUS for vCPU fds +
+	 * an arbitrary number for everything else.
+	 */
+	int nr_fds_wanted = kvm_max_vcpus + 100;
+	struct rlimit rl;
 
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
 
+	/*
+	 * Check that we're allowed to open nr_fds_wanted file descriptors and
+	 * try raising the limits if needed.
+	 */
+	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl), "getrlimit() failed!");
+
+	if (rl.rlim_cur < nr_fds_wanted) {
+		rl.rlim_cur = nr_fds_wanted;
+
+		if (rl.rlim_max <  nr_fds_wanted)
+			rl.rlim_max = nr_fds_wanted;
+
+		TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
+	}
+
 	/*
 	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
 	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
-- 
2.33.1

