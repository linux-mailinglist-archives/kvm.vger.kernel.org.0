Return-Path: <kvm+bounces-42323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09325A77E81
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C450B16CEF7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6520F2063D5;
	Tue,  1 Apr 2025 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFDrBqtl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281B7205E30
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743519908; cv=none; b=koLjUxvVp/VxSoK0bpEXnYJkkrpRjqNoFI1S2u40qHgpjpZ47o1gBRjMBVww/hVkcSsVpY3wNPU5qJNCPXc6gBkl5IpfApQ21elm50O30l0oKki/J/4kqWEH2wwei50SYSOK66qqVGkYHKfrKb+OZZQbew7IjlLyoLeQ/TduSvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743519908; c=relaxed/simple;
	bh=F/RiXgmrpmTiv2QvtvjdUGI+ud9Yccr9L3aXP3dOP60=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LUNiuXFqjmqzALOWwRVW4ClHobZQujLodztaoyjsIlEiHgQP/nEwBN88U/gU3hrBzucclBySkfIgfiz7IiHdI4p0ErppAY9tRhFh5JSdnY8SeCxWdYByk1xUA7+o0emyhQxKjsVSwNehQqPKz8x0VAmGZyrMNVeVjoQZSJ6vCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HFDrBqtl; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-225ab228a37so100486235ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743519906; x=1744124706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+IgyuGHrG6KOz4ioK+lLzhnnHjxowzYSohAuohKgopQ=;
        b=HFDrBqtlYe/Hd++C1UvM94aVgbuvTyO3XhAOHdRkE71dQIKBO4q41rI7ui0PlON+Jd
         orEFlOegFTbkr3ndZT5PyDreBR91eIQxfaMJa1F31cE86lSwn5KX+gUIjth9zHMmbG1A
         7iUg+crEl5xPK81dln8ZWO7RtnMUppbzdZlaJsMzYms8FcPIF+aS8/QouJHTP/N4Lf9j
         nlEvNHBpvIftGaWwKaiVsoZ2VIorv5tiIKtlcVumxacT31zdyRfyZ5l/3N8VDs8YjNnH
         5HXLgzjcEWwdsYhMvY3jbiAj3sC5aO42HhEMRkzpjDvYawb7yq5wKeamjw5+8Np4vCK2
         UPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743519906; x=1744124706;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IgyuGHrG6KOz4ioK+lLzhnnHjxowzYSohAuohKgopQ=;
        b=bT+9pld8lhUqtFZuYG7hZRJQMJnsZ4boWZe1HMYGx35TcbGy0EAn1fAMBQc4z1Qlu2
         KRKpMOpWLh+OAfs0tSlYlLK2dZabKhqCsKiCR5LkKGG/ea4eIo7d7X1rPTYaba+eKYxS
         odeiQM9OhtrdC31IAu8bSugb/ZgM3KpWRp1olHWU2NkcO2KLzU/Xy4vomVCix6tCfpFe
         HOjsxuG5rNHC/geXrSelE8+L8U+FDwPYQ7Y3AAhPho+nb/6BMjKaXX/Ks0NmXsdD6oon
         q0TL6N1rSOzdN2BFJzpBMYdNIT3B6heiZJl+HiQJXMaFKRflH3fBOhn/MwzIpLMvwVJp
         4hxg==
X-Gm-Message-State: AOJu0YxLhrmOEqUR9mv50ubujdN6QOnq1Y5NdYBYglHmpQ3wnbGGu+5Q
	F//1NdGxOtpzvQbKPsAyLNA93JHpSZiWvw0akwnz62idjmUx8sOzAM2tk1arC33+KT4R7fkimft
	aXg==
X-Google-Smtp-Source: AGHT+IG7JAm6yR31fSBvMf2GU4Ds1vfmbHR0/eLzAEDvkzcrRzepC4l8s3OVsGvLjol1VPLnWhQsYXPcmd8=
X-Received: from pfbgu25.prod.google.com ([2002:a05:6a00:4e59:b0:736:a320:25bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1493:b0:739:4a30:b900
 with SMTP id d2e1a72fcca58-7398037e24amr18537552b3a.7.1743519906429; Tue, 01
 Apr 2025 08:05:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:05:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401150504.829812-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest
 memory accesses
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Acquire a lock on kvm->srcu when userspace is getting MP state to handle a
rather extreme edge case where "accepting" APIC events, i.e. processing
pending INIT or SIPI, can trigger accesses to guest memory.  If the vCPU
is in L2 with INIT *and* a TRIPLE_FAULT request pending, then getting MP
state will trigger a nested VM-Exit by way of ->check_nested_events(), and
emuating the nested VM-Exit can access guest memory.

The splat was originally hit by syzkaller on a Google-internal kernel, and
reproduced on an upstream kernel by hacking the triple_fault_event_test
selftest to stuff a pending INIT, store an MSR on VM-Exit (to generate a
memory access on VMX), and do vcpu_mp_state_get() to trigger the scenario.

  =============================
  WARNING: suspicious RCU usage
  6.14.0-rc3-b112d356288b-vmx/pi_lockdep_false_pos-lock #3 Not tainted
  -----------------------------
  include/linux/kvm_host.h:1058 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  1 lock held by triple_fault_ev/1256:
   #0: ffff88810df5a330 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x8b/0x9a0 [kvm]

  stack backtrace:
  CPU: 11 UID: 1000 PID: 1256 Comm: triple_fault_ev Not tainted 6.14.0-rc3-b112d356288b-vmx #3
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x7f/0x90
   lockdep_rcu_suspicious+0x144/0x190
   kvm_vcpu_gfn_to_memslot+0x156/0x180 [kvm]
   kvm_vcpu_read_guest+0x3e/0x90 [kvm]
   read_and_check_msr_entry+0x2e/0x180 [kvm_intel]
   __nested_vmx_vmexit+0x550/0xde0 [kvm_intel]
   kvm_check_nested_events+0x1b/0x30 [kvm]
   kvm_apic_accept_events+0x33/0x100 [kvm]
   kvm_arch_vcpu_ioctl_get_mpstate+0x30/0x1d0 [kvm]
   kvm_vcpu_ioctl+0x33e/0x9a0 [kvm]
   __x64_sys_ioctl+0x8b/0xb0
   do_syscall_64+0x6c/0x170
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..3712dde0bf9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11786,6 +11786,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	if (kvm_mpx_supported())
 		kvm_load_guest_fpu(vcpu);
 
+	kvm_vcpu_srcu_read_lock(vcpu);
+
 	r = kvm_apic_accept_events(vcpu);
 	if (r < 0)
 		goto out;
@@ -11799,6 +11801,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 		mp_state->mp_state = vcpu->arch.mp_state;
 
 out:
+	kvm_vcpu_srcu_read_unlock(vcpu);
+
 	if (kvm_mpx_supported())
 		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);

base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog


