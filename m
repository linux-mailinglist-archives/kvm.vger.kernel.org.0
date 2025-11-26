Return-Path: <kvm+bounces-64783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D12C2C8C536
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E2223B62B1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6A9345CAC;
	Wed, 26 Nov 2025 23:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGDLe4fU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB18345CA0
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764199075; cv=none; b=Lqv/Xzqw646Az4DCzcBLWTrCT+1q9EAeU7cxuf5D4G/u3TJFxG8P9D08POtLtQ2GykFEcRXClQCo7nVCZFoIn5CPC0jTK+4Mdm17tBLI7TnZjkTqul0KT9xN0rqKot0wv9QrQuxDYc0phHGJJjuJrZPPUHc3bukIRtIdDfutQAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764199075; c=relaxed/simple;
	bh=JHnO3koR6MtcgW1mrjyeErLO/KQbfdQegGSHdKrkPgM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H4BxRI3xEhJO0IQK96YTkKImFfFFkUs2Ug9Zov34Zwvtt7F9Igxc2UU6nMD1mHnHoSe3BNy9CUmcNa140KHRxKWTa5e09cG5lzgkPAqqKkZ/tlRkUaHd1exIRfaD1AGoBgIhOqmT5kzxrucxU9U1ZxRMmoCirVI8lnU5cKC2kVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGDLe4fU; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9c91b814cso648853b3a.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 15:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764199073; x=1764803873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EwUBc9dRFUqPZdHB+UIvPAI/agdY5EOkuuJxwmzSkeA=;
        b=MGDLe4fU3pVUUEhuxBKHp7DCs2zdVkOt2mUGTgxJGEuI+K1Dxz2pA7UVmtyC4ZG+03
         YgvdLQZY7I6+7kiOmBrHBPyKPFqwtwDBOXMllHrTojy+w7BapfXLA6Hl9DEfPUbr1QOc
         W6EtXcbc/ScOP5R4yqFlrKZn5kFJuB1rCZuISihoJh7jQv9KqByK62PL9KLUUCGWTGh1
         VX56rtsL27MVglgx974TDbXXIypn5QfUjEeOC8mn1lAw5hFtsR94KeOhiw5Q6+yl8wXm
         VAVRQFZEtVZaTr+MxOAKw0vJ8wT26vcsTKB5yEE0oBk/z8M/UTuhZ9RJBhtH+1j6HtbZ
         i0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764199073; x=1764803873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwUBc9dRFUqPZdHB+UIvPAI/agdY5EOkuuJxwmzSkeA=;
        b=KL0PLqbflU5BYETKPcNwLXPQvBZt/xM0wrABOzAFZsDafLrrFXlYDDpE2/LWrgSjGo
         mWipk2e33XaRAzAxkta2+FQwKG9bI+d8t6/oIloZHi8o98W9GxRyUnRk4zhfvAVrNb9f
         ucLzcJvwhjccFsnOswkfwcSSTnCfp2FULO73hetjUHIF5Sqypv2a1H6arsbG5V7ARsnE
         lxNuZmnnJEIjDqGl00cKgu45eZd1+J3nLVECRtRm04H/8F3r7m0FiF3xDmL3ANyAL7Za
         82CLGxuz7sElOZ94qjytfD6oA7RBECm0bIz1YyLwuRTgBN2uJSRmr4RA8djpTEpONEV8
         vuxg==
X-Forwarded-Encrypted: i=1; AJvYcCWVapLFH/NBPPFmSeHB273zam1uuRJW7RinUs9225RnTIfZ/X7koLld7bw4472wmtJJO08=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ77wF3GOkgv9/xCuyW65GUruORHKJ5hNfr1RyolhR/7p1jDS5
	qCFdKprHgDaanvz6fm3CyVQmoFHR0RgzcfBcPENKTuX1K1eLYqw8fkxgzFWETV1OFo71JrgMnuc
	OUD0u/2R+felo0A==
X-Google-Smtp-Source: AGHT+IFm4sH1ZXQuEmtE0xbNl954CjkawYuUdXUg10ZoaftL/Uqduh+oNqyjicfbmxei5yPTlHJJwCBMW+B2Yg==
X-Received: from pfie24.prod.google.com ([2002:a62:ee18:0:b0:77f:61e8:fabd])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:914a:b0:35d:8881:e6bb with SMTP id adf61e73a8af0-3637db7a71dmr9590225637.22.1764199072920;
 Wed, 26 Nov 2025 15:17:52 -0800 (PST)
Date: Wed, 26 Nov 2025 23:17:22 +0000
In-Reply-To: <20251126231733.3302983-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126231733.3302983-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126231733.3302983-8-dmatlack@google.com>
Subject: [PATCH v4 07/18] vfio: selftests: Eliminate overly chatty logging
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Eliminate overly chatty logs that are printed during almost every test.
These logs are adding more noise than value. If a test cares about this
information it can log it itself. This is especially true as the VFIO
selftests gains support for multiple devices in a single test (which
multiplies all these logs).

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
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
2.52.0.487.g5c8c507ade-goog


