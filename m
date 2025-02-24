Return-Path: <kvm+bounces-39008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93916A42943
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FA6E17B06C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F021A264A68;
	Mon, 24 Feb 2025 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xx3G0HRK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B7264A71
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417254; cv=none; b=u0fKXq/CdTGw5wU/0yuwIcIMwvg46KGMCIi0fGdlYDR+V7rAJuhJaydJ/8p97kVfiPUmTlnylERAquJ7vOVT5DS30x5a9mYkfpBnb7SBUeVzyL+PqKj6/Fsc7dj0U89umexjeOX2hV/PQe+tCxXihsVv6+TaJVe5ZfkE+Dj39lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417254; c=relaxed/simple;
	bh=ChHQhpVxYbTXiAeNRbdrJoZgtAU1eO2sEaSStMSNrpA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=c3Vvhji0ZjnQGdr4vbLGaaUpMLr0Awy+c+gdcLw4qcpqBDaatMNctUm7t3HHtUOpkYFJ4ohxkkjrunzdUU1PS1y3BP3d+/2caHKWnBcc4jNIgSTa7hYV+IjROis7OyVrkeoTTRYQuyN8coqjJ2fcRQup5j4uHmbNwFfarheGVZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xx3G0HRK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1e7efe00so9569609a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417252; x=1741022052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPxQY7bRKSrsl0rwMMhqxmRexHRZyDzKPiknNpdHSTs=;
        b=Xx3G0HRKNKupzo61QrwIJG8ZRVmfV5aGQ1nhcnI2IBMQWhgMswwhzaskWDqkSXzIHa
         fsqb1v+xmOhcGEZdX+3f2IpEDhHQMjG8Jk74MufYj6Pg1gLUMgEoDq1ayx1F8dKp16TV
         1fLrT7p5zxVyN/cTjar4n9YTriPuM3w3C8kFYWy6d+KKXH2Q63InRz9ceveXdVNOh4nD
         vFVGcLX6Io1jiUuAMMrY1PCnFQJpL/g7KtaBNqZWUEp1KmLLYPUmhfYUn2grXzcb+/GO
         GQ7lIqytHdf6WHbXjjwtGYv8eNldPANl8s7xl7op8RXBxiEDUMTKGTFoL93F54dNBydK
         dblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417252; x=1741022052;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QPxQY7bRKSrsl0rwMMhqxmRexHRZyDzKPiknNpdHSTs=;
        b=jyCHYNagKrL0K912GzydXSC/7PI2rhzRkaofIDVl20tt3YvDacjXRicDJ6lOtbHWnS
         s+0D38Btv2r888E8/ucFMjAMS+QM7mxPk0yBGjrHPPVHEv5/kMXIUBCz3Iqk9SjQ6HSg
         4FAUcMg9014XKFU81Ctlf0/S52E/reilpsX7sCXM5xA+AnxA/i671sOODe2Q9rdhCLvu
         t1Q7D8FC/cTfMJ5OTFrV5JfwXSH49SDLsfr3iWlLKqLcQKe0VXjI/c6rS+7EFnDdqnHP
         JJklbIQ6EndTExUmoiaJIgr1Iw3crU9CJDvF85PIYsAgFPYb557MUFVQwzJyR1q9Xpho
         aBUw==
X-Gm-Message-State: AOJu0YxW5iZiB7ekMXtauCkalE6oQDGaFjAFydhDRnetprCh+EgabhjZ
	lVIgT67zYQwnBKcbM88TG9f/HryEZJIBYiDn8lSRqZN637nu67arVXtBi4RgyZmVyeOme1iHX18
	7EQ==
X-Google-Smtp-Source: AGHT+IHMxO2jlJB8uB6BmR8LSjz1yPyBddEjKyuuWppjAVjkQ/oZiNhamNiA1F9pN/rnOeUmadjA6AOp/dM=
X-Received: from pjbdj7.prod.google.com ([2002:a17:90a:d2c7:b0:2fc:2b96:2d4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7cb:b0:2ee:cd83:8fe7
 with SMTP id 98e67ed59e1d1-2fce875d6aemr22583311a91.35.1740417251898; Mon, 24
 Feb 2025 09:14:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 09:14:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224171409.2348647-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Reject KVM_RUN if userspace forces emulation during
 nested VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend KVM's restrictions on userspace forcing "emulation required" at odd
times to cover stuffing invalid guest state while a nested run is pending.
Clobbering guest state while KVM is in the middle of emulating VM-Enter is
nonsensical, as it puts the vCPU into an architecturally impossible state,
and will trip KVM's sanity check that guards against KVM bugs, e.g. helps
detect missed VMX consistency checks.

  WARNING: CPU: 3 PID: 6336 at arch/x86/kvm/vmx/vmx.c:6480 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6480 [inline]
  WARNING: CPU: 3 PID: 6336 at arch/x86/kvm/vmx/vmx.c:6480 vmx_handle_exit+0x40f/0x1f70 arch/x86/kvm/vmx/vmx.c:6637
  Modules linked in:
  CPU: 3 UID: 0 PID: 6336 Comm: syz.0.73 Not tainted 6.13.0-rc1-syzkaller-00316-gb5f217084ab3 #0
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
  RIP: 0010:__vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6480 [inline]
  RIP: 0010:vmx_handle_exit+0x40f/0x1f70 arch/x86/kvm/vmx/vmx.c:6637
   <TASK>
   vcpu_enter_guest arch/x86/kvm/x86.c:11081 [inline]
   vcpu_run+0x3047/0x4f50 arch/x86/kvm/x86.c:11242
   kvm_arch_vcpu_ioctl_run+0x44a/0x1740 arch/x86/kvm/x86.c:11560
   kvm_vcpu_ioctl+0x6ce/0x1520 virt/kvm/kvm_main.c:4340
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:906 [inline]
   __se_sys_ioctl fs/ioctl.c:892 [inline]
   __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

Reported-by: syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67598fb9.050a0220.17f54a.003b.GAE@google.com
Debugged-by: James Houghton <jthoughton@google.com>
Tested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b71392989609..8081efb25d7e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5875,11 +5875,35 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
+/*
+ * Returns true if emulation is required (due to the vCPU having invalid state
+ * with unsrestricted guest mode disabled) and KVM can't faithfully emulate the
+ * current vCPU state.
+ */
+static bool vmx_unhandleable_emulation_required(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	return vmx->emulation_required && !vmx->rmode.vm86_active &&
+	if (!vmx->emulation_required)
+		return false;
+
+	/*
+	 * It is architecturally impossible for emulation to be required when a
+	 * nested VM-Enter is pending completion, as VM-Enter will VM-Fail if
+	 * guest state is invalid and unrestricted guest is disabled, i.e. KVM
+	 * should synthesize VM-Fail instead emulation L2 code.  This path is
+	 * only reachable if userspace modifies L2 guest state after KVM has
+	 * performed the nested VM-Enter consistency checks.
+	 */
+	if (vmx->nested.nested_run_pending)
+		return true;
+
+	/*
+	 * KVM only supports emulating exceptions if the vCPU is in Real Mode.
+	 * If emulation is required, KVM can't perform a successful VM-Enter to
+	 * inject the exception.
+	 */
+	return !vmx->rmode.vm86_active &&
 	       (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected);
 }
 
@@ -5902,7 +5926,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (!kvm_emulate_instruction(vcpu, 0))
 			return 0;
 
-		if (vmx_emulation_required_with_pending_exception(vcpu)) {
+		if (vmx_unhandleable_emulation_required(vcpu)) {
 			kvm_prepare_emulation_failure_exit(vcpu);
 			return 0;
 		}
@@ -5926,7 +5950,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
-	if (vmx_emulation_required_with_pending_exception(vcpu)) {
+	if (vmx_unhandleable_emulation_required(vcpu)) {
 		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}

base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.601.g30ceb7b040-goog


