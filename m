Return-Path: <kvm+bounces-35147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB884A09F50
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 045F116ADE6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B731758B;
	Sat, 11 Jan 2025 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dI6u+okf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5C0AD51
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555412; cv=none; b=E2WWvXLbDegi/F5dk8cbLXDsCEmPq043rWVfbM5BT4pBoTYJn2ud+4x0qyNnY7wt01MD7esCFE1NrolJC6w1LapL3QElkVFVZCTI8F+arnVFEdt3WxY0uVyN1nE/M0FxppHqkWLzkVsBYj+9FhvlhZtDZBYgZE8IWy4gkbL1tqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555412; c=relaxed/simple;
	bh=IPV+UZ6l0RkxJEPJs1XadT7uny3C590ErYEO6CK/OjM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aIV9+WXBBeDqYjOPEoelW6Ow98wlBuWeLuGUYFiwcruJwBGsIlKJquIDr/F2sAIHeOlWC5H52CDuF7wxhYhbxIn7XMlWJA8PoOxkWtbtkKSIr8gkAbI2l1GqUwHmSGqFy3bQj76bwdLh2NJW3hrDuDuSiWjKPauI13xElk5saQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dI6u+okf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef80d30df1so4545321a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555409; x=1737160209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lx0fb42bvSma/AKcurOI/fK9QHvPRBt0kFsOecEfyxM=;
        b=dI6u+okfPJJK/UpNUn6fMjM7ASyI6JQj+GqY/cXQ2BmmQPQrDK1ISldVGWKSOcZmHs
         4fHJiCa2L5IQydc4PHHFRT67IAruP3B6vQPSYVJoPvLCIStgtydRoo8VzI/zT6GudxTi
         ezt199JPmeQCePp/A8PJkjNM8SMxE1vP6498eUE3L+IYN908a/2FNcDYSqizHOA2ByW4
         /3srgrHQtsrrrM5vBqu2bibqCBY0jyDp5WCom9Uiu3nyvSenf1NTXuwofP87p+B/z0gg
         BvZZk++v2ybS5A107Lzlz0DAYGqOxChMavzatw6GFoWDOIA/MlNqlKdvTmGfR6rz70Wt
         vwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555409; x=1737160209;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lx0fb42bvSma/AKcurOI/fK9QHvPRBt0kFsOecEfyxM=;
        b=eY9zPamHgQSMsdvC5Nukh2XnV1jP+LUauEyxK8yR/43nVDC8aZ6gF1t3NK/HpH44Y8
         Zlie5LVTHpYfyW+MaqSP1zFacn8W/r3Jmrz/7grsgCMnivQuwxhnbN5fKynyWy3Y6R6R
         NrYUsn512koXjYLtQVWNtQq+Qq3Z2q3MkQlPTAgiiQacuAkAW3uXU952p6d83V9UoREP
         5PqUWU6V4KjRpW0a3JEf8D4TU7R4xRjCBpOj1Oob9kOwUuD7QHIP1pNtW6eeY9u33iK/
         cSXHwKpfLfztsPTTxIoibLxHlkIzGRpe8tVxC5Js21V+GI8xQ5jOZmjHdHwhC8Bo4jbR
         Lg5g==
X-Gm-Message-State: AOJu0YxIbS3Rb0/9Vjknk8iu3JXukw7SKS5g0QyJUl+8NbC/w3tbufdU
	Tt83WeVtXeyZM6CSUp+/t52B83D67fxjsgW6U9kyugRbttTpSGtfGxmQ2YdwmoZfCEJ+z4cDQdv
	Rgw==
X-Google-Smtp-Source: AGHT+IHmMP2GI45Z4VWglkCcNFjFL3DBqH9/xjgygy1SQQkiPZffieaQDVjMLrE5PetUKqK6umgxgfdoego=
X-Received: from pjwx11.prod.google.com ([2002:a17:90a:c2cb:b0:2ef:9ef2:8790])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:258c:b0:2ee:5691:774e
 with SMTP id 98e67ed59e1d1-2f548ea6252mr19356658a91.2.1736555409230; Fri, 10
 Jan 2025 16:30:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-1-seanjc@google.com>
Subject: [PATCH v2 00/20] KVM: selftests: Fixes and cleanups for dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a variety of flaws and false failures/passes in dirty_log_test, and
drop code/behavior that adds complexity while adding little-to-no benefit.

Lots of details in the changelogs, and a partial list of complaints[1] in
Maxim's original thread[2].

[1] https://lore.kernel.org/all/Z1vR25ylN5m_DRSy@google.com
[2] https://lore.kernel.org/all/20241211193706.469817-1-mlevitsk@redhat.com

v2:
 - Collect reviews. [Maxim]
 - Expand a few changelogs to be more explicit about the effects. [Maxim]
 - Print the number of writes from each iteration. [Maxim]
 - Fix goofs in the last patch (stale message and changelog). [Maxim]

v1: https://lore.kernel.org/all/20241214010721.2356923-1-seanjc@google.com

Maxim Levitsky (2):
  KVM: selftests: Support multiple write retires in dirty_log_test
  KVM: selftests: Limit dirty_log_test's s390x workaround to s390x

Sean Christopherson (18):
  KVM: selftests: Sync dirty_log_test iteration to guest *before*
    resuming
  KVM: selftests: Drop signal/kick from dirty ring testcase
  KVM: selftests: Drop stale srandom() initialization from
    dirty_log_test
  KVM: selftests: Precisely track number of dirty/clear pages for each
    iteration
  KVM: selftests: Read per-page value into local var when verifying
    dirty_log_test
  KVM: selftests: Continuously reap dirty ring while vCPU is running
  KVM: selftests: Honor "stop" request in dirty ring test
  KVM: selftests: Keep dirty_log_test vCPU in guest until it needs to
    stop
  KVM: selftests: Post to sem_vcpu_stop if and only if vcpu_stop is true
  KVM: selftests: Use continue to handle all "pass" scenarios in
    dirty_log_test
  KVM: selftests: Print (previous) last_page on dirty page value
    mismatch
  KVM: selftests: Collect *all* dirty entries in each dirty_log_test
    iteration
  KVM: sefltests: Verify value of dirty_log_test last page isn't bogus
  KVM: selftests: Ensure guest writes min number of pages in
    dirty_log_test
  KVM: selftests: Tighten checks around prev iter's last dirty page in
    ring
  KVM: selftests: Set per-iteration variables at the start of each
    iteration
  KVM: selftests: Fix an off-by-one in the number of dirty_log_test
    iterations
  KVM: selftests: Allow running a single iteration of dirty_log_test

 tools/testing/selftests/kvm/dirty_log_test.c | 521 +++++++++----------
 1 file changed, 246 insertions(+), 275 deletions(-)


base-commit: 10485c4bc3caad3e93a6a4e99003e8ffffcd826a
-- 
2.47.1.613.gc27f4b7a9f-goog


