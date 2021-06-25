Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FFF3B46A9
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhFYPe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:34:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhFYPer (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R6vqFh3euA4lluHZrjH7C0VB/8jbPFxvQZcd2X8+z8A=;
        b=gOg0EzZ/PO+pmdV7p/lvXOkYihwQyyn+imYWLEP6OAE36HqVGSZJZGM6TFLoZcvQg3RzYR
        Tk4GOnHFN1dlXfM26swAuX/WtBXuWuRVyOuptL+bmMVN13p8Acb+uloxfNlxlQ8XPVn+It
        1cxC+0o3itqf+3DLnFV4iAkune3MqlU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-eQaVRf95NLO2x_rnyNpxLw-1; Fri, 25 Jun 2021 11:32:24 -0400
X-MC-Unique: eQaVRf95NLO2x_rnyNpxLw-1
Received: by mail-io1-f72.google.com with SMTP id x21-20020a5d99150000b02904e00bb129f0so7237300iol.18
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R6vqFh3euA4lluHZrjH7C0VB/8jbPFxvQZcd2X8+z8A=;
        b=XvtH+HKzwI4XL5ESYQXdv3uPe7HVh2izTQV9aoQOv0yJhs4LQgDAOVjsxU06gN8RVN
         BtHmYBJmC6pE4TnFvmILd+35OJD9QcehKFFtlZ0OffuLLV9oHlzKAN6D2vWQSXqJwO9x
         0B3a9b2Z+Ub0sZTm4KmpxvldtzKuKNbUcNGEmp5mK+icdQ6jRwncFiTfKGTG49LWyl83
         Ksg9DUtdLWkdKbA1H8w2QVlSDpG4fMmkl+hkvgCt3hz91JBZyhTPy4TAzo+QYJm/pQUs
         jW73L8nYYW93dZtsuFVC9oUopP5XqsyYL162vdSpeoznRrEPZn4gzWLoqxaJImk8l1Rq
         v3pA==
X-Gm-Message-State: AOAM531kwJ9PWHxRm2GfTMcztXSAU+ZKmJ2rbNjko4+fTizMHiT6hU9A
        ILmHElPj/Rqw0p/h3C5YTlhAVsNA1rswDir7cXMGZc0YW60IehbhiBYhK+5RhQ2p02TpDyKylES
        Cmm2J+KNjL2KX
X-Received: by 2002:a92:ddce:: with SMTP id d14mr8010926ilr.279.1624635143828;
        Fri, 25 Jun 2021 08:32:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiQrN5psgZSp7PJvYOwSrLNB9dXZdC9/rSyism8PuiJvzWVvPfNV/3BaOd5802wgskCbtFHg==
X-Received: by 2002:a92:ddce:: with SMTP id d14mr8010912ilr.279.1624635143672;
        Fri, 25 Jun 2021 08:32:23 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id s8sm3668772ilj.51.2021.06.25.08.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:32:23 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 4/9] KVM: X86: Introduce pte_list_count() helper
Date:   Fri, 25 Jun 2021 11:32:09 -0400
Message-Id: <20210625153214.43106-5-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
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
index eb16c1dbbb32..b3f738a7c05e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -990,6 +990,27 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
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
index 35567293c1fd..325b4242deed 100644
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

