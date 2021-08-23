Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89553F4A04
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 13:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhHWLrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 07:47:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235525AbhHWLrS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 07:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629719195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=suf40v/LjQI9QDufi2KT5VjbwdfG3GBD/X17TzzezQI=;
        b=TbmCIWjk+xWtdBsqzkCskzLhm4WaN8nLK7EwIy/XXLzbK+70tqR33tsHDBMw96P0XesFB1
        7VDnsdCoYC3XMGUWjSbUrTii/9ztA2eBC5tQVQNZNrdm7wkVlTvim1nqKiL0AuEdB/2C5n
        i/lnFb5g1UpboimNge3NbAuaizQ8A2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-Cz210ctwOBG99qyR64NGuw-1; Mon, 23 Aug 2021 07:46:34 -0400
X-MC-Unique: Cz210ctwOBG99qyR64NGuw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A4C1008062;
        Mon, 23 Aug 2021 11:46:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACBEC5F707;
        Mon, 23 Aug 2021 11:46:28 +0000 (UTC)
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
Subject: [PATCH v2 2/3] KVM: x86: force PDPTRs reload on SMM exit
Date:   Mon, 23 Aug 2021 14:46:17 +0300
Message-Id: <20210823114618.1184209-3-mlevitsk@redhat.com>
In-Reply-To: <20210823114618.1184209-1-mlevitsk@redhat.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_REQ_GET_NESTED_STATE_PAGES is also used with VM entries that happen
on exit from SMM mode, and in this case PDPTRS must be always reloaded.

Thanks to Sean Christopherson for pointing this out.

Fixes: 0f85722341b0 ("KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..4194fbf5e5d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7504,6 +7504,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	}
 
 	if (vmx->nested.smm.guest_mode) {
+
+		/* Exit from the SMM to the non root mode also uses
+		 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
+		 * but in this case the pdptrs must be always reloaded
+		 */
+		vcpu->arch.pdptrs_from_userspace = false;
+
 		ret = nested_vmx_enter_non_root_mode(vcpu, false);
 		if (ret)
 			return ret;
-- 
2.26.3

