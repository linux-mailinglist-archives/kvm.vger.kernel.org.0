Return-Path: <kvm+bounces-65438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4291CCA9C9F
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5ECF3148006
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DACC315D35;
	Sat,  6 Dec 2025 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sdVklTO4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDE13148A3
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981796; cv=none; b=ASDufPwOjqpe20Ji1wwzEBajr6LmrZgdrEOYIjfL8Cxfbm7AAD78i6fibqV5qeVauvreX7/EIeVzFsE9kemVdw9DgbgYASZuIdGhaxBH1DpK8IcsU+jQuVJ8zU0HOF4UZ6i//cUm9/E8WRuPruuL0lSAwKgAQicvPGW2IGBxFXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981796; c=relaxed/simple;
	bh=vxFL93WAY4zqIzMOP62KloH/LvPCv7AgmPTHoMKRYaA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=vA+0JnK6eyXXjW1CPZj3wdh91d65iSOr7zYHaxn4bno/rON98oUaOtTkJkyXAs5L1ZK0FJ+k16qaRdWrnPZ7kvICQKg6VUBFPbYTvNa+PYoeDm2KaJMzmyMERLXI07ZJTB1Xrhxum88NKUUQfIvJsYZCANDNOBw4roYSVr2fm1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sdVklTO4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3437f0760daso5076689a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981794; x=1765586594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEmwveQn6vdgc6heZsgyAqQ0ODAKxlyjenCFiDNwSDM=;
        b=sdVklTO43XrqDqEIYk1DxkaggJv5qn2GTPV50U99WBBgW0/GCXaqzbvsubcYpql4ZN
         6wG+zPWJmYm6IpKcyWDSBIB6FcS52Q2S8xX7bWX40w+FnnvVGKAapDbNnPHMBta9R6tY
         g+AFDwxxfkqpz8dqftDQ+S9LvwADgjLMKlT7FQF1LOGwnSsKrgYRgQjSMEz+vq2Z5sZA
         iPLVxmShRGEELNR81ldea/rGpHiyppvzpcSLE/mNhLDXjL9eQjTDLqjjdhEA0GKdLjDO
         AVPPf9DtLHHTHsbaM89+6zdyntuqiApaIW5Y1yRM7omoIeSQ12D3a4Yga8MX7K64fLYE
         JD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981794; x=1765586594;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gEmwveQn6vdgc6heZsgyAqQ0ODAKxlyjenCFiDNwSDM=;
        b=c39zJ3JkYev93QjWzj6BaTS3Go1Q+Jmt37ah2YnL/wyKWGDOY3iErou4yWwb/ZVt4E
         GVoNA544QJoqLAds7FEb26W4pHeVJngqcM/6642Z2800xiZ2lxnO1yqIqekUpwrAfc9L
         PhX7Fqv1pFzzOGOR1rpP7mFZIyASSqjdDXsJVKWhZ/4Ufonn5+b45iYF6ckh2NJVmqAU
         Wo+TlFeqUYodlOa287OqxFupYHlOxFhxupl1wtzf6zb8GnYEbhyn42WkLiuLaU9eqYRO
         H/z4DJJ8StCuuV6J/L/9nRbDreHKW4/+DS7oxjR1VaRT5bBM5zXZbMAltl9SlLFtYrr2
         +47A==
X-Gm-Message-State: AOJu0YwLtheiZoXBvLN0jq/KV/0W47eqo9K6xMafQO3XtPTYc8psv3rE
	lA9e21zGHBOvbtaOuqseWggS+hkuhKS6LIErUnaJKnmMElqqF7wDMVDpOseamRqz/8oGbDDiHoY
	vDxbX+w==
X-Google-Smtp-Source: AGHT+IGKcKsXYFiwDN9JH+Hs5XE4UIPLzuxuiGz/FY2mBLL65RU4QZMj4yDQ4Ex+8n9vlupd0eVKk8b7I8Y=
X-Received: from pjbbo14.prod.google.com ([2002:a17:90b:90e:b0:340:bb52:b060])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e11:b0:330:6d5e:f174
 with SMTP id 98e67ed59e1d1-349a258d6bbmr787826a91.20.1764981794460; Fri, 05
 Dec 2025 16:43:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-1-seanjc@google.com>
Subject: [PATCH 0/9] KVM: x86: APIC and I/O APIC cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop a bunch of _really_ old dead code (ASSERT() buried behind a DEBUG
macro that probably hasn't been enabled in 15+ years), clean up the bizarre
and confusing "dest_map" pointer that gets passed all of the place but is
only actually used for in-kernel RTC emulation, and the bury almost all of
ioapic.h behind CONFIG_KVM_IOAPIC=y.

I'm not entirely sure why I started poking at this.  I think I got mad at
the dest_map code, and then things snowballed...

Sean Christopherson (9):
  KVM: x86: Drop ASSERT()s on APIC/vCPU being non-NULL
  KVM: x86: Drop guest/user-triggerable asserts on IRR/ISR vectors
  KVM: x86: Drop ASSERT() on I/O APIC EOIs being only for LEVEL_to
    WARN_ON_ONCE
  KVM: x86: Drop guest-triggerable ASSERT()s on I/O APIC access
    alignment
  KVM: x86: Drop MAX_NR_RESERVED_IOAPIC_PINS, use KVM_MAX_IRQ_ROUTES
    directly
  KVM: x86: Add a wrapper to handle common case of IRQ delivery without
    dest_map
  KVM: x86: Fold "struct dest_map" into "struct rtc_status"
  KVM: x86: Bury ioapic.h definitions behind CONFIG_KVM_IOAPIC
  KVM: x86: Hide KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=y

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/hyperv.c           |  2 +-
 arch/x86/kvm/ioapic.c           | 43 ++++++++-------------
 arch/x86/kvm/ioapic.h           | 38 ++++++-------------
 arch/x86/kvm/irq.c              |  4 +-
 arch/x86/kvm/lapic.c            | 66 ++++++++++++++++-----------------
 arch/x86/kvm/lapic.h            | 20 +++++++---
 arch/x86/kvm/x86.c              |  4 +-
 arch/x86/kvm/xen.c              |  2 +-
 9 files changed, 81 insertions(+), 100 deletions(-)


base-commit: 5d3e2d9ba9ed68576c70c127e4f7446d896f2af2
-- 
2.52.0.223.gf5cc29aaa4-goog


