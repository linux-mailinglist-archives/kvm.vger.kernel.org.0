Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7499F3B356A
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhFXSQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232602AbhFXSQ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ny4N/dv5g7DO3oaKKsT3k5Lo/RLroZYI+1qWA8iS2Y=;
        b=i4hQ4JNrDXb07Ey5sILHPCkpkCzZR3IFYcMcDJ/Fcfss7e3wcjhInZarDw4mfZuvbH5sc1
        NF2SWijnKUlmjf9KqMOGye7cjwDNnseM+c7dJhmiMRCOgiwkECXwc0k8nDDlADntilZs8U
        Lh9mSHThnwztZwRdy6adu5ES0rke++A=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-IOOgXmztP4OrDJWaZNQB6A-1; Thu, 24 Jun 2021 14:14:05 -0400
X-MC-Unique: IOOgXmztP4OrDJWaZNQB6A-1
Received: by mail-qk1-f197.google.com with SMTP id y206-20020a3764d70000b02903b2ff4c81b1so6543402qkb.21
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ny4N/dv5g7DO3oaKKsT3k5Lo/RLroZYI+1qWA8iS2Y=;
        b=i3ZudLv4I4pbWn4wj5AuIVm0Q4wiGXXxuRX8udwRkxRO71pYasQAYDxJieDHSNBdh9
         WVVxdCqS1HwBdduc4vo/cOq+yQYk8pd1E93OfmgPnEKeSJRTfm4B/zrxRtMkl70t3kWk
         qF5xKCIl6/I9r0IzseoamYM40bMdDyaTb6SRljavXNpyNdfytihC2vMGZRIS0/7ffUzz
         PNAjDrKeDCFpHF1qcGk2ZFv5miRx6YBOAdV9mNjNOOBMBw9LL7uNKaummeGOZbJ/pJJl
         7FJC9bcOaAUFSE1CfEkGcZm/WhBy1XfR1eEi6oOMcmC4ias8goIvR26fzwXBDpgZ5o6y
         L+Mg==
X-Gm-Message-State: AOAM533nkfzHauu5U+JJDsJvtaBwcW1A2fGUaCTO8QILwuOCibAb93IA
        BQNA+ls3hKVn2agWhndDyrGv1ggtZdBmbGNj0xGMQH1mgpGq8RSBBRoHlfJmYphzx4FFthe7hv6
        QjqhaQYZsGnXzmYeB/jzk50hOMtxWEvfdL/jfkj2u3xA507XVILRmzjwADn+gWg==
X-Received: by 2002:a37:f510:: with SMTP id l16mr7017498qkk.205.1624558444897;
        Thu, 24 Jun 2021 11:14:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5xeg8fkVzCvznQIXVQuhoVQJFpwIzM0cNNpma6+xzwHDzRQWv3casplWNqC4T8UNyOmhZfQ==
X-Received: by 2002:a37:f510:: with SMTP id l16mr7017476qkk.205.1624558444679;
        Thu, 24 Jun 2021 11:14:04 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:14:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 4/9] KVM: X86: Introduce pte_list_count() helper
Date:   Thu, 24 Jun 2021 14:13:51 -0400
Message-Id: <20210624181356.10235-5-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
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
index 6dd338738118..80263ecb1de3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -927,6 +927,27 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
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
 					   struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d64ccb417c60..3cd1a878ffeb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -126,6 +126,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
+unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
-- 
2.31.1

