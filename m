Return-Path: <kvm+bounces-38737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAFDA3E1DD
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60E267A1B29
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A45215779;
	Thu, 20 Feb 2025 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AD5Jq7vJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2E215193
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071192; cv=none; b=HnM15ZWw/uPYSpTo6uyJLwKmzwDfM1NvGzFiiHEHo/G55So6YVIiL6sBAz4KAxxb2Od6nI0daaDZrLEfp0As4snHPl6UN78czAVNnH5LjD0X7IW3xfCGdGOfBqyBfV50LHxx331tsGfZpz2G455Q4u1l4k505TfeIlfSB1Oj70A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071192; c=relaxed/simple;
	bh=pGjkwu74Qac4zZwnPOH9vIK6+RLhm4IV0FQFk3WoURc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7Ubvx72hJcoQzNPPXou1gzhZlVk39So7e8dJJoYuse5EZhIE5sae5b6cGJGKhKo//wN/3+dxk53O27UD1FSlP0pkORsT9vBjS4oIo3yXpkZUfFXb25S7bENFW1jdADR9VMUDhVqk+8oHQsIDDxWuIFr/bTAnPTm5Ur+RgaBAQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AD5Jq7vJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8f7EzK9RxrNnHIDCrt2FIGl1J5d6f6j5FQ75ZzYv2x8=;
	b=AD5Jq7vJKRi0NF0qNiU0s4FstIKc3K6/RerNrCubm8EiZjWVHnnm+sa60IYg14l02MyUdK
	0lqvBGWMGbeL994U0keAhfDstfY7/k4/i4WmvOpqid88Y95LvmvBJSsxOugTHOPp319KuF
	i2XU4v65PbQyrO55ZbK5Bs4plSCH/PA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-23NEXoZHOlSZ-7fkiuoUGA-1; Thu,
 20 Feb 2025 12:06:27 -0500
X-MC-Unique: 23NEXoZHOlSZ-7fkiuoUGA-1
X-Mimecast-MFC-AGG-ID: 23NEXoZHOlSZ-7fkiuoUGA_1740071186
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 979E81800992;
	Thu, 20 Feb 2025 17:06:26 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A3D3A1800359;
	Thu, 20 Feb 2025 17:06:25 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 13/30] KVM: TDX: Get TDX global information
Date: Thu, 20 Feb 2025 12:05:47 -0500
Message-ID: <20250220170604.2279312-14-pbonzini@redhat.com>
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

From: Kai Huang <kai.huang@intel.com>

KVM will need to consult some essential TDX global information to create
and run TDX guests.  Get the global information after initializing TDX.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20241030190039.77971-3-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0666dfbe0bc0..761d3a9cd5c5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,6 +13,8 @@ module_param_named(tdx, enable_tdx, bool, 0444);
 
 static enum cpuhp_state tdx_cpuhp_state;
 
+static const struct tdx_sys_info *tdx_sysinfo;
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
@@ -90,11 +92,20 @@ static int __init __tdx_bringup(void)
 	if (r)
 		goto tdx_bringup_err;
 
+	/* Get TDX global information for later use */
+	tdx_sysinfo = tdx_get_sysinfo();
+	if (WARN_ON_ONCE(!tdx_sysinfo)) {
+		r = -EINVAL;
+		goto get_sysinfo_err;
+	}
+
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
 	 */
 	return 0;
+get_sysinfo_err:
+	__do_tdx_cleanup();
 tdx_bringup_err:
 	kvm_disable_virtualization();
 	return r;
-- 
2.43.5



