Return-Path: <kvm+bounces-61329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F187C16EDD
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE2353B4360
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B97D3563CB;
	Tue, 28 Oct 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHk2Agy9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33363355023
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686464; cv=none; b=eybvwdZkh790PDqWcTSfMn8oFULXbZac0NmlqtNuljz1w8XZVOG3lly2JcJP2P20baPENQmenFm6UcmITSXjrY5iWwXnbPu13HSfM4gd++lHq0I9lg6UzI8xrBEtOzk+dO9aCI9md9aJvjEdgne7s3QL2Z/eatzrWS1NpgRkxGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686464; c=relaxed/simple;
	bh=nEGfNmakvG/SJrWZlD9nSZUH+AMlCksOwOluH5NYAP4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n7MOTezUDybin9de/sc1/1Eay7wIaABxA4xF8CmukS0x4Z7BzDvV0uAYSUPTCC5M0Wu7WXiMGN3qs38Vwhpef7UhUMlD76bS8Py54F5ECTByX0n2IR/SqCQI+TYniibXTh5dOCMcBVz7vRsMO7ew+hiT8TVUuOINZCKv+oTTFTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHk2Agy9; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-93bc56ebb0aso2084628739f.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686461; x=1762291261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uX5GVugwc+C6JrdMwZqI+sQGwgOrrPE6BL3d8gkbivU=;
        b=iHk2Agy9zj40Uf31mcDHKXO5AJ4tHfDnAXknJbX/Mj+iVtUxO23CRQgiN8HMXQMuiD
         LQMDI4ZpBgndun8af8CPJV/TeT37/OsLmss+FtwS5KlRS102s+ipZKy5Di8MWBys9QSh
         Kpxzme6Hy8W+mDpiFU5AhQg1dhhIgxuspGvB75d53eE2i4RDyFJK0LtSF/vvgdqOB3zA
         JG49KoIDvZrDSLxl487S0/5+aDB75l2HOaRcroSo6A3QpmsZ44AXCDss0csbSh+nwf+0
         cQIAuFfo9YGuwAgB/vHn245n2alGFIpX1Y3GyxS4q4wVqL4FJnYNkHcBR3U2jV4wHc7Q
         w3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686461; x=1762291261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uX5GVugwc+C6JrdMwZqI+sQGwgOrrPE6BL3d8gkbivU=;
        b=b9AcYE0CtT6xU8jHnc8n6pBvmYPxpgPJEjM8YIbDJSDafD1ng/5qLXDRh4Kpta1KL6
         4WnbqyVlT2nVAlmYcofIKHImhCtVfOo5jVn0U+PzOy4mAWvJsLCNPUsxkBx1VMRVE8JS
         dmSV1T8sTJnNeG0jTsg11//H2Z7vzmGf2yXDTf4UHqK137sd1Eu9/EQzWJY39EPldSZ9
         W3Lz1sZo8Mv/UzRfbcfpopba9fBuUddiA7EyETKY2OVRTf5c0p1HSOa+oXI8V76ipSHs
         RgcjLqbMIakgYLR1B5gDngHB6Ck8j0kl4uVnizYTy5rp0SOcEMKlrobuBXamfiMoEbxk
         xECQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ6TEgthCF7hKjT3dUD1rAhD3IM68pzxrMRFB0rmdw7T8eIbhoDQl5v6rW5W9IaTw9tqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTG5hvBXjSKCCMwPiNoo9d0VHW2vWwXoKK2ePhpllfzQVkUVKz
	H8f1UQuOujVQk5boj00cjfvveN9f0L+JmCrsR6/KhUnmfD6J4OaIO8Xa28Esmz6/6W7DJV+Trfd
	MNg==
X-Google-Smtp-Source: AGHT+IGAFvo/KKvEdFChEUwxqiCVhHew0LDSPHYl5/GxeXUOv2hI6CPOtlDXCHz1yE7r5C1l+LIYI7DprA==
X-Received: from iobjh17.prod.google.com ([2002:a05:6602:7191:b0:945:a321:1fc4])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:718b:b0:93e:8bab:e17f
 with SMTP id ca18e2360f4ac-945c9865452mr118639039f.14.1761686461422; Tue, 28
 Oct 2025 14:21:01 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:32 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-7-sagis@google.com>
Subject: [PATCH v12 06/23] KVM: selftests: Expose segment definitons to
 assembly files
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move kernel segment definitions to a separate file which can be included
from assembly files.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/processor_asm.h        | 12 ++++++++++++
 tools/testing/selftests/kvm/lib/x86/processor.c      |  5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86/processor_asm.h

diff --git a/tools/testing/selftests/kvm/include/x86/processor_asm.h b/tools/testing/selftests/kvm/include/x86/processor_asm.h
new file mode 100644
index 000000000000..7e5386a85ca8
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/processor_asm.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Used for storing defines used by both processor.c and assembly code.
+ */
+#ifndef SELFTEST_KVM_PROCESSOR_ASM_H
+#define SELFTEST_KVM_PROCESSOR_ASM_H
+
+#define KERNEL_CS	0x8
+#define KERNEL_DS	0x10
+#define KERNEL_TSS	0x18
+
+#endif  // SELFTEST_KVM_PROCESSOR_ASM_H
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 519d60a3827c..5f75bd48623b 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -8,6 +8,7 @@
 #include "kvm_util.h"
 #include "pmu.h"
 #include "processor.h"
+#include "processor_asm.h"
 #include "sev.h"
 #include "tdx/tdx_util.h"
 
@@ -15,10 +16,6 @@
 #define NUM_INTERRUPTS 256
 #endif
 
-#define KERNEL_CS	0x8
-#define KERNEL_DS	0x10
-#define KERNEL_TSS	0x18
-
 vm_vaddr_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
-- 
2.51.1.851.g4ebd6896fd-goog


