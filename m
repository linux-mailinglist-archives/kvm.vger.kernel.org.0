Return-Path: <kvm+bounces-58794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A72BA0DB2
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EACE36C18B7
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CD33164D7;
	Thu, 25 Sep 2025 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1JQrl+//"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B99314A71
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821351; cv=none; b=Am8AoXIZjVeLT4qxXxD2E1GWfi4TorJUmY80j8rlMkDmlbwJZSHP3c/LlkG0/RaY4svpwFIZCQMkKhTUAiWGTibKcGuqPam3P19oiCWuRcEsRvfC8Ut0GzeH3UIay43oM86bL5UXXYe3HlV1Wdirtfu12iCxWigJ6Vg4KArIDzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821351; c=relaxed/simple;
	bh=Vl39UxfWLWLi3l5PbdsKcdt3BuwhVH+RNLvx6eLUFoA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YZyc05OdwiLhcDi0Iew4CYJNffwXzIgwV1PHRh/Cl9l4TK7JkOFH7RsbmG5h8p1FGkhV1qxFrM3UEUbbjWXW+B5B0r8isqXc/z0GScZJVopTjaNi5ch4Snnyc050egoFIjo0mdWFtdx8+4urrXJYZpt/gQ1/eEXfz939ui+Jl88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1JQrl+//; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54ad69f143so1584494a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821348; x=1759426148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8JLPpbGWSB/sDzGd/uv8bd5LqS+aNG5e8oV7q+AvEFc=;
        b=1JQrl+//f1SKXwpcvtTTWENFrf12CpFsf73scxHDBHZlJmNl2dUqmmiR0pOoK1ga2E
         yJSEOTYv0r2lh4wvvZELKocDGFLhiDQZxSELf0g7XEcaices9sDe3//+R2sP294s6T/w
         lD5kgZyaBn4AKYXT70jz5s6t2jyQIY9hkWDpit4aNl57aKL9e7dgun30x5ADQMR3NvsJ
         9LBPuUS8Lb+PsnuZvUgT7RckTjtuqSmZslcFrAofj/ntXRH1XRmR8tYa6sokUO+CUYO/
         6kL5NJT6I4QVed9K91HJaXTJTFOCqSqWD/jArj9+7uF6WwDwb/A1fVSYtTtPtV7KPZoK
         jIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821348; x=1759426148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8JLPpbGWSB/sDzGd/uv8bd5LqS+aNG5e8oV7q+AvEFc=;
        b=F/icUiohx7OE9j8TqBvRlABHLtfgOMBOlJPuL7SWFKQ/RTr47o7WgYVcvnRipy0k8I
         6GXvspXUUPf6ezhBQgB/lBuBzPaHBPaagSU5Pm+ZGSnWu78VnEaPfON5cHbOf6q6dalR
         6p9Q0519+sMVfRIyQLYWJmmIM95G76HXDnsRG2vtiaF5wYNsPjQTKml/zeosDagGzanM
         Gzdu3pX6N79EaIkpH5lcRZ3THyA+13hq7kew9x2J8WNAqgDSiOnhbuQFN4hnsz+s2kUM
         +D2IhkoNU6BSzmPgPj4o5OuKMPGGUIBJpPNdzlFyvF6dvaY+qRmWJ+R6K7iEYPXLdqO1
         3QBA==
X-Forwarded-Encrypted: i=1; AJvYcCUMjI/hJPktgci4CiPwvZYuaWT/g3Y0Oy0E9FzrZs1qb3qKBz2vkry52Z2lF2KYCNmS+us=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfkPedfXMzOL1lA1fI2e1Zlnfzj39GMxAZF+0x8Qx9Bl4/QMre
	6hvkFQjdHiVb4H1349yszpVquHiJNTor2LpNvIcwcpYaPa/5QXcNMivRZlgsJGSKb3/Z1P1P0Fg
	oDw==
X-Google-Smtp-Source: AGHT+IH54ohEK5/MMngFaFNsOgY6XT822zyLzOf+8aqtVGUvZwS2Bzm6zXgfkyoSbTkuPIFgLtC29AVTcg==
X-Received: from plhe13.prod.google.com ([2002:a17:903:1cd:b0:267:b6b7:9ac3])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a6f:b0:272:f9c3:31fa
 with SMTP id d9443c01a7336-27ed49b8e31mr48712695ad.9.1758821348247; Thu, 25
 Sep 2025 10:29:08 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:33 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-6-sagis@google.com>
Subject: [PATCH v11 05/21] KVM: selftests: Expose segment definitons to
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
index 2a44831e0cc9..623168ea9a44 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -7,6 +7,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "processor_asm.h"
 #include "sev.h"
 #include "tdx/tdx_util.h"
 
@@ -14,10 +15,6 @@
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
2.51.0.536.g15c5d4f767-goog


