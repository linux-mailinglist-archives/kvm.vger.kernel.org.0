Return-Path: <kvm+bounces-71096-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AAs1JKbQj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71096-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:32:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F392A13AB2E
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D326431168EF
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B9429B233;
	Sat, 14 Feb 2026 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u3jchCRW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0F22F5A10
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032457; cv=none; b=q5Z0yl9PQPAABDyheNmAYGiSBB6qO6PaM/CmDL/fn3+zPSNt2FuuNA7eR0pkbTxWpLDXhyJdG5N/OidNhtGDRvGi5M2q8HDDh4+OTwC7iNOtnsDjOIX791D/xGAJC0n8ajbSgjDmp9b6FX4zCn4rEvli6PoKwOXxRaP4bjxZK/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032457; c=relaxed/simple;
	bh=s3lzO/bXszH5OMIQQtWSrd06VzARWtW4CDEP6dETZYo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SuJ7kY9nUrMWAvJIiRVdFpOeeUIpnlM6mREfvMSbqsbr8x2OZvWwXmgvuJOnrhn8uI0XEeMgXbVAeQoWx3f58hTsavRnYG1YtihLvGXfCh9V6Ozin81tupg2Xf+IOwXy0tdVtiBPPxnS5nRMYannW8x3j+RdCk6vAjHaHxGMHMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u3jchCRW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7a98ba326so20428135ad.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032455; x=1771637255; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bpLFx/BKr4BaXcZ20UtDSNr2VDzmqXClfDpQcpkuB30=;
        b=u3jchCRWSjlhw4SO8ogo0t9LqP4/TSEeWmQq2iV5VmviyERvFTEdMmaBGMXzB4B+EG
         F7ijZ+dlCl6VNQ9rHIXEFS1plCtRX6edTH6h/7SopPg1FrwKthgionnx4l1IsP3X+2jd
         Cm21j1Vi+Zv1rRDgE94V7WCmZql5mkUXdJ4tSu1FSdTwTeEXgXqAH2lDa89sS1MFuZNS
         zjf/izj8IxYVzLhWPuLhehKjyairXYuHfrgwRyh6pOKWq1oC4/oh/oibm70ojAqwB6AJ
         WQJB2LZnKo0haAR4NgBIzZwYsRBkDnMlIzRqN/Qe7OY1j37HslYn3X9YVOU4ETy/xorZ
         rNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032455; x=1771637255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bpLFx/BKr4BaXcZ20UtDSNr2VDzmqXClfDpQcpkuB30=;
        b=d9R8o7X2YoFWKqAGOCgMhtGdj7ir8wEVp3aeCFH5enLxyJN+bsUCqxzy+krInImUIM
         HB+LMYd+ZizQ4/vkLqJ9Tg+6tEgOhnoN2QfS1s0D9hoJvC64ofSj8bL06PKigqDMQqx+
         iH0qDZTyZBKdnUCB3ue+xctzf4ccDXJ+uf3/XmDi8r9fYX+4ESElSK3gabIldVdSAzBf
         mFIE3G0ui1W5/LqpcvfCxyUsTebjDrx1b+1t/qmTvndiQx5pIFGbIHrnj8/jeTw9o7sf
         KDCofnvaSXZYxVVsAV6qQpGtjGjc8Lsn6f+nPG9p2vz1VKpznNAnVXTCYOHabbFV5muA
         b5yw==
X-Forwarded-Encrypted: i=1; AJvYcCWh8PYOpZYz2XK/XFZE1uCvvrHk5tv8H0D8tw1MmHTbtwB40xvMVYOPcTWYU0QkZT+Or2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDrGvkd6pEPQV0ATPCOKxQ4wgSFv0x3ElSWfX2nFd5GxCdd14J
	YnPwMej8drQ+Lany7jyV9gVNnoKl7aW0I8QATJTE06WraiiSUQ0XFpVlKBL8+JyFknCbRCEK1UP
	TcvbKpA==
X-Received: from plrt19.prod.google.com ([2002:a17:902:b213:b0:2aa:d3a6:c339])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:984:b0:2aa:e4f2:f076
 with SMTP id d9443c01a7336-2ac974316f2mr20540065ad.8.1771032454516; Fri, 13
 Feb 2026 17:27:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:27:02 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-17-seanjc@google.com>
Subject: [PATCH v3 16/16] KVM: TDX: Fold tdx_bringup() into tdx_hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71096-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: F392A13AB2E
X-Rspamd-Action: no action

Now that TDX doesn't need to manually enable virtualization through _KVM_
APIs during setup, fold tdx_bringup() into tdx_hardware_setup() where the
code belongs, e.g. so that KVM doesn't leave the S-EPT kvm_x86_ops wired
up when TDX is disabled.

The weird ordering (and naming) was necessary to allow KVM TDX to use
kvm_enable_virtualization(), which in turn had a hard dependency on
kvm_x86_ops.enable_virtualization_cpu and thus kvm_x86_vendor_init().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/main.c | 19 ++++++++-----------
 arch/x86/kvm/vmx/tdx.c  | 39 +++++++++++++++------------------------
 arch/x86/kvm/vmx/tdx.h  |  8 ++------
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a46ccd670785..dbebddf648be 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -29,10 +29,15 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
+	return enable_tdx ? tdx_hardware_setup() : 0;
+}
+
+static void vt_hardware_unsetup(void)
+{
 	if (enable_tdx)
-		tdx_hardware_setup();
+		tdx_hardware_unsetup();
 
-	return 0;
+	vmx_hardware_unsetup();
 }
 
 static int vt_vm_init(struct kvm *kvm)
@@ -869,7 +874,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.check_processor_compatibility = vmx_check_processor_compat,
 
-	.hardware_unsetup = vmx_hardware_unsetup,
+	.hardware_unsetup = vt_op(hardware_unsetup),
 
 	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
 	.disable_virtualization_cpu = vt_op(disable_virtualization_cpu),
@@ -1029,7 +1034,6 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 static void __exit vt_exit(void)
 {
 	kvm_exit();
-	tdx_cleanup();
 	vmx_exit();
 }
 module_exit(vt_exit);
@@ -1043,11 +1047,6 @@ static int __init vt_init(void)
 	if (r)
 		return r;
 
-	/* tdx_init() has been taken */
-	r = tdx_bringup();
-	if (r)
-		goto err_tdx_bringup;
-
 	/*
 	 * TDX and VMX have different vCPU structures.  Calculate the
 	 * maximum size/align so that kvm_init() can use the larger
@@ -1074,8 +1073,6 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
-	tdx_cleanup();
-err_tdx_bringup:
 	vmx_exit();
 	return r;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fea3dfc7ac8b..d354022ba9c9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3285,7 +3285,12 @@ int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 	return PG_LEVEL_4K;
 }
 
-static int __init __tdx_bringup(void)
+void tdx_hardware_unsetup(void)
+{
+	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
+}
+
+static int __init __tdx_hardware_setup(void)
 {
 	const struct tdx_sys_info_td_conf *td_conf;
 	int i;
@@ -3359,7 +3364,7 @@ static int __init __tdx_bringup(void)
 	return 0;
 }
 
-int __init tdx_bringup(void)
+int __init tdx_hardware_setup(void)
 {
 	int r, i;
 
@@ -3395,7 +3400,7 @@ int __init tdx_bringup(void)
 		goto success_disable_tdx;
 	}
 
-	r = __tdx_bringup();
+	r = __tdx_hardware_setup();
 	if (r) {
 		/*
 		 * Disable TDX only but don't fail to load module if the TDX
@@ -3409,31 +3414,12 @@ int __init tdx_bringup(void)
 		 */
 		if (r == -ENODEV)
 			goto success_disable_tdx;
+
+		return r;
 	}
 
-	return r;
-
-success_disable_tdx:
-	enable_tdx = 0;
-	return 0;
-}
-
-void tdx_cleanup(void)
-{
-	if (!enable_tdx)
-		return;
-
-	misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
-}
-
-void __init tdx_hardware_setup(void)
-{
 	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);
 
-	/*
-	 * Note, if the TDX module can't be loaded, KVM TDX support will be
-	 * disabled but KVM will continue loading (see tdx_bringup()).
-	 */
 	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
 
 	vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
@@ -3441,4 +3427,9 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
 	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
+	return 0;
+
+success_disable_tdx:
+	enable_tdx = 0;
+	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 45b5183ccb36..b5cd2ffb303e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -8,9 +8,8 @@
 #ifdef CONFIG_KVM_INTEL_TDX
 #include "common.h"
 
-void tdx_hardware_setup(void);
-int tdx_bringup(void);
-void tdx_cleanup(void);
+int tdx_hardware_setup(void);
+void tdx_hardware_unsetup(void);
 
 extern bool enable_tdx;
 
@@ -187,9 +186,6 @@ TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
 TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
 
 #else
-static inline int tdx_bringup(void) { return 0; }
-static inline void tdx_cleanup(void) {}
-
 #define enable_tdx	0
 
 struct kvm_tdx {
-- 
2.53.0.310.g728cabbaf7-goog


