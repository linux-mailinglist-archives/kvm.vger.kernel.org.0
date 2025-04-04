Return-Path: <kvm+bounces-42755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D50CA7C555
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D3A13BC83B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E4E21CC61;
	Fri,  4 Apr 2025 21:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="22NB831z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3851A2547
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743801307; cv=none; b=dzWE9VS5NjwVYi81/LNnxJBSe6AwniTrH2L0yJGRbJPEIkktu3dgZjWU9aobyAHDDI770qcEhQePNZGfmZZTRnxEWGW13j9PF+bmUiU9lj0s3AoZpXtf1mKYmkM/sN4hneV72so79wAvrro9IojXAIZrtUtupt/nRKAV31RenO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743801307; c=relaxed/simple;
	bh=ItUeEJxyPrZVjz5fmXJVd+IubAfuc0Tp3x2Umz+G76g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XJckMG7Ht0TyEasFwgE0y2n14W9eH6NAvCR97QZPpBDuRIJjIopgnG5ybr100k44VKWMcRsFRso4Ctq9oJaq9B4gR+DzsrjueWFmgDzSZjoJ5Zs1feDXDozntgJS74WrM9l4YCXpAoaxDQYsuQxAFuWX2OissqXzJeawLSCDOh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=22NB831z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff53a4754aso3513152a91.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 14:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743801304; x=1744406104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkG9/Gie3NkMh7eSDfJzty3mxspo7ZZ0xVy2Q3dHWOM=;
        b=22NB831z0dVIPIj0q9WW60uk4KpeVzxXMha2Fb4AUORfrQlp17ZCH3LO/XNb7I+15A
         giqbWm9/ZAFlMSWeyhIT/glCMlDiCol5gNWn9aVO2idVZOPtO1dV9FZ7cJfzwNGx7lKs
         9e6dnPDKp6Wu9Peg9YBIcPfwvyU91m0mCI8A2b2qaA1x06qOlhwlKNZ+vAa7sB8oVUMa
         qrmcx6hx3ZC9+hf0eejdsqK2y33iXAyx07nC9RHVmoUmzAAyFk1eVDBeM+WlFXZq9Xv7
         BF7oaE8jyOYu9MN1JglYAHW5CPCBLh0YP6Bz8pMNYGCNPMysjy0uHuGjKCb0Mkpgypxk
         U8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743801304; x=1744406104;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SkG9/Gie3NkMh7eSDfJzty3mxspo7ZZ0xVy2Q3dHWOM=;
        b=QT/mWbaB0tXJm8GYyJuNbBuwUSnZC4M+2hWFI8XWhXnAh7/feUlJkDSmCJXLk00gYy
         Yo91j3T8nGSFrjLvalp4xklGCvaxp0Bn7hZXW0dmqwfmqsHQq+pu0JPu4yga6ZMK/EOL
         5XCqiTrr+5HQbKuXUYudgPhwc2LyJGx4AvFw9bAKbxEBs/X7gX+KoBRRJCzY7mJHz28N
         uqXpkZ9ZgMVdMpZvtkuqHmwH0nXMS3RjHChAqjp5RApghUO7yV0bluNThAMjjHeLL10w
         mDnBrRIRXlWuFctI5LVXSxvjBEvclsD0I12/pFSPkqVWB6RUCDnC2sWDWmpFU09Y61Pg
         lajA==
X-Gm-Message-State: AOJu0Yx94CkYKqGt79nRDv+Ka1yxUhrEBLoqWTdYf4P7z4FGRi3o9nT4
	dx7SfgIbIzWzi5uuOZQnNQDSJxz6Cul0cdYLYPgP0SUdE+BROuxmzv/dV277qs2A9K9QAITV0k3
	wUw==
X-Google-Smtp-Source: AGHT+IFs32FT+Ce+FtTQ8URjvqmCz/3ftaqwgA6qZrIK3r+Twdavhp7tQfXy+gW0pJuBHlqTt3ifIanpTwI=
X-Received: from pjbsf11.prod.google.com ([2002:a17:90b:51cb:b0:2ea:46ed:5d3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c3:b0:2f4:432d:250d
 with SMTP id 98e67ed59e1d1-306a617d201mr5610182a91.21.1743801304083; Fri, 04
 Apr 2025 14:15:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 14:14:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404211449.1443336-1-seanjc@google.com>
Subject: [PATCH 0/7] irqbypass: Cleanups and a perf improvement
From: Sean Christopherson <seanjc@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

The two primary goals of this series are to make the irqbypass concept
easier to understand, and to address the terrible performance that can
result from using a list to track connections.

For the first goal, track the producer/consumer "tokens" as eventfd context
pointers instead of opaque "void *".  Supporting arbitrary token types was
dead infrastructure when it was added 10 years ago, and nothing has changed
since.  Taking an opaque token makes a *very* simple concept (device signals
eventfd; KVM listens to eventfd) unnecessarily difficult to understand.

Burying that simple behind a layer of obfuscation also makes the overall
code more brittle, as callers can pass in literally anything. I.e. passing
in a token that will never be paired would go unnoticed.

For the performance issue, use an xarray.  I'm definitely not wedded to an
xarray, but IMO it doesn't add meaningful complexity (even requires less
code), and pretty much Just Works.  Like tried this a while back[1], but
the implementation had undesirable behavior changes and stalled out.

To address the use case where huge numbers of VMs are being created without
_any_ possibility for irqbypass, KVM should probably add a
KVM_IRQFD_FLAG_NO_IRQBYPASS flag so that userspace can opt-out on a per-IRQ
basis.  I already proposed a KVM module param[2] to let userspace disable
IRQ bypass, but that obviously affects all IRQs in all VMs.  It might
suffice for most use cases, but I can imagine scenarios where the VMM wants
to be more selective, e.g. when it *knows* a KVM_IRQFD isn't eligible for
bypass.  And both of those require userspace changes.

Note, I want to do more aggressive cleanups of irqbypass at some point,
e.g. not reporting an error to userspace if connect() fails is *awful*
behavior for environments that want/need irqbypass to always work.  But
that's a future problem.

[1] https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
[2] https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com

Sean Christopherson (7):
  irqbypass: Drop pointless and misleading THIS_MODULE get/put
  irqbypass: Drop superfluous might_sleep() annotations
  irqbypass: Take ownership of producer/consumer token tracking
  irqbypass: Explicitly track producer and consumer bindings
  irqbypass: Use paired consumer/producer to disconnect during
    unregister
  irqbypass: Use guard(mutex) in lieu of manual lock+unlock
  irqbypass: Use xarray to track producers and consumers

 drivers/vfio/pci/vfio_pci_intrs.c |   5 +-
 drivers/vhost/vdpa.c              |   4 +-
 include/linux/irqbypass.h         |  38 +++---
 virt/kvm/eventfd.c                |   3 +-
 virt/lib/irqbypass.c              | 185 ++++++++++--------------------
 5 files changed, 88 insertions(+), 147 deletions(-)


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.504.g3bcea36a83-goog


