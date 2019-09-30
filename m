Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF49C21C5
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfI3NUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:20:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27866 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731303AbfI3NUN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Sep 2019 09:20:13 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8UDILJ6099286
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:11 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2va2b5wxx5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:08 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Sep 2019 14:20:05 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Sep 2019 14:20:01 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8UDJV4J38469904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 13:19:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5669F52050;
        Mon, 30 Sep 2019 13:19:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 3C2C65204E;
        Mon, 30 Sep 2019 13:19:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id F1591E020F; Mon, 30 Sep 2019 15:19:58 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        qemu-s390x <qemu-s390x@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 11/12] s390: do not call memory_region_allocate_system_memory() multiple times
Date:   Mon, 30 Sep 2019 15:19:54 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930131955.101131-1-borntraeger@de.ibm.com>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19093013-0012-0000-0000-00000352126E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19093013-0013-0000-0000-0000218CB4F0
Message-Id: <20190930131955.101131-12-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909300138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Igor Mammedov <imammedo@redhat.com>

s390 was trying to solve limited KVM memslot size issue by abusing
memory_region_allocate_system_memory(), which breaks API contract
where the function might be called only once.

Beside an invalid use of API, the approach also introduced migration
issue, since RAM chunks for each KVM_SLOT_MAX_BYTES are transferred in
migration stream as separate RAMBlocks.

After discussion [1], it was agreed to break migration from older
QEMU for guest with RAM >8Tb (as it was relatively new (since 2.12)
and considered to be not actually used downstream).
Migration should keep working for guests with less than 8TB and for
more than 8TB with QEMU 4.2 and newer binary.
In case user tries to migrate more than 8TB guest, between incompatible
QEMU versions, migration should fail gracefully due to non-exiting
RAMBlock ID or RAMBlock size mismatch.

Taking in account above and that now KVM code is able to split too
big MemorySection into several memslots, partially revert commit
 (bb223055b s390-ccw-virtio: allow for systems larger that 7.999TB)
and use kvm_set_max_memslot_size() to set KVMSlot size to
KVM_SLOT_MAX_BYTES.

1) [PATCH RFC v2 4/4] s390: do not call  memory_region_allocate_system_memory() multiple times

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Message-Id: <20190924144751.24149-5-imammedo@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 hw/s390x/s390-virtio-ccw.c | 30 +++---------------------------
 target/s390x/kvm.c         | 11 +++++++++++
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 8bfb6684cb72..18ad279a00a3 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -154,39 +154,15 @@ static void virtio_ccw_register_hcalls(void)
                                    virtio_ccw_hcall_early_printk);
 }
 
-/*
- * KVM does only support memory slots up to KVM_MEM_MAX_NR_PAGES pages
- * as the dirty bitmap must be managed by bitops that take an int as
- * position indicator. If we have a guest beyond that we will split off
- * new subregions. The split must happen on a segment boundary (1MB).
- */
-#define KVM_MEM_MAX_NR_PAGES ((1ULL << 31) - 1)
-#define SEG_MSK (~0xfffffULL)
-#define KVM_SLOT_MAX_BYTES ((KVM_MEM_MAX_NR_PAGES * TARGET_PAGE_SIZE) & SEG_MSK)
 static void s390_memory_init(ram_addr_t mem_size)
 {
     MemoryRegion *sysmem = get_system_memory();
-    ram_addr_t chunk, offset = 0;
-    unsigned int number = 0;
+    MemoryRegion *ram = g_new(MemoryRegion, 1);
     Error *local_err = NULL;
-    gchar *name;
 
     /* allocate RAM for core */
-    name = g_strdup_printf("s390.ram");
-    while (mem_size) {
-        MemoryRegion *ram = g_new(MemoryRegion, 1);
-        uint64_t size = mem_size;
-
-        /* KVM does not allow memslots >= 8 TB */
-        chunk = MIN(size, KVM_SLOT_MAX_BYTES);
-        memory_region_allocate_system_memory(ram, NULL, name, chunk);
-        memory_region_add_subregion(sysmem, offset, ram);
-        mem_size -= chunk;
-        offset += chunk;
-        g_free(name);
-        name = g_strdup_printf("s390.ram.%u", ++number);
-    }
-    g_free(name);
+    memory_region_allocate_system_memory(ram, NULL, "s390.ram", mem_size);
+    memory_region_add_subregion(sysmem, 0, ram);
 
     /*
      * Configure the maximum page size. As no memory devices were created
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index 97a662ad0ebf..54864c259c5e 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -28,6 +28,7 @@
 #include "cpu.h"
 #include "internal.h"
 #include "kvm_s390x.h"
+#include "sysemu/kvm_int.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/timer.h"
@@ -122,6 +123,15 @@
  */
 #define VCPU_IRQ_BUF_SIZE(max_cpus) (sizeof(struct kvm_s390_irq) * \
                                      (max_cpus + NR_LOCAL_IRQS))
+/*
+ * KVM does only support memory slots up to KVM_MEM_MAX_NR_PAGES pages
+ * as the dirty bitmap must be managed by bitops that take an int as
+ * position indicator. If we have a guest beyond that we will split off
+ * new subregions. The split must happen on a segment boundary (1MB).
+ */
+#define KVM_MEM_MAX_NR_PAGES ((1ULL << 31) - 1)
+#define SEG_MSK (~0xfffffULL)
+#define KVM_SLOT_MAX_BYTES ((KVM_MEM_MAX_NR_PAGES * TARGET_PAGE_SIZE) & SEG_MSK)
 
 static CPUWatchpoint hw_watchpoint;
 /*
@@ -355,6 +365,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      */
     /* kvm_vm_enable_cap(s, KVM_CAP_S390_AIS, 0); */
 
+    kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
     return 0;
 }
 
-- 
2.21.0

