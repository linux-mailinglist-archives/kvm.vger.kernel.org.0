Return-Path: <kvm+bounces-5147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF2181CAE9
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1EF1B244D1
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F011A58E;
	Fri, 22 Dec 2023 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HBzFuEoH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1501A598;
	Fri, 22 Dec 2023 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-28beb1d946fso1536500a91.0;
        Fri, 22 Dec 2023 05:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253065; x=1703857865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5zqMKf7KXgOHRYALYfO/qvFwWZkjocCEqNPPk9MJnuw=;
        b=HBzFuEoH5Rs0wTyHaNm45GCaneVutaSRiYFOa8NtaOjnyAjL9pxTjnA/FJ6CDdJTfs
         6GsWEl3R1f8MrQnjRu7CL1PDyfyiNk5MbOZ9ISXR+qxPJVROlGo3Jnp8p3WzQlI5AAns
         gc/RQQWpDapdN5C33YXL1bQvPLHsz5U8OOs1e4He8xrXmahGmer2mM6Y7fPwQC7zMspO
         cL4jCEsCtx6mADrmPKPeoEGa8cJbmk9XjWJkX8qZjijOmL/pO8YV52W4V/dkFJQnHLnh
         bfyO7vl4B50Zm0+HiTqVs7orpWbu49UOGJ1EtmB6QQjs6SHt+Kziw2xplCskNclKtzOM
         41Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253065; x=1703857865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5zqMKf7KXgOHRYALYfO/qvFwWZkjocCEqNPPk9MJnuw=;
        b=vIleMJ68tCxn3mKo6pgr4BCmUURYOt+ASo/xMd7ieXoklc5ZA9pbHdFQRerOSN5mX8
         0HBpVKiOWEP/mhyMNXyfryEEvEuzHka9bu2aItN1GXZyHge02oRRCvzyMDrjnRvuNach
         TuDMYXbIfkFWd7cOyY8WxURz0M1+o646NZ+bWp6QbjApz/6Ky6tTBILu6k3aIWFVti05
         owOpaa3VyCNknIUtonxCe2UWDLCRTdkzDOorrREOhA2zxry5P+XgO9JJT5NWwBttJ/5g
         Qt3clrjUCGyPqkIPLRCxuw0sl45DqcGU2Cjey10irgVO5mBZzbD6OigCM7SQv+0eq2gd
         qCuw==
X-Gm-Message-State: AOJu0YyCZJOoSIGUwfrs++qf+VJjCqsmNfCMYxbgqA23PrgehQ7oQS/R
	njQPEcfzJXYQH6eOJjjpCyo=
X-Google-Smtp-Source: AGHT+IFTvL7baOi+WA9A1CiGd4kDHO1A0hMH2POOXsGm8LsAosUoUwCP2mO+R1FoLFAExQXoGS9h7A==
X-Received: by 2002:a17:90a:ad84:b0:286:6cc1:3f03 with SMTP id s4-20020a17090aad8400b002866cc13f03mr1086130pjq.58.1703253065442;
        Fri, 22 Dec 2023 05:51:05 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:04 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 0/9] Multi-migration support
Date: Fri, 22 Dec 2023 23:50:39 +1000
Message-ID: <20231222135048.1924672-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thomas suggested I should split this out of the powerpc series
because it is applicable to other archs as well and it's easier
for others to review like this.

Since the v5 series:
- Split out from powerpc changes
- Fixed another small race found when running migration tests
  on aarch64 (wait for destination machine to have qmp socket
  set up before issuing qmp commands to it).
- Added a directory for common tests, added the migration
  selftest to it, build it on arm and s390x as well.
- Add "quiet" migration support, use it in migration selftest.
- Cut down runtime for migration selftest so it is suitable for
  unit tests. Add it to unit tests.
- Fix a s390x make clean omission that bit me when testing
  it. This does not depend on the other patches.

Thanks,
Nick

Nicholas Piggin (9):
  s390x: clean lib/auxinfo.o
  arch-run: Clean up temporary files properly
  arch-run: Clean up initrd cleanup
  migration: use a more robust way to wait for background job
  migration: Support multiple migrations
  arch-run: rename migration variables
  migration: Add quiet migration support
  Add common/ directory for architecture-independent tests
  migration: add a migration selftest

 arm/Makefile.common         |   1 +
 arm/sieve.c                 |   2 +-
 arm/unittests.cfg           |   6 ++
 common/selftest-migration.c |  34 +++++++
 common/sieve.c              |  51 ++++++++++
 lib/migrate.c               |  20 +++-
 lib/migrate.h               |   2 +
 powerpc/Makefile.common     |   1 +
 powerpc/unittests.cfg       |   4 +
 s390x/Makefile              |   3 +-
 s390x/sieve.c               |   2 +-
 s390x/unittests.cfg         |   4 +
 scripts/arch-run.bash       | 181 ++++++++++++++++++++++++++----------
 x86/sieve.c                 |  52 +----------
 14 files changed, 258 insertions(+), 105 deletions(-)
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0


