Return-Path: <kvm+bounces-48013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D60CEAC83FE
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C4E53BA1B4
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BC421E08B;
	Thu, 29 May 2025 22:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cHf1GyFw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4721CC79
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557182; cv=none; b=tmW0/0u7gL1Zu+ZbrD4GZRfsUg6zqrkbkaPqX+Q8Fw9e8Wx82lMQ0eN6IZsCQBgd7Sph9mcDYz+OxOUu1XxqyvJFfEV02VVzOFT7AwuoubEHrT27D8qme3mFavVDsLg0UbJbQWIJ7N75qB7dAqTXrc7eKVzFCpCKWzNP4xpiHSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557182; c=relaxed/simple;
	bh=KbEcLrZyNHW1ZbQGmI3ZdoR7aGESto+rOYcZmQV/p0Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V/OgvD/CtQ5C5pp1rjfhRpn7mKuZ8YqbTvJqflvcMFjw3gqbEnR14TEBxr4/e8MYYAEXaaggmyzhlX2fL+1jTyHdyqHSNmE4vyusMHkeBEax2U1BQSdO3aF1CTArPPdJGXmu85Ep8LWl6iKCwUqiimY0BpZG2lrbxWGUXrDDINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cHf1GyFw; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22c31b55ac6so20000005ad.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557180; x=1749161980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WiZvL65gJWBhQxETywMJkkZAmvBLGCJuVJmqPemzNU=;
        b=cHf1GyFwbCd5C9NXoLSQgJ/4YjvMkijMTzk6+b4gDCRwaoNT8cb2P0LoMyILiyfpB/
         DQxAUKVX6dubTGXlCu0o14T5X11EqbwPXxRSDiIK5AxOU/Y0cDB9qxZ08bXM/lR2r0dy
         1qvxXe4+kUCI1RJ7EcwKRKTrv81NqGXnE1zHbZQUNVcIhk9UYgsWntcZC1UPk/13sxvb
         GAArsjiGvqKMflFZDoQ5EV0FzdC7vckKYJykLZrarUWHR3eW6CLieP+/NCiqRiWRHyW2
         m/6RIN4Gm9S7M/o156MhipBwyQuzxBKL8FI6rXQFKBs2Y6DdLjz1XjWlb/nC0PPq05Fr
         VwGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557180; x=1749161980;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WiZvL65gJWBhQxETywMJkkZAmvBLGCJuVJmqPemzNU=;
        b=IsXPIWE+2XIhXjpMvoHJ0Cue923dzfHfCHltAePmdrWoRP8vw6ZEenR/pile+zAJc+
         eSzQBNaRqRen6So7nJO9l4yxQFBLEQyIPgwpDFT9tkRkHAxrqGSBsLAw5xrVQ1wyLyG8
         BsDUNBrgVPmgRw5DUdjhBKvih3AXF6yOOtCoYfENeS8XTzd+Vkj8+Fk1obBM4MVhtEZI
         2eMd7BkR2APygXvbTV5/dUgPya2AmhJnyc3ohssEinL3gGPci3XgE3Cy2HTeNL6mdyIx
         02hIuEnqqSRHI15sLU2yITz3vXQkGDKpwZ+nAzxnL4YRFUR+fIvdfKdsxWAAmW6Ltd65
         OzFg==
X-Forwarded-Encrypted: i=1; AJvYcCVs1mDH+MQlm583DMsCt1nwzpW7KE8gEDj6f67v8MoQ98XUGFAuEyqm5p2CADxtNcei/v8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxziIgqWUkMFC4fyaq/Z4ctTkkyQtoc5i/4SrhUcjusFriiX83j
	JBQGffuudLeA54ufTKeoFxt6JAc2YysNjfiTbJ0bPyEdEAv/OuXelC3RDEj48LCzovZhlAckObv
	+m1YwnQ==
X-Google-Smtp-Source: AGHT+IE/KnIFPcTR33Ni+A0ag2QlB6J3OqTksKtrH9lZLuske3p06HrhdBLvdwE6B6sOh/7FJilM1pbp4Qk=
X-Received: from plhc1.prod.google.com ([2002:a17:903:2341:b0:234:d7c5:a0e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19cb:b0:234:f1ac:c036
 with SMTP id d9443c01a7336-23529a1357amr17181895ad.50.1748557180372; Thu, 29
 May 2025 15:19:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 00/16] x86: Add CPUID properties, clean up
 related code
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Copy KVM selftests' X86_PROPERTY_* infrastructure (multi-bit CPUID
fields), and use the properties to clean up various warts.  The SEV code
is particular makes things much harder than they need to be (I went down
this rabbit hole purely because the stupid MSR_SEV_STATUS definition was
buried behind CONFIG_EFI=y, *sigh*).

The first patch is a common change to add static_assert() as a wrapper
to _Static_assert().  Forcing code to provide an error message just leads
to useless error messages.

Compile tested on arm64, riscv64, and s390x.

Sean Christopherson (16):
  lib: Add and use static_assert() convenience wrappers
  x86: Encode X86_FEATURE_* definitions using a structure
  x86: Add X86_PROPERTY_* framework to retrieve CPUID values
  x86: Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical()
  x86: Implement get_supported_xcr0() using
    X86_PROPERTY_SUPPORTED_XCR0_{LO,HI}
  x86: Add and use X86_PROPERTY_INTEL_PT_NR_RANGES
  x86/pmu: Rename pmu_gp_counter_is_available() to
    pmu_arch_event_is_available()
  x86/pmu: Rename gp_counter_mask_length to arch_event_mask_length
  x86/pmu: Mark all arch events as available on AMD
  x86/pmu: Use X86_PROPERTY_PMU_* macros to retrieve PMU information
  x86/sev: Use VC_VECTOR from processor.h
  x86/sev: Skip the AMD SEV test if SEV is unsupported/disabled
  x86/sev: Define and use X86_FEATURE_* flags for CPUID 0x8000001F
  x86/sev: Use X86_PROPERTY_SEV_C_BIT to get the AMD SEV C-bit location
  x86/sev: Use amd_sev_es_enabled() to detect if SEV-ES is enabled
  x86: Move SEV MSR definitions to msr.h

 lib/riscv/asm/isa.h      |   4 +-
 lib/s390x/asm/arch_def.h |   6 +-
 lib/s390x/fault.c        |   3 +-
 lib/util.h               |   3 +
 lib/x86/amd_sev.c        |  48 ++----
 lib/x86/amd_sev.h        |  29 ----
 lib/x86/msr.h            |   6 +
 lib/x86/pmu.c            |  22 ++-
 lib/x86/pmu.h            |   8 +-
 lib/x86/processor.h      | 312 ++++++++++++++++++++++++++++-----------
 x86/amd_sev.c            |  63 ++------
 x86/la57.c               |   2 +-
 x86/lam.c                |   4 +-
 x86/pmu.c                |   8 +-
 x86/xsave.c              |  11 +-
 15 files changed, 284 insertions(+), 245 deletions(-)


base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


