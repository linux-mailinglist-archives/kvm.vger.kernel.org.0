Return-Path: <kvm+bounces-67968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C30FD1AB5F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4443230319BC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9863A3939C6;
	Tue, 13 Jan 2026 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U3WY/b/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996CC34FF58
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768326370; cv=none; b=PHjDDa+7KqpWESgpKpAo/zbr+idXDRwjvZ0BCW6jgVLJS40BDYThZum4EehgFDmhWLbqmmuP0b63wFxAgEm9NpjS8tuVNtRB+daK4+oabQkXomClwH1nrfKvu1rvQScMWgx4CbmBqGUJ9VDwV13LSO72nT4D3ojUKLUz+RT8qNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768326370; c=relaxed/simple;
	bh=Kc6iXtyza34ocYeUdPw6arQZ62oECzXl++vxsN7lS+k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o8sMZ8/26bmIabaAGhChC4qS+0YBBSQwBBWFjqvDd3Hic6Ku7w05/jKTVpD5x1AM7xKKi6nmAB0KKN4vjC5bEhRDk+bHm5Z1RtUMmZmx12PN6VMqQyDpO5ymfuqVIXQAjL2eZGCix6Wr8N3hIw9TC85OE7KEWWQ4liLL8J0LMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U3WY/b/M; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so8878056a91.0
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768326369; x=1768931169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFPw5+539cdQiO1J8UXvDkrbIct9XnK8L9k4SGLKOz0=;
        b=U3WY/b/M6NNJKIdsKMzKeRECJuKW7iyIaG3vAUsxeimljfsW+agBqs8aXb98aOhN1p
         6VgG65Do/RisH3/yCONEqrrIUMD2VUBJTNMvr29767Bj5OqF7BLJJXW+eU9MS13ZLumZ
         uzNcTH73JbU56cxiF3JCjjwtqXKI8CDCqZ1SrFcfL+2CYTQew3pD/aRFTWc2xcqLZFPj
         UprUmImj94OWD6eC/1CIHB+x+IOGB81YXcuL7TUz8uMrY4+xunrDNZvsofoBR6MmQZYJ
         PNZPILANKE4SjpCdMDUDI+HS/HHjhiKAk0NDbwIMOV0y1u98/upkW+rYnjpomz5dipVZ
         V4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768326369; x=1768931169;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFPw5+539cdQiO1J8UXvDkrbIct9XnK8L9k4SGLKOz0=;
        b=g2UHs4lGz7yFIqXlS8ufuvnscDrfnsMVRyZzwy+Z3FNcKFb51g8J8Vn78NckVIkjn/
         5NUAqR+XIztyzklY82IJeTDJZwGiAIaYlJXUThshMWzTiJ6px7oI83AImj0h0YStNnjD
         MGrC7oafxv3vou2fUHLoi8rzzy7M3xN30uUGTjfYAEVeme2ZplBMNP7ehefMpmU9C0GS
         56UhVbNPQhJuUnqgJhIuDMbf0oq4kwUYRgFKMPsxqzZSd0xrGGH5cU1Z8ZnPYenZmeDH
         /HEamDtClHLCXKYr0s3Q6WSxr0/cVEOMcflB57IFN2adSBfWq1wdJpaDesiuLc0+C4v9
         aByQ==
X-Gm-Message-State: AOJu0Yym2a5OdYb0lKZktmKfaqypiYdGc06A741srM5B8ey0MoHCBniK
	8rRaWw75F8PLuuDT85CkvB/0cNKx/joeAm0iJk4b6InleRYOqPADGZTIbV+0Xuc13rwpzAJv36b
	jQVDBqA==
X-Google-Smtp-Source: AGHT+IGF/XIWWqYhs6Er9/hprWAOXS2JNn3SaLJx++RCETv7/QbnMUmfp1yXyh+P2rLX6NshvvVlvH1a5zU=
X-Received: from pjbmg24.prod.google.com ([2002:a17:90b:3718:b0:34c:2ca6:ff3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8b:b0:341:8bda:d0ae
 with SMTP id 98e67ed59e1d1-34f68c911c5mr21576077a91.20.1768326368918; Tue, 13
 Jan 2026 09:46:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Jan 2026 09:46:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113174606.104978-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Fix dangling IRQ bypass on x86 and arm64
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Fix three bugs in one, where KVM can incorrectly leave an IRQ configured
for bypass after the associated irqfd is deassigned from the VM (if the VMM
deassigns the irqfd while it's in bypass mode).

Two of the bugs are recent-ish, one each in x86 and arm64.  The x86 bug is
the most visible/noisy as it leads to kernel panics on AMD due to SVM's use
of a per-CPU list to track IRQs/irqfds that are being posted to the vCPU.

The third bug has existed since IRQ bypass was added ~10 years ago.  That
bug is much less likely as it requires hitting a race with a small window,
and likely requires the VMM to do some rather weird stuff on top.

The underlying issue of the x86 and arm64 bugs is that KVM clobbers the
irqfd's copy of the routing information prior to fully deassigning the irqfd,
which results in false negatives when kvm_arch_irq_bypass_del_producer()
checks for "irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI".

While the x86/arm64 bugs are fixable in arch code, e.g. by explicitly tracking
if an irqfd is in bypass mode (x86 already does this), leaving the routing
information in the irqfd as-is and instead checking if the irqfd is still
active prior to consuming its copy of the routing information fixes both the
arch bugs as well as the latent third bug.

The second patches hardens x86 against similar bugs in the future, by
essentially implementing the arch fix describes above, but wrapped in a WARN
so that bugs elsewhere are detected but less likely to be fatal.

The SVM bug was originally hit with Google's VMM, and confirmed via selftest
(which is also how I verified the fix).  I'm not entirely sure why this hasn't
been hit with QEMU.  My best guess is that QEMU always updates IRQ routing
when deassigning a VFIO IRQFD?

Sean Christopherson (2):
  KVM: Don't clobber irqfd routing type when deassigning irqfd
  KVM: x86: Assert that non-MSI doesn't have bypass vCPU when deleting
    producer

 arch/x86/kvm/irq.c |  3 ++-
 virt/kvm/eventfd.c | 44 ++++++++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 21 deletions(-)


base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.52.0.457.g6b5491de43-goog


