Return-Path: <kvm+bounces-23135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCEF2946464
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 677391F21C6F
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BBB53389;
	Fri,  2 Aug 2024 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MVbnxhHy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEB8770EB
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722630588; cv=none; b=Uje1Udh63sQEJcN5H9/Y7U38kFoZ/PoH+tuxO/LqzvR/qwpTJ0aMyhjUH/y5QEby2BOxof1oAhIferiAnH8pFprdPVEl8zWJ1BcpaUZ7kHleDlzD5Q4wgR5CY7xHD72TvKYk25WQeXkAFrzdvHE1q7dbYLAaVu1Aj1DYCrhFgro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722630588; c=relaxed/simple;
	bh=WF3wrP9FVCWhvI5s7M5QfSDvoGTfsLiiwSyrSJY3GNs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OaNE+O9AJVrfpLvxzHjGezB6biGff4QaYgSZ7/TtYJjM2xzpaPWLd3xGStwRHQFgr047Znqb0vONMVlE5up5nKBT4SsN6yDTq3ItQ+lYoq1y6yMurZWCTl7vRLn2snnLREg/sGu2R+Iv+OAAw8h2r7zM3lGWY6eiUTBhL5PcCqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MVbnxhHy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd72932d74so72501785ad.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722630585; x=1723235385; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jXAWPfkwqKY8wTkDhDCSEwSk5HKMwXuyqi+tQSb2i8o=;
        b=MVbnxhHy2VMj7/I9cdfKtAYS+0iJ9eFoIDKKfKAl9v5ma4/B4bVfQefeYE/KWTQOBC
         /va47bj1626WHACpMLgILV/rjEdjcTPqP+d0HJKyQzWtj67rYbHiFtQvsQt1KP7jIpDb
         /QSAODTMocpxEhTU/pZ4N/j7qFaIsb6FDPBwIuIR2z9OqognOuAgrYRSuLkbSAR9YLMn
         rVGQPQSNf0Pj6RApS1+xXYJyGOxxgR/1MDYIh54I+xP6HN/mLwTDbklu8BPNVx4t0nsK
         uaVMOOfnsn/PFPNYNTA8zX67IkNhQ+j1tvznhH6S0S85LokDKn+rCWETfF+MTipw5/JF
         1UHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722630585; x=1723235385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXAWPfkwqKY8wTkDhDCSEwSk5HKMwXuyqi+tQSb2i8o=;
        b=j/5j++amPJLeSOMMFGUOj6bCnFGz9WvUcFA0vGvCcjCHwbHxc1N13Fus9BAtigVJbg
         RoHPg7A6JBjVjew3TllFbLoCPTzDudNRBznoqLVJwND68H9spjr3PJW1uxAwU8z8gJe2
         gcGtkUTQOeJljySkfv1p+flMpnBTtOnUNw58cxzzUCEot6+CNQ5/GA6E0QbNzj57t3Lc
         9rsX1GO7PIwtwrZljvNN9z6CLzr4yj/vLXLt+ulnbV75MRA+WeAvy8JfObnXGtJiKIsz
         KpCH9LDXctDXWEFPJMCUangx5XAOoyVm7pVNDFf/uMsqh7D7xvxJq5i6zHMuueKzKInS
         9lIg==
X-Gm-Message-State: AOJu0Yw7CjIjQPBPD1dd2Yr0o2EBfsVkvhpMKRqZn4wdTO3anTM/BpaT
	bN8jx/P3htnaVE/QfVPob+HobpdIiAt/l9Uoy7uEKlD2ALpJ8Hm9zA8Al3F8Rr749oGmPdotoSN
	4pA==
X-Google-Smtp-Source: AGHT+IHnpZirsws9d8gFRBxELSmDfY/2At0fV7PYAnQIyxbIG/QFYTbOfn7GUnAfrDZ4vyLXfQ6B8vHnAEA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec92:b0:1fd:6529:7443 with SMTP id
 d9443c01a7336-1ff5748d388mr2108555ad.11.1722630585507; Fri, 02 Aug 2024
 13:29:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:29:40 -0700
In-Reply-To: <20240802202941.344889-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802202941.344889-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802202941.344889-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Make x2APIC ID 100% readonly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>, Haoyu Wu <haoyuwu254@gmail.com>, 
	syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Ignore the userspace provided x2APIC ID when fixing up APIC state for
KVM_SET_LAPIC, i.e. make the x2APIC fully readonly in KVM.  Commit
a92e2543d6a8 ("KVM: x86: use hardware-compatible format for APIC ID
register"), which added the fixup, didn't intend to allow userspace to
modify the x2APIC ID.  In fact, that commit is when KVM first started
treating the x2APIC ID as readonly, apparently to fix some race:

 static inline u32 kvm_apic_id(struct kvm_lapic *apic)
 {
-       return (kvm_lapic_get_reg(apic, APIC_ID) >> 24) & 0xff;
+       /* To avoid a race between apic_base and following APIC_ID update when
+        * switching to x2apic_mode, the x2apic mode returns initial x2apic id.
+        */
+       if (apic_x2apic_mode(apic))
+               return apic->vcpu->vcpu_id;
+
+       return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }

Furthermore, KVM doesn't support delivering interrupts to vCPUs with a
modified x2APIC ID, but KVM *does* return the modified value on a guest
RDMSR and for KVM_GET_LAPIC.  I.e. no remotely sane setup can actually
work with a modified x2APIC ID.

Making the x2APIC ID fully readonly fixes a WARN in KVM's optimized map
calculation, which expects the LDR to align with the x2APIC ID.

  WARNING: CPU: 2 PID: 958 at arch/x86/kvm/lapic.c:331 kvm_recalculate_apic_map+0x609/0xa00 [kvm]
  CPU: 2 PID: 958 Comm: recalc_apic_map Not tainted 6.4.0-rc3-vanilla+ #35
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
  RIP: 0010:kvm_recalculate_apic_map+0x609/0xa00 [kvm]
  Call Trace:
   <TASK>
   kvm_apic_set_state+0x1cf/0x5b0 [kvm]
   kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
   kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
   __x64_sys_ioctl+0xb8/0xf0
   do_syscall_64+0x56/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  RIP: 0033:0x7fade8b9dd6f

Reported-by: Michal Luczaj <mhal@rbox.co>
Closes: https://lore.kernel.org/all/814baa0c-1eaa-4503-129f-059917365e80@rbox.co
Reported-by: Haoyu Wu <haoyuwu254@gmail.com>
Closes: https://lore.kernel.org/all/20240126161633.62529-1-haoyuwu254@gmail.com
Reported-by: syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000c2a6b9061cbca3c3@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7172ba59ad2..c6a59871acb3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2966,18 +2966,28 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		struct kvm_lapic_state *s, bool set)
 {
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
+		u32 x2apic_id = kvm_x2apic_id(vcpu->arch.apic);
 		u32 *id = (u32 *)(s->regs + APIC_ID);
 		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
 		u64 icr;
 
 		if (vcpu->kvm->arch.x2apic_format) {
-			if (*id != vcpu->vcpu_id)
+			if (*id != x2apic_id)
 				return -EINVAL;
 		} else {
+			/*
+			 * Ignore the userspace value when setting APIC state.
+			 * KVM's model is that the x2APIC ID is readonly, e.g.
+			 * KVM only supports delivering interrupts to KVM's
+			 * version of the x2APIC ID.  However, for backwards
+			 * compatibility, don't reject attempts to set a
+			 * mismatched ID for userspace that hasn't opted into
+			 * x2apic_format.
+			 */
 			if (set)
-				*id >>= 24;
+				*id = x2apic_id;
 			else
-				*id <<= 24;
+				*id = x2apic_id << 24;
 		}
 
 		/*
@@ -2986,7 +2996,7 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		 * split to ICR+ICR2 in userspace for backwards compatibility.
 		 */
 		if (set) {
-			*ldr = kvm_apic_calc_x2apic_ldr(*id);
+			*ldr = kvm_apic_calc_x2apic_ldr(x2apic_id);
 
 			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
 			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


