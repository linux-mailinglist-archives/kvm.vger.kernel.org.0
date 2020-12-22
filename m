Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B142DC5F6
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 19:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgLPSKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 13:10:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729193AbgLPSKE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 13:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608142118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mamO1/NlN2O4Takc5K2x/wvpBK6RpZ5yuQxG16/89wI=;
        b=OIdKkCKbFdOH+dHu+n+NbGvVBHwX1Rtabaw35AXcLtXkZuBzG0mHzW1HoQ2qOn5Hze4wVS
        l6SOd+EUhb9HJENZjRBmwdiuBv1AGrHBP8HCkMfx3EJL4qS5/G2OZOu3rW/wQkPPyl3X9I
        XxMnShdZgdC29pHCBcl6ae9Z7pTumws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-wsnpYp6oP0Gt_w03dLWVEg-1; Wed, 16 Dec 2020 13:08:36 -0500
X-MC-Unique: wsnpYp6oP0Gt_w03dLWVEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5253873233;
        Wed, 16 Dec 2020 18:08:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52CF45D9EF;
        Wed, 16 Dec 2020 18:08:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com
Subject: [PATCH] KVM: SVM: fix 32-bit compilation
Date:   Wed, 16 Dec 2020 13:08:34 -0500
Message-Id: <20201216180834.1466389-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VCPU_REGS_R8...VCPU_REGS_R15 are not defined on 32-bit x86,
so cull them from the synchronization of the VMSA.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8b5ef0fe4490..e57847ff8bd2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -529,6 +529,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->rbp = svm->vcpu.arch.regs[VCPU_REGS_RBP];
 	save->rsi = svm->vcpu.arch.regs[VCPU_REGS_RSI];
 	save->rdi = svm->vcpu.arch.regs[VCPU_REGS_RDI];
+#ifdef CONFIG_X86_64
 	save->r8  = svm->vcpu.arch.regs[VCPU_REGS_R8];
 	save->r9  = svm->vcpu.arch.regs[VCPU_REGS_R9];
 	save->r10 = svm->vcpu.arch.regs[VCPU_REGS_R10];
@@ -537,6 +538,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->r13 = svm->vcpu.arch.regs[VCPU_REGS_R13];
 	save->r14 = svm->vcpu.arch.regs[VCPU_REGS_R14];
 	save->r15 = svm->vcpu.arch.regs[VCPU_REGS_R15];
+#endif
 	save->rip = svm->vcpu.arch.regs[VCPU_REGS_RIP];
 
 	/* Sync some non-GPR registers before encrypting */
-- 
2.26.2

