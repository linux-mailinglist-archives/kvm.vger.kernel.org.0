Return-Path: <kvm+bounces-35569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE2FA12849
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5BE4163286
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38721D5CC5;
	Wed, 15 Jan 2025 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="go+yHQO4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1E41C3BF0
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957374; cv=none; b=I6/Cx1C5LbBOwkAA6RSYa+JpKx5y1BDIzP49IyKf87JUeTJGRVXnGZVi5zpPAu4OE2gsjHzgxgpm5MjDCMCg4Fp+oe7gDbtTE/x4sAw8nFd7IrmbJRtDjPFl3CtNGYTINLZOuuojgXZdlcMRgi7//94WI2vgLo/CgSINvF+eANs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957374; c=relaxed/simple;
	bh=1DL6FRVWxCyRXBSiFeQyW/sKzvOUFL7Mwdmicb7YrBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbRYmpioOVxFPbHPFrV/RdOqAfh/X+LKVOiR4J4YHGn8w7Ic6vxXGm18fFJrQCLt1lIHmyD+QFJUc1iwefrJOTRfrXAfpbohFVznNc6/44Yt+cUwWQ2xM0gh74cyfn2apqgYQnwxROT3Q0mqPNalTPk7vjjNAXIm2avk1JS6xNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=go+yHQO4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736957371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hQqALrHAf7Fm/dLy6ELQQ47uQ13gI5dmb8FS7CIq3R0=;
	b=go+yHQO4b+hdZsjsWA+3QmXg1iGvKbimysHw8NXabDJsCIFRrMFC4G/1RYeJowoBGsmcLV
	AqpP2XMX41iiLG9FSJPGyntrwDY2QxsQjA7+CFgMqxLAUr4PCRHlsBd3Zu5jO27rLmIOzu
	mjFPPREa3Y1Hf9DkOHsgWyRQKNxte+s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-laVIsZqAOombEeM8un0UGg-1; Wed,
 15 Jan 2025 11:09:26 -0500
X-MC-Unique: laVIsZqAOombEeM8un0UGg-1
X-Mimecast-MFC-AGG-ID: laVIsZqAOombEeM8un0UGg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48B1E1956050;
	Wed, 15 Jan 2025 16:09:25 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B1A8E30001BE;
	Wed, 15 Jan 2025 16:09:23 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v3 06/14] x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
Date: Wed, 15 Jan 2025 11:09:04 -0500
Message-ID: <20250115160912.617654-7-pbonzini@redhat.com>
In-Reply-To: <20250115160912.617654-1-pbonzini@redhat.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. The TDX module has the concept of flushing vCPUs. These flushes
include both a flush of the translation caches and also any other state
internal to the TDX module. Before freeing a KeyID, this flush operation
needs to be done. KVM will need to perform the flush on each pCPU
associated with the TD, and also perform a TD scoped operation that checks
if the flush has been done on all vCPU's associated with the TD.

Add a tdh_vp_flush() function to be used to call TDH.VP.FLUSH on each pCPU
associated with the TD during TD teardown. It will also be called when
disabling TDX and during vCPU migration between pCPUs.

Add tdh_mng_vpflushdone() to be used by KVM to call TDH.MNG.VPFLUSHDONE.
KVM will use this during TD teardown to verify that TDH.VP.FLUSH has been
called sufficiently, and advance the state machine that will allow for
reclaiming the TD's KeyID.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-ID: <20241203010317.827803-7-rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0a5ecda98713..1d84cf8e2abe 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -156,6 +156,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_vp_flush(struct tdx_vp *vp);
+u64 tdh_mng_vpflushdone(struct tdx_td *td);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 387fec057bd3..83fc01bfd55d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1554,6 +1554,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_vp_flush(struct tdx_vp *vp)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdvpr_pa(vp),
+	};
+
+	return seamcall(TDH_VP_FLUSH, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_flush);
+
+u64 tdh_mng_vpflushdone(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+	};
+
+	return seamcall(TDH_MNG_VPFLUSHDONE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_vpflushdone);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index aacd38b12989..62cb7832c42d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -20,6 +20,8 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
+#define TDH_VP_FLUSH			18
+#define TDH_MNG_VPFLUSHDONE		19
 #define TDH_VP_CREATE			10
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
-- 
2.43.5



