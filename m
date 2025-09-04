Return-Path: <kvm+bounces-56760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E453EB43319
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C216E68406D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D6729CB3A;
	Thu,  4 Sep 2025 06:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mVd5SMVD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB11629B8CF
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968928; cv=none; b=ckC8hAjdAMdnVFptb4MPYrnr/kfhzvxal+KbmZ3OIrDGlhPds8l0sQ0PSZBHm4dJJN0LiIZA8RKSD+7LjOcrj0pV/nYCwPp35b6ooKwiz+Fm4ck7IRtgBI5SXwQQmY0YLR8qQuXFvVOohpt5foNIUpzPhFNgp1CbOv7462QSvO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968928; c=relaxed/simple;
	bh=jzB6ZNggPgXQrt5oRvtMpK/C1hmf8zACld+Ecgq9TtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YiEEPvVhbHP15dIKS1Ctl30C7EFQuTT1P5ZVV6gds6m9W7DHSibFYVg6eHWjFWTbQeRtJ7MBNQmkp6C3iwGqH17kjhxwnXu1INXfDL3Q0Mk7/q7xDQ0HEOjvFGADOCMD9CYO1F6zZCOJHRVpWg4Syjur/nmE5hUCBXi/Zfu21yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mVd5SMVD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4fbcfd821eso478961a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968926; x=1757573726; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxE+Xj3ugJHUcqN9a7F7aAsq//VgXJ8T/JzaLukZcD8=;
        b=mVd5SMVDUybeFqyXNebGqCtiwpQjoRXMwjGx23FkKwg7GsJDWSGqlWDlMulTn1tDgx
         16F3Zyu1hhlUdOnzAjAnFX4ORerOUUOIi+0KspYHnuIWLZeREm6WkQ1WzPuW4c567s0L
         UzS5kObvn5/AcuuNL3sP1xmb8+RoVMSEkIgpGuJLHm5GLcktmjsCAgWJsN4bNHwQN0Dx
         zkorZMp87kdzvkfsVTI2qbYbQ3MtDME3i2russAzuO0ylVG33kPnU8SSvlrOzY3Q0/b3
         V5q5WN8tmu02ubD5jq9ade3cJnFh44j3bKaJfcemJ1/XxM1722KaXfDgzjhiTG7HZ60t
         7ZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968926; x=1757573726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxE+Xj3ugJHUcqN9a7F7aAsq//VgXJ8T/JzaLukZcD8=;
        b=gwJNLAM42Da8wu1uP27wuSsBc/aB+JLkVcXTgArBdNuBHkkf0ha6T76zxOA6B9HuLg
         1bC1FEsM014hxmdG4wlb2TqqoQPWgg6gPAGINMlJ2GpfccOZiR/0Wka1wcfJMk53i/Nl
         wuJRAT8F04SDlS056lx/T8TQHlKFNPwIpHeGgnDxOCY4KD43+WLkOV333Wtl+4MCim13
         4Ls98lfXNIqgGAWEdj9pNXH3DaCp+tpxLzQgLn8wuBOvGRq7A4DeUjjsJXS8dW4ZYCYa
         B3kXWjSxmJujH/6FrMm/70Vaap28TJ3wmkBMQFH+1VeGFaahGXqXrIf4iNWQwh2cLI2+
         /vOw==
X-Forwarded-Encrypted: i=1; AJvYcCV5fJt/M1tMW/3cDYAvG7gazJvLiF4+N/LnUurm2ca5V0+23y2bmdEv0hoOdcv4SjvTPWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRW7hS19B5JbRx6hMmA3Hh7sv2npSCXs9YMgoywTAoHdZdpCFm
	N0dQ8MqMm/L3EdIrq+NghzDlUhH2U770vQswAxyFAoBo7mkmyUK0RBmF/YeL/JCxe/aG4pTeXK3
	bmw==
X-Google-Smtp-Source: AGHT+IGoSYrzfeX5RVnQxdwXezOdW2R08Qc3RSSjnfBqAMU0OXMTqtk5sU6FDVAGyyN96wJHsxaP6juUfQ==
X-Received: from pfbdh11.prod.google.com ([2002:a05:6a00:478b:b0:771:e00d:cee])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d1c:b0:243:ca15:f84c
 with SMTP id adf61e73a8af0-243d6f0bc0bmr25910996637.37.1756968926069; Wed, 03
 Sep 2025 23:55:26 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:45 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-16-sagis@google.com>
Subject: [PATCH v10 15/21] KVM: selftests: Setup memory regions for TDX on vm creation
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

Guest registers are inaccessible to kvm for TDX VMs. In order to set
register values for TDX we use a special boot code which loads the
register values from memory and write them into the appropriate
registers.

This patch sets up the memory regions used for the boot code and the
boot parameters for TDX.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b4c8702ba4bd..d8a944b5ada3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2018, Google LLC.
  */
+#include "tdx/tdx_util.h"
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
@@ -465,7 +466,7 @@ void kvm_set_files_rlimit(uint32_t nr_vcpus)
 static bool is_guest_memfd_required(struct vm_shape shape)
 {
 #ifdef __x86_64__
-	return shape.type == KVM_X86_SNP_VM;
+	return (shape.type == KVM_X86_SNP_VM || shape.type == KVM_X86_TDX_VM);
 #else
 	return false;
 #endif
@@ -499,6 +500,12 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	for (i = 0; i < NR_MEM_REGIONS; i++)
 		vm->memslots[i] = 0;
 
+	if (is_tdx_vm(vm)) {
+		/* Setup additional mem regions for TDX. */
+		vm_tdx_setup_boot_code_region(vm);
+		vm_tdx_setup_boot_parameters_region(vm, nr_runnable_vcpus);
+	}
+
 	kvm_vm_elf_load(vm, program_invocation_name);
 
 	/*
-- 
2.51.0.338.gd7d06c2dae-goog


