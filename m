Return-Path: <kvm+bounces-54298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F03EBB1DE2C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96C8BA019B5
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646752820D5;
	Thu,  7 Aug 2025 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z47yLss3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D0128153D
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597841; cv=none; b=KeNa23pIQE127rQsD07SLGixzmXnqe0I/NOPol5KoyiXShjDiPrR9aRc2uNoAD/JFRsLsTSc089YJUpd19afTBKtrvHS+gkPqKOxPUTQ8r5idslsRKaOYPeByrC2ar7Ynez0wQJ11BGnqgUsb5XmYdiFrDG/wX/Ei1yxxIGSDPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597841; c=relaxed/simple;
	bh=lDPkiqgqLnS2hIwk/kcRCl9YxEjkdiRRNID0A7F0VAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KFwNltfNHcWbTyK6x6M87UIj44SFiMrR/5BhhD17eqDBMRz3zT2FByMqG5uCHjDgGnpRAsD9dhiJbT4WuPHpxHIYP/Erge+QldD0DdqQgbuE3AdHS91JPx4b+xGlEQW+QSpQGstiCmQAO0356h1ZgXyUwHYTEcdKrRSp0/n61pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z47yLss3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b42249503c4so1994226a12.0
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597839; x=1755202639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4dbQa13oAbzCDXWZST2Fz7qe3oTtyOGSFzX0b1otAhk=;
        b=z47yLss3lqniPdHyaLUlt4SGaV7K9fdwwP5hySwlUkDzLUQdbMFbnBnnu2mMazNlQ4
         pOL8Or5HNsd1LWlFUpGo0uxeHLzNM0VW6HdAHbzvNR7UhCCRYICMp0+yEc0eHzweQgaQ
         mj93vy6Vx6HHXPmCJBAwwoHdTWH1NBs8aPs4pJbRxTDO78toR9JKspF3tqUBgLeahq7F
         Qc2flfdb2qVmArotb+ECjqBbFCgvITaAh9WO6Kk0BMI3uf0o24mY4quy+rHgt+aqFNDL
         AsT6Bfjm8XIA8yyPjqEtA+C7S+VlXyM3qQm+Wbc/IdiqhNtNKuRA//woDexfWnDha66C
         KUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597839; x=1755202639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dbQa13oAbzCDXWZST2Fz7qe3oTtyOGSFzX0b1otAhk=;
        b=SesWUC5zegL+O7tXfIOwBhCyqonGKmFvh6U1FRIJjnwVl2fRKP+7osL12bqht/oTlA
         tt2FpetiLVWg6pYcS1smg6QCUfg/hdvC5daMAosVaH5nTiUQREsKf6veiJ1PZ+cSgHGt
         d+MOs1wXwl/Fm0agYXGuNO97gf6Z5998v9jF5DTVRfWynf8uA57uMh5th8ZtqmhsVPWO
         6vasSu9AysqMSjy/d84Yb8pGyAyVyu1ICdAn+vBOw06C1pfrCrD0guRz+n7ARuoORljr
         crvgkvujlB3KV2IYQIy496eB3Hi2nqe7OWt2wjabW3BeIuUrOI1fHfTem4Ir/EY8HSAc
         mf1A==
X-Forwarded-Encrypted: i=1; AJvYcCVI9lmrhuIhSFssvgCspXyae6KZynfq/7gYgg2KOIIuHelfjnkSgFxr8e0EofcWLEnu/3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiCFrHM9wFD0xvuwwPwsSEuVIw05bU01U714Ohr+YOYvPOUuuY
	pqkZT6h8bo/EINEQoPdiDGqQSERHQdAdut2M5ZSNecvL/LsfsG0rzHPWbt5YfRXZlAId22HpPPm
	DsQ==
X-Google-Smtp-Source: AGHT+IG2Lk4NOPEbEjMFa+XZyNu3Q1qhg7BUXzj5BBM1i5dAZdBMzmsaEaxU8P2uH91Sze4Rm/UBNniW1g==
X-Received: from pjov3.prod.google.com ([2002:a17:90a:9603:b0:31c:2fe4:33b6])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:544c:b0:31e:a48c:25ef
 with SMTP id 98e67ed59e1d1-32184529833mr212813a91.10.1754597838787; Thu, 07
 Aug 2025 13:17:18 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:23 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-28-sagis@google.com>
Subject: [PATCH v8 27/30] KVM: selftests: TDX: Add support for TDG.VP.VEINFO.GET
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

Support TDG.VP.VEINFO.GET that the guest uses to obtain the
virtualization exception information of the recent #VE
exception.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx.h       | 21 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 19 +++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
index 53637159fa12..55e52ad3de55 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
@@ -7,6 +7,7 @@
 #include "kvm_util.h"
 
 #define TDG_VP_INFO 1
+#define TDG_VP_VEINFO_GET 3
 #define TDG_MEM_PAGE_ACCEPT 6
 
 #define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO 0x10000
@@ -43,4 +44,24 @@ uint64_t tdg_vp_info(uint64_t *rcx, uint64_t *rdx,
 uint64_t tdg_vp_vmcall_map_gpa(uint64_t address, uint64_t size, uint64_t *data_out);
 uint64_t tdg_mem_page_accept(uint64_t gpa, uint8_t level);
 
+/*
+ * Used by the #VE exception handler to gather the #VE exception
+ * info from the TDX module. This is a software only structure
+ * and not part of the TDX module/VMM ABI.
+ *
+ * Adapted from arch/x86/include/asm/tdx.h
+ */
+struct ve_info {
+	uint64_t exit_reason;
+	uint64_t exit_qual;
+	/* Guest Linear (virtual) Address */
+	uint64_t gla;
+	/* Guest Physical Address */
+	uint64_t gpa;
+	uint32_t instr_len;
+	uint32_t instr_info;
+};
+
+uint64_t tdg_vp_veinfo_get(struct ve_info *ve);
+
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
index a51ab7511936..e42b586808a1 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -222,3 +222,22 @@ uint64_t tdg_mem_page_accept(uint64_t gpa, uint8_t level)
 	return __tdx_module_call(TDG_MEM_PAGE_ACCEPT, (gpa & PAGE_MASK) | level,
 				 0, 0, 0, NULL);
 }
+
+uint64_t tdg_vp_veinfo_get(struct ve_info *ve)
+{
+	struct tdx_module_output out;
+	uint64_t ret;
+
+	memset(&out, 0, sizeof(struct tdx_module_output));
+
+	ret = __tdx_module_call(TDG_VP_VEINFO_GET, 0, 0, 0, 0, &out);
+
+	ve->exit_reason = out.rcx;
+	ve->exit_qual   = out.rdx;
+	ve->gla         = out.r8;
+	ve->gpa         = out.r9;
+	ve->instr_len   = out.r10 & 0xffffffff;
+	ve->instr_info  = out.r10 >> 32;
+
+	return ret;
+}
-- 
2.51.0.rc0.155.g4a0f42376b-goog


