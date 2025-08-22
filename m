Return-Path: <kvm+bounces-55550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4F3B3246A
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 745C26082BC
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B11E350857;
	Fri, 22 Aug 2025 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JoqvmOJF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFACA34F47B
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755898000; cv=none; b=sj9sTQm/gg4TFXW6bdZU9/7PhXb6t3Md2aYU1jGjMfMIaZQUW1MQMdXSwv/AsfsIFsOTFwrvlL1lQmpcjDjSfWp1ZcpIKyMac5IbaohC4swNHvQz+G/PZD0zfgwmRdWIRD23mRfGk6nl2+lJbAvS7skEGMFDqGiU7IUS8FtrZzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755898000; c=relaxed/simple;
	bh=JjQhi6KNfqkIb3nbS+LW8fes7AWz+Z0e/j+VlQrC1A4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SKz3umrbEcIf0ySFDZdfibSZgkvT/1NqA26fnG7hzdlsQxTYI5+ECR7MURrIAV7gyRtrbRMSv6PHqMTUsmiG6Y5W9CpgfeRV+iew+mBfYmAvzY8u4K1SS93MvUU8BLGILgDkVgvYISNCHMZWS9FLa9z/7HsCt4nhD34/j2NX6h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JoqvmOJF; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e8ae86ab3so2693471b3a.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755897998; x=1756502798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dX6gl6ogaefOfHTZOHa7XqGWnmuA0ULtK7PWWPy+bAk=;
        b=JoqvmOJFbr71WJGs1DNt9jMt5DLwHQWgj1rWTvuunI/PbLwEwzRRszikShpeopNEGN
         yF3IhqvXNW2pL7LCJr4PxG7lEsHyFdzkqDffTwKfkC9D4+UG/65mSlH6pCoZL2F0ab9z
         tlKyu9u+qAscgiI9e+Bsgec4g2ZTaek0leoiKMP4PGBh/Kr4AiWs9ERo+OOjM3UaMzAF
         HpJjeKEdalqXUo962wM5zD3NVCU7gQoZ4i1aoOI86pibq+eMovbdORWDBqwiR1r2WEcH
         IpFMbpEAuNpEcIyE7Fq0IdZWYpTeJoAICAzc3MNcek5pDWHPzK3jAN4mwfcgE8VTEgY4
         ES8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897998; x=1756502798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dX6gl6ogaefOfHTZOHa7XqGWnmuA0ULtK7PWWPy+bAk=;
        b=OOKhpYqory9sj4WkRvC5Rqa+SNGVi8B5enIFQJxkLr7mri4BGclNbzmTt6s1DdELM9
         GD99wQWldrYbMv+zha2z22HxQ8qBVAZ1v/9xh3/MMxYfAsim/dQSePAHmLqZGYrK6l/f
         ox33NeWEi4JsecVRLetdyIfQLR6GIadmAHSc98vJ5FM5h6P97IluXQ9Hd7Sb6AvhwdJc
         rZRP+A9Bgrjy7uSwQ9jFwCa3fKYGGiEbcMQKvPb8SgpFYIJ3pGbppdzKKPjt/u/tLXx5
         qTfJbcY32KDc0wlkOMCh09J8kbV/uwL3i+C/Yz7SXiBviUIbE7ssh84RCvOdkVi3m5bA
         zs1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUASiEzEMtheK2aIkIaSdMsYY3b+VXEGrXPJ1teblFMTAVqQg6GV2WifCa/peLL0/midU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAC72NeLkmHWew4nccimRuKCCPiu7rslHrmf3UhM1tX2zukfSO
	ev12P0Ub3kR3x0jy7tAPh1qnzelXEPVIbWsLXidIoSHRKzlElUDv8uAnQYfcfi2J8rMrYVAQazM
	MJVBdu5bkUWiRXg==
X-Google-Smtp-Source: AGHT+IHAHdoKYZtp22oi76UfJYhJGtpx1hHvF94ArfhVoqbsmCroeHKncs7gkNZhW7SFhDDAuV1S+iSWzsk3Ww==
X-Received: from pji6.prod.google.com ([2002:a17:90b:3fc6:b0:31e:cee1:4d04])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3393:b0:240:252a:157c with SMTP id adf61e73a8af0-24340b7ab5amr5815454637.11.1755897998301;
 Fri, 22 Aug 2025 14:26:38 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:25:07 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-21-dmatlack@google.com>
Subject: [PATCH v2 20/30] tools headers: Import iosubmit_cmds512()
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Import iosubmit_cmds512() from arch/x86/include/asm/io.h into tools/ so
it can be used by VFIO selftests to interact with Intel DSA devices.

Also pull in movdir64b() from arch/x86/include/asm/special_insns.h into
tools/, which is the underlying instruction used by iosubmit_cmds512().

Changes made when importing: None

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/arch/x86/include/asm/io.h            | 26 +++++++++++++++++++++
 tools/arch/x86/include/asm/special_insns.h | 27 ++++++++++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 tools/arch/x86/include/asm/special_insns.h

diff --git a/tools/arch/x86/include/asm/io.h b/tools/arch/x86/include/asm/io.h
index 4c787a2363de..ecad61a3ea52 100644
--- a/tools/arch/x86/include/asm/io.h
+++ b/tools/arch/x86/include/asm/io.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include "special_insns.h"
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -72,4 +73,29 @@ build_mmio_write(__writeq, "q", u64, "r", )
 
 #include <asm-generic/io.h>
 
+/**
+ * iosubmit_cmds512 - copy data to single MMIO location, in 512-bit units
+ * @dst: destination, in MMIO space (must be 512-bit aligned)
+ * @src: source
+ * @count: number of 512 bits quantities to submit
+ *
+ * Submit data from kernel space to MMIO space, in units of 512 bits at a
+ * time.  Order of access is not guaranteed, nor is a memory barrier
+ * performed afterwards.
+ *
+ * Warning: Do not use this helper unless your driver has checked that the CPU
+ * instruction is supported on the platform.
+ */
+static inline void iosubmit_cmds512(void __iomem *dst, const void *src,
+				    size_t count)
+{
+	const u8 *from = src;
+	const u8 *end = from + count * 64;
+
+	while (from < end) {
+		movdir64b(dst, from);
+		from += 64;
+	}
+}
+
 #endif /* _TOOLS_ASM_X86_IO_H */
diff --git a/tools/arch/x86/include/asm/special_insns.h b/tools/arch/x86/include/asm/special_insns.h
new file mode 100644
index 000000000000..04af42a99c38
--- /dev/null
+++ b/tools/arch/x86/include/asm/special_insns.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_ASM_X86_SPECIAL_INSNS_H
+#define _TOOLS_ASM_X86_SPECIAL_INSNS_H
+
+/* The dst parameter must be 64-bytes aligned */
+static inline void movdir64b(void *dst, const void *src)
+{
+	const struct { char _[64]; } *__src = src;
+	struct { char _[64]; } *__dst = dst;
+
+	/*
+	 * MOVDIR64B %(rdx), rax.
+	 *
+	 * Both __src and __dst must be memory constraints in order to tell the
+	 * compiler that no other memory accesses should be reordered around
+	 * this one.
+	 *
+	 * Also, both must be supplied as lvalues because this tells
+	 * the compiler what the object is (its size) the instruction accesses.
+	 * I.e., not the pointers but what they point to, thus the deref'ing '*'.
+	 */
+	asm volatile(".byte 0x66, 0x0f, 0x38, 0xf8, 0x02"
+		     : "+m" (*__dst)
+		     :  "m" (*__src), "a" (__dst), "d" (__src));
+}
+
+#endif /* _TOOLS_ASM_X86_SPECIAL_INSNS_H */
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


