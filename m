Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632233FB68B
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbhH3M4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236775AbhH3M4p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630328151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyWUfShEEXIAdxHlx1+TduYWMabCnlql89pOYGzRwI4=;
        b=F17HwOUKrJ0Zl6QwNyf+KB3JQzavFoaPkWFIXu8ybXao0Zt99RPM9WBJzzYGkSYQiRxS25
        cuVO52hYvwaXlfOUFIxr2p+NKVcUlNLpbqgBU3chol7Z85zRDiRPTk2/iRkAQKuzz822h4
        gPOviZj7OF1dY38yqW8I4cGL9EulzXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478--lHB7gybNByPVW9MF-ENjw-1; Mon, 30 Aug 2021 08:55:49 -0400
X-MC-Unique: -lHB7gybNByPVW9MF-ENjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CE2F10055B9;
        Mon, 30 Aug 2021 12:55:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C947560939;
        Mon, 30 Aug 2021 12:55:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 1/6] KVM: SVM: restore the L1 host state prior to resuming nested guest on SMM exit
Date:   Mon, 30 Aug 2021 15:55:34 +0300
Message-Id: <20210830125539.1768833-2-mlevitsk@redhat.com>
In-Reply-To: <20210830125539.1768833-1-mlevitsk@redhat.com>
References: <20210830125539.1768833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Otherwise guest entry code might see incorrect L1 state (e.g paging state).

Fixes: 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from SMM")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..4aa269a587d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4347,27 +4347,30 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
-			if (svm_allocate_nested(svm))
+			if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
+					 &map_save) == -EINVAL)
 				return 1;
 
-			vmcb12 = map.hva;
-
-			nested_load_control_from_vmcb12(svm, &vmcb12->control);
-
-			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
-			kvm_vcpu_unmap(vcpu, &map, true);
+			if (svm_allocate_nested(svm))
+				return 1;
 
 			/*
 			 * Restore L1 host state from L1 HSAVE area as VMCB01 was
 			 * used during SMM (see svm_enter_smm())
 			 */
-			if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
-					 &map_save) == -EINVAL)
-				return 1;
 
 			svm_copy_vmrun_state(&svm->vmcb01.ptr->save,
 					     map_save.hva + 0x400);
 
+			/*
+			 * Restore L2 state
+			 * */
+
+			vmcb12 = map.hva;
+			nested_load_control_from_vmcb12(svm, &vmcb12->control);
+			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
+
+			kvm_vcpu_unmap(vcpu, &map, true);
 			kvm_vcpu_unmap(vcpu, &map_save, true);
 		}
 	}
-- 
2.26.3

