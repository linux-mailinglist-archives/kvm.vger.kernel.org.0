Return-Path: <kvm+bounces-32627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3CF9DB056
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D89E166F5A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B751CA8D;
	Thu, 28 Nov 2024 00:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v7XxW7Eo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA0CE571
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754631; cv=none; b=nN3h5ZXS4++9Mqr8jEUlvxKz8DgaaeShAljuugNSJ5f0ORJcahuBSB3VXw/Hobh5Uj/dhtstHBwW5AyF4TZAXHA+JTmzhrbcPksJfaZMjHJiUvu+Cs+p4voIlo5qIsAw6S6zhcHHLhJKRpbJrkSWEo2IrLRhN3Rkq+ZyUa6WGoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754631; c=relaxed/simple;
	bh=EACB2yPyU5Yw8+WwKYitNwB9tkKiB/UcMdmwylhn5ac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=glqqbo59FRrZe0K7RPIjPwKPMZr33NEsKgsdxBB5dMwnHEhTSlKwbHRdZ1mtvB9r/4NVxxC/rOFARyW92jOImNrYkdtUE05cPUVCJoYB6CSunVm4hhtqtYXMC/BCeCp/OM5R3t+SVw7NaC4MuSKX5jBZjWfEM345n/0BvDh3s68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v7XxW7Eo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea65508e51so412717a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732754629; x=1733359429; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=H6v00VWPrFlV9G8PXjNGHz1lcbArd14LtnA+J13xoHI=;
        b=v7XxW7EoO+ncriNDu2gIHvbXy3S5xYONjO+Tf0yNsXsxEn8y6N3rh5wETBW6Tkebqa
         /RSErLXc8BX0QLx/r/i3LGRs4MJwvLuPUkvCxE8EQGrWfd2IM1FVHou0vWBKhB4qHfnR
         DC626wTtM/z4pDK4dzZeBj3uzSy3Mv7fOWtdC/65d9bGU9oseiO0LmGVrUQQwnSExSCZ
         SBpi/PSVK5jclZsl47hQHhddfM3q+PapNBtwbBWpJgqV4X+J7d+5jAYGYDr3OYfCJ+SV
         Hhe1gqn/npwqYlC37ShZibIpIqaM6lA8kjTUVNHXtr0M0gSeI98t6iGOy+81tlouIU9S
         Y9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732754629; x=1733359429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H6v00VWPrFlV9G8PXjNGHz1lcbArd14LtnA+J13xoHI=;
        b=MWJXM+Trqu7KhSTVArfiUAkuyVLxTmXHkWAwTk6P+qfUCS4ehWN6VleM8uMsCuTCbw
         DgH46SoiMXMp1tPHbheE07tsq8LkKyj45txJjUDrauifdji7J9z3yek9qAfzmOpoUO0R
         QPJXkXG9UeYWMTqhPV78vCbYYiQWmyFCbdxzSTPU5N2msshRc5VilDzFdINXbB+ftP7S
         Ux/O6fOfMBAvDI+m6Ut7tvMv4/qs4vgL/2Ocg/Ctb9+Z0VDeREu93PAy4LgxDY5NzOLT
         dSlVSIE26estY/pwVCURFkvq18c357DiINcG453rUlKrPil12pTJtGflw+vYIpDUN9KX
         Lqfw==
X-Gm-Message-State: AOJu0Yygzxq2937JZtqbcxA3O6qwE8KTqSw5Unp0tkjElDktKs0VqyA8
	oIrhaMR4wgv+Uqcn8NqhdmUPByPLwn9s04eLXPHGUVSjZ/+s+nDvZMDGtJ1XXEklK8n4rWX+pn6
	Ylg==
X-Google-Smtp-Source: AGHT+IEK9pbCeaFZWXX0PLadQxkBbAx1o35IfYFdtf0yqxaDLee26TJikEv6kZT/3lUfdcYbGJKEkLcA4Vc=
X-Received: from pjbpd1.prod.google.com ([2002:a17:90b:1dc1:b0:2ea:448a:8cd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:2ea:bf1c:1e3a
 with SMTP id 98e67ed59e1d1-2ee08eb2ae0mr7730683a91.12.1732754629027; Wed, 27
 Nov 2024 16:43:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:43:39 -0800
In-Reply-To: <20241128004344.4072099-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128004344.4072099-2-seanjc@google.com>
Subject: [PATCH v4 1/6] KVM: x86: Play nice with protected guests in complete_hypercall_exit()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Use is_64_bit_hypercall() instead of is_64_bit_mode() to detect a 64-bit
hypercall when completing said hypercall.  For guests with protected state,
e.g. SEV-ES and SEV-SNP, KVM must assume the hypercall was made in 64-bit
mode as the vCPU state needed to detect 64-bit mode is unavailable.

Hacking the sev_smoke_test selftest to generate a KVM_HC_MAP_GPA_RANGE
hypercall via VMGEXIT trips the WARN:

  ------------[ cut here ]------------
  WARNING: CPU: 273 PID: 326626 at arch/x86/kvm/x86.h:180 complete_hypercall_exit+0x44/0xe0 [kvm]
  Modules linked in: kvm_amd kvm ... [last unloaded: kvm]
  CPU: 273 UID: 0 PID: 326626 Comm: sev_smoke_test Not tainted 6.12.0-smp--392e932fa0f3-feat #470
  Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
  RIP: 0010:complete_hypercall_exit+0x44/0xe0 [kvm]
  Call Trace:
   <TASK>
   kvm_arch_vcpu_ioctl_run+0x2400/0x2720 [kvm]
   kvm_vcpu_ioctl+0x54f/0x630 [kvm]
   __se_sys_ioctl+0x6b/0xc0
   do_syscall_64+0x83/0x160
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: b5aead0064f3 ("KVM: x86: Assume a 64-bit hypercall for guests with protected state")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..0b2fe4aa04a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9976,7 +9976,7 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
 	u64 ret = vcpu->run->hypercall.ret;
 
-	if (!is_64_bit_mode(vcpu))
+	if (!is_64_bit_hypercall(vcpu))
 		ret = (u32)ret;
 	kvm_rax_write(vcpu, ret);
 	++vcpu->stat.hypercalls;
-- 
2.47.0.338.g60cca15819-goog


