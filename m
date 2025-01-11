Return-Path: <kvm+bounces-35186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7612BA09FD1
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CDC416A2FB
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361D380BEC;
	Sat, 11 Jan 2025 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4qs5oJlp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F8921106
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557457; cv=none; b=DmUrzV3Qdnl90ZWaHPtKlqtrvkY30XOmJUP2xe95Qlq3mQhSzrIWyguUv2Xp1rgWVrl1K1EtVCrWYqmuZNzEsnt/Jy+rjFkO4aE7CNbPqjRTy8SREuajdXhbw6F+YIdxVl/nkykq79Woo2s6UnvqLDqm5BpYbkQgPU3dq0KcHIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557457; c=relaxed/simple;
	bh=xIq2EpqRyA2AXMVcTKTfGnLziwxJNZwMY0SpruaP6dQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fHgcBV8gpZ+YhEEMzq9zI5a/IZ64ZrTV65ZR+cEzFloR3/xfDUD7BFKXrY4COATYVrOTLXD+hx4VkgxhF/EwcqCu6icqPfbyQ+AGioxcMif3/Ft6XOJtJYZCMrjNf7A0G5g7IkPRLzwnVXLYrXxOMiiP4v6gXSNWO80IKIRqjE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4qs5oJlp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee46799961so6714186a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736557455; x=1737162255; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qLONhXo3aW3WBH6fEqaAtaxz8PcaBZClYQxjCE2fW5k=;
        b=4qs5oJlp1NssvfORJ4Fz8n0E7/9Q9YF6XBJ3KFSFnXvaaAWsBWw1SVWB7aW1eRxyck
         Wn65+z/O5Lf/+namTAQj9Lb95a2TFGMpZNE+B93P4SwWgV9s1ytC2WTpktBQTUrDjuWu
         MRDtshiYsP7ay+wgdPVxE/xxIpU6kTv6pzGbAo2N+Ys1aETlClp+FqZrchyifISTaZiZ
         /H+lxtQByZMBz6nbxJ2OFA69N9NanXwdSR8CdNFKfjuT3GqGAVhtI7/HD3MzZsFzNqsQ
         TWBQ2RB7ojnF3/PIp7AR5JEFoKOc4mjiiCKKwq9gasQ1lBQgF0R0448AUghuwSc+uVEP
         YSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736557455; x=1737162255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qLONhXo3aW3WBH6fEqaAtaxz8PcaBZClYQxjCE2fW5k=;
        b=QD6zzbbPrlWCv0V+K3QhacsNScOGfLQxcXyYVefAq07XaYq4L4gl8VuZXLSfz25HqW
         /nh5ZzRp/hb5o+Y8oNjT1qvfonAMREztlHmRYLai9knUePGtNX4+eCXjBuD9AItA6nZ0
         QEEPKJHy3JCmj+xK4ZXC8EdPNOby5ry+LN2Iyra9bsspicAEeSWXLD6RP1PK80bhdoqQ
         8SF4saEbOey42K/z0CmIq1mN90CTs3daDf8oatIiOqMyXxuhmpQ6N4O6vKCeVzdfAv7R
         kxUFwWw4wtTaN7NFpzjn+TMi6VNCgt4C5f2zJtfiD0RcyzzBkW1HgXuHnTVUunImihSP
         eY/Q==
X-Gm-Message-State: AOJu0YwjKw7LQyJWZWT+1990oIN3Bx4Uglej1nfYC+Gn/T1QMiaBn5FJ
	Pl4BxIJCGO+IX6VyPbfrHD0ZCmEdAR7hUA52slsrmJFP5DWRCCnBzxnsqT/FlNqFIFUDr9eViGU
	koQ==
X-Google-Smtp-Source: AGHT+IHH0Fmds1PmmVVZr37IVwKQmveAAVRjINELYisNKzj4RspyqLxQGG7qVO+G/iH8KfvqVTQcx1AsZ7I=
X-Received: from pjbqi17.prod.google.com ([2002:a17:90b:2751:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b8e:b0:2ee:d433:7c54
 with SMTP id 98e67ed59e1d1-2f548eceae7mr17545829a91.19.1736557455348; Fri, 10
 Jan 2025 17:04:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:04:06 -0800
In-Reply-To: <20250111010409.1252942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111010409.1252942-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111010409.1252942-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: Bail from the dirty ring reset flow if a signal is pending
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Abort a dirty ring reset if the current task has a pending signal, as the
hard limit of INT_MAX entries doesn't ensure KVM will respond to a signal
in a timely fashion.

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/dirty_ring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 2faf894dec5a..a81ad17d5eef 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -117,6 +117,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	cur_slot = cur_offset = mask = 0;
 
 	while (likely((*nr_entries_reset) < INT_MAX)) {
+		if (signal_pending(current))
+			return -EINTR;
+
 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
 		if (!kvm_dirty_gfn_harvested(entry))
-- 
2.47.1.613.gc27f4b7a9f-goog


