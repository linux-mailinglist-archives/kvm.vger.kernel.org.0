Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2A64178A1
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347655AbhIXQd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347424AbhIXQdl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pvBapdQ+zIzAmyxrrOIhvPAnOMqQp2FLAZOjpWmFNDo=;
        b=D8detBW4iAoiQ6abBIt5Mdq2MQ9plcP02z3lSDmkUYN8tsdhr6niZ6+vXMwXEJxasNYyV5
        +ALSQQBvqW7JkFibJuRfToPhQQIDGKOtBKPkoQ15NeMyc08/lvrBuBUFOXRw2Dcx/JXJEX
        P76fnYVkx+k4zCqcLKTv6pEYYJsj8G4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-zQLAOaFBMIa6AFkmt1myaw-1; Fri, 24 Sep 2021 12:32:04 -0400
X-MC-Unique: zQLAOaFBMIa6AFkmt1myaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF0FC10168D0;
        Fri, 24 Sep 2021 16:32:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24C5E60E1C;
        Fri, 24 Sep 2021 16:32:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH v3 16/31] KVM: x86/mmu: Verify shadow walk doesn't terminate early in page faults
Date:   Fri, 24 Sep 2021 12:31:37 -0400
Message-Id: <20210924163152.289027-17-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

WARN and bail if the shadow walk for faulting in a SPTE terminates early,
i.e. doesn't reach the expected level because the walk encountered a
terminal SPTE.  The shadow walks for page faults are subtle in that they
install non-leaf SPTEs (zapping leaf SPTEs if necessary!) in the loop
body, and consume the newly created non-leaf SPTE in the loop control,
e.g. __shadow_walk_next().  In other words, the walks guarantee that the
walk will stop if and only if the target level is reached by installing
non-leaf SPTEs to guarantee the walk remains valid.

Opportunistically use fault->goal-level instead of it.level in
FNAME(fetch) to further clarify that KVM always installs the leaf SPTE at
the target level.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20210906122547.263316-1-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 3 +++
 arch/x86/kvm/mmu/paging_tmpl.h | 7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5ba0a844f576..2ddbabad5bd2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3012,6 +3012,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
+	if (WARN_ON_ONCE(it.level != fault->goal_level))
+		return -EFAULT;
+
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
 			   fault->write, fault->goal_level, base_gfn, fault->pfn,
 			   fault->prefault, fault->map_writable);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6bc0dbc0baff..7a8a2d14a3c7 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -760,9 +760,12 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		}
 	}
 
+	if (WARN_ON_ONCE(it.level != fault->goal_level))
+		return -EFAULT;
+
 	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
-			   it.level, base_gfn, fault->pfn, fault->prefault,
-			   fault->map_writable);
+			   fault->goal_level, base_gfn, fault->pfn,
+			   fault->prefault, fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-- 
2.27.0


