Return-Path: <kvm+bounces-39335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A24A46969
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1E783AAF49
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8038C2512E2;
	Wed, 26 Feb 2025 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXzGMQef"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C052512CE
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593733; cv=none; b=MJrzRREICheT5rsCLex+L4LFP/bjhGhY6ESOkiiJe5agsehwRjvZ5s3UCDfMZhSpe6irq1AYiMG17OD5z6/KjkI7oIizYSy0TBW5aVKPaMEu3rDOwZS6M0I/Nfo8BzRN02aO4lqC430a0leTx9X+1n1Q2dWOmMUsfO1mUPmO2CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593733; c=relaxed/simple;
	bh=NOrvwXqR5tV+W7LxV0x2ybvsuMk244ehyvtkjrZV+Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLGEgD30pWwd8c6eAxHuS+5HsT1J1tC3PlblBodfqQzpgcQB9pd6lCRFYJpRN9sSGDZ3qd9Y4BXQtRP8uo1TwHL/ihh5XV43NYEqvnkyt94SYYi8hdJb6j5LPVq5HJHCDNTtfC+LufRtRq9HmeSoCAZtQRMWNBJ9XMoi73whYCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXzGMQef; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iq3nv4epyJpDbkhtRdpqEYBbJ+XxMFdUGfj+JfUiYew=;
	b=EXzGMQef+1iXDT14asFyPawc/RW3ECDuOhBc98NjSgAJEU5E4rTRZGQEy3fF+eyI7F3Guz
	/BNUQiNNQxYIyUTwIfWQj/LSCHOWx6DHPt2vGrJ49MWxsXx9qM6QmyWU2NltDd4qz8VbCZ
	ouBk8i4bTOfRD4YC2Z3DSgG+ZBIHoDY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-03ljOewoNaGsqNojuGZQ4g-1; Wed,
 26 Feb 2025 13:15:27 -0500
X-MC-Unique: 03ljOewoNaGsqNojuGZQ4g-1
X-Mimecast-MFC-AGG-ID: 03ljOewoNaGsqNojuGZQ4g_1740593725
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B22B3180087C;
	Wed, 26 Feb 2025 18:15:25 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 607ED19560B9;
	Wed, 26 Feb 2025 18:15:24 +0000 (UTC)
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
Subject: [PATCH 20/33] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date: Wed, 26 Feb 2025 13:14:39 -0500
Message-ID: <20250226181453.2311849-21-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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
index c319eb44d9f9..8928b27547c1 100644
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



