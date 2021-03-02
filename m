Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E541132B5A2
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381996AbhCCHTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835975AbhCBTfa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fa0yryuIS4KknQc8ZC/Uv2cqGqk8gPX2VHiY6TsaQrk=;
        b=TUKbmji1lpVFyvZWESxK4/UPJSlHSvjxdsPKHIZ4rpQpQr7chNr9pJ/IAE1NxAYdp3ilov
        ilQdAde8BryqaDs91CdWe1svqJEwoNIMnbD4u/FRX5ZyUTeAxYp+EXG8MKg3lJXlWzVXuB
        Dfhe7F9fz2Vm9e3HJO+UHxlhREm8tmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-wlejCQP9MBuYp0JD7HrnuA-1; Tue, 02 Mar 2021 14:33:49 -0500
X-MC-Unique: wlejCQP9MBuYp0JD7HrnuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA444801976;
        Tue,  2 Mar 2021 19:33:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 941A960BFA;
        Tue,  2 Mar 2021 19:33:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 06/23] KVM: nSVM: do not mark all VMCB01 fields dirty on nested vmexit
Date:   Tue,  2 Mar 2021 14:33:26 -0500
Message-Id: <20210302193343.313318-7-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since L1 and L2 now use different VMCBs, most of the fields remain
the same from one L1 run to the next.  svm_set_cr0 and other functions
called by nested_svm_vmexit already take care of clearing the
corresponding clean bits; only the TSC offset is special.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f88d0614d9b8..4fc742ba1f1f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -698,8 +698,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm_set_gif(svm, false);
 	svm->vmcb->control.exit_int_info = 0;
 
-	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
-		svm->vcpu.arch.l1_tsc_offset;
+	svm->vcpu.arch.tsc_offset = svm->vcpu.arch.l1_tsc_offset;
+	if (svm->vmcb->control.tsc_offset != svm->vcpu.arch.tsc_offset) {
+		svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
+		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	}
 
 	svm->nested.ctl.nested_cr3 = 0;
 
@@ -717,8 +720,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vcpu.arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(&svm->vcpu);
 
-	vmcb_mark_all_dirty(svm->vmcb);
-
 	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
 				       vmcb12->control.exit_info_1,
 				       vmcb12->control.exit_info_2,
-- 
2.26.2


