Return-Path: <kvm+bounces-45929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E63C5AAFE86
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E8F3188DC0B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09902284674;
	Thu,  8 May 2025 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQtrLIcl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCF3284667
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716777; cv=none; b=DQXdmwQkSmptUMyPIcihcSLK5yutB4t4OW5vhZD/H8oXDw+bXzHo8SImoI42sR2Bhy281dk7R0YsIg/acaTkRsE6bkQXMpxXRimZgdtJY+k1tHE8mHvMMR9F149DB/nJKmSui6OZT6xKgvTHAED1PhCtt/EZljbf/ip/ZyWiyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716777; c=relaxed/simple;
	bh=pIWAPu28XGKIr7qPx6xnPgm+joe07aUW8TauRVAgp7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asaP8LELYK8AQr9dXT1zCaUI0l3vEpbAmEMDvEa6UNdro7PZUXImufV8hzGuhZmzLE67ba19UI89OGQ2ViIa1XHv3+NcWuJY+PDwkYy7KIF1vjtyHB7GaH/LTorI1MyeojDV75zze5ym46IAEyfSF5TnSNiyE85trvBoO/1a8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQtrLIcl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716776; x=1778252776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pIWAPu28XGKIr7qPx6xnPgm+joe07aUW8TauRVAgp7g=;
  b=fQtrLIclYmTSMPkteyyyl7rF5ui0AO9bfqohW2+G/Y0qkRGt442Mfg1C
   AaKIQzGhMh+DSz5e43zrzRjilLWXLhPP/XT+HFRKIIgJau+f0AeOD0FHL
   ZfgERHQHBp+JTq+alams1c5p3mOebCH9KfHAlLOsz5ddSn0SPen6QcgCY
   e6yhIszVMN3CKjhwQ03NElzMKNqVA1s/BByPc4mMXzq0chIeGMHUumFHd
   NiDism2YNUpLaSpnl48W7bNSChVY0IqwTrV8ULyEklD6JPd8IH+NK8HI5
   bshAVgAGdqR4hyVTAPmuZWL4niPaDnXcdaNQO01jESwVxfNZ6c3oUEagI
   A==;
X-CSE-ConnectionGUID: jsq1a9IKSGK6HLNcuypCdg==
X-CSE-MsgGUID: ko9npKoYTEG6w52NXhb0LQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888209"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888209"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:15 -0700
X-CSE-ConnectionGUID: fexHkJ1pQOWpS7fH0Xl8zQ==
X-CSE-MsgGUID: Bg36XUWRRn6puNEh9shJyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440058"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:13 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 26/55] i386/tdx: Finalize TDX VM
Date: Thu,  8 May 2025 10:59:32 -0400
Message-ID: <20250508150002.689633-27-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Invoke KVM_TDX_FINALIZE_VM to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 31b288382fc8..b0ee50d76208 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -360,6 +360,9 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
      */
     ram_block = tdx_guest->tdvf_mr->ram_block;
     ram_block_discard_range(ram_block, 0, ram_block->max_length);
+
+    tdx_vm_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL, &error_fatal);
+    CONFIDENTIAL_GUEST_SUPPORT(tdx_guest)->ready = true;
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.43.0


