Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8313653AA9
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiLVCfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiLVCfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:08 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C655248D3
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:07 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b16-20020a17090a551000b00225aa26f1dbso295894pji.8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bxkmrVszmYtdX56U0+zIQlMbh2VgS2C48ld2l9CYwus=;
        b=Rn6JhTg0zhPlYluWmxYHpBlbM65jcOKT08CTpFfaF7H5DiKsfX4cghOlXKtbXYarOK
         Rly5XOhtvEYkFNI27R7kdmcDaft+DtQZHjIUVe60dOsihgLsa9smgxM+b5XDJjnQ5ViO
         Lkw5zbkLDE5ElgM22t1HWQhqSPjJc/A7roPsY0/dbXeUhXDdkCO+aerp6M5Gy8UvxMx9
         hry1N1NLcMymvSxaWuZTNy40tIRuVsbU4zETnVIVyXentp2aZLJhf0IN9lIyvdeQEICD
         jjslMf9GOy2+ihLLAQ7wMggtMTn5Pk6LiRqyldHCiyElR3iBYcg59o/9Nzc9a7CBMBBj
         D2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bxkmrVszmYtdX56U0+zIQlMbh2VgS2C48ld2l9CYwus=;
        b=fJ+RLpKnQhH9EE7aTbXHjgXVKc4nK17vyeZYHcd9OwvgpQyZ1b8tmmEB/1tkrLeYcy
         Aqf38Kb7q0mcH1fFoDq5Ow/TpF6Bes6bMvXVSuA5JbS6MdJHEI3nv3e9eIHsjSnMj1X1
         JnUWMVaw3Xww/C8sJM0XtASDqdN0wUHhdm+WPzKINSu7GkCu7qPdk+vEGwZ2XPIPjepc
         pcoU5nB5ZlLuXD7PRZCseLb9tp85rQiJ3X8Fk6/aAGRXLaYBp76XzfJStu49p0aUEEvc
         cuCaTF/N/uDuVL/MUhZRB9liNBAJBWhuxxEzQ8fY2hn4OEjxBfCFkSpu+OM8jAm0sDwp
         Agug==
X-Gm-Message-State: AFqh2krkyDLMaaT9YJXOnY/iHp0fx2scMa55xsZcTqdUbgbB0uf0YbmJ
        sV/DydOPVsdDsCmV2IItz0Q9B4pRNje0
X-Google-Smtp-Source: AMrXdXtuF9r3bYe3VPv1FhZLvcXC0CXs3tzUIuXM098fxmkDbP+sDF600+9NCrol1k+pvP3NgkN8AZPuhIVd
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a62:1d0c:0:b0:56b:bba4:650a with SMTP id
 d12-20020a621d0c000000b0056bbba4650amr294643pfd.4.1671676506822; Wed, 21 Dec
 2022 18:35:06 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:52 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-5-vipinsh@google.com>
Subject: [Patch v3 4/9] KVM: Add module param to make page tables NUMA aware
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a numa_aware_page_table module param to make page tables NUMA aware.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index efd9b38ea9a2..d48064503b88 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1358,6 +1358,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 
+void *kvm_mmu_get_free_page(int nid, gfp_t gfp);
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f2d762878b97..d96c8146e9ba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -93,6 +93,13 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+/*
+ * If possible, allocate page table's pages on the same node the underlying
+ * physical page is pointing to.
+ */
+static bool __read_mostly numa_aware_pagetable = true;
+module_param_named(numa_aware_pagetable, numa_aware_pagetable, bool, 0644);
+
 /*
  * Ordering of locks:
  *
@@ -384,6 +391,21 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
 	kvm_arch_guest_memory_reclaimed(kvm);
 }
 
+void *kvm_mmu_get_free_page(int nid, gfp_t gfp)
+{
+	#ifdef CONFIG_NUMA
+	struct page *spt_page;
+
+	if (numa_aware_pagetable) {
+		spt_page = alloc_pages_node(nid, gfp, 0);
+		if (spt_page)
+			return page_address(spt_page);
+	}
+	#endif // CONFIG_NUMA
+
+	return (void *)__get_free_page(gfp);
+}
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
-- 
2.39.0.314.g84b9a713c41-goog

