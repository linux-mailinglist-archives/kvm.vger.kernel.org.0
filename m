Return-Path: <kvm+bounces-35331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01868A0C4A7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2082F169E88
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3CE1F9F60;
	Mon, 13 Jan 2025 22:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1zI/CGE8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5156A1F8EF3
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807266; cv=none; b=EtpMDLqFTHPXWzOEdwv0VxE8JEvIWQAVhw9CmqXnaWi3BD/NS/SI11uTUxMaWbWxHtiiY07QAe/kNHmY1GTPlCZ5XutteI7jzKfoOfAWcFKLt/eE2h0mkHRyjfERW7x7aGRpy+T+HTZK/pywXPX1uZK6YaKVLNWLqox0HvWnE0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807266; c=relaxed/simple;
	bh=vblzX9oZHAXxiqXhSe7IP/dcd0L4gup1FWh8NLr+JyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Git6ehJ8/upbqPOY7toXQrw1HRxEbnV7hsBSk3+Cwwuu/u+q/HK1eBc4HIotLC3LYiNow8n6UhRIzLc/g6+zw3jRHQ5Npn73iZxuSJDYhtv4yElpskWzj8KKmDGSwgo43qsrybYjgazyloq/9aVstMTk0rr7QYP19DQMTr+qDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1zI/CGE8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216750b679eso60322615ad.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807264; x=1737412064; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FedWRlmic2iRbfD7jbI+6doHjrw5hxRZcg5PhzQ2p6Y=;
        b=1zI/CGE84arHGyuQdpAnpAG8T8e0GBfHnhAGsyG7oTIB86Chtqu4VOmSurNpvcOB+u
         mkeIYdL1nTN20ehmFckI5gky5Szijdi4jxF45xycc0TRvVMDYf7a/DaeLXWtKyi1pxns
         LEd7pwtRstsOuuAqq8KzduiHaV9ZjMoy/8MW2vYCzTb+VFGdPhfweePJNCEF/Ll0Ilgq
         RvzneqiH7vtBz5wWq3KsMCWKA+EhBNJM76DscIqheqokUy4hA1EsyXRVWc4QdYMZKqn5
         s+tHTVk1NIOPd90n7gH8bLltNUcBK25bzINrBXq2EtQ9l5wlSftcJGF8x/SV43xVggWQ
         k3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807264; x=1737412064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FedWRlmic2iRbfD7jbI+6doHjrw5hxRZcg5PhzQ2p6Y=;
        b=biLFIBbO+mlnzxpHrc5p85fo9gyHhHKb8son32UDSVFOezOdrZW9zpKKd8Dib0rzZM
         BtzJciqmzRJsRt1LOeQDA8eeeFpwk2+r9IiGdXD+fZ/S7ucZmbjxfDpS9yvfew43zpmx
         HhzWVAF3XpbeXMmsBXNam/FowUNBnh0H7R7yiG+sTDUUFqk6C48+fw5lG+WNles+5CMV
         6wf/NV8t47cMwZR79E0Kxet7PnuXc80GcjAPMbjMXM+vki6O9a424buLjDu8SA+9GzA0
         hkV2sfC1G7ycA76J6HU/7EDCWBaGZFOTIYNM1F7v6xfYhbw+bMDrqlgr2xXJa1kN+AQh
         bZZQ==
X-Gm-Message-State: AOJu0Ywum4ye5RjJ3SHi+nBuMhBxNTBcxyfhpTW0RDfYNKx6zgyyxHIe
	tipHes+1n6sCT1EovDgeDFRAJlrjCWzP5j3DmBotWyH3T8i7O+MQiW0YYMIZHQSFZQjfRtK34Yq
	/zA==
X-Google-Smtp-Source: AGHT+IG/ROPkD8yLMtzQiIrh1R/MPmPtvI4UCtDnjy6mbuSklnLOxfXbAF79flfOKNZCBDDB0j65jdsuvK8=
X-Received: from plsd19.prod.google.com ([2002:a17:902:b713:b0:212:4fad:1dc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f705:b0:205:4721:19c
 with SMTP id d9443c01a7336-21a83fe48fdmr325122105ad.37.1736807263732; Mon, 13
 Jan 2025 14:27:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 13 Jan 2025 14:27:36 -0800
In-Reply-To: <20250113222740.1481934-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113222740.1481934-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local
 APIC isn't in-kernel
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
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
Cc: stable@vger.kernel
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
2.47.1.688.g23fc6f90ad-goog


