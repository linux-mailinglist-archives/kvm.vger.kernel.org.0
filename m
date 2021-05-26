Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A4E3918B4
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhEZNYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:24:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233628AbhEZNYN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5Oylu3yAHNX8x25OPkYHmmCVlM82yxkdUETdPHj3HI=;
        b=jPBVdxYxSy/LxOsqTV1DUoBkdOgrXMWiXbyw/hcaQpeq1H7QzjBzKZhWoGmomxPkPPrtED
        +FJdL0pt/BIfcX+dWxtrfwvNfeDHP0cpxXGmlxjTGIpB5ffOhWAQ79S3SUZtLVE32YTCf9
        euBJrolxCtDwWR/33XMbfwNm8N30R5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-bwjlUzanPMaBW-Al9v5DxA-1; Wed, 26 May 2021 09:22:40 -0400
X-MC-Unique: bwjlUzanPMaBW-Al9v5DxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2FF180364C;
        Wed, 26 May 2021 13:22:38 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C658B5D9C6;
        Wed, 26 May 2021 13:22:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/11] KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
Date:   Wed, 26 May 2021 15:20:23 +0200
Message-Id: <20210526132026.270394-9-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'need_vmcs12_to_shadow_sync' is used for both shadow and enlightened
VMCS sync when we exit to L1. The comment in nested_vmx_failValid()
validly states why shadow vmcs sync can be omitted but this doesn't
apply to enlightened VMCS as it 'shadows' all VMCS12 fields.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 93ef8e00828e..34b8e2471a5b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -173,9 +173,13 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 			| X86_EFLAGS_ZF);
 	get_vmcs12(vcpu)->vm_instruction_error = vm_instruction_error;
 	/*
-	 * We don't need to force a shadow sync because
-	 * VM_INSTRUCTION_ERROR is not shadowed
+	 * We don't need to force sync to shadow VMCS because
+	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
+	 * fields and thus must be synced.
 	 */
+	if (to_vmx(vcpu)->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
+		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
+
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-- 
2.31.1

