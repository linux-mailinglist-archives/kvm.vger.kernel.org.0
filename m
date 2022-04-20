Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2B1508178
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 08:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359519AbiDTGwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 02:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359469AbiDTGwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 02:52:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906C210FF9
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 23:49:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bg24so1082768pjb.1
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 23:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HcOyFFr5uNW7p7L81tPw2b4BwpcJtuh1ONNlb6nVe4M=;
        b=KMHYwzjEI+ebVWexmryb9LqrzMou5rD1VOxY4g++9RznQ2zCHUg2G3QE13W4c+9eBi
         5Ij+s3S0AHOa4mESz/YKYa91vaIcAwAtYpQAtIidCw/bSeG/yrmgiPIZGNVwhWP98CKO
         ZzeEQlEOUxo3fJBaUCUO4f4icm8xk2oW9j1dxmhuNRGmL0U83OKSp6trb1C3lH8Av2bs
         7UdvHq22LMD+j19rCdYRJYOysdg20Tic7nUhRjRTajWlF7Xcb/g7+67WcMsjfrGyrarL
         GppyCqEcw6V/Z0zfSckiUbeuYWN8P1iJ/AsPS4L9k8ZrwsoeLRrKMINnFyc5HKfVGbyZ
         5xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HcOyFFr5uNW7p7L81tPw2b4BwpcJtuh1ONNlb6nVe4M=;
        b=HnCtRxZMyO80Aij5QNeG/ZPENKHaNnAKtM+9G1lNwUsZRF6E0/Smx1fItvmQ1xGzMP
         QZO3ISGtuJRmCM7jri2YtVsq7O0SehY17oZzkQ8ltCJ3TYyO3alroAGShu1dIn3F7NUv
         0UXOTJMdSQoznaERDIqBR41IdffruuOTj7j7F1ki8p+ack1a+k8YzW7rjxWqlIyPIhx+
         ygP6nD/W+qdti8L7OuuxLLdCYbrGPVXqa6n0txEHqVvdSAo/fvckefTnbo1QZ/z8hOSD
         arnxW6WBynzuy9oHDVnEleFTocDc8FTFlCQSjBCto8+SmWUnjYcuRDMs7U1TJmFRuYzb
         AKhQ==
X-Gm-Message-State: AOAM530Qt9S8+NYVnmg/OlR6yDTjWJhQZ+HgGORxTJ4ISSVy6VU+PZqm
        7ljlQ3jQbszqeop43D0vvjHMpA==
X-Google-Smtp-Source: ABdhPJzsd0pNleubZJHKgQS/43ueWAxY6PsKNye2Ti0mGMN3QlsMfh5pUgiFuErY/MxX+pZJHwIo3w==
X-Received: by 2002:a17:90a:600b:b0:1cb:8ba5:d3bc with SMTP id y11-20020a17090a600b00b001cb8ba5d3bcmr2756907pji.42.1650437386064;
        Tue, 19 Apr 2022 23:49:46 -0700 (PDT)
Received: from always-x1.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id r29-20020a63441d000000b003a97e8f71e7sm10148921pga.88.2022.04.19.23.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 23:49:45 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH] KVM: HWPoison: Fix memory address&size during remap
Date:   Wed, 20 Apr 2022 14:45:42 +0800
Message-Id: <20220420064542.423508-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

qemu exits during reset with log:
qemu-system-x86_64: Could not remap addr: 1000@22001000

Currently, after MCE on RAM of a guest, qemu records a ram_addr only,
remaps this address with a fixed size(TARGET_PAGE_SIZE) during reset.
In the hugetlbfs scenario, mmap(addr...) needs page_size aligned
address and correct size. Unaligned address leads mmap to fail.

What's more, hitting MCE on RAM of a guest, qemu records this address
and try to fix it during reset, this should be a common logic. So
remove kvm_hwpoison_page_add from architecture dependent code, record
this in SIGBUS handler instead. Finally poisoning/unpoisoning a page
gets static in kvm-all.c,

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 accel/kvm/kvm-all.c      | 47 ++++++++++++++++++++++++++++++----------
 include/sysemu/kvm_int.h | 12 ----------
 target/arm/kvm64.c       |  1 -
 target/i386/kvm/kvm.c    |  1 -
 4 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5f1377ca04..2a91c5a461 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1167,11 +1167,14 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
     return ret;
 }
 
+#ifdef KVM_HAVE_MCE_INJECTION
 typedef struct HWPoisonPage {
     ram_addr_t ram_addr;
+    size_t page_size; /* normal page or hugeTLB page? */
     QLIST_ENTRY(HWPoisonPage) list;
 } HWPoisonPage;
 
+/* hwpoison_page_list stores the poisoned pages, unpoison them during reset */
 static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
     QLIST_HEAD_INITIALIZER(hwpoison_page_list);
 
@@ -1181,25 +1184,48 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr, page->page_size);
         g_free(page);
     }
 }
 
-void kvm_hwpoison_page_add(ram_addr_t ram_addr)
+static void kvm_hwpoison_page_add(CPUState *cpu, int sigbus_code, void *addr)
 {
     HWPoisonPage *page;
+    ram_addr_t ram_addr, align_ram_addr;
+    ram_addr_t offset;
+    hwaddr paddr;
+    size_t page_size;
+
+    assert(sigbus_code == BUS_MCEERR_AR || sigbus_code == BUS_MCEERR_AO);
+    ram_addr = qemu_ram_addr_from_host(addr);
+    if (ram_addr == RAM_ADDR_INVALID ||
+        !kvm_physical_memory_addr_from_host(cpu->kvm_state, addr, &paddr)) {
+        /* only deal with valid guest RAM here */
+        return;
+    }
 
+    /* get page size of RAM block, test it's a normal page or huge page */
+    page_size = qemu_ram_block_from_host(addr, false, &offset)->page_size;
+    align_ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
-        if (page->ram_addr == ram_addr) {
+        if (page->ram_addr == align_ram_addr) {
+            assert(page->page_size == page_size);
             return;
         }
     }
-    page = g_new(HWPoisonPage, 1);
-    page->ram_addr = ram_addr;
+
+    page = g_new0(HWPoisonPage, 1);
+    page->ram_addr = align_ram_addr;
+    page->page_size = page_size;
     QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
 }
 
+static __thread void *pending_sigbus_addr;
+static __thread int pending_sigbus_code;
+static __thread bool have_sigbus_pending;
+#endif
+
 static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
 {
 #if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
@@ -2601,7 +2627,9 @@ static int kvm_init(MachineState *ms)
         s->kernel_irqchip_split = mc->default_kernel_irqchip_split ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
     }
 
+#if defined KVM_HAVE_MCE_INJECTION
     qemu_register_reset(kvm_unpoison_all, NULL);
+#endif
 
     if (s->kernel_irqchip_allowed) {
         kvm_irqchip_create(s);
@@ -2782,12 +2810,6 @@ void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu)
     run_on_cpu(cpu, do_kvm_cpu_synchronize_pre_loadvm, RUN_ON_CPU_NULL);
 }
 
-#ifdef KVM_HAVE_MCE_INJECTION
-static __thread void *pending_sigbus_addr;
-static __thread int pending_sigbus_code;
-static __thread bool have_sigbus_pending;
-#endif
-
 static void kvm_cpu_kick(CPUState *cpu)
 {
     qatomic_set(&cpu->kvm_run->immediate_exit, 1);
@@ -2883,6 +2905,8 @@ int kvm_cpu_exec(CPUState *cpu)
 #ifdef KVM_HAVE_MCE_INJECTION
         if (unlikely(have_sigbus_pending)) {
             qemu_mutex_lock_iothread();
+            kvm_hwpoison_page_add(cpu, pending_sigbus_code,
+                                  pending_sigbus_addr);
             kvm_arch_on_sigbus_vcpu(cpu, pending_sigbus_code,
                                     pending_sigbus_addr);
             have_sigbus_pending = false;
@@ -3436,6 +3460,7 @@ int kvm_on_sigbus(int code, void *addr)
      * we can only get action optional here.
      */
     assert(code != BUS_MCEERR_AR);
+    kvm_hwpoison_page_add(first_cpu, code, addr);
     kvm_arch_on_sigbus_vcpu(first_cpu, code, addr);
     return 0;
 #else
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 1f5487d9b7..52ec8ef99c 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -40,16 +40,4 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
                                   AddressSpace *as, int as_id, const char *name);
 
 void kvm_set_max_memslot_size(hwaddr max_slot_size);
-
-/**
- * kvm_hwpoison_page_add:
- *
- * Parameters:
- *  @ram_addr: the address in the RAM for the poisoned page
- *
- * Add a poisoned page to the list
- *
- * Return: None.
- */
-void kvm_hwpoison_page_add(ram_addr_t ram_addr);
 #endif
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index ccadfbbe72..a3184eb3d2 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -1450,7 +1450,6 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-            kvm_hwpoison_page_add(ram_addr);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
              * synchronously from the vCPU thread, so we can easily
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9cf8e03669..fb72b349ed 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -622,7 +622,6 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
-            kvm_hwpoison_page_add(ram_addr);
             kvm_mce_inject(cpu, paddr, code);
 
             /*
-- 
2.20.1

