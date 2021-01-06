Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EF02EBCD6
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbhAFKyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:54:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbhAFKyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7De1ngoOgky9O4PV2XjGG95Ljxiw6Nzdpvpp/JwdNqE=;
        b=WAt77w25E3MrmxJ/whsBabrzm45HbnnQI+Y+7lTdMuiNWbaWDfHcOe7jyVOwrTzMDFyxlG
        LgDTU2dieYEAjRZyPAZvm5kiHvzEJvDES1t8cXQ8L4HHcAMAlXX5AgxmFC+GVH3mqy5PRc
        bqLAdLSdbeSWTiYDg2MmlALG62eVKmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-4upRnGpaNLq2e2x1HbL4mw-1; Wed, 06 Jan 2021 05:53:23 -0500
X-MC-Unique: 4upRnGpaNLq2e2x1HbL4mw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 596E4107ACE3;
        Wed,  6 Jan 2021 10:53:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9269D5B4A9;
        Wed,  6 Jan 2021 10:53:16 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] KVM: nVMX: fix for disappearing L1->L2 event injection on L1 migration
Date:   Wed,  6 Jan 2021 12:53:06 +0200
Message-Id: <20210106105306.450602-3-mlevitsk@redhat.com>
In-Reply-To: <20210106105306.450602-1-mlevitsk@redhat.com>
References: <20210106105306.450602-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If migration happens while L2 entry with an injected event to L2 is pending,
we weren't including the event in the migration state and it would be
lost leading to L2 hang.

Fix this by queueing the injected event in similar manner to how we queue
interrupted injections.

This can be reproduced by running an IO intense task in L2,
and repeatedly migrating the L1.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e2f26564a12de..2ea0bb14f385f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2355,12 +2355,12 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * Interrupt/Exception Fields
 	 */
 	if (vmx->nested.nested_run_pending) {
-		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-			     vmcs12->vm_entry_intr_info_field);
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
-			     vmcs12->vm_entry_exception_error_code);
-		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
-			     vmcs12->vm_entry_instruction_len);
+		if ((vmcs12->vm_entry_intr_info_field & VECTORING_INFO_VALID_MASK))
+			vmx_process_injected_event(&vmx->vcpu,
+						   vmcs12->vm_entry_intr_info_field,
+						   vmcs12->vm_entry_instruction_len,
+						   vmcs12->vm_entry_exception_error_code);
+
 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
 			     vmcs12->guest_interruptibility_info);
 		vmx->loaded_vmcs->nmi_known_unmasked =
-- 
2.26.2

