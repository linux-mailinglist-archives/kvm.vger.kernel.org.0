Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AD11E8246
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgE2PmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:42:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727831AbgE2Pjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBGkYgyJ8t56KCY/g0VbmTME7lFoIVkD8I73jTWjLnc=;
        b=T97bK0sMZdiVibQgjQ+gg4vH0jIfN0OhXdpcGDl1sx9wWi+wG9DzV66fI//TDwLGJnY7au
        7OQEwc1wpBk9+kxG/pTijDb3ktWMn371/7f/cipHl3nAE23/e48+vKKiowJJq/qAReRKSN
        rjw7S35B36uxTaDq0lD1g4OouvOdFL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-Vnng9a8hO2GtalkyuGuPUg-1; Fri, 29 May 2020 11:39:40 -0400
X-MC-Unique: Vnng9a8hO2GtalkyuGuPUg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B7FC19057A1;
        Fri, 29 May 2020 15:39:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5E2D5D9D5;
        Fri, 29 May 2020 15:39:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 07/30] KVM: nVMX: always update CR3 in VMCS
Date:   Fri, 29 May 2020 11:39:11 -0400
Message-Id: <20200529153934.11694-8-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02 as
an optimization, but this is only correct before the nested vmentry.
If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
already been put in guest mode, the value of CR3 will not be updated.
Remove the optimization, which almost never triggers anyway.

Fixes: 04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b3a41645e157..7b55dc6230a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3085,10 +3085,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
-		/* Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter. */
-		if (is_guest_mode(vcpu))
-			update_guest_cr3 = false;
-		else if (!enable_unrestricted_guest && !is_paging(vcpu))
+		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
 		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			guest_cr3 = vcpu->arch.cr3;
-- 
2.26.2


