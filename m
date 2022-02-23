Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F114C0BE9
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbiBWFZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiBWFZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:36 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF76BDCB
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:34 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3-20020a25ad43000000b0062462e2af34so11456972ybe.17
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aBDkmRlW2wO+VZF+yuNfjgMBKgOQnmUW3eUrwjZrCS8=;
        b=YOGSR3d5gsNbX6iUzwto0/6/twFuZLdwqQ+OyGBmDQ+Y0Z9tIxowj80ZJNXhvJxX+Y
         39mdIpZnjCbsNOAMZ3WcDDj7mi8QZH0c/RsyMzdcAwnc6PykioINuQH19G0EC5hHlDik
         23zXjrmfS9wbxjdu3O5ye1/Ud1PUIpPDZK7t9Nl7PN6MOX3LEYFZ3t9yeI4RY0EL+Zno
         WAZ3yPIe48Tjd2EqQRhcT9O3QomAL8NNi0J1Bk6EaY/8ic2RRlHQl+dYmmLeJ/OqUWOZ
         mOxvcqRrmNjCUbbMYTjvZgG5UsBId8RgCT1I73bDH8qdngvHAJMKuao3IUJPZHo/KDG+
         YImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aBDkmRlW2wO+VZF+yuNfjgMBKgOQnmUW3eUrwjZrCS8=;
        b=k6/WoNDAcqITC5Iw07MQP5mTC5L7mgwV3M7PUxvmtAuHI1V/evZwTn4b5RZRY2nkRA
         +o2eUQkP44sHmWbeb9qd+B+3AuSUJNLdtm9FZFxe7FPIA+aNjSSsTVaA+MqlMSwvgJlS
         O0IPybFzioK9BBw/OAx4Mjspdul9twNnvXbEWmqxrjmqpH1pSvAMDL5aKpis5rQvn8Mq
         b1nVdFRsYbSHM72c4YhHWrW6JrzYWgyOrGRqyvzGHXUs2lFKZOT99vGxQI8CqLucZdDZ
         h7iplR9sLLv9bjAVRBertgKL9py2e15DmwEtkFVG04D/dtJHfp7hS0z+bdbpnkAwYAJt
         nQ4g==
X-Gm-Message-State: AOAM531BH7ktg2LvbBMVKxM90rf3NmkXuAXE4R9zyiuPHuZJhhfW+pX5
        O+e++RBS8xloc/ZtcC8n6sDXnNaJnHWy
X-Google-Smtp-Source: ABdhPJxviHHfMBTme5NCgrk3enqRX6Pa+N3RjWDQxUKeUW0rsQhJHGhPnnpDhjrkSitIn82U+v9xIBog7t0o
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:7489:0:b0:2d1:518:8c57 with SMTP id
 p131-20020a817489000000b002d105188c57mr27268814ywc.69.1645593861309; Tue, 22
 Feb 2022 21:24:21 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:52 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-17-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 16/47] mm: asi: Support for mapping non-sensitive pcpu chunks
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds support for mapping and unmapping dynamic percpu chunks as
globally non-sensitive. A later patch will modify the percpu allocator
to use this for dynamically allocating non-sensitive percpu memory.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 include/linux/vmalloc.h |  4 ++--
 mm/percpu-vm.c          | 51 +++++++++++++++++++++++++++++++++--------
 mm/vmalloc.c            | 17 ++++++++++----
 security/Kconfig        |  2 +-
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index c7c66decda3e..5f85690f27b6 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -260,14 +260,14 @@ extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 # ifdef CONFIG_MMU
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align);
+				     size_t align, ulong flags);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
 # else
 static inline struct vm_struct **
 pcpu_get_vm_areas(const unsigned long *offsets,
 		const size_t *sizes, int nr_vms,
-		size_t align)
+		size_t align, ulong flags)
 {
 	return NULL;
 }
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 2054c9213c43..5579a96ad782 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -153,8 +153,12 @@ static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
 static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 			     struct page **pages, int page_start, int page_end)
 {
+	struct vm_struct **vms = (struct vm_struct **)chunk->data;
 	unsigned int cpu;
 	int i;
+	ulong addr, nr_pages;
+
+	nr_pages = page_end - page_start;
 
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
@@ -164,8 +168,14 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 			WARN_ON(!page);
 			pages[pcpu_page_idx(cpu, i)] = page;
 		}
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
-				   page_end - page_start);
+		addr = pcpu_chunk_addr(chunk, cpu, page_start);
+
+		/* TODO: We should batch the TLB flushes */
+		if (vms[0]->flags & VM_GLOBAL_NONSENSITIVE)
+			asi_unmap(ASI_GLOBAL_NONSENSITIVE, (void *)addr,
+				  nr_pages * PAGE_SIZE, true);
+
+		__pcpu_unmap_pages(addr, nr_pages);
 	}
 }
 
@@ -212,18 +222,30 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
  * reverse lookup (addr -> chunk).
  */
 static int pcpu_map_pages(struct pcpu_chunk *chunk,
-			  struct page **pages, int page_start, int page_end)
+			  struct page **pages, int page_start, int page_end,
+			  gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
 	int i, err;
+	ulong addr, nr_pages;
+
+	nr_pages = page_end - page_start;
 
 	for_each_possible_cpu(cpu) {
-		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
+		addr = pcpu_chunk_addr(chunk, cpu, page_start);
+		err = __pcpu_map_pages(addr,
 				       &pages[pcpu_page_idx(cpu, page_start)],
-				       page_end - page_start);
+				       nr_pages);
 		if (err < 0)
 			goto err;
 
+		if (gfp & __GFP_GLOBAL_NONSENSITIVE) {
+			err = asi_map(ASI_GLOBAL_NONSENSITIVE, (void *)addr,
+				      nr_pages * PAGE_SIZE);
+			if (err)
+				goto err;
+		}
+
 		for (i = page_start; i < page_end; i++)
 			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
 					    chunk);
@@ -231,10 +253,15 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
+		addr = pcpu_chunk_addr(chunk, tcpu, page_start);
+
+		if (gfp & __GFP_GLOBAL_NONSENSITIVE)
+			asi_unmap(ASI_GLOBAL_NONSENSITIVE, (void *)addr,
+				  nr_pages * PAGE_SIZE, false);
+
+		__pcpu_unmap_pages(addr, nr_pages);
 		if (tcpu == cpu)
 			break;
-		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
-				   page_end - page_start);
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
@@ -285,7 +312,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
 	if (pcpu_alloc_pages(chunk, pages, page_start, page_end, gfp))
 		return -ENOMEM;
 
-	if (pcpu_map_pages(chunk, pages, page_start, page_end)) {
+	if (pcpu_map_pages(chunk, pages, page_start, page_end, gfp)) {
 		pcpu_free_pages(chunk, pages, page_start, page_end);
 		return -ENOMEM;
 	}
@@ -334,13 +361,19 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 {
 	struct pcpu_chunk *chunk;
 	struct vm_struct **vms;
+	ulong vm_flags = 0;
+
+	if (static_asi_enabled() && (gfp & __GFP_GLOBAL_NONSENSITIVE))
+		vm_flags = VM_GLOBAL_NONSENSITIVE;
+
+	gfp &= ~__GFP_GLOBAL_NONSENSITIVE;
 
 	chunk = pcpu_alloc_chunk(gfp);
 	if (!chunk)
 		return NULL;
 
 	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				pcpu_nr_groups, pcpu_atom_size);
+				pcpu_nr_groups, pcpu_atom_size, vm_flags);
 	if (!vms) {
 		pcpu_free_chunk(chunk);
 		return NULL;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ba588a37ee75..f13bfe7e896b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3664,10 +3664,10 @@ pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
  */
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align)
+				     size_t align, ulong flags)
 {
-	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	unsigned long vmalloc_start = VMALLOC_START;
+	unsigned long vmalloc_end = VMALLOC_END;
 	struct vmap_area **vas, *va;
 	struct vm_struct **vms;
 	int area, area2, last_area, term_area;
@@ -3677,6 +3677,15 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 	/* verify parameters and allocate data structures */
 	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
+
+	if (static_asi_enabled() && (flags & VM_GLOBAL_NONSENSITIVE)) {
+		vmalloc_start = VMALLOC_GLOBAL_NONSENSITIVE_START;
+		vmalloc_end = VMALLOC_GLOBAL_NONSENSITIVE_END;
+	}
+
+	vmalloc_start = ALIGN(vmalloc_start, align);
+	vmalloc_end = vmalloc_end & ~(align - 1);
+
 	for (last_area = 0, area = 0; area < nr_vms; area++) {
 		start = offsets[area];
 		end = start + sizes[area];
@@ -3815,7 +3824,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	for (area = 0; area < nr_vms; area++) {
 		insert_vmap_area(vas[area], &vmap_area_root, &vmap_area_list);
 
-		setup_vmalloc_vm_locked(vms[area], vas[area], VM_ALLOC,
+		setup_vmalloc_vm_locked(vms[area], vas[area], flags | VM_ALLOC,
 				 pcpu_get_vm_areas);
 	}
 	spin_unlock(&vmap_area_lock);
diff --git a/security/Kconfig b/security/Kconfig
index 0a3e49d6a331..e89c2658e6cf 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -68,7 +68,7 @@ config PAGE_TABLE_ISOLATION
 config ADDRESS_SPACE_ISOLATION
 	bool "Allow code to run with a reduced kernel address space"
 	default n
-	depends on X86_64 && !UML && SLAB
+	depends on X86_64 && !UML && SLAB && !NEED_PER_CPU_KM
 	depends on !PARAVIRT
 	help
 	   This feature provides the ability to run some kernel code
-- 
2.35.1.473.g83b2b277ed-goog

