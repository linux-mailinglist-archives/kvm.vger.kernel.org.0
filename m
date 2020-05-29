Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716271E821F
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgE2Pkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727976AbgE2Pjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 11:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRaKAYxHqQkvZV5uE+uWY1sU9cGf+mjEUrPBdF2T4rk=;
        b=WyNamtzroKYlkwxzK4gheN73S0WppsjF+Z+tFSw4xXpJ1Zq5I610S5aeoP9BKCrAZZmFg3
        TismMZi9uuQ8zgC16lGM/MwI4Fk8I8tDJuiOIi5dzVWDsRm0WeiQQ7SMBzh++7+tWzX5Bz
        JdWYXQjCoNhs4GXXjmWbSK1LvUGrac0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-Ygr4C00DMK6a7b-Zsi7Gkg-1; Fri, 29 May 2020 11:39:49 -0400
X-MC-Unique: Ygr4C00DMK6a7b-Zsi7Gkg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FD9A835B40;
        Fri, 29 May 2020 15:39:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AAEC10013C2;
        Fri, 29 May 2020 15:39:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 24/30] KVM: nSVM: split nested_vmcb_check_controls
Date:   Fri, 29 May 2020 11:39:28 -0400
Message-Id: <20200529153934.11694-25-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The authoritative state does not come from the VMCB once in guest mode,
but KVM_SET_NESTED_STATE can still perform checks on L1's provided SVM
controls because we get them from userspace.

Therefore, split out a function to do them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 65ecc8586f75..bd3a89cd4070 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -203,26 +203,31 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vmcb *vmcb)
+static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((vmcb->save.efer & EFER_SVME) == 0)
+	if ((control->intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
-	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
-	    (vmcb->save.cr0 & X86_CR0_NW))
+	if (control->asid == 0)
 		return false;
 
-	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
+	if ((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
+	    !npt_enabled)
 		return false;
 
-	if (vmcb->control.asid == 0)
+	return true;
+}
+
+static bool nested_vmcb_checks(struct vmcb *vmcb)
+{
+	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
-	if ((vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
-	    !npt_enabled)
+	if (((vmcb->save.cr0 & X86_CR0_CD) == 0) &&
+	    (vmcb->save.cr0 & X86_CR0_NW))
 		return false;
 
-	return true;
+	return nested_vmcb_check_controls(&vmcb->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
-- 
2.26.2


