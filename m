Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B6470F48
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 01:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345409AbhLKAPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 19:15:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244137AbhLKAPk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 19:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639181524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cvGP21/tndevis1BecHSxZ3W2vlszEHfVpFxmLIpCPs=;
        b=Ju/TooJKz+ggSuvLFoKec3k/cPNx99pz6l8hWoY3982DkQCnHBK1TNuIYuDBu+ks9g5maJ
        uLOKjSpmxSBDsX/i0eq2xEY4CpU5r2sFROkSCk6sLxhdyCFiwkrLucUS69oqarSBG0inot
        8m+6EqAjXasidSJLKfxOmHzacXcrTW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-3Y2GxqywObSQthUteKlEow-1; Fri, 10 Dec 2021 19:12:01 -0500
X-MC-Unique: 3Y2GxqywObSQthUteKlEow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B09A31006AA0;
        Sat, 11 Dec 2021 00:11:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 411D97AB47;
        Sat, 11 Dec 2021 00:11:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     laijs@linux.alibaba.com, Sean Christopherson <seanjc@google.com>
Subject: [PATCH] Revert "KVM: X86: Update mmu->pdptrs only when it is changed"
Date:   Fri, 10 Dec 2021 19:11:57 -0500
Message-Id: <20211211001157.74709-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 24cd19a28cb7174df502162641d6e1e12e7ffbd9.
Sean Christopherson reports:

"Commit 24cd19a28cb7 ('KVM: X86: Update mmu->pdptrs only when it is
changed') breaks nested VMs with EPT in L0 and PAE shadow paging in L2.
Reproducing is trivial, just disable EPT in L1 and run a VM.  I haven't
investigating how it breaks things."

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 85127b3e3690..af22ad79e081 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -841,12 +841,9 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 		}
 	}
 
-	kvm_register_mark_available(vcpu, VCPU_EXREG_PDPTR);
-	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
-		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
-		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
-		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
-	}
+	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 	vcpu->arch.pdptrs_from_userspace = false;
 
 	return 1;
-- 
2.31.1

