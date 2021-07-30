Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA5C3DC0BC
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhG3WFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:05:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232672AbhG3WFI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 18:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627682702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSBJ7FBNCe1tAX/jT7A68XhwxPR3lX/uR04jjJ3Q1pU=;
        b=OwyGDBTT/M7qGmLVGiI6Kkxf8SXrE+XwX21M/fklZHrOXj8UnJCRxkkNJzNF2mXTQnjTju
        YnD9eizbujfomM4gRGRUIceC1/QR4nEq8Uyr3iqpGP+R1JyVntUTgg35Zb9wO+EnryriDB
        n07is+roabaZ6xXkX0v3kQqpIRLEnCQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-iDbodSd0MpervcqRp5oMWw-1; Fri, 30 Jul 2021 18:05:01 -0400
X-MC-Unique: iDbodSd0MpervcqRp5oMWw-1
Received: by mail-qt1-f197.google.com with SMTP id l7-20020ac848c70000b0290252173fe79cso5158500qtr.2
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NSBJ7FBNCe1tAX/jT7A68XhwxPR3lX/uR04jjJ3Q1pU=;
        b=PU+wazW4wUumtSR7s5eDRcIEqdfDubIs+Ds5gwYUUBJFmRB7jwNDrIH4rVYJkR6M0p
         WxkYMSBeikxkrfx6oOs1R9Wub02b+cuSBvP9liGCwT6pDY1Ndozb/XhYzCB/F6zIIFnl
         c6M9RvWkhFPQ2s6TxlKOGBzdjfXplGJTB/BH072j3jt4NhmOT0MEwewZbZxfwc9WSKNq
         TyNhnKr0EJFh3AqKUEsi9YMjN0D8HKUpnr+nPyc2ukhLhsptvcEyJ0TaSmjTmmsPKIQA
         e2CEDuSzkxwfjvuwX4Jdj63kCZk95EhhmNZaptHZIdFavftHXVmFGsgMFLPKG1+J6oTz
         uzwg==
X-Gm-Message-State: AOAM5335P0weYM792wdCF0/KE4nRA0J8moCxLxn4LwlKOjSJcsSEZTKt
        UXknwBjHJY3l0IvG7EnvDgzHVkVEmT2oRs9pefk7EUsPyXZ74SHVcMBgFEw5ZIYCRR0Sg1FCCks
        0OLLgdGu5qAsRVVGZTY7UiDS4F/4g1emj+cA/nssugROpau/LKGv0huxMB4l3oA==
X-Received: by 2002:a05:620a:1423:: with SMTP id k3mr4382996qkj.311.1627682700541;
        Fri, 30 Jul 2021 15:05:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsE0R7naZuNPnJJC2QXc2HOhX6dmnUYtwJ3AeyZw/7H252RCpv0ekq01gRagRLcYrLB58hlA==
X-Received: by 2002:a05:620a:1423:: with SMTP id k3mr4382968qkj.311.1627682700254;
        Fri, 30 Jul 2021 15:05:00 -0700 (PDT)
Received: from t490s.. (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id l12sm1199651qtx.45.2021.07.30.15.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:04:59 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 2/7] KVM: X86: Introduce pte_list_count() helper
Date:   Fri, 30 Jul 2021 18:04:50 -0400
Message-Id: <20210730220455.26054-3-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730220455.26054-1-peterx@redhat.com>
References: <20210730220455.26054-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helper is used to count the number of rmap entries in the rmap list
pointed by the kvm_rmap_head.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          | 21 +++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5429c20cf2cf..16c99f771c9e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -998,6 +998,27 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 	__pte_list_remove(sptep, rmap_head);
 }
 
+unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
+{
+	struct pte_list_desc *desc;
+	unsigned int i, count = 0;
+
+	if (!rmap_head->val)
+		return 0;
+	else if (!(rmap_head->val & 1))
+		return 1;
+
+	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+
+	while (desc) {
+		for (i = 0; (i < PTE_LIST_EXT) && desc->sptes[i]; i++)
+			count++;
+		desc = desc->more;
+	}
+
+	return count;
+}
+
 static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 					   const struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ca7b7595bbfc..62bb8f758b3f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -131,6 +131,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
+unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
-- 
2.31.1

