Return-Path: <kvm+bounces-8414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A25E84F1FF
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0D61C211BE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1DA664C9;
	Fri,  9 Feb 2024 09:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSyIV+Zq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FA7664D6;
	Fri,  9 Feb 2024 09:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469908; cv=none; b=aTRkJ6L0PPdSi8gNFAyTsNUNiTSvzUwzjSwTQmEJkCHFb3yf7B4TbJBLrQZl9v6H71hVauHgm22RmObIGVeoSFb+mC3IgYNEzWYoFqBEfSonKc8/Vtm4yHJxKLPPAZBGNsfKPcaqqJcRzXtImFM8U0WuFsKfKR36AJXkoXAsL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469908; c=relaxed/simple;
	bh=B8anZMNRBPcLlvRLKlObFqArty/ywxPpo4Jp/46Vlxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gv6aC47V0gNksNzSKLlwj6Uo71jfw9xeLCBQtYRzM2utwlwnqL6l5vVVNQ1PFgahfuayvN0a52faswuKrwSrFjhq+W38oj6HBBhiP+RM0PtptRapIeJpYmpUxJ1V5QtFtOkzyU3pWcN4i42mjIjEP6ebAfhlARBZnsI5SZ4Skzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSyIV+Zq; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bfd40ff56fso261185b6e.2;
        Fri, 09 Feb 2024 01:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469905; x=1708074705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+vVti2Abh8xz/VGQndlLuUefZ1rrTqLcNRInLl4jaCU=;
        b=ZSyIV+ZqiA3whvWwO58kAgK3eFCrGRCYH34rD8kH19yVonHMp3JZcpnJZW6rVSPRx4
         9z/sKu6yCPQ4+LoUjtydnBPYsM2QEiS5Hs+dGtp+IU80pTAu1X6CbirXsTInItMQ+D1c
         i5uem1FX+xbWP8Wrk314Wiy/P7p9IoC1ZX5xDKcUDF9a4zgzkoi+rcu3C8OomrfzcWSg
         dHb00N29vuBjgZYyFHuhBLhLruKITzl259nqPPAeQyfEl9tK0p8aQ0X0T2M7fFgKvc4a
         I4e5aU6a1sKQx61LxCZ0CKepmKkwWfoRkN88PDIwPj1JNidZOknoYMKXDJZPRcMFX6hL
         mFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469905; x=1708074705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+vVti2Abh8xz/VGQndlLuUefZ1rrTqLcNRInLl4jaCU=;
        b=V22kKstRntH40QSwEarn1kFi16yvnCQvFdUZJPEZip7IM8CSSqIflrmw8UKjBmHRSi
         M+I51K42MWe63PhXgITuN4Qb5TBi4cEIShh9oFNdMPRayYpg84Ou1J5CGIVE6wd/8poq
         9Mc+aTkk9Aax3gXSAkRhpeX0cV1oue22VinOl7U59bwGMQJC24ZdF9CC2wSoIdyrS9z+
         WlXBsYv1UiQCfjjlYxT+skxgGLkbCD0Y4h87V0IyjO4KtH8vyEqDqh26cW589pac3cSr
         /fK+eu8YOgvqxvxTj2QcQp6ACn7SB0GNl5rqibrniw/rIzETMUh+iQ3habubXYNDA+GF
         OYHQ==
X-Gm-Message-State: AOJu0Yxq65DBlcmgk3mhZWV4y6IUaRBZMqbT9uyxZd5/1rdvULqVFB0o
	gqnw6Ai5tnuw/iDyp7De9vMs9AhJCGrO1omrL7NsiBPElpDoS7L8
X-Google-Smtp-Source: AGHT+IG3zdJLlpnr4YMGnHBARjjI3k3jmK+vigqyhy9cel3bnwJ5WgU4GP+yPUZ/oLlX1seRUem1Dw==
X-Received: by 2002:a05:6358:d381:b0:179:272e:54e9 with SMTP id mp1-20020a056358d38100b00179272e54e9mr987022rwb.30.1707469905629;
        Fri, 09 Feb 2024 01:11:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU0PhkvLsxF+pFGpKPmBboiEOLww3D4Trh2Gnp8VhERt9RNQ+97flnppsx2wejpSO65vpdv3Kz/QekBz56jxf9FM2zOpoU5glNWmU+dHZHfjMM0wlGpxuSbH7HC4cQl0adtxvkosWDhxvIpC1Ez47nwO3G2bzjlVV7rao9m3dv73deWpUcOO8P+oFeW1BZOHt8jnAiUjaI1WQkiXQEez7QX8A+5eseqHuIlJQFpRMj530lUtXdGv5gO/Pwrq/ujaHwX/SCp/L+WgPcb6bmC8F48wD8SgSFQRK6o7i2hN8ANZHCU2NnTf9+9r+1PV8meIp1RVCMdgT+shuhLmzkqXGvWQE5jFiVvQx0NZ1gvyczsTIvSdCsLLnGYB/TJ33N0WYKA+Ay/rRmS9rWN7QmnDK0gatGkS0vEK2xtYymb9s1/mY8vCDxyJiiA/03cywPsAfejpyCNUWw8kZ28mnEyU4QXOmA4CYFY/frvo3IEoarAPLGyZ5XJ/uY2M0lxLKRjZTvsa8iUJLhEUOInj0UIZLTAJEZ9zEGa3nzxNIlggEV4CKbdqTWPXczh
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:11:45 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 0/8] Multi-migration support
Date: Fri,  9 Feb 2024 19:11:26 +1000
Message-ID: <20240209091134.600228-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the detailed reviews. Hopefully this is the last one...

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

 arm/Makefile.common          |   1 +
 arm/selftest-migration.c     |   1 +
 arm/sieve.c                  |   2 +-
 arm/unittests.cfg            |   6 ++
 common/selftest-migration.c  |  34 +++++++
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
 18 files changed, 253 insertions(+), 108 deletions(-)
 create mode 120000 arm/selftest-migration.c
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0


