Return-Path: <kvm+bounces-55241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D34CB2ECDE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E26FB1BA1194
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0153F2E92BA;
	Thu, 21 Aug 2025 04:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ostrz5e6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F492E8B90
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750574; cv=none; b=ZMGbObJ1cqTDxWvc1InMBmaV/I6fUWD8h/duzSAkfBUQRcG0w/lIlN8EH0IAupaYyzt2FqzM46MebHrk1sBu6wBt7N2bVkuGREkYjUuX1jQzeZgPHwVVlC9m0x9l+61HjKkdInrPxyH8a75H0fe0vccgEZ6atU401epXlSk6Wxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750574; c=relaxed/simple;
	bh=tr/kYasvhaM7kVMspgyv9tdsJx7ARbBqJCQJSG2OYi0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5Cgz0RFaT7aXVCb/Yj3FCQzGEsAfwiWIo9ArX+o6J7kdDGtfSWcNfS5naDOltEJnH/XP0pZU34JCLDdwn+/Q4qkb4oBeHRsjp3KdnFYFa9IGHohZ7m8XVVPnI6fsWjVtfZaExm+6mdgFVTRR6mrCx+CL9GTU/y2tryqScFuOgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ostrz5e6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b474a689901so404151a12.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750571; x=1756355371; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0NNhncePcfevR9BqJj7luu3cgXc4QyqZzLOry8PLvlQ=;
        b=Ostrz5e69/1I4BGr7xqfykKD8DXxoNG4gstXZp9p0ewTu/PZRZhtav5GrBUSLDlzy6
         f06I5SvLSvU3WrkWskdL6bGqBwikz7TeSRIgvmB+FfJaWRagK+HsK/3UkdAfeHuH0nVp
         XNuqnO+sLK4wS7NL7z2P+zoODGHb/iICOu0XzbyeFkR6fWRXeOC9PhnZDZR669CNNN2v
         DVrvMR3DDbE7VPSxzsF+YmbxCpdOo/PFpN7PTomyHNyBQLKaYvcagFifVTGiTZzq15uo
         gwMnreUyuuXlUFvU3wNkwGeo7mdmDxkMToEmr5ABdO1TqIFT3HTTGS2qhv28LZAp4pJj
         t62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750571; x=1756355371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0NNhncePcfevR9BqJj7luu3cgXc4QyqZzLOry8PLvlQ=;
        b=aWQNN4Leb2ltR4RsJFW5bRHxyaY/7Pky4iWpXI/mjgAYe2fqj0m3UfSDA07PlIn8g+
         xNVk5RcL/3QAmHMTpHxDOgy0BDh8ASJrPD/wD89U3teEHrKT306DBNY+S1jNgi+18zg1
         gLyqdkh9ICl++Q8zKbYmJyhqbfjAb4VKPXA81gFX9D/f0Lf9WmWPurHdpz/+5URbejoo
         12wSOhLRizBvwfQ1D4DPqZ/EPX4vvILOXfmasv/MhxLPvdG19XGRojLODW7tGNRaR+Yl
         EWYtWho9ZKZTYFk775WHddKhy6la9m0KjaYgBaANUhOgtJKV1i+n7SmXss3s+EmPzvZI
         DBpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmkRsU5gPhLdeuOIqES43hFpEmTEYrjM3OK1o0IXUYjuhgZKWp06nWwSBtZ6IWiVXwn8U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy69Ay2oBZ1QYHX+M/oq7rgPtJs1AnAcn2CGMhgRRQwPeq1VoSK
	lsR+3QLmSlGS0wmX7XxyhXaI7xx7uKT8z39yDw0Z6jD/nrXI9IB+NnLxLVW0oYhfd029gCNYHtm
	Bpw==
X-Google-Smtp-Source: AGHT+IFHt8bMa7jB5MANhdG47UreNFuDH8fmYAoZds65ocGLlqKumuv8qls/N0mgvNCEDLrPY4SlSjc9EQ==
X-Received: from pjyp4.prod.google.com ([2002:a17:90a:e704:b0:321:6924:af9a])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f68b:b0:240:2145:e51f
 with SMTP id d9443c01a7336-245febe11dcmr17946895ad.3.1755750571576; Wed, 20
 Aug 2025 21:29:31 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:28:58 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-6-sagis@google.com>
Subject: [PATCH v9 05/19] KVM: selftests: Update kvm_init_vm_address_properties()
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
index 1eae92957456..6dbf40cbbc2a 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -8,6 +8,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "sev.h"
+#include "tdx/tdx_util.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -1190,12 +1191,19 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 
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
+		vm->arch.s_bit = 1ULL << (gpa_bits - 1);
+		vm->gpa_tag_mask = vm->arch.s_bit;
 	}
 }
 
-- 
2.51.0.rc1.193.gad69d77794-goog


