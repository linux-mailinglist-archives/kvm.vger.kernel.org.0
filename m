Return-Path: <kvm+bounces-55249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0837FB2ED12
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4339F7BF6F6
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CF02EB860;
	Thu, 21 Aug 2025 04:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xs8hNWM/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4382EA728
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750586; cv=none; b=U8n+vUiPgMbqdBz+3NRp9JuznlXeVj6oSvZgPX9kV/BTlIg8MZOmtwQSQKkIEj9m4DtiMnGG/KpobdFbcjfsor2OGMcEyy73byul6hr1measN6/OqZFgj/51dAzktG3W0FF6AW8wf9g3v0daFvxx+eA+GJwbmbbUgQRZveLNFX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750586; c=relaxed/simple;
	bh=8LW9fPqlqltwsHHnngmKu/oedqkqhCGSJV7BughN2D8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jg69qWN0BrRfO62ByC6o869rz1TRy2jYOWKJqFWAefxQwlURrKIf+H9LbWEHOV/tJlemRzXZy7dy3PClTkAHHqwRzOQffaJXnCTQMZ1xhW1ibQI0oCDHIpz2KVKgPkPZ9TkrPj8BJHJH/hKoMw+iWpyVaUVdVdhu2lyYNjrARhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xs8hNWM/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174c667aso477149a12.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750584; x=1756355384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0v8Xhqku7JbLYSzHfxNxFV/zNuQzZHa6ydPXR+w0a3o=;
        b=Xs8hNWM/wbZOpxKY2rua9bKgcOvvGUATzpLjyBXCipood0F923RUDdzy3y4NKMpYGs
         NlEzcblJ7v/cOhmmGIWzN7bpxKdUWgcEiE7/EXeV971Wmi1bWnxKwq7RpzZikyjF0LX9
         I6Auj6Eb03Iic5LNBLXeg/7knEz2tTvHbKIQ+2TW4imekMVnv7xs5Jhd+QiCpylC5VvF
         +x7Si4aq0/+HxHj3m9daV+v526hPdYz9093Pxdi7vH34WesGp4+baHBTxgVOd/H2s8SI
         t5re4iOvxptjb2B4gTp4V4R48BEOxnUlB9BZV+h/BV2k+vBACTZGK4Hp791Yepa5Fqnm
         UX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750584; x=1756355384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v8Xhqku7JbLYSzHfxNxFV/zNuQzZHa6ydPXR+w0a3o=;
        b=LzDUn2FR2Wc5TW5C4rKaoOq4BcDwqsK5aZ3ZO1VHyroHKZgiwYyvz84NBxX7mFUcvJ
         DSsZHd8mONE3IPQjrDGCEtonz9Vdl0TuQS2mgJfR0k+7as1iUPzHz14OCP/gB7pt67YT
         YDGR5PDoxQaB1xgt4ePrzXsCpZ7wxDlkUqSSsdsitYlWYjrznJTaUBOD5GDs3T/00Q6D
         WUUJ61iwzvXHmepyfSaXPOyHgdKcUdelP0mhZ14RnEP+2t+fnxsy5f++/6Yy7D7NK/3a
         qrBE8/ubJ3m58bITyuFeaaqbhIo83ubgp3TLVBTUw4fHyZ3GytAzxWKsRo2c4szZq08Q
         cfMw==
X-Forwarded-Encrypted: i=1; AJvYcCVQIFxsya0N5OguA08Wie36bHpK+VAn88oqV2mCFnDYoRXEkSH1sMACcBGswB8Bvb9uztw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM14M88Hl1Jx1EdruAmnvoDMH89TuORetz/e4O1tWW0W2hqK1l
	SDiMytTaV/nNac9DYWPzGKTtneQCTEwx2TM39DghXcF7i+/J30tNozHO8Wsnd7+0pWnpJyKHXuT
	AKg==
X-Google-Smtp-Source: AGHT+IHoYEwP7EzZ53USD2mIjc5qGUC3k55bBLYh38dEin6rSVJ2mTGlfcHpGpSYs073s+UjtI+o0y1iHQ==
X-Received: from pjbli15.prod.google.com ([2002:a17:90b:48cf:b0:31f:1a3e:fe3b])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3ca7:b0:243:755:58ae
 with SMTP id adf61e73a8af0-24330acb929mr1268174637.47.1755750583705; Wed, 20
 Aug 2025 21:29:43 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:29:06 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-14-sagis@google.com>
Subject: [PATCH v9 13/19] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
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
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

This also exercises the KVM_TDX_CAPABILITIES ioctl.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/lib/x86/tdx/tdx_util.c        | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index 3869756a5641..d8eab99d9333 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -232,6 +232,21 @@ static void vm_tdx_filter_cpuid(struct kvm_vm *vm,
 	free(tdx_cap);
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
 void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 {
 	struct kvm_tdx_init_vm *init_vm;
@@ -251,6 +266,8 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 	memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
 	free(cpuid);
 
+	tdx_check_attributes(vm, attributes);
+
 	init_vm->attributes = attributes;
 
 	vm_tdx_vm_ioctl(vm, KVM_TDX_INIT_VM, 0, init_vm);
-- 
2.51.0.rc1.193.gad69d77794-goog


