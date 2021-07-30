Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566E93DC0CA
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhG3WGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233146AbhG3WGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 18:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627682770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o4BBOvgzxNUCJGeElx/7CJIgRVcb9Llih1duOoDbR4M=;
        b=iq5n5/mA1hd3AeNX0RyRTMn4v+PMwDrBLWbaLiWyYiboJ+G6busUmmS9hwHkvLGo8clXeI
        XA+ZDQs0rEXwGAnmuuJ5MDrdpE+dVMR07WAp0UiZPf/i+lR0AFSuuoc6dUVDjziwXnpD12
        06o7r9BpGbQ0I/qR86pjtH2VgWJJWe0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-7tBJQCaWPvS0xt48LluGsQ-1; Fri, 30 Jul 2021 18:06:07 -0400
X-MC-Unique: 7tBJQCaWPvS0xt48LluGsQ-1
Received: by mail-qk1-f198.google.com with SMTP id e11-20020a05620a208bb02903b854c43335so5986724qka.21
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o4BBOvgzxNUCJGeElx/7CJIgRVcb9Llih1duOoDbR4M=;
        b=iapL9uUcTkNBAyVNnkdmF3dsRZGClgU+pAHg4OzXTjQ51kqpLoaIuvRi/a6c/IqIHV
         gvUbIXkekNtZtMW40p5XVPGXSsxyoO6AoTAMOIo8KnISHDAK/8b5P5yWprNhwqzc2ga1
         6ttGKndYmKEC5K/9LLjs2IbJiJb/R9E1AiPLYCL+PQv4CKsTQUGbk+CKQQ07C/X6SDN+
         9x2cq9QTZAfjZbX9Mf8dtPKow2fRYumhkiEgogEf0N88EkkpyjJzl3AnJchdGIG9PnrL
         hsbkMVlb3CrMCmyy3TvKvuUTYlrriP6rhZV7WY9WLQNdpRjxBrnKiz8V11ufR9ge6rHd
         8dpQ==
X-Gm-Message-State: AOAM531CCL6U6BzMg0nuK3z67czVW69MVvoPXToAwcSahxp/bfzuD31b
        Xo11R61r7TU6ftwWbxhjuI+7f/Zno5kkc0TPc8ain0DpYKSbiywxP4Vefo31/q1xZzwVihIfnwx
        r4MunaAVwnsiQ
X-Received: by 2002:a0c:df09:: with SMTP id g9mr5152069qvl.30.1627682766745;
        Fri, 30 Jul 2021 15:06:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8B8Fu0lZQSprSiVyqxCrIMRlql3zmCcV7iN3gkLx6KiU458PV2fSBpow9iSveEnl956h6FQ==
X-Received: by 2002:a0c:df09:: with SMTP id g9mr5152051qvl.30.1627682766549;
        Fri, 30 Jul 2021 15:06:06 -0700 (PDT)
Received: from t490s.. (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id d16sm1154974qtj.69.2021.07.30.15.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:06:06 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 7/7] KVM: X86: Optimize zapping rmap
Date:   Fri, 30 Jul 2021 18:06:05 -0400
Message-Id: <20210730220605.26377-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730220455.26054-1-peterx@redhat.com>
References: <20210730220455.26054-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using rmap_get_first() and rmap_remove() for zapping a huge rmap list could be
slow.  The easy way is to travers the rmap list, collecting the a/d bits and
free the slots along the way.

Provide a pte_list_destroy() and do exactly that.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 111c37141dbe..9b2616760e23 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1027,6 +1027,34 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	return count;
 }
 
+/* Return true if rmap existed, false otherwise */
+static bool pte_list_destroy(struct kvm_rmap_head *rmap_head)
+{
+	struct pte_list_desc *desc, *next;
+	int i;
+
+	if (!rmap_head->val)
+		return false;
+
+	if (!(rmap_head->val & 1)) {
+		mmu_spte_clear_track_bits((u64 *)rmap_head->val);
+		goto out;
+	}
+
+	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+
+	for (; desc; desc = next) {
+		for (i = 0; i < desc->spte_count; i++)
+			mmu_spte_clear_track_bits(desc->sptes[i]);
+		next = desc->more;
+		mmu_free_pte_list_desc(desc);
+	}
+out:
+	/* rmap_head is meaningless now, remember to reset it */
+	rmap_head->val = 0;
+	return true;
+}
+
 static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 					   const struct kvm_memory_slot *slot)
 {
@@ -1418,18 +1446,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			  const struct kvm_memory_slot *slot)
 {
-	u64 *sptep;
-	struct rmap_iterator iter;
-	bool flush = false;
-
-	while ((sptep = rmap_get_first(rmap_head, &iter))) {
-		rmap_printk("spte %p %llx.\n", sptep, *sptep);
-
-		pte_list_remove(rmap_head, sptep);
-		flush = true;
-	}
-
-	return flush;
+	return pte_list_destroy(rmap_head);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-- 
2.31.1

