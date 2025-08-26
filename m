Return-Path: <kvm+bounces-55712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D984B3505A
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 02:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8941D1A87AAB
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93929265630;
	Tue, 26 Aug 2025 00:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wnA9yR0o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384D51FC0EF
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168816; cv=none; b=hUugZVCntd3RCw5f4nwW6liAsC9bCGLpBc8eDLxD+dMceX7wSnE30K57d/nFufkoVslSkRB6d/5lKopjyTDMyDW5yzSeFBSjpIsLhvFoZ6aPi5tgBy4qNLfQ296Jj6KRp2/XG2F7fQCXrBOd7LcRI+LP171pSl2WKtQFn3IAHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168816; c=relaxed/simple;
	bh=OGApnXhecwv65yclankWf5l5OEJW6iLLstfxLiQxT78=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hkdr+JdWlRN513fc4mf7N/188AL9qO0lEtzqAHnznksaHN+ciKbViEhlj52Te7jFYbxOUtYgzfB9qOXhmLt8lXN0hF360vqh4Zxm3GDSoOGYKjgYgGRzgK0KwC6dIy86jRpjHu70k3GgPhBBJIyZTRKFB7t27XFJMObpDC3cJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wnA9yR0o; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-325228e9c12so3689759a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756168814; x=1756773614; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGFfEAOpmCnYuTpD1Fkefs/dVeGZ0wTmpw3Bli3LbeI=;
        b=wnA9yR0o3Zao4cmij5KpH31jEUNmW3Z3vb6s1D/e57RQBf6J7qhRVeiYZtgRhrmBJX
         ptg07/T3KbOGlTbbSZttzE6qmKX6BRZGjwwV+my+bWtdSAnQQv8SofFczHW+u3MgYNEZ
         bul7mDBV1lkjM4wSTHFlJUjzFIGvoqDcjc38v6cnoH319TrzIAfeZ8oN7XmwpNwFcqZO
         Z5/Oa8S9cbAFJSMR9ByE+yjtBjUqnBBOVisGUzDbG0zgZLxXHu4HwfGxiWfUwQMEUyhF
         LOOXmrNH9/RK1eOGY8y5xBSbwl2RS8wypLV2EEj+EZvwslg0oIVNGQfv58zGR8JHPGTR
         FZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756168814; x=1756773614;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGFfEAOpmCnYuTpD1Fkefs/dVeGZ0wTmpw3Bli3LbeI=;
        b=Cd4x8JdgBd1MgzWByl9tRV8+8kSwUcPDGwnN2QvhwgQ46x/ZrbnRG9ebFaTZmNBpTO
         FuggEawQ48551Vt3N38CnQB+/X7Wv3KvqpJ/T7jNKRC+yimSP4O5NvKNYl3iU+asKbZE
         hW16ZhuWzvQAudJLTgdl9Yw369uVozW3ZOrqSANXfh6ga27HUfpHDNDl6jcl48b5TCJp
         czMoX/8N51bmQbC2Y/EIb6i9ZcICEe9HNUdRuRzeEXq3YRpWMiKk0LS1YcSW83AjvZ3t
         bWL4UxNy/52Ndjl93GjA2dx522GpuMV4aSYpo96EhE59gacQCEhjbUqr7xsrwaNCcHfb
         IxaQ==
X-Gm-Message-State: AOJu0YynWmYpO56qPBxDtJufjMJABDcIKr2J32UJshMmWi3VnpTJYoM0
	ClucOiVqhRnGUEMlo30CS9FfpHvvSJQ3SDWaMICZiwq5ENJnwVZr0iaWaKiOV2X2tGeLqa384C7
	ec13Y8w==
X-Google-Smtp-Source: AGHT+IHK1NCtVV/uARgx2pzXRzDVXR83QkBAFqL6vl11EOqC5SFFLlVBCFYJmnq5S7TIzbHzRbowBd1bBwU=
X-Received: from pjbqc3.prod.google.com ([2002:a17:90b:2883:b0:312:dbc:f731])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2811:b0:323:7df8:6eec
 with SMTP id 98e67ed59e1d1-3274620a008mr515983a91.18.1756168814547; Mon, 25
 Aug 2025 17:40:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 17:40:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250826004012.3835150-1-seanjc@google.com>
Subject: [PATCH 0/3] vhost_task: KVM: Fix a race where KVM wakes an exited task
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Fix a bug where KVM attempts to wake a vhost task that has already exited in
response to a fatal signal, and tack on a few cleanups to harden against
introducing similar bugs in the future.

Somehow, this only started causing problems when commit 56180dd20c19 ("futex:
Use RCU-based per-CPU reference counting instead of rcuref_t") landed.  I have
no idea why the futex changes exposed the bug, and I don't care all that much,
as this is firmly a KVM bug.

Sean Christopherson (3):
  vhost_task: KVM: Don't wake KVM x86's recovery thread if vhost task
    was killed
  vhost_task: Allow caller to omit handle_sigkill() callback
  KVM: x86/mmu: Don't register a sigkill callback for NX hugepage
    recovery tasks

 arch/x86/kvm/mmu/mmu.c           |  9 ++----
 include/linux/sched/vhost_task.h |  1 +
 kernel/vhost_task.c              | 52 +++++++++++++++++++++++++++++---
 3 files changed, 51 insertions(+), 11 deletions(-)


base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.51.0.261.g7ce5a0a67e-goog


