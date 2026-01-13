Return-Path: <kvm+bounces-67881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AE443D1604D
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 676903019075
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D9E254AFF;
	Tue, 13 Jan 2026 00:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKdu7sH+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1161D1C861D
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264317; cv=none; b=jR5c58cHbrPMN58A/nAg+rD70ZtKADA7CMSP5qWyWEShD2yoapyPs5lTiBJSUWizC0/gRNmNDOO/knhplTuw4oWm4Gk3tiVR14PuQFBz2C/JPMiix+nVkqVixhbm+FVUIKZu3rCJhJR1htxa4LCernS6GqfesUneC+wTkwO9Ei8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264317; c=relaxed/simple;
	bh=1VuAmDtBX4mlZMH7IwPjotZPqSwCat8TdgRQJGAduJE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZgVV+UgZWpPRWDTjp5hRyeTDn2/Mr7D2eTPsSrTQd/YCMpE3+YepY2MXMc9TRWUknfN3a/J33i7jQJ3MJhrNqpae1O4vwDDZbdiMnszmmZv9wcfCtVY8AaggzqOXDnIAuM9c8gkhGAeFbqWqmtClvHcHCSArmSzh9aMb9wxnvw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKdu7sH+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f13989cd3so163333175ad.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264315; x=1768869115; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2KE/lthQSBGJhQGE5g8HKNcydIKgYbFl8ssR33VH1h8=;
        b=ZKdu7sH+YC3DZaB8aenaYo6ESMfcscHR/MZ6TU3SL/G5daxU4+VHkF1R2/LXA/hR48
         CQqTp9SBLz0onafFnS8EEffWpf9XRBRwXrnLEuEXBgouaQWTX17zEct1nAThpUjXFExP
         GI1TN02pdHvGdMcMbJ1JWzuI50pB48VqduTlpqUeMF8gfDF/z6E/XYYOB9KQCHuOUPqD
         aEQCAtvRaE6KtVWLCUNnD4LQAXTDqM1aECx8dkJyl9ewNLmtidSKmegAjS+BGhCvLZlR
         tNu2Km4swyFwf3CYCfNpVPA4UvncyLEnhSED+OgMB6Ln6lTJ2+q33uAqb6iYUV7LW4br
         5E0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264315; x=1768869115;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2KE/lthQSBGJhQGE5g8HKNcydIKgYbFl8ssR33VH1h8=;
        b=RA97RtNBkxh6SfdkwU9Y+IRisXKHFXjZ+c4RKT9H5hEyCNVM+/RHwRQ6nYHVrHdQ9L
         TrhwBobrqdbDVkl+rE/hW6CIUUUYWXtW6KDtrYutFCbfEQ0JGo1+s6GqX2+0TR5y+NG4
         z7Y65CSJZjj/lIo1LHimCKhi+fbm8WgzHobGEd8tCrH7rHHO2G5NDoaN9VcCpO8qbVRr
         2GbDiioQogTfInPT5+d51HRYxvTF502Nliqwr6qlvMmXfV9BQld3Zq2sFu0GC20UUohJ
         GXMc+XsZQ/tklaBvZFjx/W/9cPqvUjCrvwFC/QFsmuhCOempr9ZhOXx6XSjrQi7z5uk7
         ghiw==
X-Gm-Message-State: AOJu0YxDxNu+rvxOlyC6fwibkOmyaPV239TMQ7OpnZzAqwmPrXMOyiOk
	7jWaVkq23YjDQQiCJQbBX1QtMtSV6biqUBjMzXnTf6AoqqBFk3dKqpcrdjAj5Ma2iMxsMFJ7FUS
	ywv937WuqQpdKk+QANu3RM8GTch5QdMwJ/+GrKKRrJwaeMpDub89Qq3a7LldkF92qLpGizW/fJ6
	qtjFKyIg6hJUUOc4cjmpdYHNuWuflyH5/01CUM4uoqiWk=
X-Google-Smtp-Source: AGHT+IEQ/bLtar+MAEdU+LLoSrQUNGKkwQNqYRlYBisDfuHuAfCO09h7jGP3Y/6ng/CNwUUnL9LfcSYa1d/leg==
X-Received: from plbx12.prod.google.com ([2002:a17:902:ea8c:b0:2a0:895f:1026])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b30:b0:26d:d860:3dae with SMTP id d9443c01a7336-2a3ee4138c4mr206761975ad.3.1768264315299;
 Mon, 12 Jan 2026 16:31:55 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 00/10] Improve test parity between SVM and VMX
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

This series introduces numerous tests for features that VMX testing
covers but current SVM testing lacks.

I went through all VMX tests and identified which ones could have an
equivalent test written for SVM.

This series also includes some canonicalization and consistency check
tests as defined by the APM.

v1 -> v2:
  - Renamed check_npt_ad_pte() to found_bad_npt_ad().
  - Renamed test_event_injection() to svm_event_injection() and removed
    the test from the svm suite to run separately.
  - For the svm_event_injection test, injecting the CP vector now relies
    on shadow stack capabilities as suggested by Yosry.
  - Added a new test for verifying that certain instructions generate a
    #UD when EFER.SVME=0. This is a regression test in response to a fix
    that is currently under review [1]

[1] https://lore.kernel.org/all/20260112174535.3132800-5-chengkev@google.com/

v1: https://lore.kernel.org/all/20251219225908.334766-1-chengkev@google.com/

Kevin Cheng (10):
  x86/svm: Fix virq_inject SVM test failure
  x86/nSVM: Add test for NPT A/D bits
  x86/svm: Add tests for APIC passthrough
  x86/nSVM: Add tests for instruction interrupts
  x86/svm: Add tests for PF exception testing
  x86/svm: Extend NPT test coverage for different page table levels
  x86/svm: Add NPT ignored bits test
  x86/svm: Add testing for NPT permissions on guest page tables
  x86/svm: Add event injection check tests
  x86/svm: Add test for #UD when EFER.SVME=0

 lib/x86/processor.h |  11 +
 lib/x86/vm.c        |   2 +-
 lib/x86/vm.h        |   2 +
 x86/Makefile.common |   2 +
 x86/access.c        |   7 -
 x86/access.h        |  11 +
 x86/svm.c           |  16 +-
 x86/svm.h           |   9 +
 x86/svm_npt.c       | 801 ++++++++++++++++++++++++++++++++++++++++----
 x86/svm_tests.c     | 702 ++++++++++++++++++++++++++++++++++----
 x86/unittests.cfg   |  62 +++-
 x86/vmx_tests.c     |   5 -
 12 files changed, 1486 insertions(+), 144 deletions(-)

--
2.52.0.457.g6b5491de43-goog


