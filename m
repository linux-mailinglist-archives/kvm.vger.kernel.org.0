Return-Path: <kvm+bounces-41855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5763CA6E1F1
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 19:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 625D7188EC54
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2307F263F54;
	Mon, 24 Mar 2025 17:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b="PBL5wDwg"
X-Original-To: kvm@vger.kernel.org
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E399450;
	Mon, 24 Mar 2025 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742839049; cv=none; b=Hxx/0ZAl7EnOUEMIpBa+lJpaBDebyw9+SLR4Khg3g211trMLrPPwPsgZzMIEjHSYrT9iiRQSKNUIREReudqj32iV0qxnqzaxKunUvI9TZ4dgawvsVt90P6UZf+Mep+X3/tPebBxdc+L1KmoKLL2NGbQarJFFqRUPu+7Ijk4uNKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742839049; c=relaxed/simple;
	bh=NWMa0LZi+vB8RiQmxqV47sxMrBDDPBMaWAHnbcE9oBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hY8XCr8Kg/6FkYJlpkM4LdoNkzIcbG5dCTzeKskURSuP20MnIOLfFC6kIZtTeQLRLDbqTtIOAuEUweC58GiJbzRB82/Mz2oN4eQ/XCXIXSmla8YyGI/attkZE7JHfRotEaNOxETD8MdINfpxh50Dw67GwYiPtvMkti/jL/kzWAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru; spf=pass smtp.mailfrom=rosa.ru; dkim=pass (1024-bit key) header.d=rosa.ru header.i=@rosa.ru header.b=PBL5wDwg; arc=none smtp.client-ip=178.154.239.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rosa.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rosa.ru
Received: from mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1d:4795:0:640:c576:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id C05DB46D06;
	Mon, 24 Mar 2025 20:57:14 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id CvSVLw4LiqM0-RnaISLm5;
	Mon, 24 Mar 2025 20:57:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosa.ru; s=mail;
	t=1742839034; bh=f0JglIfLdiJdCiELGSM17hESlAkEOahyf16djTIKSYU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=PBL5wDwg7MAbXY6t78q8y4M1UiOLqiX617xviqHqJ2ktIE/d3tDeMXk/wm0aHN50V
	 3ZohWMKB6dxSCAGPydPlTZ37jGToShxnfpU0e0WQpPgnLeLm3mbNSKJWgA8eMptyiK
	 130MFmmr8WJp16rc+sai/9YGhgTxj9lKB9h2NtG0=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.vla.yp-c.yandex.net; dkim=pass header.i=@rosa.ru
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
Subject: [PATCH] KVM: x86: forcibly leave SMM mode on vCPU reset
Date: Mon, 24 Mar 2025 20:57:07 +0300
Message-ID: <20250324175707.19925-1-m.lobanov@rosa.ru>
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

Considering that hardware CPUs exit SMM mode completely upon receiving
a triple fault by triggering a hardware reset (which inherently leads
to exiting SMM), explicitly perform SMM exit prior to the WARN check.
Although subsequent code clears vCPU hflags, including the SMM flag,
calling kvm_smm_changed ensures the exit from SMM is handled correctly
and explicitly, aligning precisely with hardware behavior.


Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b64ab350bcd..f1c95c21703a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12409,6 +12409,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (is_guest_mode(vcpu))
 		kvm_leave_nested(vcpu);
 
+	if (is_smm(vcpu))
+		kvm_smm_changed(vcpu, false);
+
 	kvm_lapic_reset(vcpu, init_event);
 
 	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
-- 
2.47.2


