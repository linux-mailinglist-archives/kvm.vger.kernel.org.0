Return-Path: <kvm+bounces-61330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A5CC16F14
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4256F19C51EC
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB46D3563DD;
	Tue, 28 Oct 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BT0Vg4bY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C81354ADA
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686464; cv=none; b=Ia/p9g1vmUgGQh1V6qLGXU7zZxGcJ57EVk1JNVq/nWftx+BabKZy0eksH2wXxKlCgm6LK78cI7RkfW0OclsVZR0oTCXq0KIJYgeeSSEHlbsOhH6obmSFb7q9I9S3g7PTrLjwcTrc0T+QXh0IRvMfqkmBAu5gNW5l9iTK8tskaQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686464; c=relaxed/simple;
	bh=EJICXa/yniV4LFyjrDgYiN24uZol6pdpsvo9d5t1gtc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U/WSpQqxnjiQMMh+U1sqyRO5dpNQIcvFF6kdnE95/edShtEsXhrCkv0q3/grKf/k/x/Y/C0kRgTWHfK+ja9aTCi/DsX3bE1qfHvXpdbT7J7DFsbbCln4tZ+FUva6L/x2oepyxWMwxhfrIG5R/1rz1bSWkr6x9HPXRG9/VLUS/oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BT0Vg4bY; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-93e4da7a183so609538339f.1
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686460; x=1762291260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KJrNVIag5TCnvbKa/N0Y0euKb8NaHrULGif/OSObmig=;
        b=BT0Vg4bYZGBWSXHbuFwcZrV5ooC2CsTLeLzwo4/ZIVK2xd5bfLJGgGYuVaX3YFb4FW
         ULVOH3AgT0Gor0JOZm1BUhnEBxWofes7wVJ59DbEsN781F5hxiqFiWvTz01oDVwF7WTv
         B87lgLT0sLJ2WgMJtcslKrpZkVl5cQkcY8SfvmK4aihsaL9OoCYbyfSRjn/xmqsAE1JU
         gp7ysGgVuAyiueUQ9gWOLhP4x0eE4QWoBIEjAqh5BdoaMiMMPujUIJ7MTBtAT0aOAqub
         /ruuRMzbZTeUJ99EHqmpgGWEtDZRXArXkICAl+ekEo7Uo42oKHAp4ZCN/IVWFc9oxtGO
         LCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686460; x=1762291260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KJrNVIag5TCnvbKa/N0Y0euKb8NaHrULGif/OSObmig=;
        b=K7HwwOolvNTwfScs5u6AoOzREof+mu4Qkk7fkZ6CEX79ocpkr2i3uovVO67/ZRmD/1
         zGNc9nZGODxpfw05He3SwG2qxKUTDPbGwW8Wumr/U3XzrpCsDZU4VdMd6uLx0e5Qj+x1
         gxvxAy/F4k5LuTQYy4YnXiiOibRAdI4lGYbUX5f7yhXsuBgdgXbNXcuLwAJ77zrlkv6e
         ekRCLeaZYFSmtxx5PnUM+Gr4Ri4KqOFoVNzf2URszUEOx8wP1nMjnOxgUALi4aTH7+uY
         j85Htya3s2kW+9XmIOCEa4LH4qFrNcz1TnM6Wsel7dNESH6doZYRKyiEbPPmO4wSfdyf
         ovTw==
X-Forwarded-Encrypted: i=1; AJvYcCXD475IoMjxqezzwxuMm4oDTPzlaQgRpK6QlvrtqLucmSAqU9PytROrvRX4jWXgCLkNPzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUkXKWwqQlFJpFUKwDdUw02Y/Gfzhh7WGOiuVVMr1q4SHym/mv
	OTsV1PFADaANT8Yyeyen7iYx4Nx7dRBqb8sL9sbGCGJOM8oCFZ/I+xZsTctc+SIjX/dQL0fq+Ww
	2Dg==
X-Google-Smtp-Source: AGHT+IEFDrPZWGFBr5+mejr0DLlrxzW412Y0+IuWkkXjbawypFaXM37gBgvb80RrvB50OENuGh7DZHijvw==
X-Received: from iobid12.prod.google.com ([2002:a05:6602:6a8c:b0:944:5708:3425])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3fcd:b0:945:a7ce:646c
 with SMTP id ca18e2360f4ac-945c97ea328mr148145439f.10.1761686460371; Tue, 28
 Oct 2025 14:21:00 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:31 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-6-sagis@google.com>
Subject: [PATCH v12 05/23] KVM: selftests: Update kvm_init_vm_address_properties()
 for TDX
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
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

Let kvm_init_vm_address_properties() initialize vm->arch.{s_bit, tag_mask}
similar to SEV.

TDX sets the shared bit based on the guest physical address width and
currently supports 48 and 52 widths.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx_util.h       | 14 ++++++++++++++
 tools/testing/selftests/kvm/lib/x86/processor.c    | 12 ++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
new file mode 100644
index 000000000000..286d5e3c24b1
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTESTS_TDX_TDX_UTIL_H
+#define SELFTESTS_TDX_TDX_UTIL_H
+
+#include <stdbool.h>
+
+#include "kvm_util.h"
+
+static inline bool is_tdx_vm(struct kvm_vm *vm)
+{
+	return vm->type == KVM_X86_TDX_VM;
+}
+
+#endif // SELFTESTS_TDX_TDX_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 2898fe4f6de4..519d60a3827c 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -9,6 +9,7 @@
 #include "pmu.h"
 #include "processor.h"
 #include "sev.h"
+#include "tdx/tdx_util.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -1195,12 +1196,19 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 
 void kvm_init_vm_address_properties(struct kvm_vm *vm)
 {
+	uint32_t gpa_bits = kvm_cpu_property(X86_PROPERTY_GUEST_MAX_PHY_ADDR);
+
+	vm->arch.sev_fd = -1;
+
 	if (is_sev_vm(vm)) {
 		vm->arch.sev_fd = open_sev_dev_path_or_exit();
 		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
 		vm->gpa_tag_mask = vm->arch.c_bit;
-	} else {
-		vm->arch.sev_fd = -1;
+	} else if (is_tdx_vm(vm)) {
+		TEST_ASSERT(gpa_bits == 48 || gpa_bits == 52,
+			    "TDX: bad X86_PROPERTY_GUEST_MAX_PHY_ADDR value: %u", gpa_bits);
+		vm->arch.s_bit = BIT_ULL(gpa_bits - 1);
+		vm->gpa_tag_mask = vm->arch.s_bit;
 	}
 }
 
-- 
2.51.1.851.g4ebd6896fd-goog


