Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8A297B66
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759993AbgJXINd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 04:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759987AbgJXIKd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 24 Oct 2020 04:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603527029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MxP14utHMULsl3WXK0dJ6zVnCUZr6qoeodCunclasgs=;
        b=fNT5fTGOhUPuPL2XrMp8Ii2z8qmB+Sic+g/rNl+0w6Sl+TnJufasAP1uG+WwmewsB/KTHj
        GKDQVSMeelZ3C0YjbEgUvuDwtnlheVgBvBAhhb1sMXHhN7hCSXx9IW4xYzrqAShuu7Tk9v
        Go1U2aQoETR35koGkHGhuh8MITH1+lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-yLgipaYwOY2OHFz0_xmqIg-1; Sat, 24 Oct 2020 04:10:27 -0400
X-MC-Unique: yLgipaYwOY2OHFz0_xmqIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9A95186DD23;
        Sat, 24 Oct 2020 08:10:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CE025578A;
        Sat, 24 Oct 2020 08:10:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] KVM: vmx: rename pi_init to avoid conflict with paride
Date:   Sat, 24 Oct 2020 04:10:24 -0400
Message-Id: <20201024081024.2798990-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

allyesconfig results in:

ld: drivers/block/paride/paride.o: in function `pi_init':
(.text+0x1340): multiple definition of `pi_init'; arch/x86/kvm/vmx/posted_intr.o:posted_intr.c:(.init.text+0x0): first defined here
make: *** [Makefile:1164: vmlinux] Error 1

because commit:

commit 8888cdd0996c2d51cd417f9a60a282c034f3fa28
Author: Xiaoyao Li <xiaoyao.li@intel.com>
Date:   Wed Sep 23 11:31:11 2020 -0700

    KVM: VMX: Extract posted interrupt support to separate files

added another pi_init(), though one already existed in the paride code.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 arch/x86/kvm/vmx/posted_intr.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index e4e7adff818c..f02962dcc72c 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -222,7 +222,7 @@ void pi_wakeup_handler(void)
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 }
 
-void __init pi_init(int cpu)
+void __init pi_init_cpu(int cpu)
 {
 	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
 	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index e53b97f82097..0bdc41391c5b 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -91,9 +91,9 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 int pi_pre_block(struct kvm_vcpu *vcpu);
 void pi_post_block(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
-void __init pi_init(int cpu);
+void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 		   bool set);
 
-#endif /* __KVM_X86_VMX_POSTED_INTR_H */
\ No newline at end of file
+#endif /* __KVM_X86_VMX_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 755896797a81..281c405c7ea3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8004,7 +8004,7 @@ static int __init vmx_init(void)
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 
-		pi_init(cpu);
+		pi_init_cpu(cpu);
 	}
 
 #ifdef CONFIG_KEXEC_CORE
-- 
2.26.2

