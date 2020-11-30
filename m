Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897932C85AC
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 14:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgK3Nh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 08:37:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727153AbgK3Nhz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 08:37:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606743388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hk5OFvWNHbg5hVN0Ht1zaSz7OJS2S2+j4P4NifxDXl0=;
        b=Nk6odFw5Ph0u2vSl+RfASZgsV2wEv/bKzEywqpndLn+wXkF3JXDojTnbVlrkLO6SgX1mVs
        YVUEYFj8LI+QDreLm/sbvurgeY8hb0fVepCqooc9VSAyuufUFU9m82lT3LmyIm3lfYaE44
        qjfHgybgsiY6wOVymkKEjH144tDd/lw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-Fc7cNOVpOU2PP00_SseBIg-1; Mon, 30 Nov 2020 08:36:26 -0500
X-MC-Unique: Fc7cNOVpOU2PP00_SseBIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA8F48144E5;
        Mon, 30 Nov 2020 13:36:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B84C060C62;
        Mon, 30 Nov 2020 13:36:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list),
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/2] KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS
Date:   Mon, 30 Nov 2020 15:35:59 +0200
Message-Id: <20201130133559.233242-3-mlevitsk@redhat.com>
In-Reply-To: <20201130133559.233242-1-mlevitsk@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This quirk reflects the fact that we currently treat MSR_IA32_TSC
and MSR_TSC_ADJUST access by the host (e.g qemu) in a way that is different
compared to an access from the guest.

For host's MSR_IA32_TSC read we currently always return L1 TSC value, and for
host's write we do the tsc synchronization.

For host's MSR_TSC_ADJUST write, we don't make the tsc 'jump' as we should
for this msr.

When the hypervisor uses the new TSC GET/SET state ioctls, all of this is no
longer needed, thus leave this enabled only with a quirk
which the hypervisor can disable.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/x86.c              | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 8e76d3701db3f..2a60fc6674164 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -404,6 +404,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
+#define KVM_X86_QUIRK_TSC_HOST_ACCESS      (1 << 5)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f0ae9cb14b8a..46a2111d54840 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3091,7 +3091,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC_ADJUST:
 		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
-			if (!msr_info->host_initiated) {
+			if (!msr_info->host_initiated ||
+			    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS)) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
 			}
@@ -3118,7 +3119,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_ia32_power_ctl = data;
 		break;
 	case MSR_IA32_TSC:
-		if (msr_info->host_initiated) {
+		if (msr_info->host_initiated &&
+		    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS)) {
 			kvm_synchronize_tsc(vcpu, data);
 		} else {
 			u64 adj = kvm_compute_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
@@ -3409,17 +3411,24 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
 		break;
 	case MSR_IA32_TSC: {
+		u64 tsc_offset;
+
 		/*
 		 * Intel SDM states that MSR_IA32_TSC read adds the TSC offset
 		 * even when not intercepted. AMD manual doesn't explicitly
 		 * state this but appears to behave the same.
 		 *
-		 * On userspace reads and writes, however, we unconditionally
+		 * On userspace reads and writes, when KVM_X86_QUIRK_SPECIAL_TSC_READ
+		 * is present, however, we unconditionally
 		 * return L1's TSC value to ensure backwards-compatible
 		 * behavior for migration.
 		 */
-		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
-							    vcpu->arch.tsc_offset;
+
+		if (msr_info->host_initiated &&
+		    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS))
+			tsc_offset = vcpu->arch.l1_tsc_offset;
+		else
+			tsc_offset = vcpu->arch.tsc_offset;
 
 		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
 		break;
-- 
2.26.2

