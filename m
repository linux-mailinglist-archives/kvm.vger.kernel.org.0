Return-Path: <kvm+bounces-27728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D55D98B35C
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59D252841C6
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E351BE86C;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Y2NJOuIO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E031BBBC6;
	Tue,  1 Oct 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758939; cv=none; b=dxi+smaR281v9CfzgWUZoVcytxZQiV5kyNF5RaIXuhxit110TK7EcWuczbkP7VXJ4UTDFQx8EgZUTrJyMNau3QMS9Jz3D9HxOD4Vb/kMuTYcpfZVa0NuyafEdlWXLjaFzV168qyebvC8PTR2JpksAdE8Xv+gGFIPzpded4OtNXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758939; c=relaxed/simple;
	bh=5TG94s28ejMPLZuTN+ZSw/em4KzqzULOEqado4Xkwyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coOPBZN2UEbZAiOM4NYv0L1VeMxzDcItZ68K+ij8jRZIx4wnO3NSfx8d8nIJzfQsaE1S6zmDrQhYyeJKz+Z9OhmHOa+uZM6QUEjACQMJ81a7mV5I76QwcKHriLbu14odGLINv8LZ646EdIJv2GU81h9HrLzhQ4uKJhswSRxZRIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Y2NJOuIO; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7n3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:39 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7n3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758900;
	bh=4qMitadCZcAtQoU+ROJIy5ikCk5LW8rpQXESx5x0i2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2NJOuIONP/G6SdlqrTJ+naSPF1HFQYdqe+ls6nhoc1CC0Jo032goOMUyj94dKaIr
	 rr7z1lTdtXOAPoE3lcCbJDG0PGt7diIxJsZS3OuUEMfjCcaJCrHiTesQV1SEfi7cBX
	 eK80gDns0/1+FgFIRcAw/bOL7maXNyLEWwsTVoHzUfzj9HBHCIouEHI+M+ILxO0OQo
	 7wRPKukrfishIjOpiqXj01BwkXy+qZ6NS8SrQNPM/9DUMybuK3f+lHw5cc9D29j4Ud
	 q2gEUHySFQ1dJFoCwTigqeh9gJdnrBanpdwKHd4D/VnXTKSTI6F1xhyZUO0wdjoPPw
	 u2qTGgnsyskqg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 24/27] KVM: nVMX: Add a prerequisite to existence of VMCS fields
Date: Mon, 30 Sep 2024 22:01:07 -0700
Message-ID: <20241001050110.3643764-25-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a prerequisite to existence of VMCS fields as some of them exist
only on processors that support certain CPU features.

This is required to fix KVM unit test VMX_VMCS_ENUM.MAX_INDEX.

Originally-by: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/nested.c             | 19 +++++++++++++++++--
 arch/x86/kvm/vmx/nested_vmcs_fields.h | 13 +++++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/nested_vmcs_fields.h

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7f3ac558ace5..4529fd635385 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -49,6 +49,21 @@ static unsigned long *vmx_bitmap[VMX_BITMAP_NR];
 #define vmx_vmread_bitmap                    (vmx_bitmap[VMX_VMREAD_BITMAP])
 #define vmx_vmwrite_bitmap                   (vmx_bitmap[VMX_VMWRITE_BITMAP])
 
+static bool nested_cpu_has_vmcs_field(struct kvm_vcpu *vcpu, u16 vmcs_field_encoding)
+{
+	switch (vmcs_field_encoding) {
+#define HAS_VMCS_FIELD(x, c)			\
+	case x:					\
+		return c;
+#define HAS_VMCS_FIELD_RANGE(x, y, c)		\
+	case x...y:				\
+		return c;
+#include "nested_vmcs_fields.h"
+	default:
+		return true;
+	}
+}
+
 struct shadow_vmcs_field {
 	u16	encoding;
 	u16	offset;
@@ -5565,7 +5580,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return nested_vmx_failInvalid(vcpu);
 
 		offset = get_vmcs12_field_offset(field);
-		if (offset < 0)
+		if (offset < 0 || !nested_cpu_has_vmcs_field(vcpu, field))
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 		if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
@@ -5691,7 +5706,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = get_vmcs12_field_offset(field);
-	if (offset < 0)
+	if (offset < 0 || !nested_cpu_has_vmcs_field(vcpu, field))
 		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 	/*
diff --git a/arch/x86/kvm/vmx/nested_vmcs_fields.h b/arch/x86/kvm/vmx/nested_vmcs_fields.h
new file mode 100644
index 000000000000..fcd6c32dce31
--- /dev/null
+++ b/arch/x86/kvm/vmx/nested_vmcs_fields.h
@@ -0,0 +1,13 @@
+#if !defined(HAS_VMCS_FIELD) && !defined(HAS_VMCS_FIELD_RANGE)
+BUILD_BUG_ON(1)
+#endif
+
+#ifndef HAS_VMCS_FIELD
+#define HAS_VMCS_FIELD(x, c)
+#endif
+#ifndef HAS_VMCS_FIELD_RANGE
+#define HAS_VMCS_FIELD_RANGE(x, y, c)
+#endif
+
+#undef HAS_VMCS_FIELD
+#undef HAS_VMCS_FIELD_RANGE
-- 
2.46.2


