Return-Path: <kvm+bounces-56750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA391B432F8
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A401176CA0
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F3028A3F8;
	Thu,  4 Sep 2025 06:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p+w1Kfw4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51585286420
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968913; cv=none; b=ghjo5ZgH2aBrC0UAvqvPoo/SwNmPxryjNvAmrzM0ZDd+BE2UqYa1qMMBYR9Ums2rTYVnrZC2GTK+h+XoQbthGmv/+yeRPKnZm7d8jGamdt4TKtoe94F2AvbrkusQdqI3jNADjBuNaUWW4OYXpzsNFeGosI2bCS9BWB690DizygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968913; c=relaxed/simple;
	bh=7B7lwBJ0jXTeacBWtIq12DWMmRMY2GhnIen+mcsaZ6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hQWSXZbz3K3UACVoUfponDJSRmkj5j/0Bmym3Jm5NQTVLk5LVdAoEYp4Qn0NUBDtze8vh/gwH7cPipmsvIQe1sDqSznQV4XKJhnJXKuHrtXWLxLQAl8LvT3dt1ACHpc7Y/g77oiraQGWLJ5uCelx1lSQQsuWGnuIxUbIJ16DyvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p+w1Kfw4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-325ce108e45so630302a91.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968910; x=1757573710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YEQCBMmqJuzc9aQAf9Qk31e/qZjHLfuJ8wSwcpoTOE=;
        b=p+w1Kfw4AJE2YHaSQt0VziaJcUmWz9Aoebxp3sV9fagmd3xzJfAlRPIjcJkCvSgcKx
         xU+SsWwcexxDf7/0iTkdoY4KzbM+TFrexXo5MaIitKHdSpwp+DWjVa0tg8ivWzvgavXh
         tL4N5P6NZpGoo/Y9b6TCJ2m5QfJVm1q37m1AYyh6AUte4HT5MRIAotHYofcQbhwiS3uG
         Lna48So6yOY0zQvyumfvzQmrX+CsUAIxNBAoZHuqFxTiDx+Hts27bmVVUVlrAY57jlJ0
         +sAMCGDKzbQpiWedw2QVdxQ8wi7eDu6SB9Cu1k3+qNoD9ZDtGuKfBkIfTu2B32jNJnK2
         W4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968910; x=1757573710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YEQCBMmqJuzc9aQAf9Qk31e/qZjHLfuJ8wSwcpoTOE=;
        b=rdCrw/zu2tdR3HDI7+Yu+3UGcoUjrOfpBNFI1ArQK2TUWpkxy+m7F0GKm43A7iQ/oO
         A/iUGP/MmT2tHQU/nMQeaMfV8sYUMplHhaHJDkKxymA7RbKpuLtaY6GW+0WhcLgiCuc4
         nhgqmQfAnltyGkjSXC3L1teRTTZKFv0JekpuOkFtcwxFHXQ4zDHr2PfrUmKReT2khg2V
         XXzSxO/bN0QtmyDsueZmMLBGw9Pgwl4QknZ/00aLp2vie6n5GxnlJuNmFCoKr4cTqWQU
         FeVmJZe/TZeg8+EOgfSH1sEujX648PDydKn6FPTqFVtEIv4v4SFhJGtHdMzgG/jo3Pt2
         mcbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVwr4Kt1V67E6HhTfZW4YdnGJn28KQXH38kipCXKVMVM3Cu+m8mdW6HJXKzaBZSxuRmEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrp0SOqJGnYPTgy1Qbntmto35fItjIgunrbMe4WJiVNpkSP4VS
	hzbZVuYvWeNGkOrkFXk5P3cp65UODL9hHs0reRzJNnf+wVVZpWPB9LPSNf1ec4GWccG2U3eLzK2
	3Zg==
X-Google-Smtp-Source: AGHT+IE9YYmncisXydvkAn1sJlRRuLIxllELyPyRwTcYcKt7NlhRMcgbBqYTWjEB12Ff/oJCvryXlzSM4Q==
X-Received: from pjh4.prod.google.com ([2002:a17:90b:3f84:b0:329:d461:98a4])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d8c:b0:32b:6132:5f99
 with SMTP id 98e67ed59e1d1-32b61326264mr6170784a91.15.1756968910496; Wed, 03
 Sep 2025 23:55:10 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:35 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-6-sagis@google.com>
Subject: [PATCH v10 05/21] KVM: selftests: Expose segment definitons to
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
2.51.0.338.gd7d06c2dae-goog


