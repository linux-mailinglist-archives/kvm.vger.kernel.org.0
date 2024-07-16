Return-Path: <kvm+bounces-21718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC8F932C6E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 077471C2205A
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16CF19E7FE;
	Tue, 16 Jul 2024 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jd0gNmc6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543FB19DF75
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145312; cv=none; b=g83WQ1b1a5oqaBkzLHtFbUVcUvaVMg2HLgBcCy68SPx8Is0fxOwKUklWjlct8Dy3kKE1iXQA/ktDJMnEgDFmWRZ8i9nw6cXTLdllx6qCUZMhVSd+K90o5W+gyE0eJ6S9SFJxB7vGaXhifbeEI1YD43Vkn7xIjP74ciJdGnTx5c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145312; c=relaxed/simple;
	bh=ORQtPOUjRaH7fq192/3Uf+CcJuvKVSUruZo9xOxKbJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F1uhqF2ppVjOfN2TgAjFJouTiITJ4Cc/ovCieHDQYdO+1AS2EdqqA5RLNmIDWltBgHyXfKuU4ntn3nADE1yXyXbAIH4shengPoYQQ0haAK5Zb4qRJz8M1cR6bZP1w6Eue5f34EmCVp2F5feCXZz8ldeHk/w8tpXIhjMriGJZA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jd0gNmc6; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145311; x=1752681311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ORQtPOUjRaH7fq192/3Uf+CcJuvKVSUruZo9xOxKbJw=;
  b=jd0gNmc6thXQ3tRGZLm3/sScykyiVCPCXI0wI0FV59Os/5mC9zPiIjLd
   7EgSvd866PDoIXPI8/lOqF9Z7LrJpUmRUvwoApGcvPq/u1P0/UPj+84fS
   9msQD0/r58ZhgkpJDTYcTr7yQe/UKY86jfpeV1s5oQIMKpoiz+tCFcBVw
   IaPBfY3OWkyomT7QFhWr5/sHu1Z6fA2tossOnKtHUJdXDOnvR5W+E3J39
   SUZHzQBhGvaOobhqiLIsUSDflZT2UzJTNfWUm+76onjPl8wOZD7wafiwL
   djHEu9ocVKrLfUSnJoph1X1Wbal4zxgGJpFsjikIXbi8lC/RyBM/Jchk0
   w==;
X-CSE-ConnectionGUID: zTnlvaEASWm+FHJ0smmsRw==
X-CSE-MsgGUID: jwzV+3oUSGWtfSvz1L+kMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743700"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743700"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:54:52 -0700
X-CSE-ConnectionGUID: sX48Ry9oS9a3ksiDhRNKcg==
X-CSE-MsgGUID: IzrrmODeTFCDv39AExZSaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788277"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:54:49 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 2/9] target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and MSR_KVM_SYSTEM_TIME definitions
Date: Wed, 17 Jul 2024 00:10:08 +0800
Message-Id: <20240716161015.263031-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716161015.263031-1-zhao1.liu@intel.com>
References: <20240716161015.263031-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These 2 MSRs have been already defined in kvm_para.h (standard-headers/
asm-x86/kvm_para.h).

Remove QEMU local definitions to avoid duplication.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 86e42beb78bf..6ad5a7dbf1fd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -81,9 +81,6 @@
 #define KVM_APIC_BUS_CYCLE_NS       1
 #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
 
-#define MSR_KVM_WALL_CLOCK  0x11
-#define MSR_KVM_SYSTEM_TIME 0x12
-
 /* A 4096-byte buffer can hold the 8-byte kvm_msrs header, plus
  * 255 kvm_msr_entry structs */
 #define MSR_BUF_SIZE 4096
-- 
2.34.1


