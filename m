Return-Path: <kvm+bounces-42087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0B4A72812
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 02:24:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 328F21895443
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 01:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68213BBF2;
	Thu, 27 Mar 2025 01:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="smPIZ4DO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520593596A
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 01:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743038687; cv=none; b=GDEXHTtwGWI/J7GPML/Y0Grk0uxsFSEjZ0LSsyLY9ZfR1dw8e9E4in1/fJuHKCThRKu6m2sEWNqRNEpFfSybmz6CBLdGSbOe6aWA83fnWIQqGSLsiU4YPC4O8khsECREOWx25z1xEPtiE4Pqv2A73wwKhoRdva/AqPlEP/8DHe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743038687; c=relaxed/simple;
	bh=3kxkXpBhoJScEEurm+b8lsAO1U7qWl5x/4lmhlHIsxA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D7eZtw/pcUYglsD5tkPMY0g8kbpfesxOUeudYOWff5ozsuZtfWT/H1L9ZI/fo5XhNb9BIr5pxfgbJ7xvmoPDW1EIgT9ooZAiMIbjl6/KWqVBet/uhkoATSqs7+H6vuzu/W03LNlQJgHIzwIn3XrFJ9kJDHU9tgrQw+5YGHpzN0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=smPIZ4DO; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-5243f067a34so74207e0c.3
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 18:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743038685; x=1743643485; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OnBfyElwB7pR2NOpIQEhHFwjTaj6cxlSHySqE1g9O24=;
        b=smPIZ4DO9v02diZOUzVSnZP4+S4t8KfxLaB40rAD+oKbLjQEJDYakIVyYMLM6p6PyZ
         IDBYG12flFMFcarU8zOWUITvgPgx9oQV4k8wxyom65D4TLRNwupvigR7/6UCRo/NNUQ8
         Pmx6zSegz+5qZfGvcV0rVS6hi8xrKIaK6dmjzc7m/QDLbkvtvC03V4sZR3arGQ78j1K7
         xRgZ5NPTjwq7g63QkEKrqQGqE3ZDac4vtsoT8PhG1oeuu4/jrZMDEMXqrwOkkjhk+FjL
         PqfUisWScyqG6PtfDhgZMGSjvKSj1d4Ncl4qlW27pjGTvtMErEK6WWO7c3RN2GAVq80H
         MYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743038685; x=1743643485;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OnBfyElwB7pR2NOpIQEhHFwjTaj6cxlSHySqE1g9O24=;
        b=BY4nmrJOM0jXDMTS8R5z0qLpcYfDIVEXh3r2EpnMYl9T75s+gOdfuWYgRAJRVh5+zV
         irnCYP9f/UZ22kDdGSyt8wwFSX4cuGFM4WvoJ87qf0ggw1QCnvDelr7lmSW0gbPZFQfY
         H1fRSo8vVmE5VIere74jpd6GJkVaMfBtuaOaZNCnnnb9rrZ2QC8dIhs2tvBZwUqHZ0vB
         kqhoGdGV5aDRB1JuHILdE0ZXd2om6RSxUbOnOe9LPrmyOopNAgPSqj7wN9CliBzkAaW0
         l9El2unnY74CyYhiauIaamwBvEq2nMFjJt3Kp/6Xeh5/5ciJujquy6n4frAgL6Frvqz3
         jFTA==
X-Forwarded-Encrypted: i=1; AJvYcCUZxF8XPs0ocP08LgpzkLOisrIWjZESnOAck7rw3mkozcgju3l2rrvlKvkEuku2dyJkB3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLrPkG59twNo129MfRUVxBakzcZLq0E0UtN5zj7nXfNkl39zVo
	cgD3VfiZcqhxE3BQebuflFAVbyiqibsX/EZfD7MG3wEDCotbJb9clL7bvBt4yTr+/r4Bd7roqg0
	va7LXAEUjPFp4mKaLYA==
X-Google-Smtp-Source: AGHT+IEMXalzFI1RmQMmbOxY3dwo1qPrh8Qx1TkLKs2CMrepip9P0Lapptz92/BHPG+Q/ecCwOSxQ1kdXgRemPD4
X-Received: from vkb18.prod.google.com ([2002:a05:6122:8112:b0:51c:af44:e006])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:3d0e:b0:523:9ee7:7f8e with SMTP id 71dfb90a1353d-526009144f9mr1633987e0c.4.1743038685245;
 Wed, 26 Mar 2025 18:24:45 -0700 (PDT)
Date: Thu, 27 Mar 2025 01:23:45 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250327012350.1135621-1-jthoughton@google.com>
Subject: [PATCH 0/5] KVM: selftests: access_tracking_perf_test fixes for NUMA
 balancing and MGLRU
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yu Zhao <yuzhao@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This is a follow-up from Maxim's recent v2[1] and the selftest changes
from the v8 of the x86 lockless aging series[2].

With MGLRU, touching a page doesn't necessarily clear the Idle flag.
This has come up in the past, and the recommendation was to use MGLRU
generation numbers[3], which is what this series does.

With NUMA balancing, pages are temporarily mapped as PROT_NONE, so the
SPTEs will be zapped, losing the Accessed bits. The fix here is, in the
event we have lost access information to print a warning and continue
with the test, just like what we do if the test is running a nested VM.

A flag is added for the user to specify if they wish for the test to
always enforce or always skip this check.

Based on kvm/next.

[1]: https://lore.kernel.org/all/20250325015741.2478906-1-mlevitsk@redhat.com/
[2]: https://lore.kernel.org/kvm/20241105184333.2305744-12-jthoughton@google.com/
[3]: https://lore.kernel.org/all/CAOUHufZeADNp_y=Ng+acmMMgnTR=ZGFZ7z-m6O47O=CmJauWjw@mail.gmail.com/

James Houghton (3):
  cgroup: selftests: Move cgroup_util into its own library
  KVM: selftests: Build and link selftests/cgroup/lib into KVM selftests
  KVM: selftests: access_tracking_perf_test: Use MGLRU for access
    tracking

Maxim Levitsky (1):
  KVM: selftests: access_tracking_perf_test: Add option to skip the
    sanity check

Sean Christopherson (1):
  KVM: selftests: Extract guts of THP accessor to standalone sysfs
    helpers

 tools/testing/selftests/cgroup/Makefile       |  21 +-
 .../selftests/cgroup/{ => lib}/cgroup_util.c  |   3 +-
 .../cgroup/{ => lib/include}/cgroup_util.h    |   4 +-
 .../testing/selftests/cgroup/lib/libcgroup.mk |  12 +
 tools/testing/selftests/kvm/Makefile.kvm      |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c | 263 ++++++++++--
 .../selftests/kvm/include/lru_gen_util.h      |  51 +++
 .../testing/selftests/kvm/include/test_util.h |   1 +
 .../testing/selftests/kvm/lib/lru_gen_util.c  | 383 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/test_util.c   |  42 +-
 10 files changed, 726 insertions(+), 58 deletions(-)
 rename tools/testing/selftests/cgroup/{ => lib}/cgroup_util.c (99%)
 rename tools/testing/selftests/cgroup/{ => lib/include}/cgroup_util.h (99%)
 create mode 100644 tools/testing/selftests/cgroup/lib/libcgroup.mk
 create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.395.g12beb8f557-goog


