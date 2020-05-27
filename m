Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270681E4528
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgE0OEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 10:04:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730378AbgE0OEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 10:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590588287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vlVIr30v//g+9i0b5CXbC5CgscrkJJKNK4GDkeNGLN8=;
        b=LgQ/OqB5AP8qz5t6Tzr4V4Nr0xTTlm5j4kShL6HDmy2ujxtaMZ0XZeyiGUYcX/0arOy2oZ
        ptCt2q7R2mFo2XbH/pNXoIPCgKS+z52z60nqphdhg1JLy4TvAmZvBScy8DftSqwhN9fNL4
        F5V+jJFjtuHOcQ7mGOUN6rfVWoSpYuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-E90PUzbCNjmMj-KVuivPGQ-1; Wed, 27 May 2020 10:04:46 -0400
X-MC-Unique: E90PUzbCNjmMj-KVuivPGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58431474;
        Wed, 27 May 2020 14:04:44 +0000 (UTC)
Received: from starship.f32vm (unknown [10.35.206.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F2571A8EA;
        Wed, 27 May 2020 14:04:37 +0000 (UTC)
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
Subject: [PATCH v3 2/2] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
Date:   Wed, 27 May 2020 17:04:25 +0300
Message-Id: <20200527140425.3484-3-mlevitsk@redhat.com>
In-Reply-To: <20200527140425.3484-1-mlevitsk@redhat.com>
References: <20200527140425.3484-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This MSR is only available when the host supports WAITPKG feature.

This breaks a L2 guest, if the L0 is set to ignore the unknown MSRs,
because the only other safety check that the L1 kernel  does is an attempt
to read the MSR, and it succeeds since L0 ignores that read.

This makes L1 kernel to inform its qemu that MSR_IA32_UMWAIT_CONTROL
is a supported MSR but later on when qemu attempts to set it in the
host state this fails since it is not supported.

Fixes: 6e3ba4abcea56 (KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b226fb8abe41b..4752293312947 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5316,6 +5316,10 @@ static void kvm_init_msr_list(void)
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
+		case MSR_IA32_UMWAIT_CONTROL:
+			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.26.2

