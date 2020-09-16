Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54DA26C011
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 11:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIPJDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 05:03:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43665 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726452AbgIPJDx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 05:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600247031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=k1t3aEF1OX+VjrQN9WEWMI8c1AvBflhlomB9um5hxKk=;
        b=d8zM/AUuOyKv7qVnrbYYYB3kZIK/9uOgThZi5ns86Fy4DnSE3A5doSP4zBSNj48LMV/sGG
        4O6q2IwP+2hH/VdORDwyAPSBrbx5mjCgYWFj6fneiVn0M9iwgRpfyQcuBt6WI/tVKwTymu
        BmhuKCNQ1siag6BUR1ayos2zW1VfxyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-8tOYClDzM0itUWfAY2fe4A-1; Wed, 16 Sep 2020 05:03:48 -0400
X-MC-Unique: 8tOYClDzM0itUWfAY2fe4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5981A1005E72;
        Wed, 16 Sep 2020 09:03:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E040278808;
        Wed, 16 Sep 2020 09:03:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Haiwei Li <lihaiwei@tencent.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH] Revert "KVM: Check the allocation of pv cpu mask"
Date:   Wed, 16 Sep 2020 11:03:42 +0200
Message-Id: <20200916090342.748452-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit 0f990222108d ("KVM: Check the allocation of pv cpu mask") we
have in 5.9-rc5 has two issue:
1) Compilation fails for !CONFIG_SMP, see:
   https://bugzilla.kernel.org/show_bug.cgi?id=209285

2) This commit completely disables PV TLB flush, see
   https://lore.kernel.org/kvm/87y2lrnnyf.fsf@vitty.brq.redhat.com/

The allocation problem is likely a theoretical one, if we don't
have memory that early in boot process we're likely doomed anyway.
Let's solve it properly later.

This reverts commit 0f990222108d214a0924d920e6095b58107d7b59.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kernel/kvm.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1b51b727b140..9663ba31347c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -652,6 +652,7 @@ static void __init kvm_guest_init(void)
 	}
 
 	if (pv_tlb_flush_supported()) {
+		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
 		pr_info("KVM setup pv remote TLB flush\n");
 	}
@@ -764,14 +765,6 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);
 
-static void kvm_free_pv_cpu_mask(void)
-{
-	unsigned int cpu;
-
-	for_each_possible_cpu(cpu)
-		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
-}
-
 static __init int kvm_alloc_cpumask(void)
 {
 	int cpu;
@@ -790,20 +783,11 @@ static __init int kvm_alloc_cpumask(void)
 
 	if (alloc)
 		for_each_possible_cpu(cpu) {
-			if (!zalloc_cpumask_var_node(
-				per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu))) {
-				goto zalloc_cpumask_fail;
-			}
+			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu));
 		}
 
-	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
-	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
 	return 0;
-
-zalloc_cpumask_fail:
-	kvm_free_pv_cpu_mask();
-	return -ENOMEM;
 }
 arch_initcall(kvm_alloc_cpumask);
 
-- 
2.25.4

