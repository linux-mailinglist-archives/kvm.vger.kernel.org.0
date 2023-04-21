Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F86EA250
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 05:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjDUDZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 23:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDUDZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 23:25:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A6C198D
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 20:25:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63d4595d60fso11671543b3a.0
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 20:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682047551; x=1684639551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+zxRsWS+3IU+RNo3KGaqhN519lT6XoGVpis2yIvD9J4=;
        b=mTvf/+GdsxzrevVYATMdwUZf+VPYPU5UcsdnfuafBVyLLSYzUYkz3JIYaUVVyqcLKk
         O1iiWDq524gGVsNwOsFV4Uxp3ZDSBJ17MqsbmF53mWgy3pybCTOmc2by24GQVT8Wbg2e
         6FtawOD/Vpoj6pIB9XcBERDjsO7EAQC8Qgtal5BpWs8tKVjUOFSTHr345DEjFwPrgef5
         CfIsQbLrmlprgV1bhEPwwq4lf5fSJlfO36+Jhhe7b3ly5rY6txsT+ICGXNKuPfBtx56q
         UtX7JHCbNSVfWHrNn7hL40dvL3BCAiiApc17l/Xoqt8wsmbz94zkRo4rXVP/6E41pnkS
         K15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682047551; x=1684639551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zxRsWS+3IU+RNo3KGaqhN519lT6XoGVpis2yIvD9J4=;
        b=KeaBrHnU4BAmiv/olT7AGjoPrF+/drVdYx5Bmxh09qYHHIGKVBBUzTvvoEyOL0hPsX
         5jjN7HoQgTLeI+QXvww/F3+oPsoCZK+1Z728bCrK1Cd2LANimxoQNuR5Cy1G/Q9r/vfd
         8IwiVqucxmJOHkPTWID1aescutZTGRf7LWSWpI5U5ZWNhi1qkKPlxjIWKWlGnACLLi6J
         qEZ7g0OirCuZru425wSAjK6fcIXUwXEBwRTlJ9vQOhjauH36U9vH14JvmHc2+fWo2BKF
         5Nfe0VYNjjPXMBlyRyjhRn+aXL1TdC7FLowQJCLdH18OZhTqXX05dYe0NA5Kxirs27Rr
         Vv5g==
X-Gm-Message-State: AAQBX9cQoacqTEM/EdK//cYlqmf1GwZxNF69h2C6dOzhnvqpddt9PeKI
        aE3C4M119n7nhyJoAOMsmw2wyBd3nXNkyXPt
X-Google-Smtp-Source: AKy350Z7VTSVhHxJYob56JUW59cG1C4XRMANfKcmNbirGqTVp0eb7TcaQmNlYc1+096SEOMQ3XChFg==
X-Received: by 2002:a17:903:2409:b0:1a2:89eb:3d1a with SMTP id e9-20020a170903240900b001a289eb3d1amr3756175plo.6.1682047550719;
        Thu, 20 Apr 2023 20:25:50 -0700 (PDT)
Received: from localhost.localdomain (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001a69918611csm1775868plb.72.2023.04.20.20.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 20:25:50 -0700 (PDT)
From:   Robert Hoo <robert.hoo.linux@gmail.com>
To:     pbonzini@redhat.com, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, vkuznets@redhat.com,
        Robert Hoo <robert.hoo.linux@gmail.com>
Subject: [RESEND][QEMU PATCH] accel/kvm: Don't use KVM maximum support number to alloc user memslots
Date:   Fri, 21 Apr 2023 11:25:22 +0800
Message-Id: <20230421032522.999-1-robert.hoo.linux@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Corrects QEMU to properly use what KVM_CAP_NR_MEMSLOTS means,
i.e. the maximum user memslots KVM supports.
1. Rename KVMState::nr_slots --> max_slots.
2. Remember nr_slots in each KML. This also decouples each KML, e.g. x86's
   two KMLs don't need to have same size of slots[].
3. Change back initial slot[] size to 32, increase it dynamically
   (exponentially) till the maximum number KVM supports. 32 should suites
   almost all normal guests.

Background:
Since KVM commit 4fc096a99e01d ("KVM: Raise the maximum number of user
memslots"), KVM_CAP_NR_MEMSLOTS returns 32764 (SHRT_MAX - 3), which is a
huge increase from previous 509 (x86). This change based on the fact that
KVM alloc memslots dynamically. But QEMU allocates that huge number of user
memslots statically. This is indeed unwanted by both sides. It makes:

1. Memory waste. Allocates (SHRT_MAX - 3) * sizeof(KVMSlot), while a
typical VM needs far less, e.g. my VM just reached 9th as the highest mem
slot ever used. x86 further, has 2 kmls; approx. 2 x 2MB for each VM.
2. Time waste. Several KML Slot functions go through the whole
KML::slots[], (SHRT_MAX - 3) makes it far longer than necessary, e.g.
kvm_lookup_matching_slot(), kvm_physical_memory_addr_from_host(),
kvm_physical_log_clear(), kvm_log_sync_global().

Functional Test:
Temporarily set KVM_DEF_NR_SLOTS = 8, let it go through slot[] dynamic
increase, VM launched and works well.

Performance improvement:
Func time (ns) of kvm_lookup_matching_slot(), for example,
			Before				After
sample count		5874				6812
mean			11403				5867
min			1775				1722
max			784949				30263

Signed-off-by: Robert Hoo <robert.hoo.linux@gmail.com>
---
Resend:
Add stats about kvm_lookup_matching_slot() for example.
CC kvm mail list per get_maintainer.pl suggests.
I believe this benefits Live Migration, but not devices at hand to do
the system level test.

 accel/kvm/kvm-all.c      | 57 +++++++++++++++++++++++++++++-----------
 include/sysemu/kvm_int.h |  4 ++-
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index cf3a88d90e..708170139c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -178,22 +178,50 @@ int kvm_get_max_memslots(void)
 {
     KVMState *s = KVM_STATE(current_accel());
 
-    return s->nr_slots;
+    return s->max_slots;
 }
 
-/* Called with KVMMemoryListener.slots_lock held */
+/* Called with kvm_slots_lock()'ed */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
     KVMState *s = kvm_state;
+    KVMSlot *new_slots;
     int i;
+    int new_nr, old_nr;
 
-    for (i = 0; i < s->nr_slots; i++) {
+    for (i = 0; i < kml->nr_slots; i++) {
         if (kml->slots[i].memory_size == 0) {
             return &kml->slots[i];
         }
     }
 
-    return NULL;
+    /* Already reached maximum, no more can expand */
+    if (kml->nr_slots >= s->max_slots) {
+        return NULL;
+    }
+
+    new_nr = 2 * kml->nr_slots;
+    new_nr = MIN(new_nr, s->max_slots);
+    /* It might overflow */
+    if (new_nr < 0 || new_nr <= kml->nr_slots) {
+        return NULL;
+    }
+
+    new_slots = g_try_new0(KVMSlot, new_nr);
+    if (!new_slots) {
+        return NULL;
+    }
+
+    memcpy(new_slots, kml->slots, kml->nr_slots * sizeof(KVMSlot));
+    old_nr = kml->nr_slots;
+    kml->nr_slots = new_nr;
+    g_free(kml->slots);
+    kml->slots = new_slots;
+    for (i = old_nr; i < kml->nr_slots; i++) {
+        kml->slots[i].slot = i;
+    }
+
+    return &kml->slots[old_nr];
 }
 
 bool kvm_has_free_slot(MachineState *ms)
@@ -226,10 +254,9 @@ static KVMSlot *kvm_lookup_matching_slot(KVMMemoryListener *kml,
                                          hwaddr start_addr,
                                          hwaddr size)
 {
-    KVMState *s = kvm_state;
     int i;
 
-    for (i = 0; i < s->nr_slots; i++) {
+    for (i = 0; i < kml->nr_slots; i++) {
         KVMSlot *mem = &kml->slots[i];
 
         if (start_addr == mem->start_addr && size == mem->memory_size) {
@@ -271,7 +298,7 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
     int i, ret = 0;
 
     kvm_slots_lock();
-    for (i = 0; i < s->nr_slots; i++) {
+    for (i = 0; i < kml->nr_slots; i++) {
         KVMSlot *mem = &kml->slots[i];
 
         if (ram >= mem->ram && ram < mem->ram + mem->memory_size) {
@@ -1002,7 +1029,7 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
 
     kvm_slots_lock();
 
-    for (i = 0; i < s->nr_slots; i++) {
+    for (i = 0; i < kml->nr_slots; i++) {
         mem = &kml->slots[i];
         /* Discard slots that are empty or do not overlap the section */
         if (!mem->memory_size ||
@@ -1566,7 +1593,6 @@ static void kvm_log_sync(MemoryListener *listener,
 static void kvm_log_sync_global(MemoryListener *l)
 {
     KVMMemoryListener *kml = container_of(l, KVMMemoryListener, listener);
-    KVMState *s = kvm_state;
     KVMSlot *mem;
     int i;
 
@@ -1578,7 +1604,7 @@ static void kvm_log_sync_global(MemoryListener *l)
      * only a few used slots (small VMs).
      */
     kvm_slots_lock();
-    for (i = 0; i < s->nr_slots; i++) {
+    for (i = 0; i < kml->nr_slots; i++) {
         mem = &kml->slots[i];
         if (mem->memory_size && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
             kvm_slot_sync_dirty_pages(mem);
@@ -1687,10 +1713,11 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
 {
     int i;
 
-    kml->slots = g_new0(KVMSlot, s->nr_slots);
+    kml->slots = g_new0(KVMSlot, KVM_DEF_NR_SLOTS);
+    kml->nr_slots = KVM_DEF_NR_SLOTS;
     kml->as_id = as_id;
 
-    for (i = 0; i < s->nr_slots; i++) {
+    for (i = 0; i < kml->nr_slots; i++) {
         kml->slots[i].slot = i;
     }
 
@@ -2427,11 +2454,11 @@ static int kvm_init(MachineState *ms)
     }
 
     kvm_immediate_exit = kvm_check_extension(s, KVM_CAP_IMMEDIATE_EXIT);
-    s->nr_slots = kvm_check_extension(s, KVM_CAP_NR_MEMSLOTS);
+    s->max_slots = kvm_check_extension(s, KVM_CAP_NR_MEMSLOTS);
 
     /* If unspecified, use the default value */
-    if (!s->nr_slots) {
-        s->nr_slots = 32;
+    if (s->max_slots <= 0) {
+        s->max_slots = KVM_DEF_NR_SLOTS;
     }
 
     s->nr_as = kvm_check_extension(s, KVM_CAP_MULTI_ADDRESS_SPACE);
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index a641c974ea..38297ae366 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -37,8 +37,10 @@ typedef struct KVMMemoryUpdate {
     MemoryRegionSection section;
 } KVMMemoryUpdate;
 
+#define KVM_DEF_NR_SLOTS 32
 typedef struct KVMMemoryListener {
     MemoryListener listener;
+    int nr_slots;
     KVMSlot *slots;
     int as_id;
     QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_add;
@@ -69,7 +71,7 @@ struct KVMState
 {
     AccelState parent_obj;
 
-    int nr_slots;
+    int max_slots;
     int fd;
     int vmfd;
     int coalesced_mmio;

base-commit: c6f3cbca32bde9ee94d9949aa63e8a7ef2d7bc5b
-- 
2.31.1

