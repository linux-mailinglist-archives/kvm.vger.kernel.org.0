Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E4DBFBD0
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfIZXS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:58 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:50779 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfIZXS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:58 -0400
Received: by mail-qt1-f202.google.com with SMTP id d24so3175079qtn.17
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ss4PksOshRYZKrEYLVpamWjUtlHgN82Ss6+WzEoWR/I=;
        b=Ift8WiOEhGWektL5HivQyZFE6GUOYG6bYHJxB+QK/zvwyAy5RgaxcTKPJkAgYkbC9o
         VgJGgZwBMHwgTx2T+Z8bf6gmS0it8Za8RTAKS6tave4CMaRDgoE0FkFuJ4VIojLLd91t
         qIoYGO6We3qZnJOK4j1vKdmAEnkVfNgom1E1aQSNVPIScq2EkqvLF9azhnHMdEZqs+rQ
         vhFx8dWvyga0G8a4YocPl6fcDSb9xnjDkha0vJOqpRVIf2G4QOgtorMumVqpJ3uNJQHN
         dtzypsDQL4BsuJnE8G5lcQN4fUgaoJ0bS8JawYbkOkTgwBcVm4K8WxwDysYDWoqb22ff
         l8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ss4PksOshRYZKrEYLVpamWjUtlHgN82Ss6+WzEoWR/I=;
        b=f+QjFp3htt0cbjur80lsiAOa2KoxLV20vhy2d4UdA1BaVAKluVM48j11VopJLf3Ldx
         U1FYhH+HbM+NaDIPlwclYnge6sW0XLo1JbaNmC4NNHjPcaHUdljnHvkDq2XvF7tG8utE
         XwICeYHop0FdZzig8Uu+QRIcsKfvFkPdSqoxzUFZIZalvXrZ6Y8MQkmRR1rcRsZUXcKP
         ucax4X1irLXhZzsGewYzxuO24upJ1X9LkUGfMPOg4mvfypXLrDUoVyBwDY6G2u0cRCXC
         QxGU/yJVbYoqCbKntjSBt11FO5nMF3f3o9IrooVOXVJS7Y79q0JaA9jcDrpn5UsFtO0E
         AHlA==
X-Gm-Message-State: APjAAAXePOthbsR8n7f49cjWaKYhC79AxyZpOInSCVMcWvHAs549MeU9
        jnoH8JwE9BbEUv0zqTf3gb5AVqp/+Ei+onVbaMBBXPhqRWWL9igMSbUJMF5uue6QfP/DUFNQqlw
        zJ0zKn+l068x6a7iSl43rRNbNuK+YXJH79k5zEhVaC2ejpYqVyrK2v6f6lbWK
X-Google-Smtp-Source: APXvYqy1uVlE4u8nD9WPQhr+cMF/pU4j6Tjbp9qq0W2tzRVbJsleNJ0RaZVKbErMoAEuHuUaLSXsKuqffwww
X-Received: by 2002:ac8:5399:: with SMTP id x25mr6959278qtp.144.1569539935556;
 Thu, 26 Sep 2019 16:18:55 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:08 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-13-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 12/28] kvm: mmu: Set tlbs_dirty atomically
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tlbs_dirty mechanism for deferring flushes can be expanded beyond
its current use case. This allows MMU operations which do not
themselves require TLB flushes to notify other threads that there are
unflushed modifications to the paging structure. In order to use this
mechanism concurrently, the updates to the global tlbs_dirty must be
made atomically.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/paging_tmpl.h | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 97903c8dcad16..cc3630c8bd3ea 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -986,6 +986,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	bool host_writable;
 	gpa_t first_pte_gpa;
 	int set_spte_ret = 0;
+	int ret;
+	int tlbs_dirty = 0;
 
 	/* direct kvm_mmu_page can not be unsync. */
 	BUG_ON(sp->role.direct);
@@ -1004,17 +1006,13 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
 
 		if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
-					       sizeof(pt_element_t)))
-			return 0;
+					       sizeof(pt_element_t))) {
+			ret = 0;
+			goto out;
+		}
 
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			/*
-			 * Update spte before increasing tlbs_dirty to make
-			 * sure no tlb flush is lost after spte is zapped; see
-			 * the comments in kvm_flush_remote_tlbs().
-			 */
-			smp_wmb();
-			vcpu->kvm->tlbs_dirty++;
+			tlbs_dirty++;
 			continue;
 		}
 
@@ -1029,12 +1027,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
-			/*
-			 * The same as above where we are doing
-			 * prefetch_invalid_gpte().
-			 */
-			smp_wmb();
-			vcpu->kvm->tlbs_dirty++;
+			tlbs_dirty++;
 			continue;
 		}
 
@@ -1051,7 +1044,11 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
-	return nr_present;
+	ret = nr_present;
+
+out:
+	xadd(&vcpu->kvm->tlbs_dirty, tlbs_dirty);
+	return ret;
 }
 
 #undef pt_element_t
-- 
2.23.0.444.g18eeb5a265-goog

