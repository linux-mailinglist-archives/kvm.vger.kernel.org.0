Return-Path: <kvm+bounces-58429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 869A7B93848
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0AB218942C9
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D202FC86F;
	Mon, 22 Sep 2025 22:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nYK3dyaX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A9D31691E
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 22:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581355; cv=none; b=mbh0Zljx7r8nZ65cZzcMzt2SNDn0V0B8J97Mwl20l0ttUc9abBhDsZPxEYpPInXwcSLMhy8VNM5Xz2xIPh73Zh6etxptvRwfXpSz8lLCWX14zXkIcNZd0hUmhbv7ehwEpzUSxw9ewldHnxvZRJLJjSqwpGVyKqNxWy4d5aZxfHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581355; c=relaxed/simple;
	bh=5QNyl6HSB4ZmEtWfJZ+xy37nKYlUmhxWx4mCsLt2NOo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Z15Zn2eUtmEo4DBx6RKe+YwCh4RzAV3tnwaK8RH9vRomj9SvUHCvwny6rnk1yVKkGYBmm4y0ryrm4jRnjSYdPoy1zVtR5fAfavmdtWegVBOymaGWdycA3dT9dS3nj2o97M/vaJwhCyloi83WojCAB90hBHhfN9eMQLAO7ocD1VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nYK3dyaX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33274f8ff7cso2252011a91.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 15:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758581352; x=1759186152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tg+cfyJ8iHTctEj7ru5BA/5vFiRl/ZrC7hQcrJdFfGA=;
        b=nYK3dyaXhNNHyKYGvn2tubl8KaMcRKcYNd3Ye5NR5STCI6/O9wDM+/UaNPq0ja2qp5
         0AfiKYjExFdLDNhno34lwnlYY0qaVGeUhJWfT1406damWSlLu9o9M9RTp6NaPrMM7lsU
         va7nEa8co2dLX0GvVZBM7YbhEY2MwvaRPr9DbkOoa9UYkzh8hQ0XQg9VCzxX5M4zCm9g
         ++Zeg9ijHqubYfyM9lLm7saKDhrrhmrpvNqMLu06m4HG9OzCLk8L1820zN1+FAfvHZiM
         d2uleQgcyIoZP/B6fY2+FBsbB9eMLpzKbogCfYzOJq/VUwOAYKvFrVjtNr/GpZXcc3D8
         Pv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758581352; x=1759186152;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tg+cfyJ8iHTctEj7ru5BA/5vFiRl/ZrC7hQcrJdFfGA=;
        b=hicYECljzUqFd1HUBAs8zJcL6FVRAFcmQJqk3EvIaIpbQSadQHu3mODYUL2MeV4Phz
         82FmmvUZjBeS4uhx+CEtqKgK8uzGa66JPe9MoArcIvklqIfdXmzOjKuNAr7dQ3mplZGP
         sX5H4NvyXhhIVGIB+D1bJ9fLqQbyYFa617p8YPG4hOzwDmTz5QeMMSznU2MZPVsqmEjK
         G0lOB1OYuYa/9qkC+1hjHJsdpulIJXTgtOWsk5Wg+DKz+qMyQd8jtp/1PjpxE1axJDXV
         6rvvFeivpuT5S6YexD+eq/MIaUgaaq7axSiNnJ7Hkr4ztCmXOKO3renJrfs+mP3tlQVp
         4UXA==
X-Forwarded-Encrypted: i=1; AJvYcCWskYsXW9Jspe/LX3ceAgHfWgpIl9qy7iRyVCOjGTG9pZ9rjjWyUC1qNk1AeKKWBjT4i+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWL/ouxumGxeFBzGcfK41lI4NSZHxAvmKtKZsJjqkNSm9ScEhn
	6IDHkh3XkIpcOCcRf4ESCcsN1W/JAYbghuo8Knruxz3GxnWNDtGk7q1jCCFu65fIl9WFTBH1M1Y
	rPMxHIQ5EyWf3pg==
X-Google-Smtp-Source: AGHT+IGjxw6fs9lVd3Db6O2V15gm5vIsTH02Zn0TJdHjDmTLj28al1yn0EUqz0lmxJAOfsqMXRMLoQm1Kcspew==
X-Received: from pjbsv5.prod.google.com ([2002:a17:90b:5385:b0:32d:a0b1:2b14])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec6:b0:32e:1b03:6e12 with SMTP id 98e67ed59e1d1-332a9546a9dmr614277a91.13.1758581352286;
 Mon, 22 Sep 2025 15:49:12 -0700 (PDT)
Date: Mon, 22 Sep 2025 22:48:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250922224857.2528737-1-dmatlack@google.com>
Subject: [PATCH] vfio: selftests: Store libvfio build outputs in $(OUTPUT)/libvfio
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Dave Jiang <dave.jiang@intel.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"

Store the tools/testing/selftests/vfio/lib outputs (e.g. object files)
in $(OUTPUT)/libvfio rather than in $(OUTPUT)/lib. This is in
preparation for building the VFIO selftests library into the KVM
selftests (see Link below).

Specifically this will avoid name conflicts between
tools/testing/selftests/{vfio,kvm/lib and also avoid leaving behind
empty directories under tools/testing/selftests/kvm after a make clean.

Link: https://lore.kernel.org/kvm/20250912222525.2515416-2-dmatlack@google.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---

Note: This patch applies on top of vfio/next.

https://github.com/awilliam/linux-vfio/tree/next

 tools/testing/selftests/vfio/lib/libvfio.mk | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 5d11c3a89a28..3c0cdac30cb6 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -1,24 +1,26 @@
 include $(top_srcdir)/scripts/subarch.include
 ARCH ?= $(SUBARCH)
 
-VFIO_DIR := $(selfdir)/vfio
+LIBVFIO_SRCDIR := $(selfdir)/vfio/lib
 
-LIBVFIO_C := lib/vfio_pci_device.c
-LIBVFIO_C += lib/vfio_pci_driver.c
+LIBVFIO_C := vfio_pci_device.c
+LIBVFIO_C += vfio_pci_driver.c
 
 ifeq ($(ARCH:x86_64=x86),x86)
-LIBVFIO_C += lib/drivers/ioat/ioat.c
-LIBVFIO_C += lib/drivers/dsa/dsa.c
+LIBVFIO_C += drivers/ioat/ioat.c
+LIBVFIO_C += drivers/dsa/dsa.c
 endif
 
-LIBVFIO_O := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBVFIO_C))
+LIBVFIO_OUTPUT := $(OUTPUT)/libvfio
+
+LIBVFIO_O := $(patsubst %.c, $(LIBVFIO_OUTPUT)/%.o, $(LIBVFIO_C))
 
 LIBVFIO_O_DIRS := $(shell dirname $(LIBVFIO_O) | uniq)
 $(shell mkdir -p $(LIBVFIO_O_DIRS))
 
-CFLAGS += -I$(VFIO_DIR)/lib/include
+CFLAGS += -I$(LIBVFIO_SRCDIR)/include
 
-$(LIBVFIO_O): $(OUTPUT)/%.o : $(VFIO_DIR)/%.c
+$(LIBVFIO_O): $(LIBVFIO_OUTPUT)/%.o : $(LIBVFIO_SRCDIR)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-EXTRA_CLEAN += $(LIBVFIO_O)
+EXTRA_CLEAN += $(LIBVFIO_OUTPUT)

base-commit: acb59a4bb8ed34e738a4c3463127bf3f6b5e11a9
-- 
2.51.0.534.gc79095c0ca-goog


