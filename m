Return-Path: <kvm+bounces-41427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB3CA67B95
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DD2D189129C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E06C2144B1;
	Tue, 18 Mar 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p0m3NHmU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA3121325B
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320999; cv=none; b=YXDKMRi4TwGXl24hFZzL27fiex4aymPBvlVGTJTmQ9v3Lzs3MJMEKqjxBIjC2gfnfM44OoIxvvu62CWx9YO1Ea2YOFQY7AENWApFcu4cR7a6ePbwE+dYjT19vpSgQrFyjlMlze7xLAWar/T6QJuvjIyiTK7ffXfIZ5i04iJHoCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320999; c=relaxed/simple;
	bh=D2Vl0hjvmprdSsP8sLEgp9rXOfSsss492r6Pga44mc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5lXs5aWohR/SLtbXpHbfbRFFGmAkWOxXcvw36ORXAplCBPVKxH8r1E3kJX/AuJ9fyKGzPcyUlmDFLgi7Lq61VvYE7iQrwUt9TCsLJS31B0gCPUCgfmx45Z3ELEHyEH+FtZBPROXCJtz2EJ9SD3exwUS0pTSZCYOlHQb+Kv6O8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p0m3NHmU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224192ff68bso86800085ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320992; x=1742925792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B/BIFgYVh0LKqAIlv/WzNNj3QrJU16cGXK8ptGwEd38=;
        b=p0m3NHmUUis+/95Ku+oHrYD4lWZSSIkOLRHW40dwHyl/bTw559Nn/gTzOLoLFF4znf
         TTrpv+8T2yhfENjdguivsgDhxXaEBtR4HmpO2zWyb+gbsjivyKY5KM9k76UtO9e94Zmy
         2UHTY2KsGB/wR6v1AkGdC5NEKgOgu6h10avd92BypeXcAJhGrxRMGLo8WjkeihgvGcoW
         RJAk6TM9amKOBWm6Svlx3vtAljJpieKjZ+AcaJviInIEINNpZ3ViruICpkOg/piNgqTD
         sucLX5K5wFyeYgpihXU/c5dh+2DEyr1qtq+M7V1vJf2TWcTVwOwcioSvSwNTCeHktBFa
         qLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320992; x=1742925792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B/BIFgYVh0LKqAIlv/WzNNj3QrJU16cGXK8ptGwEd38=;
        b=QvLXaC5RU+O5f+k/Ea6iOEdiWz9bgFXrkQQEOQ8T/w9z7WR+KmmuMQhFemo5V/S81k
         hdvXhKsDrGFfzBoOlB6Jjv32KiOwDS50oe2fS/d4Ved9x+F7DkBs+egmud6cxjZKc46h
         9Jxyucdpm8cjBnr0j41bsRmqAAvCLWfjYslQn2XL4+qOl+Z6G4PWwmb3Q8cM3lYt9ver
         8u5jVDqesFfVLW9l4YR+XEmOiTdejpSkd+19bHorMmdET2oOCeqRyfX83HG4p7MJnIOd
         cW0qSJgaUjhEitD8KoKy3NdTJLfRA/AbXbWv6EH7aP0vIsK1yLsb5Yhi2X2Igm/WY7L6
         a8iw==
X-Gm-Message-State: AOJu0YzcfPxBbx9WNpwfhsB074pGP/2Z+49ldQM85j7eGIUHGX0g7vrx
	weDc1SwVCRZB4FDNmDhTTCdMkES0xdalS+SwS/EFx3oquro/Vjopb/WM40TXYyKp2XztwmXNalr
	j5g==
X-Google-Smtp-Source: AGHT+IGzOuilgyAVAxs/CJ+xQoOlaZHr1Qi0K1UT//neS2shFy705WLzEyBiiaDpPFP5dCKHstVWSzHEpno=
X-Received: from plsl17.prod.google.com ([2002:a17:903:2451:b0:223:432c:56d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:188:b0:224:1d1c:8837
 with SMTP id d9443c01a7336-2262c554bc8mr61354805ad.19.1742320992644; Tue, 18
 Mar 2025 11:03:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:02:58 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: PV clock changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a variety of bugs, flaws, and warts related to KVM's handling of PV clocks
and the associated PVCLOCK_GUEST_STOPPED flag.  Note, there are still a pile of
issues with KVM's PV clock code; hopefully the next version of those changes[*]
comes along sooner than later.

[*] https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pvclock-6.15

for you to fetch changes up to 1b3c38050b5cc07f6873f244f845fb6c8549ce85:

  KVM: x86: Override TSC_STABLE flag for Xen PV clocks in kvm_guest_time_update() (2025-02-12 10:45:55 -0800)

----------------------------------------------------------------
KVM PV clock changes for 6.15:

 - Don't take kvm->lock when iterating over vCPUs in the suspend notifier to
   fix a largely theoretical deadlock.

 - Use the vCPU's actual Xen PV clock information when starting the Xen timer,
   as the cached state in arch.hv_clock can be stale/bogus.

 - Fix a bug where KVM could bleed PVCLOCK_GUEST_STOPPED across different
   PV clocks.

 - Restrict PVCLOCK_GUEST_STOPPED to kvmclock, as KVM's suspend notifier only
   accounts for kvmclock, and there's no evidence that the flag is actually
   supported by Xen guests.

 - Clean up the per-vCPU "cache" of its reference pvclock, and instead only
   track the vCPU's TSC scaling (multipler+shift) metadata (which is moderately
   expensive to compute, and rarely changes for modern setups).

----------------------------------------------------------------
Sean Christopherson (11):
      KVM: x86: Don't take kvm->lock when iterating over vCPUs in suspend notifier
      KVM: x86: Eliminate "handling" of impossible errors during SUSPEND
      KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
      KVM: x86: Process "guest stopped request" once per guest time update
      KVM: x86/xen: Use guest's copy of pvclock when starting timer
      KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across PV clocks
      KVM: x86: Set PVCLOCK_GUEST_STOPPED only for kvmclock, not for Xen PV clock
      KVM: x86: Pass reference pvclock as a param to kvm_setup_guest_pvclock()
      KVM: x86: Remove per-vCPU "cache" of its reference pvclock
      KVM: x86: Setup Hyper-V TSC page before Xen PV clocks (during clock update)
      KVM: x86: Override TSC_STABLE flag for Xen PV clocks in kvm_guest_time_update()

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/x86.c              | 115 ++++++++++++++++++++--------------------
 arch/x86/kvm/xen.c              |  69 +++++++++++++++++++++---
 3 files changed, 121 insertions(+), 66 deletions(-)

