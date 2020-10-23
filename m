Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587362973CE
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751671AbgJWQbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751617AbgJWQas (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZrJSzb3WHvQqEKUfz6VHAhcLq9jWnL01O60urGyRQw=;
        b=CiAjXrrDyUTE824GeH/v2z8rSTIea2vDvPiVZE82cL6a7XzcHxE+9l2QMF1rA3D82wSaAm
        uaFTQxhL25PZ3EDjLtuqKWrrt80oKieV7drc1OO8/XDSWAbfTTJoSOuO4I3zhMeDuEGSyj
        09NvfiagqSzBjVKeF9zByy7AMkt5yjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-ydw-wJqON_uTE5Duqo9dOw-1; Fri, 23 Oct 2020 12:30:43 -0400
X-MC-Unique: ydw-wJqON_uTE5Duqo9dOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5B83EC11A;
        Fri, 23 Oct 2020 16:30:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 430DA9CBC8;
        Fri, 23 Oct 2020 16:30:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 21/22] kvm: x86/mmu: Don't clear write flooding count for direct roots
Date:   Fri, 23 Oct 2020 12:30:23 -0400
Message-Id: <20201023163024.2765558-22-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Direct roots don't have a write flooding count because the guest can't
affect that paging structure. Thus there's no need to clear the write
flooding count on a fast CR3 switch for direct roots.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-20-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6a0941ccac34..7b52fa1f01b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3892,7 +3892,13 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 */
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	__clear_sp_write_flooding_count(to_shadow_page(vcpu->arch.mmu->root_hpa));
+	/*
+	 * If this is a direct root page, it doesn't have a write flooding
+	 * count. Otherwise, clear the write flooding count.
+	 */
+	if (!new_role.direct)
+		__clear_sp_write_flooding_count(
+				to_shadow_page(vcpu->arch.mmu->root_hpa));
 }
 
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
-- 
2.26.2


