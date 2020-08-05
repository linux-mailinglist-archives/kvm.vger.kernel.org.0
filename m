Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0024D23D0A0
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgHETv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgHEQwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:52:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58109C0A893B;
        Wed,  5 Aug 2020 07:12:31 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r4so14687781pls.2;
        Wed, 05 Aug 2020 07:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ubR+1U/66cwEoUeTJMc9atQb7+ROgmCea2NvMPQs8PQ=;
        b=GxS+vZ2kVfbNjb07AZMVexUY0voxfkHVoEXsmMZImY7zdHxjqEqIk93rbwZ1Y2upMe
         iacdMzNeIUNZxaskLbQugw+oEvKagukI3WviguHLiY+BPthHNnn51BVYQtJV5+lnsmpb
         qUfHuAti9HoDFFnGk1nOlUKdSbj7KlQDPPnRh+JzvyRUgkfh5nlpXho1ilUoNrmVj87d
         X/jK5c6fFchj/PKd990jxwDPZed3+iBMy6cxPzms6XR3Jwd/NBknzE6y0Fici3z72d7a
         YYksm3vRqLGxcdeIxog9DquthiKVRs0BpfaaQh0quVFLMjqyLu4+79mfW/dtkvC/h1ny
         SGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ubR+1U/66cwEoUeTJMc9atQb7+ROgmCea2NvMPQs8PQ=;
        b=hOGQ9tpfKXXOmTxIgAa9JqGe4/hM9+uXW0hOeUzeVicZdIkAMiiv0H79FqCRaUF/5P
         qkHadqLrR6RVSSlZ6QUk79c/dCJ9kDomvs0l5lZl2wTQjiGrixoEtX371VAD9ztt8gxx
         EvK72aix1ufSFNAhzl11LErgbfCKdBaqEMrZpaD6BWfoOnQV+C1pw4OWfHtP5flI8nJm
         1xqVFsK4x8mNucQY2OwDvmYEDnx+Dq+Rh3GaJbidLOh6DF0MaZ0CEMv/uOFg/jMXb7yp
         WcRY0f6nzTlvHBnaF7HvpJjUAGUavV1+sIop7O7l4zLKbfHBmH1n4KP5MUe69N29sbmM
         hPVA==
X-Gm-Message-State: AOAM530CFNlgYWN+LuQpBwX9D/YWvEkZEfNRgrsHB2GOIa+0n8O9czCj
        6RpjxEAeEIcoF0AZiRh+28I=
X-Google-Smtp-Source: ABdhPJwvn3rF3guqUVD0j8h0EFW39vmETXxaXwHQFfjOtTy0pj72nVixtwJD0JIxQcE/AVhbQg8p1A==
X-Received: by 2002:a17:90a:b88b:: with SMTP id o11mr3527448pjr.58.1596636750850;
        Wed, 05 Aug 2020 07:12:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.62])
        by smtp.gmail.com with ESMTPSA id l17sm4156287pff.126.2020.08.05.07.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:12:30 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 3/9] Introduce page table remove function for direct build EPT feature
Date:   Wed,  5 Aug 2020 22:13:20 +0800
Message-Id: <20200805141320.8941-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
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
index 1609012be67d..539974183653 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6454,6 +6454,62 @@ int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *
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

