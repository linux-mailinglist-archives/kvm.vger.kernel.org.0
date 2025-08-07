Return-Path: <kvm+bounces-54296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 321C2B1DE23
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5203B5866CE
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB9E28312E;
	Thu,  7 Aug 2025 20:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ifjMxrFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB828134C
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597839; cv=none; b=tSy1J7Rrl0435Pg8eATbgGFB8VUMeFBtXVmGX7ZYkwEKlBpCvDXv5P0om5e/uPKXkQPFc15nH2kvar/s+0Hp95BkMhKNnCqjd6M0jvaALcLuLAVb5kT4+mFMX9OG8S2JaAM6dlym600WTZKz6yFp3bYvQnklsxhmh8otREoDsnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597839; c=relaxed/simple;
	bh=ndNmo3n7jVsJUhaVFvSU4GOTOiKiQ6V9KrRi130HlcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tv0zd/Y3EEmFoocfnSLMwWLUVjxl9ewimUlQGZCFKy/xivk8OTx0P6pDeYWhkbpkQmHUb9EAWWtVWHievtBhw07+T0Fr9v2cZLo1EPb3uPzMrbkvvaXTx0ytoEri151MFo+3U7+DUygPpqF8PHfT8EvCsGNxJObKyGb+aNurc30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ifjMxrFN; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3f38d3cabeso1091051a12.3
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597837; x=1755202637; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBWU1Sn84q4yPaJOeH6SG4vPoOnSToM6CD8DOZcfEIE=;
        b=ifjMxrFNDIuMbQqPPPpDiZq8HOcLCJC1j7qYcrMj/yQ4z5YeAMlvGt09LDBGZOOjX6
         nl6oMVK4IgDuY7bXFMB6YWJrJaHQWO0KLK2Fw1AiGivcsUZpiQNI4ERdJTtod/TJG1Yk
         4e14Ofj6eeed1tQGBmxYGhzkVa7aD+FvVahVgmNNgVS9V8kHK142TXP/6Oov8MKkJ6LZ
         srHDHgWdB7bMCP54b+N1DECEYdXz8+yoXoCmm9/W01wtTkjO3yx9jWSyPlBEMGYsUJ34
         QQUav5IHOiGqaduGkM23cWCb4uNvWMi4zH3tB32QYW3HbcVjtu0z69pzR8lDOEOXPRHW
         6yyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597837; x=1755202637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBWU1Sn84q4yPaJOeH6SG4vPoOnSToM6CD8DOZcfEIE=;
        b=tgZ8dVy2wELZwiqQFbqtnIy4DkAPBW3QMgW8Zngid5+5jhLDBx1EfqYOJhocav32Rk
         MKFgbg2cZy6YosWeFgFXDp81idS1iUsJWY11DdhGUjDad2vAZVh7L5vDbR/X5Df5aJQc
         mQeYVfGiuPEilgZWCMP3tzUmClVrtZCrQQsfMb3nK6tiEextZXU+OV69wHKtU6n48MaI
         7d11QiCV7d+Vdt8E/BZJO6uEBAe9t0CFB2IcmF0JUmybMYUeMDO1SjPGoYTWAZqh1jGq
         EjRoEsz1EhXY7dGL4XO/UQwRQ0f+xZqlOS6TbAndmMo8VChY62VrLMj4at7D04gikVPA
         4NNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8lAoskDJmVRdikep7Tdj8LJCnD/16vnQ2uFkQxeJrVBTGrF8p2BTkyaKVaa0ifYs9dCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFGVb7Y93CuTe/Hhl8+TAiAY7f7LYNgTVFy8YZ5YBBpa6jUnkJ
	WW2UjrwdYpyt+2qKjryjLGCGOHOI9QdXjMYYQo7/aMmgwVt7MxW/Jk+R6BSuma8wn0S758/PCll
	DDA==
X-Google-Smtp-Source: AGHT+IECHI4Izk33wOMfxJ6pDGHsZG05/2uZ1BEat0BzueMP70wBC7iSjK5nEYAcwKaUV/DsQbQaAEwBDw==
X-Received: from pltf11.prod.google.com ([2002:a17:902:74cb:b0:234:d00c:b347])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19ef:b0:234:aa9a:9e0f
 with SMTP id d9443c01a7336-242c203f9e9mr4272425ad.23.1754597837261; Thu, 07
 Aug 2025 13:17:17 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:22 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-27-sagis@google.com>
Subject: [PATCH v8 26/30] KVM: selftests: TDX: Add support for TDG.MEM.PAGE.ACCEPT
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

Add support for TDG.MEM.PAGE.ACCEPT that the guest uses to accept
a pending private page, previously added by TDH.MEM.PAGE.AUG or after
conversion using the KVM_SET_MEMORY_ATTRIBUTES ioctl().

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/include/x86/tdx/tdx.h | 2 ++
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c     | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
index 88f3571df16f..53637159fa12 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
@@ -7,6 +7,7 @@
 #include "kvm_util.h"
 
 #define TDG_VP_INFO 1
+#define TDG_MEM_PAGE_ACCEPT 6
 
 #define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO 0x10000
 #define TDG_VP_VMCALL_MAP_GPA 0x10001
@@ -40,5 +41,6 @@ uint64_t tdg_vp_info(uint64_t *rcx, uint64_t *rdx,
 		     uint64_t *r8, uint64_t *r9,
 		     uint64_t *r10, uint64_t *r11);
 uint64_t tdg_vp_vmcall_map_gpa(uint64_t address, uint64_t size, uint64_t *data_out);
+uint64_t tdg_mem_page_accept(uint64_t gpa, uint8_t level);
 
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
index bae84c34c19e..a51ab7511936 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -3,6 +3,7 @@
 #include <linux/kvm_para.h>
 #include <string.h>
 
+#include "processor.h"
 #include "tdx/tdcall.h"
 #include "tdx/tdx.h"
 #include "tdx/tdx_util.h"
@@ -215,3 +216,9 @@ uint64_t tdg_vp_vmcall_map_gpa(uint64_t address, uint64_t size, uint64_t *data_o
 		*data_out = args.r11;
 	return ret;
 }
+
+uint64_t tdg_mem_page_accept(uint64_t gpa, uint8_t level)
+{
+	return __tdx_module_call(TDG_MEM_PAGE_ACCEPT, (gpa & PAGE_MASK) | level,
+				 0, 0, 0, NULL);
+}
-- 
2.51.0.rc0.155.g4a0f42376b-goog


