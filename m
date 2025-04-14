Return-Path: <kvm+bounces-43290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC227A88E40
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBF93175E2B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD03207641;
	Mon, 14 Apr 2025 21:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rvlgWTEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C42B201100
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667330; cv=none; b=TOVNlmxT8rT3eJvtBefk8D0/znHInugEmD6Rr5asoonKtDdbATJEJsCVj5fJ8vxAzgc3GDpJLVtKnaMoyu4zlwdgLaWxsm4WKXNydjhkpAJYIvI/UN1rMiN2sOAbaUp1AzpRlFFburViobOK+VVPlb6/AP2QNKgbd/cyyBy++yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667330; c=relaxed/simple;
	bh=2byR8UH51bmbkgdPMPySpiVgg0lCi0URtBKk45sX7uc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ufyQK659Zz6yn+zrFIUXPLbnLA023o4HvWWfJAYZJf/8SyFxnClccEMvZO28Sli0BVokZ0xA/RKcCf4b0iC/JgFg6+e+C1UUAyLhjuH6CtDiajkK0XxGOSCk2Mmp0CBIecThG8X5YJma96z2Z6fL4sFLkEMBRc4tkvPTmq/vrRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rvlgWTEZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2254e500a73so35244045ad.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667329; x=1745272129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P7Qom50eDC188U13/HOFwNtvgcykvZaa1C6ujy0ONuE=;
        b=rvlgWTEZgvBkx1U6u933rXWud0+C3WIrR7VEurjwtDWzDYK5J/XiWVjq1ce3jZKFWN
         MCUrsUUunyq6FSxr1kexg4Himyz11W937cEnSynSdTgN+RRckpVSAbJzOXIiZtn90T9S
         yVmMFdq+4UTHq6gnA0vDjqxbVHlPMZRHlxt2Cr3jRD7SaR1t3JAroyyzbTcxFw8MV8Ty
         RTIvzMXv9k9BkCRySg6pZLlNz2zciwdZdg4lZqQVahbXNfYriP5evT9tLBJBapGaUGVU
         vW3IDHTepljDeM6R0g5rnqemkey3DLxtKWO7Sl/CIFEHjVOMAG0LpL8l9+5CKLpIsAUI
         FM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667329; x=1745272129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7Qom50eDC188U13/HOFwNtvgcykvZaa1C6ujy0ONuE=;
        b=jzFGg6O7t7uhJLPEsc2BuoHOyYbO50T6LRZWOF6DWBZMktlqrbDWKAqIWeB6wU5ojO
         06qsscooJ6FJTOaIc/3YisbKa8KuhouRyKCGFipj7Bc495giqTsGxxTcWvXn8z47iAui
         QE93pZ1I2Quzb+WqvJWsVocLKfEuX1cAXEqZDTFO3qEYw+B7fYeyUor+t6tTKZXXPRKu
         N+rj8FRb4Zl9tYlQe6Ek0EccDi8kNUT77A7CtEOFhLPHv7NvlBZRn+KLn7xj35+n4lwL
         WgthBtruTGvKqs/iMHhjixEf1LQtGijs0f3t+mX4+NWDsKebqDW+6aEuknMCzl2G2Zkk
         /bCg==
X-Forwarded-Encrypted: i=1; AJvYcCV4cRfdBTpMrib5OPSnRvYis2kWdMjgZqqW2h2JJBqhgGHihnrzr7F1NoxGcNlB5eyuS3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlwxL/ZjzI7eHs89u+iJfBNc7cMVoSAIFOGpRLoPb6yLIFEbwW
	h97S9EPdmQSnYRXEQlyhzZ+2Qtd7vBmUphYvB18NHO3gHbXO1NdbQqscZNOCwlJTIcU7Ndfuww=
	=
X-Google-Smtp-Source: AGHT+IHuJRjVD+KxdVZLouB1IrWp37UJ2i9gHWC/JZfkmJOJBqRbDCQizQwWokAfJIzCXL+txgFZ4h5IWA==
X-Received: from pfdc25.prod.google.com ([2002:aa7:8c19:0:b0:73b:bbec:17e9])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d512:b0:224:721:cc
 with SMTP id d9443c01a7336-22bea4ab7eemr167120605ad.13.1744667328863; Mon, 14
 Apr 2025 14:48:48 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:36 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-8-sagis@google.com>
Subject: [PATCH v6 07/30] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
 validate TDs' attribute configuration
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

This also exercises the KVM_TDX_CAPABILITIES ioctl.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/lib/x86/tdx/tdx_util.c        | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index 392d6272d17e..bb074af4a476 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -140,6 +140,21 @@ static void tdx_apply_cpuid_restrictions(struct kvm_cpuid2 *cpuid_data)
 	}
 }
 
+static void tdx_check_attributes(struct kvm_vm *vm, uint64_t attributes)
+{
+	struct kvm_tdx_capabilities *tdx_cap;
+
+	tdx_cap = tdx_read_capabilities(vm);
+
+	/* TDX spec: any bits 0 in supported_attrs must be 0 in attributes */
+	TEST_ASSERT_EQ(attributes & ~tdx_cap->supported_attrs, 0);
+
+	/* TDX spec: any bits 1 in attributes must be 1 in supported_attrs */
+	TEST_ASSERT_EQ(attributes & tdx_cap->supported_attrs, attributes);
+
+	free(tdx_cap);
+}
+
 #define KVM_MAX_CPUID_ENTRIES 256
 
 #define CPUID_EXT_VMX			BIT(5)
@@ -256,6 +271,8 @@ static void tdx_td_init(struct kvm_vm *vm, uint64_t attributes)
 	memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
 	free(cpuid);
 
+	tdx_check_attributes(vm, attributes);
+
 	init_vm->attributes = attributes;
 
 	tdx_apply_cpuid_restrictions(&init_vm->cpuid);
-- 
2.49.0.504.g3bcea36a83-goog


