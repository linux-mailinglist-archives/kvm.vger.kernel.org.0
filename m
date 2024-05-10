Return-Path: <kvm+bounces-17238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 328E28C2DBA
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 01:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2298B1C2236C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98917B516;
	Fri, 10 May 2024 23:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwJ7tQa6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B408617A933
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715385068; cv=none; b=Ibs8W9E0f+JsawEW/wdb7Ug+GU15bnl1nRhk9/ZWxNKgXph15Vw7pTFrD/3DNiJMoAIgPHFunC1pgdPnKe1m5JK1i0ElBFhAeq3Ym6HE25iP/2PPE4LjiEyTDKbwf/FTfnMxmB+XXE8nl3NrsTt9iBn7/qgsWKUYbbZqxNOXHWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715385068; c=relaxed/simple;
	bh=uQVa5GV6l573W5V02dsJrOxh0J85arazX6O7XuEK/1I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NRuvS97QkfpbbrvtyybCVCjXDi5YL/YOT/S+XrwSCOYS6PSBz7pQSfP9igaKVSyn7H6km7APUeRN1ExmAC1IKrz1FhSA2HdoYfo4MNWJNPPPwKaRIElKUjIPkEMCuU5liZgcp2ECzMTUtRXJnMSK5E+YZwEsR4ORIqwchjgVtw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwJ7tQa6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ecf2ca6069so22648005ad.2
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715385066; x=1715989866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hZTZMqbrhKFbALv0wH7v4E1dBb2W4CdYh+08yY5Xv/Y=;
        b=RwJ7tQa6I/SyhMOPmPesEg1T1d9umG6eLwcqt3LyVSJOJq3wh1fo++y2k9sKyiFADa
         iNJeOM/sl2t2btKiAouhQGcPYx+X6Gu2PbSVmsuql2SxVFdhYz3kckHc6999R77mmxmW
         PUnkVKkQE0bbQQDdV0eCWBUdhxAlsMRjckRhrn5u8jIkvNvu404BZlxa2x1UrYFUcqxW
         db+U0sV/u8irXsa+lZnn4tZajIKI3qmqSOaI6E3N9AUtdVhnUoY+fZCEpQ4tTRvnwwyQ
         ySiJCppH5wCnDGQ2NyhS1kWIQu2rG+aNk7mBbdyQydLdL9XBr8E6I8iSRp75E2Di9L9y
         cVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715385066; x=1715989866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hZTZMqbrhKFbALv0wH7v4E1dBb2W4CdYh+08yY5Xv/Y=;
        b=fuJZRJIbmIWhnjQlTUgwD38C1AlotZpU3l4ibl/7OCJt8DYWATHCPqQXEVV9z2Qn3f
         p0Sf+MX6hmgnbWPlyvKgz+JU4VLhcHZGijFH5VJMELvnJKe25cXkOPdP9aeVwHjzC6G0
         uThgl09Fbhy189BtFsdvEg2yYY3nztwrHmRXH2wnjh0OPP9Qxf4N+hb+MVeVYYKnpMeu
         3mRkrQMGdaFJrzv83kGUUeakLSNggj4cdh4RY1kxmZOjv/lXUcmSE9I5dEwLIcSpmafe
         iH471ce3mCGDAI+6lDcrdDv2qdBT+0gTlznDAvqzDczVmot6LRSrbQNnZvzoBzIukbKQ
         J4ag==
X-Gm-Message-State: AOJu0Yx8CuBzS+2C/FJ6i84Jc0XhM2hDQ6BVQ/APC/IqS5np0M/ZFxR9
	ojBhbrDE+DhsQzlznnG978lemyd1gOgOdcAY3RdfUWu2g8lyzRhQVOg6Bi899AxQq6xfpy5i265
	2fA==
X-Google-Smtp-Source: AGHT+IE85PaR2cbdEqIrCBZRZcE7pMEVkdP20YgwrcWtnJaJkb9VxHdCm24I7E3BtYRAe0WVMiU/rXQClZk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:187:b0:1eb:511d:a48d with SMTP id
 d9443c01a7336-1ef43f4ce3cmr2781985ad.9.1715385066106; Fri, 10 May 2024
 16:51:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 May 2024 16:50:49 -0700
In-Reply-To: <20240510235055.2811352-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510235055.2811352-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510235055.2811352-5-seanjc@google.com>
Subject: [GIT PULL] KVM: Selftests cleanups and fixes for 6.10
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

This is 1 of 2 selftests pull request for 6.10.  This is (by far) the smaller
of the two, and contains fairly localized changes.  The most notable fix is to
skip tests as needed if the host doesn't support KVM_CAP_USER_MEMORY2, as the
selftests currently just fail miserably on KVM_SET_USER_MEMORY_REGION2.

More details about why there are two pull requests in 2 of 2.

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.10

for you to fetch changes up to 8a53e13021330a25775a31ced44fbec2225a9443:

  KVM: selftests: Require KVM_CAP_USER_MEMORY2 for tests that create memslots (2024-05-02 16:12:28 -0700)

----------------------------------------------------------------
KVM selftests cleanups and fixes for 6.10:

 - Enhance the demand paging test to allow for better reporting and stressing
   of UFFD performance.

 - Convert the steal time test to generate TAP-friendly output.

 - Fix a flaky false positive in the xen_shinfo_test due to comparing elapsed
   time across two different clock domains.

 - Skip the MONITOR/MWAIT test if the host doesn't actually support MWAIT.

 - Avoid unnecessary use of "sudo" in the NX hugepage test to play nice with
   running in a minimal userspace environment.

 - Allow skipping the RSEQ test's sanity check that the vCPU was able to
   complete a reasonable number of KVM_RUNs, as the assert can fail on a
   completely valid setup.  If the test is run on a large-ish system that is
   otherwise idle, and the test isn't affined to a low-ish number of CPUs, the
   vCPU task can be repeatedly migrated to CPUs that are in deep sleep states,
   which results in the vCPU having very little net runtime before the next
   migration due to high wakeup latencies.

----------------------------------------------------------------
Anish Moorthy (3):
      KVM: selftests: Report per-vcpu demand paging rate from demand paging test
      KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand paging test
      KVM: selftests: Use EPOLL in userfaultfd_util reader threads

Brendan Jackman (1):
      KVM: selftests: Avoid assuming "sudo" exists in NX hugepage test

Colin Ian King (1):
      KVM: selftests: Remove second semicolon

Sean Christopherson (1):
      KVM: selftests: Require KVM_CAP_USER_MEMORY2 for tests that create memslots

Thomas Huth (1):
      KVM: selftests: Use TAP in the steal_time test

Vitaly Kuznetsov (1):
      KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK

Zide Chen (2):
      KVM: selftests: Make monitor_mwait require MONITOR/MWAIT feature
      KVM: selftests: Allow skipping the KVM_RUN sanity check in rseq_test

 .../selftests/kvm/aarch64/page_fault_test.c        |   4 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  90 +++++++++---
 .../selftests/kvm/include/userfaultfd_util.h       |  16 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   8 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c | 153 ++++++++++++---------
 tools/testing/selftests/kvm/rseq_test.c            |  35 ++++-
 tools/testing/selftests/kvm/steal_time.c           |  47 +++----
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |   1 +
 .../selftests/kvm/x86_64/nx_huge_pages_test.sh     |  13 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  52 +++----
 10 files changed, 282 insertions(+), 137 deletions(-)

