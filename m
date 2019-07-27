Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761F0776FB
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfG0FxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbfG0FwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568632"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 18/21] KVM: x86: Invoke kvm_x86_ops->cpuid_update() after kvm_update_cpuid()
Date:   Fri, 26 Jul 2019 22:52:11 -0700
Message-Id: <20190727055214.9282-19-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX's virtualization of SGX adds a lovely dependency on the guest's
supported xcr0, which is calculated in kvm_update_cpuid().  VMX must
toggled its interception of SGX instructions based on the supported
xcr0, i.e. kvm_x86_ops->cpuid_update() is certainly the correct
location for the dependent code.

kvm_update_cpuid() was originally added by commit 2acf923e38fb ("KVM:
VMX: Enable XSAVE/XRSTOR for guest").  There is no indication that its
placement after kvm_x86_ops->cpuid_update() was anything more than a
"new function at the end" decision.

Inspection of the current code reveals no dependency on kvm_x86_ops's
cpuid_update() in kvm_update_cpuid() or any of its helpers.

  - SVM's sole update is to conditionally clear X86_FEATURE_X2APIC.
    X86_FEATURE_X2APIC is only consumed by kvm_apic_set_state(), which
    is already called immediately prior to kvm_x86_ops->cpuid_update().

  - VMX updates only nested VMX MSRs, allowed FEATURE_CONTROL bits,
    and VMCS fields, e.g. secondary execution controls, none of which
    should bleed back into kvm_update_cpuid() barring an egregious
    dependency bug somewhere else.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 70e488951f25..4c235af5318c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -222,8 +222,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	cpuid_fix_nx_cap(vcpu);
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops->cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (!r)
+		kvm_x86_ops->cpuid_update(vcpu);
 
 out:
 	vfree(cpuid_entries);
@@ -245,8 +246,9 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops->cpuid_update(vcpu);
 	r = kvm_update_cpuid(vcpu);
+	if (!r)
+		kvm_x86_ops->cpuid_update(vcpu);
 out:
 	return r;
 }
-- 
2.22.0

