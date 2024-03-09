Return-Path: <kvm+bounces-11451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E8187724B
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 17:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32F181F215B8
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 16:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F5F4A23;
	Sat,  9 Mar 2024 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TV2Z0agM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E7915AF
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710001879; cv=none; b=pJ/0OUoLNca94GMRgFf0wplTWCVd0X1POgfkpAZDgxCElh/DHU51keTTltr6Fa9X7gBcqWrqMFIg7XIcNLDv+DWxfobVoFt/BcfAJklh95c81yzFcz1KdWefdkZsFKhmY1xc6n6zTvSB9IB1nbzDUMuMI5ezlz9gbrLrxc/iTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710001879; c=relaxed/simple;
	bh=UQc3izrgQr12h3Xm9t3aa7jRiYIq8O1PvIR3W3XHYC0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Cvx4gHmgCVv9VU7B7uAPQxmSe4mTd/KW/wPqeD4Tm//IFT4933BrQbXrpeybhh8fGjGXzqaIlM5z7BL9WxZ06SliokGY5mrrMsISI2DzSFuGXkGPCOxz3uf/IGZwqyvB1UpYhhdJGDw335wsQv59z6BMdzpf/niGIh/z6HKhq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TV2Z0agM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710001876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U/gHXMil7a5VrcnGbVUk1+YLbdf6KR/XO3UxnJ9TTQQ=;
	b=TV2Z0agMxa8AR7Bv0s+5cNMwwJfstdhm4rBWSSzUoIW4sOUWVSxn/T30rmqSJ7NlIbHVhi
	uqeDRuDGAZGC5CmCEwgY4TktlQorsmhYYqfTL2yebcw/GLDOdso/y2YWrJWjSZo8DnjUXr
	j0uTr41Z1w+E0RNmTFzypOfwJSV/478=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-s-jvVsfJNZ2UCQRK9TVDZQ-1; Sat,
 09 Mar 2024 11:31:15 -0500
X-MC-Unique: s-jvVsfJNZ2UCQRK9TVDZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4E2C3C025D0;
	Sat,  9 Mar 2024 16:31:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEDC3200E28D;
	Sat,  9 Mar 2024 16:31:14 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	stable@vger.kernel.org
Subject: [PATCH] SEV: disable SEV-ES DebugSwap by default
Date: Sat,  9 Mar 2024 11:31:14 -0500
Message-Id: <20240309163114.2368452-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

The DebugSwap feature of SEV-ES provides a way for confidential guests to use
data breakpoints.  However, because the status of the DebugSwap feature is
recorded in the VMSA, enabling it by default invalidates the attestation
signatures.  In 6.10 we will introduce a new API to create SEV VMs that
will allow enabling DebugSwap based on what the user tells KVM to do.
Contextually, we will change the legacy KVM_SEV_ES_INIT API to never
enable DebugSwap.

For compatibility with kernels that pre-date the introduction of DebugSwap,
as well as with those where KVM_SEV_ES_INIT will never enable it, do not enable
the feature by default.  If anybody wants to use it, for now they can enable
the sev_es_debug_swap_enabled module parameter, but this will result in a
warning.

Fixes: d1f85fbe836e ("KVM: SEV: Enable data breakpoints in SEV-ES")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c31f8..69b37956c1c8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,7 +57,7 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
-static bool sev_es_debug_swap_enabled = true;
+static bool sev_es_debug_swap_enabled = false;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 #else
 #define sev_enabled false
@@ -612,8 +612,11 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_es_debug_swap_enabled)
+	if (sev_es_debug_swap_enabled) {
 		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+		pr_warn_once("Enabling DebugSwap with KVM_SEV_ES_INIT. "
+			     "This will not work starting with Linux 6.10\n");
+	}
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
-- 
2.39.1


