Return-Path: <kvm+bounces-39330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C93A4695D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:18:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43ADD1883E50
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD4224290C;
	Wed, 26 Feb 2025 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IaDvjip/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06074239587
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593724; cv=none; b=groz7x19+b4dvOdb5i8BIQ8yGT8rd6+8eALUV83SW1BZwkH7guC51BcRFUKsDb/RGqzmpq2LNZOYqsISUtbxvHRT68cxI89u64ebx4Qll8Bh+YGyP/tZPG3K3Oly6FRe6OF6qZ3QskdkF5Z89N4MhnZm81lpA1kiBThh3meA5fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593724; c=relaxed/simple;
	bh=v0subQ8MusqLwWWiq2Tvid+nk8131GR+ABVVYMabaMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXC+LJTXhZ5swh0bAL8SA2dtZoYvSd6khCS+CDzv4eb84ndJTrio/Qg/1XPcv9wLF6diZyvV1mWlfZ5J4i8Fw2TArzh69lUoqh7n5qmK8wnJclFX3Lvy6NbizJw6vpp8Pyl1MFrFMXgaM1qANVNGM3MkR9IRAilJ9GYvSPvKt6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IaDvjip/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+51pmgeX3nMzZAL2+xNl9GnVCY4okqQgdOCTryeUlqk=;
	b=IaDvjip/CdxmbwxdQI96IRhnS8f0noFZvg5xMClEIBtbH71aB7IOT9QCxWjzFYFM3Gohq6
	6Gatea0jl1MQPSFFx1WaNkoMi0V89CmTwcJ39bShGV8IXUCeUqYyIPMdMWoU9vxpPyCz4F
	KACycFLweyI//PXMoMsqT2VkooKA1YY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-qn1WYz4nMvigFoMVJSfzZw-1; Wed,
 26 Feb 2025 13:15:20 -0500
X-MC-Unique: qn1WYz4nMvigFoMVJSfzZw-1
X-Mimecast-MFC-AGG-ID: qn1WYz4nMvigFoMVJSfzZw_1740593719
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 672E318D95F1;
	Wed, 26 Feb 2025 18:15:19 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5194C1955BD4;
	Wed, 26 Feb 2025 18:15:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 16/33] KVM: TDX: Get TDX global information
Date: Wed, 26 Feb 2025 13:14:35 -0500
Message-ID: <20250226181453.2311849-17-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
index 3c089ed3b843..b74a50e8d086 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,6 +13,8 @@ module_param_named(tdx, enable_tdx, bool, 0444);
 
 static enum cpuhp_state tdx_cpuhp_state;
 
+static const struct tdx_sys_info *tdx_sysinfo;
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
@@ -92,11 +94,20 @@ static int __init __tdx_bringup(void)
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
+	__tdx_cleanup();
 tdx_bringup_err:
 	kvm_disable_virtualization();
 	return r;
-- 
2.43.5



