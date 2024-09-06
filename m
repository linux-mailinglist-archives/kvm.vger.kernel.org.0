Return-Path: <kvm+bounces-26037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C3696FDDD
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83ABD1C21C50
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82696158DC3;
	Fri,  6 Sep 2024 22:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AfxDwBzJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB6F1B85D9
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 22:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725661116; cv=none; b=s1Ct2H5yqo4D4SAaOjcReOxbB2xSkVvPO6CK8aOs1pwgWs3fa9suHgbR6mTf7224Yb2bXiZMX9MCcJSbIZAw4wX/W8LiuvoZOTuqZbIuJe+5SmkuUda0vXVDszWdnD+Bci+pwXY9+SkgpQBtxrDoMo1xp3e0xc4oNY1lADdszWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725661116; c=relaxed/simple;
	bh=iMl1BHMoQ+1hAgoIB5yEAsU5NE3o9J3/VZLMkLMpvZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OBAFtjHUb7n9f7EyjpGLalumP0QmeXRbvJjAtM7lm5RQmo5eUgcSqkS9Nt0Jmoz5tsE89yGtLFAnlKr48z0L+hcTgWV6ljvXO/8z8K9b1r1KBs7s8I7mZx4kB0aZY1nawQpfmuA1hq5M5p76lZKNu7WcJSZH+2YSCs43nv30HIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AfxDwBzJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725661113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3+GRauXwB90EQZo7iqCdJISdP5VklZMyaWAX7+GGbD8=;
	b=AfxDwBzJijxjIQIZ6b4nezfisZ1Ir1XMVRWkRCnCvenkI9JNL5YCD6tCP4kAh8SC3fG01Z
	LmP5ymE+XQ8yM7hG+t6EBjzsJFnw7QZEPYj4Gfe2wexf5vS8wD5hETWQ1qKpAd2Ws34Dp2
	ylE61N27DZlk+sFmrYSKy1PTYSrBizk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-CKSYpXUhO8GkDdWiD-Qnyg-1; Fri,
 06 Sep 2024 18:18:32 -0400
X-MC-Unique: CKSYpXUhO8GkDdWiD-Qnyg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C3781955F43;
	Fri,  6 Sep 2024 22:18:30 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 045D519560B0;
	Fri,  6 Sep 2024 22:18:27 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 1/4] KVM: x86: drop x86.h include from cpuid.h
Date: Fri,  6 Sep 2024 18:18:21 -0400
Message-Id: <20240906221824.491834-2-mlevitsk@redhat.com>
In-Reply-To: <20240906221824.491834-1-mlevitsk@redhat.com>
References: <20240906221824.491834-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Drop x86.h include from cpuid.h to allow the x86.h to include the cpuid.h
instead.

Also fix various places where x86.h was implicitly included via cpuid.h

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/cpuid.h      | 1 -
 arch/x86/kvm/mmu.h        | 1 +
 arch/x86/kvm/vmx/hyperv.c | 1 +
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/sgx.c    | 3 +--
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 41697cca354e6..c8dc66eddefda 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -2,7 +2,6 @@
 #ifndef ARCH_X86_KVM_CPUID_H
 #define ARCH_X86_KVM_CPUID_H
 
-#include "x86.h"
 #include "reverse_cpuid.h"
 #include <asm/cpu.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 4341e0e285712..9243a2863c8bb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
+#include "x86.h"
 #include "cpuid.h"
 
 extern bool __read_mostly enable_mmio_caching;
diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index fab6a1ad98dc1..fa41d036acd49 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 
+#include "x86.h"
 #include "../cpuid.h"
 #include "hyperv.h"
 #include "nested.h"
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254df..3d64c14d4fd76 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7,6 +7,7 @@
 #include <asm/debugreg.h>
 #include <asm/mmu_context.h>
 
+#include "x86.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "mmu.h"
@@ -16,7 +17,6 @@
 #include "sgx.h"
 #include "trace.h"
 #include "vmx.h"
-#include "x86.h"
 #include "smm.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6fef01e0536e5..016db12631d66 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -4,12 +4,11 @@
 
 #include <asm/sgx.h>
 
-#include "cpuid.h"
+#include "x86.h"
 #include "kvm_cache_regs.h"
 #include "nested.h"
 #include "sgx.h"
 #include "vmx.h"
-#include "x86.h"
 
 bool __read_mostly enable_sgx = 1;
 module_param_named(sgx, enable_sgx, bool, 0444);
-- 
2.26.3


