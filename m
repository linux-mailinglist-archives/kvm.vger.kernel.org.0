Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCF83D651A
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhGZQUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:20:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238593AbhGZQSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 12:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627318726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=avwuTKw/R829e7k0vzWCG0fx07vpyZttwZixO5lwurs=;
        b=ehzOE4isAw/Z+XdIpA2Ac5JF2hVgx5mHo+jdp/jbKGoU3TBr+8ru9SOXAfclunKrLDT7Rw
        lno/uiPfMh02ECyCQIFT2rVXyq6RBj/DBdYCtgQWCc1CYQMuMK+5AWJ5yifdwnxMRNvQ07
        xWEYzvgiyB3gglY2SYPVbCzt15VWps0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-HQ3WDlM6NquN3y4fQWnQ_w-1; Mon, 26 Jul 2021 12:58:45 -0400
X-MC-Unique: HQ3WDlM6NquN3y4fQWnQ_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D3731934100;
        Mon, 26 Jul 2021 16:58:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDF335D9D3;
        Mon, 26 Jul 2021 16:58:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>
Subject: [PATCH] KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is initialized
Date:   Mon, 26 Jul 2021 12:58:43 -0400
Message-Id: <20210726165843.1441132-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, svm_hv_vmcb_dirty_nested_enlightenments has an incorrect
dereference of vmcb->control.reserved_sw before the vmcb is checked
for being non-NULL.  The compiler is usually sinking the dereference
after the check; instead of doing this ourselves in the source,
ensure that svm_hv_vmcb_dirty_nested_enlightenments is only called
with a non-NULL VMCB.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vineeth Pillai <viremana@linux.microsoft.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[Untested for now due to issues with my AMD machine. - Paolo]
---
 arch/x86/kvm/svm/svm.c          | 4 ++--
 arch/x86/kvm/svm/svm_onhyperv.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a6987549e1b..4bcb95bb8ed7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1406,8 +1406,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		goto error_free_vmsa_page;
 	}
 
-	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
-
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 
@@ -1419,6 +1417,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm_switch_vmcb(svm, &svm->vmcb01);
 	init_vmcb(vcpu);
 
+	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
+
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 9b9a55abc29f..c53b8bf8d013 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -89,7 +89,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 	 * as we mark it dirty unconditionally towards end of vcpu
 	 * init phase.
 	 */
-	if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
+	if (vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
 	    hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
 }
-- 
2.27.0

