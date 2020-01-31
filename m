Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C930214EEF1
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgAaPCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:02:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729155AbgAaPCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:02:20 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF0MwY143303
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:18 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xv7e2x7hf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:18 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:02:16 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:02:13 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF1JZZ38928884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:01:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71A2A4204B;
        Fri, 31 Jan 2020 15:02:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67C424205E;
        Fri, 31 Jan 2020 15:02:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:02:11 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 237EAE03BC; Fri, 31 Jan 2020 16:02:11 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 09/12] kvm: clear dirty bitmaps from all overlapping memslots
Date:   Fri, 31 Jan 2020 16:02:04 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150207.73127-1-borntraeger@de.ibm.com>
References: <20200131150207.73127-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-4275-0000-0000-0000039CD0BB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-4276-0000-0000-000038B0F1C2
Message-Id: <20200131150207.73127-10-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=940 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310127
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

