Return-Path: <kvm+bounces-43201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8083A871EF
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 14:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A973017057B
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 12:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E131ACEDF;
	Sun, 13 Apr 2025 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="JMxs2YZz"
X-Original-To: kvm@vger.kernel.org
Received: from forward203a.mail.yandex.net (forward203a.mail.yandex.net [178.154.239.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD341188CB1;
	Sun, 13 Apr 2025 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744545970; cv=none; b=PDevbUT6Wepfo5Dz6lb9zhg354ztn6LxlWrbXCKrQ/z1ylQPvKC/+GTiTu8qAtttTLIStDgzOy/Kh+dSpOvjvIvnpERf3dJS5c47vfvUZ4aZqIo1Q6mxdZjJHjWncYnknWhVzOy2iXH1pnwNt7JVE5O2WoRlWnMLw+2kjoVOuZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744545970; c=relaxed/simple;
	bh=u8PsHxYe+9KzQH5gysD3d12LwzebU7kL6mpp/V6CGG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R9B221al9q95RUGfMRwR/Cva/UtOY55NPnY+lsOph3sPvv0QSVnrsQBsaqAXYkF6fkj/ehPepKNrmXPuxQf8a4MKWUO+KEE2EGZx8oreKigQB2Z/gecRrBrX77yt+JAsxAGZa7Qwm0TU5dd9P3agx81ljLxAQeTETGmA1xunzxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=JMxs2YZz; arc=none smtp.client-ip=178.154.239.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward203a.mail.yandex.net (Yandex) with ESMTPS id 05CA9633FB;
	Sun, 13 Apr 2025 14:58:02 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1d:5b1c:0:640:ee42:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id 9B35246CD6;
	Sun, 13 Apr 2025 14:57:53 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ovD0tuQLiqM0-ZoqV47jK;
	Sun, 13 Apr 2025 14:57:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1744545472; bh=smL9B/mF681y0YybnUJX7iCKktwM5bsed7obNcAJQGg=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=JMxs2YZz/9wfsNp9/jxHMikrH0gZx2sbSYeNIGryALsD04r6e3204apT4298+8nEJ
	 e711a5WRG517HW5Ailr7GyDZVzPEbxm53kP4OzZeCjak3JJtKzWdyyVvDXtA+SAOEo
	 4HTqVBfxdsjPDTKtdytoSwHWj8G4gjUHW5r71iEA=
Authentication-Results: mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
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
Subject: [PATCH v2] KVM: SVM: forcibly leave SMM mode on vCPU reset
Date: Sun, 13 Apr 2025 14:57:27 +0300
Message-ID: <20250413115729.64712-1-m.lobanov@rosa.ru>
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

 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5d0c5c3300b..34a002a87c28 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2231,6 +2231,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	 */
 	if (!sev_es_guest(vcpu->kvm)) {
 		clear_page(svm->vmcb);
+		if (is_smm(vcpu))
+			kvm_smm_changed(vcpu, false);
 		kvm_vcpu_reset(vcpu, true);
 	}
 
-- 
2.47.2


