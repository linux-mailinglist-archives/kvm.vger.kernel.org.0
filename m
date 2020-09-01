Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC134258DB7
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgIALzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 07:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgIALy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:54:29 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6ACC061246;
        Tue,  1 Sep 2020 04:54:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gf14so453265pjb.5;
        Tue, 01 Sep 2020 04:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UrJgVcnrbP95bDmiuHum8f2y3Q4JhHjtF/G8Je/zjGQ=;
        b=aGJtquIXFajVdrPMJTuL6Mq33OqDp5No2w9VGsIZ3KYMF9GpjzpogU/8J6cHwEdhLg
         2cFvixQwSdm8BmEiSBEHg7JS2CQcZLln3EfbxRcw5NK1w6UaSKVlaL90dZLlB1DMZu2H
         zUo7DKsx5dN95HNNaSGtKap1p9I6O8zGTNMyoAJQE1PlJDO0IxkF92wfvPDDDAjEcdwy
         9lwy0GXD4Q41id+YHX6VBzbrKNPvBepvOD1bzobCYJKez2JEXOjvddQqq2LwObnl9CQB
         Xdl7bAWLbFhKasPcHzbJBgkKA02xCkGHKLu//Gt7UColB2EOY98bjcFcBoMxSCqce+SB
         mCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UrJgVcnrbP95bDmiuHum8f2y3Q4JhHjtF/G8Je/zjGQ=;
        b=oPvfi8fs2m0/O2JxRxr2SGsWG7mgxHffdZZoM9+hW/Oy17tCs6OgUeG7vKT+x9nnWD
         86Ivb4dUeI9W/+4vJKYavAQWDdOQmlmPgILpG0J3NRyuqkxprMw6aWCtmIr/8+VAs89j
         aS6rTYhEkO7Tv08yquL5lv5lyRRbH62aPiihxXtyopHEX2mD1DpZ8/zL9735pTz5Jh5Z
         3Pmr1oTEA8ZCvmpBhNeTILOBEAAlyeu/9KrxlEUnwiyHNddZ+x92Nq1hGrAwo9zBeIWE
         Va+b919VktVCkuDoicbZ/5VxiRphNwG+B+B94q8JW6m7yUWnSHpH3pUFSPwHNDvRnuYM
         nhDg==
X-Gm-Message-State: AOAM5334gLNGJ+Ou9EUSfa5Uja8QSoDsQW1TlqYb9VKCOd9yeUHnQ99j
        RfgB3XI3QaRM5+QOIDi/xQY=
X-Google-Smtp-Source: ABdhPJyG3Z3T1HuhBG+JY/UDJpecCHLhqHOaxg1eK+nvHEYLLhf5VV5cOUadv5GVmdXoAeLElxBWIg==
X-Received: by 2002:a17:902:9a0b:: with SMTP id v11mr1076557plp.236.1598961268957;
        Tue, 01 Sep 2020 04:54:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id q5sm1783611pfg.89.2020.09.01.04.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:54:28 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 3/9] Introduce page table remove function for direct build EPT feature
Date:   Tue,  1 Sep 2020 19:55:23 +0800
Message-Id: <12f9b9140f811c1d87f01f94c1477b50d6410263.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

During guest boots up it will modify the memory slots multiple times,
so add page table remove function to free pre-pinned memory according
to the the memory slot changes.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bfe4d2b3e809..03c5e73b96cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6482,6 +6482,62 @@ int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *
 	return 0;
 }
 
+static int __kvm_remove_spte(struct kvm *kvm, u64 *addr, gfn_t gfn, int level)
+{
+	int i;
+	int ret = level;
+	bool present = false;
+	kvm_pfn_t pfn;
+	u64 *sptep = (u64 *)__va((*addr) & PT64_BASE_ADDR_MASK);
+	unsigned index = SHADOW_PT_INDEX(gfn << PAGE_SHIFT, level);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		if (is_shadow_present_pte(sptep[i])) {
+			if (i == index) {
+				if (!is_last_spte(sptep[i], level)) {
+					ret = __kvm_remove_spte(kvm, &sptep[i], gfn, level - 1);
+					if (is_shadow_present_pte(sptep[i]))
+						return ret;
+				} else {
+					pfn = spte_to_pfn(sptep[i]);
+					mmu_spte_clear_track_bits(&sptep[i]);
+					kvm_release_pfn_clean(pfn);
+					if (present)
+						return ret;
+				}
+			} else {
+				if (i > index)
+					return ret;
+				else
+					present = true;
+			}
+		}
+	}
+
+	if (!present) {
+		pfn = spte_to_pfn(*addr);
+		mmu_spte_clear_track_bits(addr);
+		kvm_release_pfn_clean(pfn);
+	}
+	return ret;
+}
+
+void kvm_direct_tdp_remove_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	gfn_t gfn = slot->base_gfn;
+	int host_level;
+
+	if (!kvm->arch.global_root_hpa)
+		return;
+
+	for (gfn = slot->base_gfn;
+		gfn < slot->base_gfn + slot->npages;
+		gfn += KVM_PAGES_PER_HPAGE(host_level))
+		host_level = __kvm_remove_spte(kvm, &(kvm->arch.global_root_hpa), gfn, PT64_ROOT_4LEVEL);
+
+	kvm_flush_remote_tlbs(kvm);
+}
+
 /*
  * Calculate mmu pages needed for kvm.
  */
-- 
2.17.1

