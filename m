Return-Path: <kvm+bounces-49484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DCFAD951D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B35DA1E4C99
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5A2293C59;
	Fri, 13 Jun 2025 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jb/G19Au"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F19275AFF
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842065; cv=none; b=OFSu132sdZ3B7LRy1XLgY6QrSQxrt3vt375PIsTQIFriPj+OgDYaOBH47nQs9YYRiuRTxIihmaBAHz9lIqwzXe5V25uY5AbHgUhpmF0SPZkkGkwPuUhEu8Fv2SbNwrZo1zadBrK+L6A7eTBbYLjUQYnp2ndNS64c5Iy6IM/hbFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842065; c=relaxed/simple;
	bh=n+34/TQnDhQUpWV9zBPtETMCqc79945QBOwUvQHWJuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nK2xfCxMAPDsvOATT3pzLvuWPsWTUyvbq6gPiOhqOy3nhrlBL7QDVjrmejwrA9S65PIo+GuqWo0hCa/K7CbpFnkjRjF2RJbIiP6Z4PVltJFbGsv+1tECJnjsGwGk2gybBTea1rFLQnbv2T5vJZfNkKaoaFMBVQjPDMPjmvT4YgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jb/G19Au; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31220ecc586so2369970a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749842063; x=1750446863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KKvGThASRp3H2fuQgg3irPPgWW1C0TLSvPp1AQa9Mz0=;
        b=jb/G19Au2VOTqbuMe9VbDT9Wgc5PWcD1zc1vNVEUhsFj9L/RKJ2FEEdvvTi1sdlQCp
         xGvkT50H4aCGT4VMDCfRQBWOoYF+Nz6rtb6BMnpFt1EpzDsAb6me0+/ZO4K+ruwNWcnX
         wyDbQhNHMlbByeYcdwOw70iadNJO0xARyTxWs+FIfc1OPWmsFfCQiQET35FYuN0Oalpg
         BzOPCpIRpjms+1pf2L6ZPKGBrQuyljCKTxb6dUjdahyduALLMIBR4w7x+c4Qx4dYE1z5
         lvVmRMsHI72iDH4hhaqCZXD4d0UfEocfO/7JRYshQyvVcyN9jcguinFA48Rl/kFN0oDp
         naUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842063; x=1750446863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKvGThASRp3H2fuQgg3irPPgWW1C0TLSvPp1AQa9Mz0=;
        b=Ez+r7HMPmmKY5xYFXIHvnRgTbfjtlhiTIspTBUfvqGI7CHZ3rf2Ui7rs52AIjTJfjc
         r2n6XAhZYYOXvMGEXk50iTxDxx/GVBHFliS96MIhUQxKMZwb3ni5Kq4Xh9E/2r/RGiuT
         Zpmxw6toEORyLSb4+IytSxyD7TmZ5Nsh8fhTKv4yKk06lJYLK+9RZe2EvamGgKn2zwpF
         GAUWS2/M9e8HyG1B2/eb5+D4AaqMdgzT/TmfgEMvq06G3f9PqRFkn2f6XBvT3W6PWtvb
         gp8lQMlz2cx+x4w9WAauX/821+Qp/a3AJNqg2h3MH6eStYBWqV1pYRcNj3xA8JCTne9Z
         PAug==
X-Forwarded-Encrypted: i=1; AJvYcCUFUGX+ssjoSP2L4paHLQ8Q4nP8xQdAvWGWwwnn78EUdK2afcZpgw1mTt0Zg8XjV+vx7r4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJWum0Hn9HyeoXuB8lBo385I/47BWcXoHDP96LpwyGkbWxNOw1
	+E6UP2nX7IzUmOFsyJ2Ze9paP6HtZ0cF3EMxr+2I+egVEhl/7LW/J10ax5svX/kGKHPSYkZvKXc
	3HQ==
X-Google-Smtp-Source: AGHT+IEBcUSdKCdQQyJat53qjznsfsYVoRbsmkBiaiRjdIDqSqw1KmSy96Z3hS82BrR5/3y0caOOvTW4Pw==
X-Received: from pjm11.prod.google.com ([2002:a17:90b:2fcb:b0:311:ff32:a85d])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cd:b0:312:639:a06a
 with SMTP id 98e67ed59e1d1-313f1d0aa4emr1154843a91.31.1749842063073; Fri, 13
 Jun 2025 12:14:23 -0700 (PDT)
Date: Fri, 13 Jun 2025 12:13:34 -0700
In-Reply-To: <20250613191359.35078-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613191359.35078-1-sagis@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613191359.35078-8-sagis@google.com>
Subject: [PATCH v7 07/30] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
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
2.50.0.rc2.692.g299adb8693-goog


