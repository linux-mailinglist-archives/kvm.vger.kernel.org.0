Return-Path: <kvm+bounces-35187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC486A09FD3
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:05:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE83A3AA901
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18CB148FF9;
	Sat, 11 Jan 2025 01:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OtwLxFBh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9880B1854
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557460; cv=none; b=KGof17pU+2Ys877XmYctrf7zT5ozCS4MATVg584u5tkcPPp7/Db70UOIr+Jrv3vAnN9WhD+zJhmZl0qAd7O+BZXCVFKGwUAf8qHnFZ39bAIkJYB6DIiVQ+3gPd2MlmeNgHtDkX7XZ0l1gaSj5HtdJHYL9SGCxlfsMjlhMM6aYfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557460; c=relaxed/simple;
	bh=38yKh50jmTM2QnQCwQHA2pD1K0ArDB2ne9BY9y0yDsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XSOSunP+ypgTTaYfv1QIkqAC7yqIZOEyEuBr67QejNfDIPRUAa+oluALJZLV3TzcTzk7WeZ2P0w7J1sWrq9zwMo6cKRMPgzuaCt+EDwowyF9WRKNKxjY6Y92cy9uayf7ByH7Xcf/ofvmvQMQuLT0HQdb+mzNqPFJaoBTmOH8Hn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OtwLxFBh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so6672102a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736557457; x=1737162257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qztCq3yN4c7V5VVWefuCXzG4z+KIAvAw68bTrwIGEiM=;
        b=OtwLxFBhXTN+tJ+2KUpBBqdXmvLd6QivviqhooqBIdpPjzAQnYEbmbLWXTQ9OKKAhZ
         h0PMoIdDfPxwSd4KEOmmwsQXCGZmb+s+5LUFFIqPq0kmHUK3gKlMT/7oZtwcS2OMmdCu
         fJKGsKXxyoCtAxaspOiRLZ95rwhrWXwyFL9Rr3QO8LLMcLC1oekmaPZ3Jse/NZmc4gFP
         qCAKEV0Q+pAU76dvkHUW/p7t++udkCGmsHuthpVWKbm1PfqhORHzxQyRORavYKTC3LU3
         +A4WvGYoqIkrAYcMm6tiMEW+Uw04OReJlLPcrpSiJWcP4I/8eX5xNBVU1lxKO5MPXJ/G
         9Ocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736557457; x=1737162257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qztCq3yN4c7V5VVWefuCXzG4z+KIAvAw68bTrwIGEiM=;
        b=Z3UjRNEwX9y7gcgAKMFQkvZTowoYqG45Evkauy5RkDGjkyJ3DXjyXTbNIOhqGbHuRt
         u6965ai+95aeRNm5RfCXXR/T80REaclGyavOt9Jt4yMyQ2jhDdEa+8pzer+8oPC6nno0
         Udy9ao64CMrWXc71r3IK1jV218K6L7d2yDIxWwVkGE5UCpw1lvaN+GEOMnbJdOKyvWSO
         M4Ix1pMdI84xSvxYmneJi0ik9YXBZ1dmWSbJ0EkBuigwDvpcfJnlmyz5AlAqmdLIdfr9
         zCLkk2QssyI20giBWSRqdwVW19NZUvPfwNivV01O2R2AGO9fArBMbb6sPzMu3vUbW4iv
         rLJA==
X-Gm-Message-State: AOJu0YzEs+POfMt/Yu0S/MTdsF2ElcraunkAtnKM8Mn210+Ne0CW2zxc
	xaeXvXXJJdyXID875lhBivGvYVZ/Ed51w21z4xg70t3Bx46p9hjJsmU1orL/YNY+EyGk68UtPC6
	d4w==
X-Google-Smtp-Source: AGHT+IGWC2DYlQkU/EcPOOmwCPjaBsLhvhJQuYZtuDOFD2C754CM0kGzgUC90dVegSd+WxYgpA7SBB0o1w0=
X-Received: from pjc4.prod.google.com ([2002:a17:90b:2f44:b0:2f2:ea3f:34c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:274e:b0:2f4:4003:f3ea
 with SMTP id 98e67ed59e1d1-2f5490f19c7mr19708701a91.33.1736557457046; Fri, 10
 Jan 2025 17:04:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:04:07 -0800
In-Reply-To: <20250111010409.1252942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111010409.1252942-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: Conditionally reschedule when resetting the dirty ring
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index a81ad17d5eef..37eb2b7142bd 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -133,6 +133,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 
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
2.47.1.613.gc27f4b7a9f-goog


