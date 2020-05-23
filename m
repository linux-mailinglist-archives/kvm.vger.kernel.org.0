Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F971DF829
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 18:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgEWQPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 12:15:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47355 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728025AbgEWQPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 12:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590250521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ytf9W2kex3b56H4BEKOUukloGENtrEZz4KuH9AmMNpQ=;
        b=g+cyEwquQ4ytNWuON3C3BagDVPR1LyAEYlnBJBg5tR8fo9+8F69pmhuu6BiaH4Im7RIW6c
        mXgpwhfYeWkaJRLzK4QVuoqPiSeMC6w49sQBszRTYtWI2LNAH3SlXi/tdHMSYoy9YPSZlB
        uop49GSr00Kuwl3njyfgPsdBZJbfp9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-3rESmGjfPumnQqjegbACfQ-1; Sat, 23 May 2020 12:15:17 -0400
X-MC-Unique: 3rESmGjfPumnQqjegbACfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EBCF107ACCA;
        Sat, 23 May 2020 16:15:15 +0000 (UTC)
Received: from starship.f32vm (unknown [10.35.206.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DD6B600E5;
        Sat, 23 May 2020 16:15:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM capabilities
Date:   Sat, 23 May 2020 19:14:54 +0300
Message-Id: <20200523161455.3940-2-mlevitsk@redhat.com>
In-Reply-To: <20200523161455.3940-1-mlevitsk@redhat.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even though we might not allow the guest to use
WAITPKG's new instructions, we should tell KVM
that the feature is supported by the host CPU.

Note that vmx_waitpkg_supported checks that WAITPKG
_can_ be set in secondary execution controls as specified
by VMX capability MSR, rather that we actually enable it for a guest.

Fixes: e69e72faa3a0 KVM: x86: Add support for user wait instructions

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
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

