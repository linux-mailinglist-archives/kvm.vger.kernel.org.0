Return-Path: <kvm+bounces-66430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DC6CD2333
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11C1E3086ECE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA1B2DC783;
	Fri, 19 Dec 2025 23:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mlfNE4gW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDFB2ED84A
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 23:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766187511; cv=none; b=KMEdRWfLZU7b+5Op0cxixRwaj9DfMAaQs5hkBCdoX/tXuMKk66VrPvZXosAOI8p9y20Ca1307X++9bOCHYWlkF1EnyYkyyPbQWaO8S0JJvF16Ye68D1RwfY9vzu9327hBpc+jDIDIUJQj3l/7LOEDDd7bzFSkDzSG1VZnK5z0PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766187511; c=relaxed/simple;
	bh=JyC9eo530M5ljalMP8uuCAafPZED6nTNfGN1kJNfXdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rncBP4Z+OzYuKeHSKnwGppSaXalbiy4l0tBJP2r/I3HI5sl+UXhJDQhd3B6GCQ1SyggH0H1f+hofTMfK4Q4ricLJ/a8gabUwp/HbaiOwNcmY+kooPiR7EbjCc+VZlIiXg9ibixrM+JCMf2OGifKMf0et1NJDdRlPsjnuuRkyCzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mlfNE4gW; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9321b9312so4421659b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766187509; x=1766792309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYrEUFHHSrWSjApG9MRx026qZB/VzRtJqC7WAFxS0uY=;
        b=mlfNE4gWkMVLCavOHNJvzXBoNZqjNweEDxlHLW//oNNSLlw8B170gL71o4v4WbROYt
         DbrxwA4b0PFsqPXmc7q8j4IP9/pXoBoDwENSgboW3gyfa5dWXCa+kEITM20M/irBGkIP
         RsnqPKI+5cDzOPsQUi56ZEj8U8mRPfTNz9Qwc4FDFJsPcxurJFnsrGCK441xZEe6W4dP
         WxI9p5c+fzwslqR7e9gFAkDQZHV8DUSuOD4OlpRVC+dGyCzLhZ7CHhagnZWQZKLtq/XW
         kLnsJCS79qe3uyO/60kFSaA2u5hjGIGDM1BCeVDF22VOvLCChNDrR5ZqGv+o/nF5hICQ
         FhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766187509; x=1766792309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYrEUFHHSrWSjApG9MRx026qZB/VzRtJqC7WAFxS0uY=;
        b=phzJw7EoOJEV3mFOGjoL/KZSLAIQ13gX9IL4zcTUJHnngGltGeBOdk6c9AXQCweXdj
         Qjhpxc4ligc121KSr+nFR6g3/5anagV5a/LvTUAD2zLe9TwNEWbCDfNgzAnKF7CjyMzG
         BHDaL3KzyTEbu0NF1bzfdmlqK8Siqns9IhDyDjcbYdoRzmFAln2TiINWTv5w/7Teb7aq
         1Q5omGiYtiy+UmMGmULkKHPnXR4z3YKL9JLYYhBhkYrulBRnzxihi9+XslIMQaNlJFAo
         +7qgmp8H0j/oy4VwnqMRkkm6Mn/PUarUeG/j5mtRTXKwYZAiEXFRw8wJ6vqfgmuUf3L7
         xTlg==
X-Forwarded-Encrypted: i=1; AJvYcCXC2ncFWQKhmx41Ji+NS4LLLVFVt81+G/nf9I+64zmiDWwdVdX/7Mu/wSaAajlGMUGXJtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw39nPBS0SHnQquDEEDxotH4EiQTyNKEl9lC5Jw/NGWwXtER0/6
	BHOohP2r1Yp2Rq5qRMfAITvQ11HWHqrvkSmwz5zIHLcCMkv2wGwlFtS7T+GfulSGEeog7O/otKM
	UxoWacKXUGczMyA==
X-Google-Smtp-Source: AGHT+IFdwBcyxhazmcoTlALhwwLvbQZw8lpAuq+J+NHXrsmB1i51VsdgscFDGcvBfCw/ezW9ut9mRL7qW+KWSQ==
X-Received: from pfbcu6.prod.google.com ([2002:a05:6a00:4486:b0:7fb:bab5:e6e1])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:278b:b0:782:7052:5167 with SMTP id d2e1a72fcca58-7ff650c7fe1mr4234814b3a.6.1766187509445;
 Fri, 19 Dec 2025 15:38:29 -0800 (PST)
Date: Fri, 19 Dec 2025 23:38:18 +0000
In-Reply-To: <20251219233818.1965306-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219233818.1965306-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219233818.1965306-3-dmatlack@google.com>
Subject: [PATCH 2/2] vfio: selftests: Drop <uapi/linux/types.h> includes
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Shuah Khan <shuah@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the <uapi/linux/types.h> includes now that <linux/types.h>
(tools/include/linux/types.h) has a definition for __aligned_le64, which
is needed by <linux/iommufd.h>.

Including <uapi/linux/types.h> is harmless but causes benign typedef
redifitions. This is not a problem for VFIO selftests but be an issue
when the VFIO selftests library is built into KVM selftests, since they
are built with -std=gnu99 which does not allow typedef redifitions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/vfio/lib/include/libvfio/iova_allocator.h  | 1 -
 tools/testing/selftests/vfio/lib/iommu.c                         | 1 -
 tools/testing/selftests/vfio/lib/iova_allocator.c                | 1 -
 tools/testing/selftests/vfio/lib/vfio_pci_device.c               | 1 -
 tools/testing/selftests/vfio/vfio_dma_mapping_test.c             | 1 -
 tools/testing/selftests/vfio/vfio_iommufd_setup_test.c           | 1 -
 6 files changed, 6 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iova_allocator.h b/tools/testing/selftests/vfio/lib/include/libvfio/iova_allocator.h
index 8f1d994e9ea2..c7c0796a757f 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iova_allocator.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iova_allocator.h
@@ -2,7 +2,6 @@
 #ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_IOVA_ALLOCATOR_H
 #define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_IOVA_ALLOCATOR_H
 
-#include <uapi/linux/types.h>
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/iommufd.h>
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index 8079d43523f3..58b7fb7430d4 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -11,7 +11,6 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 
-#include <uapi/linux/types.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
 #include <linux/types.h>
diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/testing/selftests/vfio/lib/iova_allocator.c
index a12b0a51e9e6..8c1cc86b70cd 100644
--- a/tools/testing/selftests/vfio/lib/iova_allocator.c
+++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
@@ -11,7 +11,6 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 
-#include <uapi/linux/types.h>
 #include <linux/iommufd.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 13fdb4b0b10f..0b335e4e0435 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -11,7 +11,6 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 
-#include <uapi/linux/types.h>
 #include <linux/iommufd.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 5397822c3dd4..41b8cae7a6ae 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -3,7 +3,6 @@
 #include <sys/mman.h>
 #include <unistd.h>
 
-#include <uapi/linux/types.h>
 #include <linux/iommufd.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
diff --git a/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c b/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c
index caf1c6291f3d..5d980b148d83 100644
--- a/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c
+++ b/tools/testing/selftests/vfio/vfio_iommufd_setup_test.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <uapi/linux/types.h>
 #include <linux/limits.h>
 #include <linux/sizes.h>
 #include <linux/vfio.h>
-- 
2.52.0.322.g1dd061c0dc-goog


