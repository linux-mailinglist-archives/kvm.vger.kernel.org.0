Return-Path: <kvm+bounces-55408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AEDDB30886
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A65A1D01B17
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B883A2E2658;
	Thu, 21 Aug 2025 21:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y7LajL2k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747AE2D94B2
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812533; cv=none; b=ZrzahmSKYuuW5RB2Qg9iTe28lcVeeJMBtedseLu/FeAfd6v6kKHyPI5rCgHYF08uKstEOassPxTfegAnSDu76GCSltGIElP5TzUWqVTmugawEnN5mqZ4hdGjxKGexEOnjD4Hj2iEMQwuPTjkHoyCUmu9nlRZW2Tk+WlzkjrS4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812533; c=relaxed/simple;
	bh=6d1NpiY6CNirwuB32iXKvxQgeJfaKGkzBRWT2zfaawI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JM6Ej/fdfqv88vV7mQlY/riSQnT05EYClDqZWJ3A6fhkqvzTPNYBYqbMn3vSymx18emfbLX5YtMmQ/kJk3Ap6rLnFknzy4kjwlKI4LWIYlThdoTZFBllZdzOeqcJzje/qhbYwd4dmiQAHqO4+jVSuO7RfimPh6l9xuKn4HIalTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y7LajL2k; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e8e28e1so3692664b3a.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755812532; x=1756417332; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGTtMfRs1p1LjrrRqCwfiI7lq7kQ7leeLunUyA5zoU8=;
        b=y7LajL2krZ8PI2jXkmu+5c1UJRQN9QUb6SiJunejVH9kHz8N/6sFIK+MeTp8deZbTO
         fOtBN/r3KErHfRlhKutvb0EoQesh8Um62KsRXb3lw0jAFPRB1WA0lmZ2Vl3N0MDerQwE
         /y7+YW37RyChzi1VJiqMdpYFuaJbC2s3uATki1Q5GYcah98PPctNALzO14iX0LGL1+OG
         8CnfPpPm4ouh6binYaOPynfHbKvJ2UK9iodSav0lX+MzqBanyRUErFVIXAfEcJYP0Jg1
         m/pBvSWsMW8f78qjfpcz+kvUSBaUD8G+JPXW86j1DWXhGvJEHuUXocFh8fX1VWEC1f+r
         1w6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812532; x=1756417332;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RGTtMfRs1p1LjrrRqCwfiI7lq7kQ7leeLunUyA5zoU8=;
        b=UYBPWxavex33B0wVYlGPCV9D6379voeUdeEgbFBmq7ZajorlhEBnfjqFSBLYZexMir
         Lj69pYfu92wwB3XsiUTrHcH8oRf4Ol2MVK2NhQn7YjCysk0HZir0jrHs7QDX6Ti+CqCq
         BpmpYJkI+dNlf9+bXpy9MGvvLOK8Hvl10hQl8qaRrdrvDEYuhBa92V8WRksguvvxdy89
         m90lQlccGPWHo7F9ZZNRCujL1G+2itGeTHaS4yh6zC1SwDSAm/lYdNF34rGDAaVmD3kV
         toIjRDwcD7TODExJ7NPLAJQrxO5l64lXcAYeBrqh6tIqMIsqSgp2wZyH+VwVn07QHniI
         u5FA==
X-Gm-Message-State: AOJu0Yxsc+hv0lT/dltHEkEnJVRwovQP72vTReB5EarL4kzFT6Zye0Ls
	11aB1OjafcD3K6kdGtgCmq5DyXIPjWQgDLB8PkMjKBpyAy4cR6M0CGndUd9Of9US4AmhjC2cHhd
	dsNXU+g==
X-Google-Smtp-Source: AGHT+IEpQ1Sa00N5Sn1QccLk0FiJbYdI55Nqdbds78TD5OwaESH9bS6YdHtt687v4M01z1fED1O7DkwOTSA=
X-Received: from pjbsn7.prod.google.com ([2002:a17:90b:2e87:b0:312:dbc:f731])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1584:b0:240:cd6:a91e
 with SMTP id adf61e73a8af0-24340b0ed25mr1001848637.20.1755812531857; Thu, 21
 Aug 2025 14:42:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:42:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821214209.3463350-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86: Clean up lowest priority IRQ code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move some local APIC specific code into lapic.c that has no business being
exposed outside of local APIC emulation.   The lowest priority vector
hashing code in particular is *very* specific to lapic.c internals, but
that's not at all obvious from the globally-visible symbols.

Sean Christopherson (3):
  KVM: x86: Move kvm_irq_delivery_to_apic() from irq.c to lapic.c
  KVM: x86: Make "lowest priority" helpers local to lapic.c
  KVM: x86: Move vector_hashing into lapic.c

 arch/x86/kvm/irq.c   | 57 ------------------------------
 arch/x86/kvm/irq.h   |  4 ---
 arch/x86/kvm/lapic.c | 82 +++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.h | 12 ++-----
 arch/x86/kvm/x86.c   |  8 -----
 arch/x86/kvm/x86.h   |  1 -
 6 files changed, 77 insertions(+), 87 deletions(-)


base-commit: 9c7a1f8d8784e17bb6e0df4f616fbd8daae02919
-- 
2.51.0.261.g7ce5a0a67e-goog


