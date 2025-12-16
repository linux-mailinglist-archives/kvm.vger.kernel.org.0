Return-Path: <kvm+bounces-66080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A79E5CC4426
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C86E43129F9A
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E0D30EF92;
	Tue, 16 Dec 2025 16:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FfQvTcpy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8F22EFD9E
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765901880; cv=none; b=boMyG7xbtO7Knmd+dL+Lr0ZhHEk/utCRCJ4SZ+2ckNCRmQp297yarOQZI0QZ/pBCcvMntlD0HrSySyDExz7DcNIHHyh1eVN5fmIh/MMDdNQjcU2vF+nxPQdc4/UefAlVn2dQm5Y1T39kw1vfiTVwoMARUsWhMtE+6oWmG1rI+64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765901880; c=relaxed/simple;
	bh=oDad10tBgsXtNCipQDkssrcR7fxfDa9VYoz3N7fHVIE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZpV0AiYONC+WBfJz6Y4OQ0IUqAQYZDddbN4ykT8GbKwoS0MuwFWFWpXcTvxLKH2Hk28jXN3z3hy/X8Lx8zTiaJgyIxXUUsgnJitjhcOHegQ7eR13562Ba5hplE/wf5IoePmhq703QKf1rL5DTMme5IjEzQfv6idzeMECiQdjRMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FfQvTcpy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0a0bad5dfso62627535ad.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 08:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765901878; x=1766506678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rtWUnpShPmQzTtydQTzJbAldqFRML+Ujl+KavI+WO84=;
        b=FfQvTcpyAkAJ7Fx9tC4Dp9qEZ//vFmUJ/0blEbV4aItOGqc36kx3KwNlBHh9v5Mv2a
         6bMc9tu4L4Erv7mEP+LlCrMw+diFTRypZ0/xj4iNJg3duVitnyryHuxtuuHWGg8xpaZB
         yWPIBH8Zc1WOxuk2MF8NIb6X7hUULhPvGVWq8gdeVRjVhzcklcCV5yvdSc7pXbwBfBuF
         /MxDJS2yta8G6qDabEdeSTtaWGil503py9u/3+jx33SwZhsgUHG8q2YyfC/fuVJCH9ho
         CiUHLO7x6YAoxh9Xag7umtjdxTVe982xdJwvpMj2iATrLANDfgRyV43vVEhGs7jWvuCh
         +8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765901878; x=1766506678;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rtWUnpShPmQzTtydQTzJbAldqFRML+Ujl+KavI+WO84=;
        b=DmR+ye3lWpp+NMVpMNcCRvXO58LCSq4KITvof/tYPk/JidIp7FVEQzmKm5mPYFOVhy
         pfXsnKJSzIYxghVRxn6xM80edWCNPwfl5zAreVvczx+Z5iGLgbFcN3VM+z21dH+x3hU0
         xjMdGtFuh11smE872CvAstazfEjmanbu+IjlUpYFzz4hbVufD0RkNs6VyijFLy21bp/8
         YipGc8ykAmw0jBCuiakJ09LJ5w9DnkxqUcM8Y+EwjLrKEFk2CBHRiIWNsjycNF9vxLEp
         ALf9pQU+/VsnYs/UVYfDGWekYXpXd+SX8Ud16dlomPL2eMar1y3jpB4/+ehm/bOEDkor
         VRBw==
X-Gm-Message-State: AOJu0YyYHlBUxr+qaXD9LJk7+j54jV0K4ow3huet7Oo0uulTbg+5HPD/
	H6SfCd8c67nhqBcx3mKjKrNLDHJKidvZsVMAc0MJE+0VRmgF3kZz/+i9nBrmKcXzsFxXB+ttsl3
	hPLRd8Q==
X-Google-Smtp-Source: AGHT+IFIHdd5EBZw97/XxjgHRkRU72Rd47o3FMvs4D/9pReBVAObAAfwIFJkMxwjEPiuwoLnbiC2EuCaU68=
X-Received: from plmn1.prod.google.com ([2002:a17:903:1881:b0:29f:2f99:afb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c403:b0:29d:9db2:f833
 with SMTP id d9443c01a7336-29f23b77308mr157629785ad.25.1765901878390; Tue, 16
 Dec 2025 08:17:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 16 Dec 2025 08:17:54 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251216161755.1775409-1-seanjc@google.com>
Subject: [PATCH] KVM: nSVM: Remove a user-triggerable WARN on
 nested_svm_load_cr3() succeeding
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Drop the WARN in svm_set_nested_state() on nested_svm_load_cr3() failing
as it is trivially easy to trigger from userspace by modifying CPUID after
loading CR3.  E.g. modifying the state restoration selftest like so:

  --- tools/testing/selftests/kvm/x86/state_test.c
  +++ tools/testing/selftests/kvm/x86/state_test.c
  @@ -280,7 +280,16 @@ int main(int argc, char *argv[])

                 /* Restore state in a new VM.  */
                  vcpu = vm_recreate_with_one_vcpu(vm);
  -               vcpu_load_state(vcpu, state);
  +
  +               if (stage == 4) {
  +                       state->sregs.cr3 = BIT(44);
  +                       vcpu_load_state(vcpu, state);
  +
  +                       vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, 36);
  +                       __vcpu_nested_state_set(vcpu, &state->nested);
  +               } else {
  +                       vcpu_load_state(vcpu, state);
  +               }

                  /*
                   * Restore XSAVE state in a dummy vCPU, first without doing

generates:

  WARNING: CPU: 30 PID: 938 at arch/x86/kvm/svm/nested.c:1877 svm_set_nested_state+0x34a/0x360 [kvm_amd]
  Modules linked in: kvm_amd kvm irqbypass [last unloaded: kvm]
  CPU: 30 UID: 1000 PID: 938 Comm: state_test Tainted: G        W           6.18.0-rc7-58e10b63777d-next-vm
  Tainted: [W]=WARN
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:svm_set_nested_state+0x34a/0x360 [kvm_amd]
  Call Trace:
   <TASK>
   kvm_arch_vcpu_ioctl+0xf33/0x1700 [kvm]
   kvm_vcpu_ioctl+0x4e6/0x8f0 [kvm]
   __x64_sys_ioctl+0x8f/0xd0
   do_syscall_64+0x61/0xad0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Simply delete the WARN instead of trying to prevent userspace from shoving
"illegal" state into CR3.  For better or worse, KVM's ABI allows userspace
to set CPUID after SREGS, and vice versa, and KVM is very permissive when
it comes to guest CPUID.  I.e. attempting to enforce the virtual CPU model
when setting CPUID could break userspace.  Given that the WARN doesn't
provide any meaningful protection for KVM or benefit for userspace, simply
drop it even though the odds of breaking userspace are minuscule.

Opportunistically delete a spurious newline.

Fixes: b222b0b88162 ("KVM: nSVM: refactor the CR3 reload on migration")
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372..9be67040e94d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1870,10 +1870,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * thus MMU might not be initialized correctly.
 	 * Set it again to fix this.
 	 */
-
 	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
 				  nested_npt_enabled(svm), false);
-	if (WARN_ON_ONCE(ret))
+	if (ret)
 		goto out_free;
 
 	svm->nested.force_msr_bitmap_recalc = true;

base-commit: 2111f7ca0e92dec60f0a3644ff3b164342af33c1
-- 
2.52.0.239.gd5f0c6e74e-goog


