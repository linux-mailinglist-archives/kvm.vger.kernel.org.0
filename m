Return-Path: <kvm+bounces-1322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E237E69FE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63BAE2816C1
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E631DDC0;
	Thu,  9 Nov 2023 11:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dtGaOoL0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FAA1DA41
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:56:35 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B72D78;
	Thu,  9 Nov 2023 03:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699530995; x=1731066995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oSJ+WCISblOmP/KSjvUJCPXd3quC4qZ4W+Luwy1KEDQ=;
  b=dtGaOoL0K+EwJmJiZRgFVIqfzRJDgDGYVAD/lR7HlL2awyk/SV9p0blb
   LeDrL4BtT9UgI/Ad15g5o863jMxu8HPHYWlyqzhqaYye05UPqH4akh3BG
   G1trDvUwxqE9eEDWmdZxLZj+6dWaaWZk7OF3Jc28pKFnK5YP+7x8Q5RhG
   pHEEtS32K+4oANkjWEp7/VKvv+lz1wIO2wPqSLKx+wcIFALJjvYKIgA8y
   kQvSOfKoEJzNasTD0Myfc28GetFWsct6lQuh2vABIyLPHqQmTJGw2cgtn
   C1G/b2WhflDMmu7A8kWjKHzC8r80eLUPTeTHMOEbVhh9jJj66/7lgOmrb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936312"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936312"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976617"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976617"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:28 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 03/23] x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
Date: Fri, 10 Nov 2023 00:55:40 +1300
Message-ID: <a829d4e801896b019423b092d360a2e0fbc35f17.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX capable platforms are locked to X2APIC mode and cannot fall back to
the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.

Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3762f41bb092..eb6e63956d51 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1970,6 +1970,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	depends on X86_X2APIC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
-- 
2.41.0


