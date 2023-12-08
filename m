Return-Path: <kvm+bounces-3892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5427809916
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38678282191
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 02:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5351E1FA1;
	Fri,  8 Dec 2023 02:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w2OtNCVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3352C1728
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 18:17:33 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5c941936f7fso10168037b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 18:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702001852; x=1702606652; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7HcAkk9OcO6R26OdgJnZaKpSN5LYlU1FJ4TjFKmXHk=;
        b=w2OtNCVN/oq88R4HPVOGyI2GILwdBmN5uo6io5EXpgCdnhgbt6pU6CGtnvjMBDkxdc
         jsPyz9caKZzOG16LIsArcDBkBxCvB3bOH9gx8UiJhsaEaXh3sT0vXtBHQ50DSO5vPLLA
         euucH1+l8LYpic0atZsoj0K1XrrqqHzH7vR0TljldE2X6L/aakrtmIVe915hZg9/8iIz
         LwEmqoazuAkNSeCz5YGIYRfaseb+Qzg91cVkj6Z6uFUqEiD1g7+46XMFaFngFX+SzKvD
         V3FeZys6mu0Nx6bqnC2wCEL4c+6nsRAg7pUBhtPow9DOPmdtofUMXyz45kiPYTrc3bsp
         3Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702001852; x=1702606652;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7HcAkk9OcO6R26OdgJnZaKpSN5LYlU1FJ4TjFKmXHk=;
        b=c0JDZHT3Y983OkUxIBoqumAAvKR5Syd/PbCxt4jmgcuzdDEUzXYeBUiGprFidqpOUM
         y2Pq9VoWl3qoRE5VQ4afVfFygvmXgVEGefAWFw18nma1zeImsyVa1eE/F8JY43DbkgOp
         VeX4a9Zol0GsDQKXaaQrlghuibXiHMLWAGwmMQ/NQJR9VqaWnhITzQs4oJrfZ8v+CYSX
         OcoyI9aD0sZu47KwCIpIvz3J9V63xuw/ShTV+U10j3F/s5h6cvK7bCklHJeXSB0RvD1v
         jwXFcHHW/zR4loFAHNBOc1nVFnBA5EFdtEFthJQ7iTX4Y0BS/79UmOtZIg+rJ2dSNSnT
         sW0A==
X-Gm-Message-State: AOJu0Yz9AxUo+Sgn2uUDEc09g9mSMHjYVhWifmj2+Hb0n4vIV9m1U/v9
	kdyYPhT1/lXVxAeQaUH9qDLxEJBac84=
X-Google-Smtp-Source: AGHT+IF4M/K0KGAhMim7eQLfOFrM5Cj0KkcFsrHAyQxVlnJovHWvRW4FrdnZ3uPQIhVPScAb2KGEmYyn+5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:14d:b0:db5:3aaf:5207 with SMTP id
 p13-20020a056902014d00b00db53aaf5207mr2547ybh.3.1702001852402; Thu, 07 Dec
 2023 18:17:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  7 Dec 2023 18:17:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231208021708.1707327-1-seanjc@google.com>
Subject: [GIT PULL] KVM: selftests: Fixes and cleanups for 6.7-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull selftests fixes/cleanups for 6.7.  The big change is adding
__printf() annotation to the guest printf/assert helpers, which is waaay
better than me playing whack-a-mole when tests fail (I'm still laughing
at myself for not realizing what that annotation does).

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.7-rcN

for you to fetch changes up to 1b2658e4c709135fe1910423d3216632f641baf9:

  KVM: selftests: Annotate guest ucall, printf, and assert helpers with __printf() (2023-12-01 08:15:41 -0800)

----------------------------------------------------------------
KVM selftests fixes for 6.7-rcN:

 - Fix an annoying goof where the NX hugepage test prints out garbage
   instead of the magic token needed to run the text.

 - Fix build errors when a header is delete/moved due to a missing flag
   in the Makefile.

 - Detect if KVM bugged/killed a selftest's VM and print out a helpful
   message instead of complaining that a random ioctl() failed.

 - Annotate the guest printf/assert helpers with __printf(), and fix the
   various bugs that were lurking due to lack of said annotation.

----------------------------------------------------------------
David Woodhouse (1):
      KVM: selftests: add -MP to CFLAGS

Sean Christopherson (7):
      KVM: selftests: Drop the single-underscore ioctl() helpers
      KVM: selftests: Add logic to detect if ioctl() failed because VM was killed
      KVM: selftests: Remove x86's so called "MMIO warning" test
      KVM: selftests: Fix MWAIT error message when guest assertion fails
      KVM: selftests: Fix benign %llx vs. %lx issues in guest asserts
      KVM: selftests: Fix broken assert messages in Hyper-V features test
      KVM: selftests: Annotate guest ucall, printf, and assert helpers with __printf()

angquan yu (1):
      KVM: selftests: Actually print out magic token in NX hugepages skip message

 tools/testing/selftests/kvm/Makefile               |   3 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |  75 ++++++++-----
 tools/testing/selftests/kvm/include/test_util.h    |   2 +-
 tools/testing/selftests/kvm/include/ucall_common.h |   7 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 .../testing/selftests/kvm/set_memory_region_test.c |   6 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  10 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c       | 121 ---------------------
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |   6 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |   2 +-
 .../kvm/x86_64/private_mem_conversions_test.c      |   2 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |   4 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   2 +-
 .../testing/selftests/kvm/x86_64/xcr0_cpuid_test.c |   8 +-
 14 files changed, 78 insertions(+), 172 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c

