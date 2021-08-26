Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE13F84E6
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbhHZJ6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:58:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240999AbhHZJ6t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 05:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629971882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r2cgBUgpmolm7LbnTk/syKg/dAHfNkNOJ25JTDIQhi8=;
        b=LXluudeUzD1S55+iMtz4kyvdx0joZL7AobgiGZ9mKXcxS3MyYcdN9sNgcm+6nBMfa3PGFP
        d8b5Tg23CxZ9AmEF3TaB1qbZbRyL7FwgqvSlFDdp2EETCR65Ss6ea9h30PpM9gBfZppv7B
        Rz7DqajqXsMhiqxTUtOtP8z6Zyiyusc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-c6JEKXq1P_Sev0YF_XpD3Q-1; Thu, 26 Aug 2021 05:58:01 -0400
X-MC-Unique: c6JEKXq1P_Sev0YF_XpD3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846AE1082925;
        Thu, 26 Aug 2021 09:57:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34D0D60877;
        Thu, 26 Aug 2021 09:57:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] KVM: VMX: avoid running vmx_handle_exit_irqoff in case of emulation
Date:   Thu, 26 Aug 2021 12:57:49 +0300
Message-Id: <20210826095750.1650467-2-mlevitsk@redhat.com>
In-Reply-To: <20210826095750.1650467-1-mlevitsk@redhat.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we are emulating an invalid guest state, we don't have a correct
exit reason, and thus we shouldn't do anything in this function.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..0c2c0d5ae873 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6382,6 +6382,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vmx->emulation_required)
+		return;
+
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-- 
2.26.3

