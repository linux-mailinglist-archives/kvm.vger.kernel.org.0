Return-Path: <kvm+bounces-37016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13599A24613
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:14:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B72E23A87D9
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF8539ACC;
	Sat,  1 Feb 2025 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tf82DaQi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE521CF9B
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738372448; cv=none; b=us4KDnCgyIzANMoQcJ5Q7aXLnLkX5st0rteTKqjusfB7fvJMTyDGQSvujjzaAvsBwccJ8iqWjj+1Nuk6IGRuyiTvZcjD6NK7uxC912/2xgUWgAhtkVoC7cpmsUwerVb3t/ZIoAJj+6/zhI9bKv4CC1bRVEa4tXW5zcYc90TpXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738372448; c=relaxed/simple;
	bh=UDiTXSTfBH0EOp+MejDSxKgfdfI3+KOE+dUN4Gwb0KE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kFc7ZaMyfMg7rhNb1b5zIhNikpT9x+XMV7vIb4M49GWVqPGdgdxom/KZBqDA/6HDlV2j/zjXNae46EQUuQkX9l3pbcqdrZZF3TgRTQL203hgXO7FD6oCDf8XIg95AvLLKv04wkE8DahWeAw9dvJG2DrDd96U11FJA+Ay0Lxww30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tf82DaQi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216717543b7so67071715ad.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738372445; x=1738977245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ic4S96V5xW2k4uiIcyvRxni7wZ7oCZzN7I2/Wa5niQ=;
        b=Tf82DaQi6NZHjwUHyhlWWkSQGnGayAv8C0ooCyBW/ZqQLfusoEfshKxsbGhdK+wA8T
         ewSWfwlQAj/RHSUq7xwESUT4Q8bGytN1/M6bt5PuXYtPIM+o9+CY/Y8EWVUkYLfQSKb2
         NIj/2pc97yG1z0TvfOwpFZ2lCuakIKfHNzJtiwFokvo/TKwB5SIoy/Of3eLbQEvYtGEU
         LK+YIXR5kYYbg9p3SvDB04RDfJ2nw5OjsJ3cly8EnbMes74xHpoKKtHp4MxeOnseMlwU
         So6UmAkzlRRMOd8TaYEk1BJCuYA0naUdDQl8ZsZhRzhEL2n6tqF8OMLGw8fJrqkeCyuv
         bB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738372445; x=1738977245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Ic4S96V5xW2k4uiIcyvRxni7wZ7oCZzN7I2/Wa5niQ=;
        b=R7uZAADTKQEBC5xhf6Wyi21X52xJ3T0gTKD3Pa0PYXUsZP65kB8mPD0zQNdvKXtJfg
         p0ZHpef/Ibh1eFiNhdQitX0qEXJjaK4ksN50XT9lyBDMXYLTno6JHU5Kzib+AGxIPMAM
         UhNFVyISxEGPLoca9Kt/QSOdh74ZB2fOGQV8J8WfoB+MXrkHK/OJb6bwfx3nH/Afu9RP
         +Xl9YD7j6fNLt7lZPGJio6KDBpvAt0irnoO9vlWfS/23oULCIENpbIARwJDJUWWWl3b9
         dE50Lhs9xWeCSFJoZCn0NtaW8VuMOPfkywcNfWfdOei5Bnej1/zRKinPtPNSwJZzjULK
         sKxw==
X-Gm-Message-State: AOJu0Yw3bs63GkHZrNbzVJSkKTYLHEtmA2wWVDsiAqLvLHR0kE2Lmeb6
	0JpAqRkW3HEjmZOmQyUy536BjNRdQJOVc6UTPSYiKiFNs1JSElJnt1tfCn72sVoniUnMMPLT+Rt
	DuA==
X-Google-Smtp-Source: AGHT+IGGOiNfAsKcc7I2Ois69n1RIN8U53iejt27njRVZnAgVIYEYR+WxCnPB5UeMYUjhcsFHlqBySEAKcY=
X-Received: from plck17.prod.google.com ([2002:a17:902:f291:b0:21a:8476:ecc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d48c:b0:215:b01a:627f
 with SMTP id d9443c01a7336-21dd7c4457emr223500625ad.4.1738372445221; Fri, 31
 Jan 2025 17:14:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:13:56 -0800
In-Reply-To: <20250201011400.669483-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201011400.669483-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Reject userspace attempts to set the Xen hypercall page MSR to an index
outside of the "standard" virtualization range [0x40000000, 0x4fffffff],
as KVM is not equipped to handle collisions with real MSRs, e.g. KVM
doesn't update MSR interception, conflicts with VMCS/VMCB fields, special
case writes in KVM, etc.

Allowing userspace to redirect any MSR write can also be used to attack
the kernel, as kvm_xen_write_hypercall_page() takes multiple locks and
writes to guest memory.  E.g. if userspace sets the MSR to MSR_IA32_XSS,
KVM's write to MSR_IA32_XSS during vCPU creation will trigger an SRCU
violation due to writing guest memory:

  =============================
  WARNING: suspicious RCU usage
  6.13.0-rc3
  -----------------------------
  include/linux/kvm_host.h:1046 suspicious rcu_dereference_check() usage!

  stack backtrace:
  CPU: 6 UID: 1000 PID: 1101 Comm: repro Not tainted 6.13.0-rc3
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x7f/0x90
   lockdep_rcu_suspicious+0x176/0x1c0
   kvm_vcpu_gfn_to_memslot+0x259/0x280
   kvm_vcpu_write_guest+0x3a/0xa0
   kvm_xen_write_hypercall_page+0x268/0x300
   kvm_set_msr_common+0xc44/0x1940
   vmx_set_msr+0x9db/0x1fc0
   kvm_vcpu_reset+0x857/0xb50
   kvm_arch_vcpu_create+0x37e/0x4d0
   kvm_vm_ioctl+0x669/0x2100
   __x64_sys_ioctl+0xc1/0xf0
   do_syscall_64+0xc5/0x210
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7feda371b539

While the MSR index isn't strictly ABI, i.e. can theoretically float to
any value, in practice no known VMM sets the MSR index to anything other
than 0x40000000 or 0x40000200.

Reported-by: syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/679258d4.050a0220.2eae65.000a.GAE@google.com
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Paul Durrant <paul@xen.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/xen.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..35ecafc410f0 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1324,6 +1324,14 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	     xhc->blob_size_32 || xhc->blob_size_64))
 		return -EINVAL;
 
+	/*
+	 * Restrict the MSR to the range that is unofficially reserved for
+	 * synthetic, virtualization-defined MSRs, e.g. to prevent confusing
+	 * KVM by colliding with a real MSR that requires special handling.
+	 */
+	if (xhc->msr && (xhc->msr < 0x40000000 || xhc->msr > 0x4fffffff))
+		return -EINVAL;
+
 	mutex_lock(&kvm->arch.xen.xen_lock);
 
 	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
-- 
2.48.1.362.g079036d154-goog


