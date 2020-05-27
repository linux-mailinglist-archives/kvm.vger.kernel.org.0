Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029D61E4526
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgE0OEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 10:04:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730258AbgE0OEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 10:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590588280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LoMxv8kbrQ7HIAUcS1Qgahod+d8JOwkdyw5s7rWVktc=;
        b=TlyRv+7fD16zpHxZezzCBJowxVL0lQuNe2jKaQE7Uk+fLt5NE1T2FAb1ofcuXZ5FT77IbI
        2cvNBO4LKpCYz3GyRrejUciRCwsYYK0ZkWUBIKczf5QlVAADSyqOhGkto4rDAytiPZdyn/
        V03kJM2nnwCX8PPmRS3iT5I0k+7lNZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-G9Dv8E5LO6mDJTCtZeQgzQ-1; Wed, 27 May 2020 10:04:38 -0400
X-MC-Unique: G9Dv8E5LO6mDJTCtZeQgzQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E203519057A1;
        Wed, 27 May 2020 14:04:36 +0000 (UTC)
Received: from starship.f32vm (unknown [10.35.206.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D21471C946;
        Wed, 27 May 2020 14:04:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>, Tao Xu <tao3.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH v3 1/2] KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities
Date:   Wed, 27 May 2020 17:04:24 +0300
Message-Id: <20200527140425.3484-2-mlevitsk@redhat.com>
In-Reply-To: <20200527140425.3484-1-mlevitsk@redhat.com>
References: <20200527140425.3484-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even though we might not allow the guest to use WAITPKG's new instructions,
we should tell KVM that the feature is supported by the host CPU.

Note that vmx_waitpkg_supported checks that WAITPKG _can_ be set in the
secondary execution controls as specified by VMX capability MSR,
rather that indicate that we actually enable it for a guest.

Fixes: e69e72faa3a07 (KVM: x86: Add support for user wait instructions)

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 55712dd86bafa..fca493d4517c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7298,6 +7298,9 @@ static __init void vmx_set_cpu_caps(void)
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+
+	if (vmx_waitpkg_supported())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
-- 
2.26.2

