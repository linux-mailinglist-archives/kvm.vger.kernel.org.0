Return-Path: <kvm+bounces-59665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A0788BC6DAD
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 633B14EF5C2
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D632C327E;
	Wed,  8 Oct 2025 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q9AQkqRh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601122C3277
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965967; cv=none; b=tZVPNPs4uixEGW5LKWUYFuj7Zn9I89EoR6IZhjHg229njWoCRvnbc9MUabaWW11OX3s832SRPpe11/WhFUXRR/ac+9RpwkiEN+decl0uu4jVzyjHSeSUVQZIeP8NLJ1bQC8+fA1jFYKOzeSYvlbeZqd9mxtZ4XiJ09Y639si5fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965967; c=relaxed/simple;
	bh=dQKZCitLUp4AEbjo8VrTXTH1FgX0WhiaQGR2MhKdtP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7XCl0Z63wfB86W+oNnVHFPak7AX48OYh2hhYxqsVs4KGis7yWp1PKaeGGWmVDbbYwP2ybt6fjnH7X671Df9GmGmZGJhkkVf0ZG7tPmCjTQRewUEpOAf/n2mQbomUx8DQoZxaSEk/JhcmJFg6kxPZ3ce7QnKkRk5AOSknZO75XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q9AQkqRh; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7810289cd5eso711188b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965966; x=1760570766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Qr/aaEBlQ4MRoWoNcxCqFqhmavRVgxbyszyvABlT6w=;
        b=q9AQkqRhW2vCf8ifyfljL9rCofssKINogiRms3GdBpiAhYPzx2t2apW1yZ0iCqc64g
         0zo8lQ7vYWCIjoG09Amyc+p+uskIl8L+aGK0FJtg7+kVoZfAbXFlHlrTRzGbzGdR3DIZ
         whLxWmpIRfm1zGh2E/42cZLE84AHoRzqiKEAN4qD/5PwbWSrvFcJlUCTl/KKSoz+NrO8
         ecki8Ax48219SRcsWfmmw/9+TK1b0aivsEay4aJR0F5mNCJoZmM8JEonMlNNHRMIOaVK
         ob5OJQTY0RKcfRjR9QEJHNak/FmIVn9v4n3mxae27znGyGBhuWLh++7oXbf3Jx7VYCM2
         jG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965966; x=1760570766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Qr/aaEBlQ4MRoWoNcxCqFqhmavRVgxbyszyvABlT6w=;
        b=VsCotQ/nj6csSYpX+iKUKJyNkAfzKD7aKPOtOwKSKiTtKO9cvvJQNOzrtScIctZ8q6
         RyG1f/WbfzXu3dH2Y0acY8l6Uxrw9UNwMleoEGPUW4EEdymvZZQVGyYmU2yAllj0Bci5
         pAMd4kXgMhRCEyXgr9gRziXv1P85atmhaTYSTZ5YyinZvxlL7OP12dnl6ULnY3/rQLsb
         VUX1rP6yxpE5+h3I502Y/657c84nrnFRpAMI4+IsTJXANB4CPybiEPyavBhirU93rm3N
         XCv37B9JuJ0ks3wQ0KxX3jfJNK4kJFKQGuJiSzQLcnehx2FZbUGCDH45cIYed5NsO/ST
         X3pA==
X-Forwarded-Encrypted: i=1; AJvYcCXgX7Lt5ckslan6OQDrk5K5MmPktLO8gZiPaWwlCHBScrpm67SqMSYI4tP01P16F4/WBuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzznxBx9xat7/f9OqyGFOlOaOX2hm7bE/bE30T7ymWgkbXMfvbj
	C7bRU0pmKlA6l1icqjBY6Nxhdcv4sXVdA2TTnfkpfKuAhRZgyICouAoy5h7QVcpigitb1QF9LGU
	6pwzOL4VHqwhMTg==
X-Google-Smtp-Source: AGHT+IHxVIF+i6YUEaC73g5owIAE5Nb+AC5am3TcKxlMbQgqb7RelNOScgfVT4ggUE4b5iqT6UyddTTEBT3Idg==
X-Received: from pfbfk19.prod.google.com ([2002:a05:6a00:3a93:b0:77f:2698:a21c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:32a6:b0:2fa:516e:26c4 with SMTP id adf61e73a8af0-32da845e5bdmr7199305637.43.1759965965712;
 Wed, 08 Oct 2025 16:26:05 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:25 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-7-dmatlack@google.com>
Subject: [PATCH 06/12] vfio: selftests: Eliminate overly chatty logging
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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
2.51.0.710.ga91ca5db03-goog


