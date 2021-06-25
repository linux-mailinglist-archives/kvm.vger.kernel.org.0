Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B83B46B7
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhFYPgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:36:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhFYPgq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YjcyYxrINnzSou8d5xoDOd+Q0j+eHgX3Un7gw5UoKHs=;
        b=SLDnNfrFLu25XkZgpdqr93BaJ+kgGnqekCtt3nK0Dd1t6Y4KQxAsohZSqOWfdvS7oK0w8Q
        5DBhU9+1MIveailE07PgPKxNm2Hxk+btGIAEeq0r2tYOurIBi4ahCV230KEqND2p6Zprvo
        h8oiuHOMliefeCN/Kl9I4UvMeJitfJ4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-AQkvYzYHM7iFj7fhtMlNpQ-1; Fri, 25 Jun 2021 11:34:21 -0400
X-MC-Unique: AQkvYzYHM7iFj7fhtMlNpQ-1
Received: by mail-io1-f70.google.com with SMTP id w22-20020a5ed6160000b02904f28b1d759dso206708iom.8
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YjcyYxrINnzSou8d5xoDOd+Q0j+eHgX3Un7gw5UoKHs=;
        b=P2+peqSPn9Uc3HlhF5W+cIgIr8cocVgDnCA5y3DyKKmbieLnUHuvFpV0IG1lwIKFum
         neJ8KYYr4qcjN/GpXJPlwBLNXQ9xlrC1paWm5TnvOKL5xrbbeQ+DDFZj/kpxkjcMdq/F
         31oz3VZAhfanqp1f/m6kyF9tnGuhBNA2AR6UPOwJgtoIyaZeRVy+1MSRR62dZvwd/tqX
         H4v/QdE7DNXkkvEwdAoQ2Ji4/1591DeugXYxEVoXTnCB+ufb+5Rv0BZ11ZQFc/j3yxSD
         Y8IVS5z+xRVU9r0lZfRjNNDsLRJ5IQfd9zs9QYKirgMmByiedrrkCo/xDPVEvJA7tLdG
         9ceg==
X-Gm-Message-State: AOAM530pHDo1kp/1l0yI75x6o/GriVOUy9/E1uzZV8K36OdVOg8uc/e4
        ZYtOsJt8e1GB4hDGAvWyperWsjHq0h9avCPDnIObjHk+MwdjCksBFz05Z71cUu2ZkvE/m90aOKj
        iv6b9yekgogEG
X-Received: by 2002:a6b:2b44:: with SMTP id r65mr8803099ior.99.1624635261303;
        Fri, 25 Jun 2021 08:34:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDrcMjN0grhcN1xdY2Kguub8DNog6SwRyubFGgLe1lkSEeK2CSuD5j9rsyWmXrReWuXadcJg==
X-Received: by 2002:a6b:2b44:: with SMTP id r65mr8803084ior.99.1624635261102;
        Fri, 25 Jun 2021 08:34:21 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id 67sm3126275iob.15.2021.06.25.08.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:34:20 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 9/9] KVM: X86: Optimize zapping rmap
Date:   Fri, 25 Jun 2021 11:34:19 -0400
Message-Id: <20210625153419.43671-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
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
 arch/x86/kvm/mmu/mmu.c | 45 +++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba0258bdebc4..45aac78dcabc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1014,6 +1014,38 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	return count;
 }
 
+/* Return true if rmap existed and callback called, false otherwise */
+static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
+			     int (*callback)(u64 *sptep))
+{
+	struct pte_list_desc *desc, *next;
+	int i;
+
+	if (!rmap_head->val)
+		return false;
+
+	if (!(rmap_head->val & 1)) {
+		if (callback)
+			callback((u64 *)rmap_head->val);
+		goto out;
+	}
+
+	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+
+	while (desc) {
+		if (callback)
+			for (i = 0; i < desc->spte_count; i++)
+				callback(desc->sptes[i]);
+		next = desc->more;
+		mmu_free_pte_list_desc(desc);
+		desc = next;
+	}
+out:
+	/* rmap_head is meaningless now, remember to reset it */
+	rmap_head->val = 0;
+	return true;
+}
+
 static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 					   struct kvm_memory_slot *slot)
 {
@@ -1403,18 +1435,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			  struct kvm_memory_slot *slot)
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
+	return pte_list_destroy(rmap_head, mmu_spte_clear_track_bits);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-- 
2.31.1

