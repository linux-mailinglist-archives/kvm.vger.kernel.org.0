Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E60C21C9
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfI3NUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:20:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731268AbfI3NUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Sep 2019 09:20:07 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8UDHxeh031463
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:06 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vbgrtwdqq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:06 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Sep 2019 14:20:04 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Sep 2019 14:20:00 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8UDJwtl52166690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 13:19:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A448A4C04E;
        Mon, 30 Sep 2019 13:19:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8638F4C044;
        Mon, 30 Sep 2019 13:19:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 30 Sep 2019 13:19:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 3CAF7E020F; Mon, 30 Sep 2019 15:19:58 +0200 (CEST)
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
Subject: [PULL 09/12] kvm: clear dirty bitmaps from all overlapping memslots
Date:   Mon, 30 Sep 2019 15:19:52 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930131955.101131-1-borntraeger@de.ibm.com>
References: <20190930131955.101131-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19093013-0020-0000-0000-000003730FBB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19093013-0021-0000-0000-000021C8EA27
Message-Id: <20190930131955.101131-10-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=982 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909300138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Currently MemoryRegionSection has 1:1 mapping to KVMSlot.
However next patch will allow splitting MemoryRegionSection into
several KVMSlot-s, make sure that kvm_physical_log_slot_clear()
is able to handle such 1:N mapping.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Message-Id: <20190924144751.24149-3-imammedo@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 accel/kvm/kvm-all.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a85ec09486dd..ff9b95c0d103 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -589,8 +589,8 @@ static int kvm_log_clear_one_slot(KVMSlot *mem, int as_id, uint64_t start,
      * satisfy the KVM interface requirement.  Firstly, do the start
      * page alignment on 64 host pages
      */
-    bmap_start = (start - mem->start_addr) & KVM_CLEAR_LOG_MASK;
-    start_delta = start - mem->start_addr - bmap_start;
+    bmap_start = start & KVM_CLEAR_LOG_MASK;
+    start_delta = start - bmap_start;
     bmap_start /= psize;
 
     /*
@@ -694,8 +694,8 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
                                   MemoryRegionSection *section)
 {
     KVMState *s = kvm_state;
-    uint64_t start, size;
-    KVMSlot *mem = NULL;
+    uint64_t start, size, offset, count;
+    KVMSlot *mem;
     int ret, i;
 
     if (!s->manual_dirty_log_protect) {
@@ -713,22 +713,30 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
 
     kvm_slots_lock(kml);
 
-    /* Find any possible slot that covers the section */
     for (i = 0; i < s->nr_slots; i++) {
         mem = &kml->slots[i];
-        if (mem->start_addr <= start &&
-            start + size <= mem->start_addr + mem->memory_size) {
+        /* Discard slots that are empty or do not overlap the section */
+        if (!mem->memory_size ||
+            mem->start_addr > start + size - 1 ||
+            start > mem->start_addr + mem->memory_size - 1) {
+            continue;
+        }
+
+        if (start >= mem->start_addr) {
+            /* The slot starts before section or is aligned to it.  */
+            offset = start - mem->start_addr;
+            count = MIN(mem->memory_size - offset, size);
+        } else {
+            /* The slot starts after section.  */
+            offset = 0;
+            count = MIN(mem->memory_size, size - (mem->start_addr - start));
+        }
+        ret = kvm_log_clear_one_slot(mem, kml->as_id, offset, count);
+        if (ret < 0) {
             break;
         }
     }
 
-    /*
-     * We should always find one memslot until this point, otherwise
-     * there could be something wrong from the upper layer
-     */
-    assert(mem && i != s->nr_slots);
-    ret = kvm_log_clear_one_slot(mem, kml->as_id, start, size);
-
     kvm_slots_unlock(kml);
 
     return ret;
-- 
2.21.0

