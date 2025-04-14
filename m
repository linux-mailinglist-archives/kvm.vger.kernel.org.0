Return-Path: <kvm+bounces-43260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A0EA88997
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F2CB7A6465
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F13E289364;
	Mon, 14 Apr 2025 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="mC0xs/5P"
X-Original-To: kvm@vger.kernel.org
Received: from forward205b.mail.yandex.net (forward205b.mail.yandex.net [178.154.239.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31028469A;
	Mon, 14 Apr 2025 17:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744651139; cv=none; b=O53JQ5wbdjhFAy0aNK7Lf6+5jcPx6hLoSWgx7Pfn6e27G3zO2rfWT55jGCStvn/9Z+k6nVW5IgG+GzBGvkVxBn1OL1OlwWCvF2FdWGE5dUWvlgVS8ZeB2QtrPOIBBU5HA3yK1OmfMc5/ZldfwEA1fR5ND1R0BV7CuLpHuh1sV/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744651139; c=relaxed/simple;
	bh=G77ROff31km5oic0MrLl+7V+X9eKW5/vOe5Aa4RAjlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LEDfuewna9zvZstqmaXBHNw/HLrPX7YyPH+GX8+NoBWKilldbWBg+WXwuFeSeNMwkv11xAE1ZgoekwVUP9UMMv+RkZ/8+ro3XF2YIDP6mtZShuW8E+6SSkzlGt3XuWCJ6wgD4t1Zf1rHWKS0rJ9ORz3Lt3yhgpDW8G1SccsIGWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=mC0xs/5P; arc=none smtp.client-ip=178.154.239.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d102])
	by forward205b.mail.yandex.net (Yandex) with ESMTPS id 1DE766522C;
	Mon, 14 Apr 2025 20:12:38 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-63.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-63.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:3fa3:0:640:b228:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id A739C609D3;
	Mon, 14 Apr 2025 20:12:29 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-63.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id PCKvQd1LmW20-QSrumStn;
	Mon, 14 Apr 2025 20:12:28 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1744650748; bh=wFx6lLFV+QupO4M4+wLGufqzKiqBmpx6VWXYCXbP+dU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=mC0xs/5PO+JAudJ+Yfo9WY73Caa8C77wLAUOratA0i1DxX58kUOHYB08BT86W/8rZ
	 b7Ze9gTt3vwiUaatGbBJEpqutn8ETFPW1/SdRvqgKgS2f3mYtrwLDstFoDcZc266mB
	 aOTD0DM6Pn8wLoZfUImzgUo2kaBN7i22r5JeJ0Tg=
Authentication-Results: mail-nwsmtp-smtp-production-main-63.sas.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
From: Mikhail Lobanov <m.lobanov@rosa.ru>
To: Sean Christopherson <seanjc@google.com>
Cc: Mikhail Lobanov <m.lobanov@rosa.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH v3] KVM: SVM: forcibly leave SMM mode on vCPU reset
Date: Mon, 14 Apr 2025 20:12:06 +0300
Message-ID: <20250414171207.155121-1-m.lobanov@rosa.ru>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, commit ed129ec9057f ("KVM: x86: forcibly leave nested mode
on vCPU reset") addressed an issue where a triple fault occurring in
nested mode could lead to use-after-free scenarios. However, the commit
did not handle the analogous situation for System Management Mode (SMM).

This omission results in triggering a WARN when a vCPU reset occurs
while still in SMM mode, due to the check in kvm_vcpu_reset(). This
situation was reprodused using Syzkaller by:
1) Creating a KVM VM and vCPU
2) Sending a KVM_SMI ioctl to explicitly enter SMM
3) Executing invalid instructions causing consecutive exceptions and
eventually a triple fault

The issue manifests as follows:

WARNING: CPU: 0 PID: 25506 at arch/x86/kvm/x86.c:12112
kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
Modules linked in:
CPU: 0 PID: 25506 Comm: syz-executor.0 Not tainted
6.1.130-syzkaller-00157-g164fe5dde9b6 #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
RIP: 0010:kvm_vcpu_reset+0x1d2/0x1530 arch/x86/kvm/x86.c:12112
Call Trace:
 <TASK>
 shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2136
 svm_invoke_exit_handler+0x110/0x530 arch/x86/kvm/svm/svm.c:3395
 svm_handle_exit+0x424/0x920 arch/x86/kvm/svm/svm.c:3457
 vcpu_enter_guest arch/x86/kvm/x86.c:10959 [inline]
 vcpu_run+0x2c43/0x5a90 arch/x86/kvm/x86.c:11062
 kvm_arch_vcpu_ioctl_run+0x50f/0x1cf0 arch/x86/kvm/x86.c:11283
 kvm_vcpu_ioctl+0x570/0xf00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4122
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x19a/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Architecturally, hardware CPUs exit SMM upon receiving a triple
fault as part of a hardware reset. To reflect this behavior and
avoid triggering the WARN, this patch explicitly calls
kvm_smm_changed(vcpu, false) in the SVM-specific shutdown_interception()
handler prior to resetting the vCPU.

The initial version of this patch attempted to address the issue by calling
kvm_smm_changed() inside kvm_vcpu_reset(). However, this approach was not
architecturally accurate, as INIT is blocked during SMM and SMM should not
be exited implicitly during a generic vCPU reset. This version moves the
fix into shutdown_interception() for SVM, where the triple fault is
actually handled, and where exiting SMM explicitly is appropriate.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
---
v2: Move SMM exit from kvm_vcpu_reset() to SVM's shutdown_interception(), 
per suggestion from Sean Christopherson <seanjc@google.com>.
v3: -Export kvm_smm_changed() using EXPORT_SYMBOL_GPL.
-Wrap the call to kvm_smm_changed() in svm.c with #ifdef CONFIG_KVM_SMM 
to avoid build errors when SMM support is disabled.

 arch/x86/kvm/smm.c     | 1 +
 arch/x86/kvm/svm/svm.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 699e551ec93b..9864c057187d 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -131,6 +131,7 @@ void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 	kvm_mmu_reset_context(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_smm_changed);
 
 void process_smi(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5d0c5c3300b..c5470d842aed 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2231,6 +2231,10 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	 */
 	if (!sev_es_guest(vcpu->kvm)) {
 		clear_page(svm->vmcb);
+#ifdef CONFIG_KVM_SMM
+		if (is_smm(vcpu))
+			kvm_smm_changed(vcpu, false);
+#endif
 		kvm_vcpu_reset(vcpu, true);
 	}
 
-- 
2.47.2


