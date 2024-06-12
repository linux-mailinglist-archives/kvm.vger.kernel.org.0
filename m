Return-Path: <kvm+bounces-19393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9E3904A22
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 06:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 546EB2839D6
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 04:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87AAF28399;
	Wed, 12 Jun 2024 04:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NH2Twx/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086322092;
	Wed, 12 Jun 2024 04:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718167373; cv=none; b=sEoaU528KWUDz6iLN3yAUYr1yUDUDYJRB8t+bz/hTvcwwCTsShxxxUeFCSdoz5qkfPa+oDWwi702cs6JukqHw+Bd2u7f7fvK9m/pEMmeYJVUNfhX1hp0iCs4vVcpXNMiMbJiZq/PsS9+IhAWh4ufqdOCu/x9A9GPYJn58bDQKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718167373; c=relaxed/simple;
	bh=uybxDxR4RrOc+lmzdhnsTV2MydU3qxq3iFowjLn3ArI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s8jlUQLrx4t9ZAGLS29rsoF9ViyxMndObs3h74YSpb9mrDsFm7cqqBS0fUeGTinsd9wF5fqk3bij7+VxMvVjDZ4BiBylbQbHaL9zoUYidPBc+fE4x4i5PPZ0CNwpzwEfcJ81C8YAal+4mVnnEcdBxANBsmF6+b0w8joN5SIRu1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NH2Twx/M; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f717608231so20497415ad.2;
        Tue, 11 Jun 2024 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718167371; x=1718772171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y8v3v+i8Ggw/AVGwDDCI9JHG5YYl3a/3EDerkme1e7c=;
        b=NH2Twx/M9q8YPUIjuP9CH9zL/D4epXkF57DDmKfpR0mI9UlunsMkGG8lnGtB3pADJO
         sblqYI84S8vxlwUwMU8rlRw8tkL/BUChO425qwAuXlLhJLIuWeDJaRz0K44b2cwDt3pX
         tghZWjHWdv6OpvF6GPG8v+ARWpCq+crHjS82gxAa19x57CtuInpJGgD37boEzAGEjsZO
         W6ZlKrzpNeW5vJycPNTNuahadrimsfm9xxjGwKIs3nzTWY5XnYS3OhrcOZOQ9XVvaS71
         rdqNMj1wOJ/bOyK+ZtsZnjhLrGx5p+zbsPra993hI7DF9twGEg2urGiCQVHeJz3gLJ/c
         22Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718167371; x=1718772171;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y8v3v+i8Ggw/AVGwDDCI9JHG5YYl3a/3EDerkme1e7c=;
        b=VAVU0bc1Uv9X3eR2gOMd/e6t/lFKh4C6lwWZ9LcErKB7TPU1FcynpeJvypHhD1jP8S
         6DxAvtuXsA8mibU6p74+t9VCm14cZCCRsRsoCYHVs1nIJFzUZ3URxEclCQGXp46Hlc6U
         gQOHIdJNJ6IUAW11qMKSsHIxnLn5Hhmpg4mg12sflepI/X2tZYHAWtjDML4n8upHy03R
         shwWS5Ogny9ihiQ7gPPyCWibf2Fuc+OFIc5/HTir53gX/Bpnuymxbsfz2T+VILYu9R9K
         U5G/PxCGjqnC5RgeuXgTAwhwbOni6dT3lYdSzPNmi6LX2mXVCSR+jYhW//Y9qcmSHpnB
         YJ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUY6M0UEL4u0Rt8JE1Ed1vsaD0hW5OtmvPPxHhASX35AodI1DOtdO6eDIa75WCFWANbJxYfNfrh3n91dShETKTUFQNMveWRkNi9XxyRkyY/avNestfiizKmHEyJoNN5dA==
X-Gm-Message-State: AOJu0YzcoOuLRV2hGAPKUlued/UaLUetQINRm48723HPTgvJZPIvCJoW
	i9sSnyNTRMGTZeajmuLcyiE/QEIDWbSpwX7MMzSG9LYOS2OoSp82
X-Google-Smtp-Source: AGHT+IHpwHlh4iJRWgbNKg9wzqjgXtSTZ/ZgvwJw6UxQFuG3nQAI47SaA434g24rShYkZX8sK7hePg==
X-Received: by 2002:a17:903:234d:b0:1f7:3d0d:4c8 with SMTP id d9443c01a7336-1f83b569c9amr9508185ad.13.1718167370569;
        Tue, 11 Jun 2024 21:42:50 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f71017b639sm52957535ad.21.2024.06.11.21.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 21:42:49 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
Date: Wed, 12 Jun 2024 14:42:32 +1000
Message-ID: <20240612044234.212156-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
in dependency chains that cause them to be made as intermediate files,
which get removed when make finishes. This results in unnecessary
partial rebuilds. If make is run again, this time the .aux.o targets
are not intermediate, possibly due to being made via different
dependencies.

Adding .aux.o files to .PRECIOUS prevents them being removed and solves
the rebuild problem.

s390x does not have the problem because .SECONDARY prevents dependancies
from being built as intermediate. However the same change is made for
s390x, for consistency.

Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/Makefile.common     | 2 +-
 powerpc/Makefile.common | 2 +-
 riscv/Makefile          | 2 +-
 s390x/Makefile          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe01..0b26a92a6 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -31,7 +31,7 @@ CFLAGS += -O2
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 
 # We want to keep intermediate files
-.PRECIOUS: %.elf %.o
+.PRECIOUS: %.elf %.o %.aux.o
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index b98f71c2f..16f14577e 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -30,7 +30,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
 
 # We want to keep intermediate files
-.PRECIOUS: %.o
+.PRECIOUS: %.o %.aux.o
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb5..7207ff988 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -53,7 +53,7 @@ AUXFLAGS ?= 0x0
 KEEP_FRAME_POINTER := y
 
 # We want to keep intermediate files
-.PRECIOUS: %.elf %.o
+.PRECIOUS: %.elf %.o %.aux.o
 
 define arch_elf_check =
 	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64..d436c6e9a 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -85,7 +85,7 @@ CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -Wl,--build-id=none
 
 # We want to keep intermediate files
-.PRECIOUS: %.o %.lds
+.PRECIOUS: %.o %.aux.o %.lds
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
-- 
2.45.1


