Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60D23B2856
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 09:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhFXHMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 03:12:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8436 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhFXHLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 03:11:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9WQK1F5nzZklD;
        Thu, 24 Jun 2021 15:06:33 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 15:09:34 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 24 Jun 2021 15:09:34 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <vkuznets@redhat.com>
CC:     <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: selftests: Fix mapping length truncation in m{,un}map()
Date:   Thu, 24 Jun 2021 15:09:31 +0800
Message-ID: <20210624070931.565-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

max_mem_slots is now declared as uint32_t. The result of (0x200000 * 32767)
is unexpectedly truncated to be 0xffe00000, whilst we actually need to
allocate about, 63GB. Cast max_mem_slots to size_t in both mmap() and
munmap() to fix the length truncation.

We'll otherwise see the failure on arm64 thanks to the access_ok() checking
in __kvm_set_memory_region(), as the unmapped VA happen to go beyond the
task's allowed address space.

 # ./set_memory_region_test
Allowed number of memory slots: 32767
Adding slots 0..32766, each memory region with 2048K size
==== Test Assertion Failure ====
  set_memory_region_test.c:391: ret == 0
  pid=94861 tid=94861 errno=22 - Invalid argument
     1	0x00000000004015a7: test_add_max_memory_regions at set_memory_region_test.c:389
     2	 (inlined by) main at set_memory_region_test.c:426
     3	0x0000ffffb8e67bdf: ?? ??:0
     4	0x00000000004016db: _start at :?
  KVM_SET_USER_MEMORY_REGION IOCTL failed,
  rc: -1 errno: 22 slot: 2615

Fixes: 3bf0fcd75434 ("KVM: selftests: Speed up set_memory_region_test")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d79d58eada9f..85b18bb8f762 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -376,7 +376,7 @@ static void test_add_max_memory_regions(void)
 	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
 		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
 
-	mem = mmap(NULL, MEM_REGION_SIZE * max_mem_slots + alignment,
+	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
 		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
 	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
@@ -401,7 +401,7 @@ static void test_add_max_memory_regions(void)
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Adding one more memory slot should fail with EINVAL");
 
-	munmap(mem, MEM_REGION_SIZE * max_mem_slots + alignment);
+	munmap(mem, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment);
 	munmap(mem_extra, MEM_REGION_SIZE);
 	kvm_vm_free(vm);
 }
-- 
2.19.1

