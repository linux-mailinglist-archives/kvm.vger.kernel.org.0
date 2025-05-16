Return-Path: <kvm+bounces-46893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEDFABA54F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 826FA4A82D5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD32280308;
	Fri, 16 May 2025 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sPyTEakJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7B281377
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431349; cv=none; b=KKoEI4wTKUdxhAHw6u7E24roEKWHS9FgdfY2UZLeQWq3msy1dMKhKNRLoZ8pAGJPjdMgq00tG+xF2udTMaX2L8rOmt3kd2CWMckff/HQjC8uIq6wNfwk5cjm8vQDfVxRLX9vd3Jj815D1KLJXyGNPJ0nyVGpPTxKc5lLdkhxbPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431349; c=relaxed/simple;
	bh=Rpd69iJyvfwAlVGI4I1bFliXaThxa8DUe5ebe7JgWeM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rxCaklvTDE8C4Yv0U4TVcDKu//xRbuZjST2QsHlw6AYq7+xxFs5ZFJo5azZ1Zpfjw+l0T0mnZr1i7ChRevRT31SvfQsrIpgOai5UpJ8a0TXYIDSUoLyhJrP+sKtGkmMzRSeHHUt6l+RlTI0XDc3ElSPSfRvaZKMcP4Xg2cullL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sPyTEakJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so2123443a91.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431348; x=1748036148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ova2r7VVYyiTf4lugW4BCVVVxMshH9nMU4eEdweoL7o=;
        b=sPyTEakJOAiQuSgYr7QlwnFXbF6XSAp6RDNaxA1XWEpWrVQVl3cyIty0IXNpOWkukK
         AAldZHw4HAb8KJy1rYJgowTK9/ExKqL+/h0JyKP/vu+z1bxoKsG+IhaSNRy2FWCVdMTw
         wDLpkbS/Wml0Ao+kuNnjfUKexgd0gTDLA27a23XrRLsDNnT5iiWq5jOUQBwyvcDcraek
         CwD407tm8AYPQh+wdHefu6qNz4FuQT3ORw+3qWt0CCDlDrceh7n86iEV2Vlarwke84/P
         S+LfJLI94q6mqZsVHqtUFyWNPJlhjRocn68kGVV2Fh6P+XXtztWeO2lwRfs/ixOraznr
         vGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431348; x=1748036148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ova2r7VVYyiTf4lugW4BCVVVxMshH9nMU4eEdweoL7o=;
        b=fSayPBfd5+vUZeUopu9LhOKZ/U9l7tn3jubYW6oG80GOwNzhKb1krvsqSZVXP5iIS3
         6ZUUmrzSd1BlfY0VBHk5UFErsCVrFSPGDQobieSsE+ql2nWzBlYAPoNjcmwlhZ9LZ9Sf
         qJACPu+pWFpCmhqP0hYcZCWlQfvYISQ5onnWW1HKHIe3CB15iCMmyWlnn8ZHG4/S2ogF
         cLm7RcPJKnEuINOQY6CdIqCRlPqtzmqDd/eGQjK2FwI7oKhlQ6Yz+mJ2NqIDiWWMHjkW
         410PokXBRcPQoQ+V2S/mBd8L+6vA6O6SeWzIe4Woqz0d5wo47+jvswlZIVzQcfMegTa3
         nUYw==
X-Gm-Message-State: AOJu0YwI00pnTu0tuqtnzozTp5mdtrfhBPoPeP062+AeJIuN7/sl46E3
	obOzapM7dlz8ucErsNz8uhWlVPjlNtSiYEOn9Js9h1RJ/lJaL7+4hkaszvpNayZMt7YGj1EmtXO
	n1GHGGQ==
X-Google-Smtp-Source: AGHT+IF809N1jB3x6msHfp9e5c5WFbWbgxrMw9eVJpQdfzg+ArgwpimlRRtEqmuLYTdV+qtKwWK8K/1OHpA=
X-Received: from pjboi16.prod.google.com ([2002:a17:90b:3a10:b0:2fe:7f7a:74b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:30c:523e:89e3
 with SMTP id 98e67ed59e1d1-30e7d520e3dmr7600236a91.11.1747431347773; Fri, 16
 May 2025 14:35:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:35:37 -0700
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516213540.2546077-4-seanjc@google.com>
Subject: [PATCH v3 3/6] KVM: Conditionally reschedule when resetting the dirty ring
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	James Houghton <jthoughton@google.com>, Sean Christopherson <seanjc@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

When resetting a dirty ring, conditionally reschedule on each iteration
after the first.  The recently introduced hard limit mitigates the issue
of an endless reset, but isn't sufficient to completely prevent RCU
stalls, soft lockups, etc., nor is the hard limit intended to guard
against such badness.

Note!  Take care to check for reschedule even in the "continue" paths,
as a pathological scenario (or malicious userspace) could dirty the same
gfn over and over, i.e. always hit the continue path.

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: 	4-....: (5249 ticks this GP) idle=51e4/1/0x4000000000000000 softirq=309/309 fqs=2563
  rcu: 	(t=5250 jiffies g=-319 q=608 ncpus=24)
  CPU: 4 UID: 1000 PID: 1067 Comm: dirty_log_test Tainted: G             L     6.13.0-rc3-17fa7a24ea1e-HEAD-vm #814
  Tainted: [L]=SOFTLOCKUP
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_arch_mmu_enable_log_dirty_pt_masked+0x26/0x200 [kvm]
  Call Trace:
   <TASK>
   kvm_reset_dirty_gfn.part.0+0xb4/0xe0 [kvm]
   kvm_dirty_ring_reset+0x58/0x220 [kvm]
   kvm_vm_ioctl+0x10eb/0x15d0 [kvm]
   __x64_sys_ioctl+0x8b/0xb0
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  Tainted: [L]=SOFTLOCKUP
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_arch_mmu_enable_log_dirty_pt_masked+0x17/0x200 [kvm]
  Call Trace:
   <TASK>
   kvm_reset_dirty_gfn.part.0+0xb4/0xe0 [kvm]
   kvm_dirty_ring_reset+0x58/0x220 [kvm]
   kvm_vm_ioctl+0x10eb/0x15d0 [kvm]
   __x64_sys_ioctl+0x8b/0xb0
   do_syscall_64+0x5b/0x160
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index e844e869e8c7..97cca0c02fd1 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -134,6 +134,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 
 		ring->reset_index++;
 		(*nr_entries_reset)++;
+
+		/*
+		 * While the size of each ring is fixed, it's possible for the
+		 * ring to be constantly re-dirtied/harvested while the reset
+		 * is in-progress (the hard limit exists only to guard against
+		 * wrapping the count into negative space).
+		 */
+		if (!first_round)
+			cond_resched();
+
 		/*
 		 * Try to coalesce the reset operations when the guest is
 		 * scanning pages in the same slot.
-- 
2.49.0.1112.g889b7c5bd8-goog


