Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E84CB7C7
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiCCH3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiCCH2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:41 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24B72DCC
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292458; x=1677828458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=efl/khJDj+x8rvRDLcUl9AoBWzvRZc0qmgZJdcK4ATM=;
  b=R98TA6d819IL5RdCHnuqDbTML+oS+T+407/1R1A0BtX2TljALsj13m9+
   IZzgrYHynS9sQg7CFE3NN7m/SoH55exnnpfr9CGVWke8O9wJqDbg5p1H5
   VkL2FRBsXqLB+MhJPcZDAu8yEAUaA9IzlHgy/jKY6trCg8S+ejh2gTWZl
   A68GysHZ1s/EYkOiEXWaJpuGZqep9xZbkyizaZptW/nK8U4HEpQArcAtt
   /AsEZOWJrEiCxuLq8Ri0Oozj61WchAXdfCXpDyIzQ7CE541uSe/s1N6ik
   MVqtIJcNERJnjxvVZUgNcDLuGsGfN3khYnoJeMfAOAY2pCN0wwAcqImJM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176971"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176971"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631609"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:33 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 07/17] x86 TDX: Extend EFI run script to support TDX
Date:   Thu,  3 Mar 2022 15:18:57 +0800
Message-Id: <20220303071907.650203-8-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently TDX framework is based on EFI support and running test case
in TDX environment requires special QEMU command line parameters.

Add an environment variable EFI_TDX. When set, enable test case to
run in TDX protected environment with special QEMU parameters.

Force "-cpu host" to be the last parameter as qemu doesn't support
to customize CPU feature for TD guest currently.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 x86/efi/README.md |  6 ++++++
 x86/efi/run       | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/x86/efi/README.md b/x86/efi/README.md
index a39f509cd9aa..b6f1fc68b0f3 100644
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
index ac368a59ba9f..2af0a303ea0e 100755
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
+	-device loader,file="$EFI_UEFI",id=fd0 \
+	-object tdx-guest,id=tdx0 \
+	-machine q35,kvm-type=tdx,pic=no,kernel_irqchip=split,confidential-guest-support=tdx0 \
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

