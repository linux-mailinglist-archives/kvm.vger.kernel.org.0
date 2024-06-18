Return-Path: <kvm+bounces-19880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA0890DAB9
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:32:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63FF0B24408
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBE614884D;
	Tue, 18 Jun 2024 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4wQC3IJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94C613F00A
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731942; cv=none; b=QN3ku7a6SFOxN7S94CRc2O11frimXlmsebPiUbgNs5GlItxrsXh0EyJvxv96zEyLHUQ0cK4p1fDlumrVwSWpTcjK/q2Nxlz+hQmn4BhHUIlHlADhqYDFehC6U8kpicyb5YFeG2aR+oggHu6djrdWOheQ6bZlfKMd9kHu0Ls0DPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731942; c=relaxed/simple;
	bh=GnWNyaD0dn1dpEgub594iNEV5lYBdNv90ZFO+R0wiLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K89DH93Nwcexlj7YtZSaTWD6kg9TmvPaSLdMR1P0YhduUgWKMnW0jfMoj5ETa2yN3r5NJhUxga/knLZscQfUuNcRyCsa2UCQXsmkzog00Xdp7snYAaB3ugHlDR1UYTxmg+NWV4PlV+1WmsELPfLHAem/oOby3YmCqjf/BsfkyBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G4wQC3IJ; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7062c11d0d1so7983b3a.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718731940; x=1719336740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Blulmc7pIET82cKP+ePX3OT26FWkLZf8vE5qV2TfTZA=;
        b=G4wQC3IJtvwbX3J+E5AzKMSNbl9ZCq0zjtNkRr20/OGSuv0rUlA/CbBqp/kxgrYnaz
         PlBYfQw0prj9hv/29mrnq0rvBrzallXxx0EcyeJ/QnPmZz4Ei6kEky5rH/6B58DQUA+8
         N58CPqO6bhnqublJidAsRxUmKmtWgCrA4izJHArcJlBhE7q7oVkUQgZiruh3n2WvKbwp
         zdcd0npL5e31Q2odbDR9rvKyEFMjRIGKH9J0ezExdq/yH5FYyhlFXntp2GIc3YTCAUGK
         uRCOuFhsARDtUx7iF+/zVtc65Gs5cjbSH9YoYfeGrA098pWP0bLuaThXWkWOME3e4Bus
         6CCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731940; x=1719336740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Blulmc7pIET82cKP+ePX3OT26FWkLZf8vE5qV2TfTZA=;
        b=TeTR7ubBICt9sfwnvXRtQo8JPoHnv88mrQ8qNAKz11O8cZTOTzVPYkEn0rl7OH1Aay
         Hx/fedrZJeS6DnDuwl0SzQ59IYxCyd2dHH0OluP2/gA56CVI1L/I3kSkpC7fDQwyZc8e
         OFfBmrq7OEUOUTC9R6Q0KZyY/HmhbutiJB9VpnbF84L8kHn8IdwfXjnsGQzEeFDFte+l
         3pse3kqyWJMKzoQMw0dBw9snUQcpSMlX/A+26aWRfO88LDq+1TIvL1hyaaqL7NIGnvwh
         DHH/wVmZ8AduAHgA90rNX6FdEHNDIMeZRtP1cDbhC0FJIKpYfTeDspUq9U46LLd/aeU3
         2meA==
X-Gm-Message-State: AOJu0YynEcrqnL0uNxiigsFwFmfbA/Mnn9wvPISQK0hvrw1EmlauLhIp
	X+cU8zG2oGSXDFg0cM+f587Vm914Wx9Uqjaj28tvr5Qlf32dlE1Eahs9aiZR
X-Google-Smtp-Source: AGHT+IGx8S9jQ3ds3aVy2ZQbfAouACrLu1UZ1btjCp4nsn/uJImlHjZZR82m8v5QLbJBPdxDfrYm8g==
X-Received: by 2002:a17:90b:f92:b0:2bd:ef6b:c33b with SMTP id 98e67ed59e1d1-2c7b4a682a0mr513360a91.0.1718731939782;
        Tue, 18 Jun 2024 10:32:19 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75ee5a5sm13529305a91.17.2024.06.18.10.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:32:19 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 2/4] riscv: Update exception cause list
Date: Wed, 19 Jun 2024 01:30:51 +0800
Message-ID: <20240618173053.364776-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618173053.364776-1-jamestiotio@gmail.com>
References: <20240618173053.364776-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the list of exception and interrupt causes to follow the latest
RISC-V privileged ISA specification (version 20240411).

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h       | 15 +++++++++------
 lib/riscv/asm/processor.h |  2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index d5879d2a..c1777744 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -26,15 +26,18 @@
 #define EXC_STORE_MISALIGNED	6
 #define EXC_STORE_ACCESS	7
 #define EXC_SYSCALL		8
-#define EXC_HYPERVISOR_SYSCALL	9
-#define EXC_SUPERVISOR_SYSCALL	10
+#define EXC_SUPERVISOR_SYSCALL	9
 #define EXC_INST_PAGE_FAULT	12
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
-#define EXC_INST_GUEST_PAGE_FAULT	20
-#define EXC_LOAD_GUEST_PAGE_FAULT	21
-#define EXC_VIRTUAL_INST_FAULT		22
-#define EXC_STORE_GUEST_PAGE_FAULT	23
+#define EXC_SOFTWARE_CHECK	18
+#define EXC_HARDWARE_ERROR	19
+
+/* Interrupt causes */
+#define IRQ_SUPERVISOR_SOFTWARE	1
+#define IRQ_SUPERVISOR_TIMER	5
+#define IRQ_SUPERVISOR_EXTERNAL	9
+#define IRQ_COUNTER_OVERFLOW	13
 
 #ifndef __ASSEMBLY__
 
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 767b1caa..5942ed2e 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -4,7 +4,7 @@
 #include <asm/csr.h>
 #include <asm/ptrace.h>
 
-#define EXCEPTION_CAUSE_MAX	16
+#define EXCEPTION_CAUSE_MAX	64
 #define INTERRUPT_CAUSE_MAX	16
 
 typedef void (*exception_fn)(struct pt_regs *);
-- 
2.43.0


