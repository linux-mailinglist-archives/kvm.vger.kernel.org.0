Return-Path: <kvm+bounces-9242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C11F285CEB0
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4EBA1C21EEE
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28F738DD2;
	Wed, 21 Feb 2024 03:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RD7dQ/ad"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77262E3FE;
	Wed, 21 Feb 2024 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486104; cv=none; b=RKQRVjofFSC4rWL1dWUVzBX614OQFBsrH+SUV8nV0foSmEb5Y93eIJcc4cqBtPEBeTqoE9LfmLaLtvzYJVDqbT9cpFZlsyR7tn6EU7KhJVpZWE4QzaT32NprZq/UDCM20hGTl09pU8JMp0oRT0xt765sARJoZ0UxCNvJgyMj8TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486104; c=relaxed/simple;
	bh=00EYudbANOSaxNSrkwurD81lMrDxfKTUqVgu1v5tMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oWxC3DgP/dY/N1wHlsc6rXYfQtUKTSagcpwxuHsOFnjnMYAmqf8/LW5ZHRe4OjuRlvQkpF7ZW7G6bw8Ma16mQ1M6u6RTvNg/DYwkBifM5kMPYNQsqgJZ9usLx8ymR06SzOsBFi01gUrfv6WYiAHCaoDGhIW568oiSFisUo4AzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RD7dQ/ad; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc13fb0133so1087405ad.3;
        Tue, 20 Feb 2024 19:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486101; x=1709090901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ig+g0BUZSXifjVBy73OzZ9fIB5v/6NjxVeJ9J0qwojE=;
        b=RD7dQ/adwDzYEKhGflBIrdFLE5qB7Vf8urwI6eeW80KdO6A91EcvqyRy2psTEbnvGT
         tM20TRMUpUFNDo9tWbyuKOk//UiirdfgzqsMFlYQTRzvC8y9mhPOFWxYuV1/WwbDUbNM
         azY2+vqWP2Qk1TrXyDMHwb802Y8f6FfWivyOxeGipD9dzg/C1Dgi+a8mW6wDU5a3Z1Yf
         OQbV40VRWRO9uCyT2F84b2+lfARj20HFgDslde2VPzf9q5CufuoA4mHL+UiOX9nzgnq5
         I6gIDaORPnlvobYbmBF3biFNj8VFCGeC5BuP4nlrTanOpt+RGCuXfpHjxW1zAk6ouK4a
         P7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486101; x=1709090901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ig+g0BUZSXifjVBy73OzZ9fIB5v/6NjxVeJ9J0qwojE=;
        b=M0z7wSWxAq2pHAy4/QxPG7snL0lWFMD3yCJR16OVjP0uW/7iy04sBMbJVmlodCF+Dp
         xxsFz9Y/yJf3UI3cRAxW31dyT22ZPG7tQkv9zxy9espQIYOI+gJCskELIvSrfVhULIlX
         4JktEETSTz5LsTLag8xYOKfIuDhBDppc+bORt3UJGn+WqzRwBMX3TljrCh5nExc2GjSM
         OpQ/s7pP6M8KDaqR9+QCdfqUtkLI0VK3miRWUsg0OYArKCtUVU0qNau9HMi2bRwOFINw
         wbyVR555ri0JL08IVvVkaQWQaAL1iYIkNMBDeSoKOxG+UZgq97uQuIUHwwPWD9vySDkF
         CnaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyhFW0rukBJi7iCohM/Em7sXb3Etwsc5psk+sBcDZmjbsRKIvS93cOkObQKwXkcHiDwPmXCcT3FvX7NgOA8hj0w3xtkBJxYmrx9eFWL6sy74LA0G8/xlLr1K7hvswwaA==
X-Gm-Message-State: AOJu0YzPH80+sgPfxFYCKhIqSZ1WLaDrflh/PdcuX9XyPNW+zP5vQBWO
	lEd7BsSCgVpktuSMjuvXwfwXUe2bUGtlfkDPzIOsNZ6g9um9D+U1
X-Google-Smtp-Source: AGHT+IENcbmlmxPUUYa5IPoB3qyzTiAzkVoX3rrNvUBxi29LRyMCLlj6+/WkLPi+Nhs8BmfBMPXIdQ==
X-Received: by 2002:a17:902:b902:b0:1d9:8ddf:5fa0 with SMTP id bf2-20020a170902b90200b001d98ddf5fa0mr14621025plb.62.1708486100817;
        Tue, 20 Feb 2024 19:28:20 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:20 -0800 (PST)
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
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 0/8] Multi-migration support
Date: Wed, 21 Feb 2024 13:27:49 +1000
Message-ID: <20240221032757.454524-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that strange arm64 hang is found to be QEMU bug, I'll repost.
Since arm64 requires Thomas's uart patch and it is worse affected
by the QEMU bug, I will just not build it on arm. The QEMU bug
still affects powerpc (and presumably s390x) but it's not causing
so much trouble for this test case.

I have another test case that can hit it reliably and doesn't
cause crashes but that takes some harness and common lib work so
I'll send that another time.

Since v4:
- Don't build selftest-migration on arm.
- Reduce selftest-migration iterations from 100 to 30 to make the
  test run faster (it's ~0.5s per migration).

Since v3:
- Addressed Thomas's review comments:
- Patch 2 initrd cleanup unset the old variable in the correct place.
- Patch 4 multi migration removed the extra wait for "Now migrate the
  VM" message, and updated comments around it.
- Patch 6 fix typo and whitespace in quiet migration support.
- Patch 8 fix typo and whitespace in migration selftest.

Since v2:
- Rebase on riscv port and auxvinfo fix was merged.
- Clean up initrd cleanup moves more commands into the new cleanup
  function from the trap handler comands (suggested by Thomas).
- "arch-run: Clean up temporary files properly" patch is now renamed
  to "arch-run: Fix TRAP handler..."
- Fix TRAP handler patch has redone changelog to be more precise about
  the problem and including recipe to recreate it.
- Fix TRAP handler patch reworked slightly to remove the theoretical
  race rather than just adding a comment about it.
- Patch 3 was missing a couple of fixes that leaked into patch 4,
  those are moved into patch 3.

Thanks,
Nick

Nicholas Piggin (8):
  arch-run: Fix TRAP handler recursion to remove temporary files
    properly
  arch-run: Clean up initrd cleanup
  migration: use a more robust way to wait for background job
  migration: Support multiple migrations
  arch-run: rename migration variables
  migration: Add quiet migration support
  Add common/ directory for architecture-independent tests
  migration: add a migration selftest

 arm/sieve.c                  |   2 +-
 common/selftest-migration.c  |  29 ++++++
 common/sieve.c               |  51 ++++++++++
 lib/migrate.c                |  19 +++-
 lib/migrate.h                |   2 +
 powerpc/Makefile.common      |   1 +
 powerpc/selftest-migration.c |   1 +
 powerpc/unittests.cfg        |   4 +
 riscv/sieve.c                |   2 +-
 s390x/Makefile               |   1 +
 s390x/selftest-migration.c   |   1 +
 s390x/sieve.c                |   2 +-
 s390x/unittests.cfg          |   4 +
 scripts/arch-run.bash        | 177 +++++++++++++++++++++++++----------
 x86/sieve.c                  |  52 +---------
 15 files changed, 240 insertions(+), 108 deletions(-)
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0


