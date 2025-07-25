Return-Path: <kvm+bounces-53488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A74B12680
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACF1AE3637
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41AB9265609;
	Fri, 25 Jul 2025 22:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uZw+M0+g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117C126462E
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481254; cv=none; b=GkFVMAtdydZ0y597zRPp3K/AZ5YJF5D5luSuLWbGzEc9xB5VqbrtmT6XWnWE1TAYzKlC53z05mHa5aOk6Zv+0DCGaga6S6qBRh8raZ7pwhAwkY0zeHa2UWoG9QhEMC7bp2QW4EFK2tqDTfb+9/V3I0SB1K8z8CJ032POmjGIUhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481254; c=relaxed/simple;
	bh=abLpqvJxSIZbPdFo1BTzkz/diu6mfiCRjLClhqyjwxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GT9lExtdDkiiEWVbCmsi1c6rCN9PtStVoJ+dCuJHduVH8f2c7bcZ6S1/eTKwpYq37bV89ym/oKKmbMKtQi9BIjr5Y8GxPKdIaxNsFMyL8A1CoAifBXaQFpLFTdXUuesGnyo0nH+qijpOJjojp8SL/v9BvNaD5ksB/0rvATDOoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uZw+M0+g; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115fb801bcso3139079a12.3
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481252; x=1754086052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X6X3zbgFRSWQOltzrYJm8357YkjydV/3raX+xE2R1uo=;
        b=uZw+M0+ghvyLAE/wR2EFaNJFvMY7PKzyvB8/A1l43pDnWPE6OGx/QErdm99DRD6hx5
         qpNlAm4ixUeQh3DLtsQX/UrBycsasQOcLBv47OODUuiiGGHK6EbUqzS2Zkv3ukD1dazC
         kVc7OIQL1QsKpiXELk6x/FXCuMzbTdjprzRmk8a9FlP7WXRKkGd5XAAdkXXWCHT4/2Oo
         kDffF2ufIgkrqaLcKZ5Vd87m56F1kR0tzCnBZM5dyKP0yIPwnAcwo16MfabaXtjkoCrX
         gKLc8h7sg5FeU3J1RyRHrUbHqK9tX4lVdOABbtiTMiVOwU8PI5xCDzxESu7iQdhW1lHB
         nemw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481252; x=1754086052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6X3zbgFRSWQOltzrYJm8357YkjydV/3raX+xE2R1uo=;
        b=TXeA6kZtFfIcMLthzuV++sTK2Rhw/UvFZSRyB0W4B34wD84igNrfITls63nIOv7IiX
         VWGcQXF8DA6fDduXcTV0WMfPtvClJQ3EG/FHHTQBWMpbFBJxWBu6eHnr9FyABAy/DM9g
         +FdeOsZI9w8M6DpdQGntp9f+050+5Idpg9+ysZE8iGrdZvdCI3wKmIwVE0C5j/wSKK3b
         IjDFxCfgMIh8ThvDCIFS6r36eSXW9TD1QpkfCmVEmNW2XYweQxPRFPUs3b5XBKSUd5gK
         JDolmdTy670Z83pZbyUNYIHFAyIOqZf9sUDYMcTJoYYZlvjRSJxn5y0ygGX5agDwu2Wd
         lzLw==
X-Gm-Message-State: AOJu0YwjL6t4sc7fyotrjmyksDfVCO+dXGGWRhmRni8M2VySmUqarsDb
	nRWfhF8uTmPLUKPzG7sQv4pQzuqc/WYvVcVt2ZosvOnztjl/AQBRv47kc/mLsr08kC2YZ6UuMJx
	iU7Opgw==
X-Google-Smtp-Source: AGHT+IGjJsB588IbCOEdRsmckCBkD5eL2L0y/a+t6/hjC8Qz2NcIIuOXcPkqe96FVTpXiYitH3r4tm1Yzrs=
X-Received: from pjbsl3.prod.google.com ([2002:a17:90b:2e03:b0:312:1e70:e233])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d0e:b0:315:7ddc:4c2a
 with SMTP id 98e67ed59e1d1-31e778594bcmr5096051a91.12.1753481252222; Fri, 25
 Jul 2025 15:07:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:09 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-10-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Minor "quality of user life" selftests cleanups.

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.17

for you to fetch changes up to 71443210e26de3b35aea8dced894ad3c420d55d5:

  KVM: selftests: Print a more helpful message for EACCESS in access tracking test (2025-06-20 13:39:11 -0700)

----------------------------------------------------------------
KVM selftests changes for 6.17

 - Fix a comment typo.

 - Verify KVM is loaded when getting any KVM module param so that attempting to
   run a selftest without kvm.ko loaded results in a SKIP message about KVM not
   being loaded/enabled, versus some random parameter not existing.

 - SKIP tests that hit EACCES when attempting to access a file, with a "Root
   required?" help message.  In most cases, the test just needs to be run with
   elevated permissions.

----------------------------------------------------------------
Rahul Kumar (1):
      KVM: selftests: Fix spelling of 'occurrences' in sparsebit.c comments

Sean Christopherson (4):
      KVM: selftests: Verify KVM is loaded when getting a KVM module param
      KVM: selftests: Add __open_path_or_exit() variant to provide extra help info
      KVM: selftests: Play nice with EACCES errors in open_path_or_exit()
      KVM: selftests: Print a more helpful message for EACCESS in access tracking test

 .../selftests/kvm/access_tracking_perf_test.c      |  7 ++-----
 tools/testing/selftests/kvm/include/kvm_util.h     |  1 +
 .../testing/selftests/kvm/include/x86/processor.h  |  6 +++++-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 23 ++++++++++++++++++----
 tools/testing/selftests/kvm/lib/sparsebit.c        |  4 ++--
 tools/testing/selftests/kvm/lib/x86/processor.c    | 10 ----------
 .../x86/vmx_exception_with_invalid_guest_state.c   |  2 +-
 7 files changed, 30 insertions(+), 23 deletions(-)

