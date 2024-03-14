Return-Path: <kvm+bounces-11850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8451387C650
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A85EE1C20A3C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0647317C67;
	Thu, 14 Mar 2024 23:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yPsYUdfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5F617756
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458806; cv=none; b=RKR2BvmZai5tOLUPbB3aHJEJtegfVJLE7ZA7uRImcaDSiDSULnm3f+b8g3KM/q22QABUy8Izch4S6A/Uu64WBIDrBuLxm3jLTbz29FPagEvh8ZUyiMslWSANnmpMWZmVHQdZbakOMFcxzCGWF5xJth8VLkmIVbK7rTwZDyek/3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458806; c=relaxed/simple;
	bh=BMhrGuRzp2+08KNUOPVJMqbqkXnVvoFiAgycmxs2gKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ho87m0HhQYQoM8SdZEGbOofpJWjwTw6nyxPpHiIBCP0VbUDRSartinnRncak7RFpTDPr4shn2kLyXtyIC6O5Fw2X4+t+qylNjtGaEDEMVK8Q5rrqSuE7ZJDZeW2vBI1wPhYYfJNHjtTZX+VRp11GkMvjC85Vp2uUO1sg4HDANnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yPsYUdfZ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ddc9430263so16859445ad.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458804; x=1711063604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xxEEnp8KYxWW22Dja8/hqreyUmSSC0e9nt+hWHrby04=;
        b=yPsYUdfZReeC3sc7CxHLX7X6f4wQr2qaqj3VhzL7sCTktwAwp3OzrzlHL3qTNnRCYg
         oyoPX1bDPIlh5lHSOtvI5HOcLz3ar8iCuh356/53nurARwuvPZp+8o1aOvB41tGmMWZd
         EmQ4MmYmqvkxKlchTW1FxJffwsRtU9j7OridtjBENauMBwCUaS/N6wjSLEw2RA5vUZpy
         kUYvZRdCx6dj4YJQPnx6Ql9CfgSV10FBF7riNAF/63ZHHG+N3h2EKPyAnXKZnyo7nG+s
         beraPK3w+wC09buA2Mh/hdXskgZTgvCAftyR9bh0JDxPhDFGpOfZm/cllYSEWhvRvkie
         GAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458804; x=1711063604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xxEEnp8KYxWW22Dja8/hqreyUmSSC0e9nt+hWHrby04=;
        b=Y7+nSbefDbCAyk84BCekLqLxhdOLrMGqJjMhLfdXDxKxV32c16YvkApWRhZJDU2Qnn
         X8xn1kMNtBjTDZGbVgCMyBmlC/AaX/Ege4QrhEYrTtmU0zIv/nDkfsTBV8DCKaqaT7Q5
         MrsxXwI0GzkAzXIfK2nTB3zzyJS22o1y1iYHD88MFFIpt18wDb2SxPFFoUaSsEiRWIv4
         vqcsqxWt/QJiyQvl9y/LsCJhHwUI3IHUQCbbShfgqD8y/35nYn2GzCB23G7P70kvX7b2
         CabuCici4hbqPPa0TN0Y39KKBUZ+ZyeF278ulBzu6yPknLq+z+QAIflV4sDkUEe7dFEt
         M0LA==
X-Forwarded-Encrypted: i=1; AJvYcCXHiKydY8YO5fx9Z9XT6zZpFt3YmXpmKCkHDPf9d/NVcSD7yQShKlk7GeMDt9oFY9Lfu3O/XVEjvhbv+c6Yw21bOC3p
X-Gm-Message-State: AOJu0YzKI4Wa/IlqZ+JvE5Z7ZdcNgNgGF7Tiz4yDMgIIqoW7XWZgrsG4
	M60UMJqJqTf2/QgOo0tp5BCnKomAww66rUydUMDCxb9VFhOXoEFEVbXWjAmi5+ftYlydWZCehMy
	Ezg==
X-Google-Smtp-Source: AGHT+IH3tWVDzScYAxWAoO+AJJrzIFuBnfUykicaYWmU+HGG/cysXNug5oRiY871AjgR+7oBptYedZH/VEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c2:b0:1dd:7d71:5900 with SMTP id
 u2-20020a17090341c200b001dd7d715900mr9743ple.1.1710458803732; Thu, 14 Mar
 2024 16:26:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:21 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-3-seanjc@google.com>
Subject: [PATCH 02/18] KVM: sefltests: Add kvm_util_types.h to hold common
 types, e.g. vm_vaddr_t
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the base types unique to KVM selftests out of kvm_util.h and into a
new header, kvm_util_types.h.  This will allow kvm_util_arch.h, i.e. core
arch headers, to reference common types, e.g. vm_vaddr_t and vm_paddr_t.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 16 +--------------
 .../selftests/kvm/include/kvm_util_types.h    | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/kvm_util_types.h

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 95baee5142a7..acdcddf78e3f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -21,28 +21,14 @@
 #include <sys/ioctl.h>
 
 #include "kvm_util_arch.h"
+#include "kvm_util_types.h"
 #include "sparsebit.h"
 
-/*
- * Provide a version of static_assert() that is guaranteed to have an optional
- * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
- * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
- * i.e. effectively makes the message mandatory.  Many KVM selftests #define
- * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
- * a result, static_assert() behavior is non-deterministic and may or may not
- * require a message depending on #include order.
- */
-#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
-#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
-
 #define KVM_DEV_PATH "/dev/kvm"
 #define KVM_MAX_VCPUS 512
 
 #define NSEC_PER_SEC 1000000000L
 
-typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
-typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
-
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
new file mode 100644
index 000000000000..764491366eb9
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UTIL_TYPES_H
+#define SELFTEST_KVM_UTIL_TYPES_H
+
+/*
+ * Provide a version of static_assert() that is guaranteed to have an optional
+ * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
+ * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
+ * i.e. effectively makes the message mandatory.  Many KVM selftests #define
+ * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
+ * a result, static_assert() behavior is non-deterministic and may or may not
+ * require a message depending on #include order.
+ */
+#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
+#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
+
+typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
+typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
+
+#endif /* SELFTEST_KVM_UTIL_TYPES_H */
-- 
2.44.0.291.gc1ea87d7ee-goog


