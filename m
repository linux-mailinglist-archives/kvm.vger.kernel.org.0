Return-Path: <kvm+bounces-39325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F67A4694F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAAD9188DCF7
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CFB23A9A5;
	Wed, 26 Feb 2025 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOzvwY6x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1859B23906A
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593719; cv=none; b=QzCssr6eLcSJQvdxXHcT1MinKZ6iFrGjFUJ1BQ0NiMx0b3//KCFxvIsfXCiY6c1w6njk2sQlrsb6qi2qOo2EW7UdDnFTrZbDmdK47M2Jd1L+HGb5KViFVYVz30LySBKgxoUCavTqvBoFC3V170qrDWOOE0G7azrHDjcYvSrzsxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593719; c=relaxed/simple;
	bh=O9ZzyfOn0JOlkxPGIrSAM2lvehpQC23fCK92ThFUqH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDOF1rbGSAt+84hrAdEUNvvvpCMa0B713hAS9FQBYRubLOkLKOzLgNU+UoInbTIWEXL5iWGg2OGI/8ifP5WERjgHvxJ1L8R2dc5za/6Z+cTQW2DFezuMx6il9DYXM5try8em5V6gWIMdbtHklpLBGZV0ze9fwHrsPcG2TVXjS20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOzvwY6x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAWo7r+0FJM6VF1NEs5BudGty7K5q5afVeOpseAOVUM=;
	b=hOzvwY6xezgmcCOylXgCOXsq2UB2Nmo021iDSBLFz7LdX1wtO4lbwHABzaIXqiqDPxenge
	JBFjlFsEaUVaTjPXvuNZdCf5w1LaQAqjxGoRnD2U421GqMRYqbaekR1YzXGnf66r1Rem1r
	Io7PMOR7dcTF0i+QRNhVv/IBqzG/sUI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-Yvt70WBhM6iThZxb3VLzhg-1; Wed,
 26 Feb 2025 13:15:13 -0500
X-MC-Unique: Yvt70WBhM6iThZxb3VLzhg-1
X-Mimecast-MFC-AGG-ID: Yvt70WBhM6iThZxb3VLzhg_1740593712
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0332E1903092;
	Wed, 26 Feb 2025 18:15:12 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08EE31955BD4;
	Wed, 26 Feb 2025 18:15:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 10/33] x86/virt/tdx: allocate tdx_sys_info in static memory
Date: Wed, 26 Feb 2025 13:14:29 -0500
Message-ID: <20250226181453.2311849-11-pbonzini@redhat.com>
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

Adding all the information that KVM needs increases the size of struct
tdx_sys_info, to the point that you can get warnings about the stack
size of init_tdx_module().  Since KVM also needs to read the TDX metadata
after init_tdx_module() returns, make the variable a global.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 369b264f4d9b..578ad468634b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -53,6 +53,8 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+static struct tdx_sys_info tdx_sysinfo;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -1061,15 +1063,14 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdx_sys_info sysinfo;
 	int ret;
 
-	ret = get_tdx_sys_info(&sysinfo);
+	ret = get_tdx_sys_info(&tdx_sysinfo);
 	if (ret)
 		return ret;
 
 	/* Check whether the kernel can support this module */
-	ret = check_features(&sysinfo);
+	ret = check_features(&tdx_sysinfo);
 	if (ret)
 		return ret;
 
@@ -1090,12 +1091,12 @@ static int init_tdx_module(void)
 		goto out_put_tdxmem;
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
 	if (ret)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdx_sysinfo.tdmr);
 	if (ret)
 		goto err_free_tdmrs;
 
-- 
2.43.5



