Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C01629F600
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 21:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgJ2URY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 16:17:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgJ2URW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 16:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604002641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/Ga9qLMXiSt+t8rm7ErthD7fYkO9+JKlbonBWSv1No=;
        b=KMwAy9E0+Bb3epJ2DFZQKKSZcKIObV055JdYlMjBuu7PjsYOFYBzHwP1PaV0htvgV9CDxb
        Vf1pC//zTU7AocFnDZtPhRolZMbzlej9qjcbkux0reYqzBIfrRCEDSoW4cxJDdCU6PpgqP
        ZUYYvqf9AQPYXSlhweXeuCi9oIuQ8fo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-w33TEpelOZCARxjcKf71Lg-1; Thu, 29 Oct 2020 16:17:14 -0400
X-MC-Unique: w33TEpelOZCARxjcKf71Lg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D09C98030A3;
        Thu, 29 Oct 2020 20:17:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD7776EF68;
        Thu, 29 Oct 2020 20:17:10 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH 1/4] KVM: selftests: Don't require THP to run tests
Date:   Thu, 29 Oct 2020 21:17:00 +0100
Message-Id: <20201029201703.102716-2-drjones@redhat.com>
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
References: <20201029201703.102716-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unless we want to test with THP, then we shouldn't require it to be
configured by the host kernel. Unfortunately, even advising with
MADV_NOHUGEPAGE does require it, so check for THP first in order
to avoid madvise failing with EINVAL.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 23 +++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..3327cebc1095 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -14,6 +14,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <unistd.h>
 #include <linux/kernel.h>
 
 #define KVM_UTIL_PGS_PER_HUGEPG 512
@@ -664,13 +665,21 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	/* As needed perform madvise */
 	if (src_type == VM_MEM_SRC_ANONYMOUS || src_type == VM_MEM_SRC_ANONYMOUS_THP) {
-		ret = madvise(region->host_mem, npages * vm->page_size,
-			     src_type == VM_MEM_SRC_ANONYMOUS ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);
-		TEST_ASSERT(ret == 0, "madvise failed,\n"
-			    "  addr: %p\n"
-			    "  length: 0x%lx\n"
-			    "  src_type: %x",
-			    region->host_mem, npages * vm->page_size, src_type);
+		struct stat statbuf;
+
+		ret = stat("/sys/kernel/mm/transparent_hugepage", &statbuf);
+		TEST_ASSERT(ret == 0 || (ret == -1 && errno == ENOENT),
+			    "stat /sys/kernel/mm/transparent_hugepage");
+
+		TEST_ASSERT(ret == 0 || src_type != VM_MEM_SRC_ANONYMOUS_THP,
+			    "VM_MEM_SRC_ANONYMOUS_THP requires THP to be configured in the host kernel");
+
+		if (ret == 0) {
+			ret = madvise(region->host_mem, npages * vm->page_size,
+				      src_type == VM_MEM_SRC_ANONYMOUS ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);
+			TEST_ASSERT(ret == 0, "madvise failed, addr: %p length: 0x%lx src_type: %x",
+				    region->host_mem, npages * vm->page_size, src_type);
+		}
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
-- 
2.27.0

