Return-Path: <kvm+bounces-62933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19622C542B3
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 20:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC4E03B2DF9
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935B1351FC2;
	Wed, 12 Nov 2025 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xJ/3Kpcq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356E35029F
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 19:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975378; cv=none; b=jctkyjAukJ5N0Ypvx5rPbt6sXAOWtqC+kTEkMyTSiwk2F9nRvUPsQPXmQmx6WnujWu+ptoBN4Sa58EL3RgNyL3AsnkxcZsM+ArszfCAluPgbRFd2blb3MUdhQbZ7bCGDjWJZ47/qvSd2RV8MPlB8TLh/kZq0YFYB1qR5FnV/B6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975378; c=relaxed/simple;
	bh=j/qVMd3MvTUa/awqSQUVlSj2s5CofTYFxaDMQ6ETcQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k0eY9JWG3VNJ48MmeiiJIL1BHRLFV9JVjFfCV+0N4rUtwYKcBukwG5fQtLRhz7CJIZt4nYgeAZffRNJeqoMjnXuGe9dKnndG1LD4/HTTjqgWM4v+DQCIWPpMmzFj5QnZBa1PZvUyejbhAKBMbKL5T1U5UtuBTAAXOs509NUGcHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xJ/3Kpcq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b89c1ce9cfso472645b3a.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 11:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762975375; x=1763580175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uiy8tigNPCCZiWR1z0pXaHh2gPneQJv15HEUGvJLWqk=;
        b=xJ/3KpcqBs0X4k3M+3ipJtsI+tnSa/yk9cTZZQ5MLT3/ZI1hmbi/xeet3jeUznt6mj
         sEaMowcGVU2vs49ZPiy0aHPcTCpjNYfYhiq9Uq/TPcCRR0WRv7nlctWe20CNeyrozuIP
         YqX5CSqQpk7Ue1ccdbRV1FBCG2NSnW4ndiffv6ezIwUt1AetyZj3xiN7gDtUPQL1kCxw
         ks2qyO0lewLw4d85dTUX90/Xybyy28A2vrdd2wZ9D7/jb6DtNv0cTz+PhULKYIk2Tg5m
         nEZJbY7PGYqfxtOep/ZIHXJ29SQhu4dKdRzT76w5MnX8AQmu2dxTyY/S2/me7YVQm2cq
         v+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975375; x=1763580175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uiy8tigNPCCZiWR1z0pXaHh2gPneQJv15HEUGvJLWqk=;
        b=HMdRZxg765B1xbbgpetc2VDkiNKKx1zWmZY4ugdZ48lUHb4RjBatTwv3ozIkMmKTPK
         F5YGwIi76UEnG7tsoVsm9q8+KLVwET4XZ2vpwODzDESrqWKT+8unwWoFpVitWzWLcthw
         fxLsP/n7UXfgcNzGkt81JopHCgw9ExOqkxnf2Ed6FIccxaLh+KjvZV2uXmDpjlaq294v
         UqOpwxCfG6Ub6yRJuQ9g1KARC2qbXislTp4pn1b4vvkf2xIuMK8P+qwxg1O9MaiQ3ejN
         wzq0Eb5SrJUufKXJcBH8soYzjaoztXcH4TawW16iEJ2fl3gcug2RDva0+2ip61y03gG/
         0WZg==
X-Forwarded-Encrypted: i=1; AJvYcCVTQLsrd1wBVNRw+7IM9CPhohCOsTK/ikmgrhmiBHaLoSw2Jbv6jDpdIMMX1GcLXoUkgss=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyVg3jpkrntgZCzaHINNzi5tqJplADunsajpCQ4zqFGpDUozbj
	HT4uJfetblnDJv3HVDn8aRYVQRn1c8UO6GB/xYVLlEbh+fOe4eVNT49+pkuo1F/HlxjgiWB3Jdj
	8D1C+1v6Zpt0jIw==
X-Google-Smtp-Source: AGHT+IHTkEQKZW/Nui6RQdGyae0bAnsLjVZr/UbRZUUfe/uM6cYPChsHxARiYwiuw2YD0ipNO5ncGADz8WSHZw==
X-Received: from pfbei24.prod.google.com ([2002:a05:6a00:80d8:b0:7b8:2d09:cf])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e083:b0:350:b8e:f99b with SMTP id adf61e73a8af0-3590b51dd7dmr5088842637.45.1762975374835;
 Wed, 12 Nov 2025 11:22:54 -0800 (PST)
Date: Wed, 12 Nov 2025 19:22:21 +0000
In-Reply-To: <20251112192232.442761-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251112192232.442761-8-dmatlack@google.com>
Subject: [PATCH v2 07/18] vfio: selftests: Eliminate overly chatty logging
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>, 
	David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Eliminate overly chatty logs that are printed during almost every test.
These logs are adding more noise than value. If a test cares about this
information it can log it itself. This is especially true as the VFIO
selftests gains support for multiple devices in a single test (which
multiplies all these logs).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index e5e8723ecb41..abb7a62a03ea 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include <stdio.h>
-
 #include "../../../kselftest.h"
 #include <vfio_util.h>
 
@@ -29,7 +27,6 @@ void vfio_pci_driver_probe(struct vfio_pci_device *device)
 		if (ops->probe(device))
 			continue;
 
-		printf("Driver found: %s\n", ops->name);
 		device->driver.ops = ops;
 	}
 }
@@ -58,17 +55,6 @@ void vfio_pci_driver_init(struct vfio_pci_device *device)
 	driver->ops->init(device);
 
 	driver->initialized = true;
-
-	printf("%s: region: vaddr %p, iova 0x%lx, size 0x%lx\n",
-	       driver->ops->name,
-	       driver->region.vaddr,
-	       driver->region.iova,
-	       driver->region.size);
-
-	printf("%s: max_memcpy_size 0x%lx, max_memcpy_count 0x%lx\n",
-	       driver->ops->name,
-	       driver->max_memcpy_size,
-	       driver->max_memcpy_count);
 }
 
 void vfio_pci_driver_remove(struct vfio_pci_device *device)
-- 
2.52.0.rc1.455.g30608eb744-goog


