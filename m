Return-Path: <kvm+bounces-54278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B0BB1DDE3
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D72473AAD51
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA8B274FCE;
	Thu,  7 Aug 2025 20:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZmFzrer6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B354230274
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597810; cv=none; b=P0nulHmQLXFPGf5+syVotUaeXhiJvcv3CFwuHRUHqrPb+ygtQqXqZszx/c1B6SpLP/gCYaahlRnBeRB+06FzEi7jHb6d2Vo4gthCiV1hVPXqYHAq9rMtHJcE9Dm7n1gvkQR6mTGoaaX/6IsBHKRoObjEfc4LWPHKx+PS2+v/LE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597810; c=relaxed/simple;
	bh=qZKtRz7nLG2KF7a1TIq9CkaKwIyQfE7M1cz+YMT0C3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/tNeH8PNlzLj9qC3fkh2JY7RCD5r5xPLleko9OT7KAxH8GA8AfRhqBezJPyw7RsPIv0MZtNe0NmHWcCGBxAqaQURpP1XlWfkkrHYJg+UgNPXAwhjEx0K4rMpNb1+y8ORqVdOSXRh47+/Hz/MCHmEjZf2yOlml4ZGPLG6wikFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZmFzrer6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f3b65ce07so2548946a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597808; x=1755202608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ok7xE/zvSsxm3sMvm91OXvNKe4HIqd8wijh5DP/BfeQ=;
        b=ZmFzrer6tnf89eTHTYtDDmcOlwC7JhRsg5azmqe4vedhD8IK8/8xH8c0LpvUyRz2FP
         Px+K7U0iwI+S6WRFc/QpANy4QUbrsEzv6B7O+0RW+Uq/B5LOH+BHY80oxhwWtlSmi8VU
         sZKvt8OHddPO7glc0yzKco2t3IyQAsC7/3ZemZ2uWFRc6PXIhXF7NbIKNX+T+7bBtqWL
         hQkLTWD51D5726zXEfrOPw4wdNlIUX69hH7MeZ9XzUo74n0sPoueRnlLeFtoisDGK/aC
         105Z+YEmorV9kn+DuV1+CfrnjJqHc3NcnG7QPhkIDBQeytX6mYePVjUaF2YE26mTXqEQ
         vsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597808; x=1755202608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ok7xE/zvSsxm3sMvm91OXvNKe4HIqd8wijh5DP/BfeQ=;
        b=D21ShKBgGK2XfF3Dmme5wvQWDF9ocsA03QithY68TtPRfNA+KYIh+p5L3v1ItbW68I
         XOYMFQ6Ap5D12PtpTRAnU+U3rJnrDGQxHibC6yBbyMEEop8oURmmI+V+WRToBVIiM63V
         fBB24hulLad48exEfK22CxfMLbQVJEOQl7RJzvn1Ows4Qd3+gw5b/y3QFZA9W73eD3jk
         z2YpnRxMvsKiUnOgz2Bg4mRbIVZfEcqixQUcaIyAkILA5f5clLbuiuhRWroBeELjqMEa
         26t0QjDwLx3RDw/wSJmaQWhmDxM79TjVCe+hVUYcoH/8d64bJQdklk0w/UNOtwJb8Emf
         EY9w==
X-Forwarded-Encrypted: i=1; AJvYcCWxbZSyYWu1kyKR8SQ0ldS/z1zHfPLKrv0gyww7pBYKe59/YxsnckN/cKEhMQuKmZYlaOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhBqnFLXGgGmcTnnlx4bZcAB0b26YbtO/RBVcsOTg4HnUkKWpX
	8Sbj3Aq392AkWHUkCOHa68dtvKJXn33dhVMdYrpCYkS/gL/69grWVHbk4cGtH8dwv7r3dipWIrD
	ITQ==
X-Google-Smtp-Source: AGHT+IEOPFXTvjzpu+YcxLn8CBY9Lmh8oefZR6eapvpl0ypNZ8CQQQCwseoJbEg4jHcPbgbjKqwF/k3k4w==
X-Received: from pjnx5.prod.google.com ([2002:a17:90a:8a85:b0:31f:335d:342d])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d89:b0:321:2160:bf76
 with SMTP id 98e67ed59e1d1-32183e6d8b9mr392794a91.25.1754597808002; Thu, 07
 Aug 2025 13:16:48 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:03 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-8-sagis@google.com>
Subject: [PATCH v8 07/30] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
 validate TDs' attribute configuration
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
2.51.0.rc0.155.g4a0f42376b-goog


