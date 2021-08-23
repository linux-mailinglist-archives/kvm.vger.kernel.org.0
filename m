Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241003F4A01
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 13:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhHWLrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 07:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236504AbhHWLrP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 07:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629719191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwNNaNhyAGeMbSYJPxgVcIB3GZONSwZOlvja76HMuBI=;
        b=MctP2XgSx0GFDClZFAnLhEyakNlGRyYOjDYJWrajSb7hWlAOpFwf0tPoOPm4gsQO/iGKLB
        bNGYX9OPXoNVJq+EsRuUu85oyMSh71BkE2dRpiXG3qEWVBUveUcTg2AKtSKb0WsXBJ2j8U
        pOsvddbYyy8I+TFSFfsg4tATPQ7edz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-v4uxGZZ_PzKnLSmdgXo5GQ-1; Mon, 23 Aug 2021 07:46:29 -0400
X-MC-Unique: v4uxGZZ_PzKnLSmdgXo5GQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 496741940922;
        Mon, 23 Aug 2021 11:46:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 594B05C261;
        Mon, 23 Aug 2021 11:46:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 1/3] KVM: nSVM: restore the L1 host state prior to resuming a nested guest on SMM exit
Date:   Mon, 23 Aug 2021 14:46:16 +0300
Message-Id: <20210823114618.1184209-2-mlevitsk@redhat.com>
In-Reply-To: <20210823114618.1184209-1-mlevitsk@redhat.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the guest is entered prior to restoring the host save area,
the guest entry code might see incorrect L1 state (e.g paging state).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..ea7a4dacd42f 100644
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
+			 */
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

