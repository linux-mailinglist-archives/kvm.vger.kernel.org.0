Return-Path: <kvm+bounces-4674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C789816712
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39CE2284634
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D1B101C2;
	Mon, 18 Dec 2023 07:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMm7acx+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24CF9D1
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883432; x=1734419432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iuHNTyl3V46owvCvN2t2hQRk6lPnus3k5IM1uUR0ujU=;
  b=bMm7acx+35W15F1qT58HZTrLf75+PN7JsYj3QPwsGw/9BQymZiOlske6
   txoUV69GrenXq3xXMLPHZxJ5SKud+2f4RK+cORv/635IUXDFki9SUUZ9p
   +b1EQVNokC2txvafuwBthX1cYfG9S3W67MqgH+t9Kq9luYFsMLVEBWz1X
   GCsarYtuyTmnI+c81ep4VIGTD99aWUXdT95zcBsv6tPJ4J2FR0lzId9iX
   OaWbDuOLt+yDJ2/18ijm8l2NgQiiSTNzA11WssburIXOp2lzyD3BHkDMQ
   DCKGaoXP6aeL2nZLvu+IAnqdTrwXivIW7YfZGoWIH5dkzAMMc/5ZCNF4p
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667889"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667889"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824702"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824702"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:28 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 08/18] x86 TDX: Extend EFI run script to support TDX
Date: Mon, 18 Dec 2023 15:22:37 +0800
Message-Id: <20231218072247.2573516-9-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Currently TDX framework is based on EFI support and running test case in
TDX environment requires special QEMU command line parameters.

Add an environment variable EFI_TDX. When set, enable test case to run
in TDX protected environment with special QEMU parameters.

Force "-cpu host" to be the last parameter as qemu doesn't support to
customize CPU feature for TD guest currently.

Using "-bios" to load TDVF (OVMF with TDX support).

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-8-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 x86/efi/README.md |  6 ++++++
 x86/efi/run       | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/x86/efi/README.md b/x86/efi/README.md
index aa1dbcdd..494f3888 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -30,6 +30,12 @@ the env variable `EFI_UEFI`:
 
     EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
 
+### Run test cases with UEFI in TDX environment
+
+To run a test case with UEFI and TDX enabled:
+
+    EFI_TDX=y ./x86/efi/run ./x86/msr.efi
+
 ## Code structure
 
 ### Code from GNU-EFI
diff --git a/x86/efi/run b/x86/efi/run
index 85aeb94f..08512b08 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -18,6 +18,7 @@ source config.mak
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_SMP:=1}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_TDX:=n}"
 
 if [ ! -f "$EFI_UEFI" ]; then
 	echo "UEFI firmware not found: $EFI_UEFI"
@@ -29,6 +30,24 @@ fi
 # Remove the TEST_CASE from $@
 shift 1
 
+# TDX support -kernel QEMU parameter, could utilize the original way of
+# verifying QEMU's configuration. CPU feature customization isn't supported
+# in TDX currently, so pass through all the features with `-cpu host`
+if [ "$EFI_TDX" == "y" ]; then
+	"$TEST_DIR/run" \
+	-bios "$EFI_UEFI" \
+	-object tdx-guest,id=tdx0 \
+	-machine q35,kernel_irqchip=split,confidential-guest-support=tdx0 \
+	-kernel "$EFI_SRC/$EFI_CASE.efi" \
+	-net none \
+	-nographic \
+	-m 256 \
+	"$@" \
+	-cpu host
+
+	exit $?
+fi
+
 if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	EFI_CASE=dummy
 fi
-- 
2.25.1


