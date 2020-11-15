Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C7C2B35BF
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgKOP16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 10:27:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgKOP16 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 15 Nov 2020 10:27:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605454077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tEILAmOv/3vnRK3BL1tBNlRIN1HW0Lh9cIAmXOTwRHs=;
        b=LAqSXJo7MhCNZGYUZyif28vjHj9Hd6cppfAWB2qR41sM07h5mukQenaAW0Fosf+3OJdWD/
        7xnKfirys4/TslPi4gdy9tpsHieXiWirDo9ebd0VJE5IbW8e0jVcD/j9BEJT09kiESd58V
        mftxMQZw5VVqXHMHKV1m2Bu7Imz5r5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-dVX9a26FOB2wCnB7W9j7mQ-1; Sun, 15 Nov 2020 10:27:54 -0500
X-MC-Unique: dVX9a26FOB2wCnB7W9j7mQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82240427C7;
        Sun, 15 Nov 2020 15:27:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A39321E78;
        Sun, 15 Nov 2020 15:27:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>
Subject: [PATCH] kvm: mmu: fix is_tdp_mmu_check when the TDP MMU is not in use
Date:   Sun, 15 Nov 2020 10:27:52 -0500
Message-Id: <20201115152752.1625224-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases where shadow paging is in use, the root page will
be either mmu->pae_root or vcpu->arch.mmu->lm_root.  Then it will
not have an associated struct kvm_mmu_page, because it is allocated
with alloc_page instead of kvm_mmu_alloc_page.

Just return false quickly from is_tdp_mmu_root if the TDP MMU is
not in use, which also includes the case where shadow paging is
enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 27e381c9da6c..ff28a5c6abd6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -49,7 +49,14 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 {
 	struct kvm_mmu_page *sp;
 
+	if (!kvm->arch.tdp_mmu_enabled)
+		return false;
+	if (WARN_ON(!VALID_PAGE(hpa)))
+		return false;
+
 	sp = to_shadow_page(hpa);
+	if (WARN_ON(!sp))
+		return false;
 
 	return sp->tdp_mmu_page && sp->root_count;
 }
-- 
2.26.2

