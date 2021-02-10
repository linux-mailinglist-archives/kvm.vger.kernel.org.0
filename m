Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D091316AA3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 17:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhBJQBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 11:01:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhBJQBP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 11:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612972789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0AECEEP9Q9Mf6W1DX+0jc2j059G15vKX1mqct6nue10=;
        b=fTeeJx4Rm/pCD20uocWaZ2oztNTj48dIJIayqd37v/f7EbPJvtMDCcsagKxNJsDHOstpiX
        s74n2SPgRwnXq2O0ih7hHY1wj+mWntr4q/OKKnB9PCjyjhuDLqrNGX7JkJip+Iul3LWfI3
        ESlk9XiXi2DkHaW5xDu3tnUpNOieVUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-JAjOZPrnO--7NHIX2kVBBw-1; Wed, 10 Feb 2021 10:59:45 -0500
X-MC-Unique: JAjOZPrnO--7NHIX2kVBBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 196721846097;
        Wed, 10 Feb 2021 15:59:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1764F5D6DC;
        Wed, 10 Feb 2021 15:59:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: nSVM: call nested_svm_load_cr3 on nested state load
Date:   Wed, 10 Feb 2021 17:59:37 +0200
Message-Id: <20210210155937.141569-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While KVM's MMU should be fully reset by loading of nested CR0/CR3/CR4
by KVM_SET_SREGS, we are not in nested mode yet when we do it and therefore
only root_mmu is reset.

On regular nested entries we call nested_svm_load_cr3 which both updates the
guest's CR3 in the MMU when it is needed, and it also initializes
the mmu again which makes it initialize the walk_mmu as well when nested
paging is enabled in both host and guest.

Since we don't call nested_svm_load_cr3 on nested state load,
the walk_mmu can be left uninitialized, which can lead to a NULL pointer
dereference while accessing it if we happen to get a nested page fault
right after entering the nested guest first time after the migration and
we decide to emulate it, which leads to emulator trying to access
walk_mmu->gva_to_gpa which is NULL.

Therefore we should call this function on nested state load as well.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 519fe84f2100..c209f1232928 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1282,6 +1282,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	nested_vmcb02_prepare_control(svm);
 
+	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+				  nested_npt_enabled(svm));
+
+	if (ret) {
+		svm_leave_nested(svm);
+		goto out_free;
+	}
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:
-- 
2.26.2

