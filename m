Return-Path: <kvm+bounces-35897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFD8A15A52
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F5CC168550
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BE117C61;
	Sat, 18 Jan 2025 00:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LvFvn/N4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D842F846F
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737160500; cv=none; b=VJs3lVl8TAfQZF17dDxPQw6Bs4nfDTG+s2PwpUm2C/04FdxrHAnEmO6Ln9XjxSUSsxZcv6VXYvBffO7T1/ckAMfvaxS4BiPU/H7htwvRhc6I+y+uiqOREpJx1RYw5jVgErC5+OL80xyrzP5u9gpN3KDiQdKqcLHxldKiZuQ3Llc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737160500; c=relaxed/simple;
	bh=eGHe5gF9I7lfcTZORHYZOxZxqC6xcvK6L3bhqa/xB0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q7ZyiBFGLmCUg+nHD2hqGlwXUBb48wGaYRX4i6IzLUxVJC6eED716HXcgF0JeH3uNx7/wFqzBop7UHHb4MrQvgyf6PFKCFggwbF1QoyRhWuKCbBJxh/U8asnPPgwVuK4ZOSvGcrAKnsvks0WIsO6CdikVH+kO5HqMrR2BV3mOF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LvFvn/N4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso5316417a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737160498; x=1737765298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0S5is2s74td8olw60SMBDSb7Un/PlX1cyabFTguZZXE=;
        b=LvFvn/N4cnBnXTt8XWxKRr2uAkshWQPaPdED1XaQZNK17ocnRViVGG+hMu4DtDVaYr
         1UJZsWX/5DI0koOcIltzYkP0IGFQtf2uda1HfP30Wm+DYAKIou/X/xRVLGxWNHCyudn4
         jh34rFSLApU+x++XMyqg4DbBH0yLSe/RmgTvzF7vfkb3Zo6jJ7+stK4tptjUAVdocIm5
         trDWbNPgLOETevJ9V3roPn0U/hulTyTKZ0K42CvjVeDhTPxZHS8RCw/1y1Mw5TilL+Fe
         liZU9otEhfuQuWnhboePtbijYvwz1olhJY5PdzRCD987h600o8uDyLRFbPgr39P9oWoj
         bRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737160498; x=1737765298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0S5is2s74td8olw60SMBDSb7Un/PlX1cyabFTguZZXE=;
        b=D+cfd8/AtoAU6Uui+a8yRgjpUL4YhWsf+rVosvNxTaa3vRY81La/HyEKpeTnH7MKcn
         h9icL7LnV1BtcWyhtGu/ramRV7Ws+G9SGSgMXGIUNk7DMY3xRI0HVmZRS+YJDa5jbVaQ
         qJCaYGINN6uSPwi2+Br9si11PSSQDNzbvOW4rbmKAHrLmWX2lLvm5zNCPj6HOTpcPLtg
         bezKWVa3w/RyYkNzkVo1SnAdMHIcLVZ2rAzBEUKAaa+15gX9zOxQprsyRXl9rDogxlIf
         gT3U3ocPPVJNLa9BdEW0gbKFlktl5fxVzEGifDn6UC3DEr8ZouCCx41NnpwELkN27Dmq
         aKxg==
X-Gm-Message-State: AOJu0Yye67IJxLytcnHeFFEUfc/slYAiCCa+AEsDQ4j344BCPGHxxn5a
	HCp0vY/0t607ujBAv9dE+VYKFQF8BGbB8K4wWIxlDrE6R+Msst6RXbYG8E9p4lGeRaI3j+S/1Wj
	tnQ==
X-Google-Smtp-Source: AGHT+IHd4uHzHZdChMtxIJlYIYnRzZVH4GhDcfPnpmm3A9dFAICoxUGOFyvyMpEcWkNkINoiDwelqEqPznM=
X-Received: from pjbdb14.prod.google.com ([2002:a17:90a:d64e:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e41:b0:2ee:f19b:86e5
 with SMTP id 98e67ed59e1d1-2f782c71ec7mr7576221a91.14.1737160498146; Fri, 17
 Jan 2025 16:34:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:34:51 -0800
In-Reply-To: <20250118003454.2619573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118003454.2619573-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118003454.2619573-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if
 local APIC isn't in-kernel
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Advertise support for Hyper-V's SEND_IPI and SEND_IPI_EX hypercalls if and
only if the local API is emulated/virtualized by KVM, and explicitly reject
said hypercalls if the local APIC is emulated in userspace, i.e. don't rely
on userspace to opt-in to KVM_CAP_HYPERV_ENFORCE_CPUID.

Rejecting SEND_IPI and SEND_IPI_EX fixes a NULL-pointer dereference if
Hyper-V enlightenments are exposed to the guest without an in-kernel local
APIC:

  dump_stack+0xbe/0xfd
  __kasan_report.cold+0x34/0x84
  kasan_report+0x3a/0x50
  __apic_accept_irq+0x3a/0x5c0
  kvm_hv_send_ipi.isra.0+0x34e/0x820
  kvm_hv_hypercall+0x8d9/0x9d0
  kvm_emulate_hypercall+0x506/0x7e0
  __vmx_handle_exit+0x283/0xb60
  vmx_handle_exit+0x1d/0xd0
  vcpu_enter_guest+0x16b0/0x24c0
  vcpu_run+0xc0/0x550
  kvm_arch_vcpu_ioctl_run+0x170/0x6d0
  kvm_vcpu_ioctl+0x413/0xb20
  __se_sys_ioctl+0x111/0x160
  do_syscal1_64+0x30/0x40
  entry_SYSCALL_64_after_hwframe+0x67/0xd1

Note, checking the sending vCPU is sufficient, as the per-VM irqchip_mode
can't be modified after vCPUs are created, i.e. if one vCPU has an
in-kernel local APIC, then all vCPUs have an in-kernel local APIC.

Reported-by: Dongjie Zou <zoudongjie@huawei.com>
Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
Fixes: 2bc39970e932 ("x86/kvm/hyper-v: Introduce KVM_GET_SUPPORTED_HV_CPUID")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f0a94346d00..44c88537448c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2226,6 +2226,9 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	u32 vector;
 	bool all_cpus;
 
+	if (!lapic_in_kernel(vcpu))
+		return HV_STATUS_INVALID_HYPERCALL_INPUT;
+
 	if (hc->code == HVCALL_SEND_IPI) {
 		if (!hc->fast) {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
@@ -2852,7 +2855,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
 			ent->eax |= HV_X64_APIC_ACCESS_RECOMMENDED;
 			ent->eax |= HV_X64_RELAXED_TIMING_RECOMMENDED;
-			ent->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
+			if (!vcpu || lapic_in_kernel(vcpu))
+				ent->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
 			ent->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
 			if (evmcs_ver)
 				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
-- 
2.48.0.rc2.279.g1de40edade-goog


