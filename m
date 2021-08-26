Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60B3F84E8
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbhHZJ6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 05:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241190AbhHZJ6x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 05:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629971886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6YB0Y9PXN8/DSQdHJ6mRhz11Ijve9k4iHJzE0FjFaRE=;
        b=Bznc4MOwCczKOmGOBQpJw4iylrGxtoHa669oiPFp164K1wFbGQKWJCCJqXjGxUa6g12sPl
        mLQ62l4CxuaYZnsAUft6DxrJZJkiifUYSFGCOPL0s+r0V6wOORuNsMZUFzT82gD/pAHojR
        /QrLM0zw01T38lDfaeuiF3t0CA60Wiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-0LxItbf3MCiEHeFSynqXbA-1; Thu, 26 Aug 2021 05:58:04 -0400
X-MC-Unique: 0LxItbf3MCiEHeFSynqXbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A2F0801A92;
        Thu, 26 Aug 2021 09:58:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E465A60877;
        Thu, 26 Aug 2021 09:57:59 +0000 (UTC)
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
Subject: [PATCH 2/2] VMX: nSVM: enter protected mode prior to returning to nested guest from SMM
Date:   Thu, 26 Aug 2021 12:57:50 +0300
Message-Id: <20210826095750.1650467-3-mlevitsk@redhat.com>
In-Reply-To: <20210826095750.1650467-1-mlevitsk@redhat.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SMM return code switches CPU to real mode, and
then the nested_vmx_enter_non_root_mode first switches to vmcs02,
and then restores CR0 in the KVM register cache.

Unfortunately when it restores the CR0, this enables the protection mode
which leads us to "restore" the segment registers from
"real mode segment cache", which is not up to date vs L2 and trips
'vmx_guest_state_valid check' later, when the
unrestricted guest mode is not enabled.

This happens to work otherwise, because after we enter the nested guest,
we restore its register state again from SMRAM with correct values
and that includes the segment values.

As a workaround to this if we enter protected mode first,
then setting CR0 won't cause this damage.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..805c415494cf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7507,6 +7507,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	}
 
 	if (vmx->nested.smm.guest_mode) {
+
+		/*
+		 * Enter protected mode to avoid clobbering L2's segment
+		 * registers during nested guest entry
+		 */
+		vmx_set_cr0(vcpu, vcpu->arch.cr0 | X86_CR0_PE);
+
 		ret = nested_vmx_enter_non_root_mode(vcpu, false);
 		if (ret)
 			return ret;
-- 
2.26.3

