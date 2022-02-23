Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6614C0BB8
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbiBWFZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiBWFY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A65D6C930
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b64-20020a256743000000b0061e169a5f19so26554573ybc.11
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZeYN5P9RWE85rWG989hD+TytaZQUQYUlju5cKer3rg4=;
        b=ojUJsUEL9fv13WjcZCmN21LxwR3Z6zqiLpmAQSzxCgc5C9RlKzd4dJEPqIdea+S3R3
         SjjKai+zXn4VwTi+vC8vw+NDJWHGEkF4oYybv8WUgGBs6X4Bacon5BeJ8KDM6+Kjcqg7
         fYXSLYWwuUfF3ZzaHWiW5r5fUjU5hUbi5i8udL9OUGPQxFLT6BZJN8cKiUG2KSidmSdI
         7UxdullkH2J71pHhwQMQjuVH7Fyee/6awuNUgdr31148ohQL1xZz1MmOnDGr6y/5AC05
         atbUvniVVa19eg7E36/l3gFWXXYduMYcF6MD2CAuUTHeqJzSqvtlhwblL5Fzis+kQ6SQ
         claQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZeYN5P9RWE85rWG989hD+TytaZQUQYUlju5cKer3rg4=;
        b=fqAJny8XpmNBfKazVcafqF1HaTbizsOAJdRWuOs64pC0M4CbMxaEfl2lG54SGbk4vt
         oPstX8WflrELWucO9prH8N7Ja8HlWrKxBPNB6L/eJHcNFdqlv5hplZqCdpNyQzKp15zR
         Olh5as5Mah0l+Cr9+eXtG4qv7p84E9cjX1x2VX17u0dAuHdTPsSqtdb5tujQZndpb/Sg
         tZarFpGzxYRZOOL+gU8ZPvEEurlolIxg4fmIzFrF500tVR3cF6oYPfmiRDeSmdYcQIjw
         QcGvTk/vMrnflsX6356U7p+d+hthoVtI/WPAjZoB1QtxZO2r042aK6l/Afys/p/bE9+W
         xxVg==
X-Gm-Message-State: AOAM532DugsLKDBRr0aEI0VDjDFTAXetQnQSAEKUjI9+dpNzguLCNFua
        D9a8Sm30/VKdXses3it/JrErFN86iiw4
X-Google-Smtp-Source: ABdhPJx7Y4lP1+DVrEJyeaCPqdjSHoYWrsMiEOQNVQ/p8prXsXPbox8dmisMikykjaQnA+B25uCbwTFY5Vh8
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a5b:589:0:b0:61d:de51:9720 with SMTP id
 l9-20020a5b0589000000b0061dde519720mr26317731ybp.167.1645593850281; Tue, 22
 Feb 2022 21:24:10 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:47 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-12-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 11/47] mm: asi: Global non-sensitive vmalloc/vmap support
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

A new flag, VM_GLOBAL_NONSENSITIVE is added to designate globally
non-sensitive vmalloc/vmap areas. When using the __vmalloc /
__vmalloc_node APIs, if the corresponding GFP flag is specified, the
VM flag is automatically added. When using the __vmalloc_node_range API,
either flag can be specified independently. The VM flag will only map
the vmalloc area as non-sensitive, while the GFP flag will only map the
underlying direct map area as non-sensitive.

When using the __vmalloc_node_range API, instead of VMALLOC_START/END,
VMALLOC_GLOBAL_NONSENSITIVE_START/END should be used. This is to
keep these mappings separate from locally non-sensitive vmalloc areas,
which will be added later. Areas outside of the standard vmalloc range
can specify the range as before.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/pgtable_64_types.h |  5 +++
 arch/x86/mm/asi.c                       |  3 +-
 include/asm-generic/asi.h               |  3 ++
 include/linux/vmalloc.h                 |  6 +++
 mm/vmalloc.c                            | 53 ++++++++++++++++++++++---
 5 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 91ac10654570..0fc380ba25b8 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -141,6 +141,11 @@ extern unsigned int ptrs_per_p4d;
 
 #define VMALLOC_END		(VMALLOC_START + (VMALLOC_SIZE_TB << 40) - 1)
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define VMALLOC_GLOBAL_NONSENSITIVE_START	VMALLOC_START
+#define VMALLOC_GLOBAL_NONSENSITIVE_END		VMALLOC_END
+#endif
+
 #define MODULES_VADDR		(__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 /* The module sections ends with the start of the fixmap */
 #ifndef CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index d381ae573af9..71348399baf1 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -198,7 +198,8 @@ static int __init asi_global_init(void)
 				    "ASI Global Non-sensitive direct map");
 
 	preallocate_toplevel_pgtbls(asi_global_nonsensitive_pgd,
-				    VMALLOC_START, VMALLOC_END,
+				    VMALLOC_GLOBAL_NONSENSITIVE_START,
+				    VMALLOC_GLOBAL_NONSENSITIVE_END,
 				    "ASI Global Non-sensitive vmalloc");
 
 	return 0;
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 012691e29895..f918cd052722 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -14,6 +14,9 @@
 
 #define ASI_GLOBAL_NONSENSITIVE		NULL
 
+#define VMALLOC_GLOBAL_NONSENSITIVE_START	VMALLOC_START
+#define VMALLOC_GLOBAL_NONSENSITIVE_END		VMALLOC_END
+
 #ifndef _ASSEMBLY_
 
 struct asi_hooks {};
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 6e022cc712e6..c7c66decda3e 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -39,6 +39,12 @@ struct notifier_block;		/* in notifier.h */
  * determine which allocations need the module shadow freed.
  */
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define VM_GLOBAL_NONSENSITIVE	0x00000800	/* Similar to __GFP_GLOBAL_NONSENSITIVE */
+#else
+#define VM_GLOBAL_NONSENSITIVE	0
+#endif
+
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f2ef719f1cba..ba588a37ee75 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2393,6 +2393,33 @@ void __init vmalloc_init(void)
 	vmap_initialized = true;
 }
 
+static int asi_map_vm_area(struct vm_struct *area)
+{
+	if (!static_asi_enabled())
+		return 0;
+
+	if (area->flags & VM_GLOBAL_NONSENSITIVE)
+		return asi_map(ASI_GLOBAL_NONSENSITIVE, area->addr,
+			       get_vm_area_size(area));
+
+	return 0;
+}
+
+static void asi_unmap_vm_area(struct vm_struct *area)
+{
+	if (!static_asi_enabled())
+		return;
+
+	/*
+	 * TODO: The TLB flush here could potentially be avoided in
+	 * the case when the existing flush from try_purge_vmap_area_lazy()
+	 * and/or vm_unmap_aliases() happens non-lazily.
+	 */
+	if (area->flags & VM_GLOBAL_NONSENSITIVE)
+		asi_unmap(ASI_GLOBAL_NONSENSITIVE, area->addr,
+			  get_vm_area_size(area), true);
+}
+
 static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
 	struct vmap_area *va, unsigned long flags, const void *caller)
 {
@@ -2570,6 +2597,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	int flush_dmap = 0;
 	int i;
 
+	asi_unmap_vm_area(area);
 	remove_vm_area(area->addr);
 
 	/* If this is not VM_FLUSH_RESET_PERMS memory, no need for the below. */
@@ -2787,16 +2815,20 @@ void *vmap(struct page **pages, unsigned int count,
 
 	addr = (unsigned long)area->addr;
 	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
-		vunmap(area->addr);
-		return NULL;
-	}
+				pages, PAGE_SHIFT) < 0)
+		goto err;
+
+	if (asi_map_vm_area(area))
+		goto err;
 
 	if (flags & VM_MAP_PUT_PAGES) {
 		area->pages = pages;
 		area->nr_pages = count;
 	}
 	return area->addr;
+err:
+	vunmap(area->addr);
+	return NULL;
 }
 EXPORT_SYMBOL(vmap);
 
@@ -2991,6 +3023,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
+	if (asi_map_vm_area(area))
+		goto fail;
+
 	return area->addr;
 
 fail:
@@ -3038,6 +3073,9 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	if (WARN_ON_ONCE(!size))
 		return NULL;
 
+	if (static_asi_enabled() && (vm_flags & VM_GLOBAL_NONSENSITIVE))
+		gfp_mask |= __GFP_ZERO;
+
 	if ((size >> PAGE_SHIFT) > totalram_pages()) {
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, exceeds total pages",
@@ -3127,8 +3165,13 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, int node, const void *caller)
 {
+	ulong vm_flags = 0;
+
+	if (static_asi_enabled() && (gfp_mask & __GFP_GLOBAL_NONSENSITIVE))
+		vm_flags |= VM_GLOBAL_NONSENSITIVE;
+
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
-				gfp_mask, PAGE_KERNEL, 0, node, caller);
+				gfp_mask, PAGE_KERNEL, vm_flags, node, caller);
 }
 /*
  * This is only for performance analysis of vmalloc and stress purpose.
-- 
2.35.1.473.g83b2b277ed-goog

