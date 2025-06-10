Return-Path: <kvm+bounces-48866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6879AD434B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DB6D189CA67
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BED264FA6;
	Tue, 10 Jun 2025 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SpihRTup"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023DF264A77
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585261; cv=none; b=jdeN/1g1u7zvzSdTOO2o/g3UMuwfM9QMGmIv2mFhS8AAq4l1WhyJQUJuvx5tgMfs5ftC66yjR53u6JbkYmYJ2vh3xG0j1+yBfTZWIUzWUTAQZ36KTfC09AqycLGEr/f9Th8drsUX+seYrZ42ea1vUOdHjvU9VlZQbSFF0Oh3qYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585261; c=relaxed/simple;
	bh=uy4rlK6TzsSoYe+4CTyLlmHmEmnXx4TCtg/vbLXtO08=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lC6XLykKhHiB17+3RnpTMT5JLrIs2mOueRItIurTp0SZWJ218FHhJeQ6qlCDRkEp8Q9Gsi/Gtjcl2IBQVRqF53s6QtrIAHLwfwyLDW3U0Q4U64quPtttRG4zDq9bX5mo/2L2PPpLKcz65NH631/9vdZR9dcdlBOIwO89YuSkTzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SpihRTup; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso6799598a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585259; x=1750190059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdUg+95Zgvn11Ky+VyoA1/FSqgSPughYzEnbMWAk+FY=;
        b=SpihRTupFpg+0Z4I+8UqSvE2810v0e2jP4+e0kWfYB5eLlIVAybOyA/6w4IY4DCvWI
         X0hcjjcYBW9W/8LCAcuqrh/UCAI+MIFTMQoLQGdm2lQ9Org31mCpgbpx0M8bWM39IcRD
         2bo6xxM3yB030gWMMzgHbhGHrdy712MeDFw3nKSiCqpOe3SVAJVVcVlutiN/iEafKXBk
         JP0pZclox9z5e45XiOlM4N+hq2kXhlvPxTGHtBWVWcxeA1BLvrBoUgJMkiCdibznQFsQ
         4vblP5ytSjxuxDl7rNQ5nP2Ziy9A2PC6xmCq48SxSK6HoowSR/i+fagIQJNMJ++jeWkf
         Cmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585259; x=1750190059;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xdUg+95Zgvn11Ky+VyoA1/FSqgSPughYzEnbMWAk+FY=;
        b=NT0roZZ6TcVUxCM2/Xg2YDD8eybrs4FQ+SMQ0Y0JVuqT/ZcEovzwRXQIk3w07E/GMg
         1K4cVdVEKrhwGAZma4n2Q4LTxwYYvA6fIUWUb7YJmoo56b/4JNH+lLbPgaR5hNvfccZj
         geWttJ2NgmmZPnLCO/MntcJWw7UQcz7E8kBqmPs4fI9JRc01YrSaldsYQy6rSNfbHE6P
         wHd5awa+5yDP/WxwOx2bc96aynMmzPsECDBG0bo43NMS8WzvVsv+XGj1HpSDSy2k4t37
         S1OOsVlyzUHY8FQ3RBONMZlj77yeZivTmVm0qtgGvEIOJdh6pvE11kVZl37zDKWpP+XB
         D4hg==
X-Gm-Message-State: AOJu0YzUutUDvZbhXv2sAzdWoHtSZq4IUysdVyIoZY1M4GLhvVBWnLBd
	zfg3ini6SAr5YpzVwZ9XmLifIXgLCWY1DHUrgdBF4NGyd4BqQuWngChXGSi4at8n8QKbNLV4zw8
	Vabl0XQ==
X-Google-Smtp-Source: AGHT+IF3ceX4pCOgzF4a4Qxb6moLAuEDwBsCqt6CWEiT2/sSaOs6K5MohSgcOTIcv9yK/VPfOzSn5c90kAQ=
X-Received: from pjbqo14.prod.google.com ([2002:a17:90b:3dce:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da85:b0:312:f88d:260b
 with SMTP id 98e67ed59e1d1-313b1f09e36mr15451a91.14.1749585259079; Tue, 10
 Jun 2025 12:54:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 00/14] x86: Add CPUID properties, clean up
 related code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Copy KVM selftests' X86_PROPERTY_* infrastructure (multi-bit CPUID
fields), and use the properties to clean up various warts.  The SEV code
is particular makes things much harder than they need to be.

Note, this applies on kvm-x86 next.

v2:
 - Avoid tabs immediatedly after #defines. [Dapeng]
 - Sqaush the arch events vs. GP counters fixes into one patch. [Dapeng]
 - Mask available arch events based on enumerate bit vector width. [Dapeng]
 - Add a missing space in a printf argument. [Liam]
 - Collect reviews. [Dapeng, Liam]

v1: https://lore.kernel.org/all/20250529221929.3807680-1-seanjc@google.com

Sean Christopherson (14):
  x86: Encode X86_FEATURE_* definitions using a structure
  x86: Add X86_PROPERTY_* framework to retrieve CPUID values
  x86: Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical()
  x86: Implement get_supported_xcr0() using
    X86_PROPERTY_SUPPORTED_XCR0_{LO,HI}
  x86: Add and use X86_PROPERTY_INTEL_PT_NR_RANGES
  x86/pmu: Mark all arch events as available on AMD, and rename fields
  x86/pmu: Mark Intel architectural event available iff X <=
    CPUID.0xA.EAX[31:24]
  x86/pmu: Use X86_PROPERTY_PMU_* macros to retrieve PMU information
  x86/sev: Use VC_VECTOR from processor.h
  x86/sev: Skip the AMD SEV test if SEV is unsupported/disabled
  x86/sev: Define and use X86_FEATURE_* flags for CPUID 0x8000001F
  x86/sev: Use X86_PROPERTY_SEV_C_BIT to get the AMD SEV C-bit location
  x86/sev: Use amd_sev_es_enabled() to detect if SEV-ES is enabled
  x86: Move SEV MSR definitions to msr.h

 lib/x86/amd_sev.c   |  48 ++-----
 lib/x86/amd_sev.h   |  29 ----
 lib/x86/msr.h       |   6 +
 lib/x86/pmu.c       |  25 ++--
 lib/x86/pmu.h       |   8 +-
 lib/x86/processor.h | 312 ++++++++++++++++++++++++++++++++------------
 x86/amd_sev.c       |  63 ++-------
 x86/la57.c          |   2 +-
 x86/pmu.c           |   9 +-
 x86/xsave.c         |  11 +-
 10 files changed, 273 insertions(+), 240 deletions(-)


base-commit: 0293b912a7e7c019ed0144ad9ee62c09b0b61de2
-- 
2.50.0.rc0.642.g800a2b2222-goog


