Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50F7474557
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhLNOja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:39:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234990AbhLNOj1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 09:39:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639492767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2rStoPL6fQLx4oCsX+/VBOg86v69CREOj9Z7qxiEeY0=;
        b=BWZ5NAh8SxJrOXuslxXOLSZsvmPj7xY5wzFrCaRcuv2uFZ0RAPVnsE4ktBt6ecrD88vHiK
        don3QqtQe1MXCpMRDx48fqD4Jy79cu/ke0e0DEw7lvWDDCzS4rMFtk1p1Qz8SHR9/Ly+RN
        EIbYx6zINBFO1hWlKFqA7qlqMQWVt4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-W7EiWiWzOfW-CFqXGqaAPQ-1; Tue, 14 Dec 2021 09:39:21 -0500
X-MC-Unique: W7EiWiWzOfW-CFqXGqaAPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AF778189D5;
        Tue, 14 Dec 2021 14:39:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98C7478C30;
        Tue, 14 Dec 2021 14:39:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use
Date:   Tue, 14 Dec 2021 15:38:59 +0100
Message-Id: <20211214143859.111602-6-vkuznets@redhat.com>
In-Reply-To: <20211214143859.111602-1-vkuznets@redhat.com>
References: <20211214143859.111602-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V TLFS explicitly forbids VMREAD and VMWRITE instructions when
Enlightened VMCS interface is in use:

"Any VMREAD or VMWRITE instructions while an enlightened VMCS is
active is unsupported and can result in unexpected behavior.""

Windows 11 + WSL2 seems to ignore this, attempts to VMREAD VMCS field
0x4404 ("VM-exit interruption information") are observed. Failing
these attempts with nested_vmx_failInvalid() makes such guests
unbootable.

Microsoft confirms this is a Hyper-V bug and claims that it'll get fixed
eventually but for the time being we need a workaround. (Temporary) allow
VMREAD to get data from the currently loaded Enlightened VMCS.

Note: VMWRITE instructions remain forbidden, it is not clear how to
handle them properly and hopefully won't ever be needed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.h  | 12 ++++++++++++
 arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 9bc2521b159e..8d70f9aea94b 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -98,6 +98,18 @@ static __always_inline int evmcs_field_offset(unsigned long field,
 	return evmcs_field->offset;
 }
 
+static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
+				 unsigned long field, u16 offset)
+{
+	/*
+	 * vmcs12_read_any() doesn't care whether the supplied structure
+	 * is 'struct vmcs12' or 'struct hv_enlightened_vmcs' as it takes
+	 * the exact offset of the required field, use it for convenience
+	 * here.
+	 */
+	return vmcs12_read_any((void *)evmcs, field, offset);
+}
+
 #if IS_ENABLED(CONFIG_HYPERV)
 
 static __always_inline int get_evmcs_offset(unsigned long field,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0b990a6914c1..27fedb220a23 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7,6 +7,7 @@
 #include <asm/mmu_context.h>
 
 #include "cpuid.h"
+#include "evmcs.h"
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
@@ -5074,27 +5075,44 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
+	/* Normal or Enlightened VMPTRLD must be performed first */
+	if (vmx->nested.current_vmptr == INVALID_GPA &&
+	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+		return nested_vmx_failInvalid(vcpu);
+
 	/*
 	 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
 	 * any VMREAD sets the ALU flags for VMfailInvalid.
 	 */
-	if (vmx->nested.current_vmptr == INVALID_GPA ||
-	    (is_guest_mode(vcpu) &&
-	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
+	if (is_guest_mode(vcpu) &&
+	    get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA)
 		return nested_vmx_failInvalid(vcpu);
 
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	offset = vmcs12_field_offset(field);
-	if (offset < 0)
-		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+	/*
+	 * Inside guest mode, Enlightened VMCS is not the ultimate source of
+	 * truth, shadow VMCS12/VMCS02 are.
+	 */
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) && !is_guest_mode(vcpu)) {
+		offset = evmcs_field_offset(field, NULL);
+		if (offset < 0)
+			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
-	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
-		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+		/* Read the field, zero-extended to a u64 value */
+		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+	} else {
+		offset = vmcs12_field_offset(field);
+		if (offset < 0)
+			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
-	/* Read the field, zero-extended to a u64 value */
-	value = vmcs12_read_any(vmcs12, field, offset);
+		if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
+			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+
+		/* Read the field, zero-extended to a u64 value */
+		value = vmcs12_read_any(vmcs12, field, offset);
+	}
 
 	/*
 	 * Now copy part of this value to register or memory, as requested.
-- 
2.33.1

