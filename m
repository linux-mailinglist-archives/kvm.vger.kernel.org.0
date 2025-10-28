Return-Path: <kvm+bounces-61345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2954EC16F9A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:27:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 874FF3BA466
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A8635A129;
	Tue, 28 Oct 2025 21:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fu75H0Dk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40CE3590CD
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686477; cv=none; b=hunjR6IbOi6wacMEk5VyXGUN92UxntWp23xIrvAnn0PMPtTncJSdu+51pcYQfUzUpVZuQhUE2OxE/rkryXum4jMFKCaez2nrVYWwKhYMiZJ/gcpIfjTGdvCiSbGPpghphjpPy8LkESmstHG79EN3zGW7l/7u8Xfju1+n2RgkHEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686477; c=relaxed/simple;
	bh=iSEEdrLiLmqcw9R7W8cvdfSlfMoFs/dHBaP7FgEu694=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z+Xdc9ckeuXzGnUsCQyo7J/mKfZmgKr7sNan3AVE5Gq3EdpbatOnhv5m1qzBekZygFIbbX7mEXH0f8Cwyi94C0Z57IWae4318IjdAZmD0C9TeGAmAma4Od+9vZSH/l9W+qu9QQ1qCr7ru9lC8Sj+mi1VdrLJuYPxUL/0oUmf9gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fu75H0Dk; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-8870219dce3so625004039f.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686475; x=1762291275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9cMMlxlKXtL0VXA8L0h89s2s0Us0y8kGMwGXpa8RPm0=;
        b=fu75H0DkvxBHgjB4QkgYDB6nkKMb1rPkIs2AXI40H0+vzQoXYbMmDPebp0UgXzv4fh
         2V2hL4+p084OUGpQy0YG5hjjYXZev3D0729ri677u/SRR7mltX62BQ1I35QXi/sfDp3m
         NpQdq9aSIHuxcBYb0/CQaG6sLIQ16ECLkFTRP1GxTtMh7vYjExCi4f17bcLyn/Z6eBBx
         zhE0RC3rrZVrXS17aclhl53aAPUfwtlAbOjuJEP453MG9ZGFhkQ7uQi9nOzTOon9k7qf
         rW2sdGXEWtEQ7rR3JvhXTp0v7vJ4ikfyDxfX0g/pp33WFHLe8J/dFLpTPMOcVOZPiCdC
         EJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686475; x=1762291275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9cMMlxlKXtL0VXA8L0h89s2s0Us0y8kGMwGXpa8RPm0=;
        b=nigyAoS5noDoSpq7mLFo9aU2deMAoXrU7EshW+Sn6mR4GsaXqM9QzhZrH9OhZXofh2
         irR14OXAP4or+JusOSElwoMuA0Q34E4H7FetRmuhq8LNsQNmQ8LhtWbd+uKVTlj5C/50
         y8UbhUfs02isxiNqsA8XAIosirRALlHEIvVerCovPP7Ey2DV8AtDyBj0MifAiq1RMx87
         1FbcdNodZfNt0h5XjKFCm9rNAe7D1fW867iNS6FxDpFgKwrdraBk3VCkNcUZ6L9UAQgM
         BFoLbgn0cH55lCcTtokTNmP5bxJED1fj9A0L3M6gBTntQhDZJCcAVAzHC29PyuC/Tv8K
         3XKw==
X-Forwarded-Encrypted: i=1; AJvYcCWdKwpt6PkZyFFo2ezZtIPvUKeWtR66Mxb8hKLQX84JwTft+CtPHYyN58i6xhZRfI805zs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6SKJzaMs8s2eFBEOm0tvSxOFBxXE3for572ZIPdNPWo0Zk7SK
	xVdvDocjN3wWtG+vs2yqMY7nYWsVw26MjUd3OowmJ8DgjWFfFLrpFO4OaG3L3hZEit9LXg2Z3Bs
	Ztw==
X-Google-Smtp-Source: AGHT+IGeXWSnPReZTOd3BW/1Br2ITY0QeYz/8fcks7dNKFTMkhzfS1nQHUJfmshL3eo+QhycTnHG4IpefQ==
X-Received: from iobeh6.prod.google.com ([2002:a05:6602:4a06:b0:940:d830:481e])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:1581:b0:93e:897a:78f
 with SMTP id ca18e2360f4ac-945c965df7dmr154836339f.2.1761686474855; Tue, 28
 Oct 2025 14:21:14 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:47 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-22-sagis@google.com>
Subject: [PATCH v12 21/23] KVM: selftests: Add wrapper for TDX MMIO from guest
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
 .../selftests/kvm/include/x86/tdx/tdx.h       | 14 +++++++++++
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 23 +++++++++++++++++++
 3 files changed, 38 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/tdx.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 969338b66592..b7a518d62098 100644
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
index 000000000000..f9c1acd5b30c
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -0,0 +1,23 @@
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
+		.r10 = TDG_VP_VMCALL,
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
2.51.1.851.g4ebd6896fd-goog


