Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E55776F7
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfG0Fwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:40958 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbfG0FwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568629"
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
Subject: [RFC PATCH 17/21] KVM: VMX: Add handler for ENCLS[EINIT] to support SGX Launch Control
Date:   Fri, 26 Jul 2019 22:52:10 -0700
Message-Id: <20190727055214.9282-18-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGX Launch Control (LC) modifies the behavior of ENCLS[EINIT] to query
a set of user-controllable MSRs (Launch Enclave, a.k.a. LE, Hash MSRs)
when verifying the key used to sign an enclave.  On CPUs without LC
support, the public key hash of allowed LEs is hardwired into the CPU to
an Intel controlled key (the Intel key is also the reset value of the LE
hash MSRs).

When LC is enabled in the host, EINIT must be intercepted and executed
in the host using the guest's LE hash MSR value, even if the guest's
values are fixed to hardware default values.  The MSRs are not switched
on VM-Enter/VM-Exit as writing the MSRs is extraordinarily expensive,
e.g. each WRMSR is 4x slower than a regular WRMSR and on par with a full
VM-Enter -> VM-Exit transition.  Furthermore, as the MSRS aren't allowed
in the hardware-supported lists, i.e. would need to be manually read and
written.  On the other hand, EINIT takes tens of thousands of cycles to
execute (it's so slow that it's interruptible), i.e. the ~1k cycles of
overhead to trap-and-execute EINIT is unlikely to be noticed by the
guest, let alone impact the overall performance of SGX.

Actual usage of the handler will be added in a future patch, i.e. when
SGX virtualization is fully enabled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/sgx.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 5b08e7dcc3a3..2bcfa3b6c75e 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -221,3 +221,27 @@ int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 
 	return sgx_encls_postamble(vcpu, ret, trapnr, secs_gva);
 }
+
+int handle_encls_einit(struct kvm_vcpu *vcpu)
+{
+	unsigned long sig_hva, secs_hva, token_hva;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	gva_t sig_gva, secs_gva, token_gva;
+	int ret, trapnr;
+
+	if (sgx_get_encls_gva(vcpu, kvm_rbx_read(vcpu), 1808, 4096, &sig_gva) ||
+	    sgx_get_encls_gva(vcpu, kvm_rcx_read(vcpu), 4096, 4096, &secs_gva) ||
+	    sgx_get_encls_gva(vcpu, kvm_rdx_read(vcpu), 304, 512, &token_gva))
+		return 1;
+
+	if (sgx_gva_to_hva(vcpu, sig_gva, false, &sig_hva) ||
+	    sgx_gva_to_hva(vcpu, secs_gva, true, &secs_hva) ||
+	    sgx_gva_to_hva(vcpu, token_gva, false, &token_hva))
+		return 1;
+
+	ret = sgx_einit((void __user *)sig_hva, (void __user *)token_hva,
+			(void __user *)secs_hva, vmx->msr_ia32_sgxlepubkeyhash,
+			&trapnr);
+
+	return sgx_encls_postamble(vcpu, ret, trapnr, secs_hva);
+}
-- 
2.22.0

