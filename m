Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A79633F57E
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 17:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhCQQ3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 12:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232348AbhCQQ3g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 12:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615998576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ec77b3T6zhXo/PBg8ex/iLP72N94UqDgNwEoG/Vb6t8=;
        b=DqO4PpVzp42TlZ4IPAicNaT/VxcNiaEMvT6Are+TUUzejoQPfhKG2xOl9tVJ/sBTXTwlPA
        5oH8jD1XI08YsmucwpJltdexU5vozXvzlsS0hSnJEDN8zuotntWnRYiBgAMIU+EQZgpbeZ
        MuimchvWrsbKAHFL4NUFl2wAKNGd7mY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-nxFpyJPkO1eddoAvyEObOw-1; Wed, 17 Mar 2021 12:29:32 -0400
X-MC-Unique: nxFpyJPkO1eddoAvyEObOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 505EA107B7CC;
        Wed, 17 Mar 2021 16:29:31 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CACA607CB;
        Wed, 17 Mar 2021 16:29:30 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, seanjc@google.com
Subject: [PATCH] KVM: nSVM: Additions to optimizing L12 to L2 vmcb.save copies
Date:   Wed, 17 Mar 2021 12:29:30 -0400
Message-Id: <20210317162930.28135-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend using the vmcb12 control clean field to determine which
vmcb12.save registers were marked dirty in order to minimize
register copies by including the CR bit.

This patch also fixes the init of last_vmcb12_gpa by using an invalid
physical address instead of 0.

Tested:
kvm-unit-tests
kvm selftests
Fedora L1 L2

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 9 ++++++---
 arch/x86/kvm/svm/svm.c    | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8523f60adb92..6f9a40e002bc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -449,9 +449,12 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
-	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
-	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+
+	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_CR))) {
+		svm_set_efer(&svm->vcpu, vmcb12->save.efer);
+		svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
+		svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+	}
 
 	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..41f5cd1009ca 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1234,7 +1234,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = 0;
-	svm->nested.last_vmcb12_gpa = 0;
+	svm->nested.last_vmcb12_gpa = -1;
 	vcpu->arch.hflags = 0;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
-- 
2.26.2

