Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150D534CE7
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfFDQJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbfFDQJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:09:51 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C99DFC0624A1;
        Tue,  4 Jun 2019 16:09:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00EF65D9D2;
        Tue,  4 Jun 2019 16:09:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
Subject: [PATCH] KVM/nSVM: properly map nested VMCB
Date:   Tue,  4 Jun 2019 18:09:39 +0200
Message-Id: <20190604160939.17031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 04 Jun 2019 16:09:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest
memory") broke nested SVM completely: kvm_vcpu_map()'s second parameter is
GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the other way
around.

Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 735b8c01895e..5beca1030c9a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3293,7 +3293,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(svm->nested.vmcb), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
@@ -3583,7 +3583,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	vmcb_gpa = svm->vmcb->save.rax;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(vmcb_gpa), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
-- 
2.20.1

