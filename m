Return-Path: <kvm+bounces-13771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB86989A7A3
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60FC51F22CBB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6B0381BA;
	Fri,  5 Apr 2024 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTTqibd0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF5C3715E
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361370; cv=none; b=EHo2E0JEySQHCGvby4dIyK87+14bbTn99z+HZa3iLLmIIRjqGgX1kT3XMsQcgBTWQs2UxE8SSuHKwFqHdrk4reqlDijQQkTVkeZ7VX3EgYpyanTd4/cRB+VJfy3aj0CV9Q/eKw5eAfvv08mt21aYBR8u4fhvnmK/4b/9WR6UGbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361370; c=relaxed/simple;
	bh=AccG0MiuF1gaQ/tlNrC7daiT5+/cGUIsCHnIXxtCfA8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WQJt+GZPdt5I+a6eE7G8NxfXhgH3Rr36aXIVkupyWsg15fQOszwAhXuaZ7R1EgYkMPRuFypXPSGnkvBYhkC2fDneGwun16fcYBxZc/UyDbuHF7xvtEuMANsZPL2zfIyKlwxul6YRDKI/otZSnmS1gx6QokBgw7rUNnJilVWE+9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QTTqibd0; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ea80a33cf6so2376059b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361368; x=1712966168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ks+8RAw2AVd/RYLtBLu22q09dihoe7Q9j5ZsJkIm8XQ=;
        b=QTTqibd0im7q5c92/z0O+PkQxGfosAjZmQznaBWrfNJ+2tDxJ6VcwyGyYzJODZSLX3
         PmOT7Nb39IaJLCZVzONDx2fIQENazh7KL8OynWaegS8/1g6CcjFU5nj4agyxpxwvMrok
         5lknVvpadmi1d9vZdnAUvp7sfcDcWS7JO9f/98N7L7BpIG8xMD6h5xdKIXEBmMjqbQD+
         wfoGLGT3lWWaNKY2Z6duzjUmNzZyPuMr6cUIJ1Beu9cWXtT7gAW0i39syREJjI7VDghM
         n17bnlUKeTuHLKN5ok72zP8l0kWCM86A+pqns8+c/pz0oA+WaMAoKEyBeT78+Orw7mXW
         E2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361368; x=1712966168;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ks+8RAw2AVd/RYLtBLu22q09dihoe7Q9j5ZsJkIm8XQ=;
        b=f9Naf9npGFz9dcws024iM1qhHO8rmCdLaUory5Wy+hYWGLQNi/vuIbD8/bi3zuE1n9
         Hepur9y+daWPUl73Wn1DXhRK5Lr+ur/ZfKybHx1/gOlvu4Nv+shwPrgL9xXbhoHlTtX5
         2R+c8gEHogyBZG+qdknBUYDqyqK4nyTkIChxBDVoE/Aa/Yy0Q0PjFMd4M3KxvxFEwuiO
         CILNq3shMLnFgX3grxcGXS7D8H8CyOjZHt4bzGi/e+2mRmgEcpgjRsJKfiL5FG++zXXW
         ThHPUl7GYZPBZBD1FtVHgi0jmrW2uk3IpyjJarlQSr4z6YyHWhsL0sjAwi+StUOF3FeO
         ANAw==
X-Gm-Message-State: AOJu0Yxfv2Aq8Rc2jLUOsMSkWrmeO8NJ2KzPYgPEVdpDCpkJxhN2qh5Y
	sbJxyJytZUacew1TbDj4Bmaho9UE9SwwF4K4ccB5LAoJDTgPwpgxKBHs8ARwT2rqc0FGdYdZlgb
	J8w==
X-Google-Smtp-Source: AGHT+IEv1Z/LGB9K0Ramp9Ut2hpjJVb2wlxWWFeYPrwmlwqzFmyiKeOqKlgmEwntGgpWSLYljFkVkrxidsQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:188f:b0:6eb:3b8d:dc9b with SMTP id
 x15-20020a056a00188f00b006eb3b8ddc9bmr368324pfh.3.1712361368118; Fri, 05 Apr
 2024 16:56:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:55:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-1-seanjc@google.com>
Subject: [PATCH 00/10] KVM: x86: Fix LVTPC masking on AMD CPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

This is kinda sorta v2 of Sandipan's fix for KVM's incorrect setting of
the MASK bit when delivering PMIs through the LVTPC.

It's a bit rushed, as I want to get Sandipan's fix applied early next
week so that it can make its way to Linus' tree for -rc4.  And I didn't
want to apply Sandipan's patch as-is, because I'm a little paranoid that
the guest CPUID check could be noticeable slow, and it's easy to avoid.

My plan is to grab patches 1-2 for 6.9 asap, and let the rest simmer for
much, much longer (they are *very* lightly tested).

As for why this looks wildy different than Sandipan's compat_vendor idea,
when I started looking at KVM's various AMD vs. Intel checks, I realized
it makes no sense to support an "unknown" vendor.  KVM can't do *nothing*,
and so practically speaking, an "unknown" vendor vCPU would actually end
up with a weird mix of AMD *and* Intel behavior, not AMD *or* Intel
behavior.

Sandipan Das (1):
  KVM: x86/pmu: Do not mask LVTPC when handling a PMI on AMD platforms

Sean Christopherson (9):
  KVM: x86: Snapshot if a vCPU's vendor model is AMD vs. Intel
    compatible
  KVM: x86/pmu: Squash period for checkpointed events based on host
    HLE/RTM
  KVM: x86: Apply Intel's TSC_AUX reserved-bit behavior to Intel compat
    vCPUs
  KVM: x86: Inhibit code #DBs in MOV-SS shadow for all Intel compat
    vCPUs
  KVM: x86: Use "is Intel compatible" helper to emulate SYSCALL in
    !64-bit
  KVM: SVM: Emulate SYSENTER RIP/RSP behavior for all Intel compat vCPUs
  KVM: x86: Allow SYSENTER in Compatibility Mode for all Intel compat
    vCPUs
  KVM: x86: Open code vendor_intel() in string_registers_quirk()
  KVM: x86: Bury guest_cpuid_is_amd_or_hygon() in cpuid.c

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 13 ++++++
 arch/x86/kvm/cpuid.h            | 16 ++------
 arch/x86/kvm/emulate.c          | 71 ++++++++++-----------------------
 arch/x86/kvm/kvm_emulate.h      |  1 +
 arch/x86/kvm/lapic.c            |  3 +-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/svm/svm.c          | 14 +++----
 arch/x86/kvm/x86.c              | 30 ++++++++------
 10 files changed, 68 insertions(+), 85 deletions(-)


base-commit: 8cb4a9a82b21623dbb4b3051dd30d98356cf95bc
-- 
2.44.0.478.gd926399ef9-goog


