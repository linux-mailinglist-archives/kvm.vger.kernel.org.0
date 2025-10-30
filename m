Return-Path: <kvm+bounces-61518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FDFC21D83
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 093E534D9B2
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12792374AA7;
	Thu, 30 Oct 2025 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2TBzJznl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EB836E34A
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 18:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761850689; cv=none; b=CLjR2Iv/q/M2TSx5UbizYR43w0VA4PjX8J89E/jeNXnIX64Ic0RJGWyzByjCQkE0IBFAWNkfdNTMzoIqNdbkdk4GZ0pQBNq9T0jtlsO83zaW39U8BAgjmyCUjwSlFWkw++LEjy3tX5cZVf6nkvckrDfGuQAXQrxZeH2EucTPgsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761850689; c=relaxed/simple;
	bh=RyA8Ri5olrt5gVUAkNvgzyYtXDsIqh0YJlOJzxYebls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JvuAI9uaeKD2MnI1dv/+7b+lXv1+DPEH1xcry0cyaGlkja+jxa8IcmPaXxvdYjQU9+33s5/ymX3q3+t81AV8DIJDi9EQh+4hFRrZCczgiEIeuM92UzSSTK5zwbJtJg6wgjALRc1Z8qIUnkx3w4fSZfAVS4NuhIVoSRg2dIhOTCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2TBzJznl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso1197099a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761850687; x=1762455487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ffdGfK3G8fFqWd4bB2Py6VDSdKdATKpCm00IZqsBSKk=;
        b=2TBzJznlMDlWWG7tJPryqo4r+OENiehvvBeDK5GYkQhxIj7lIOT4JdTMwTMoXivEl9
         wYN0oKJ8xRwVeTSjTjOPUa6/cuSbWI/kBXpPruKqJb5Z//veei3bUVXBnBD2RzncP1O4
         X8wh1lwmrOnZchmG0QweqCM6ixcAESiXNFeZkgjIb3W8vhWZMn4jB4eNdq8RQThuCYkx
         TxfYSonXMp9bqmGV/of7acCuonmNJzlDMa0RM7fTIxd/oJWV6xzdGHM+VZOntHk1Q128
         zNx+DlLFXlazbH8C4xjm6dUiP9NnIdP0Ymj0zWHk9vj+XFTs2kYBL9bRiZxI4JDFnPCF
         YGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761850687; x=1762455487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffdGfK3G8fFqWd4bB2Py6VDSdKdATKpCm00IZqsBSKk=;
        b=CXw7WmybuD+xZjdEoNEo+OuLffVvalR3fXYJHfEysRSB5zX+9ITBHMymh94zV+B0Zj
         Na0dEXmvzD0xgPuD0SL7YDadezdH72IQqC9Pukw9u3MYioCoGzGGbqh4KTFANc2ZPrvJ
         Cw5d0bvFdTz47jekgzp5mU36Yi3pJLoF+mwGNfxr8RRlOZHT+CSC/Zt83U7/9Jv7yqhr
         ltIgoXL/iK0USb4+T8/CkxnrMnqQIaY7Ezo4V2zH9DjsJy5hSGq3oa03DytzsyzhFWGo
         BAY6DoCoBwClPHm0JhkhGR/uAFAX36agvr0tXB7LqTyW+EZh1H+k3qh931aQ3pd+S5GT
         e1Fw==
X-Gm-Message-State: AOJu0YyLTo/APvrhZBTpQpzmwzejyAph39/5TflWbVG3Smk/7Fv8iQ2N
	z+wh+ZgkWQPVmImPe2FCn6jB9YCoetIAkj99Vh1UwnKG6TS4uw0pJemhmv7DDRIaTVTS/P/Kvz8
	w/4gpxQ==
X-Google-Smtp-Source: AGHT+IF2EI2U816IX2ZBkV1AWOUJKFRBQZltZYX3ifvjPmcAGE8cExdVkbmQPbMi8HXd1Tz34n+BLWcJgeQ=
X-Received: from plrd18.prod.google.com ([2002:a17:902:aa92:b0:27d:1f18:78ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e746:b0:295:6e0:7b0d
 with SMTP id d9443c01a7336-2951a5e4b8cmr7986855ad.56.1761850686758; Thu, 30
 Oct 2025 11:58:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 11:58:01 -0700
In-Reply-To: <20251030185802.3375059-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030185802.3375059-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030185802.3375059-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Unload "FPU" state on INIT if and only if its
 currently in-use
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace the hack added by commit f958bd2314d1 ("KVM: x86: Fix potential
put_fpu() w/o load_fpu() on MPX platform") with a more robust approach of
unloading+reloading guest FPU state based on whether or not the vCPU's FPU
is currently in-use, i.e. currently loaded.  This fixes a bug on hosts
that support CET but not MPX, where kvm_arch_vcpu_ioctl_get_mpstate()
neglects to load FPU state (it only checks for MPX support) and leads to
KVM attempting to put FPU state due to kvm_apic_accept_events() triggering
INIT emulation.  E.g. on a host with CET but not MPX, syzkaller+KASAN
generates:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
  CPU: 211 UID: 0 PID: 20451 Comm: syz.9.26 Tainted: G S                  6.18.0-smp-DEV #7 NONE
  Tainted: [S]=CPU_OUT_OF_SPEC
  Hardware name: Google Izumi/izumi, BIOS 0.20250729.1-0 07/29/2025
  RIP: 0010:fpu_swap_kvm_fpstate+0x3ce/0x610 ../arch/x86/kernel/fpu/core.c:377
  RSP: 0018:ff1100410c167cc0 EFLAGS: 00010202
  RAX: 0000000000000004 RBX: 0000000000000020 RCX: 00000000000001aa
  RDX: 00000000000001ab RSI: ffffffff817bb960 RDI: 0000000022600000
  RBP: dffffc0000000000 R08: ff110040d23c8007 R09: 1fe220081a479000
  R10: dffffc0000000000 R11: ffe21c081a479001 R12: ff110040d23c8d98
  R13: 00000000fffdc578 R14: 0000000000000000 R15: ff110040d23c8d90
  FS:  00007f86dd1876c0(0000) GS:ff11007fc969b000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f86dd186fa8 CR3: 00000040d1dfa003 CR4: 0000000000f73ef0
  PKRU: 80000000
  Call Trace:
   <TASK>
   kvm_vcpu_reset+0x80d/0x12c0 ../arch/x86/kvm/x86.c:11818
   kvm_apic_accept_events+0x1cb/0x500 ../arch/x86/kvm/lapic.c:3489
   kvm_arch_vcpu_ioctl_get_mpstate+0xd0/0x4e0 ../arch/x86/kvm/x86.c:12145
   kvm_vcpu_ioctl+0x5e2/0xed0 ../virt/kvm/kvm_main.c:4539
   __se_sys_ioctl+0x11d/0x1b0 ../fs/ioctl.c:51
   do_syscall_x64 ../arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x6e/0x940 ../arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f86de71d9c9
   </TASK>

with a very simple reproducer:

  r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x80b00, 0x0)
  r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
  ioctl$KVM_CREATE_IRQCHIP(r1, 0xae60)
  r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0)
  ioctl$KVM_SET_IRQCHIP(r1, 0x8208ae63, ...)
  ioctl$KVM_GET_MP_STATE(r2, 0x8004ae98, &(0x7f00000000c0))

Alternatively, the MPX hack in GET_MP_STATE could be extended to cover CET,
but from a "don't break existing functionality" perspective, that isn't any
less risky than peeking at the state of in_use, and it's far less robust
for a long term solution (as evidenced by this bug).

Reported-by: Alexander Potapenko <glider@google.com>
Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..d1e048d14e88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12137,9 +12137,6 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	int r;
 
 	vcpu_load(vcpu);
-	if (kvm_mpx_supported())
-		kvm_load_guest_fpu(vcpu);
-
 	kvm_vcpu_srcu_read_lock(vcpu);
 
 	r = kvm_apic_accept_events(vcpu);
@@ -12156,9 +12153,6 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 
 out:
 	kvm_vcpu_srcu_read_unlock(vcpu);
-
-	if (kvm_mpx_supported())
-		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);
 	return r;
 }
@@ -12788,6 +12782,7 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 	u64 xfeatures_mask;
+	bool fpu_in_use;
 	int i;
 
 	/*
@@ -12811,13 +12806,23 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 	BUILD_BUG_ON(sizeof(xfeatures_mask) * BITS_PER_BYTE <= XFEATURE_MAX);
 
 	/*
-	 * All paths that lead to INIT are required to load the guest's FPU
-	 * state (because most paths are buried in KVM_RUN).
+	 * Unload guest FPU state (if necessary) before zeroing XSTATE fields
+	 * as the kernel can only modify the state when its resident in memory,
+	 * i.e. when it's not loaded into hardware.
+	 *
+	 * WARN if the vCPU's desire to run, i.e. whether or not its in KVM_RUN,
+	 * doesn't match the loaded/in-use state of the FPU, as KVM_RUN is the
+	 * only path that can trigger INIT emulation _and_ loads FPU state, and
+	 * KVM_RUN should _always_ load FPU state.
 	 */
-	kvm_put_guest_fpu(vcpu);
+	WARN_ON_ONCE(vcpu->wants_to_run != fpstate->in_use);
+	fpu_in_use = fpstate->in_use;
+	if (fpu_in_use)
+		kvm_put_guest_fpu(vcpu);
 	for_each_set_bit(i, (unsigned long *)&xfeatures_mask, XFEATURE_MAX)
 		fpstate_clear_xstate_component(fpstate, i);
-	kvm_load_guest_fpu(vcpu);
+	if (fpu_in_use)
+		kvm_load_guest_fpu(vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
-- 
2.51.1.930.gacf6e81ea2-goog


