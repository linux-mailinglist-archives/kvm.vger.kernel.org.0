Return-Path: <kvm+bounces-35714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60461A1475D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A96BE188ECA9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69DF0150997;
	Fri, 17 Jan 2025 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RhFhhVZF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2010C38DD1
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076051; cv=none; b=kTDnnH2+SR3vk/2+qJ5Z1JGbbsl8mnXseiRjQYeX03JqWWZz0e1HIz+KmPAiyr+Nw5utadeGoAU+SvJPleR7XlR9NTWBQ0FfOhgJelHa8Lo+VY1ahVwb0ZGwvlM8VYSt/UszHg0UnrqRwU6Obsu44YKeDDHqzyi22pgkw2mjY/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076051; c=relaxed/simple;
	bh=7/LZCZ8Ektdi7tWdrbja+CX3up3IWEpkcAVpYvcvQuU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D1qHkXdvbMVdS8QXpaao6RCSpCPeMU72zDWngGxwraWz8CxTPARrUBJrCPjJFZyDik0roAX7nZSiK6Jo6N49vAzwDyLr+lj4sKKiSo9CY9OKlGyUxvXIyFPjRiZxKbqthED4XWgvmUNVmVZxZqHTOGSUxXcd9JNl8K12rFQ4jMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RhFhhVZF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166e907b5eso29983525ad.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076049; x=1737680849; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HzI07b5Sr9M/y6szAvg5slefWyhJN7kLQT3DILNaRT8=;
        b=RhFhhVZFjGpcQReYrXOhsBNsbu2PQZ1yO56P00GoSNwvb30HbVUvnj0rdiD6ihvEFK
         XNkTlETevZd83A812ZiYlzOmO2U6lSc4gbEvlRBRPZFjl1Z5pOQC9YY93mqzye7Eh4HA
         lJCmS30MBib1DAVZ6d0XoWp/+6zl1Ev1TjvqyKX8e9ZA+L7BzFVskgHp18Xv/s0Io7Fl
         7m4G62s542BgLnN/aMsmu3+d2n7HgLd+zdBZudAfp7XM/yiV00w6Q2ayrzl5fYyiVvkq
         PZgdkmjIr6aG1OXfHKNV0G5gdUZVoVQ/RF2h7XG05KbXbZSZv3VcB1jsEcAvEzWFEEJ9
         7XRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076049; x=1737680849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HzI07b5Sr9M/y6szAvg5slefWyhJN7kLQT3DILNaRT8=;
        b=A0TwCKYnCqbS+RJDAUamQUcDOJCUhxsGOVxNMtsTOU4MQOcQ1FAP8wPFkaep+eUBAT
         xOpWGt6gr0kXOVIv3BMVPO9Qu3fjcHiqHpVLIvd2+cl6DyjzuRgm+3VzEzIkUJaKcst+
         K9p0h6V1jQIg5W8CpRgkUKJBeB96hUh+VHiJG1S48DWUUJigiTOqPb/AcVxRadXMVq5I
         AvYC1iy2vOAriZLymncCPq0csacUNUo6f01Ilvdrg3gx1EvMVsRaxtVUaVNOByg5vf1O
         2YKxlFI7uG+uY5y8Xd8+++MZZ8jH/kL5R/ucTpabkwmMxHPnGQKU7B5BXXvebs38A0ar
         CfYg==
X-Gm-Message-State: AOJu0Yx0Z9dKRwPhhXfeianr3U98epgYdCmqIDGHhAaeXvLGiuTFbsv/
	kSsFPV4095Hap31LqFKPzJnXb01lRpxlzWUa8oY4oa7Qn8oQD+BtOC2/YPdQJE5YLErprEzqfBs
	scg==
X-Google-Smtp-Source: AGHT+IH5HpIFzTyoG3TBAmkVXX+0bbLOEwfafof7d8/TCwuSgamwWUOHcGxA2XdRAw2uOI1n6wArriCvudE=
X-Received: from plly21.prod.google.com ([2002:a17:902:7c95:b0:215:94db:1290])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8f:b0:216:6d48:9177
 with SMTP id d9443c01a7336-21c352c7976mr13123105ad.11.1737076049379; Thu, 16
 Jan 2025 17:07:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:15 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-5-seanjc@google.com>
Subject: [GIT PULL] KVM: Selftests changes for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

FYI, the "LLC references/misses" patch exposed a latent failure on SKX/CLX/CPL[*]
(who's brilliant idea was it to use "CPL" for a CPU code name on x86?).  Dapeng
is following up with the uarch folks to understand what's going on.  If -rc1 is
immiment and we don't have a fix, my plan is to have the test only assert that
the count is non-zero, and then go with a more precise fix if one arises.

[*] https://lore.kernel.org/all/202501141009.30c629b4-lkp@intel.com

The following changes since commit 10b2c8a67c4b8ec15f9d07d177f63b563418e948:

  Merge tag 'kvm-x86-fixes-6.13-rcN' of https://github.com/kvm-x86/linux into HEAD (2024-12-22 12:59:33 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.14

for you to fetch changes up to 983820cb53c0e796777caf85bfc2810ad0c8fb22:

  KVM: selftests: Add helpers for locally (un)blocking IRQs on x86 (2025-01-08 12:57:03 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.14:

 - Misc cleanups and prep work.

 - Annotate _no_printf() with "printf" so that pr_debug() statements are
   checked by the compiler for default builds (and pr_info() when QUIET).

 - Attempt to whack the last LLC references/misses mole in the Intel PMU
   counters test by adding a data load and doing CLFLUSH{OPT} on the data
   instead of the code being executed.  The theory is that modern Intel CPUs
   have learned new code prefetching tricks that bypass the PMU counters.

----------------------------------------------------------------
Chen Ni (1):
      KVM: selftests: Remove unneeded semicolon

Colton Lewis (2):
      KVM: selftests: Fix typos in x86's PMU counter test's macro variable use
      KVM: selftests: Add defines for AMD PMU CPUID features and properties

Isaku Yamahata (1):
      KVM: selftests: Add printf attribute to _no_printf()

Sean Christopherson (2):
      KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU
      KVM: selftests: Add helpers for locally (un)blocking IRQs on x86

 .../selftests/kvm/access_tracking_perf_test.c      |  2 +-
 tools/testing/selftests/kvm/include/test_util.h    |  2 +-
 .../testing/selftests/kvm/include/x86/processor.h  | 47 ++++++++++++++++++++++
 tools/testing/selftests/kvm/x86/hyperv_ipi.c       |  6 ++-
 .../testing/selftests/kvm/x86/pmu_counters_test.c  | 15 +++----
 tools/testing/selftests/kvm/x86/svm_int_ctl_test.c |  5 +--
 .../selftests/kvm/x86/ucna_injection_test.c        |  2 +-
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c   |  3 +-
 tools/testing/selftests/kvm/x86/xapic_state_test.c |  4 +-
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c  |  5 +--
 10 files changed, 68 insertions(+), 23 deletions(-)

