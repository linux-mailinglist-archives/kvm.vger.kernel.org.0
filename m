Return-Path: <kvm+bounces-42370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE1FA780B8
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF1FD1666AC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AD620DD5C;
	Tue,  1 Apr 2025 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NcZQotf7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFA09461
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525795; cv=none; b=ROlB5rWhg1rouc/32bDSvwKRtYv4PKzBPGFQbkn+WmKiWm8V7ssIWpQQ8YelaAcOdYfQkTA0mL/JjP0ezY4FDWPglgNQC1KI/y8l60B1Rs8/mweuG5vjw3Fx1j6UJtlL3YJHqyYtX3qRIaolxrF57ay/mYF/tTtISEC/Dg4iJpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525795; c=relaxed/simple;
	bh=M2TWGxm2NnULLddMhVhPkqPLLNeRUG1H8C4s84FThmU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jjEA3ScKukIeTsowX0us4TlauRzASWblES/4e4K8pq2U31KlI56KUEQaY31/tRHz1vXUFdx0fwMnQ1Kj5C9AUSVxMFq3XBqTdR8rleNlLQCT1tAJjoGfC8jx/AufToMS2/RZCcfAB7u+vHQ96q1W7K/5vpqXN1yCeelYRuM5JwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NcZQotf7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2240a7aceeaso106659045ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743525794; x=1744130594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUK/6WGgSJ/C4fjzbbO0q/5WO+lyppJyX3j10SVag1Y=;
        b=NcZQotf7j27GUQOvVdAb/vG8T6lvb5ReHuVA1DeI28ozGxYYzoymTG1AoW20OlTYa2
         ceVgq3d0CHQ5f+3byczq7H4is0bz8LecbGZ626idV4E+hYrCVgOSH91W6nD7JeGUhNXb
         BWP7ssORJE8aeYxjrkKjW9/khxPLuol4b2GYpZhrlQjnlNNcOXKAF0AzNzr+xD4GBHW4
         GCMPk0wR0iH0VW5H3gXft7QZ5AaTQ1ediHQ48FEugQ0uuCXxedKvvYPhvHiv+VlvHpVD
         SpmVaHhzcmpfL3b0TljmEMnUGBOmJ7CH71dOU6iamm7/j7ptxX2rtm/a606yanCwJzZU
         75qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743525794; x=1744130594;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WUK/6WGgSJ/C4fjzbbO0q/5WO+lyppJyX3j10SVag1Y=;
        b=ik5N08FoN0OCZ9NPuNN5YMI/ssVMpbZdiOnd3dKayRcPw7sv/UI/Q02s4xyUf6GXbX
         DyWky2M45piBEwWyis65vdsNmCv2OI7rQK7ZX9JSD/hCROzSsRFQUaC7O+QU0hVL4QZY
         wQIB7GRy+wO+rJtPN51lbNYYJEdakpzrbU4OvgYFGldiUVk/iAeNZgsmjCZwc1VPk5lk
         pIoMozHfl1jl5vsjN692aHuikKXxGIjMQ186F0edr5CNeG/+t8unq5AiT/SfZKsL50XK
         TTQL884ClYfkCm3mDoN4Ay8FB+LoFF6m1dXhFuM0F9RDik1QW2jI6Bbq2ZodLF1yVOPG
         TfPg==
X-Forwarded-Encrypted: i=1; AJvYcCX0BoCSRcxSiw2xluoL/DXMUBfJvjvYmvz/kXCPmM+FmK7x/XshNog9RFHenV4W6ihn7c0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA+2OkrfZzu1//ATSmYxJXezKlAnDJIzIXv2Oog4G3LcPVxrP+
	BsIWjflsxHYCDqKxb+czbPGESncqdlEgUCMh12ZmVZCG2S3hFBR2J7nWZrAatZO0JpRdrG8s4pj
	r1A==
X-Google-Smtp-Source: AGHT+IH5cSz/o1O5v0jybOuWyQZ2DFWw5DlZufPEuiMUgV19rvAjQSX5gNGvM0NBycvX5iYtLbhVUResHeo=
X-Received: from pfih11.prod.google.com ([2002:a05:6a00:218b:b0:736:79d0:fd28])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e541:b0:21f:3e2d:7d42
 with SMTP id d9443c01a7336-2292f9773b4mr180796675ad.23.1743525793742; Tue, 01
 Apr 2025 09:43:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:34:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401163447.846608-1-seanjc@google.com>
Subject: [PATCH v2 0/8] x86/irq: KVM: Optimize KVM's PIR harvesting
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Optimizing KVM's PIR harvesting using the same techniques as posted MSIs,
most notably to use 8-byte accesses on 64-bit kernels (/facepalm).

Fix a few warts along the way, and finish up by adding a helper to dedup
the PIR harvesting code between KVM and posted MSIs.

v2:
 - Collect a review. [tglx]
 - Use an "unsigned long" with a bitwise-OR to gather PIR. [tglx]

v1: https://lore.kernel.org/all/20250315030630.2371712-1-seanjc@google.com

Sean Christopherson (8):
  x86/irq: Ensure initial PIR loads are performed exactly once
  x86/irq: Track if IRQ was found in PIR during initial loop (to load
    PIR vals)
  KVM: VMX: Ensure vIRR isn't reloaded at odd times when sync'ing PIR
  x86/irq: KVM: Track PIR bitmap as an "unsigned long" array
  KVM: VMX: Process PIR using 64-bit accesses on 64-bit kernels
  KVM: VMX: Isolate pure loads from atomic XCHG when processing PIR
  KVM: VMX: Use arch_xchg() when processing PIR to avoid instrumentation
  x86/irq: KVM: Add helper for harvesting PIR to deduplicate KVM and
    posted MSIs

 arch/x86/include/asm/posted_intr.h | 78 +++++++++++++++++++++++++++---
 arch/x86/kernel/irq.c              | 63 ++++--------------------
 arch/x86/kvm/lapic.c               | 20 ++++----
 arch/x86/kvm/lapic.h               |  4 +-
 arch/x86/kvm/vmx/posted_intr.h     |  2 +-
 5 files changed, 95 insertions(+), 72 deletions(-)


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog


