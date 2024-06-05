Return-Path: <kvm+bounces-18858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C997E8FC5F2
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14EA1C20D14
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 08:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AC6194132;
	Wed,  5 Jun 2024 08:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UuRf3vlv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EC2193071
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 08:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717575394; cv=none; b=C099OrDrNivy8MuZ6UmghLS0YqJKb2AxIFtLSpYrApTzlSCVOuWihmFEycWKKjQSoJetkHyqm47Q8MJkeoh5s+m0dFzhgwxn04XGUNIsJWK8yyh9H7EH5mR6cQPVk0XBxjXYbHX9EtsHLikjGzjSQ42xrw7/fWgKe4vHc9CpA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717575394; c=relaxed/simple;
	bh=JkoW7OO3oSO3kHjIitviFo4GyxZqbp/nlhKOaPB2jik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pL0YwebtXUtafzq6lrX9DoR3f+N8+gHIhMqT/p1uVVMO1j3XMUhq3QEv42a0i+cOad+oy3TIal2G3D8Y5my4RJANArm7VfWMsDXMQmhrd7EAumYkAFR9X6b275viMHXUvvkFm0a+pB6SI6OBvUaaFHoTb+oLvCUkrrJ6P7O5Mso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UuRf3vlv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f4a5344ec7so5336885ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 01:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717575392; x=1718180192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iakJGz4msSJJF2YzJH4MDKnSQWVMhYg8DDb2ecXDNzc=;
        b=UuRf3vlv69u1QMAWWnSpFwAvyO3ayPoJR/AUuYuOqdJIxOwwV2qRLnhnAHij8xcegh
         5ELH1BSSMRiBIfv+X0+9ANRVBDqCgkP8DGZ+1KN3q2c9f50wUR2eLFC0lkWzheil0Apv
         c/niPn49wCiGVUICmipUkBkZJyeTx0EOfZZihi8h2l1CAxBlAf3v4F5N3Bu6W1UpxZ48
         dFSyolG2nubPifFu2my/8XaRPDk1mxdGJK9buO9IxlV4nJGx9UL5tAZB2T0e41sYJOjo
         iQgzQZBVH41XrqxEJAQ2Dlh/bCVcdFvK1qilFxWGS8IC/E1ZEzpsgxu3qU7uP60gzV7C
         p/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717575392; x=1718180192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iakJGz4msSJJF2YzJH4MDKnSQWVMhYg8DDb2ecXDNzc=;
        b=ce6c55Bd94RFFuLbviltBVGVHObHoXWx4kf5wCAGi+/szzd9z/dEaf4Up+k2Pc+q2p
         knTdhvdWNZvS5rpV871geucNVDz2wMQbWuPV+3meRUhGU7p6ugL7izLJQXiwh9Yq8+S+
         MtBrRf6fmqt7vELwKshksEuY8w5RS6xAfdQaVkypHwm+/F0xPiUVbflndcUSgqdt6uGW
         /4xk+dTG4am6z/8bDtUrrLIQ+GZ6MX+kP1wKtWav7kdS3rBAcv9cfcA2R+UyP+Pblvf+
         scPCzkYUjeDfzpQgbz6A6IAYz09mwj3QYb+mFVeiZxnV63jh+UCbHHvNvTSVGL95smLF
         l27g==
X-Forwarded-Encrypted: i=1; AJvYcCWjKpTlVGLmCK2XjOdMYYZRQ2CYwCXLdwuWndHN12FwhVSYO7+9Vvc2/zV4H/ULIl68C/Qp5yzbDaEEwE921WXb/l96
X-Gm-Message-State: AOJu0YzksPW7I2vpCFCuMOZ0BZF60uc1T6veyPVsOjdPdVPWCjzVziO6
	UwqsuCeq/yjxZTtcuVy0l08d7MkdRWuRhC1g0V/QR6dWJVaMRj3y
X-Google-Smtp-Source: AGHT+IFzj6yqQ7tbLZIcYlKv4QNi+9o4ynK0kj4F4ChTJoUw8kInQmCmd3jYzsmuQ/FOygra3ead5A==
X-Received: by 2002:a17:902:ea07:b0:1f6:87f:1156 with SMTP id d9443c01a7336-1f6a55b363fmr29370225ad.0.1717575391800;
        Wed, 05 Jun 2024 01:16:31 -0700 (PDT)
Received: from wheely.local0.net ([1.146.96.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f681f9d19esm45845565ad.111.2024.06.05.01.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 01:16:31 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	"Marc Hartmayer" <mhartmay@linux.ibm.com>,
	kvm@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
Date: Wed,  5 Jun 2024 18:16:23 +1000
Message-ID: <20240605081623.8765-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's another oddity I ran into with the build system. Try run make
twice. With arm64 and ppc64, the first time it removes some intermediate
files and the second causes another rebuild of several files. After
that it's fine. s390x seems to follow a similar pattern but does not
suffer from the problem. Also, the .PRECIOUS directive is not preventing
them from being deleted inthe first place. So... that probably means I
haven't understood it properly and the fix may not be correct, but it
does appear to DTRT... Anybody with some good Makefile knowledge might
have a better idea.

Thanks,
Nick
---
powerpc and arm64 remove .aux.o files because they are seen as
intermediate, I think because they don't have an explicit target
(for some reason not s390x, haven't tested arm or riscv). This
causes them to be those files to be removed after the make runs.
If make is run again the .aux.o and .elf targets are rebuild,
but for some reason they are treated differently and not removed,
leading to the 3rd make being a no-op.
---
 arm/Makefile.common     | 3 ++-
 powerpc/Makefile.common | 2 +-
 riscv/Makefile          | 2 +-
 s390x/Makefile          | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe01..3ebbcc13e 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -72,7 +72,7 @@ eabiobjs = lib/arm/eabi_compat.o
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 
 ifeq ($(CONFIG_EFI),y)
-%.aux.o: $(SRCDIR)/lib/auxinfo.c
+$(tests-all:.$(exe)=.aux.o): $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(@:.aux.o=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
 
@@ -92,6 +92,7 @@ ifeq ($(CONFIG_EFI),y)
 		-j .reloc \
 		-O binary $^ $@
 else
+$(tests-all:.$(exe)=.aux.o): $(SRCDIR)/lib/auxinfo.c
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(@:.aux.o=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index b98f71c2f..3b219eee0 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -52,7 +52,7 @@ cflatobjs += lib/powerpc/smp.o
 
 OBJDIRS += lib/powerpc
 
-%.aux.o: $(SRCDIR)/lib/auxinfo.c
+$(tests-all:.elf=.aux.o): $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive)
diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb5..4610cb4d4 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -81,7 +81,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
-%.aux.o: $(SRCDIR)/lib/auxinfo.c
+$(tests:.$(exe)=.aux.o): $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
 
diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64..4c0c8085c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -178,7 +178,7 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
-%.aux.o: $(SRCDIR)/lib/auxinfo.c
+$(tests:.elf=.aux.o): $(SRCDIR)/lib/auxinfo.c
 	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 .SECONDEXPANSION:
-- 
2.43.0


