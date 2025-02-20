Return-Path: <kvm+bounces-38750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8449A3E1FC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E9D7177090
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A339622330F;
	Thu, 20 Feb 2025 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQFS7qDy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47042206A4
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071210; cv=none; b=V3jfqxSX3kVk5PfIexTbBqSyyPy0/hLyb/MmaOFm+4i36HAYmCdbro92mfiyUZTKY3eJsEgtOuSZNaiY9x3XP720HddVc/ldC93qzyPwE/6e+AVWJ4PoMFaG2BRI7OylwmuqBndiPzf4MFqVRpdz5y9yeVkj/Ao5uqJ3E8Xmboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071210; c=relaxed/simple;
	bh=1I701KyNSGUm8RYQFeoQ3GgMoqE3LdQNgtYUk6q86q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/TKluvzgUjovucNll2X2lHXxTmj9u6Xoesor8bRblPr+yBkc+lWy6eraF1MFBchQ/Je1UElnQTitmeUHwhFp+UUb+FJkvEtOaU1/hCZogQ7DjEoEwvMWkQPCZaKtW2z9z0DvHSrUvJGUkGDYmGQZ/NE08JKAVKGT/TzZT58AYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQFS7qDy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxfc0QDdR7NUvWcoQzVsBBRdWvI7T7CZJvQ3sHjQves=;
	b=WQFS7qDy7lI35ZELZraMxx1x1WQuS+CRL9DSPXFzP/APHe0aRsckP8sM0U0ZebEpqOgmoO
	qAccGYtnrl46Ai9kR5NehZg53WkMx7N/7WLZvBL6T/322ZChfEF6IjgcIftvglzEEl8sLl
	ssuirxzg1JfPlyTlj+ZSxO0LeuJ3ZPM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-8RdNyRGDNZuWfFeTJ7S94w-1; Thu,
 20 Feb 2025 12:06:33 -0500
X-MC-Unique: 8RdNyRGDNZuWfFeTJ7S94w-1
X-Mimecast-MFC-AGG-ID: 8RdNyRGDNZuWfFeTJ7S94w_1740071192
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60A6E19357B1;
	Thu, 20 Feb 2025 17:06:32 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 10B45180035F;
	Thu, 20 Feb 2025 17:06:30 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 17/30] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date: Thu, 20 Feb 2025 12:05:51 -0500
Message-ID: <20250220170604.2279312-18-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to print out errors from the TDX module in a uniform
manner.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a830e9c42bf2..1f4875e5f7c9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -10,6 +10,21 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#define pr_tdx_error(__fn, __err)	\
+	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
+
+#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)		\
+	pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
+
+#define pr_tdx_error_1(__fn, __err, __rcx)		\
+	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
+
+#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
+	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
+
+#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
+	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
+
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
-- 
2.43.5



