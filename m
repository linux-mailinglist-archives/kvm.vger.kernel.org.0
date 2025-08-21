Return-Path: <kvm+bounces-55253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78617B2ED00
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADF88B61215
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0342ECEA2;
	Thu, 21 Aug 2025 04:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O52GhE5q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1F2EBDD7
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750591; cv=none; b=GrLNjQhGvAdPHYEYY6YIU0pJSmpP8hVQgIJPDR8D6/PCRv51bEJtUL8Ck2EIlKHFsNvfD7RPKzNNVAUOddhQf6p/l4UTErorE0+pNQZWEXxbm+Jm4T2GswzWDqa6Q3PKoggyTZkMFjXdmhWew4dBDVoJ/kiDqklu5uN2uHoWrQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750591; c=relaxed/simple;
	bh=YfCKtl1oYUHFl63/I/l0XnKZWiM4Uj8GywSB9cp0jjE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T4ImTfUD3HKgRzkTMDlw71b+UNu53f2DJZBCTdC5lpHTBTEGXj8lFXcvdtb9ZlWZxqCCci3TR0mK4O26Mz56LIHIfkLPxBhzUCMcag1sA7HCVPKswOqOn+dBLSRT2zbWUF0GcbLi5GhpBQATf4fMK69vUCgVObnKtPIay8kqTfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O52GhE5q; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4716fc08abso448971a12.0
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750589; x=1756355389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=17hgKbvgVoShstlAaX3KPF4mBrZKhgeiLGz5GZxS0HI=;
        b=O52GhE5qK4AMD2GXcRnwmN5F4wVV5RohZRhH5L1ughC0WR6OrXZddN64EFUx8ZZvoZ
         jmgvqnlyqsXJuQBzpXeDyKxu1AYglzOfdnuJBsfZxzDFSSgodPJaydfnPNMXc9KLcdmN
         33wQLkl8Pfx3UwUNj15M+9/7RFyoRXdn3UOPNl9CZWjYUqt41+7Xik/R5Rl3bCMlvnuE
         NYX9S6RSgLfouq4gL81jmg5BjNu2jJTE83wPx2r+gJ6And613amn9Q3M52GGYjaXkVeZ
         tfaqRVepyXmH04DlPtKXZ9ZXYDQvMSs9lTEx4KbkDTx0KXePqNAEag7pSp+2kOibeobI
         MS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750589; x=1756355389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17hgKbvgVoShstlAaX3KPF4mBrZKhgeiLGz5GZxS0HI=;
        b=Edx0eM4OIPcQhLtCHaOe7WokSg+TKNZuNUWQ75WntIyt3mpXuJ1XxQif2zLSncGrbc
         X2sA0RemheayHZRgNklefeMuIJg/CN7Peppukh1w1FrG81UHkEaDALKSGcsIhX0zVRPd
         oUd6uIMSDJxGLXWDE+Ra51qA2LAxj8f3Gb8SOQwaBQP/fm5n/4GTK90xr1O6mF7VeNQF
         eDx3Wdb8M96mkGyPEkdYJ2/RcHJIMnLRqQpF+2TC+vLH7qTCyysr3aebz8/LgP9Bd2VL
         9muVzpI2fzsX3hMFkaNhHndF4FIediuR+/nRxZSdCE8cph4mQqw0yhfHQ37sKdgn/rwX
         DquA==
X-Forwarded-Encrypted: i=1; AJvYcCXioWxXXVGikEkKn5o5UEn0myb3BtYIUCXe+c2PAVmml4FDgzRUE6pbJJ/XXGCpCPO8bQw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6kYfWOZ46P+5lkHavZkiE0ETAgTKcqw3p67MIi1kOAAJoJAw6
	7cG9Gchc87nQe3RdSgzLPKgPNwXfPjCaLbfrJyUdDQioYUHi2kAvnEd3GdmSmy4Glhkz/cyxD8U
	9og==
X-Google-Smtp-Source: AGHT+IGF5a5kRZmxUiR0v1iGU7vvhEaAdIOjYi1z34R/ceiLYsiE+HhRHvw9xVKXOykbRjsvm8/UnJbeaw==
X-Received: from pgbl17.prod.google.com ([2002:a63:5711:0:b0:b47:9d0:bf72])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0c:b0:240:101c:4428
 with SMTP id adf61e73a8af0-243308364d2mr1563120637.10.1755750589607; Wed, 20
 Aug 2025 21:29:49 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:29:10 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-18-sagis@google.com>
Subject: [PATCH v9 17/19] KVM: selftests: Add wrapper for TDX MMIO from guest
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

Add utility function to issue MMIO TDCALL from TDX guests.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/include/x86/tdx/tdx.h       | 14 ++++++++++++
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 22 +++++++++++++++++++
 3 files changed, 37 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/tdx.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 1f541c0d4fe1..8d1aaebd746e 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -35,6 +35,7 @@ LIBKVM_x86 += lib/x86/vmx.c
 LIBKVM_x86 += lib/x86/tdx/tdx_util.c
 LIBKVM_x86 += lib/x86/tdx/td_boot.S
 LIBKVM_x86 += lib/x86/tdx/tdcall.S
+LIBKVM_x86 += lib/x86/tdx/tdx.c
 
 LIBKVM_arm64 += lib/arm64/gic.c
 LIBKVM_arm64 += lib/arm64/gic_v3.c
diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
new file mode 100644
index 000000000000..22b096402998
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_TDX_TDX_H
+#define SELFTESTS_TDX_TDX_H
+
+#include <stdint.h>
+
+/* MMIO direction */
+#define MMIO_READ	0
+#define MMIO_WRITE	1
+
+uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_t size,
+					     uint64_t data_in);
+
+#endif // SELFTESTS_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
new file mode 100644
index 000000000000..12df30ac1ceb
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "tdx/tdcall.h"
+#include "tdx/tdx.h"
+
+#define TDG_VP_VMCALL 0
+
+#define TDG_VP_VMCALL_VE_REQUEST_MMIO	48
+
+uint64_t tdg_vp_vmcall_ve_request_mmio_write(uint64_t address, uint64_t size,
+					     uint64_t data_in)
+{
+	struct tdx_tdcall_args args = {
+		.r11 = TDG_VP_VMCALL_VE_REQUEST_MMIO,
+		.r12 = size,
+		.r13 = MMIO_WRITE,
+		.r14 = address,
+		.r15 = data_in,
+	};
+
+	return __tdx_tdcall(&args, 0);
+}
-- 
2.51.0.rc1.193.gad69d77794-goog


