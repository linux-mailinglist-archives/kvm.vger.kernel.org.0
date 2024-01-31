Return-Path: <kvm+bounces-7608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1FB844B3E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:50:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 076FA292766
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3753A8F0;
	Wed, 31 Jan 2024 22:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bZMjaUFV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B613A1D4
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741419; cv=none; b=i+4kAloohtSyxHZWMNW9gvA8waDXtYr6+hpZ2UIafJpdBYNHUxkDoXFUZFyIZ95RYwO+49T02l6SwZLeGhoiAnw6T9CrGkP0U2eHwWL5A4vLgVDm0tluuH6m2NBZ4dH2sds0sfga4LnH3p5zTThNSTVR7KAzC3b48x6/gnJRirA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741419; c=relaxed/simple;
	bh=1/4WEIAIKqQBXE0ZhDljCAFK3p148tD/jCshuVONiGI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LayH1714v+TRldMAGmTYbpgNYPqSsRs2PGQkZ8hgJNb5euG8adDkIWxrAEcNoE9nZBJPEhns9xZakvhKk+CB87bDEmrQ0XFGHSN97W509qs44LM9Di+ZlOEppWVk1lT7sceewgMiXvKv+MSf/3DSrxBzwB78QRbid70WGNI8wTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bZMjaUFV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706741415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4Bff5uM3q8eLthCYLMVDr14Of+ziM6eQHIEK7k2YKg=;
	b=bZMjaUFVn4fydTcuFiNzgUrw7ja2Vxdr9cyXC8LTJHmpwOQ1o4b0zsHzV6iHCxfjA2SDY5
	V27R7BMuPhWszK7bT+dPYJOf30VNJqChfnlrr2O3Viw7v7NsuFtcLwg7YfHu5HvAXKZKB3
	cHgGrPrtvFrSoY8SeliaqYzcM1Tzniw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-4ALEoIVjPnW3OisOpzO0ow-1; Wed, 31 Jan 2024 17:50:11 -0500
X-MC-Unique: 4ALEoIVjPnW3OisOpzO0ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C1D4185A785;
	Wed, 31 Jan 2024 22:50:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A6AE2166B31;
	Wed, 31 Jan 2024 22:50:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dionnaglaze@google.com,
	seanjc@google.com
Subject: [PATCH 2/3] kvm: x86: use a uapi-friendly macro for BIT
Date: Wed, 31 Jan 2024 17:50:09 -0500
Message-Id: <20240131225010.2872733-3-pbonzini@redhat.com>
In-Reply-To: <20240131225010.2872733-1-pbonzini@redhat.com>
References: <20240131225010.2872733-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Dionna Glaze <dionnaglaze@google.com>

Change uapi header uses of BIT to instead use the uapi/linux/const.h bit
macros, since BIT is not defined in uapi headers.

The PMU mask uses _BITUL since it targets a 32 bit flag field, whereas
the longmode definition is meant for a 64 bit flag field.

Cc: Sean Christophersen <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Message-Id: <20231207001142.3617856-1-dionnaglaze@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a448d0964fc0..9ae91a21ffea 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -7,6 +7,7 @@
  *
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/stddef.h>
@@ -526,7 +527,7 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
-#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
 #define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 
 /*
@@ -552,7 +553,7 @@ struct kvm_pmu_event_filter {
 	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
 #define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
 #define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
-#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(_BITULL(55))
 #define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
 
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
@@ -560,7 +561,7 @@ struct kvm_pmu_event_filter {
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
-#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+#define KVM_EXIT_HYPERCALL_LONG_MODE	_BITULL(0)
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
-- 
2.39.0



